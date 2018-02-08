From: =?UTF-8?B?SsOpcsOpbXkgRmFuZ3XDqGRl?= <j.fanguede@virtualopensystems.com>
Subject: Re: [PATCH] KVM: arm64: Enable the EL1 physical timer for AArch32
 guests
Date: Thu, 8 Feb 2018 15:10:16 +0100
Message-ID: <CAGE1QJqJ15zNDU-DVj8zwNL210Lo_iz5qOFm=5CEOQhKx0tfhA@mail.gmail.com>
References: <1518091039-17356-1-git-send-email-j.fanguede@virtualopensystems.com>
 <51fa6f87-4d4d-0c14-9fb0-6ce0d2808ce3@arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1469012785053975140=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DC8449DFA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Feb 2018 09:05:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lS1bKsDVGOvJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Feb 2018 09:04:45 -0500 (EST)
Received: from mail-ot0-f177.google.com (mail-ot0-f177.google.com
 [74.125.82.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 448DB49DE6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Feb 2018 09:04:45 -0500 (EST)
Received: by mail-ot0-f177.google.com with SMTP id a2so4431417otf.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Feb 2018 06:10:47 -0800 (PST)
In-Reply-To: <51fa6f87-4d4d-0c14-9fb0-6ce0d2808ce3@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

--===============1469012785053975140==
Content-Type: multipart/alternative; boundary="94eb2c1924f474fbd70564b3fa72"

--94eb2c1924f474fbd70564b3fa72
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Thu, Feb 8, 2018 at 1:08 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:

> On 08/02/18 11:57, J=C3=A9r=C3=A9my Fangu=C3=A8de wrote:
> > Some 32bits guest OS can use the CNTP timer, however KVM does not
> > handle the accesses, injecting a fault instead.
> >
> > Use the proper handlers to emulate the EL1 Physical Timer (CNTP)
> > register accesses of AArch32 guests.
> >
> > Signed-off-by: J=C3=A9r=C3=A9my Fangu=C3=A8de <j.fanguede@virtualopensy=
stems.com>
> > Signed-off-by: Alvise Rigo <a.rigo@virtualopensystems.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 50a43c7..c0ab4f7 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1545,6 +1545,11 @@ static const struct sys_reg_desc cp15_regs[] =3D=
 {
> >
> >       { Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, c13_CI=
D
> },
> >
> > +     /* CNTP_TVAL */
> > +     { Op1( 0), CRn(14), CRm( 2), Op2( 0), access_cntp_tval },
> > +     /* CNTP_CTL */
> > +     { Op1( 0), CRn(14), CRm( 2), Op2( 1), access_cntp_ctl },
> > +
> >       /* PMEVCNTRn */
> >       PMU_PMEVCNTR(0),
> >       PMU_PMEVCNTR(1),
> > @@ -1618,6 +1623,7 @@ static const struct sys_reg_desc cp15_64_regs[] =
=3D {
> >       { Op1( 0), CRn( 0), CRm( 9), Op2( 0), access_pmu_evcntr },
> >       { Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi },
> >       { Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL,
> c2_TTBR1 },
> > +     { Op1( 2), CRn( 0), CRm(14), Op2( 0), access_cntp_cval },
> >  };
> >
> >  /* Target specific emulation tables */
> >
>
> Seems OK to me. Can you please update the corresponding 32bit code while
> you're at it?
>
I'm working on it, I'll send soon the arm 32bit version, once tested.

Jeremy

>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
>

--94eb2c1924f474fbd70564b3fa72
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Marc,<br><div><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Thu, Feb 8, 2018 at 1:08 PM, Marc Zyngier <span dir=3D"=
ltr">&lt;<a href=3D"mailto:marc.zyngier@arm.com" target=3D"_blank">marc.zyn=
gier@arm.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div c=
lass=3D"m_5950063223294626919m_6811923720026052507m_-4744201811796511766HOE=
nZb"><div class=3D"m_5950063223294626919m_6811923720026052507m_-47442018117=
96511766h5">On 08/02/18 11:57, J=C3=A9r=C3=A9my Fangu=C3=A8de wrote:<br>
&gt; Some 32bits guest OS can use the CNTP timer, however KVM does not<br>
&gt; handle the accesses, injecting a fault instead.<br>
&gt;<br>
&gt; Use the proper handlers to emulate the EL1 Physical Timer (CNTP)<br>
&gt; register accesses of AArch32 guests.<br>
&gt;<br>
&gt; Signed-off-by: J=C3=A9r=C3=A9my Fangu=C3=A8de &lt;<a href=3D"mailto:j.=
fanguede@virtualopensystems.com" target=3D"_blank">j.fanguede@virtualopensy=
stems<wbr>.com</a>&gt;<br>
&gt; Signed-off-by: Alvise Rigo &lt;<a href=3D"mailto:a.rigo@virtualopensys=
tems.com" target=3D"_blank">a.rigo@virtualopensystems.com</a><wbr>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 arch/arm64/kvm/sys_regs.c | 6 ++++++<br>
&gt;=C2=A0 1 file changed, 6 insertions(+)<br>
&gt;<br>
&gt; diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c<br>
&gt; index 50a43c7..c0ab4f7 100644<br>
&gt; --- a/arch/arm64/kvm/sys_regs.c<br>
&gt; +++ b/arch/arm64/kvm/sys_regs.c<br>
&gt; @@ -1545,6 +1545,11 @@ static const struct sys_reg_desc cp15_regs[] =
=3D {<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access=
_vm_reg, NULL, c13_CID },<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* CNTP_TVAL */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op1( 0), CRn(14), CRm( 2), Op2( 0), access_cntp=
_tval },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* CNTP_CTL */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op1( 0), CRn(14), CRm( 2), Op2( 1), access_cntp=
_ctl },<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* PMEVCNTRn */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0PMU_PMEVCNTR(0),<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0PMU_PMEVCNTR(1),<br>
&gt; @@ -1618,6 +1623,7 @@ static const struct sys_reg_desc cp15_64_regs[] =
=3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0{ Op1( 0), CRn( 0), CRm( 9), Op2( 0), access=
_pmu_evcntr },<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0{ Op1( 0), CRn( 0), CRm(12), Op2( 0), access=
_gic_sgi },<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access=
_vm_reg, NULL, c2_TTBR1 },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op1( 2), CRn( 0), CRm(14), Op2( 0), access_cntp=
_cval },<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt;=C2=A0 /* Target specific emulation tables */<br>
&gt;<br>
<br>
</div></div>Seems OK to me. Can you please update the corresponding 32bit c=
ode while<br>
you&#39;re at it?<br></blockquote><div>I&#39;m working on it, I&#39;ll send=
 soon the arm 32bit version, once tested.<br><br></div><div>Jeremy<br></div=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex">
<br>
Thanks,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 M.<br>
<span class=3D"m_5950063223294626919m_6811923720026052507m_-474420181179651=
1766HOEnZb"><font color=3D"#888888">--<br>
Jazz is not dead. It just smells funny...<br>
</font></span></blockquote></div><br></div></div></div>

--94eb2c1924f474fbd70564b3fa72--

--===============1469012785053975140==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1469012785053975140==--
