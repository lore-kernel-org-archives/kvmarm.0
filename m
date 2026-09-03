Received: from mta1.migadu.com (out-163.mta1.migadu.com [95.215.58.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD2437A848
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452733; cv=none; b=HjatwRMV5BJzS1jzbJujhPnTnaNwSGKl8E3y84iUZQm/n99H4sYtIr0eKHiKHn8HGsdQSY5w/cBTEHnZpnsuLdMLTl95COS7a4n3SE6LLQlMByKgROyjLLdvcSwG6zruLuyUezgh73bM4alPYbvqVHx6NT9yPAaejiN7v6Bjlxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452733; c=relaxed/simple;
	bh=K2XhZRaEcnv7ObK0vhzgK3Ez5fck2OLgKTd878PvPlw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SJiAz5rEJ5mM4tV/rjVOD1zPh+BNhQffBADvjzOgTuZyXaO7/BZVhLKFkrlEWRpWOSVDqGK3gYiO7PnWkVFtFEKK2fX9XBp5OriCrus2W5BNkdZx31xWoBIEd55gboqh3sM4MYmtNm3do0/T2rYQJDEQruZTx/2ZAjruqg7oRHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Il8qmLKR; arc=none smtp.client-ip=95.215.58.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Il8qmLKR"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=K2XhZRaEcnv7ObK0vhzgK3Ez5fck2OLgKTd878PvPlw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788452728; v=1; x=1789057528;
 b=Il8qmLKRHkhABw1pUOUZOGdRDa1xW6wAMUKi9kZT3dJD44aqm/rxzO2PeXTF7HXxQcGWSDN0
 0yxopwRXYGhBPCBLUwv4vTufQjgzkrkhUUy4GGTk4bD4oP8iXSDaQwXF97ERWZZ+HRWP+pdz7mH
 K8Wqdgjex7SDwkaHlBzwOIgo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3724e39a28223af8;
	Thu, 03 Sep 2026 16:25:28 +0000
X-Mizu-Trace-ID: 3724e39a28223af8
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17358so6594e87.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 09:25:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxCn5mfUY/rqJRbz5BARaWh6a/zXhweEgumdp9laKdRjPGswggWe40a6YgJC0tmgK9YXuDfgPA=@lists.linux.dev
X-Gm-Message-State: AFuF++lHs+DG74+rroxLJeGgo/lOCsupvkOOw2rhxvRt08FKKCyPZAb1
	NMaRtZbS0nAuLmlwN8Kaq6FAtX1SIL6NJbJQG21jyPMgR95d9+8uqxP6Emby1t+uQKD0RE6qJFO
	3WtZ5dwzXCkualSG6jqFK+brjDcCbo+g1hVsIToKB
X-Received: by 2002:a05:6512:230e:b0:5b6:bea:f091 with SMTP id
 2adb3069b0e04-5b60ecb9c0emr180091e87.10.1788452723672; Thu, 03 Sep 2026
 09:25:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-8-fuad.tabba@linux.dev>
 <apg9R_QsE1cckIgJ@e143914.arm.com>
In-Reply-To: <apg9R_QsE1cckIgJ@e143914.arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 3 Sep 2026 17:24:47 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz4dpJnWDco+1K4YwJs1D3=n4HqKti2zBNsxDUj7L9U7Q@mail.gmail.com>
X-Gm-Features: AcwNN1XaENgw11noY_HItOusfbxfw1uGRSOhZB7GEJ_PRsZTm3y4puO8FZvoGt4
Message-ID: <CA+EHjTz4dpJnWDco+1K4YwJs1D3=n4HqKti2zBNsxDUj7L9U7Q@mail.gmail.com>
Subject: Re: [PATCH 07/17] KVM: arm64: Add system register reset framework for
 protected VMs
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Sept 2026 at 16:14, Joey Gouly <joey.gouly@arm.com> wrote:
>
> On Mon, Aug 31, 2026 at 05:34:11PM +0100, Fuad Tabba wrote:
> > Reset a protected VM's system registers at EL2 rather than taking the
> > host's values: add kvm_reset_pvm_sys_regs() and the
> > pvm_sys_reg_reset_vals[] table that drives it, and call it from
> > init_pkvm_hyp_vcpu() for protected vCPUs. The values follow the
> > host-side reset in sys_regs.c, with a poison value where it resets to
> > UNKNOWN, and for VBAR_EL1 and CONTEXTIDR_EL1 in place of the 0 it
> > resets them to. MPIDR_EL1 is derived from vcpu_id, as for any KVM
> > guest.
> >
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
>
> The commit message says "rather than taking the host's values", but if I
> understand correctly, at this point in the series, they still take the
> hosts values because this is still present:
>
>         hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
>
> Not necessarily saying anything needs to change, just to write down what
> I noticed while reviewing / reading this code!

Actually, you're right. This should change. That copy runs on every
entry and is removed only in patch 13, so until then the reset values
are overwritten and this patch has no observable effect for a
protected VM. The message will say so for v2. Patch 6 hits the same
copy and works around it, preserving the timer registers across it.

>
> The only other thing I was a bit unsure of was the actual list of
> registers pvm_sys_reg_reset_vals. It's the EL1 registers, minus
> unsupported FEATs (MTE, debug(?), GCS, etc)

Not quite: some EL0 registers are in it, and debug isn't excluded.
I'll state the rule in the commit message. And there's the Sashiko fix
too.

Thanks!
/fuad

>
> Otherwise:
> Acked-by: Joey Gouly <joey.gouly@arm.com>
>
> Thanks,
> Joey
>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c         |  5 ++
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c     | 91 ++++++++++++++++++++++++--
> >  3 files changed, 93 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > index 49a0a992047ba..a04b7c04d5135 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > @@ -95,6 +95,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
> >  bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
> >  bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
> >  void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
> > +void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
> >  int kvm_check_pvm_sysreg_table(void);
> >
> >  #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index e85f13233da08..af334318d0a03 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -551,6 +551,11 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
> >               goto done;
> >
> >       ret = pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
> > +     if (ret)
> > +             goto done;
> > +
> > +     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > +             kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
> >  done:
> >       if (ret)
> >               unpin_host_vcpu(host_vcpu);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > index 8758c68017765..ebfd48aa15b56 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -525,6 +525,84 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
> >       /* Performance Monitoring Registers are restricted. */
> >  };
> >
> > +struct sys_reg_desc_reset {
> > +     int reg;
> > +     void (*reset)(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *rd);
> > +     u64 value;
> > +};
> > +
> > +/* Hardware value, as sys_regs.c's reset_actlr()/reset_amair_el1(). */
> > +static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
> > +{
> > +     __vcpu_assign_sys_reg(vcpu, r->reg, read_sysreg(actlr_el1));
> > +}
> > +
> > +static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
> > +{
> > +     __vcpu_assign_sys_reg(vcpu, r->reg, read_sysreg(amair_el1));
> > +}
> > +
> > +static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
> > +{
> > +     __vcpu_assign_sys_reg(vcpu, r->reg, kvm_calculate_mpidr(vcpu));
> > +}
> > +
> > +static void reset_value(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
> > +{
> > +     __vcpu_assign_sys_reg(vcpu, r->reg, r->value);
> > +}
> > +
> > +#define RESET_VAL(REG, RESET_VAL) {  REG, reset_value, RESET_VAL }
> > +
> > +#define RESET_ZERO(REG) RESET_VAL(REG, 0)
> > +
> > +#define RESET_UNKNOWN(REG) RESET_VAL(REG, 0x1de7ec7edbadc0deULL)
> > +
> > +#define RESET_FUNC(REG, RESET_FUNC) {  REG, RESET_FUNC, 0 }
> > +
> > +/* Sorted ascending by reg; kvm_check_pvm_sysreg_table() enforces it. */
> > +static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
> > +     RESET_FUNC(MPIDR_EL1, reset_mpidr),
> > +     RESET_UNKNOWN(TPIDR_EL0),
> > +     RESET_UNKNOWN(TPIDRRO_EL0),
> > +     RESET_UNKNOWN(TPIDR_EL1),
> > +     RESET_ZERO(CNTKCTL_EL1),
> > +     RESET_UNKNOWN(PAR_EL1),
> > +     RESET_ZERO(MDCCINT_EL1),
> > +     RESET_ZERO(DISR_EL1),
> > +     RESET_ZERO(PMCCFILTR_EL0),
> > +     RESET_ZERO(PMUSERENR_EL0),
> > +     RESET_ZERO(CPACR_EL1),
> > +     RESET_VAL(CONTEXTIDR_EL1, 0x00000000dbadc0deULL),
> > +     RESET_VAL(SCTLR_EL1, 0x00C50078ULL),
> > +     RESET_FUNC(ACTLR_EL1, reset_actlr),
> > +     RESET_ZERO(TCR_EL1),
> > +     RESET_UNKNOWN(AFSR0_EL1),
> > +     RESET_UNKNOWN(AFSR1_EL1),
> > +     RESET_UNKNOWN(ESR_EL1),
> > +     RESET_UNKNOWN(MAIR_EL1),
> > +     RESET_FUNC(AMAIR_EL1, reset_amair_el1),
> > +     RESET_ZERO(MDSCR_EL1),
> > +     RESET_ZERO(ZCR_EL1),
> > +     RESET_UNKNOWN(TTBR0_EL1),
> > +     RESET_UNKNOWN(TTBR1_EL1),
> > +     RESET_UNKNOWN(FAR_EL1),
> > +     RESET_VAL(VBAR_EL1, 0x1de7ec7edbadc000ULL),
> > +     RESET_UNKNOWN(PIRE0_EL1),
> > +     RESET_UNKNOWN(PIR_EL1),
> > +};
> > +
> > +void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu)
> > +{
> > +     unsigned long i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(pvm_sys_reg_reset_vals); i++) {
> > +             const struct sys_reg_desc_reset *r = &pvm_sys_reg_reset_vals[i];
> > +
> > +             r->reset(vcpu, r);
> > +     }
> > +}
> > +
> >  /*
> >   * Initializes feature registers for protected vms.
> >   */
> > @@ -550,16 +628,21 @@ void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
> >  }
> >
> >  /*
> > - * Checks that the sysreg table is unique and in-order.
> > - *
> > - * Returns 0 if the table is consistent, or 1 otherwise.
> > + * Both tables must be unique and sorted ascending. pvm_sys_reg_descs.reg is the
> > + * sys_reg() encoding, pvm_sys_reg_reset_vals.reg the vcpu_sysreg index, so they
> > + * compare differently. BUG_ON() at __pkvm_init: fatal at boot.
> >   */
> >  int kvm_check_pvm_sysreg_table(void)
> >  {
> >       unsigned int i;
> >
> >       for (i = 1; i < ARRAY_SIZE(pvm_sys_reg_descs); i++) {
> > -             if (cmp_sys_reg(&pvm_sys_reg_descs[i-1], &pvm_sys_reg_descs[i]) >= 0)
> > +             if (cmp_sys_reg(&pvm_sys_reg_descs[i - 1], &pvm_sys_reg_descs[i]) >= 0)
> > +                     return 1;
> > +     }
> > +
> > +     for (i = 1; i < ARRAY_SIZE(pvm_sys_reg_reset_vals); i++) {
> > +             if (pvm_sys_reg_reset_vals[i - 1].reg >= pvm_sys_reg_reset_vals[i].reg)
> >                       return 1;
> >       }
> >
> > --
> > 2.39.5
> >
