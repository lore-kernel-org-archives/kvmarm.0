Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09AC4C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 28 Feb 2022 20:46:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C55D408C1;
	Mon, 28 Feb 2022 15:46:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kMRJoU4yW9-y; Mon, 28 Feb 2022 15:46:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04BFC49DED;
	Mon, 28 Feb 2022 15:46:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3117D49DED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Feb 2022 13:02:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E8qQXAXdwdbo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Feb 2022 13:02:56 -0500 (EST)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92A1C40BED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Feb 2022 13:02:56 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vadn1kU+Lzn0Xe7Y4Yt7kUPJrw8pN4cdq2BwFof9gvpbnAELtYRAUMWNVbEsZtbc7IKZYrMleS7a6FOgaT7zDHhfS/Y0Mo0NtJTw6+cy4yStqTuLa/AKEKQX5ZjjrHP530FqBurZje/wAhdcfCEfVoGgCjXAiSLjPcHyF9GAAld1UeoZJRTmlbCT37xXm8+6cfGEsvbBJ6AeljrKzqQhFWpkeoNNgcd0dIYgYwX1ia4+hhyaXEaZfeTHrC2GWf4zzTty2h9AHgHcO9ZEV5gG1OMegE5BYBhR2wiglGYAr1hMu//ztL0ISQxwLO3Zr3Q8whs3NoqgyKZ13tTUW6EC0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ispba06/vBc8D9pvm5abQM6b840mzrbXQvrSfMxygio=;
 b=EWrCmPADUbcSr/JOV1NiAK2xq6p01q5n354DWKl1NPGMiuSJyCF8o2+JbmFw3cCbWEhlatzp6YqZ0wF7dOh8GEXQw4f/SFwvWjPSc6t5dxdcYsmZmLAt8CAnqGalhptFUYYniZmxzyhzlkYIyaohvEgaczzqkKdgxS/Xg1FBSsFPAd0jgeWsOzwl2aVGLP1o8kkJo+oeionAJjbSxdaKrvw4WVeUQKzU7OgVpr8J7+Q/gUFS3DGfpWldV17cfrwSze5pj5gpB+6KVHcuxt6vzb2J9txCZnjy4S3kv2pYdlD7QxMHZyhfr0hNmpk+vR9KXJM8U8hlKzhLK2Vhd2y0WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ispba06/vBc8D9pvm5abQM6b840mzrbXQvrSfMxygio=;
 b=VzZxeShLNRZjxqmshYDpamIvjUkCykobIdeDphshPHtgFG2VKgOTqVwBpWBdpsEY7TglnYUBJMe9gIDvsaaGyIlWHRLjDsVU7ri9Vl+M9qZSGFuph/FTnzjyf8bCspr9/lU3S0dbjSwVPl0sqRSdtkvtLaaO1U0eBRj6pdWBArtollh9uHpF1WcYYxw4A4L1hh2tpunSPvP9W6Zq7g/YDgTpLh/6GAe37UzDW8rIlxmZthKLROFp4K49U9zGCSyDVGYlqN9tFNudDFFza8gUAzaos50pH8BHcc4u/LjNKznOV35lr0DYJAgFvD6RJcinQ1sFZmGfsioO71yfUpdBrw==
Received: from BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14)
 by SN1PR12MB2365.namprd12.prod.outlook.com (2603:10b6:802:2e::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 18:02:51 +0000
Received: from BYAPR12MB3192.namprd12.prod.outlook.com
 ([fe80::fdf5:3159:a592:7d32]) by BYAPR12MB3192.namprd12.prod.outlook.com
 ([fe80::fdf5:3159:a592:7d32%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 18:02:50 +0000
From: Eugene Huang <eugeneh@nvidia.com>
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: Timer delays in VM
Thread-Topic: Timer delays in VM
Thread-Index: AdgszUnmuyWPbbQDTHiT7yyfAge0rQ==
Date: Mon, 28 Feb 2022 18:02:50 +0000
Message-ID: <BYAPR12MB31927AEB9D0A4068ED12826DD9019@BYAPR12MB3192.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a46a954-727f-4c5b-ec16-08d9fae4891a
x-ms-traffictypediagnostic: SN1PR12MB2365:EE_
x-microsoft-antispam-prvs: <SN1PR12MB2365EEFA19DB2BFB18303895D9019@SN1PR12MB2365.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pCyFMSt2ZDJx7nDwAzOYEA6PxKcKIT2neiaDhw+6LRRU80JMvob7F98pfFgUQdYfgxOyuLNmz//Epba1VbNlP2kZfyuEPEKsTVFRmrRwWB7clBGjqvEaGo58aggxZiB/dWDiRA+pAJ8arYR/RY/65cf56+6+G8Z7tshIBY0jhTac8QDFXFMjVHfWs16UMRWG+Qsydwa2FdHmzMxqJhD6BOxD511QehFHp/DlRnrkpMLTlQonSWDBtq0E2ZXZwhXXWFU5rTzH/W0EYSz00sN8mX3B1aqjikKq56ZOHBdGj26qOap5Snl3Jq2qcD6rbx+dn0zIbGaaFDttGPCdUgWDMG4KWdq/21Cj2ZRYw5b1SijiHkqhaLrXOffKRih/19LKyhu0wR6xYHBTkvVP8dz4b7gIWGUkMh66ZWmbfmh1UqMDZyNhu0Ta7SmqSy+iJDGX2rXAgUWg/u7qJ09dErwTd6M8d/O3TMj/RLUSZW7R8lY+4a0w1s9ZSmPrRQZKcwe/M1M9H+i8jOOqzsJrA8044VStBVsbbNGfoFK6JuabbkNFdFBmIAujy3Med99uFAkEqy0PuYEzxFIlsi46LiHuCYdvta5/cGjuuaoQpM2CkKQkZeEi7nYb0JOQ8gWXX+5Lm1NFEj7RcjehqaVK4QpdM9+YWoNoP0gqJLqDzIaQ/aOXYuFgdTjvohN1fixBGl+yRdkldc1GqnFTPofrVl/Y5A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BYAPR12MB3192.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(6506007)(66946007)(7696005)(76116006)(66556008)(66476007)(83380400001)(66446008)(38100700002)(71200400001)(122000001)(26005)(3480700007)(55016003)(316002)(5660300002)(9686003)(186003)(9326002)(64756008)(6916009)(33656002)(52536014)(8936002)(38070700005)(86362001)(508600001)(2906002)(8676002)(4744005);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EgGjmwRvbxDCwSUuWZD/9ewuIsBV5ibNXHs8Fi2XevDTUJLaXGXEGgbEJ9i1?=
 =?us-ascii?Q?2CTgXLrmUNLbz9ITc/XgOisYDBtjI6kyKvu+ijQGU3plUIsopPrP0IA6XqK6?=
 =?us-ascii?Q?LKvzgMijYLKxJL/55vb74gWIp1lm2l5fDiNDbAe9KiM91GtUIF0VugPhVSne?=
 =?us-ascii?Q?Z0LLtzb3JJE7mwOs3mdcV7cB/JU31FRybFi+ivchCXswsejhS5YIRCp+QGY7?=
 =?us-ascii?Q?+uAwq8x73Z0dK2cZ6BrDBmZ1INH9+gE4HTYHuYSsLLDxefWZTTKe44FEoRts?=
 =?us-ascii?Q?Yq8pjr3PdPkvGQ2NlHtF9MPJ5lzWgR4ccUanni9vAAwzZISs43vc09l+BAqI?=
 =?us-ascii?Q?zGTcYRF7c8nsuTWl7PZNPiSMwLiGIPgJhRyqovXbooe6bDiqcBqb//EH5Zi2?=
 =?us-ascii?Q?IXzLA0obXYMxW6SAoKJp2fYMVZ7mgz28qD2yWHL2EHodLXJcEZ7m2kLq3vZh?=
 =?us-ascii?Q?9nsQytncbOC/2WF58F6NqgesKjSHSHkuk4YJOpvCWl3VhtQ6XAi9CmovgRs/?=
 =?us-ascii?Q?m3X+6aiSu5fUNUMB4NIPSWuUqGVczqwhnI/pfdawjI5pScVofCch39lhUoyZ?=
 =?us-ascii?Q?VeaHs1OXdoT/OYWsUKo9dx2opC1fdB4Py+O3r9MkFGkz+/TiRY7gJJ6fQUhN?=
 =?us-ascii?Q?nX6gqnGCUhvQgg+dZzOWvvuXlgJgh8ry1Dt1856k99+gLFcAZOsgKx32lefE?=
 =?us-ascii?Q?uuQd4n97ejTX092JqvQeMClKU3HYLVqvLGPnZCIObRmts11jdXuZ5sLA3LLm?=
 =?us-ascii?Q?W4GaSS2gIFhB4oH4SjCqZ5xsgw3FU6eJ86DX4VIu4lvK26bSA/iS59SuGV3K?=
 =?us-ascii?Q?yU42TQmqdtHryBwIIoO6fVm+RlIkURTJVYmQXbUPqjo1ykNQ2qmlCUnvdIEE?=
 =?us-ascii?Q?MZ2goDrViHMSTF5dRiZg3vE5fsSnYTZ8728Ny8fz7WnisMCko2PtMb6FIow5?=
 =?us-ascii?Q?5uptOqwBdKOJtAKu6cmCPJ//jE2piA7nvXs/cSnzwZfl4Th7NboaYy72lpef?=
 =?us-ascii?Q?QhNeGKQbac4qbNvU0LBGwhfsZZqIii8xleOBVNCCvD8HZH9Cq4porCBe9Z7H?=
 =?us-ascii?Q?/JiRsxakrb/gfEgr25S/blkvKIC2WwKyzJEZOzz9g27HExIEG+ERSWDIiA/o?=
 =?us-ascii?Q?+my2QW2Oi3zibztthnX7smzLGetW1UX+1uc4phjMLrKKsrK0MhIxF0z67B+7?=
 =?us-ascii?Q?VO1BA9RkZn8rJDOjZQclCdnb7ZWheKefGYXukB1hVtLFn4/73CxuI2MsWtuU?=
 =?us-ascii?Q?bQDSPGWz7Yo5dgcHZYzOpYTIDAdS0Zo4xzwUUwWTOV1VyJsPxFSR8Lt6323S?=
 =?us-ascii?Q?8q4NskLqpu78ctLuNKOkirQm1ILlALO/AeJxMFLXklufjn/uWMJCtJMoharg?=
 =?us-ascii?Q?nx8yzuQWgeifk9JD+dVFvTSc2+SS0qC2lVO04N2VHHwr5LBRMk9aif+VwPCS?=
 =?us-ascii?Q?HRH2nn74S4H276MA8KjaQ0fxfmxJ+Ow0xPp1R5kIsKAn5irX+WAAL/DNiAgP?=
 =?us-ascii?Q?ju9Xsq5ynBgr71fnLv3gQXAdlQwQvb/grIfGXsAW92sXLacCaaXul/0+39FM?=
 =?us-ascii?Q?qawkN7m4NPDobHkMi1WORShgnEOGtze7yd2Y0ho7pYNmWGBwTIg3dqcArjNO?=
 =?us-ascii?Q?uT3vQasBieB3ruCWz+2hqzE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a46a954-727f-4c5b-ec16-08d9fae4891a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 18:02:50.8897 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4M0NUs54uJfHR1aAJl+IE8KW7yHqFyiQ95qWohowZqmwvwm/Yc5TXqqAepFAOH4zKe8vyuz4IlUwbjT4p5VeHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2365
X-Mailman-Approved-At: Mon, 28 Feb 2022 15:45:59 -0500
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
Content-Type: multipart/mixed; boundary="===============7713813639751332571=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============7713813639751332571==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BYAPR12MB31927AEB9D0A4068ED12826DD9019BYAPR12MB3192namp_"

--_000_BYAPR12MB31927AEB9D0A4068ED12826DD9019BYAPR12MB3192namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I am running qemu on an arm64 CentOS host. Inside a ubuntu VM, a process ru=
ns a timer created using timer_t:
ev.sigev_notify_function =3D m_callback;
...
timer_create(CLOCK_MONOTONIC, &ev, &m_timer_t);

This timer sometimes has significant delays. For example, the 50 ms timer c=
an have a callback delay of 100ms.

I did a host kernel trace and see a lot of WFx kvm_exits, and  the followin=
g events between kvm_exit and kvm_entry:
kvm_exit
kvm_wfx_arm64
kvm_get_timer_map
sched_switch
kvm_timer_save_state
kvm_timer_update_irq
vgic_update_irq_pending
kvm_timer_restore_state
kvm_vcpu_wakeup
kvm_arm_setup_debug
kvm_arm_set_dreg32
kvm_entry

I have the following questions:

  1.  Why there are a lot WFx exits? Is the timer dependent on it?
  2.  Does this timer rely on kvm timer irq injection?
  3.  What can be any possible causes for the timer delay? Are there some l=
ocking mechanisms which can cause the delay?
  4.  What parameters can tune this timer?

Thanks.


--_000_BYAPR12MB31927AEB9D0A4068ED12826DD9019BYAPR12MB3192namp_
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
	{font-family:DengXian;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"\@DengXian";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
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
/* List Definitions */
@list l0
	{mso-list-id:1164781690;
	mso-list-type:hybrid;
	mso-list-template-ids:-1218272158 67698703 67698713 67698715 67698703 6769=
8713 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level2
	{mso-level-number-format:alpha-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level3
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	text-indent:-9.0pt;}
@list l0:level4
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level5
	{mso-level-number-format:alpha-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level6
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	text-indent:-9.0pt;}
@list l0:level7
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level8
	{mso-level-number-format:alpha-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level9
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	text-indent:-9.0pt;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72" style=3D"word-wrap:=
break-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I am running qemu on an arm64 CentOS host. Inside a =
ubuntu VM, a process runs a timer created using timer_t:<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;">ev.sigev_notify_function =3D m_c=
allback;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;">&#8230;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;">timer_create(CLOCK_MONOTONIC, &a=
mp;ev, &amp;m_timer_t);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">This timer sometimes has significant delays. For exa=
mple, the 50 ms timer can have a callback delay of 100ms.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I did a host kernel trace and see a lot of WFx kvm_e=
xits, and &nbsp;the following events between kvm_exit and kvm_entry:<o:p></=
o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">kvm_exit<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">kvm_wfx_arm64<o:p></=
o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">kvm_get_timer_map<o:=
p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">sched_switch<o:p></o=
:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">kvm_timer_save_state=
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">kvm_timer_update_irq=
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">vgic_update_irq_pend=
ing<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">kvm_timer_restore_st=
ate<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">kvm_vcpu_wakeup<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">kvm_arm_setup_debug<=
o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">kvm_arm_set_dreg32<o=
:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:.5in"><span style=3D"font-size:=
9.0pt;font-family:&quot;Courier New&quot;;color:black">kvm_entry<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;;color:black"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal">I have the following questions:<o:p></o:p></p>
<ol style=3D"margin-top:0in" start=3D"1" type=3D"1">
<li class=3D"MsoListParagraph" style=3D"margin-left:0in;mso-list:l0 level1 =
lfo1">Why there are a lot WFx exits? Is the timer dependent on it?<o:p></o:=
p></li><li class=3D"MsoListParagraph" style=3D"margin-left:0in;mso-list:l0 =
level1 lfo1">Does this timer rely on kvm timer irq injection?<o:p></o:p></l=
i><li class=3D"MsoListParagraph" style=3D"margin-left:0in;mso-list:l0 level=
1 lfo1">What can be any possible causes for the timer delay? Are there some=
 locking mechanisms which can cause the delay?<o:p></o:p></li><li class=3D"=
MsoListParagraph" style=3D"margin-left:0in;mso-list:l0 level1 lfo1">What pa=
rameters can tune this timer?<o:p></o:p></li></ol>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_BYAPR12MB31927AEB9D0A4068ED12826DD9019BYAPR12MB3192namp_--

--===============7713813639751332571==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7713813639751332571==--
