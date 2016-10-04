From: Eugene Bagdasaryan <eb693@cornell.edu>
Subject: development guide for installing KVMARM kernel
Date: Tue, 4 Oct 2016 18:13:01 +0000
Message-ID: <CY1PR0401MB1629013D592E886EF2332C80EEC50@CY1PR0401MB1629.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6189359864377658292=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C918A412A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Oct 2016 14:03:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2b5i1msT2tfe for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Oct 2016 14:03:21 -0400 (EDT)
Received: from limerock03.mail.cornell.edu (limerock03.mail.cornell.edu
 [128.84.13.243])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8A61412A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Oct 2016 14:03:21 -0400 (EDT)
Received: from exchange.cornell.edu (sf-e2013-05.exchange.cornell.edu
 [10.22.40.52])
 by limerock03.mail.cornell.edu (8.14.4/8.14.4_cu) with ESMTP id u94ID0P2009764
 for <kvmarm@lists.cs.columbia.edu>; Tue, 4 Oct 2016 14:13:04 -0400
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============6189359864377658292==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CY1PR0401MB1629013D592E886EF2332C80EEC50CY1PR0401MB1629_"

--_000_CY1PR0401MB1629013D592E886EF2332C80EEC50CY1PR0401MB1629_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hey guys

I am trying to install KVMARM kernel on my RPi3, I have found a link to Dev=
 guide (http://www.virtualopensystems.com/en/solutions/guides/kvm-on-arm/) =
the guide seems a bit outdated, since it links to git repo https://github.c=
om/virtualopensystems/linux-kvm-arm that has the latest commit dated back t=
o 2014.
Can you please point me to the correct way to install this on RaspbianOS (4=
.4.11-v7+)


Thank you,
Eugene


--_000_CY1PR0401MB1629013D592E886EF2332C80EEC50CY1PR0401MB1629_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hey guys<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I am trying to install KVMARM kernel on my RPi3, I h=
ave found a link to Dev guide (<a href=3D"http://www.virtualopensystems.com=
/en/solutions/guides/kvm-on-arm/">http://www.virtualopensystems.com/en/solu=
tions/guides/kvm-on-arm/</a>) the guide
 seems a bit outdated, since it links to git repo <a href=3D"https://github=
.com/virtualopensystems/linux-kvm-arm">
https://github.com/virtualopensystems/linux-kvm-arm</a> that has the latest=
 commit dated back to 2014.<o:p></o:p></p>
<p class=3D"MsoNormal">Can you please point me to the correct way to instal=
l this on RaspbianOS (4.4.11-v7&#43;)<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thank you,<o:p></o:p></p>
<p class=3D"MsoNormal">Eugene<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_CY1PR0401MB1629013D592E886EF2332C80EEC50CY1PR0401MB1629_--

--===============6189359864377658292==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6189359864377658292==--
