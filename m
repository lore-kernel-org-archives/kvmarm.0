Return-Path: <SRS0=pAxc=S3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432EEC43218
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:29:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A4D70214AE
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4D70214AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44EDF4A445;
	Thu, 25 Apr 2019 09:28:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RHHzXHnh28bh; Thu, 25 Apr 2019 09:28:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1A714A47D;
	Thu, 25 Apr 2019 09:28:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D01F24A445
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:28:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o6HIwlQJ2vVS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 09:28:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 594C84A36C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:28:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE675A78;
 Thu, 25 Apr 2019 06:28:10 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA0A13F5C1;
 Thu, 25 Apr 2019 06:28:08 -0700 (PDT)
Date: Thu, 25 Apr 2019 14:28:06 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v7 12/27] KVM: arm64/sve: System register context switch
 and access support
Message-ID: <20190425132805.GC3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-13-git-send-email-Dave.Martin@arm.com>
 <87bm0vwhsd.fsf@zen.linaroharston>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87bm0vwhsd.fsf@zen.linaroharston>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190425132806.5wDPDt4BD6Ca2f55EPp6m0St1-0yslqODWfvIyyvSDA@z>

On Wed, Apr 24, 2019 at 04:21:22PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > This patch adds the necessary support for context switching ZCR_EL1
> > for each vcpu.
> >
> > ZCR_EL1 is trapped alongside the FPSIMD/SVE registers, so it makes
> > sense for it to be handled as part of the guest FPSIMD/SVE context
> > for context switch purposes instead of handling it as a general
> > system register.  This means that it can be switched in lazily at
> > the appropriate time.  No effort is made to track host context for
> > this register, since SVE requires VHE: thus the hosts's value for
> > this register lives permanently in ZCR_EL2 and does not alias the
> > guest's value at any time.
> >
> > The Hyp switch and fpsimd context handling code is extended
> > appropriately.
> >
> > Accessors are added in sys_regs.c to expose the SVE system
> > registers and ID register fields.  Because these need to be
> > conditionally visible based on the guest configuration, they are
> > implemented separately for now rather than by use of the generic
> > system register helpers.  This may be abstracted better later on
> > when/if there are more features requiring this model.
> >
> > ID_AA64ZFR0_EL1 is RO-RAZ for MRS/MSR when SVE is disabled for the
> > guest, but for compatibility with non-SVE aware KVM implementations
> > the register should not be enumerated at all for KVM_GET_REG_LIST
> > in this case.  For consistency we also reject ioctl access to the
> > register.  This ensures that a non-SVE-enabled guest looks the same
> > to userspace, irrespective of whether the kernel KVM implementation
> > supports SVE.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> >
> > ---
> >

[...]

> > diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> > index 1cf4f02..7053bf4 100644
> > --- a/arch/arm64/kvm/fpsimd.c
> > +++ b/arch/arm64/kvm/fpsimd.c
> > @@ -103,14 +103,21 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vc=
pu)
> >  void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
> >  {
> >  	unsigned long flags;
> > +	bool host_has_sve =3D system_supports_sve();
> > +	bool guest_has_sve =3D vcpu_has_sve(vcpu);
> >
> >  	local_irq_save(flags);
> >
> >  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> > +		u64 *guest_zcr =3D &vcpu->arch.ctxt.sys_regs[ZCR_EL1];
> > +
> =

> Is this just to avoid:
> =

>    vcpu->arch.ctxt.sys_regs[ZCR_EL1] =3D read_sysreg_s(SYS_ZCR_EL12);

No, it's just done to shorten the line.  Otherwise a trailing =3D is hard
to avoid (which Marc didn't like) or the line has to be over 80 chars
(which I didn't like).

> in fact wouldn't:
> =

>    __vcpu_sys_reg(vcpu,ZCR_EL1) =3D read_sysreg_s(SYS_ZCR_EL12);

We could use __vcpu_sys_reg() yes, I missed that.

I could spin a patch for this, but it doesn't feel like a high priority
at this stage.

[...]

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Thanks
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
