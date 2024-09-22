--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.21
-- Dumped by pg_dump version 9.5.21

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: actor_award; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actor_award (
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    description character varying(100) NOT NULL,
    award_name character varying(40) NOT NULL,
    year_of_award integer NOT NULL,
    category character varying(100) NOT NULL,
    result character varying(20)
);


ALTER TABLE public.actor_award OWNER TO postgres;

--
-- Name: appearance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appearance (
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    description character varying(100) NOT NULL,
    scene_no integer NOT NULL
);


ALTER TABLE public.appearance OWNER TO postgres;

--
-- Name: award; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.award (
    award_name character varying(40) NOT NULL,
    institution character varying(50) NOT NULL,
    country character varying(20) NOT NULL
);


ALTER TABLE public.award OWNER TO postgres;

--
-- Name: crew; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crew (
    id character(8) NOT NULL,
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    contribution character varying(30)
);


ALTER TABLE public.crew OWNER TO postgres;

--
-- Name: crew_award; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crew_award (
    id character(8) NOT NULL,
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    award_name character varying(40) NOT NULL,
    year_of_award integer NOT NULL,
    category character varying(100) NOT NULL,
    result character varying(20)
);


ALTER TABLE public.crew_award OWNER TO postgres;

--
-- Name: director; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.director (
    id character(8) NOT NULL,
    title character varying(40) NOT NULL,
    production_year integer NOT NULL
);


ALTER TABLE public.director OWNER TO postgres;

--
-- Name: director_award; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.director_award (
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    award_name character varying(40) NOT NULL,
    year_of_award integer NOT NULL,
    category character varying(100) NOT NULL,
    result character varying(20)
);


ALTER TABLE public.director_award OWNER TO postgres;

--
-- Name: movie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie (
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    country character varying(20) NOT NULL,
    run_time integer NOT NULL,
    major_genre character varying(15)
);


ALTER TABLE public.movie OWNER TO postgres;

--
-- Name: movie_award; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_award (
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    award_name character varying(40) NOT NULL,
    year_of_award integer NOT NULL,
    category character varying(100) NOT NULL,
    result character varying(20)
);


ALTER TABLE public.movie_award OWNER TO postgres;

--
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    id character(8) NOT NULL,
    first_name character varying(15) NOT NULL,
    last_name character varying(30) NOT NULL,
    year_born integer
);


ALTER TABLE public.person OWNER TO postgres;

--
-- Name: winners_id_age; Type: VIEW; Schema: public; Owner: comp2400
--

CREATE VIEW public.winners_id_age AS
 SELECT c.id,
    (ca.year_of_award - p.year_born) AS age
   FROM ((public.crew c
     JOIN public.crew_award ca USING (id, title, production_year))
     JOIN public.person p USING (id))
  WHERE ((ca.result)::text = 'won'::text);


ALTER TABLE public.winners_id_age OWNER TO comp2400;

--
-- Name: multiple_ages; Type: VIEW; Schema: public; Owner: comp2400
--

CREATE VIEW public.multiple_ages AS
 SELECT w.id,
    w.age,
    w.id AS id1
   FROM public.winners_id_age w
  WHERE (w.age IN ( SELECT w1.age
           FROM public.winners_id_age w1
          GROUP BY w1.age
         HAVING (count(*) > 1)))
  ORDER BY w.age;


ALTER TABLE public.multiple_ages OWNER TO comp2400;

--
-- Name: restriction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restriction (
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    description character varying(20) NOT NULL,
    country character varying(20) NOT NULL
);


ALTER TABLE public.restriction OWNER TO postgres;

--
-- Name: restriction_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restriction_category (
    description character varying(20) NOT NULL,
    country character varying(20) NOT NULL
);


ALTER TABLE public.restriction_category OWNER TO postgres;

--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    id character(8) NOT NULL,
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    description character varying(100) NOT NULL,
    credits character varying(40)
);


ALTER TABLE public.role OWNER TO postgres;

--
-- Name: scene; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scene (
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    scene_no integer NOT NULL,
    description character varying(100) NOT NULL
);


ALTER TABLE public.scene OWNER TO postgres;

--
-- Name: writer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.writer (
    id character(8) NOT NULL,
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    credits character varying(40)
);


ALTER TABLE public.writer OWNER TO postgres;

--
-- Name: writer_award; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.writer_award (
    id character(8) NOT NULL,
    title character varying(40) NOT NULL,
    production_year integer NOT NULL,
    award_name character varying(40) NOT NULL,
    year_of_award integer NOT NULL,
    category character varying(100) NOT NULL,
    result character varying(20)
);


ALTER TABLE public.writer_award OWNER TO postgres;

--
-- Data for Name: actor_award; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actor_award (title, production_year, description, award_name, year_of_award, category, result) FROM stdin;
Alice	1990	Alice Tate	Golden Globe Awards	1991	Best Performance by an Actress	nominated
Chaplin	1992	Charlie Chaplin	Oscar	1993	Best Actor in a Leading Role	nominated
Chaplin	1992	Charlie Chaplin	Golden Globe Awards	1993	Best Performance by an Actor	nominated
Chaplin	1992	Hannah Chaplin	Golden Globe Awards	1993	Best Performance by an Actress	nominated
Fearless	1993	Carla Rodrigo	Oscar	1994	Best Actress in a Supporting Role	nominated
Fearless	1993	Carla Rodrigo	Golden Globe Awards	1994	Best Actress in a Supporting Role	nominated
Cyrano de Bergerac	1990	Cyrano De Bergerac	Oscar	1991	Best Actor in a Leading Role	nominated
Cyrano de Bergerac	1990	Cyrano De Bergerac	BAFTA Film Award	1992	Best Actor	nominated
Manhattan Murder Mystery	1993	Carol Lipton	Golden Globe Awards	1994	Best Performance by an Actress	nominated
Benny and Joon	1993	Sam	Golden Globe Awards	1994	Best Performance by an Actor	nominated
Six Degrees of Separation	1993	Ouisa Kittredge	Oscar	1994	Best Actress in a Leading Role	nominated
Six Degrees of Separation	1993	Ouisa Kittredge	Golden Globe Awards	1994	Best Performance by an Actress	nominated
In the Line of Fire	1993	Mitch Leary	Oscar	1994	Best Actor in a Supporting Role	nominated
In the Line of Fire	1993	Mitch Leary	BAFTA Film Award	1994	Best Actor Supporting	nominated
In the Line of Fire	1993	Mitch Leary	Golden Globe Awards	1994	Best Performance by an Actor	nominated
Traffic	2000	Javier Rodriguez	Oscar	2001	best actor in a supporting role	won
Gladiator	2000	Maximus	Oscar	2001	Best actor in a leading role	won
Life is Beautiful	1997	Guido Orefice	Oscar	1998	Actor in a Leading Role	won
Affliction	1997	Glen Whitehouse	Oscar	1998	Actor in a supporting Role	won
Shakespeare in Love	1998	Queen Elizabeth	Oscar	1998	Actress in a supporting Role	won
Boys Dont Cry	1999	Brandon Teena	Oscar	1999	Actress in a Leading Role	won
American Beauty	1999	Lester Burnham	Oscar	1999	Actor in a Leading Role	won
The Cider House Rules	1999	Dr Wilbur Larch	Oscar	1999	Actor in a supporting Role	won
Topless Women Talk About Their Lives	1997	Neil	New Zealand Film and TV Awards	1999	Best Actor	won
The Piano	1993	Ada McGrath	Oscar	1994	Best Actress	won
The Piano	1993	Flora McGrath	Oscar	1994	Best supporting Actress	won
The Piano	1993	Ada McGrath	AFI Award	1993	Best Actress in a lead role	won
The Piano	1993	George Baines	AFI Award	1993	Best Actor in a lead role	won
The Piano	1993	Ada McGrath	BAFTA Film Award	1994	Best Actress in a lead role	won
Strictly Ballroom	1992	Shirley Hastings	AFI Award	1992	Best Actress in a supporting role	won
Strictly Ballroom	1992	Doug Hastings	AFI Award	1992	Best Actor in a supporting role	won
Traffic	2000	Javier Rodriguez	Golden Globe Awards	2001	Best Actor in a supporting role	won
Traffic	2000	Javier Rodriguez	Silver Berlin Bear	2001	Best Actor	won
Psycho	1960	Marion Crane	Golden Globe Awards	1961	Best Supporting Actress	won
Twelve Monkeys	1995	Jeffrey Goines	Golden Globe Awards	1996	Best Supporting Actor	won
Chaplin	1992	Charlie Chaplin	BAFTA Film Award	1993	Best Actor	won
Chaplin	1992	Charlie Chaplin	ALFS Award	1993	Actor of the Year	won
Cyrano de Bergerac	1990	Cyrano De Bergerac	ALFS Award	1992	Actor OF the Year	won
Bawang Bie Ji	1993	Juxian	NYFCC Award	1993	Best Supporting Actress	won
\.


--
-- Data for Name: appearance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appearance (title, production_year, description, scene_no) FROM stdin;
Psycho	1960	Lila Crane	1
Psycho	1960	Marion Crane	1
Psycho	1960	Sam Loomis	1
Psycho	1960	Lila Crane	3
Psycho	1960	Marion Crane	3
Psycho	1960	Man in hat	3
Psycho	1960	Norman Bates	4
Psycho	1960	Norman Bates	5
Psycho	1960	Mother	5
Psycho	1960	Norman Bates	6
Psycho	1960	Norman Bates	7
Psycho	1960	Sam Loomis	7
Psycho	1960	Lila Crane	7
Psycho	1960	Norman Bates	8
Psycho	1960	Mother	8
The Birds	1963	Mitch Brenner	1
The Birds	1963	Melanie Daniels	1
The Birds	1963	Mitch Brenner	2
The Birds	1963	Man in pet shop	2
The Birds	1963	Annie Hayworth	3
The Birds	1963	Melanie Daniels	3
The Birds	1963	Mitch Brenner	4
The Birds	1963	Lydia Brenner	4
The Birds	1963	Melanie Daniels	4
The Birds	1963	Mitch Brenner	5
The Birds	1963	Annie Hayworth	5
The Birds	1963	Melanie Daniels	5
The Birds	1963	Mitch Brenner	6
The Birds	1963	Annie Hayworth	6
The Birds	1963	Melanie Daniels	6
The Birds	1963	Lydia Brenner	6
The Birds	1963	Mitch Brenner	7
The Birds	1963	Melanie Daniels	7
The Birds	1963	Lydia Brenner	7
The Birds	1963	Mitch Brenner	8
The Birds	1963	Melanie Daniels	8
The Birds	1963	Lydia Brenner	8
Rear Window	1954	L.B. Jeff Jefferies	1
Rear Window	1954	L.B. Jeff Jefferies	2
Rear Window	1954	Lisa Carol Fremont	2
Rear Window	1954	Lisa Carol Fremont	3
Rear Window	1954	Clock-Winding Man	3
Rear Window	1954	Lisa Carol Fremont	4
Rear Window	1954	Lars Thorwald	4
Rear Window	1954	L.B. Jeff Jefferies	4
Rear Window	1954	L.B. Jeff Jefferies	5
Rear Window	1954	Lars Thorwald	5
Rear Window	1954	Lisa Carol Fremont	6
Rear Window	1954	Lars Thorwald	6
Rear Window	1954	L.B. Jeff Jefferies	7
Rear Window	1954	Lars Thorwald	7
Rear Window	1954	L.B. Jeff Jefferies	8
Rear Window	1954	Lisa Carol Fremont	8
Traffic	2000	Javier Rodriguez	1
Traffic	2000	Manolo Sanchez	1
Traffic	2000	Robert Wakefield	2
Traffic	2000	Barbara Wakefield	2
Traffic	2000	Caroline Wakefield	3
Traffic	2000	Montel Gordon	4
Traffic	2000	Ray Castro	4
Traffic	2000	Carlos Ayala	4
Traffic	2000	Helena Ayala	4
Traffic	2000	Manolo Sanchez	5
Traffic	2000	Ray Castro	5
Traffic	2000	Javier Rodriguez	5
Traffic	2000	Montel Gordon	5
Traffic	2000	Robert Wakefield	6
Traffic	2000	Barbara Wakefield	6
Traffic	2000	Caroline Wakefield	6
Traffic	2000	Francisco Flores	6
Traffic	2000	Montel Gordon	6
Traffic	2000	Helena Ayala	7
Traffic	2000	Javier Rodriguez	7
Traffic	2000	Manolo Sanchez	7
Traffic	2000	Francisco Flores	7
Traffic	2000	Javier Rodriguez	8
Traffic	2000	Manolo Sanchez	8
Traffic	2000	Robert Wakefield	8
Traffic	2000	Barbara Wakefield	8
Traffic	2000	Francisco Flores	9
Traffic	2000	Robert Wakefield	9
Traffic	2000	Montel Gordon	9
Traffic	2000	Carlos Ayala	9
Traffic	2000	Robert Wakefield	10
Traffic	2000	Barbara Wakefield	10
Traffic	2000	Caroline Wakefield	10
Traffic	2000	Carlos Ayala	10
Traffic	2000	Montel Gordon	10
Traffic	2000	Manolo Sanchez	10
Traffic	2000	Francisco Flores	10
Traffic	2000	Carlos Ayala	11
Traffic	2000	Helena Ayala	11
Traffic	2000	Montel Gordon	11
Bullets Over Broadway	1994	David Shayne	1
Bullets Over Broadway	1994	Julian Marx	1
Bullets Over Broadway	1994	Rocco	1
Bullets Over Broadway	1994	David Shayne	2
Bullets Over Broadway	1994	David Shayne	3
Bullets Over Broadway	1994	Julian Marx	3
Bullets Over Broadway	1994	Rocco	3
Bullets Over Broadway	1994	Rocco	4
Bullets Over Broadway	1994	Julian Marx	4
Bullets Over Broadway	1994	Rocco	5
Bullets Over Broadway	1994	David Shayne	6
Bullets Over Broadway	1994	Julian Marx	6
Tombstone	1993	Kurt Russell	1
Tombstone	1993	Val Kilmer	1
Tombstone	1993	Kurt Russell	2
Tombstone	1993	Kurt Russell	3
Tombstone	1993	Val Kilmer	3
Tombstone	1993	Sam Elliott	3
Tombstone	1993	Val Kilmer	4
Tombstone	1993	Sam Elliott	5
Tombstone	1993	Kurt Russell	5
Tombstone	1993	Kurt Russell	6
Tombstone	1993	Sam Elliott	6
Alice	1990	Joe	1
Alice	1990	Alice Tate	2
Alice	1990	Doug Tate	2
Alice	1990	Joe	3
Alice	1990	Alice Tate	3
Psycho	1960	Marion Crane	4
Psycho	1960	Marion Crane	6
Psycho	1960	Milton Arbogast	7
Alice	1990	Joe	4
Alice	1990	Doug Tate	4
Alice	1990	Alice Tate	5
Alice	1990	Doug Tate	5
Alice	1990	Joe	6
Alice	1990	Alice Tate	7
Alice	1990	Joe	8
Mermaids	1990	Rachel Flax	1
Mermaids	1990	Lou Landsky	1
Mermaids	1990	Lou Landsky	2
Mermaids	1990	Charlotte Flax	2
Mermaids	1990	Rachel Flax	3
Mermaids	1990	Lou Landsky	3
Mermaids	1990	Charlotte Flax	3
Mermaids	1990	Rachel Flax	4
Mermaids	1990	Lou Landsky	4
Mermaids	1990	Rachel Flax	5
Exotica	1994	Inspector	1
Exotica	1994	Thomas Pinto	1
Exotica	1994	Inspector	2
Exotica	1994	Inspector	3
Exotica	1994	Thomas Pinto	3
Exotica	1994	Christina	3
Exotica	1994	Thomas Pinto	4
Exotica	1994	Inspector	5
Exotica	1994	Christina	5
Exotica	1994	Christina	6
Exotica	1994	Inspector	7
Exotica	1994	Thomas Pinto	8
Red Rock West	1992	Michael Williams	1
Red Rock West	1992	Michael Williams	2
Red Rock West	1992	Jim	2
Red Rock West	1992	Michael Williams	3
Red Rock West	1992	Jim	3
Red Rock West	1992	Jim	4
Red Rock West	1992	Michael Williams	5
Red Rock West	1992	Jim	5
Red Rock West	1992	Jim	6
Red Rock West	1992	Michael Williams	7
Red Rock West	1992	Michael Williams	8
Red Rock West	1992	Jim	8
Chaplin	1992	Charlie Chaplin	1
Chaplin	1992	Hannah Chaplin	1
Chaplin	1992	Sydney Chaplin	1
Chaplin	1992	Hannah Chaplin	2
Chaplin	1992	Charlie Chaplin	3
Chaplin	1992	Sydney Chaplin	3
Chaplin	1992	Charlie Chaplin	4
Chaplin	1992	Hannah Chaplin	4
Chaplin	1992	Sydney Chaplin	5
Chaplin	1992	Charlie Chaplin	6
Chaplin	1992	Hannah Chaplin	6
Fearless	1993	Max Klein	1
Fearless	1993	Laura Klein	2
Fearless	1993	Max Klein	3
Fearless	1993	Max Klein	4
Fearless	1993	Laura Klein	4
Fearless	1993	Laura Klein	5
Fearless	1993	Carla Rodrigo	5
Fearless	1993	Max Klein	6
Fearless	1993	Laura Klein	7
Fearless	1993	Carla Rodrigo	8
Fearless	1993	Max Klein	9
Fearless	1993	Laura Klein	10
Fearless	1993	Max Klein	11
Threesome	1994	Alex	1
Threesome	1994	Stuart	1
Threesome	1994	Stuart	2
Threesome	1994	Eddy	2
Threesome	1994	Alex	3
Threesome	1994	Stuart	3
Threesome	1994	Alex	4
Threesome	1994	Stuart	5
Threesome	1994	Eddy	5
Threesome	1994	Alex	6
Threesome	1994	Stuart	7
Threesome	1994	Alex	8
Jungle Fever	1991	Flipper Purify	1
Jungle Fever	1991	Flipper Purify	2
Jungle Fever	1991	Angie Tucci	2
Jungle Fever	1991	Flipper Purify	3
Jungle Fever	1991	Angie Tucci	3
Jungle Fever	1991	Flipper Purify	4
Jungle Fever	1991	Angie Tucci	4
Jungle Fever	1991	Flipper Purify	5
Jungle Fever	1991	Angie Tucci	6
Jungle Fever	1991	Flipper Purify	7
Jungle Fever	1991	Angie Tucci	8
Internal Affairs	1990	Dennis Peck	1
Internal Affairs	1990	Raymond Avila	1
Internal Affairs	1990	Kathleen Avila	1
Internal Affairs	1990	Dennis Peck	2
Internal Affairs	1990	Raymond Avila	2
Internal Affairs	1990	Raymond Avila	3
Internal Affairs	1990	Kathleen Avila	3
Internal Affairs	1990	Dennis Peck	4
Internal Affairs	1990	Raymond Avila	5
Internal Affairs	1990	Kathleen Avila	5
Internal Affairs	1990	Dennis Peck	6
Internal Affairs	1990	Kathleen Avila	6
Single White Female	1992	Allison Jones	1
Single White Female	1992	Hedra Carlson	2
Single White Female	1992	Allison Jones	3
Single White Female	1992	Allison Jones	4
Single White Female	1992	Hedra Carlson	4
Single White Female	1992	Sam Rawson	5
Single White Female	1992	Allison Jones	6
Single White Female	1992	Sam Rawson	6
Single White Female	1992	Sam Rawson	7
Single White Female	1992	Allison Jones	8
Single White Female	1992	Hedra Carlson	8
Single White Female	1992	Allison Jones	9
Trust	1990	Maria Coughlin	1
Trust	1990	Matthew Slaughter	1
Trust	1990	Maria Coughlin	2
Trust	1990	Matthew Slaughter	2
Trust	1990	Maria Coughlin	3
Trust	1990	Matthew Slaughter	3
Trust	1990	Matthew Slaughter	4
Trust	1990	Maria Coughlin	5
Trust	1990	Matthew Slaughter	5
Trust	1990	Maria Coughlin	6
Ju Dou	1990	Ju Dou	1
Ju Dou	1990	Yang Tian-qing	1
Ju Dou	1990	Ju Dou	2
Ju Dou	1990	Yang Tian-qing	2
Ju Dou	1990	Ju Dou	3
Ju Dou	1990	Yang Tian-qing	3
Ju Dou	1990	Ju Dou	4
Ju Dou	1990	Yang Tian-qing	4
Ju Dou	1990	Ju Dou	5
Ju Dou	1990	Yang Tian-qing	5
Ju Dou	1990	Ju Dou	6
Ju Dou	1990	Yang Tian-qing	7
Dahong Denglong Gaogao Gua	1991	Songlian	1
Dahong Denglong Gaogao Gua	1991	The Master	1
Dahong Denglong Gaogao Gua	1991	The Third Concubine	2
Dahong Denglong Gaogao Gua	1991	The Master	2
Dahong Denglong Gaogao Gua	1991	Songlian	3
Dahong Denglong Gaogao Gua	1991	The Third Concubine	3
Dahong Denglong Gaogao Gua	1991	Songlian	4
Dahong Denglong Gaogao Gua	1991	Songlian	5
Dahong Denglong Gaogao Gua	1991	The Third Concubine	5
Dahong Denglong Gaogao Gua	1991	Songlian	6
Dahong Denglong Gaogao Gua	1991	The Master	6
Cyrano de Bergerac	1990	Cyrano De Bergerac	1
Cyrano de Bergerac	1990	Roxane	1
Cyrano de Bergerac	1990	Cyrano De Bergerac	2
Cyrano de Bergerac	1990	Roxane	2
Cyrano de Bergerac	1990	Cyrano De Bergerac	3
Cyrano de Bergerac	1990	Cyrano De Bergerac	4
Cyrano de Bergerac	1990	Roxane	4
Cyrano de Bergerac	1990	Cyrano De Bergerac	5
Cyrano de Bergerac	1990	Roxane	5
Manhattan Murder Mystery	1993	Larry Lipton	1
Manhattan Murder Mystery	1993	Larry Lipton	2
Manhattan Murder Mystery	1993	Carol Lipton	2
Manhattan Murder Mystery	1993	Larry Lipton	3
Manhattan Murder Mystery	1993	Carol Lipton	3
Manhattan Murder Mystery	1993	Larry Lipton	4
Manhattan Murder Mystery	1993	Carol Lipton	4
Manhattan Murder Mystery	1993	Larry Lipton	5
Manhattan Murder Mystery	1993	Carol Lipton	6
Manhattan Murder Mystery	1993	Larry Lipton	7
Manhattan Murder Mystery	1993	Larry Lipton	8
Manhattan Murder Mystery	1993	Carol Lipton	8
El Mariachi	1992	El Mariachi	1
El Mariachi	1992	Domino	1
El Mariachi	1992	El Mariachi	2
El Mariachi	1992	El Mariachi	3
El Mariachi	1992	Domino	3
El Mariachi	1992	Domino	4
El Mariachi	1992	El Mariachi	5
El Mariachi	1992	El Mariachi	6
El Mariachi	1992	Domino	6
El Mariachi	1992	Domino	7
El Mariachi	1992	El Mariachi	8
El Mariachi	1992	Domino	9
El Mariachi	1992	El Mariachi	10
El Mariachi	1992	Domino	10
Once Were Warriors	1994	Beth Heke	1
Once Were Warriors	1994	Jake Heke	1
Once Were Warriors	1994	Beth Heke	2
Once Were Warriors	1994	Jake Heke	2
Once Were Warriors	1994	Beth Heke	3
Once Were Warriors	1994	Jake Heke	3
Once Were Warriors	1994	Jake Heke	4
Once Were Warriors	1994	Beth Heke	5
Once Were Warriors	1994	Jake Heke	5
Once Were Warriors	1994	Beth Heke	6
Once Were Warriors	1994	Jake Heke	6
Priest	1994	Father Greg Pilkington	1
Priest	1994	Father Matthew Thomas	2
Priest	1994	Father Greg Pilkington	3
Priest	1994	Father Matthew Thomas	3
Priest	1994	Father Greg Pilkington	4
Priest	1994	Father Greg Pilkington	5
Priest	1994	Father Matthew Thomas	5
Priest	1994	Father Matthew Thomas	6
Priest	1994	Father Greg Pilkington	7
Priest	1994	Father Matthew Thomas	7
Priest	1994	Father Greg Pilkington	8
Pump Up the Volum	1990	Mark Hunter	1
Pump Up the Volum	1990	Nora Diniro	1
Pump Up the Volum	1990	Mark Hunter	2
Pump Up the Volum	1990	Nora Diniro	2
Pump Up the Volum	1990	Mark Hunter	3
Pump Up the Volum	1990	Nora Diniro	3
Pump Up the Volum	1990	Mark Hunter	4
Pump Up the Volum	1990	Nora Diniro	4
Pump Up the Volum	1990	Mark Hunter	5
Pump Up the Volum	1990	Nora Diniro	5
Pump Up the Volum	1990	Mark Hunter	6
Benny and Joon	1993	Sam	1
Benny and Joon	1993	Juniper Pearl	1
Benny and Joon	1993	Sam	2
Benny and Joon	1993	Juniper Pearl	2
Benny and Joon	1993	Sam	3
Benny and Joon	1993	Juniper Pearl	3
Benny and Joon	1993	Sam	4
Benny and Joon	1993	Juniper Pearl	4
Benny and Joon	1993	Sam	5
Benny and Joon	1993	Juniper Pearl	5
Six Degrees of Separation	1993	Ouisa Kittredge	1
Six Degrees of Separation	1993	Paul	1
Six Degrees of Separation	1993	John Flanders	2
Six Degrees of Separation	1993	Ouisa Kittredge	3
Six Degrees of Separation	1993	Paul	3
Six Degrees of Separation	1993	John Flanders	3
Six Degrees of Separation	1993	Ouisa Kittredge	4
Six Degrees of Separation	1993	Paul	4
Six Degrees of Separation	1993	John Flanders	4
Six Degrees of Separation	1993	Ouisa Kittredge	5
Six Degrees of Separation	1993	Paul	5
Bawang Bie Ji	1993	Cheng Dieyi	1
Bawang Bie Ji	1993	Duan Xiaolou	2
Bawang Bie Ji	1993	Cheng Dieyi	3
Bawang Bie Ji	1993	Duan Xiaolou	3
Bawang Bie Ji	1993	Cheng Dieyi	4
Bawang Bie Ji	1993	Juxian	4
Bawang Bie Ji	1993	Duan Xiaolou	5
Bawang Bie Ji	1993	Juxian	5
Bawang Bie Ji	1993	Cheng Dieyi	6
Bawang Bie Ji	1993	Duan Xiaolou	6
Bawang Bie Ji	1993	Juxian	7
Bawang Bie Ji	1993	Cheng Dieyi	8
In the Line of Fire	1993	Secret Service Agent Frank Horrigan	1
In the Line of Fire	1993	Mitch Leary	1
In the Line of Fire	1993	Secret Service Agent Lilly Raines	1
In the Line of Fire	1993	Secret Service Agent Frank Horrigan	2
In the Line of Fire	1993	Secret Service Agent Lilly Raines	2
In the Line of Fire	1993	Mitch Leary	3
In the Line of Fire	1993	Secret Service Agent Frank Horrigan	4
In the Line of Fire	1993	Secret Service Agent Lilly Raines	4
In the Line of Fire	1993	Secret Service Agent Frank Horrigan	5
In the Line of Fire	1993	Mitch Leary	5
In the Line of Fire	1993	Secret Service Agent Lilly Raines	5
Heavenly Creatures	1994	Pauline Yvonne Rieper	1
Heavenly Creatures	1994	Juliet Marion Hulme	1
Heavenly Creatures	1994	Pauline Yvonne Rieper	2
Heavenly Creatures	1994	Juliet Marion Hulme	2
Heavenly Creatures	1994	Pauline Yvonne Rieper	3
Heavenly Creatures	1994	Juliet Marion Hulme	3
Heavenly Creatures	1994	Pauline Yvonne Rieper	4
Heavenly Creatures	1994	Juliet Marion Hulme	4
Heavenly Creatures	1994	Pauline Yvonne Rieper	5
Heavenly Creatures	1994	Pauline Yvonne Rieper	6
Heavenly Creatures	1994	Juliet Marion Hulme	6
Hoop Dreams	1994	Himself	1
Hoop Dreams	1994	Himself	2
Hoop Dreams	1994	Himself	3
Hoop Dreams	1994	Himself	4
Hoop Dreams	1994	Himself	5
Seven	1995	Detective William Somerset	1
Seven	1995	Detective William Somerset	2
Seven	1995	Detective David Mills	2
Seven	1995	Detective William Somerset	3
Seven	1995	Detective David Mills	3
Seven	1995	Detective William Somerset	4
Seven	1995	Detective David Mills	4
Seven	1995	Detective William Somerset	5
Seven	1995	Detective David Mills	5
Seven	1995	Detective David Mills	6
Seven	1995	Detective William Somerset	7
Seven	1995	Detective David Mills	7
Shallow Grave	1994	Juliet Miller	1
Shallow Grave	1994	David Stephens	1
Shallow Grave	1994	Alex Law	1
Shallow Grave	1994	Juliet Miller	2
Shallow Grave	1994	David Stephens	2
Shallow Grave	1994	Alex Law	2
Shallow Grave	1994	David Stephens	3
Shallow Grave	1994	Juliet Miller	4
Shallow Grave	1994	David Stephens	5
Shallow Grave	1994	Alex Law	5
Shallow Grave	1994	Juliet Miller	6
Shallow Grave	1994	David Stephens	6
French Kiss	1995	Kate	1
French Kiss	1995	Luc Teyssier	1
French Kiss	1995	Kate	2
French Kiss	1995	Luc Teyssier	2
French Kiss	1995	Luc Teyssier	3
French Kiss	1995	Charlie	3
French Kiss	1995	Kate	4
French Kiss	1995	Luc Teyssier	4
French Kiss	1995	Charlie	5
French Kiss	1995	Kate	6
French Kiss	1995	Luc Teyssier	6
Braindead	1992	Lionel Cosgrove	1
Braindead	1992	Paquita Maria Sanchez	2
Braindead	1992	Mum	2
Braindead	1992	Lionel Cosgrove	3
Braindead	1992	Paquita Maria Sanchez	4
Braindead	1992	Mum	4
Braindead	1992	Undertaker Assistant	5
Braindead	1992	Lionel Cosgrove	6
Braindead	1992	Paquita Maria Sanchez	6
Braindead	1992	Undertaker Assistant	7
Braindead	1992	Undertaker Assistant	8
Braindead	1992	Mum	9
Clerks	1994	Veronica Loughran	1
Clerks	1994	Caitlin Bree	1
Clerks	1994	Veronica Loughran	2
Clerks	1994	Veronica Loughran	3
Clerks	1994	Caitlin Bree	3
Clerks	1994	Veronica Loughran	4
Clerks	1994	Caitlin Bree	4
Clerks	1994	Veronica Loughran	5
Clerks	1994	Caitlin Bree	5
Clerks	1994	Caitlin Bree	6
Clerks	1994	Veronica Loughran	7
Clerks	1994	Caitlin Bree	8
Apollo 13	1995	Jim Lovell	1
Apollo 13	1995	Fred Haise	2
Apollo 13	1995	Jack Swigert	2
Apollo 13	1995	Jim Lovell	3
Apollo 13	1995	Fred Haise	4
Apollo 13	1995	Jack Swigert	4
Apollo 13	1995	Jim Lovell	5
Apollo 13	1995	Fred Haise	6
Apollo 13	1995	Jim Lovell	7
Apollo 13	1995	Jack Swigert	8
Apollo 13	1995	Jim Lovell	9
Apollo 13	1995	Fred Haise	9
Apollo 13	1995	Jack Swigert	10
Reservoir Dogs	1992	Larry	1
Reservoir Dogs	1992	Freddy	2
Reservoir Dogs	1992	Larry	3
Reservoir Dogs	1992	Vic	3
Reservoir Dogs	1992	Freddy	4
Reservoir Dogs	1992	Vic	4
Reservoir Dogs	1992	Larry	5
Reservoir Dogs	1992	Freddy	6
Reservoir Dogs	1992	Vic	6
Pulp Fiction	1994	Vincent Vega	1
Pulp Fiction	1994	Jules Winnfield	1
Pulp Fiction	1994	Vincent Vega	2
Pulp Fiction	1994	Jules Winnfield	3
Pulp Fiction	1994	Winston Wolf	3
Pulp Fiction	1994	Vincent Vega	4
Pulp Fiction	1994	Jules Winnfield	5
Pulp Fiction	1994	Vincent Vega	6
Pulp Fiction	1994	Vincent Vega	7
Pulp Fiction	1994	Winston Wolf	7
Pulp Fiction	1994	Winston Wolf	8
Pulp Fiction	1994	Jules Winnfield	9
Short Cuts	1993	Ann Finnigan	1
Short Cuts	1993	Howard Finnigan	2
Short Cuts	1993	Ann Finnigan	3
Short Cuts	1993	Paul Finnigan	3
Short Cuts	1993	Howard Finnigan	4
Short Cuts	1993	Ann Finnigan	5
Short Cuts	1993	Paul Finnigan	5
Short Cuts	1993	Paul Finnigan	6
Short Cuts	1993	Howard Finnigan	7
Short Cuts	1993	Paul Finnigan	7
Short Cuts	1993	Ann Finnigan	8
Short Cuts	1993	Paul Finnigan	8
Legends of the Fall	1994	Tristan Ludlow	1
Legends of the Fall	1994	Colonel William Ludlow	1
Legends of the Fall	1994	Tristan Ludlow	2
Legends of the Fall	1994	Alfred Ludlow	2
Legends of the Fall	1994	Colonel William Ludlow	3
Legends of the Fall	1994	Tristan Ludlow	4
Legends of the Fall	1994	Colonel William Ludlow	5
Legends of the Fall	1994	Alfred Ludlow	5
Legends of the Fall	1994	Tristan Ludlow	6
Legends of the Fall	1994	Alfred Ludlow	7
Legends of the Fall	1994	Tristan Ludlow	8
Legends of the Fall	1994	Colonel William Ludlow	8
Natural Born Killers	1994	Mickey Knox	1
Natural Born Killers	1994	Mallory Wilson Knox	1
Natural Born Killers	1994	Wayne Gale	2
Natural Born Killers	1994	Mickey Knox	3
Natural Born Killers	1994	Mallory Wilson Knox	3
Natural Born Killers	1994	Mickey Knox	4
Natural Born Killers	1994	Mallory Wilson Knox	5
Natural Born Killers	1994	Wayne Gale	5
Natural Born Killers	1994	Mickey Knox	6
Natural Born Killers	1994	Wayne Gale	6
Natural Born Killers	1994	Mickey Knox	7
Natural Born Killers	1994	Mallory Wilson Knox	7
In the Mouth of Madness	1995	John Trent	1
In the Mouth of Madness	1995	Sutter Cane	1
In the Mouth of Madness	1995	Sutter Cane	2
In the Mouth of Madness	1995	John Trent	3
In the Mouth of Madness	1995	Linda Styles	3
In the Mouth of Madness	1995	Sutter Cane	4
In the Mouth of Madness	1995	Linda Styles	4
In the Mouth of Madness	1995	John Trent	5
In the Mouth of Madness	1995	Linda Styles	5
In the Mouth of Madness	1995	Sutter Cane	6
In the Mouth of Madness	1995	John Trent	7
Forrest Gump	1994	Forrest Gump	1
Forrest Gump	1994	Forrest Gump	2
Forrest Gump	1994	Forrest Gump	3
Forrest Gump	1994	Jenny Curran	3
Forrest Gump	1994	Lieutenant Daniel Taylor	4
Forrest Gump	1994	Forrest Gump	5
Forrest Gump	1994	Jenny Curran	5
Forrest Gump	1994	Lieutenant Daniel Taylor	6
Forrest Gump	1994	Forrest Gump	7
Forrest Gump	1994	Lieutenant Daniel Taylor	7
Forrest Gump	1994	Forrest Gump	8
Forrest Gump	1994	Lieutenant Daniel Taylor	9
Forrest Gump	1994	Forrest Gump	10
Forrest Gump	1994	Jenny Curran	11
Malcolm X	1992	Malcolm X	1
Malcolm X	1992	Betty Shabazz	1
Malcolm X	1992	Shorty	2
Malcolm X	1992	Malcolm X	3
Malcolm X	1992	Betty Shabazz	3
Malcolm X	1992	Shorty	4
Malcolm X	1992	Malcolm X	5
Malcolm X	1992	Betty Shabazz	6
Malcolm X	1992	Malcolm X	7
Malcolm X	1992	Shorty	7
Malcolm X	1992	Shorty	8
Malcolm X	1992	Malcolm X	9
Malcolm X	1992	Malcolm X	10
Malcolm X	1992	Betty Shabazz	10
Dead Again	1991	Mike Church	1
Dead Again	1991	Gray Baker	2
Dead Again	1991	Margaret Strauss	2
Dead Again	1991	Mike Church	3
Dead Again	1991	Gray Baker	3
Dead Again	1991	Margaret Strauss	4
Dead Again	1991	Mike Church	5
Dead Again	1991	Margaret Strauss	5
Dead Again	1991	Gray Baker	6
Dead Again	1991	Mike Church	7
Dead Again	1991	Margaret Strauss	7
Dead Again	1991	Gray Baker	8
Jurassic Park	1993	Alan Grant	1
Jurassic Park	1993	Ellie Sattler	1
Jurassic Park	1993	Ian Malcolm	2
Jurassic Park	1993	Ellie Sattler	3
Jurassic Park	1993	Alan Grant	4
Jurassic Park	1993	Ian Malcolm	5
Jurassic Park	1993	John Parker Hammond	5
Jurassic Park	1993	Ian Malcolm	6
Jurassic Park	1993	Alan Grant	7
Jurassic Park	1993	John Parker Hammond	8
Jurassic Park	1993	Ellie Sattler	8
Jurassic Park	1993	John Parker Hammond	9
Clueless	1995	Cher Horowitz	1
Clueless	1995	Dionne	2
Clueless	1995	Tai Fraiser	2
Clueless	1995	Cher Horowitz	3
Clueless	1995	Cher Horowitz	4
Clueless	1995	Dionne	4
Clueless	1995	Tai Fraiser	4
Clueless	1995	Dionne	5
Clueless	1995	Tai Fraiser	5
Clueless	1995	Cher Horowitz	6
Clueless	1995	Dionne	7
Clueless	1995	Tai Fraiser	7
Shadowlands	1993	Lewis	1
Shadowlands	1993	Joy Gresham	1
Shadowlands	1993	Lewis	2
Shadowlands	1993	Arnold Dopliss	2
Shadowlands	1993	Joy Gresham	3
Shadowlands	1993	Lewis	4
Shadowlands	1993	Arnold Dopliss	5
Shadowlands	1993	Lewis	6
Shadowlands	1993	Arnold Dopliss	6
Shadowlands	1993	Joy Gresham	7
Shadowlands	1993	Arnold Dopliss	7
Amateur	1994	Isabelle	1
Amateur	1994	Thomas Ludens	1
Amateur	1994	Sofia Ludens	1
Amateur	1994	Isabelle	2
Amateur	1994	Thomas Ludens	2
Amateur	1994	Thomas Ludens	3
Amateur	1994	Sofia Ludens	3
Amateur	1994	Isabelle	4
Amateur	1994	Sofia Ludens	4
Amateur	1994	Isabelle	5
Amateur	1994	Thomas Ludens	5
GoodFellas	1990	James	1
GoodFellas	1990	Henry Hill	2
GoodFellas	1990	Tommy DeVito	2
GoodFellas	1990	James	3
GoodFellas	1990	Henry Hill	3
GoodFellas	1990	Tommy DeVito	4
GoodFellas	1990	James	5
GoodFellas	1990	Henry Hill	6
GoodFellas	1990	James	7
GoodFellas	1990	Tommy DeVito	8
GoodFellas	1990	James	9
GoodFellas	1990	Tommy DeVito	9
GoodFellas	1990	James	10
GoodFellas	1990	Henry Hill	11
Little Women	1994	Josephine	1
Little Women	1994	Friedrich	2
Little Women	1994	Josephine	3
Little Women	1994	Margaret	3
Little Women	1994	Josephine	4
Little Women	1994	Older Amy March	4
Little Women	1994	Margaret	5
Little Women	1994	Josephine	6
Little Women	1994	Friedrich	6
Little Women	1994	Older Amy March	7
Little Women	1994	Josephine	8
Little Women	1994	Older Amy March	8
While You Were Sleeping	1995	Narrator	1
While You Were Sleeping	1995	Jack Callaghan	1
While You Were Sleeping	1995	Narrator	2
While You Were Sleeping	1995	Saul	3
While You Were Sleeping	1995	Jack Callaghan	4
While You Were Sleeping	1995	Saul	4
While You Were Sleeping	1995	Narrator	5
While You Were Sleeping	1995	Saul	6
While You Were Sleeping	1995	Narrator	7
While You Were Sleeping	1995	Saul	7
While You Were Sleeping	1995	Jack Callaghan	8
While You Were Sleeping	1995	Narrator	9
Psycho	1998	Lila Crane	1
Psycho	1998	Marion Crane	1
Psycho	1998	Sam Loomis	1
Psycho	1998	Marion Crane	2
Psycho	1998	Lila Crane	3
Psycho	1998	Marion Crane	3
Psycho	1998	Norman Bates	4
Psycho	1998	Marion Crane	4
Psycho	1998	Norman Bates	5
Psycho	1998	Mother	5
Psycho	1998	Mother	6
Psycho	1998	Norman Bates	6
Psycho	1998	Marion Crane	6
Psycho	1998	Norman Bates	7
Psycho	1998	Sam Loomis	7
Psycho	1998	Milton Arbogast	7
Psycho	1998	Lila Crane	7
Psycho	1998	Norman Bates	8
Psycho	1998	Mother	8
Psycho	1960	Mother	6
Psycho	1960	Marion Crane	2
\.


--
-- Data for Name: award; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.award (award_name, institution, country) FROM stdin;
BAFTA Film Award	British Academy Awards	UK
Oscar	Academy Awards	USA
Golden Globe Awards	The Hollywood Foreign Press Association	USA
Eddie	American Cinema Editors	USA
New Zealand Film and TV Awards	New Zealand Film and TV	New Zealand
Locarno International Film Festival	Festival Internazionale del Film Locarno	Switzerland
ALFS Award	London Film Critics Circle Awards	UK
AFI Award	Australian Film Institute	Australia
Silver Berlin Bear	Berlin International Film Festival	Germany
NYFCC Award	New York Film Critics Circle Awards	USA
\.


--
-- Data for Name: crew; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crew (id, title, production_year, contribution) FROM stdin;
00000027	Shakespeare in Love	1998	Costume Design
00000209	The Matrix	1999	Sound Effects Editing
00000205	The Matrix	1999	Visual Effects
00000206	The Matrix	1999	Visual Effects
00000207	The Matrix	1999	Visual Effects
00000208	The Matrix	1999	Visual Effects
00001140	The Piano	1993	Cinematography
00000306	The Piano	1993	Costume Design
00000307	The Piano	1993	Production Design
00000325	Mad Max	1979	Music
00000349	Strictly Ballroom	1992	Costume Design
00000348	Strictly Ballroom	1992	Production Design
00000347	Strictly Ballroom	1992	Editing
00000545	Alien	1979	Music
00000546	Alien	1979	Production Design
00000547	Alien	1979	Special Effects
00000562	Aliens	1986	Sound Editor
00000563	Aliens	1986	Visual Effects
00000564	Aliens	1986	Visual Effects
00000006	Titanic	1997	Set Decorator
00000007	Titanic	1997	Cinematography
00000008	Titanic	1997	Costume Design
00000009	Titanic	1997	Visual Effects
00000010	Titanic	1997	Sound Effects
00000011	Titanic	1997	Editing
00000012	Titanic	1997	Music
00000013	Titanic	1997	Song Lyric
00001009	Titanic	1997	Song Lyric
00001009	Titanic	1998	Song Lyric
00001009	Bullets Over Broadway	1994	producer
00001010	Bullets Over Broadway	1994	cinematography
00001011	Bullets Over Broadway	1994	film editing
00001012	Bullets Over Broadway	1994	casting
00001013	Bullets Over Broadway	1994	costume design
00001019	Tombstone	1993	producer
00001020	Tombstone	1993	cinematography
00001021	Tombstone	1993	film editing
00001022	Tombstone	1993	casting
00001023	Tombstone	1993	costume design
00001009	Alice	1990	producer
00001010	Alice	1990	cinematography
00001011	Alice	1990	film editing
00001012	Alice	1990	casting
00001013	Alice	1990	costume design
00001032	Mermaids	1990	producer
00001033	Mermaids	1990	cinematography
00001034	Mermaids	1990	film editing
00001035	Mermaids	1990	casting
00001036	Mermaids	1990	costume design
00001041	Exotica	1994	producer
00001042	Exotica	1994	cinematography
00001043	Exotica	1994	film editing
00001047	Red Rock West	1992	producer
00001048	Red Rock West	1992	cinematography
00001049	Red Rock West	1992	film editing
00001050	Red Rock West	1992	costume design
00001056	Chaplin	1992	cinematography
00001057	Chaplin	1992	film editing
00001058	Chaplin	1992	casting
00001059	Chaplin	1992	costume design
00001065	Fearless	1993	producer
00001066	Fearless	1993	cinematography
00001067	Fearless	1993	film editing
00001068	Fearless	1993	casting
00001069	Fearless	1993	costume design
00001074	Threesome	1994	producer
00001075	Threesome	1994	cinematography
00001076	Threesome	1994	film editing
00001077	Threesome	1994	casting
00001078	Threesome	1994	costume design
00001079	Jungle Fever	1991	producer
00001082	Jungle Fever	1991	cinematography
00001083	Jungle Fever	1991	film editing
00001084	Jungle Fever	1991	casting
00001085	Jungle Fever	1991	costume design
00001091	Internal Affairs	1990	producer
00001092	Internal Affairs	1990	cinematography
00001093	Internal Affairs	1990	film editing
00001094	Internal Affairs	1990	casting
00001095	Internal Affairs	1990	costume design
00001096	Single White Female	1992	producer
00001101	Single White Female	1992	cinematography
00001102	Single White Female	1992	film editing
00001103	Single White Female	1992	costume design
00001104	Trust	1990	producer
00001107	Trust	1990	cinematography
00001108	Trust	1990	film editing
00001109	Trust	1990	costume design
00001114	Ju Dou	1990	producer
00001115	Ju Dou	1990	cinematography
00001116	Ju Dou	1990	film editing
00001117	Ju Dou	1990	costume design
00001121	Dahong Denglong Gaogao Gua	1991	producer
00001122	Dahong Denglong Gaogao Gua	1991	cinematography
00001123	Dahong Denglong Gaogao Gua	1991	film editing
00001127	Cyrano de Bergerac	1990	producer
00001128	Cyrano de Bergerac	1990	cinematography
00001129	Cyrano de Bergerac	1990	film editing
00001130	Cyrano de Bergerac	1990	costume design
00001010	Manhattan Murder Mystery	1993	cinematography
00001011	Manhattan Murder Mystery	1993	film editing
00001012	Manhattan Murder Mystery	1993	casting
00001013	Manhattan Murder Mystery	1993	costume design
00001132	El Mariachi	1992	producer
00001139	Once Were Warriors	1994	producer
00001140	Once Were Warriors	1994	cinematography
00001141	Once Were Warriors	1994	film editing
00001142	Once Were Warriors	1994	casting
00001147	Priest	1994	producer
00001148	Priest	1994	cinematography
00001149	Priest	1994	film editing
00001150	Priest	1994	casting
00001154	Pump Up the Volum	1990	producer
00001155	Pump Up the Volum	1990	cinematography
00001156	Pump Up the Volum	1990	film editing
00001157	Pump Up the Volum	1990	casting
00001162	Benny and Joon	1993	cinematography
00001163	Benny and Joon	1993	film editing
00001164	Benny and Joon	1993	casting
00001165	Six Degrees of Separation	1993	producer
00001170	Six Degrees of Separation	1993	cinematography
00001171	Six Degrees of Separation	1993	film editing
00001172	Six Degrees of Separation	1993	casting
00001177	Bawang Bie Ji	1993	producer
00001178	Bawang Bie Ji	1993	film editing
00001179	In the Line of Fire	1993	producer
00001184	In the Line of Fire	1993	cinematography
00001185	In the Line of Fire	1993	casting
00001186	Heavenly Creatures	1994	producer
00001189	Heavenly Creatures	1994	cinematography
00001190	Heavenly Creatures	1994	film editing
00001194	Hoop Dreams	1994	producer
00001199	Seven	1995	cinematography
00001200	Seven	1995	film editing
00001201	Seven	1995	casting
00001207	Shallow Grave	1994	producer
00001208	Shallow Grave	1994	cinematography
00001209	Shallow Grave	1994	film editing
00001212	French Kiss	1995	producer
00001215	French Kiss	1995	cinematography
00001216	French Kiss	1995	film editing
00001190	Braindead	1992	producer
00001220	Braindead	1992	cinematography
00001221	Clerks	1994	producer
00001224	Clerks	1994	cinematography
00001185	Apollo 13	1995	casting
00001230	Apollo 13	1995	producer
00001231	Apollo 13	1995	cinematography
00001232	Reservoir Dogs	1992	producer
00001236	Reservoir Dogs	1992	film editing
00001237	Reservoir Dogs	1992	casting
00001240	Pulp Fiction	1994	producer
00001236	Pulp Fiction	1994	film editing
00001252	Short Cuts	1993	producer
00001255	Short Cuts	1993	cinematography
00001253	Short Cuts	1993	film editing
00001258	Legends of the Fall	1994	cinematography
00001259	Legends of the Fall	1994	film editing
00001260	Legends of the Fall	1994	casting
00001265	Natural Born Killers	1994	film editing
00001266	Natural Born Killers	1994	costume design
00001268	In the Mouth of Madness	1995	producer
00001272	In the Mouth of Madness	1995	cinematography
00001273	In the Mouth of Madness	1995	film editing
00001278	Forrest Gump	1994	producer
00001279	Forrest Gump	1994	cinematography
00001280	Forrest Gump	1994	casting
00001082	Malcolm X	1992	cinematography
00001084	Malcolm X	1992	casting
00001283	Malcolm X	1992	film editing
00001287	Dead Again	1991	producer
00001288	Dead Again	1991	cinematography
00001289	Dead Again	1991	film editing
00001290	Dead Again	1991	casting
00001295	Jurassic Park	1993	producer
00001296	Jurassic Park	1993	film editing
00001185	Jurassic Park	1993	casting
00001301	Clueless	1995	producer
00001302	Clueless	1995	cinematography
00001303	Clueless	1995	film editing
00001304	Clueless	1995	casting
00001305	Shadowlands	1993	producer
00001309	Shadowlands	1993	cinematography
00001310	Shadowlands	1993	film editing
00001311	Shadowlands	1993	casting
00001104	Amateur	1994	producer
00001314	Amateur	1994	film editing
00001315	Amateur	1994	casting
00001316	Amateur	1994	costume design
00001321	GoodFellas	1990	producer
00001322	GoodFellas	1990	cinematography
00001323	GoodFellas	1990	film editing
00001328	Little Women	1994	producer
00001329	Little Women	1994	cinematography
00001330	Little Women	1994	film editing
00001335	While You Were Sleeping	1995	producer
00001336	While You Were Sleeping	1995	film editing
00001337	While You Were Sleeping	1995	casting
00001345	Psycho	1998	Music
00001345	Psycho	1960	Music
00001012	Gladiator	2002	casting
00001011	Gladiator	2002	casting
00001010	Gladiator	2002	casting
\.


--
-- Data for Name: crew_award; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crew_award (id, title, production_year, award_name, year_of_award, category, result) FROM stdin;
00001013	Bullets Over Broadway	1994	Oscar	1995	Best Costume Design	nominated
00001059	Chaplin	1992	BAFTA Film Award	1993	Best Costume Design	nominated
00000209	The Matrix	1999	Oscar	1999	Sound Effects Editing	won
00000205	The Matrix	1999	Oscar	1999	Visual Effects	won
00000206	The Matrix	1999	Oscar	1999	Visual Effects	won
00000207	The Matrix	1999	Oscar	1999	Visual Effects	won
00000208	The Matrix	1999	Oscar	1999	Visual Effects	won
00000027	Shakespeare in Love	1998	Oscar	1998	Costume Design	won
00001140	The Piano	1993	AFI Award	1993	Cinematography	won
00000306	The Piano	1993	AFI Award	1993	Costume Design	won
00000307	The Piano	1993	AFI Award	1993	Production Design	won
00000307	The Piano	1993	BAFTA Film Award	1994	Production Design	won
00000306	The Piano	1993	BAFTA Film Award	1994	Costume Design	won
00000325	Mad Max	1979	AFI Award	1979	Best Original Music Score	won
00000348	Strictly Ballroom	1992	BAFTA Film Award	1993	Production Design	won
00000349	Strictly Ballroom	1992	BAFTA Film Award	1993	Costume Design	won
00000348	Strictly Ballroom	1992	AFI Award	1992	Production Design	won
00000349	Strictly Ballroom	1992	AFI Award	1992	Costume Design	won
00000347	Strictly Ballroom	1992	AFI Award	1992	Editing	won
00000547	Alien	1979	Oscar	1980	Special Effects	won
00000546	Alien	1979	BAFTA Film Award	1980	Production Design	won
00000545	Alien	1979	BAFTA Film Award	1980	Sound Track	won
00000562	Aliens	1986	Oscar	1987	Sound Effects	won
00000563	Aliens	1986	Oscar	1987	Visual Effects	won
00000564	Aliens	1986	BAFTA Film Award	1987	Visual Effects	won
00000006	Titanic	1997	Oscar	1998	Set Decorating	won
00000007	Titanic	1997	Oscar	1998	Cinematography	won
00000008	Titanic	1997	Oscar	1998	Costume Design	won
00000009	Titanic	1997	Oscar	1998	Visual Effects	won
00000010	Titanic	1997	Oscar	1998	Sound Effects	won
00000011	Titanic	1997	Oscar	1998	Editing	won
00000012	Titanic	1997	Oscar	1998	Music	won
00000013	Titanic	1997	Oscar	1998	Song Lyric	won
00000011	Titanic	1997	Eddie	1998	Editing	won
00001130	Cyrano de Bergerac	1990	Oscar	1991	Best Costume Design	won
00001128	Cyrano de Bergerac	1990	BAFTA Film Award	1992	Best Cinematography	won
00001130	Cyrano de Bergerac	1990	BAFTA Film Award	1992	Best Costume Design	won
\.


--
-- Data for Name: director; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.director (id, title, production_year) FROM stdin;
00000001	Titanic	1997
00000021	Shakespeare in Love	1998
00000021	Shakespeare in Love	1999
00000041	The Cider House Rules	1999
00001051	Gandhi	1982
00000081	American Beauty	1999
00000101	Affliction	1997
00000121	Life is Beautiful	1997
00000141	Boys Dont Cry	1999
00001291	Saving Private Ryan	1998
00000181	The Birds	1963
00000181	Rear Window	1954
00000201	The Matrix	1999
00000241	The Price of Milk	2000
00000261	The Footstep Man	1992
00000241	Topless Women Talk About Their Lives	1997
00000301	The Piano	1993
00000321	Mad Max	1979
00000341	Strictly Ballroom	1992
00000361	My Mother Frank	2000
00000381	American Psycho	2000
00000401	Scream 2	1997
00000401	Scream 3	2000
00000441	Traffic	2000
00000321	Traffic	2001
00000181	Psycho	1960
00000481	I Know What You Did Last Summer	1997
00000501	Cruel Intentions	1999
00000521	Wild Things	1998
00000541	Alien	1979
00000001	Aliens	1986
00001038	Alien 3	1992
00000601	Alien: Resurrection	1997
00000541	Gladiator	2000
00000001	Gladiator	2001
00000641	The World Is Not Enough	1999
00000661	Heat	1995
00000681	American History X	1998
00000401	Fight Club	1999
00000222	Fight Club	2000
00000441	Out of Sight	1998
00000741	Entrapment	1999
00000661	The Insider	1999
00000781	The Blair Witch Project	1999
00000801	Lethal Weapon 4	1998
00000821	The Fifth Element	1997
00000841	The Sixth Sense	1999
00000841	Unbreakable	2000
00000881	Armageddon	1998
00001331	The Kid	2000
00000921	Twelve Monkeys	1995
00000222	You have Got Mail	1998
00000941	Toy Story	1995
00000961	Proof of Life	2000
00001131	Hanging Up	2000
00001005	Bullets Over Broadway	1994
00001005	Bullets Over Broadway	1995
00001014	Tombstone	1993
00001005	Alice	1990
00001027	Mermaids	1990
00001037	Exotica	1994
00001044	Red Rock West	1992
00001051	Chaplin	1992
00001060	Fearless	1993
00001070	Threesome	1994
00001079	Jungle Fever	1991
00001086	Internal Affairs	1990
00001096	Single White Female	1992
00001104	Trust	1990
00001110	Ju Dou	1990
00001110	Dahong Denglong Gaogao Gua	1991
00001124	Cyrano de Bergerac	1990
00001005	Manhattan Murder Mystery	1993
00001132	El Mariachi	1992
00001135	Once Were Warriors	1994
00001143	Priest	1994
00001151	Pump Up the Volum	1990
00001158	Benny and Joon	1993
00001165	Six Degrees of Separation	1993
00001173	Bawang Bie Ji	1993
00001179	In the Line of Fire	1993
00001186	Heavenly Creatures	1994
00001191	Hoop Dreams	1994
00001195	Seven	1995
00001202	Shallow Grave	1994
00001210	French Kiss	1995
00001186	Braindead	1992
00001221	Clerks	1994
00001225	Apollo 13	1995
00001232	Reservoir Dogs	1992
00001232	Pulp Fiction	1994
00001248	Short Cuts	1993
00001254	Legends of the Fall	1994
00001261	Natural Born Killers	1994
00001267	In the Mouth of Madness	1995
00001274	Forrest Gump	1994
00001079	Malcolm X	1992
00001284	Dead Again	1991
00001291	Jurassic Park	1993
00001297	Clueless	1995
00001305	Shadowlands	1993
00001104	Amateur	1994
00001317	GoodFellas	1990
00001324	Little Women	1994
00001331	While You Were Sleeping	1995
00001343	Psycho	1998
00000621	Gladiator	2002
\.


--
-- Data for Name: director_award; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.director_award (title, production_year, award_name, year_of_award, category, result) FROM stdin;
Bullets Over Broadway	1994	Oscar	1995	Best Director	nominated
Saving Private Ryan	1998	Oscar	1998	Directing	won
American Beauty	1999	Oscar	1999	Directing	won
The Piano	1993	AFI Award	1993	Best Director	won
Strictly Ballroom	1992	AFI Award	1992	Best Director	won
Titanic	1997	Oscar	1998	Best Director	won
Traffic	2000	Oscar	2001	Best Director	won
Gladiator	2002	Oscar	2003	Best Director	nominated
Gladiator	2002	AFI Award	2003	Best Director	nominated
Gladiator	2002	ALFS Award	2003	Best Director	nominated
Gladiator	2002	Golden Globe Awards	2003	Best Director	won
Bullets Over Broadway	1994	Golden Globe Awards	1995	Best Director	won
Fight Club	2000	Golden Globe Awards	2001	Best Director	won
\.


--
-- Data for Name: movie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie (title, production_year, country, run_time, major_genre) FROM stdin;
Titanic	1997	USA	195	romance
Titanic	1998	USA	195	romance
Shakespeare in Love	1998	UK	122	romance
Shakespeare in Love	1999	UK	122	romance
The Cider House Rules	1999	USA	125	drama
The Cider House Rules	2000	USA	125	drama
Gandhi	1982	India	188	drama
American Beauty	1999	USA	121	drama
Affliction	1997	USA	113	drama
Life is Beautiful	1997	Italy	118	comedy
Boys Dont Cry	1999	USA	118	drama
Saving Private Ryan	1998	USA	170	action
The Birds	1963	USA	119	horror
The Matrix	1999	USA	136	action
Toy Story	1995	USA	81	animation
You have Got Mail	1998	USA	119	comedy
Proof of Life	2000	USA	135	drama
Hanging Up	2000	USA	94	comedy
The Price of Milk	2000	New Zealand	87	romance
The Footstep Man	1992	New Zealand	89	drama
Topless Women Talk About Their Lives	1997	New Zealand	87	drama
The Piano	1993	New Zealand	121	romance
Mad Max	1979	Australia	88	action
Strictly Ballroom	1992	Australia	94	comedy
My Mother Frank	2000	Australia	95	comedy
American Psycho	2000	Canada	101	horror
Scream 2	1997	USA	116	horror
Scream 3	2000	USA	116	horror
Traffic	2000	Germany	147	crime
Traffic	2001	Germany	147	crime
Psycho	1960	USA	109	horror
I Know What You Did Last Summer	1997	USA	100	horror
Cruel Intentions	1999	USA	95	romance
Wild Things	1998	USA	108	crime
Alien	1979	UK	117	horror
Aliens	1986	USA	154	action
Alien 3	1992	USA	115	action
Alien: Resurrection	1997	USA	109	action
Gladiator	2000	UK	154	drama
Gladiator	2001	UK	154	romance
The World Is Not Enough	1999	UK	127	action
Heat	1995	USA	171	action
Heat	1996	USA	171	action
American History X	1998	USA	119	drama
Fight Club	1999	Germany	139	drama
Fight Club	2000	USA	139	drama
Out of Sight	1998	USA	122	comedy
Entrapment	1999	Germany	113	action
The Insider	1999	USA	157	drama
The Blair Witch Project	1999	USA	86	drama
Lethal Weapon 4	1998	USA	127	crime
The Fifth Element	1997	USA	126	action
The Sixth Sense	1999	USA	106	thriller
Unbreakable	2000	USA	106	thriller
Armageddon	1998	USA	153	action
The Kid	2000	USA	104	comedy
Twelve Monkeys	1995	USA	129	thriller
Rear Window	1954	USA	112	thriller
Bullets Over Broadway	1994	USA	98	comedy
Bullets Over Broadway	1995	USA	98	comedy
Tombstone	1993	USA	130	western
Alice	1990	USA	106	romance
Mermaids	1990	USA	110	comedy
Exotica	1994	Canada	103	drama
Red Rock West	1992	USA	94	thriller
Chaplin	1992	USA	145	drama
Fearless	1993	USA	122	drama
Threesome	1994	USA	93	comedy
Jungle Fever	1991	USA	132	romance
Internal Affairs	1990	USA	115	thriller
Single White Female	1992	USA	103	thriller
Trust	1990	USA	90	comedy
Ju Dou	1990	China	95	drama
Dahong Denglong Gaogao Gua	1991	China	125	drama
Cyrano de Bergerac	1990	France	135	action
Manhattan Murder Mystery	1993	USA	104	comedy
El Mariachi	1992	Mexico	81	thriller
Once Were Warriors	1994	New Zealand	99	drama
Priest	1994	UK	103	comedy
Pump Up the Volum	1990	USA	105	drama
Benny and Joon	1993	USA	98	comedy
Six Degrees of Separation	1993	USA	101	drama
Bawang Bie Ji	1993	China	157	drama
In the Line of Fire	1993	USA	110	action
Heavenly Creatures	1994	New Zealand	109	thriller
Hoop Dreams	1994	USA	175	documentary
Seven	1995	USA	123	thriller
Shallow Grave	1994	UK	93	thriller
French Kiss	1995	USA	111	comedy
Braindead	1992	New Zealand	104	comedy
Clerks	1994	USA	92	comedy
Apollo 13	1995	USA	140	action
Reservoir Dogs	1992	USA	100	thriller
Pulp Fiction	1994	USA	154	crime
Short Cuts	1993	USA	187	drama
Legends of the Fall	1994	USA	133	romance
Natural Born Killers	1994	USA	118	violence
In the Mouth of Madness	1995	USA	95	horror
Forrest Gump	1994	USA	142	comedy
Malcolm X	1992	USA	194	drama
Dead Again	1991	USA	107	thriller
Jurassic Park	1993	USA	127	action
Clueless	1995	USA	97	comedy
Shadowlands	1993	UK	131	drama
Amateur	1994	USA	105	thriller
GoodFellas	1990	USA	146	violence
Little Women	1994	USA	115	drama
While You Were Sleeping	1995	USA	103	romance
Psycho	1998	USA	105	horror
Twilight	1998	USA	94	thriller
Twilight	2008	USA	121	romance
The Avengers	1998	USA	89	action
The Avengers	2012	USA	143	action
Bad Boys	1983	USA	123	drama
Bad Boys	1995	USA	119	action
Gladiator	2002	UK	130	drama
The Birds	1966	UK	120	horror
\.


--
-- Data for Name: movie_award; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_award (title, production_year, award_name, year_of_award, category, result) FROM stdin;
Strictly Ballroom	1992	BAFTA Film Award	1993	best film	nominated
Ju Dou	1990	Oscar	1991	Best Foreign Language Film	nominated
Dahong Denglong Gaogao Gua	1991	Oscar	1992	Best Foreign Language Film	nominated
Cyrano de Bergerac	1990	Oscar	1991	Best Foreign Language Film	nominated
Cyrano de Bergerac	1990	BAFTA Film Award	1992	Best Film not in the English Language	nominated
Bawang Bie Ji	1993	Oscar	1994	Best Foreign Language Film	nominated
Gladiator	2000	Oscar	2001	best picture	won
Gladiator	2000	BAFTA Film Award	2001	best film	won
Gladiator	2000	Golden Globe Awards	2001	Best Motion Picture Drama	won
Traffic	2000	NYFCC Award	2000	Best Film	won
Shakespeare in Love	1998	BAFTA Film Award	1999	best film	won
American Beauty	1999	BAFTA Film Award	2000	best film	won
Gandhi	1982	BAFTA Film Award	1983	best film	won
American Beauty	1999	Oscar	1999	best picture	won
The Piano	1993	AFI Award	1993	best film	won
Strictly Ballroom	1992	AFI Award	1992	best film	won
Titanic	1997	Oscar	1998	best picture	won
Dahong Denglong Gaogao Gua	1991	BAFTA Film Award	1993	Best Film not in the English Language	won
Dahong Denglong Gaogao Gua	1991	NYFCC Award	1992	Best Foreign Language Film	won
Cyrano de Bergerac	1990	Golden Globe Awards	1991	Best Foreign Language Film	won
Cyrano de Bergerac	1990	ALFS Award	1991	Foreign Language Film of the Year	won
Bawang Bie Ji	1993	BAFTA Film Award	1994	Best Film not in the English Language	won
Bawang Bie Ji	1993	Golden Globe Awards	1994	Best Foreign Language Film	won
Bawang Bie Ji	1993	NYFCC Award	1993	Best Foreign Language Film	won
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person (id, first_name, last_name, year_born) FROM stdin;
00001001	James	Stewart	1908
00001002	Grace	Kelly	1929
00001003	Raymond	Burr	1917
00001004	John Michael	Hayes	1919
00000982	Delia	Ephron	1943
00000983	Lisa	Kudrow	1963
00000961	Taylor	Hackford	1945
00000962	Tony	Gilroy (I)	1962
00000963	David	Morse	1953
00000941	John	Lasseter	1957
00000942	Tim	Allen	1953
00000943	Annie	Potts	1952
00000921	Terry	Gilliam	1940
00000922	Chris	Marker	1921
00000923	Joseph	Melito	1932
00000902	Audrey	Wells	1961
00000903	Spencer	Breslin	1992
00000904	Emily	Mortimer	1971
00000881	Michael	Bay	1965
00000882	Robert	Roy Pool	1957
00000883	Billy	Bob Thornton	1955
00000884	Liv	Tyler	1977
00000862	Spencer	Clark	1987
00000841	M. Night	Shyamalan	1970
00000842	Haley	Joel Osment	1988
00000843	Toni	Collette	1972
00000821	Luc	Besson	1959
00000822	Bruce	Willis	1955
00000823	Gary	Oldman	1958
00000824	Milla	Jovovich	1975
00000801	Richard	Donner	1930
00000802	Jonathan	Lemkin	1948
00000803	Danny	Glover	1946
00000781	Daniel	Myrick	1964
00000782	Heather	Donahue	1974
00000783	Joshua	Leonard	1975
00000784	Michael	C. Williams	1973
00000761	Marie	Brenner	1963
00000762	Diane	Venora	1952
00000741	Jon	Amiel	1948
00000742	Ronald	Bass	1943
00000743	Sean	Connery	1930
00000744	Ving	Rhames	1961
00000721	Elmore	Leonard	1925
00000722	George	Clooney	1961
00000723	Jim	Robinson (I)	1947
00000724	Jennifer	Lopez	1970
00000701	Chuck	Palahniuk	1955
00000703	Meat	Loaf	1951
00000681	Tony	Kaye (I)	1968
00000682	David 	McKenna	1968
00000683	Edward	Norton	1969
00000684	Edward	Furlong	1977
00000685	Beverly	DAngelo	1969
00000661	Michael	Mann	1943
00000662	Al	Pacino	1940
00000663	Robert	De Niro	1943
00000641	Michael	Apted	1941
00000642	Neal	Purvis	1950
00000643	Pierce	Brosnan	1953
00000644	Sophie	Marceau	1966
00000645	Denise	Richards	1972
00000621	David	H. Franzoni	1967
00000622	Russell	Crowe	1964
00000623	Joaquin	Phoenix	1974
00000624	Connie	Nielsen	1965
00000601	Jean-Pierre	Jeunet	1955
00000602	Joss	Whedon	1964
00000604	Dominique	Pinon	1955
00000582	Vincent	Ward	1956
00000583	Charles	Dutton	1951
00000584	Charles	Dance	1946
00000561	Carrie	Henn	1976
00000562	Don	Sharpe	1968
00000563	Suzanne	M. Benson	1959
00000564	Brian	Johnson (I)	1970
00000541	Ridley	Scott	1937
00000542	Dan	OBannon	1946
00000543	Tom	Skerritt	1933
00000544	Sigourney	Weaver	1949
00000545	Derrick	Leather	1960
00000546	Michael	Seymour (I)	1958
00000547	Nick	Allder	1963
00000521	John	McNaughton	1950
00000522	Stephen 	Peters	1947
00000524	Matt	Dillon	1964
00000501	Roger	Kumble	1966
00000502	Choderlos	de Laclos	1741
00000503	Reese	Witherspoon	1976
00000504	Selma	Blair	1972
00000481	Jim	Gillespie (I)	1968
00000482	Lois	Duncan	1972
00000483	Jennifer	Love Hewitt	1979
00000484	Ryan	Phillippe	1974
00000485	Sarah	Michelle Gellar	1977
00000461	Robert	Bloch	1917
00000462	Anthony	Perkins	1932
00000463	Vera	Miles	1929
00000464	Janet	Leigh	1927
00000465	John	Gavin	1928
00000466	Paul	Jasmin	1921
00000441	Steven	Soderbergh	1963
00000442	Stephen	Gaghan	1956
00000443	Michael	Douglas	1944
00000444	Benicio	Del Toro	1967
00000445	Catherine	Zeta-Jones	1969
00000446	Stephen	Bauer	1956
00000447	Luis	Guzman	1967
00000448	Amy	Irving	1953
00000449	Erika	Christensen	1982
00000450	Don	Cheadle	1964
00000451	Jacob	Vargas	1963
00000452	Clifton	Collins	1971
00000421	Liev	Schreiber	1967
00000422	Beth	Toussaint	1962
00000423	Roger	Jackson	1965
00000424	Kelly	Rutherford	1968
00000401	Wes	Craven	1939
00000402	Kevin	Williamson	1965
00000403	David	Arquette	1971
00000404	Neve	Campbell	1973
00000405	Courteney	Cox	1964
00000381	Mary	Harron (I)	1966
00000382	Bret	Easton Ellis	1964
00000383	Christian	Bale	1974
00000384	Willem	Dafoe	1955
00000385	Jared	Leto	1971
00000361	Mark	Lamprell	1950
00000362	Nicholas	Bishop	1974
00000363	Rose	Byrne	1953
00000364	Sinead	Cusack	1948
00000341	Baz	Luhrmann	1942
00000342	Craig	Pearce	1948
00000343	Paul	Mercurio	1963
00000344	Tara	Morice	1967
00000345	Pat	Thompson (II)	1940
00000346	Barry	Otto	1965
00000347	Jill	Bilcock	1967
00000348	Catherine	Martin (I)	1950
00000349	Angus	Strathie	1954
00000321	George	Miller (II)	1945
00000322	James	McCausland	1943
00000323	Mel	Gibson	1956
00000324	Joanne	Samuel	1951
00000325	Brian	May (I)	1934
00000001	James	Cameron	1954
00000002	Leonardo	DiCaprio	1974
00000004	Billy	Zane	1966
00000005	Kathy	Bates	1948
00000006	Michael	Ford (I)	1966
00000007	Russell	Carpenter	1971
00000008	Deborah	Lynn Scott	1968
00000009	Thomas	L.Fisher	1956
00000010	Tom	Bellfort	1964
00000011	Conrad	Buff IV	1956
00000012	James	Horner	1953
00000013	Will	Jennings (II)	1961
00000021	John	Madden	1949
00000022	Marc	Norman	1952
00000023	Geoffrey	Rush	1951
00000025	Steve	ODonnell	1956
00000026	Judi	Dench	1934
00000027	Sandy	Powell	1940
00000041	Lasse	Hallstrom	1946
00000042	John	Irving	1942
00000043	Kate	Nelligan	1950
00000044	Tobey	Maguire	1975
00000045	Charlize	Theron	1975
00000046	Delroy	Lindo	1952
00000047	Michael	Caine	1958
00000062	John	Briley	1925
00000063	Ben	Kingsley	1943
00000064	Candice	Bergen	1946
00000065	Roshan	Seth	1942
00000066	Edward	Fox	1937
00000081	Sam	Mendes	1965
00000082	Alan	Ball	1957
00000083	Kevin	Spacey	1959
00000084	Annette	Bening	1958
00000085	Thora	Birch	1982
00000086	Wes	Bentley	1978
00000101	Paul	Schrader	1946
00000102	Russell	Banks	1940
00000103	Nick	Nolte	1941
00000104	Brigid	Tierney	1948
00000105	Holmes	Osborne	1950
00000106	Jim	True	1945
00000107	James	Coburn	1928
00000121	Roberto	Benigini	1952
00000122	Vincenzo	Cerami	1940
00000123	Nicoletta	Braschi	1960
00000141	Kimberly	Peirce	1967
00000142	Andy	Bienen	1965
00000143	Hilary	Swank	1974
00000144	Chloe	Sevigny	1974
00000145	Peter	Sarsgaard	1972
00000146	Brendan	Sexton III	1980
00000162	Robert	Rodat	1953
00000164	Tom	Sizemore	1964
00000165	Edwards	Burns	1968
00000166	Barry	Pepper	1970
00000181	Alfred	Hitchcock	1932
00000182	Daphne	Du Maurier	1940
00000183	Evan	Hunter	1937
00000184	Rod	Taylor	1935
00000185	Jessica	Tandy	1941
00000186	Suzanne	Pleshette	1938
00000187	Tippi	Hedren	1931
00000201	Andy	Wachowski	1965
00000202	Larry	Wachowski	1968
00000203	Keanu	Reeves	1972
00000204	Laurence	Fishburne	1970
00000205	John	Gaeta	1962
00000206	Janek	Sirrs	1957
00000207	Steve	Courtley	1961
00000208	Jon	Thum	1956
00000209	Dane	A.davis	1966
00000222	Nora	Ephron	1941
00000223	Parker	Posey	1968
00000241	Harry	Sinclair (II)	1965
00000242	Danielle	Cormack	1959
00000243	Karl	Urban	1972
00000244	Willa	ONeill	1970
00000261	Leon	Narbey	1958
00000262	Stephen	Grives	1971
00000263	Jennifer	Ward-Lealand	1966
00000264	Michael	Hurst (I)	1957
00000281	Joel	Tobeck	1971
00000282	Ian	Hughes (I)	1968
00000301	Jane	Campion	1954
00000302	Holly	Hunter	1958
00000304	Anna	Paquin	1982
00000306	Janet	Patterson	1967
00000307	Andrew	McAlpine	1962
00001005	Woody	Allen	1935
00001006	John	Cusack	1966
00001007	Jack	Warden	1920
00001008	Tony	Sirico	1942
00001009	Robert	Greenhut	1943
00001010	Carlo	DiPalma	1925
00001011	Susan E.	Morse	1930
00001012	Juliet	Taylor	1967
00001013	Jeffrey	Kurland	1958
00001014	George P.	Cosmatos	1941
00001015	Kevin	Jarre	1938
00001016	Kurt	Russell	1951
00001017	Val	Kilmer	1959
00001018	Sam	Elliott	1944
00001019	Sean	Daniel	1951
00001020	William A.	Fraker	1923
00001021	Harvey	Rosenstock	1935
00001022	Lora	Kennedy	1940
00001023	Joseph A.	Porro	1943
00001024	Joe	Mantegna	1947
00001025	Mia	Farrow	1945
00001026	William	Hurt	1950
00001027	Richard	Benjamin	1938
00001028	Patty	Dann	1942
00001029	Cherilyn	LaPierre	1946
00001030	Bob	Hoskins	1942
00001031	Winona	Ryder	1971
00001032	Lauren	Lloyd	1941
00001033	Howard	Atherton	1938
00001034	Jacqueline	Cambas	1952
00001035	Margery	Simkin	1947
00001036	Marit	Allen	1954
00001037	Atom	Egoyan	1960
00001038	David	Hemblen	1958
00001039	Don	Mckellar	1963
00001040	Mia	Kirshner	1976
00001041	Paul	Sarossy	1963
00001042	Susan	Shipton	1959
00001043	Linda	Muir	1960
00001044	John	Dahl	1956
00001045	Nicolas	Cage	1964
00001046	Craig	Reay	1967
00001047	Steve	Golin	1958
00001048	Marc	Reshovsky	1965
00001049	Scott	Chestnut	1959
00001050	Terry	Dresbach	1964
00001051	Richard	Attenborough	1923
00001052	Charles	Chaplin	1889
00001053	Robert	Downey Jr.	1965
00001054	Geraldine	Chaplin	1944
00001055	Paul	Rhys	1963
00001056	Sven	Nykvist	1922
00001057	Anne V.	Coates	1925
00001058	Mike	Fenton	1947
00001059	Ellen	Mirojnick	1949
00001060	Peter	Weir	1944
00001061	Rafael	Yglesias	1954
00001062	Jeff	Bridges	1949
00001063	Isabella	Rossellini	1952
00001064	Rosie	Perez	1964
00001065	Mark	Rosenberg	1948
00001066	Allen	Daviau	1953
00001067	Bill	Anderson	1962
00001068	Howard	Feuer	1965
00001069	Marilyn	Matthews	1955
00001070	Andrew	Fleming	1946
00001071	Lara	Boyle	1970
00001072	Stephen	Baldwin	1966
00001073	Josh	Charles	1971
00001074	Brad	Krevoy	1967
00001075	Alexander	Gruszynski	1954
00001076	Bill	Carruth	1949
00001077	Ed	Mitchell	1955
00001078	Deborah	Everton	1962
00001079	Spike	Lee	1957
00001080	Wesley	Snipes	1962
00001081	Annabella	Sciorra	1964
00001082	Ernest R.	Dickerson	1952
00001083	Samuel D.	Pollard	1963
00001084	Robi	Reed	1954
00001085	Ruth E.	Carter	1968
00001086	Mike	Figgis	1948
00001087	Henry	Bean	1943
00001088	Richard	Gere	1949
00001089	Andy	Carcia	1956
00001090	Nancy	Travis	1961
00001091	Frank	Mancuso	1958
00001092	John	Alonzo	1934
00001093	Robert	Estrin	1942
00001094	Carrie	Frazier	1947
00001095	Rudy	Dillon	1950
00001096	Barbet	Schroeder	1941
00001097	John	Lutz	1948
00001098	Bridget	Fonda	1964
00001099	Jennifer	Leigh	1962
00001100	Steven	Weber	1961
00001101	Luciano	Tovoli	1965
00001102	Lee	Percy	1971
00001103	Milena	Canonero	1965
00001104	Hal	Hartley	1959
00001105	Adrienne	Shelly	1966
00001106	Martin	Donovan	1957
00001107	Michael	Spiller	1961
00001108	Nick	Gomez	1963
00001109	Claudia	Brown	1962
00001110	Yimou	Zhang	1951
00001111	Heng	Liu	1964
00001112	Li	Gong	1965
00001113	Baotian	Li	1950
00001114	Hu	Jian	1962
00001115	Changwei	Gu	1965
00001116	Yuan	Du	1955
00001117	Zhi-an	Zhang	1963
00001118	Su	Tong	1957
00001119	Jingwu	Ma	1947
00001120	Caifei	He	1965
00001121	Fu-Sheng	Chiu	1956
00001122	Zhao	Fei	1952
00001123	Yuan	Du	1967
00001124	Jean-Paul	Rappeneau	1932
00001125	Gerard	Depardieu	1948
00001126	Anne	Brochet	1966
00001127	Rene	Cleitman	1940
00001128	Pierre	Lhomme	1930
00001129	Noelle	Boisson	1942
00001130	Franca	Squarciapion	1943
00001131	Diane	Keaton	1946
00001132	Robert	Rodriguez	1968
00001133	Carlos	Gallardo	1966
00001134	Consuelo	Gomez	1958
00001135	Lee	Tamahori	1950
00001136	Riwia	Brown	1953
00001137	Rena	Owen	1960
00001138	Temuera	Morrison	1961
00001139	Robin	Scholes	1965
00001140	Stuart	Dryburgh	1952
00001141	D.Michael	Horton	1958
00001142	Don	Selwyn	1960
00001143	Antonia	Bird	1963
00001144	Jimmy	McGovern	1949
00001145	Linus	Roache	1964
00001146	Tom	Wilkinson	1959
00001147	George	Faber	1961
00001148	Fred	Tammes	1963
00001149	Susan	Spivey	1957
00001150	Janet	Goddard	1965
00001151	Allan	Moyle	1947
00001152	Christian	Slater	1969
00001153	Samantha	Mathis	1970
00001154	Sandy	Stern	1968
00001155	Walt	Lloyd	1972
00001156	Larry	Bock	1962
00001157	Judith	Holstra	1964
00001158	Jeremiah S.	Chechik	1962
00001159	Barry	Berman	1957
00001160	Johnny	Depp	1963
00001161	Mary	Masterson	1966
00001162	John	Schwartzman	1965
00001163	Carol	Littleton	1957
00001164	Risa	Garcia	1956
00001165	Fred	Schepisi	1939
00001166	John	Guare	1938
00001167	Stockard	Channing	1944
00001168	Will	Smith	1968
00001169	Donald	Sutherland	1935
00001170	Ian	Baker	1947
00001171	Peter	Honess	1951
00001172	Ellen	Chenoweth	1962
00001173	Kaige	Chen	1952
00001174	Lillian	Lee	1954
00001175	Leslie	Cheung	1956
00001176	Fengyi	Zhang	1965
00001177	Feng	Hsu	1948
00001178	Xiaonan	Pei	1966
00001179	Wolfgang	Petersen	1941
00001180	Jeff	Maguire	1948
00001181	Clint	Eastwood	1930
00001182	John	Malkovich	1953
00001183	Rene	Russo	1954
00001184	John	Bailey	1942
00001185	Janet	Hirshenson	1950
00001186	Peter	Jackson	1961
00001187	Melanie	Lynskey	1977
00001188	Kate	Winslet	1975
00001189	Alun	Bollinger	1963
00001190	Jamie	Selkirk	1966
00001191	Steve	James	1957
00001192	William	Gates	1968
00001193	Arthur	Agee	1956
00001194	Peter	Gilbert	1963
00001195	David	Fincher	1962
00001196	Andrew	Walker	1964
00001197	Morgan	Freeman	1937
00001198	Brad	Pitt	1963
00001199	Darius	Khondji	1956
00001200	Richard	Francis-Bruce	1948
00001201	Kerry	Barden	1951
00001202	Danny	Boyle	1956
00001203	John	Hodge	1964
00001204	Kerry	Fox	1966
00001205	Christopher	Eccleston	1964
00001206	Ewan	McGregor	1971
00001207	Andrew	Macdonald	1966
00001208	Brian	Tufano	1968
00001209	Masahiro	Hirakubo	1964
00001210	Lawrence	Kasdan	1949
00001211	Adam	Brooks	1956
00001212	Meg	Ryan	1961
00001213	Kevin	Kline	1947
00001214	Timothy	Hutton	1960
00001215	Owen	Roizman	1936
00001216	Joe	Hutshing	1947
00001217	Timothy	Balme	1964
00001218	Diana	Penalver	1967
00001219	Elizabeth	Moody	1957
00001220	Murray	Milne	1959
00001221	Kevin	Smith	1970
00001222	Marilyn	Ghigliotti	1971
00001223	Lisa	Spoonhauer	1968
00001224	David	Klein	1965
00001225	Ron	Howard	1954
00001226	Jim	Lovell	1928
00001227	Tom	Hanks	1956
00001228	Bill	Paxton	1955
00001229	Kevin	Bacon	1958
00001230	Brian	Grazer	1951
00001231	Dean	Cundey	1945
00001232	Quentin	Tarantino	1963
00001233	Harvey	Keitel	1939
00001234	Tom	Roth	1961
00001235	Michael	Madsen	1958
00001236	Sally	Menke	1962
00001237	Ronnie	Yeskel	1967
00001238	John	Travolta	1954
00001239	Samuel	Jackson	1948
00001240	Lawrence	Bender	1958
00001241	Ang	Lee	1954
00001242	Sihung	Lung	1968
00001243	Yu-Wen	Wang	1969
00001244	Chien-lien	Wu	1968
00001245	Kong	Hsu	1956
00001246	Jong	Lin	1969
00001247	Tim	Squyres	1962
00001248	Robert	Altman	1925
00001249	Andie	MacDowell	1958
00001250	Bruce	Davison	1946
00001251	Jack	Lemmon	1925
00001252	Cary	Brokaw	1951
00001253	Geraldine	Peroni	1954
00001254	Edward	Zwick	1952
00001255	Jim	Harrison	1937
00001256	Anthony	Hopkins	1937
00001257	Aidan	Quinn	1959
00001258	John	Toll	1962
00001259	Steven	Rosenblum	1963
00001260	Mary	Colquhoun	1939
00001261	Oliver	Stone	1946
00001262	Woody	Harrelson	1961
00001263	Juliette	Lewis	1973
00001264	Robert	Richardson	1964
00001265	Brain	Berdan	1958
00001266	Richard	Hornung	1950
00001267	John	Carpenter	1948
00001268	Michael	Luca	1951
00001269	Sam	Neil	1947
00001270	Jurgen	Prochnow	1941
00001271	Julie	Carmen	1960
00001272	Gary	Kibbe	1954
00001273	Edward	Warschilka	1949
00001274	Robert	Zemeckis	1952
00001275	Winston	Groom	1944
00001276	Robin	Wright	1966
00001277	Gary	Sinise	1955
00001278	Wendy	Finerman	1953
00001279	Don	Burgess	1957
00001280	Ellen	Lewis	1961
00001281	Denzel	Washington	1954
00001282	Angela	Bassett	1958
00001283	Barry	Brown	1952
00001284	Kenneth	Branagh	1960
00001285	Scott	Frank	1960
00001286	Emma	Thompson	1959
00001287	Lindsay	Doran	1948
00001288	Matthew	Leonetti	1952
00001289	Peter	Berger	1955
00001290	Gail	Levin	1960
00001291	Steven	Spielberg	1946
00001292	Michael	Crichton	1942
00001293	Laura	Dern	1967
00001294	Jeff	Goldblum	1952
00001295	Kathleen	Kennedy	1947
00001296	Michael	Kahn	1924
00001297	Amy	Heckerling	1954
00001298	Alicia	Silverston	1976
00001299	Stacey	Dash	1966
00001300	Brittany	Murphy	1977
00001301	Scott	Rudin	1958
00001302	Bill	Pope	1961
00001303	Debra	Chiate	1970
00001304	Marcia	Ross	1969
00001305	Richard	Attenborough	1923
00001306	William	Nicholson	1948
00001307	Debra	Winger	1955
00001308	Roddy	Maude-Roxby	1930
00001309	Roger	Pratt	1947
00001310	Lesley	Walker	1956
00001311	Lucy	Boulting	1967
00001312	Isabelle	Huppert	1955
00001313	Elina	Lowensohn	1966
00001314	Steven	Hamilton	1968
00001315	Billy	Hopkins	1965
00001316	Alexandra	Welker	1959
00001317	Martin	Scorsese	1942
00001318	Robert	Niro	1943
00001319	Ray	Liotta	1955
00001320	Joe	Pesci	1943
00001321	Irwin	Winkler	1931
00001322	Michael	Ballhaus	1935
00001323	Thelma	Schoonmaker	1940
00001324	Gillian	Armstrong	1950
00001325	Lousia	Alcott	1832
00001326	Gabriel	Byrne	1950
00001327	Trini	Alvarado	1967
00001328	Denise	DiNovi	1955
00001329	Geoffrey	Simpson	1961
00001330	Nicholas	Beauman	1965
00001331	Jon	Turteltaub	1964
00001332	Daniel	Sullivan	1939
00001333	Sandra	Bullock	1964
00001334	Bill	Pullman	1953
00001335	Roger	Birnbaum	1954
00001336	Bruce	Green	1952
00001337	Cathy	Sandrich	1961
00001338	Anne	Heche	1969
00001339	Vince	Vaughn	1970
00001340	Viggo	Mortensen	1958
00001341	Julianne	Moore	1960
00001342	William	Macy	1950
00001343	Gus	Van Sant	1952
00001344	Joseph	Stefano	1922
00001345	Bernard	Herrmann	1911
00001346	Martin	Balsam	1919
\.


--
-- Data for Name: restriction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restriction (title, production_year, description, country) FROM stdin;
Titanic	1997	M	Australia
Titanic	1997	KT	Belgium
Titanic	1997	TE	Chile
Titanic	1997	K-12	Finland
Titanic	1997	U	France
Titanic	1997	12(w)	Germany
Titanic	1997	12	UK
Shakespeare in Love	1998	M	Australia
Shakespeare in Love	1998	U	France
Shakespeare in Love	1998	6(bw)	Germany
Shakespeare in Love	1998	M	New Zealand
Shakespeare in Love	1999	M	Australia
Shakespeare in Love	1999	U	France
Shakespeare in Love	1999	6(bw)	Germany
Shakespeare in Love	1999	M	New Zealand
The Cider House Rules	1999	M	Australia
The Cider House Rules	1999	K-12	Finland
The Cider House Rules	1999	M	New Zealand
The Cider House Rules	1999	U	France
The Cider House Rules	1999	12	Germany
The Price of Milk	2000	M	New Zealand
The Price of Milk	2000	PG-13	USA
Topless Women Talk About Their Lives	1997	M	Australia
The Piano	1993	M	Australia
The Piano	1993	R	USA
Mad Max	1979	R	USA
Mad Max	1979	R	Australia
Strictly Ballroom	1992	PG	Australia
Strictly Ballroom	1992	PG	USA
My Mother Frank	2000	M	Australia
My Mother Frank	2000	M	New Zealand
American Psycho	2000	R18	New Zealand
American Psycho	2000	R	Australia
American Psycho	2000	R	USA
Scream 2	1997	R	USA
Scream 3	2000	R	USA
Scream 3	2000	R18	New Zealand
Traffic	2000	R	USA
Traffic	2000	M	Australia
Psycho	1960	M	Australia
Psycho	1960	R	USA
I Know What You Did Last Summer	1997	M	Australia
I Know What You Did Last Summer	1997	R	USA
Cruel Intentions	1999	R	USA
Cruel Intentions	1999	M	Australia
Wild Things	1998	M	Australia
Wild Things	1998	R	USA
Alien	1979	M	Australia
Alien	1979	R	USA
Aliens	1986	M	Australia
Aliens	1986	R	USA
Alien 3	1992	M	Australia
Alien 3	1992	R	USA
Alien: Resurrection	1997	M	Australia
Alien: Resurrection	1997	R	USA
Gladiator	2000	M	Australia
Gladiator	2000	R	USA
The World Is Not Enough	1999	PG-13	USA
The World Is Not Enough	1999	M	Australia
The World Is Not Enough	1999	M	New Zealand
Heat	1995	R	USA
Heat	1995	M	Australia
American History X	1998	R18	New Zealand
American History X	1998	M	Australia
American History X	1998	R	USA
Fight Club	1999	R	USA
Fight Club	1999	R18	New Zealand
Fight Club	1999	R	Australia
Out of Sight	1998	M	Australia
Out of Sight	1998	R	USA
Entrapment	1999	PG-13	USA
Entrapment	1999	M	New Zealand
Entrapment	1999	M	Australia
The Insider	1999	M	New Zealand
The Insider	1999	R	USA
The Blair Witch Project	1999	R	USA
The Blair Witch Project	1999	M	Australia
Lethal Weapon 4	1998	M	Australia
Lethal Weapon 4	1998	R	USA
The Fifth Element	1997	PG-13	USA
The Fifth Element	1997	PG	Australia
The Sixth Sense	1999	M	Australia
The Sixth Sense	1999	M	New Zealand
The Sixth Sense	1999	PG-13	USA
Unbreakable	2000	PG-13	USA
Unbreakable	2000	M	New Zealand
Unbreakable	2000	M	Australia
Armageddon	1998	M	Australia
Armageddon	1998	PG-13	USA
The Kid	2000	PG	Australia
The Kid	2000	PG	USA
The Kid	2000	PG	New Zealand
Twelve Monkeys	1995	M	Australia
Twelve Monkeys	1995	R	USA
Affliction	1997	R	USA
Affliction	1997	M	Australia
American Beauty	1999	R	USA
American Beauty	1999	M	Australia
American Beauty	1999	R18	New Zealand
Boys Dont Cry	1999	R18	New Zealand
Boys Dont Cry	1999	R	USA
Boys Dont Cry	1999	R	Australia
Gandhi	1982	PG	USA
Hanging Up	2000	PG-13	USA
Hanging Up	2000	M	New Zealand
Life is Beautiful	1997	M	New Zealand
Life is Beautiful	1997	M	Australia
Life is Beautiful	1997	PG-13	USA
Proof of Life	2000	M	New Zealand
Proof of Life	2000	M	Australia
Proof of Life	2000	R	USA
Saving Private Ryan	1998	R	USA
Saving Private Ryan	1998	M	Australia
The Birds	1963	PG	Australia
The Birds	1963	PG-13	USA
Rear Window	1954	PG	Australia
Rear Window	1954	PG	USA
The Matrix	1999	M	New Zealand
The Matrix	1999	M	Australia
The Matrix	1999	R	USA
Toy Story	1995	G	Australia
Toy Story	1995	G	USA
You have Got Mail	1998	PG	USA
Rear Window	1954	16	Germany
Bullets Over Broadway	1994	13	Argentina
Bullets Over Broadway	1994	14	Chile
Bullets Over Broadway	1994	K-12	Finland
Bullets Over Broadway	1994	U	France
Bullets Over Broadway	1994	12	Germany
Bullets Over Broadway	1994	12	Portugal
Bullets Over Broadway	1994	M	Portugal
Bullets Over Broadway	1994	T	Spain
Bullets Over Broadway	1994	11	Sweden
Bullets Over Broadway	1994	15	UK
Bullets Over Broadway	1994	R	USA
Tombstone	1993	M	Australia
Tombstone	1993	K-16	Finland
Tombstone	1993	16	Germany
Tombstone	1993	18	Spain
Tombstone	1993	15	Sweden
Tombstone	1993	15	UK
Tombstone	1993	R	USA
Alice	1990	13	Argentina
Alice	1990	14	Chile
Alice	1990	S	Finland
Alice	1990	U	France
Alice	1990	12	Germany
Alice	1990	Btl	Sweden
Alice	1990	12	UK
Alice	1990	PG-13	USA
Mermaids	1990	13	Argentina
Mermaids	1990	14	Chile
Mermaids	1990	K-12	Finland
Mermaids	1990	U	France
Mermaids	1990	12	Germany
Mermaids	1990	11	Sweden
Mermaids	1990	15	UK
Mermaids	1990	PG-13	USA
Exotica	1994	18	Chile
Exotica	1994	K-16	Finland
Exotica	1994	M	Portugal
Exotica	1994	16	Portugal
Exotica	1994	13	Spain
Exotica	1994	15	Sweden
Exotica	1994	18	UK
Exotica	1994	R	USA
Red Rock West	1992	16	Germany
Red Rock West	1992	T	Spain
Red Rock West	1992	15	UK
Red Rock West	1992	R	USA
Chaplin	1992	13	Argentina
Chaplin	1992	14	Chile
Chaplin	1992	S	Finland
Chaplin	1992	6	Germany
Chaplin	1992	T	Spain
Chaplin	1992	Btl	Sweden
Chaplin	1992	15	UK
Chaplin	1992	PG-13	USA
Fearless	1993	13	Argentina
Fearless	1993	M	Australia
Fearless	1993	KT	Belgium
Fearless	1993	14	Chile
Fearless	1993	K-14	Finland
Fearless	1993	12	Germany
Fearless	1993	12	Netherlands
Fearless	1993	13	Spain
Fearless	1993	15	Sweden
Fearless	1993	15	UK
Fearless	1993	R	USA
Threesome	1994	MA	Australia
Threesome	1994	K-16	Finland
Threesome	1994	16	Germany
Threesome	1994	M	Portugal
Threesome	1994	18	Spain
Threesome	1994	11	Sweden
Threesome	1994	18	UK
Threesome	1994	R	USA
Jungle Fever	1991	K-14	Finland
Jungle Fever	1991	16	Germany
Jungle Fever	1991	18	Spain
Jungle Fever	1991	15	Sweden
Jungle Fever	1991	18	UK
Jungle Fever	1991	R	USA
Internal Affairs	1990	18	Argentina
Internal Affairs	1990	K-16	Finland
Internal Affairs	1990	18	Germany
Internal Affairs	1990	15	Sweden
Internal Affairs	1990	18	UK
Internal Affairs	1990	R	USA
Single White Female	1992	18	Argentina
Single White Female	1992	M	Australia
Single White Female	1992	18	Chile
Single White Female	1992	K-16	Finland
Single White Female	1992	16	Germany
Single White Female	1992	18	Spain
Single White Female	1992	15	Sweden
Single White Female	1992	18	UK
Single White Female	1992	R	USA
Trust	1990	K-14	Finland
Trust	1990	15	Sweden
Trust	1990	R	USA
Ju Dou	1990	18	Chile
Ju Dou	1990	K-12	Finland
Ju Dou	1990	15	Sweden
Ju Dou	1990	PG-13	USA
Dahong Denglong Gaogao Gua	1991	13	Argentina
Dahong Denglong Gaogao Gua	1991	14	Chile
Dahong Denglong Gaogao Gua	1991	12	Germany
Dahong Denglong Gaogao Gua	1991	13	Spain
Dahong Denglong Gaogao Gua	1991	11	Sweden
Dahong Denglong Gaogao Gua	1991	PG	USA
Cyrano de Bergerac	1990	TE	Chile
Cyrano de Bergerac	1990	U	France
Cyrano de Bergerac	1990	11	Sweden
Cyrano de Bergerac	1990	PG	USA
Manhattan Murder Mystery	1993	13	Argentina
Manhattan Murder Mystery	1993	T	Spain
Manhattan Murder Mystery	1993	11	Sweden
Manhattan Murder Mystery	1993	PG	USA
El Mariachi	1992	M	Australia
El Mariachi	1992	K-16	Finland
El Mariachi	1992	18	Germany
El Mariachi	1992	18	Spain
El Mariachi	1992	15	UK
El Mariachi	1992	R	USA
Once Were Warriors	1994	MA	Australia
Once Were Warriors	1994	18	Chile
Once Were Warriors	1994	K-16	Finland
Once Were Warriors	1994	16	Germany
Once Were Warriors	1994	16	Portugal
Once Were Warriors	1994	18	Spain
Once Were Warriors	1994	15	Sweden
Once Were Warriors	1994	18	UK
Once Were Warriors	1994	R	USA
Priest	1994	MA	Australia
Priest	1994	K-16	Finland
Priest	1994	12(w)	Germany
Priest	1994	16	Portugal
Priest	1994	18	Spain
Priest	1994	15	Sweden
Priest	1994	15	UK
Priest	1994	R	USA
Pump Up the Volum	1990	M	Australia
Pump Up the Volum	1990	12	Germany
Pump Up the Volum	1990	15	UK
Pump Up the Volum	1990	R	USA
Benny and Joon	1993	U	France
Benny and Joon	1993	12	Germany
Benny and Joon	1993	T	Spain
Benny and Joon	1993	11	Sweden
Benny and Joon	1993	12	UK
Benny and Joon	1993	PG	USA
Six Degrees of Separation	1993	13	Argentina
Six Degrees of Separation	1993	13	Spain
Six Degrees of Separation	1993	15	UK
Six Degrees of Separation	1993	R	USA
Bawang Bie Ji	1993	18	Chile
Bawang Bie Ji	1993	K-14	Finland
Bawang Bie Ji	1993	12	Germany
Bawang Bie Ji	1993	18	Spain
Bawang Bie Ji	1993	15	Sweden
Bawang Bie Ji	1993	15	UK
Bawang Bie Ji	1993	R	USA
In the Line of Fire	1993	13	Argentina
In the Line of Fire	1993	M	Australia
In the Line of Fire	1993	14	Chile
In the Line of Fire	1993	K-16	Finland
In the Line of Fire	1993	16	Germany
In the Line of Fire	1993	18	Spain
In the Line of Fire	1993	15	Sweden
In the Line of Fire	1993	15	UK
In the Line of Fire	1993	R	USA
Heavenly Creatures	1994	M	Australia
Heavenly Creatures	1994	18	Chile
Heavenly Creatures	1994	K-16	Finland
Heavenly Creatures	1994	16	Germany
Heavenly Creatures	1994	16	Portugal
Heavenly Creatures	1994	18	Spain
Heavenly Creatures	1994	15	Sweden
Heavenly Creatures	1994	18	UK
Heavenly Creatures	1994	R	USA
Hoop Dreams	1994	M	Australia
Hoop Dreams	1994	15	UK
Hoop Dreams	1994	PG-13	USA
Seven	1995	R	Australia
Seven	1995	18	Chile
Seven	1995	K-16	Finland
Seven	1995	16	Germany
Seven	1995	16	Portugal
Seven	1995	18	Spain
Seven	1995	15	Sweden
Seven	1995	18	UK
Seven	1995	R	USA
Shallow Grave	1994	MA	Australia
Shallow Grave	1994	K-16	Finland
Shallow Grave	1994	16	Germany
Shallow Grave	1994	M	Portugal
Shallow Grave	1994	18	Spain
Shallow Grave	1994	15	Sweden
Shallow Grave	1994	18	UK
Shallow Grave	1994	R	USA
French Kiss	1995	PG	Australia
French Kiss	1995	TE	Chile
French Kiss	1995	U	France
French Kiss	1995	6(bw)	Germany
French Kiss	1995	12	Portugal
French Kiss	1995	T	Spain
French Kiss	1995	12	UK
French Kiss	1995	PG-13	USA
Braindead	1992	18	Argentina
Braindead	1992	R	Australia
Braindead	1992	18	Chile
Braindead	1992	18	Germany
Braindead	1992	16	Portugal
Braindead	1992	18	Spain
Braindead	1992	15	Sweden
Braindead	1992	18	UK
Clerks	1994	R	Australia
Clerks	1994	K-12	Finland
Clerks	1994	12	Germany
Clerks	1994	18	Spain
Clerks	1994	Btl	Sweden
Clerks	1994	18	UK
Clerks	1994	R	USA
Apollo 13	1995	13	Argentina
Apollo 13	1995	PG	Australia
Apollo 13	1995	KT	Belgium
Apollo 13	1995	14	Chile
Apollo 13	1995	U	France
Apollo 13	1995	6(bw)	Germany
Apollo 13	1995	12	Portugal
Apollo 13	1995	T	Spain
Apollo 13	1995	PG	USA
Reservoir Dogs	1992	R	Australia
Reservoir Dogs	1992	18	Germany
Reservoir Dogs	1992	R18	New Zealand
Reservoir Dogs	1992	16	Portugal
Reservoir Dogs	1992	18	Spain
Reservoir Dogs	1992	15	Sweden
Reservoir Dogs	1992	18	UK
Reservoir Dogs	1992	R	USA
Pulp Fiction	1994	18	Argentina
Pulp Fiction	1994	R	Australia
Pulp Fiction	1994	18	Chile
Pulp Fiction	1994	16	Germany
Pulp Fiction	1994	16	Portugal
Pulp Fiction	1994	18	Spain
Pulp Fiction	1994	15	Sweden
Pulp Fiction	1994	18	UK
Pulp Fiction	1994	R	USA
Short Cuts	1993	MA	Australia
Short Cuts	1993	K-14	Finland
Short Cuts	1993	U	France
Short Cuts	1993	16	Germany
Short Cuts	1993	18	Spain
Short Cuts	1993	15	Sweden
Short Cuts	1993	18	UK
Short Cuts	1993	R	USA
Legends of the Fall	1994	13	Argentina
Legends of the Fall	1994	M	Australia
Legends of the Fall	1994	14	Chile
Legends of the Fall	1994	12(w)	Germany
Legends of the Fall	1994	12	Netherlands
Legends of the Fall	1994	13	Spain
Legends of the Fall	1994	15	Sweden
Legends of the Fall	1994	15	UK
Legends of the Fall	1994	R	USA
Natural Born Killers	1994	18	Argentina
Natural Born Killers	1994	R	Australia
Natural Born Killers	1994	18	Chile
Natural Born Killers	1994	K-16	Finland
Natural Born Killers	1994	18	Germany
Natural Born Killers	1994	12	Portugal
Natural Born Killers	1994	18	Spain
Natural Born Killers	1994	15	Sweden
Natural Born Killers	1994	18	UK
Natural Born Killers	1994	R	USA
In the Mouth of Madness	1995	M	Australia
In the Mouth of Madness	1995	16	Germany
In the Mouth of Madness	1995	16	Portugal
In the Mouth of Madness	1995	18	Spain
In the Mouth of Madness	1995	18	UK
In the Mouth of Madness	1995	R	USA
Forrest Gump	1994	13	Argentina
Forrest Gump	1994	PG	Australia
Forrest Gump	1994	14	Chile
Forrest Gump	1994	K-12	Finland
Forrest Gump	1994	12	Germany
Forrest Gump	1994	12	Netherlands
Forrest Gump	1994	T	Spain
Forrest Gump	1994	11	Sweden
Forrest Gump	1994	12	UK
Forrest Gump	1994	PG-13	USA
Malcolm X	1992	13	Argentina
Malcolm X	1992	M	Australia
Malcolm X	1992	14	Chile
Malcolm X	1992	K-14	Finland
Malcolm X	1992	12	Germany
Malcolm X	1992	T	Spain
Malcolm X	1992	15	Sweden
Malcolm X	1992	15	UK
Malcolm X	1992	PG-13	USA
Dead Again	1991	M	Australia
Dead Again	1991	K-16	Finland
Dead Again	1991	16	Germany
Dead Again	1991	13	Spain
Dead Again	1991	15	Sweden
Dead Again	1991	15	UK
Dead Again	1991	R	USA
Jurassic Park	1993	13	Argentina
Jurassic Park	1993	PG	Australia
Jurassic Park	1993	TE	Chile
Jurassic Park	1993	K-16	Finland
Jurassic Park	1993	U	France
Jurassic Park	1993	12	Germany
Jurassic Park	1993	13	Spain
Jurassic Park	1993	11	Sweden
Jurassic Park	1993	PG-13	USA
Clueless	1995	13	Argentina
Clueless	1995	M	Australia
Clueless	1995	KT	Belgium
Clueless	1995	14	Chile
Clueless	1995	S	Finland
Clueless	1995	U	France
Clueless	1995	12	Portugal
Clueless	1995	T	Spain
Clueless	1995	11	Sweden
Clueless	1995	12	UK
Clueless	1995	PG-13	USA
Shadowlands	1993	13	Argentina
Shadowlands	1993	14	Chile
Shadowlands	1993	S	Finland
Shadowlands	1993	PG	USA
Amateur	1994	K-16	Finland
Amateur	1994	18	Spain
Amateur	1994	15	Sweden
Amateur	1994	15	UK
Amateur	1994	R	USA
GoodFellas	1990	18	Argentina
GoodFellas	1990	R	Australia
GoodFellas	1990	18	Chile
GoodFellas	1990	K-16	Finland
GoodFellas	1990	16	Germany
GoodFellas	1990	16	Portugal
GoodFellas	1990	15	Sweden
GoodFellas	1990	18	UK
GoodFellas	1990	R	USA
Little Women	1994	G	Australia
Little Women	1994	TE	Chile
Little Women	1994	S	Finland
Little Women	1994	T	Spain
Little Women	1994	Btl	Sweden
Little Women	1994	PG	USA
While You Were Sleeping	1995	PG	Australia
While You Were Sleeping	1995	TE	Chile
While You Were Sleeping	1995	S	Finland
While You Were Sleeping	1995	U	France
While You Were Sleeping	1995	6(bw)	Germany
While You Were Sleeping	1995	12	Portugal
While You Were Sleeping	1995	T	Spain
While You Were Sleeping	1995	PG	USA
The Birds	1966	PG	New Zealand
\.


--
-- Data for Name: restriction_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restriction_category (description, country) FROM stdin;
M	Australia
KT	Belgium
TE	Chile
K-12	Finland
U	France
12(w)	Germany
12	UK
M	New Zealand
6(bw)	Germany
12	Germany
16	Germany
PG-13	USA
R	Australia
PG	USA
PG	Australia
R18	New Zealand
PG	New Zealand
G	USA
G	Australia
15	UK
M	Portugal
12	Portugal
T	Spain
11	Sweden
R	USA
K-16	Finland
18	Spain
15	Sweden
13	Argentina
14	Chile
S	Finland
Btl	Sweden
18	Chile
16	Portugal
13	Spain
18	UK
6	Germany
K-14	Finland
12	Netherlands
MA	Australia
18	Argentina
18	Germany
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (id, title, production_year, description, credits) FROM stdin;
00000002	Titanic	1997	Jack Dawson	
00001188	Titanic	1997	Rose DeWitt Bukater	Heavenly Creatures
00000004	Titanic	1997	Cal Hockley	
00000005	Titanic	1997	Molly Brown	
00000023	Shakespeare in Love	1998	Philip Henslowe	
00001146	Shakespeare in Love	1998	Hugh Fennyman	Priest
00000025	Shakespeare in Love	1998	Lambert	
00000026	Shakespeare in Love	1998	Queen Elizabeth	
00000043	The Cider House Rules	1999	Olive Worthington	
00000044	The Cider House Rules	1999	Homer Wells	
00000045	The Cider House Rules	1999	Candy Kendall	
00000046	The Cider House Rules	1999	Mr.Rose	
00000047	The Cider House Rules	1999	Dr Wilbur Larch	
00000063	Gandhi	1982	Mahatma Gandhi	
00000064	Gandhi	1982	Margaret Bourke	
00000065	Gandhi	1982	Pandit Nehru	
00000066	Gandhi	1982	General Dyer	
00000083	American Beauty	1999	Lester Burnham	
00000084	American Beauty	1999	Carolyn Burnham	
00000085	American Beauty	1999	Jane Burnham	
00000086	American Beauty	1999	Ricky Fitts	
00000103	Affliction	1997	Wade Whitehouse	
00000104	Affliction	1997	Jill	
00000105	Affliction	1997	Gordon LaRiviere	
00000106	Affliction	1997	Jack Hewitt	
00000107	Affliction	1997	Glen Whitehouse	
00000121	Life is Beautiful	1997	Guido Orefice	
00000123	Life is Beautiful	1997	Dora	
00000143	Boys Dont Cry	1999	Brandon Teena	
00000144	Boys Dont Cry	1999	Lana Tisdel	
00000145	Boys Dont Cry	1999	John Lotter	
00000146	Boys Dont Cry	1999	Marvin Thomas	
00001227	Saving Private Ryan	1998	Captain John	Toy Story
00000164	Saving Private Ryan	1998	Sergeant Michael	
00000165	Saving Private Ryan	1998	Richard Reiben	
00000166	Saving Private Ryan	1998	Jackson	
00000181	The Birds	1963	Man in pet shop	
00000184	The Birds	1963	Mitch Brenner	
00000185	The Birds	1963	Lydia Brenner	
00000186	The Birds	1963	Annie Hayworth	
00000187	The Birds	1963	Melanie Daniels	
00001001	Rear Window	1954	L.B. Jeff Jefferies	
00001002	Rear Window	1954	Lisa Carol Fremont	
00001003	Rear Window	1954	Lars Thorwald	
00000181	Rear Window	1954	Clock-Winding Man	Psycho, Birds
00000203	The Matrix	1999	Thomas	
00000204	The Matrix	1999	Morpheus	
00001227	Toy Story	1995	Woody	Saving Private Ryan
00000942	Toy Story	1995	Buzz Lightyear	
00000943	Toy Story	1995	Bo Peep	
00001212	Proof of Life	2000	Alice Bowman	Hanging Up
00000622	Proof of Life	2000	Terry Thorne	Gladiator
00000963	Proof of Life	2000	Peter Bowman	
00001212	Hanging Up	2000	Eve	Proof of Life
00001131	Hanging Up	2000	Georgia	Manhattan Murder Mystery
00000983	Hanging Up	2000	Maddy	
00000223	You have Got Mail	1998	Patricia Eden	
00001212	You have Got Mail	1998	Kathleen Kelly	Hanging Up
00000242	The Price of Milk	2000	Lucinda	Topless Women Talk About Their Lives
00000243	The Price of Milk	2000	Rob	
00000244	The Price of Milk	2000	Drosophila	Topless Women Talk About Their Lives
00000262	The Footstep Man	1992	Sam	
00000263	The Footstep Man	1992	Mirielle	
00000264	The Footstep Man	1992	Henri de Toulouse	
00000242	Topless Women Talk About Their Lives	1997	Liz	The Price of Milk
00000281	Topless Women Talk About Their Lives	1997	Neil	
00000282	Topless Women Talk About Their Lives	1997	Ant	
00000244	Topless Women Talk About Their Lives	1997	Prue	The Price of Milk
00000302	The Piano	1993	Ada McGrath	
00001233	The Piano	1993	George Baines	Reservoir Dogs
00000304	The Piano	1993	Flora McGrath	
00000323	Mad Max	1979	Max Rockatansky	Lethal Weapon 4
00000324	Mad Max	1979	Jessie Rockatansky	
00000343	Strictly Ballroom	1992	Scott Hastings	
00000344	Strictly Ballroom	1992	Fran	
00000345	Strictly Ballroom	1992	Shirley Hastings	
00000346	Strictly Ballroom	1992	Doug Hastings	
00000362	My Mother Frank	2000	Mike	
00000363	My Mother Frank	2000	Jenny	
00000364	My Mother Frank	2000	Frank	
00000383	American Psycho	2000	Patrick Bateman 	
00000384	American Psycho	2000	Donald Kimball	
00000385	American Psycho	2000	Paul Allen	
00001153	American Psycho	2000	Courtney Rawlinson	Pump Up the Volume
00000403	Scream 2	1997	Dwight Dewey Riley	
00000404	Scream 2	1997	Sidney Prescott	
00000405	Scream 2	1997	Gale Weathers	
00000485	Scream 2	1997	Casey	I Know What You Did Last Summer
00000421	Scream 3	2000	Cotton Weary	
00000422	Scream 3	2000	Female Caller	
00000423	Scream 3	2000	The Voice	
00000424	Scream 3	2000	Christine	
00000404	Scream 3	2000	Sidney Prescott	Scream 2
00000405	Scream 3	2000	Gale Weathers	Scream 2
00000443	Traffic	2000	Robert Wakefield	
00000444	Traffic	2000	Javier Rodriguez	
00000445	Traffic	2000	Helena Ayala	Entrapment
00000446	Traffic	2000	Carlos Ayala	
00000447	Traffic	2000	Ray Castro	
00000448	Traffic	2000	Barbara Wakefield	
00000449	Traffic	2000	Caroline Wakefield	
00000450	Traffic	2000	Montel Gordon	
00000451	Traffic	2000	Manolo Sanchez	
00000452	Traffic	2000	Francisco Flores	
00000462	Psycho	1960	Norman Bates	
00000463	Psycho	1960	Lila Crane	
00000464	Psycho	1960	Marion Crane	
00000181	Psycho	1960	Man in hat	
00000465	Psycho	1960	Sam Loomis	
00000483	I Know What You Did Last Summer	1997	Julie James	
00000485	I Know What You Did Last Summer	1997	Helen Shivers	Scream 2
00000484	I Know What You Did Last Summer	1997	Barry Cox	Cruel Intentions
00000484	Cruel Intentions	1999	Sebastian Valmont	I Know What You Did Last Summer
00000485	Cruel Intentions	1999	Kathryn Merteuil	Scream 2
00000503	Cruel Intentions	1999	Annette Hargrove	
00000504	Cruel Intentions	1999	Cecile Caldwell	
00001229	Wild Things	1998	Ray Duquette	Apollo 13
00000524	Wild Things	1998	Sam Lombardo	
00000404	Wild Things	1998	Suzie Toller	Scream 2
00000543	Alien	1979	Captain	
00000544	Alien	1979	Warrent Officer	Aliens
00000544	Aliens	1986	Lieutenant	Alien
00000561	Aliens	1986	Rebecca	
00000544	Alien 3	1992	Ellen Ripley	Aliens
00000583	Alien 3	1992	Dillon	
00000584	Alien 3	1992	Clemens	
00000544	Alien: Resurrection	1997	Lieutenant Ellen	Aliens
00001031	Alien: Resurrection	1997	Betty Mechanic	Mermaids
00000604	Alien: Resurrection	1997	Betty Chief Mechanic	
00000622	Gladiator	2000	Maximus	The Insider
00000623	Gladiator	2000	Commodus	
00000624	Gladiator	2000	Lucilla	
00000643	The World Is Not Enough	1999	James Bond	
00000644	The World Is Not Enough	1999	CEO Elektra	
00000645	The World Is Not Enough	1999	Christmas	
00000662	Heat	1995	Vincent Hanna	The Insider
00000663	Heat	1995	Neil McCauley	
00001017	Heat	1995	Chris Shiherlis	Tombstone
00000683	American History X	1998	Derek Vinyard	
00000684	American History X	1998	Daniel Vinyard	
00000685	American History X	1998	Doris Vinyard	
00000683	Fight Club	1999	Narrator	
00001198	Fight Club	1999	Tyler Durden	Twelve Monkeys
00000703	Fight Club	1999	Robert Paulsen	
00000722	Out of Sight	1998	Jack Foley	
00000723	Out of Sight	1998	Bank Employee	
00000724	Out of Sight	1998	Karen Sisco	
00000445	Entrapment	1999	Virginia Baker	Traffic
00000743	Entrapment	1999	Robert Mac	
00000744	Entrapment	1999	Aaron Thibadeaux	
00000762	The Insider	1999	Liane Wigand	
00000622	The Insider	1999	Jeffrey Wigand	Gladiator
00000662	The Insider	1999	Lowell Bergman	Heat
00000782	The Blair Witch Project	1999	Heather Donahue	
00000783	The Blair Witch Project	1999	Josh	
00000784	The Blair Witch Project	1999	Mike	
00000803	Lethal Weapon 4	1998	Roger Murtaugh	
00001183	Lethal Weapon 4	1998	Lorna Cole	In the Line of Fire
00000323	Lethal Weapon 4	1998	Martin Riggs	Mad Max
00000822	The Fifth Element	1997	Korben Dallas	The Sixth Sense
00000823	The Fifth Element	1997	Zorg	
00000824	The Fifth Element	1997	Leeloo	
00000822	The Sixth Sense	1999	Dr.Malcolm Crowe	The Fifth Element
00000842	The Sixth Sense	1999	Cole Sear	
00000843	The Sixth Sense	1999	Lynn Sear	
00000822	Unbreakable	2000	David Dunn	The Sixth Sense
00001276	Unbreakable	2000	Audrey Dunn	Forrest Gump
00000862	Unbreakable	2000	Joseph Dunn	
00000822	Armageddon	1998	Harry S.Stamper	The Fifth Element
00000883	Armageddon	1998	Dan Truman	
00000884	Armageddon	1998	Grace Stamper	
00000822	The Kid	2000	Russ Duritz	Armageddon
00000903	The Kid	2000	Rusty Duritz	
00000904	The Kid	2000	Amy	
00000822	Twelve Monkeys	1995	James Cole	The Fifth Element
00000923	Twelve Monkeys	1995	Young Cole	
00001198	Twelve Monkeys	1995	Jeffrey Goines	Fight Club
00001006	Bullets Over Broadway	1994	David Shayne	
00001007	Bullets Over Broadway	1994	Julian Marx	While You Were Sleeping
00001008	Bullets Over Broadway	1994	Rocco	
00001016	Tombstone	1993	Kurt Russell	
00001017	Tombstone	1993	Val Kilmer	Heat
00001018	Tombstone	1993	Sam Elliott	
00001024	Alice	1990	Joe	
00001025	Alice	1990	Alice Tate	
00001026	Alice	1990	Doug Tate	
00001029	Mermaids	1990	Rachel Flax	
00001030	Mermaids	1990	Lou Landsky	
00001031	Mermaids	1990	Charlotte Flax	Little Women
00001038	Exotica	1994	Inspector	
00001039	Exotica	1994	Thomas Pinto	
00001040	Exotica	1994	Christina	
00001045	Red Rock West	1992	Michael Williams	
00001046	Red Rock West	1992	Jim	
00001053	Chaplin	1992	Charlie Chaplin	
00001054	Chaplin	1992	Hannah Chaplin	
00001055	Chaplin	1992	Sydney Chaplin	
00001062	Fearless	1993	Max Klein	
00001063	Fearless	1993	Laura Klein	
00001064	Fearless	1993	Carla Rodrigo	
00001071	Threesome	1994	Alex	
00001072	Threesome	1994	Stuart	
00001073	Threesome	1994	Eddy	
00001080	Jungle Fever	1991	Flipper Purify	
00001081	Jungle Fever	1991	Angie Tucci	
00001088	Internal Affairs	1990	Dennis Peck	
00001089	Internal Affairs	1990	Raymond Avila	Dead Again
00001090	Internal Affairs	1990	Kathleen Avila	
00001098	Single White Female	1992	Allison Jones	
00001099	Single White Female	1992	Hedra Carlson	
00001100	Single White Female	1992	Sam Rawson	
00001105	Trust	1990	Maria Coughlin	
00001106	Trust	1990	Matthew Slaughter	Amateur
00001112	Ju Dou	1990	Ju Dou	Daohong Denglong Gaogao Gua
00001113	Ju Dou	1990	Yang Tian-qing	
00001112	Dahong Denglong Gaogao Gua	1991	Songlian	Ju Dou
00001120	Dahong Denglong Gaogao Gua	1991	The Third Concubine	
00001119	Dahong Denglong Gaogao Gua	1991	The Master	
00001125	Cyrano de Bergerac	1990	Cyrano De Bergerac	
00001126	Cyrano de Bergerac	1990	Roxane	
00001005	Manhattan Murder Mystery	1993	Larry Lipton	
00001131	Manhattan Murder Mystery	1993	Carol Lipton	Hanging Up
00001133	El Mariachi	1992	El Mariachi	
00001134	El Mariachi	1992	Domino	
00001137	Once Were Warriors	1994	Beth Heke	
00001138	Once Were Warriors	1994	Jake Heke	
00001145	Priest	1994	Father Greg Pilkington	
00001146	Priest	1994	Father Matthew Thomas	Shakespeare in Love
00001152	Pump Up the Volum	1990	Mark Hunter	
00001153	Pump Up the Volum	1990	Nora Diniro	Little Women
00001160	Benny and Joon	1993	Sam	
00001161	Benny and Joon	1993	Juniper Pearl	
00001167	Six Degrees of Separation	1993	Ouisa Kittredge	
00001168	Six Degrees of Separation	1993	Paul	
00001169	Six Degrees of Separation	1993	John Flanders	
00001175	Bawang Bie Ji	1993	Cheng Dieyi	
00001176	Bawang Bie Ji	1993	Duan Xiaolou	
00001112	Bawang Bie Ji	1993	Juxian	
00001181	In the Line of Fire	1993	Secret Service Agent Frank Horrigan	
00001182	In the Line of Fire	1993	Mitch Leary	
00001183	In the Line of Fire	1993	Secret Service Agent Lilly Raines	Lethal Weapon 4
00001187	Heavenly Creatures	1994	Pauline Yvonne Rieper	
00001188	Heavenly Creatures	1994	Juliet Marion Hulme	Titanic
00001192	Hoop Dreams	1994	Himself	
00001193	Hoop Dreams	1994	Arthur	
00001197	Seven	1995	Detective William Somerset	
00001198	Seven	1995	Detective David Mills	Legends of the Fall
00001204	Shallow Grave	1994	Juliet Miller	
00001205	Shallow Grave	1994	David Stephens	
00001206	Shallow Grave	1994	Alex Law	
00001212	French Kiss	1995	Kate	You have Got Mail
00001213	French Kiss	1995	Luc Teyssier	
00001214	French Kiss	1995	Charlie	
00001217	Braindead	1992	Lionel Cosgrove	
00001218	Braindead	1992	Paquita Maria Sanchez	
00001219	Braindead	1992	Mum	
00001186	Braindead	1992	Undertaker Assistant	
00001222	Clerks	1994	Veronica Loughran	
00001223	Clerks	1994	Caitlin Bree	
00001227	Apollo 13	1995	Jim Lovell	Forrest Gump
00001228	Apollo 13	1995	Fred Haise	
00001229	Apollo 13	1995	Jack Swigert	Wild Things
00001233	Reservoir Dogs	1992	Larry	Pulp Fiction
00001234	Reservoir Dogs	1992	Freddy	
00001235	Reservoir Dogs	1992	Vic	
00001238	Pulp Fiction	1994	Vincent Vega	
00001239	Pulp Fiction	1994	Jules Winnfield	
00001233	Pulp Fiction	1994	Winston Wolf	Reservoir Dogs
00001249	Short Cuts	1993	Ann Finnigan	
00001250	Short Cuts	1993	Howard Finnigan	
00001251	Short Cuts	1993	Paul Finnigan	
00001198	Legends of the Fall	1994	Tristan Ludlow	Seven
00001256	Legends of the Fall	1994	Colonel William Ludlow	Shadowlands
00001257	Legends of the Fall	1994	Alfred Ludlow	
00001262	Natural Born Killers	1994	Mickey Knox	
00001263	Natural Born Killers	1994	Mallory Wilson Knox	
00001264	Natural Born Killers	1994	Wayne Gale	
00001269	In the Mouth of Madness	1995	John Trent	Jurassic Park
00001270	In the Mouth of Madness	1995	Sutter Cane	
00001271	In the Mouth of Madness	1995	Linda Styles	
00001227	Forrest Gump	1994	Forrest Gump	Apollo 13
00001276	Forrest Gump	1994	Jenny Curran	Unbreakable
00001277	Forrest Gump	1994	Lieutenant Daniel Taylor	
00001281	Malcolm X	1992	Malcolm X	
00001282	Malcolm X	1992	Betty Shabazz	
00001079	Malcolm X	1992	Shorty	
00001284	Dead Again	1991	Mike Church	
00001089	Dead Again	1991	Gray Baker	Internal Affaris
00001286	Dead Again	1991	Margaret Strauss	
00001269	Jurassic Park	1993	Alan Grant	In the Mouth of Madness
00001293	Jurassic Park	1993	Ellie Sattler	
00001294	Jurassic Park	1993	Ian Malcolm	
00001051	Jurassic Park	1993	John Parker Hammond	
00001298	Clueless	1995	Cher Horowitz	
00001299	Clueless	1995	Dionne	
00001300	Clueless	1995	Tai Fraiser	
00001256	Shadowlands	1993	Lewis	Legends of the Fall
00001307	Shadowlands	1993	Joy Gresham	
00001308	Shadowlands	1993	Arnold Dopliss	
00001312	Amateur	1994	Isabelle	
00001106	Amateur	1994	Thomas Ludens	Trust
00001313	Amateur	1994	Sofia Ludens	
00001318	GoodFellas	1990	James	
00001319	GoodFellas	1990	Henry Hill	
00001320	GoodFellas	1990	Tommy DeVito	
00001031	Little Women	1994	Josephine	Mermaids
00001326	Little Women	1994	Friedrich	
00001327	Little Women	1994	Margaret	
00001153	Little Women	1994	Older Amy March	Pump Up the Volum
00001333	While You Were Sleeping	1995	Narrator	
00001334	While You Were Sleeping	1995	Jack Callaghan	
00001007	While You Were Sleeping	1995	Saul	Bullets Over Broadway
00001339	Psycho	1998	Norman Bates	
00001341	Psycho	1998	Lila Crane	
00001338	Psycho	1998	Marion Crane	
00001346	Psycho	1960	Milton Arbogast	
00001342	Psycho	1998	Milton Arbogast	
00001340	Psycho	1998	Sam Loomis	
00001175	Bawang Bie Ji	1993	man in bar	\N
00000026	Topless Women Talk About Their Lives	1997	Narrator	\N
00000462	Psycho	1960	Mother	
00001339	Psycho	1998	Mother	
00000621	Gladiator	2000	Brutus	Me
00000623	Gladiator	2002	Commodus	Me
\.


--
-- Data for Name: scene; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scene (title, production_year, scene_no, description) FROM stdin;
Rear Window	1954	1	Jeffs appartment
Rear Window	1954	2	Private Dramas
Rear Window	1954	3	The Piano Player
Rear Window	1954	4	The Salesman
Rear Window	1954	5	Witness of a murder
Rear Window	1954	6	Lisa in danger
Rear Window	1954	7	Final battle
Rear Window	1954	8	One more broken leg
The Birds	1963	1	Love Birds
The Birds	1963	2	Dogs in front of a pet shop
The Birds	1963	3	Arriving at Bodega Bay
The Birds	1963	4	Gull attack
The Birds	1963	5	Birthday party
The Birds	1963	6	Bird meeting
The Birds	1963	7	At Brenners House
The Birds	1963	8	Open End
Psycho	1960	1	Fed up with life
Psycho	1960	2	40000 dollars for a new start
Psycho	1960	3	Coffee Break
Psycho	1960	4	The Bates Motel
Psycho	1960	5	Norman and Mother
Psycho	1960	6	Taking a shower
Psycho	1960	7	Norman takes over
Psycho	1960	8	Killing mother
Traffic	2000	1	Corruption at Mexican Border
Traffic	2000	2	A new anti-drug czar
Traffic	2000	3	Addicted to Drugs
Traffic	2000	4	Arresting a Baron
Traffic	2000	5	Temptations
Traffic	2000	6	Loosing Caroline
Traffic	2000	7	Taking over the Business
Traffic	2000	8	Untenable Situation
Traffic	2000	9	Assassains
Traffic	2000	10	New Family Values
Traffic	2000	11	The Fight goes on
Bullets Over Broadway	1994	1	gangster
Bullets Over Broadway	1994	2	playwright
Bullets Over Broadway	1994	3	theater
Bullets Over Broadway	1994	4	writing
Bullets Over Broadway	1994	5	murder
Bullets Over Broadway	1994	6	new-york
Tombstone	1993	1	settle down in Tombstone
Tombstone	1993	2	Wyatts brother
Tombstone	1993	3	The Cowboys band
Tombstone	1993	4	problems caused
Tombstone	1993	5	violence region
Tombstone	1993	6	shoot-out at the OK Corral
Alice	1990	1	bored-housewife
Alice	1990	2	infidelity
Alice	1990	3	human-relationship
Alice	1990	4	socialite
Alice	1990	5	christmas
Alice	1990	6	gossip
Alice	1990	7	invisible-man
Alice	1990	8	invisible
Mermaids	1990	1	failed relationship
Mermaids	1990	2	move to east coast
Mermaids	1990	3	Charlottes life
Mermaids	1990	4	the church employee
Mermaids	1990	5	mother-daughter relationship
Exotica	1994	1	bay-sitting
Exotica	1994	2	flashback-sequence
Exotica	1994	3	homesexual
Exotica	1994	4	audit
Exotica	1994	5	ticket-scalping
Exotica	1994	6	psychological-drama
Exotica	1994	7	lesbian-scene
Exotica	1994	8	smuggling
Red Rock West	1992	1	money
Red Rock West	1992	2	neo-noir
Red Rock West	1992	3	hitman
Red Rock West	1992	4	sheriff
Red Rock West	1992	5	murder
Red Rock West	1992	6	small-town
Red Rock West	1992	7	railway
Red Rock West	1992	8	train
Chaplin	1992	1	charlie-chaplin
Chaplin	1992	2	hollywood
Chaplin	1992	3	silent-film-maker
Chaplin	1992	4	political-persecution
Chaplin	1992	5	film-making
Chaplin	1992	6	based-on-multiple-works
Fearless	1993	1	car-crash
Fearless	1993	2	isolation
Fearless	1993	3	recovery
Fearless	1993	4	law
Fearless	1993	5	self-confidence
Fearless	1993	6	disaster
Fearless	1993	7	video-game
Fearless	1993	8	airplane-accident
Fearless	1993	9	flashback-sequence
Fearless	1993	10	allergy
Fearless	1993	11	strawberry
Threesome	1994	1	midget
Threesome	1994	2	dormitory
Threesome	1994	3	best-friend
Threesome	1994	4	college
Threesome	1994	5	homosexual
Threesome	1994	6	roommate
Threesome	1994	7	shower-scene
Threesome	1994	8	adult-humor
Jungle Fever	1991	1	racial
Jungle Fever	1991	2	affair
Jungle Fever	1991	3	deception
Jungle Fever	1991	4	interracial-love
Jungle Fever	1991	5	crack-den
Jungle Fever	1991	6	drugs
Jungle Fever	1991	7	new-york
Jungle Fever	1991	8	racism
Internal Affairs	1990	1	corrupt-cop
Internal Affairs	1990	2	internal-affairs
Internal Affairs	1990	3	investigation
Internal Affairs	1990	4	unfaithfulness
Internal Affairs	1990	5	lesbian-cop
Internal Affairs	1990	6	police
Single White Female	1992	1	apartment
Single White Female	1992	2	software
Single White Female	1992	3	notebook
Single White Female	1992	4	personals-column
Single White Female	1992	5	murder
Single White Female	1992	6	psychopath
Single White Female	1992	7	puppy
Single White Female	1992	8	roommate
Single White Female	1992	9	female scene
Trust	1990	1	Marias pregnancy
Trust	1990	2	homeless
Trust	1990	3	Matthew Slaughter
Trust	1990	4	Matthews job
Trust	1990	5	being together
Trust	1990	6	changes
Ju Dou	1990	1	1920s
Ju Dou	1990	2	crippling-accident
Ju Dou	1990	3	factory-owner
Ju Dou	1990	4	feudal-society
Ju Dou	1990	5	impotence
Ju Dou	1990	6	push-cart
Ju Dou	1990	7	sadism
Dahong Denglong Gaogao Gua	1991	1	marriage
Dahong Denglong Gaogao Gua	1991	2	Chens castle
Dahong Denglong Gaogao Gua	1991	3	competition between the wives
Dahong Denglong Gaogao Gua	1991	4	the red lantern
Dahong Denglong Gaogao Gua	1991	5	haircut
Dahong Denglong Gaogao Gua	1991	6	doctor
Cyrano de Bergerac	1990	1	fall in love with Roxane
Cyrano de Bergerac	1990	2	the large nose
Cyrano de Bergerac	1990	3	the letter
Cyrano de Bergerac	1990	4	Christian in love
Cyrano de Bergerac	1990	5	the mistake
Manhattan Murder Mystery	1993	1	blackmail
Manhattan Murder Mystery	1993	2	neighbor
Manhattan Murder Mystery	1993	3	heart-attack
Manhattan Murder Mystery	1993	4	husband-wife-relationship
Manhattan Murder Mystery	1993	5	new-york
Manhattan Murder Mystery	1993	6	publisher
Manhattan Murder Mystery	1993	7	amateur-detective
Manhattan Murder Mystery	1993	8	murder
El Mariachi	1992	1	motorcycle
El Mariachi	1992	2	paper-knife
El Mariachi	1992	3	singer
El Mariachi	1992	4	low-budget
El Mariachi	1992	5	bathtub
El Mariachi	1992	6	guitar
El Mariachi	1992	7	mistaken-identity
El Mariachi	1992	8	dream
El Mariachi	1992	9	guitar-case
El Mariachi	1992	10	hotel
Once Were Warriors	1994	1	marriage
Once Were Warriors	1994	2	rape
Once Were Warriors	1994	3	suicide
Once Were Warriors	1994	4	vulgarity
Once Were Warriors	1994	5	alcohol
Once Were Warriors	1994	6	suicide-by-hanging
Priest	1994	1	Love Birds
Priest	1994	2	Dogs in front of a pet shop
Priest	1994	3	Arriving at Bodega Bay
Priest	1994	4	Gull attack
Priest	1994	5	Birthday party
Priest	1994	6	Bird meeting
Priest	1994	7	At Brenners House
Priest	1994	8	Open End
Pump Up the Volum	1990	1	catholic
Pump Up the Volum	1990	2	controversial
Pump Up the Volum	1990	3	homosexual
Pump Up the Volum	1990	4	incest
Pump Up the Volum	1990	5	priest
Pump Up the Volum	1990	6	religion
Benny and Joon	1993	1	mechanic
Benny and Joon	1993	2	psychiatrist
Benny and Joon	1993	3	mental-illness
Benny and Joon	1993	4	psychoanalysis
Benny and Joon	1993	5	schizophrenia
Six Degrees of Separation	1993	1	bisexual
Six Degrees of Separation	1993	2	homosexual
Six Degrees of Separation	1993	3	impostor
Six Degrees of Separation	1993	4	suicide
Six Degrees of Separation	1993	5	nudity
Bawang Bie Ji	1993	1	peking-opera
Bawang Bie Ji	1993	2	training
Bawang Bie Ji	1993	3	become famous
Bawang Bie Ji	1993	4	prostitution
Bawang Bie Ji	1993	5	japanese-occupation
Bawang Bie Ji	1993	6	communism
Bawang Bie Ji	1993	7	drugs
Bawang Bie Ji	1993	8	culture revolution
In the Line of Fire	1993	1	assassination
In the Line of Fire	1993	2	master-of-disguise
In the Line of Fire	1993	3	president
In the Line of Fire	1993	4	neck-breaking-scene
In the Line of Fire	1993	5	secret-service
Heavenly Creatures	1994	1	schoolgirl
Heavenly Creatures	1994	2	bathtub
Heavenly Creatures	1994	3	make-believe
Heavenly Creatures	1994	4	parent
Heavenly Creatures	1994	5	surreal
Heavenly Creatures	1994	6	murder
Hoop Dreams	1994	1	college
Hoop Dreams	1994	2	ghetto
Hoop Dreams	1994	3	high-school
Hoop Dreams	1994	4	narrated
Hoop Dreams	1994	5	school
Seven	1995	1	detective
Seven	1995	2	seven-deadly-sins
Seven	1995	3	violence
Seven	1995	4	overweight
Seven	1995	5	partner
Seven	1995	6	serial-killer
Seven	1995	7	disturbing
Shallow Grave	1994	1	apartment
Shallow Grave	1994	2	corpse
Shallow Grave	1994	3	death
Shallow Grave	1994	4	friend
Shallow Grave	1994	5	greed
Shallow Grave	1994	6	betrayal
French Kiss	1995	1	wine
French Kiss	1995	2	american-in-paris
French Kiss	1995	3	france
French Kiss	1995	4	human-relaionship
French Kiss	1995	5	paris-france
French Kiss	1995	6	toronto
Braindead	1992	1	1950s
Braindead	1992	2	splatter
Braindead	1992	3	dominatnt-mother
Braindead	1992	4	zombie
Braindead	1992	5	gore
Braindead	1992	6	disturbing
Braindead	1992	7	mutant-baby
Braindead	1992	8	reanimation
Braindead	1992	9	zoo
Clerks	1994	1	necrophilia
Clerks	1994	2	new-jersey
Clerks	1994	3	russian-rock
Clerks	1994	4	snowball
Clerks	1994	5	funeral
Clerks	1994	6	generation-X
Clerks	1994	7	disgruntled-worker
Clerks	1994	8	accidental-necrophilia
Apollo 13	1995	1	astronaut
Apollo 13	1995	2	husband and wife
Apollo 13	1995	3	launch
Apollo 13	1995	4	nasa
Apollo 13	1995	5	lunar-mission
Apollo 13	1995	6	survival
Apollo 13	1995	7	explosion
Apollo 13	1995	8	space-travel
Apollo 13	1995	9	spacecraft
Apollo 13	1995	10	return
Reservoir Dogs	1992	1	car-jacking
Reservoir Dogs	1992	2	hit-and-run
Reservoir Dogs	1992	3	severed-ear
Reservoir Dogs	1992	4	cop-killer
Reservoir Dogs	1992	5	chase
Reservoir Dogs	1992	6	undercover
Pulp Fiction	1994	1	injection
Pulp Fiction	1994	2	dance-contest
Pulp Fiction	1994	3	ganster
Pulp Fiction	1994	4	full-circle
Pulp Fiction	1994	5	boxing
Pulp Fiction	1994	6	taxicab
Pulp Fiction	1994	7	foot-massage
Pulp Fiction	1994	8	hamburger
Pulp Fiction	1994	9	corpse
Short Cuts	1993	1	fishing
Short Cuts	1993	2	helicopter
Short Cuts	1993	3	unfaithfulness
Short Cuts	1993	4	suicide
Short Cuts	1993	5	telepone-sex
Short Cuts	1993	6	chainsaw
Short Cuts	1993	7	earthquake
Short Cuts	1993	8	hospital
Legends of the Fall	1994	1	bear
Legends of the Fall	1994	2	brothers
Legends of the Fall	1994	3	racism
Legends of the Fall	1994	4	the war
Legends of the Fall	1994	5	passion
Legends of the Fall	1994	6	corruption
Legends of the Fall	1994	7	marriage
Legends of the Fall	1994	8	father and son
Natural Born Killers	1994	1	escape
Natural Born Killers	1994	2	snake-bite
Natural Born Killers	1994	3	serial-killer
Natural Born Killers	1994	4	desert
Natural Born Killers	1994	5	prison
Natural Born Killers	1994	6	revenge
Natural Born Killers	1994	7	wedding-ring
In the Mouth of Madness	1995	1	axe
In the Mouth of Madness	1995	2	horro-writer
In the Mouth of Madness	1995	3	lovecraft
In the Mouth of Madness	1995	4	author
In the Mouth of Madness	1995	5	publisher
In the Mouth of Madness	1995	6	asylum
In the Mouth of Madness	1995	7	monster
Forrest Gump	1994	1	running
Forrest Gump	1994	2	folk-singer
Forrest Gump	1994	3	vietnam war
Forrest Gump	1994	4	table-tennis
Forrest Gump	1994	5	hero
Forrest Gump	1994	6	strom
Forrest Gump	1994	7	shrimping
Forrest Gump	1994	8	marathon
Forrest Gump	1994	9	wedding
Forrest Gump	1994	10	cancer
Forrest Gump	1994	11	son
Malcolm X	1992	1	penitentiary
Malcolm X	1992	2	hustler
Malcolm X	1992	3	beach
Malcolm X	1992	4	harlem
Malcolm X	1992	5	streetcar
Malcolm X	1992	6	police-brutality
Malcolm X	1992	7	streetcar
Malcolm X	1992	8	surveillance
Malcolm X	1992	9	train
Malcolm X	1992	10	urban-decay
Dead Again	1991	1	reporter
Dead Again	1991	2	reincarnation
Dead Again	1991	3	scandal
Dead Again	1991	4	opera
Dead Again	1991	5	private-detective
Dead Again	1991	6	wedding
Dead Again	1991	7	amnesia
Dead Again	1991	8	jewelry
Jurassic Park	1993	1	amusement-park
Jurassic Park	1993	2	tropical-island
Jurassic Park	1993	3	tyrannosaurus
Jurassic Park	1993	4	child
Jurassic Park	1993	5	gene-manipulation
Jurassic Park	1993	6	raptor
Jurassic Park	1993	7	computer-cracker
Jurassic Park	1993	8	disaster
Jurassic Park	1993	9	product-placement
Clueless	1995	1	beverly-hills
Clueless	1995	2	high-school
Clueless	1995	3	popularity
Clueless	1995	4	teen
Clueless	1995	5	makeover
Clueless	1995	6	driving test
Clueless	1995	7	wedding
Shadowlands	1993	1	author
Shadowlands	1993	2	the Narnia books
Shadowlands	1993	3	teacher of Oxford
Shadowlands	1993	4	Joy Gresham
Shadowlands	1993	5	love affair
Shadowlands	1993	6	Joy is unwell
Shadowlands	1993	7	life became complicated
Amateur	1994	1	amnesia
Amateur	1994	2	blackmail
Amateur	1994	3	nun
Amateur	1994	4	torture
Amateur	1994	5	pornographer
GoodFellas	1990	1	gangster
GoodFellas	1990	2	prison
GoodFellas	1990	3	heist
GoodFellas	1990	4	paranoia
GoodFellas	1990	5	contraband
GoodFellas	1990	6	mafia
GoodFellas	1990	7	nightclub
GoodFellas	1990	8	cheat-on-wife
GoodFellas	1990	9	organized-crime
GoodFellas	1990	10	witness-protection
GoodFellas	1990	11	christmas
Little Women	1994	1	1860s
Little Women	1994	2	american-civil-war
Little Women	1994	3	neighbor
Little Women	1994	4	sisters
Little Women	1994	5	secret meetings
Little Women	1994	6	party
Little Women	1994	7	father
Little Women	1994	8	piano
While You Were Sleeping	1995	1	family
While You Were Sleeping	1995	2	christmas
While You Were Sleeping	1995	3	winter
While You Were Sleeping	1995	4	coma
While You Were Sleeping	1995	5	financee
While You Were Sleeping	1995	6	loneliness
While You Were Sleeping	1995	7	infatuation
While You Were Sleeping	1995	8	subway
While You Were Sleeping	1995	9	new-year-eve
Psycho	1998	1	Fed up with life
Psycho	1998	2	40000 dollars for a new start
Psycho	1998	3	Coffee Break
Psycho	1998	4	The Bates Motel
Psycho	1998	5	Norman and Mother
Psycho	1998	6	Taking a shower
Psycho	1998	7	Norman takes over
Psycho	1998	8	Killing mother
\.


--
-- Data for Name: writer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.writer (id, title, production_year, credits) FROM stdin;
00000001	Titanic	1997	
00000022	Shakespeare in Love	1998	None
00000022	Shakespeare in Love	1999	None
00000042	The Cider House Rules	1999	None
00000062	The Cider House Rules	2000	None
00000062	Gandhi	1982	
00000082	American Beauty	1999	
00000102	Affliction	1997	
00000121	Life is Beautiful	1997	
00000122	Life is Beautiful	1997	
00000141	Boys Dont Cry	1999	
00000142	Boys Dont Cry	1999	
00000162	Saving Private Ryan	1998	
00000182	The Birds	1963	
00000183	The Birds	1963	
00001004	Rear Window	1954	
00000201	The Matrix	1999	
00000202	The Matrix	1999	
00000241	The Price of Milk	2000	Topless Women Talk About Their Lives
00000261	The Footstep Man	1992	
00000241	Topless Women Talk About Their Lives	1997	The Price of Milk
00000301	The Piano	1993	
00000321	Mad Max	1979	
00000322	Mad Max	1979	
00000341	Strictly Ballroom	1992	
00000342	Strictly Ballroom	1992	
00000361	My Mother Frank	2000	
00000381	American Psycho	2000	
00000382	American Psycho	2000	
00000402	Scream 2	1997	Scream 3
00000402	Scream 3	2000	Scream 2
00000442	Traffic	2000	
00000461	Psycho	1960	
00000482	I Know What You Did Last Summer	1997	
00000502	Cruel Intentions	1999	
00000522	Wild Things	1998	
00000542	Alien	1979	
00000001	Aliens	1986	
00000582	Alien 3	1992	
00000602	Alien: Resurrection	1997	
00000621	Gladiator	2000	
00000642	The World Is Not Enough	1999	
00000661	Heat	1995	None
00000661	Heat	1996	None
00000682	American History X	1998	
00000701	Fight Club	1999	
00000721	Out of Sight	1998	
00000742	Entrapment	1999	
00000761	The Insider	1999	
00000781	The Blair Witch Project	1999	
00000802	Lethal Weapon 4	1998	
00000821	The Fifth Element	1997	
00000841	The Sixth Sense	1999	
00000841	Unbreakable	2000	The Sixth Sense
00000882	Armageddon	1998	
00000902	The Kid	2000	
00000922	Twelve Monkeys	1995	
00000222	You have Got Mail	1998	
00000941	Toy Story	1995	
00000962	Proof of Life	2000	
00000962	Hanging Up	2000	
00001005	Bullets Over Broadway	1994	Alice
00001015	Tombstone	1993	
00001005	Alice	1990	Bullets Over Broadway
00001028	Mermaids	1990	
00001037	Exotica	1994	
00001044	Red Rock West	1992	
00001052	Chaplin	1992	
00001061	Fearless	1993	
00001070	Threesome	1994	
00001079	Jungle Fever	1991	Malcolm X
00001087	Internal Affairs	1990	
00001097	Single White Female	1992	
00001104	Trust	1990	Amateur
00001111	Ju Dou	1990	
00001118	Dahong Denglong Gaogao Gua	1991	
00001124	Cyrano de Bergerac	1990	
00001005	Manhattan Murder Mystery	1993	
00001132	El Mariachi	1992	
00001136	Once Were Warriors	1994	
00001144	Priest	1994	
00001151	Pump Up the Volum	1990	
00001159	Benny and Joon	1993	
00001166	Six Degrees of Separation	1993	
00001174	Bawang Bie Ji	1993	
00001180	In the Line of Fire	1993	
00001186	Heavenly Creatures	1994	Braindead
00001191	Hoop Dreams	1994	
00001196	Seven	1995	
00001203	Shallow Grave	1994	
00001211	French Kiss	1995	
00001186	Braindead	1992	Heavenly Creatures
00001221	Clerks	1994	
00001226	Apollo 13	1995	
00001232	Reservoir Dogs	1992	Pulp Fiction
00001232	Pulp Fiction	1994	Reservoir Dogs
00001248	Short Cuts	1993	
00001255	Legends of the Fall	1994	
00001261	Natural Born Killers	1994	
00001268	In the Mouth of Madness	1995	
00001275	Forrest Gump	1994	
00001279	Malcolm X	1992	Jungle Fever
00001285	Dead Again	1991	
00001292	Jurassic Park	1993	
00001297	Clueless	1995	
00001306	Shadowlands	1993	
00001104	Amateur	1994	Trust
00001317	GoodFellas	1990	
00001325	Little Women	1994	
00001332	While You Were Sleeping	1995	
00001344	Psycho	1960	
00000461	Psycho	1998	
00001344	Psycho	1998	
00000542	Gladiator	2002	
00000001	Gladiator	2002	
\.


--
-- Data for Name: writer_award; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.writer_award (id, title, production_year, award_name, year_of_award, category, result) FROM stdin;
00001005	Bullets Over Broadway	1994	Oscar	1995	Best Writing	nominated
00001180	In the Line of Fire	1993	Oscar	1994	Best Writing	nominated
00000042	The Cider House Rules	1999	Oscar	1999	Written Based on previous Material	won
00000301	The Piano	1993	Oscar	1994	Written Directly for Screen	won
00000341	Strictly Ballroom	1992	AFI Award	1992	Best Screenplay	won
00000342	Strictly Ballroom	1992	AFI Award	1992	Best Screenplay	won
00000442	Traffic	2000	Golden Globe Awards	2001	Best Screenplay	won
00000442	Traffic	2000	Oscar	2001	Screenplay based on Material	won
00001005	Alice	1990	Oscar	1991	Best Writing	won
00000082	American Beauty	1999	Oscar	2000	Screenplay Written Directly for Screen	won
00000542	Gladiator	2002	Oscar	2003	Best Writing	nominated
00000542	Gladiator	2002	AFI Award	2003	Best Screenplay	nominated
00000542	Gladiator	2002	Golden Globe Awards	2003	Best Screenplay	nominated
00000542	Gladiator	2002	ALFS Award	2003	Best Writing	won
00000001	Gladiator	2002	Oscar	2003	Best Writing	nominated
00000001	Gladiator	2002	AFI Award	2003	Best Screenplay	nominated
00000621	Gladiator	2000	Oscar	2001	Best Writing	won
00001005	Bullets Over Broadway	1994	AFI Award	1995	Best Screenplay	nominated
\.


--
-- Name: pk_actor_award; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor_award
    ADD CONSTRAINT pk_actor_award PRIMARY KEY (title, production_year, description, award_name, year_of_award, category);


--
-- Name: pk_appearance; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appearance
    ADD CONSTRAINT pk_appearance PRIMARY KEY (title, production_year, description, scene_no);


--
-- Name: pk_award; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.award
    ADD CONSTRAINT pk_award PRIMARY KEY (award_name);


--
-- Name: pk_crew; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT pk_crew PRIMARY KEY (id, title, production_year);


--
-- Name: pk_crew_award; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew_award
    ADD CONSTRAINT pk_crew_award PRIMARY KEY (id, title, production_year, award_name, year_of_award, category);


--
-- Name: pk_director; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director
    ADD CONSTRAINT pk_director PRIMARY KEY (title, production_year);


--
-- Name: pk_director_award; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director_award
    ADD CONSTRAINT pk_director_award PRIMARY KEY (title, production_year, award_name, year_of_award, category);


--
-- Name: pk_movie; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie
    ADD CONSTRAINT pk_movie PRIMARY KEY (title, production_year);


--
-- Name: pk_movie_award; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_award
    ADD CONSTRAINT pk_movie_award PRIMARY KEY (title, production_year, award_name, year_of_award, category);


--
-- Name: pk_person; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT pk_person PRIMARY KEY (id);


--
-- Name: pk_rc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restriction_category
    ADD CONSTRAINT pk_rc PRIMARY KEY (description, country);


--
-- Name: pk_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT pk_role PRIMARY KEY (title, production_year, description);


--
-- Name: pk_scene; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scene
    ADD CONSTRAINT pk_scene PRIMARY KEY (title, production_year, scene_no);


--
-- Name: pk_writer; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writer
    ADD CONSTRAINT pk_writer PRIMARY KEY (id, title, production_year);


--
-- Name: pk_writer_award; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writer_award
    ADD CONSTRAINT pk_writer_award PRIMARY KEY (id, title, production_year, award_name, year_of_award, category);


--
-- Name: fk_actor_award_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor_award
    ADD CONSTRAINT fk_actor_award_1 FOREIGN KEY (title, production_year, description) REFERENCES public.role(title, production_year, description);


--
-- Name: fk_actor_award_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor_award
    ADD CONSTRAINT fk_actor_award_2 FOREIGN KEY (award_name) REFERENCES public.award(award_name);


--
-- Name: fk_appearance_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appearance
    ADD CONSTRAINT fk_appearance_1 FOREIGN KEY (title, production_year, description) REFERENCES public.role(title, production_year, description);


--
-- Name: fk_appearance_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appearance
    ADD CONSTRAINT fk_appearance_2 FOREIGN KEY (title, production_year, scene_no) REFERENCES public.scene(title, production_year, scene_no);


--
-- Name: fk_crew_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT fk_crew_1 FOREIGN KEY (title, production_year) REFERENCES public.movie(title, production_year);


--
-- Name: fk_crew_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT fk_crew_2 FOREIGN KEY (id) REFERENCES public.person(id);


--
-- Name: fk_crew_award_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew_award
    ADD CONSTRAINT fk_crew_award_1 FOREIGN KEY (id, title, production_year) REFERENCES public.crew(id, title, production_year);


--
-- Name: fk_crew_award_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew_award
    ADD CONSTRAINT fk_crew_award_2 FOREIGN KEY (award_name) REFERENCES public.award(award_name);


--
-- Name: fk_director_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director
    ADD CONSTRAINT fk_director_1 FOREIGN KEY (title, production_year) REFERENCES public.movie(title, production_year);


--
-- Name: fk_director_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director
    ADD CONSTRAINT fk_director_2 FOREIGN KEY (id) REFERENCES public.person(id);


--
-- Name: fk_director_award_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director_award
    ADD CONSTRAINT fk_director_award_1 FOREIGN KEY (title, production_year) REFERENCES public.director(title, production_year);


--
-- Name: fk_director_award_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director_award
    ADD CONSTRAINT fk_director_award_2 FOREIGN KEY (award_name) REFERENCES public.award(award_name);


--
-- Name: fk_movie_award_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_award
    ADD CONSTRAINT fk_movie_award_1 FOREIGN KEY (title, production_year) REFERENCES public.movie(title, production_year);


--
-- Name: fk_movie_award_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_award
    ADD CONSTRAINT fk_movie_award_2 FOREIGN KEY (award_name) REFERENCES public.award(award_name);


--
-- Name: fk_restriction_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restriction
    ADD CONSTRAINT fk_restriction_1 FOREIGN KEY (title, production_year) REFERENCES public.movie(title, production_year);


--
-- Name: fk_restriction_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restriction
    ADD CONSTRAINT fk_restriction_2 FOREIGN KEY (description, country) REFERENCES public.restriction_category(description, country);


--
-- Name: fk_role_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT fk_role_1 FOREIGN KEY (title, production_year) REFERENCES public.movie(title, production_year);


--
-- Name: fk_role_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT fk_role_2 FOREIGN KEY (id) REFERENCES public.person(id);


--
-- Name: fk_scene_movie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scene
    ADD CONSTRAINT fk_scene_movie FOREIGN KEY (title, production_year) REFERENCES public.movie(title, production_year);


--
-- Name: fk_writer_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writer
    ADD CONSTRAINT fk_writer_1 FOREIGN KEY (title, production_year) REFERENCES public.movie(title, production_year);


--
-- Name: fk_writer_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writer
    ADD CONSTRAINT fk_writer_2 FOREIGN KEY (id) REFERENCES public.person(id);


--
-- Name: fk_writer_award_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writer_award
    ADD CONSTRAINT fk_writer_award_1 FOREIGN KEY (id, title, production_year) REFERENCES public.writer(id, title, production_year);


--
-- Name: fk_writer_award_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writer_award
    ADD CONSTRAINT fk_writer_award_2 FOREIGN KEY (award_name) REFERENCES public.award(award_name);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO PUBLIC;


--
-- Name: TABLE actor_award; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.actor_award FROM PUBLIC;
REVOKE ALL ON TABLE public.actor_award FROM postgres;
GRANT ALL ON TABLE public.actor_award TO postgres;
GRANT SELECT ON TABLE public.actor_award TO PUBLIC;


--
-- Name: TABLE appearance; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.appearance FROM PUBLIC;
REVOKE ALL ON TABLE public.appearance FROM postgres;
GRANT ALL ON TABLE public.appearance TO postgres;
GRANT SELECT ON TABLE public.appearance TO PUBLIC;


--
-- Name: TABLE award; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.award FROM PUBLIC;
REVOKE ALL ON TABLE public.award FROM postgres;
GRANT ALL ON TABLE public.award TO postgres;
GRANT SELECT ON TABLE public.award TO PUBLIC;


--
-- Name: TABLE crew; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.crew FROM PUBLIC;
REVOKE ALL ON TABLE public.crew FROM postgres;
GRANT ALL ON TABLE public.crew TO postgres;
GRANT SELECT ON TABLE public.crew TO PUBLIC;


--
-- Name: TABLE crew_award; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.crew_award FROM PUBLIC;
REVOKE ALL ON TABLE public.crew_award FROM postgres;
GRANT ALL ON TABLE public.crew_award TO postgres;
GRANT SELECT ON TABLE public.crew_award TO PUBLIC;


--
-- Name: TABLE director; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.director FROM PUBLIC;
REVOKE ALL ON TABLE public.director FROM postgres;
GRANT ALL ON TABLE public.director TO postgres;
GRANT SELECT ON TABLE public.director TO PUBLIC;


--
-- Name: TABLE director_award; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.director_award FROM PUBLIC;
REVOKE ALL ON TABLE public.director_award FROM postgres;
GRANT ALL ON TABLE public.director_award TO postgres;
GRANT SELECT ON TABLE public.director_award TO PUBLIC;


--
-- Name: TABLE movie; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.movie FROM PUBLIC;
REVOKE ALL ON TABLE public.movie FROM postgres;
GRANT ALL ON TABLE public.movie TO postgres;
GRANT SELECT ON TABLE public.movie TO PUBLIC;


--
-- Name: TABLE movie_award; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.movie_award FROM PUBLIC;
REVOKE ALL ON TABLE public.movie_award FROM postgres;
GRANT ALL ON TABLE public.movie_award TO postgres;
GRANT SELECT ON TABLE public.movie_award TO PUBLIC;


--
-- Name: TABLE person; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.person FROM PUBLIC;
REVOKE ALL ON TABLE public.person FROM postgres;
GRANT ALL ON TABLE public.person TO postgres;
GRANT SELECT ON TABLE public.person TO PUBLIC;


--
-- Name: TABLE restriction; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.restriction FROM PUBLIC;
REVOKE ALL ON TABLE public.restriction FROM postgres;
GRANT ALL ON TABLE public.restriction TO postgres;
GRANT SELECT ON TABLE public.restriction TO PUBLIC;


--
-- Name: TABLE restriction_category; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.restriction_category FROM PUBLIC;
REVOKE ALL ON TABLE public.restriction_category FROM postgres;
GRANT ALL ON TABLE public.restriction_category TO postgres;
GRANT SELECT ON TABLE public.restriction_category TO PUBLIC;


--
-- Name: TABLE role; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.role FROM PUBLIC;
REVOKE ALL ON TABLE public.role FROM postgres;
GRANT ALL ON TABLE public.role TO postgres;
GRANT SELECT ON TABLE public.role TO PUBLIC;


--
-- Name: TABLE scene; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.scene FROM PUBLIC;
REVOKE ALL ON TABLE public.scene FROM postgres;
GRANT ALL ON TABLE public.scene TO postgres;
GRANT SELECT ON TABLE public.scene TO PUBLIC;


--
-- Name: TABLE writer; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.writer FROM PUBLIC;
REVOKE ALL ON TABLE public.writer FROM postgres;
GRANT ALL ON TABLE public.writer TO postgres;
GRANT SELECT ON TABLE public.writer TO PUBLIC;


--
-- Name: TABLE writer_award; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.writer_award FROM PUBLIC;
REVOKE ALL ON TABLE public.writer_award FROM postgres;
GRANT ALL ON TABLE public.writer_award TO postgres;
GRANT SELECT ON TABLE public.writer_award TO PUBLIC;


--
-- PostgreSQL database dump complete
--

