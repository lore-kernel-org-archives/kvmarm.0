Return-Path: <SRS0=VMV7=EY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 512CFC5519F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 17:02:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5B3424883
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 17:02:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5B3424883
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 016004BA19;
	Wed, 18 Nov 2020 12:02:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xBXQP3q+ED7b; Wed, 18 Nov 2020 12:02:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4FE74BA1D;
	Wed, 18 Nov 2020 12:02:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7432F4BA19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 12:02:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KtgjHbTt+Kmc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2020 12:02:49 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E25A4BA0A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 12:02:49 -0500 (EST)
Received: from trantor (unknown [2.26.170.190])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 846B42487D;
 Wed, 18 Nov 2020 17:02:44 +0000 (UTC)
Date: Wed, 18 Nov 2020 17:02:41 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v4 1/2] arm64: kvm: Save/restore MTE registers
Message-ID: <X7VTsaO/7+Izqm8/@trantor>
References: <20201026155727.36685-1-steven.price@arm.com>
 <20201026155727.36685-2-steven.price@arm.com>
 <b8f2fe15e0cab5c24094915b8c000930@kernel.org>
 <98eaa539-0ae8-ce4c-8886-3040542ede80@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <98eaa539-0ae8-ce4c-8886-3040542ede80@arm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Nov 18, 2020 at 04:01:18PM +0000, Steven Price wrote:
> On 17/11/2020 19:20, Marc Zyngier wrote:
> > On 2020-10-26 15:57, Steven Price wrote:
> > > diff --git a/arch/arm64/include/asm/sysreg.h
> > > b/arch/arm64/include/asm/sysreg.h
> > > index d52c1b3ce589..7727df0bc09d 100644
> > > --- a/arch/arm64/include/asm/sysreg.h
> > > +++ b/arch/arm64/include/asm/sysreg.h
> > > @@ -565,7 +565,8 @@
> > > =A0#define SCTLR_ELx_M=A0=A0=A0 (BIT(0))
> > > =

> > > =A0#define SCTLR_ELx_FLAGS=A0=A0=A0 (SCTLR_ELx_M=A0 | SCTLR_ELx_A | S=
CTLR_ELx_C | \
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 SCTLR_ELx_SA | SCTLR_ELx_I | SC=
TLR_ELx_IESB)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 SCTLR_ELx_SA | SCTLR_ELx_I | SC=
TLR_ELx_IESB | \
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 SCTLR_ELx_ITFSB)
> > > =

> > > =A0/* SCTLR_EL2 specific flags. */
> > > =A0#define SCTLR_EL2_RES1=A0=A0=A0 ((BIT(4))=A0 | (BIT(5))=A0 | (BIT(=
11)) |
> > > (BIT(16)) | \
> > > diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> > > b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> > > index 7a986030145f..a124ffa49ba3 100644
> > > --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> > > +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> > > @@ -18,6 +18,11 @@
> > > =A0static inline void __sysreg_save_common_state(struct
> > > kvm_cpu_context *ctxt)
> > > =A0{
> > > =A0=A0=A0=A0 ctxt_sys_reg(ctxt, MDSCR_EL1)=A0=A0=A0 =3D read_sysreg(m=
dscr_el1);
> > > +=A0=A0=A0 if (system_supports_mte()) {
> > > +=A0=A0=A0=A0=A0=A0=A0 ctxt_sys_reg(ctxt, RGSR_EL1)=A0=A0=A0 =3D read=
_sysreg_s(SYS_RGSR_EL1);
> > > +=A0=A0=A0=A0=A0=A0=A0 ctxt_sys_reg(ctxt, GCR_EL1)=A0=A0=A0 =3D read_=
sysreg_s(SYS_GCR_EL1);
> > > +=A0=A0=A0=A0=A0=A0=A0 ctxt_sys_reg(ctxt, TFSRE0_EL1)=A0=A0=A0 =3D
> > > read_sysreg_s(SYS_TFSRE0_EL1);
> > =

> > As far as I can tell, HCR_EL2.ATA is still clear when running a guest.
> > So why, do we save/restore this state yet?
> > =

> > Also, I wonder whether we should keep these in the C code. If one day
> > we enable MTE in the kernel, we will have to move them to the assembly
> > part, much like we do for PAuth. And I fear that "one day" is pretty
> > soon:
> > =

> > https://lore.kernel.org/linux-arm-kernel/cover.1605046192.git.andreyknv=
l@google.com/
> =

> Good point. Although for MTE we do have the option of setting TCO in PSTA=
TE
> so this could remain in C if we're not bothered about the 'gap' in KASAN
> coverage. I haven't yet got my head around how (or indeed if) that series
> handles guests.

I think we should be fine with the currently proposed in-kernel MTE
support. However, setting GCR_EL1 can get in the way if stack tagging is
ever enabled (it breaks single image). The compiler uses GCR_EL1 to
generate different colours for variables on the stack and changing it in
the middle of a function may cause confusion. You'd have to set
PSTATE.TCO for the whole function, either from the caller or, if the
compiler gets smarter, some function attribute.

-- =

Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
