Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EE0C2D0EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 14:06:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5B4321D6C
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 14:06:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Mk+e5b1C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5B4321D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0634B239;
	Fri, 17 Apr 2020 10:06:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id acnxaGP+U7SH; Fri, 17 Apr 2020 10:06:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7422B4B1FE;
	Fri, 17 Apr 2020 10:06:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31F364B210
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 10:06:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L7I4mZ2fZO29 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 10:06:10 -0400 (EDT)
Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com
 [209.85.208.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 158F24B1C8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 10:06:10 -0400 (EDT)
Received: by mail-lj1-f193.google.com with SMTP id u6so2158866ljl.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 07:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=I9uLzJPTF0ffHjzjV87lWX+LLwM8O+HEh/Ba0jUxYi0=;
 b=Mk+e5b1CBfx90ZGp4SbkvIRvJh+qMwfIN/5T3gv9tO+pfa7SgEyC5PtjpgQP/J01Os
 E2rlRpvaGtU+bjKMWNlp080n8ZMPCx/A0hgbb+rauP/Hb4yfOaxdzqilvQ8cUsoDZY5j
 5RdKYbf1vdXfs2ZwDiTh+fr1aP1ivbT+SquK8pd5JabhuMPOmVDAOftikqOQehwCLdl1
 rnH8NPqR6hi5J93yTeg3Dvz5FJJYlQ9wwwsFL/j6TySgDIPRPtpeSdpbuAUlLpN+lm/M
 fNLvPZHC2ljT6AP+DEanzpoZ0AjRIxuWo8bbmTZaGZ5bxEPNcX6vSIxhjloBI0RjDMDb
 N9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=I9uLzJPTF0ffHjzjV87lWX+LLwM8O+HEh/Ba0jUxYi0=;
 b=j+pSp8mbYYlPt6CiTBitWOUX5q6DBcndSUXO8696oZgFdliyTzgU1sHve8iJRiMw8p
 sCywDvPbBih6OaSo8Y1GBR4+hwWJXH4eDRib2iSJx9fCVkTdZw8wmAEtO/zvpAOUDuY1
 va0+ZOlx9E5N11jCW4Sd9K31TWIgubbH0Ks1LGOcUL9/sov+pzbt8kq0kfuGrDordSTc
 MRwshQKtCWtYsJAxDS1n3usGgfH/l0REzAIVIcktJhU1em25/aaEB3dVCUX8y8LgaWF/
 cUDue1ki9zOAxaMh5jWMAoNdT6zWbKMuHsbhOwX2tZZzL6IDkbI8iBsXSJTGWpMgCRc4
 Nx9Q==
X-Gm-Message-State: AGi0PuZ7HxXxI4Nnr0azI92Fo6pQnYE3IUSdB2YUG6LhGlBZK9ymWflc
 myvKHPqaqTjxDnCeSPHeIpJCYW6FiTbVpF4ffwBLGQ==
X-Google-Smtp-Source: APiQypJDJG2PHeeJkI5L5Usa75rksXmmjSctRrf4wTzPjzskMGcBK6Da0SoAoaWvC2FLyaKAoP/9n/MKi8hs9ZmlJAE=
X-Received: by 2002:a2e:89cf:: with SMTP id c15mr2209617ljk.284.1587132368453; 
 Fri, 17 Apr 2020 07:06:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200417135801.82871-1-tabba@google.com>
 <20200417135801.82871-2-tabba@google.com>
 <20200417140314.GA53632@C02TD0UTHF1T.local>
In-Reply-To: <20200417140314.GA53632@C02TD0UTHF1T.local>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 17 Apr 2020 15:05:32 +0100
Message-ID: <CA+EHjTwsnDR7cp-uM6RWk2QscqAoDe0m=xrgnFuo-W2d-Or57Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
To: Mark Rutland <mark.rutland@arm.com>
Cc: catalin.marinas@arm.com, Marc Zyngier <maz@kernel.org>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============4632396640710697047=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4632396640710697047==
Content-Type: multipart/alternative; boundary="00000000000009019c05a37d0d0a"

--00000000000009019c05a37d0d0a
Content-Type: text/plain; charset="UTF-8"

Thanks Mark.  I'll will fix this and send out a v3.

Cheers,
/fuad

On Fri, Apr 17, 2020 at 3:03 PM Mark Rutland <mark.rutland@arm.com> wrote:

> Hi Fuad,
>
> On Fri, Apr 17, 2020 at 02:57:58PM +0100, Fuad Tabba wrote:
> > From: Will Deacon <will@kernel.org>
> >
> > CONFIG_KVM_ARM_HOST is just a proxy for CONFIG_KVM, so remove it in
> favour
> > of the latter.
> >
> > Signed-off-by: Will Deacon <will@kernel.org>
>
> As a general thing, when sending patches written by others, you must
> append your own S-o-B to the chain. Please see:
>
>
> https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin
>
> That pplies to patches 1-3 in this series.
>
> Thanks,
> Mark.
>
> > ---
> >  arch/arm64/kernel/asm-offsets.c |  2 +-
> >  arch/arm64/kernel/smp.c         |  2 +-
> >  arch/arm64/kvm/Kconfig          |  6 ----
> >  arch/arm64/kvm/Makefile         | 54 ++++++++++++++++-----------------
> >  arch/arm64/kvm/hyp/Makefile     | 22 +++++++-------
> >  5 files changed, 40 insertions(+), 46 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/asm-offsets.c
> b/arch/arm64/kernel/asm-offsets.c
> > index 9981a0a5a87f..a27e0cd731e9 100644
> > --- a/arch/arm64/kernel/asm-offsets.c
> > +++ b/arch/arm64/kernel/asm-offsets.c
> > @@ -96,7 +96,7 @@ int main(void)
> >    DEFINE(CPU_BOOT_PTRAUTH_KEY,       offsetof(struct secondary_data,
> ptrauth_key));
> >  #endif
> >    BLANK();
> > -#ifdef CONFIG_KVM_ARM_HOST
> > +#ifdef CONFIG_KVM
> >    DEFINE(VCPU_CONTEXT,               offsetof(struct kvm_vcpu,
> arch.ctxt));
> >    DEFINE(VCPU_FAULT_DISR,    offsetof(struct kvm_vcpu,
> arch.fault.disr_el1));
> >    DEFINE(VCPU_WORKAROUND_FLAGS,      offsetof(struct kvm_vcpu,
> arch.workaround_flags));
> > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > index 061f60fe452f..0a3045d9f33f 100644
> > --- a/arch/arm64/kernel/smp.c
> > +++ b/arch/arm64/kernel/smp.c
> > @@ -430,7 +430,7 @@ static void __init hyp_mode_check(void)
> >                          "CPU: CPUs started in inconsistent modes");
> >       else
> >               pr_info("CPU: All CPU(s) started at EL1\n");
> > -     if (IS_ENABLED(CONFIG_KVM_ARM_HOST))
> > +     if (IS_ENABLED(CONFIG_KVM))
> >               kvm_compute_layout();
> >  }
> >
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 449386d76441..ce724e526689 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -28,7 +28,6 @@ config KVM
> >       select HAVE_KVM_CPU_RELAX_INTERCEPT
> >       select HAVE_KVM_ARCH_TLB_FLUSH_ALL
> >       select KVM_MMIO
> > -     select KVM_ARM_HOST
> >       select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >       select SRCU
> >       select KVM_VFIO
> > @@ -50,11 +49,6 @@ config KVM
> >
> >         If unsure, say N.
> >
> > -config KVM_ARM_HOST
> > -     bool
> > -     ---help---
> > -       Provides host support for ARM processors.
> > -
> >  config KVM_ARM_PMU
> >       bool
> >       ---help---
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index 7a3768538343..a5334b91729a 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -7,33 +7,33 @@ ccflags-y += -I $(srctree)/$(src)
> >
> >  KVM=../../../virt/kvm
> >
> > -obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += hyp/
> > +obj-$(CONFIG_KVM) += kvm.o
> > +obj-$(CONFIG_KVM) += hyp/
> >
> > -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/eventfd.o $(KVM)/vfio.o
> $(KVM)/irqchip.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += arm.o mmu.o mmio.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += psci.o perf.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += hypercalls.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += pvtime.o
> > +kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
> > +kvm-$(CONFIG_KVM) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
> > +kvm-$(CONFIG_KVM) += arm.o mmu.o mmio.o
> > +kvm-$(CONFIG_KVM) += psci.o perf.o
> > +kvm-$(CONFIG_KVM) += hypercalls.o
> > +kvm-$(CONFIG_KVM) += pvtime.o
> >
> > -kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o
> sys_regs_generic_v8.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o pmu.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += aarch32.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += arch_timer.o
> > -kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
> > +kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
> > +kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
> > +kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o
> sys_regs_generic_v8.o
> > +kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
> > +kvm-$(CONFIG_KVM) += aarch32.o
> > +kvm-$(CONFIG_KVM) += arch_timer.o
> > +kvm-$(CONFIG_KVM)  += pmu-emul.o
> >
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-init.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-irqfd.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v2.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v3.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v4.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio-v2.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio-v3.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-kvm-device.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-its.o
> > -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-debug.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-init.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-irqfd.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-v2.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-v3.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-v4.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-mmio.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v2.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v3.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-kvm-device.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-its.o
> > +kvm-$(CONFIG_KVM) += vgic/vgic-debug.o
> > diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> > index dc18274a6826..8229e47ba870 100644
> > --- a/arch/arm64/kvm/hyp/Makefile
> > +++ b/arch/arm64/kvm/hyp/Makefile
> > @@ -6,17 +6,17 @@
> >  ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
> >               $(DISABLE_STACKLEAK_PLUGIN)
> >
> > -obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += aarch32.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-cpuif-proxy.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += entry.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += switch.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
> > -obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
> > +obj-$(CONFIG_KVM) += vgic-v3-sr.o
> > +obj-$(CONFIG_KVM) += timer-sr.o
> > +obj-$(CONFIG_KVM) += aarch32.o
> > +obj-$(CONFIG_KVM) += vgic-v2-cpuif-proxy.o
> > +obj-$(CONFIG_KVM) += sysreg-sr.o
> > +obj-$(CONFIG_KVM) += debug-sr.o
> > +obj-$(CONFIG_KVM) += entry.o
> > +obj-$(CONFIG_KVM) += switch.o
> > +obj-$(CONFIG_KVM) += fpsimd.o
> > +obj-$(CONFIG_KVM) += tlb.o
> > +obj-$(CONFIG_KVM) += hyp-entry.o
> >
> >  # KVM code is run at a different exception code with a different map, so
> >  # compiler instrumentation that inserts callbacks or checks into the
> code may
> > --
> > 2.26.1.301.g55bc3eb7cb9-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

--00000000000009019c05a37d0d0a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Mark.=C2=A0 I&#39;ll will fix this and send out a v=
3.<div><br></div><div>Cheers,</div><div>/fuad</div></div><br><div class=3D"=
gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Apr 17, 2020 at =
3:03 PM Mark Rutland &lt;<a href=3D"mailto:mark.rutland@arm.com">mark.rutla=
nd@arm.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">Hi Fuad,<br>
<br>
On Fri, Apr 17, 2020 at 02:57:58PM +0100, Fuad Tabba wrote:<br>
&gt; From: Will Deacon &lt;<a href=3D"mailto:will@kernel.org" target=3D"_bl=
ank">will@kernel.org</a>&gt;<br>
&gt; <br>
&gt; CONFIG_KVM_ARM_HOST is just a proxy for CONFIG_KVM, so remove it in fa=
vour<br>
&gt; of the latter.<br>
&gt; <br>
&gt; Signed-off-by: Will Deacon &lt;<a href=3D"mailto:will@kernel.org" targ=
et=3D"_blank">will@kernel.org</a>&gt;<br>
<br>
As a general thing, when sending patches written by others, you must<br>
append your own S-o-B to the chain. Please see:<br>
<br>
<a href=3D"https://www.kernel.org/doc/html/v4.17/process/submitting-patches=
.html#sign-your-work-the-developer-s-certificate-of-origin" rel=3D"noreferr=
er" target=3D"_blank">https://www.kernel.org/doc/html/v4.17/process/submitt=
ing-patches.html#sign-your-work-the-developer-s-certificate-of-origin</a><b=
r>
<br>
That pplies to patches 1-3 in this series.<br>
<br>
Thanks,<br>
Mark.<br>
<br>
&gt; ---<br>
&gt;=C2=A0 arch/arm64/kernel/asm-offsets.c |=C2=A0 2 +-<br>
&gt;=C2=A0 arch/arm64/kernel/smp.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0=
 2 +-<br>
&gt;=C2=A0 arch/arm64/kvm/Kconfig=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0=
 6 ----<br>
&gt;=C2=A0 arch/arm64/kvm/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 54 ++=
++++++++++++++-----------------<br>
&gt;=C2=A0 arch/arm64/kvm/hyp/Makefile=C2=A0 =C2=A0 =C2=A0| 22 +++++++-----=
--<br>
&gt;=C2=A0 5 files changed, 40 insertions(+), 46 deletions(-)<br>
&gt; <br>
&gt; diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-o=
ffsets.c<br>
&gt; index 9981a0a5a87f..a27e0cd731e9 100644<br>
&gt; --- a/arch/arm64/kernel/asm-offsets.c<br>
&gt; +++ b/arch/arm64/kernel/asm-offsets.c<br>
&gt; @@ -96,7 +96,7 @@ int main(void)<br>
&gt;=C2=A0 =C2=A0 DEFINE(CPU_BOOT_PTRAUTH_KEY,=C2=A0 =C2=A0 =C2=A0 =C2=A0of=
fsetof(struct secondary_data, ptrauth_key));<br>
&gt;=C2=A0 #endif<br>
&gt;=C2=A0 =C2=A0 BLANK();<br>
&gt; -#ifdef CONFIG_KVM_ARM_HOST<br>
&gt; +#ifdef CONFIG_KVM<br>
&gt;=C2=A0 =C2=A0 DEFINE(VCPU_CONTEXT,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0offsetof(struct kvm_vcpu, arch.ctxt));<br>
&gt;=C2=A0 =C2=A0 DEFINE(VCPU_FAULT_DISR,=C2=A0 =C2=A0 offsetof(struct kvm_=
vcpu, arch.fault.disr_el1));<br>
&gt;=C2=A0 =C2=A0 DEFINE(VCPU_WORKAROUND_FLAGS,=C2=A0 =C2=A0 =C2=A0 offseto=
f(struct kvm_vcpu, arch.workaround_flags));<br>
&gt; diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c<br>
&gt; index 061f60fe452f..0a3045d9f33f 100644<br>
&gt; --- a/arch/arm64/kernel/smp.c<br>
&gt; +++ b/arch/arm64/kernel/smp.c<br>
&gt; @@ -430,7 +430,7 @@ static void __init hyp_mode_check(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 &quot;CPU: CPUs started in inconsistent modes&quot;);<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_info(&quot;CP=
U: All CPU(s) started at EL1\n&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (IS_ENABLED(CONFIG_KVM_ARM_HOST))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (IS_ENABLED(CONFIG_KVM))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kvm_compute_layo=
ut();<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig<br>
&gt; index 449386d76441..ce724e526689 100644<br>
&gt; --- a/arch/arm64/kvm/Kconfig<br>
&gt; +++ b/arch/arm64/kvm/Kconfig<br>
&gt; @@ -28,7 +28,6 @@ config KVM<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0select HAVE_KVM_CPU_RELAX_INTERCEPT<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0select HAVE_KVM_ARCH_TLB_FLUSH_ALL<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0select KVM_MMIO<br>
&gt; -=C2=A0 =C2=A0 =C2=A0select KVM_ARM_HOST<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0select KVM_GENERIC_DIRTYLOG_READ_PROTECT<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0select SRCU<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0select KVM_VFIO<br>
&gt; @@ -50,11 +49,6 @@ config KVM<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If unsure, say N.<br>
&gt;=C2=A0 <br>
&gt; -config KVM_ARM_HOST<br>
&gt; -=C2=A0 =C2=A0 =C2=A0bool<br>
&gt; -=C2=A0 =C2=A0 =C2=A0---help---<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0Provides host support for ARM processors.<=
br>
&gt; -<br>
&gt;=C2=A0 config KVM_ARM_PMU<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0bool<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0---help---<br>
&gt; diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile<br>
&gt; index 7a3768538343..a5334b91729a 100644<br>
&gt; --- a/arch/arm64/kvm/Makefile<br>
&gt; +++ b/arch/arm64/kvm/Makefile<br>
&gt; @@ -7,33 +7,33 @@ ccflags-y +=3D -I $(srctree)/$(src)<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 KVM=3D../../../virt/kvm<br>
&gt;=C2=A0 <br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D kvm.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D hyp/<br>
&gt; +obj-$(CONFIG_KVM) +=3D kvm.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D hyp/<br>
&gt;=C2=A0 <br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D $(KVM)/kvm_main.o $(KVM)/coalesced_mm=
io.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)=
/irqchip.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D arm.o mmu.o mmio.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D psci.o perf.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D hypercalls.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D pvtime.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.=
o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D arm.o mmu.o mmio.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D psci.o perf.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D hypercalls.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D pvtime.o<br>
&gt;=C2=A0 <br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D inject_fault.o regmap.o va_layout.o<b=
r>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D hyp.o hyp-init.o handle_exit.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D guest.o debug.o reset.o sys_regs.o sy=
s_regs_generic_v8.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic-sys-reg-v3.o fpsimd.o pmu.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D aarch32.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D arch_timer.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_PMU)=C2=A0 +=3D pmu-emul.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D inject_fault.o regmap.o va_layout.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D hyp.o hyp-init.o handle_exit.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D guest.o debug.o reset.o sys_regs.o sys_regs_ge=
neric_v8.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic-sys-reg-v3.o fpsimd.o pmu.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D aarch32.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D arch_timer.o<br>
&gt; +kvm-$(CONFIG_KVM)=C2=A0 +=3D pmu-emul.o<br>
&gt;=C2=A0 <br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-init.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-irqfd.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-v2.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-v3.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-v4.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-mmio.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-mmio-v2.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-mmio-v3.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-kvm-device.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-its.o<br>
&gt; -kvm-$(CONFIG_KVM_ARM_HOST) +=3D vgic/vgic-debug.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-init.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-irqfd.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-v2.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-v3.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-v4.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-mmio.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-mmio-v2.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-mmio-v3.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-kvm-device.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-its.o<br>
&gt; +kvm-$(CONFIG_KVM) +=3D vgic/vgic-debug.o<br>
&gt; diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile=
<br>
&gt; index dc18274a6826..8229e47ba870 100644<br>
&gt; --- a/arch/arm64/kvm/hyp/Makefile<br>
&gt; +++ b/arch/arm64/kvm/hyp/Makefile<br>
&gt; @@ -6,17 +6,17 @@<br>
&gt;=C2=A0 ccflags-y +=3D -fno-stack-protector -DDISABLE_BRANCH_PROFILING \=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$(DISABLE_STACKL=
EAK_PLUGIN)<br>
&gt;=C2=A0 <br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D vgic-v3-sr.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D timer-sr.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D aarch32.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D vgic-v2-cpuif-proxy.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D sysreg-sr.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D debug-sr.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D entry.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D switch.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D fpsimd.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D tlb.o<br>
&gt; -obj-$(CONFIG_KVM_ARM_HOST) +=3D hyp-entry.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D vgic-v3-sr.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D timer-sr.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D aarch32.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D vgic-v2-cpuif-proxy.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D sysreg-sr.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D debug-sr.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D entry.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D switch.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D fpsimd.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D tlb.o<br>
&gt; +obj-$(CONFIG_KVM) +=3D hyp-entry.o<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 # KVM code is run at a different exception code with a different=
 map, so<br>
&gt;=C2=A0 # compiler instrumentation that inserts callbacks or checks into=
 the code may<br>
&gt; -- <br>
&gt; 2.26.1.301.g55bc3eb7cb9-goog<br>
&gt; <br>
&gt; _______________________________________________<br>
&gt; kvmarm mailing list<br>
&gt; <a href=3D"mailto:kvmarm@lists.cs.columbia.edu" target=3D"_blank">kvma=
rm@lists.cs.columbia.edu</a><br>
&gt; <a href=3D"https://lists.cs.columbia.edu/mailman/listinfo/kvmarm" rel=
=3D"noreferrer" target=3D"_blank">https://lists.cs.columbia.edu/mailman/lis=
tinfo/kvmarm</a><br>
</blockquote></div>

--00000000000009019c05a37d0d0a--

--===============4632396640710697047==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4632396640710697047==--
