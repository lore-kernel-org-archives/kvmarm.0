Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C58C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 08:33:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93CF060EE3
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 08:33:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 93CF060EE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=riscure.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D1EC4B0E1;
	Mon, 11 Oct 2021 04:33:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@riscure.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SC3T5xZLlqHk; Mon, 11 Oct 2021 04:33:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C796F4B0CC;
	Mon, 11 Oct 2021 04:33:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D1BC4A531
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 03:06:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 72j2w2IUscd6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 03:06:38 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70121.outbound.protection.outlook.com [40.107.7.121])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9C274A19A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 03:06:37 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHFgeIDuiJn/5H+3eVCppwbRw01A/UVUIQUxDmx3ZGrJ4ld5cLJBNW6RKDe40jlrYcSa9BBOuPh5Uty/MeSjm1CiXHG8t/GlfWhwfhzZ3cVXhfKFq9vsSZQV9HFGkQ+aNDYtmqkBIR/yyRgXNb0GNBzCbUNAk/ZxakaTwnIMlFcnfXAXeh/aZGaWXrtb11IC1Z5lJj6gIv31/gCqMQ0Wr24uYm3heaeXcZCiHnAohAckTVNsOyIgECRd3EvdJGk43Qiwy8jJvb+QryrsNWTrEbTbyPBcLXHkFT1pzLneCPz77Aa+zz8XYGFh2mqvCL9DDKsUDOjEDkTMaBrZXz4kAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJCpj/0/hTSSCPocHI+7xSEoJ8pXT3ioL28W2OveOg8=;
 b=m0ljnu7F+DPMpFxRTgSCYJ5XQGljLglWjHhnSH0Nc7i57agSX8HEk+WVfJ7q3x/YMGyIweiupMpIw7zmePaPMZQ946baqA/TUMgWYLkW+Ak5fYfcfN8ZmvO19v8WbIQWXUguVgHI7xUsRt6AT3PWZdPm3y56+qhdKl0EJBsW0EBA1OF2YfiZ8iDliuUMlO1jyUl1u7dpIHcSupgT8t02hbtfzntvU9UyUk0c2Fli4A5Q4Nuk1n6l8E3/CObrES8nwMPsov2k1fQKSG0wHeij5szPiTOzpbqc0jjoChmbevaEk9qYEsakyPeIP2DovisD8+JPA+eKtwB+SuxeAa2+5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=riscure.com; dmarc=pass action=none header.from=riscure.com;
 dkim=pass header.d=riscure.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riscure.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJCpj/0/hTSSCPocHI+7xSEoJ8pXT3ioL28W2OveOg8=;
 b=iOgjSBftRzTv5zHYYWeAxqVV+lwCFm/qyGOrJZ+PYp9hs/4fWLeZes8fvPyVgtsVExV1G+k7Oo2Q5lu5igJ7uIiFxMPrpOjnYr+uN8pp1h2YiMNC8mQaqreFKc3lj+8PUmdok5nKsUHl8ye2QoZ91EY3Pu0SNevuaHDV/PoWruc=
Received: from VI1P18901MB0624.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:800:11e::19) by VI1P18901MB0175.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801:4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Mon, 11 Oct
 2021 07:06:34 +0000
Received: from VI1P18901MB0624.EURP189.PROD.OUTLOOK.COM
 ([fe80::8d66:a3a3:1362:50cc]) by VI1P18901MB0624.EURP189.PROD.OUTLOOK.COM
 ([fe80::8d66:a3a3:1362:50cc%7]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 07:06:33 +0000
From: Zaheer Syed <syed@riscure.com>
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: Special KVM Development Project @ Riscure
Thread-Topic: Special KVM Development Project @ Riscure
Thread-Index: Ade+bncJpVfIdmItTvqL0ie4g4IIeQ==
Date: Mon, 11 Oct 2021 07:06:33 +0000
Message-ID: <VI1P18901MB06244BA740CBA013E9AFBC6BD7B59@VI1P18901MB0624.EURP189.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lists.cs.columbia.edu; dkim=none (message not signed)
 header.d=none; lists.cs.columbia.edu;
 dmarc=none action=none header.from=riscure.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88e09c4a-857d-4cff-ed28-08d98c85a8a6
x-ms-traffictypediagnostic: VI1P18901MB0175:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P18901MB0175F7DF0C096DB36DB77A62D7B59@VI1P18901MB0175.EURP189.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A6EMLsVOcU71Sh4MPP1XJpt3aeGYNtfcCcJM0cBxCL3D6bSpnrccVJPvqH0c6pXm00tuwz4xNlvEe7wgvbjSsssgfs1xzv0F913QHm64epnKPaOYQV7pdDUSva5saAv7bxOOTzufqLSXYB7xxdEsTw5PfH6fhDscfBf1w/bTxZs6MrvLwuywPg/9qk1456LUv1YGQje407I1hX1Va2ihMOTxpYEaboJrSYKat0bWv/vni4XoSprnevikLMqOYqOQnbaoItpCkA/AtEEgL3dRJfvxOlrQNlTYhdUTJ1hLmLWeFctAa765t8mdySNEFevOg5jjLf7PRI6CPdC9HpryGJipOVpRe/1S37t4GOUlGZ4OnD18eNfUqBgMmeZuHyZVORTd29WUtxCx0+HgcjuCsXE96c5XNz8MaLlNG0akMaAsdeTV3CPZk8ksm3SclslambX+us25Q/gtvzkmtcL4KWMA5RkNn7E+FB3DksnG/+B0EenR22FOr8Fnu0Otu2tbOPfI/6ARacYcf2MVVVjoaeEnYM2uWkD61JTq2RKxOCXLHms9x4nOG32+niVRfrkWcyDqs2GWbXOsSf2vNjJAbmtBpMMSJj2ZQQq6lJHILC4bra8tiUqzKx0JKh2slHhLwhvto0ND9z9Qi+3lmtQK6OHQbC4K6POWIkEHDGgKxFXKGAsMSCaIaX+nsjmY1HvIZd+/MsX/z8kPB3y0+smRwA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1P18901MB0624.EURP189.PROD.OUTLOOK.COM; PTR:; CAT:NONE;
 SFS:(39830400003)(396003)(136003)(366004)(346002)(376002)(66446008)(76116006)(66946007)(64756008)(86362001)(66556008)(33656002)(66476007)(71200400001)(107886003)(186003)(9326002)(9686003)(6506007)(316002)(7696005)(8936002)(55016002)(508600001)(122000001)(83380400001)(2906002)(5660300002)(6916009)(38100700002)(52536014)(4326008)(38070700005)(8676002)(4744005);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VApj6lgrXDrS4Rw6W9ophdLcbnBNmQbIlq5qroLT8WZP+voKw58tFICBYBhT?=
 =?us-ascii?Q?u6xvD8doKH5bAeG3xeFwZziUBX8ppmiPpmXiHGgRXTLzNgzvTddbEPyuakkm?=
 =?us-ascii?Q?qiCnBVPZhlSdtdCp1Zqib3UfxidHiLDeATJrUyGee8ychzHyakgOprTS5vNn?=
 =?us-ascii?Q?aTb+EmgcGsjA0ZtwmZcor2Xl5ZwK9+BM4XiyscM81aJjNtTvC3E6kHaI/LVg?=
 =?us-ascii?Q?Gf0fvk+vCo35AIerdfZDo589uGLhrcEI7sE6/u6xFfxMAZH9KHau7eI6LyeH?=
 =?us-ascii?Q?TcQ1qhoVdJX1HnrX9L0x0EtEHlOD6IaWF4LYdSplwpnQZpWlmUvGOL6LOXHO?=
 =?us-ascii?Q?Cb/bzKcggwbaYo7HEkTSkLvzSYGfivnQ9RXBt1mKOLxj++x7YHezoL3fiJzf?=
 =?us-ascii?Q?J32W4vqdaARu9mCR06T04LFuJvvEq4t3U6iEmzs77Q11pGZLO7zhJ2rX0UeO?=
 =?us-ascii?Q?wPw5IrsLA978qtESaEocAXlCwSWNdQ6t8Fx4KJ/weGotEno5yLIU12cmSUd3?=
 =?us-ascii?Q?tj8VNIgC08FUH1H17Lr5cxHrEIWIJaFCHSOZ6FYTLMcFJY4jCqZBqizpTsX8?=
 =?us-ascii?Q?HZEhO7K/yDcSm13QG7QhxtB28F/odRKkI+6RQaIlrZomioK271LRBclvYuqy?=
 =?us-ascii?Q?aq42clZdAuaMrdCTq+FMKd+lTRR77SYYLK4OGc08JFESq9lKropaKSFKG4Cr?=
 =?us-ascii?Q?LOa0LmQNBG8YXlV0J3Lk2+68Nmgv8e7C89ASfZSwhWz0pCeYpj4PyH6Yz57e?=
 =?us-ascii?Q?wiFHJBv3Jc7G6MpYheiHRPh1xo8hW744TqQ7t6UI/hbs4UMhjCDRv6XFcdla?=
 =?us-ascii?Q?TVP9Ic9G05dk9klKLAhSjCg28+bE460KUrXF3uw2pYhfp/51w3sM6NydYK0b?=
 =?us-ascii?Q?jllTvdzU9pZfMePmDhc1RN9QvCUXbv7hsxZFUU2zLCedpzlyQF5MxKm6TsUD?=
 =?us-ascii?Q?ofPOC8mj9vQJ9hKIXoG2V8AYv7/whmBT+pKKbRPvDchWGQytlX538mjONoIc?=
 =?us-ascii?Q?61Ql6gyZJCD9+3xPIPdk6wPmwf6zCxhO1eb15VnB5dzj5KtXDSAV5mexqGg4?=
 =?us-ascii?Q?2e2fE8gRh2pONOi9eckotYFzDkNkt8vpb6xV3iFe3sak+Imbm+NE/OyZmF21?=
 =?us-ascii?Q?vzPAPW6XL97AJUGJVCgtjw6InoyGxDPGWeifhgMrmgbVtuByN1sv8hY9bJkU?=
 =?us-ascii?Q?LP7N8rPotty1UB7Ke+PvyuYZ1BTieiK6KnNOp/ayCNb4CjizktM/iPXNA2mt?=
 =?us-ascii?Q?7PUjmPvMpRLfji7pICSOlRjslVAoWhJGht4/4AJFMnVHO5bnnE1F9m7eG+H3?=
 =?us-ascii?Q?JIEsCUk/6nLgGMd+5K4VTacm219nTYge42us5zynkvWOSb5oSo/ULPK0+kQ3?=
 =?us-ascii?Q?0U+iMYaOlVWXLJisrWDFmidNhtfv?=
MIME-Version: 1.0
X-OriginatorOrg: riscure.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1P18901MB0624.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e09c4a-857d-4cff-ed28-08d98c85a8a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 07:06:33.5277 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3a3321e5-d4a5-4381-9178-450f4b5de9e6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wk8yLS7Ih0JR5gvq6i8BcGs5eeOtKweEsnCCy5xWUnNP/6TXOyngY1gu2rhbH6erfdU9/kJ1LJnZzurVONDtkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P18901MB0175
X-Mailman-Approved-At: Mon, 11 Oct 2021 04:33:52 -0400
Cc: Jasper van Woudenberg <vanWoudenberg@riscure.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6378876260621781928=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============6378876260621781928==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_VI1P18901MB06244BA740CBA013E9AFBC6BD7B59VI1P18901MB0624_"

--_000_VI1P18901MB06244BA740CBA013E9AFBC6BD7B59VI1P18901MB0624_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,

My name is Zaheer, and I am reaching out with regards to a specific project=
 that is under development at Riscure.

This pertains to KVM hypervisor development & modification, in order for us=
 to enable specific fuzzing use cases. We hope, if successful, to also upst=
ream this KVM modification the Linux kernel as well.

As this is a listed email alias on the Linux KVM IRC page, would this be of=
 any interest to you in supporting Riscure as a contractor specifically for=
 this project?

If so, it would be great to share more specific details on the timeline and=
 responsibilities scope/specifics.

Thanks!

Best regards & thanks,
Zaheer


--_000_VI1P18901MB06244BA740CBA013E9AFBC6BD7B59VI1P18901MB0624_
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
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
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
<p class=3D"MsoNormal">Hello,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">My name is Zaheer, and I am reaching out with regard=
s to a specific project that is under development at Riscure.<o:p></o:p></p=
>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">This pertains to KVM hypervisor development &amp; mo=
dification, in order for us to enable specific fuzzing use cases. We hope, =
if successful, to also upstream this KVM modification the Linux kernel as w=
ell.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">As this is a listed email alias on the Linux KVM IRC=
 page, would this be of any interest to you in supporting Riscure as a cont=
ractor specifically for this project?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">If so, it would be great to share more specific deta=
ils on the timeline and responsibilities scope/specifics.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks!<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Best regards &amp; thanks,<o:p></o:p></p>
<p class=3D"MsoNormal">Zaheer<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_VI1P18901MB06244BA740CBA013E9AFBC6BD7B59VI1P18901MB0624_--

--===============6378876260621781928==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6378876260621781928==--
