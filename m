From: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Thu, 2 Jul 2015 20:29:18 +0000
Message-ID: <D805D093-CCFE-4835-853A-B2654DAA10A1@caviumnetworks.com>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
 <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com>
 <558A6A84.5020603@arm.com> <20150624085128.GA22785@cbox>
 <558A7936.7020109@arm.com> <20150625123034.GE28244@cbox>
 <558BF6C9.3000009@arm.com> <558C05A9.8080201@arm.com>
 <CAFEAcA_ULz=ugQW=NmthzqYRtvcfwteQTh0DonHRN6U5NykEtQ@mail.gmail.com>
 <20150626095318.GG28244@cbox>
 <F37C68A5-E48F-462C-AD18-0F3C096348C7@caviumnetworks.com>
 <559180CA.3050905@arm.com>
 <CAFEAcA-E+KdiL4suQ0DoEvB-zGpNZ7-dq46FegC_iXYRPvo9jA@mail.gmail.com>
 <559185D4.7060308@arm.com>
 <85D36B67-643B-407F-944F-D18D54FF9909@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7874397720138170642=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7777E5782D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 16:18:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id au3ohRgSEewf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 16:18:03 -0400 (EDT)
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0098.outbound.protection.outlook.com [65.55.169.98])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59A065782C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 16:18:03 -0400 (EDT)
In-Reply-To: <85D36B67-643B-407F-944F-D18D54FF9909@caviumnetworks.com>
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
To: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "timur@codeaurora.org" <timur@codeaurora.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============7874397720138170642==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D805D093CCFE4835853AB2654DAA10A1caviumnetworkscom_"

--_000_D805D093CCFE4835853AB2654DAA10A1caviumnetworkscom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

is there a chance that this get merged in to 4.2? if not is it possible to =
accept the other patches like adding implementations explicitly(like Thunde=
r).

Thanks,
Tirumalesh.
On Jun 29, 2015, at 11:39 AM, Chalamarla, Tirumalesh <Tirumalesh.Chalamarla=
@caviumnetworks.com<mailto:Tirumalesh.Chalamarla@caviumnetworks.com>> wrote=
:


On Jun 29, 2015, at 10:52 AM, Marc Zyngier <marc.zyngier@arm.com<mailto:mar=
c.zyngier@arm.com>> wrote:

On 29/06/15 18:38, Peter Maydell wrote:
On 29 June 2015 at 18:30, Marc Zyngier <marc.zyngier@arm.com<mailto:marc.zy=
ngier@arm.com>> wrote:
On 29/06/15 18:13, Chalamarla, Tirumalesh wrote:
Will this also prevents migrating between same implementations,
if no how is this identified.

This shouldn't. It is pretty easy to look at the incoming guest's MIDR,
and verify that it matches the default MIDR on the receiving system. Any
difference, and the migration should abort.

Do you really want to forbid migration between (say)
Cortex-A57 r3p0 and Cortex-A57 r3p1 ?

That seems pretty harsh.

I think we may need to allow for some flexibility (same major version
only, or +/- 1 minor version...). The idea I'm trying to convey is that
with "generic CPI", migration is not guaranteed unless we're on
extremely similar hardware.

yes, this is the point i am trying to make, we need some flexibility. so th=
at it works with same chips with different passes may be.
if we are allowing this, then we are not putting emulation as a requirement=
.

Thanks,
Tirumalesh.

M.
--
Jazz is not dead. It just smells funny...


--_000_D805D093CCFE4835853AB2654DAA10A1caviumnetworkscom_
Content-Type: text/html; charset="us-ascii"
Content-ID: <346857972F79D046956B307E0A39AEEB@namprd07.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-lin=
e-break: after-white-space;" class=3D"">
is there a chance that this get merged in to 4.2? if not is it possible to =
accept the other patches like adding implementations explicitly(like Thunde=
r).
<div class=3D""><br class=3D"">
</div>
<div class=3D"">Thanks,</div>
<div class=3D"">Tirumalesh.&nbsp;<br class=3D"">
<div class=3D"">
<div>
<blockquote type=3D"cite" class=3D"">
<div class=3D"">On Jun 29, 2015, at 11:39 AM, Chalamarla, Tirumalesh &lt;<a=
 href=3D"mailto:Tirumalesh.Chalamarla@caviumnetworks.com" class=3D"">Tiruma=
lesh.Chalamarla@caviumnetworks.com</a>&gt; wrote:</div>
<br class=3D"Apple-interchange-newline">
<div class=3D"">
<blockquote type=3D"cite" style=3D"font-family: Helvetica; font-size: 12px;=
 font-style: normal; font-variant: normal; font-weight: normal; letter-spac=
ing: normal; line-height: normal; orphans: auto; text-align: start; text-in=
dent: 0px; text-transform: none; white-space: normal; widows: auto; word-sp=
acing: 0px; -webkit-text-stroke-width: 0px;" class=3D"">
<br class=3D"Apple-interchange-newline">
On Jun 29, 2015, at 10:52 AM, Marc Zyngier &lt;<a href=3D"mailto:marc.zyngi=
er@arm.com" class=3D"">marc.zyngier@arm.com</a>&gt; wrote:<br class=3D"">
<br class=3D"">
On 29/06/15 18:38, Peter Maydell wrote:<br class=3D"">
<blockquote type=3D"cite" class=3D"">On 29 June 2015 at 18:30, Marc Zyngier=
 &lt;<a href=3D"mailto:marc.zyngier@arm.com" class=3D"">marc.zyngier@arm.co=
m</a>&gt; wrote:<br class=3D"">
<blockquote type=3D"cite" class=3D"">On 29/06/15 18:13, Chalamarla, Tirumal=
esh wrote:<br class=3D"">
<blockquote type=3D"cite" class=3D"">Will this also prevents migrating betw=
een same implementations,<br class=3D"">
if no how is this identified.<br class=3D"">
</blockquote>
<br class=3D"">
This shouldn't. It is pretty easy to look at the incoming guest's MIDR,<br =
class=3D"">
and verify that it matches the default MIDR on the receiving system. Any<br=
 class=3D"">
difference, and the migration should abort.<br class=3D"">
</blockquote>
<br class=3D"">
Do you really want to forbid migration between (say)<br class=3D"">
Cortex-A57 r3p0 and Cortex-A57 r3p1 ?<br class=3D"">
<br class=3D"">
That seems pretty harsh.<br class=3D"">
</blockquote>
<br class=3D"">
I think we may need to allow for some flexibility (same major version<br cl=
ass=3D"">
only, or &#43;/- 1 minor version...). The idea I'm trying to convey is that=
<br class=3D"">
with &quot;generic CPI&quot;, migration is not guaranteed unless we're on<b=
r class=3D"">
extremely similar hardware.<br class=3D"">
<br class=3D"">
</blockquote>
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant: normal; font-weight: normal; letter-spacing: normal; line-he=
ight: normal; orphans: auto; text-align: start; text-indent: 0px; text-tran=
sform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-=
text-stroke-width: 0px; float: none; display: inline !important;" class=3D"=
">yes,
 this is the point i am trying to make, we need some flexibility. so that i=
t works with same chips with different passes may be.<span class=3D"Apple-c=
onverted-space">&nbsp;</span></span><br style=3D"font-family: Helvetica; fo=
nt-size: 12px; font-style: normal; font-variant: normal; font-weight: norma=
l; letter-spacing: normal; line-height: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; widows:=
 auto; word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant: normal; font-weight: normal; letter-spacing: normal; line-he=
ight: normal; orphans: auto; text-align: start; text-indent: 0px; text-tran=
sform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-=
text-stroke-width: 0px; float: none; display: inline !important;" class=3D"=
">if
 we are allowing this, then we are not putting emulation as a requirement.<=
span class=3D"Apple-converted-space">&nbsp;</span></span><br style=3D"font-=
family: Helvetica; font-size: 12px; font-style: normal; font-variant: norma=
l; font-weight: normal; letter-spacing: normal; line-height: normal; orphan=
s: auto; text-align: start; text-indent: 0px; text-transform: none; white-s=
pace: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0=
px;" class=3D"">
<br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; f=
ont-variant: normal; font-weight: normal; letter-spacing: normal; line-heig=
ht: normal; orphans: auto; text-align: start; text-indent: 0px; text-transf=
orm: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-te=
xt-stroke-width: 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant: normal; font-weight: normal; letter-spacing: normal; line-he=
ight: normal; orphans: auto; text-align: start; text-indent: 0px; text-tran=
sform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-=
text-stroke-width: 0px; float: none; display: inline !important;" class=3D"=
">Thanks,</span><br style=3D"font-family: Helvetica; font-size: 12px; font-=
style: normal; font-variant: normal; font-weight: normal; letter-spacing: n=
ormal; line-height: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; word-spacing:=
 0px; -webkit-text-stroke-width: 0px;" class=3D"">
<span style=3D"font-family: Helvetica; font-size: 12px; font-style: normal;=
 font-variant: normal; font-weight: normal; letter-spacing: normal; line-he=
ight: normal; orphans: auto; text-align: start; text-indent: 0px; text-tran=
sform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-=
text-stroke-width: 0px; float: none; display: inline !important;" class=3D"=
">Tirumalesh.<span class=3D"Apple-converted-space">&nbsp;</span></span><br =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; font-=
variant: normal; font-weight: normal; letter-spacing: normal; line-height: =
normal; orphans: auto; text-align: start; text-indent: 0px; text-transform:=
 none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-s=
troke-width: 0px;" class=3D"">
<br style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; f=
ont-variant: normal; font-weight: normal; letter-spacing: normal; line-heig=
ht: normal; orphans: auto; text-align: start; text-indent: 0px; text-transf=
orm: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-te=
xt-stroke-width: 0px;" class=3D"">
<blockquote type=3D"cite" style=3D"font-family: Helvetica; font-size: 12px;=
 font-style: normal; font-variant: normal; font-weight: normal; letter-spac=
ing: normal; line-height: normal; orphans: auto; text-align: start; text-in=
dent: 0px; text-transform: none; white-space: normal; widows: auto; word-sp=
acing: 0px; -webkit-text-stroke-width: 0px;" class=3D"">
<span class=3D"Apple-tab-span" style=3D"white-space: pre;"></span>M.<br cla=
ss=3D"">
--<span class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">
Jazz is not dead. It just smells funny...</blockquote>
</div>
</blockquote>
</div>
<br class=3D"">
</div>
</div>
</body>
</html>

--_000_D805D093CCFE4835853AB2654DAA10A1caviumnetworkscom_--

--===============7874397720138170642==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7874397720138170642==--
