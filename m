Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E6CC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 16:14:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D928461213
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 16:14:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D928461213
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D02C4B0F7;
	Thu,  4 Nov 2021 12:14:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id peqvSxinBO4U; Thu,  4 Nov 2021 12:14:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD0354B0F5;
	Thu,  4 Nov 2021 12:14:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8656049F5D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 12:14:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wj4GtZ+mx1m5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Nov 2021 12:14:38 -0400 (EDT)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com
 [209.85.166.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E864F4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 12:14:37 -0400 (EDT)
Received: by mail-il1-f181.google.com with SMTP id w10so6683935ilc.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 09:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NgdcI1FZCEQ3mYVhXe1Y6jGpAFm0yKOO22Hx0/66Yl0=;
 b=RbDG5roEvPdd+o7AyibShf3GbKzCA+h6ImfBEm1d64Jskuj6Gf//VE8G1HLcsaI1V+
 UEhJPE+l5Czac4oKKknSxpMnFZVg2k0GdFXZ/5o0Zai2/cZ6/vbA+fGqc74XwDhHKuC9
 I2oMazu9Nhn4ISseWuM7ozGoe3L0gKqKnYFiLA48IXw8BPNVfoGHn+k+khIzdjto9IFV
 5TwMh//dT/mws+aKF4EmZwwFqTW/yJ9HGVMv/fnL0cI/8K7bEEM0ZfWPclzuNlRA4xct
 RilnUYOshbxiR5WQg4e8WnBROnyyhgCzc7en1rZp+SmbdpFzDWagV66KzRYWCR4sKkv1
 OdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NgdcI1FZCEQ3mYVhXe1Y6jGpAFm0yKOO22Hx0/66Yl0=;
 b=VFnGOXoRi90Bjd60nzdQopNx9U2h+Bc7jPhnIGYpzLOEvcCAMaPhRhDRpdqW8DKHDl
 vI9ot/B/ZG+0zdOxE33e8a70yJuCuJynim86tDl0J4l7nP4BbHuukZmXYsTxNKah6ZWl
 VBgn3Bi0BwaukfnDPDWsUoV6gkpi2UmTwcizyM4coy8b7C/zD4CbBBcTgQxLTqkJegdA
 hASHLjqInSU3ggZdgaVpIvCUvlg+kMn2VrgI07yoGtcDcK3lhqepCy0+jmDaPQv0xVZD
 SBChV1+haEOYW2F4lxno9BhImIvSMJLYZXzzMZLDABVw87mMz8hOD4vp0BQPbKGe8ZAT
 JRiQ==
X-Gm-Message-State: AOAM5315yb4yXPsCX4YDFs2makyVZjgcIuQVh8MAvwmIXX+aSv3JxA/O
 gKAVGtb8dM6YlH95y6HsWETm1Q==
X-Google-Smtp-Source: ABdhPJx2UgnaOyMeSxP/7ePkII99LyFnFauRypM2aOjFE2TqKMumJnFeXDpWYbsH0cY4gElUJRy0vA==
X-Received: by 2002:a92:1a08:: with SMTP id a8mr35594481ila.286.1636042477103; 
 Thu, 04 Nov 2021 09:14:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id u12sm1042822iop.52.2021.11.04.09.14.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Nov 2021 09:14:36 -0700 (PDT)
Date: Thu, 4 Nov 2021 16:14:33 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v2 02/28] KVM: arm64: Save ID registers' sanitized
 value per vCPU
Message-ID: <YYQG6fxRVEsJ9w2d@google.com>
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-3-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211103062520.1445832-3-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

On Tue, Nov 02, 2021 at 11:24:54PM -0700, Reiji Watanabe wrote:
> Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> registers' sanitized value in the array for the vCPU at the first
> vCPU reset. Use the saved ones when ID registers are read by
> userspace (via KVM_GET_ONE_REG) or the guest.

Based on my understanding of the series, it appears that we require the
CPU identity to be the same amongst all vCPUs in a VM. Is there any
value in keeping a single copy in kvm_arch?

> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
>  arch/arm64/kvm/sys_regs.c         | 24 ++++++++++++++++--------
>  2 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9b5e7a3b6011..0cd351099adf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -145,6 +145,14 @@ struct kvm_vcpu_fault_info {
>  	u64 disr_el1;		/* Deferred [SError] Status Register */
>  };
>  
> +/*
> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> + * where 0<=crm<8, 0<=op2<8.
> + */
> +#define KVM_ARM_ID_REG_MAX_NUM 64
> +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> +#define IDREG_SYS_IDX(id)	(ID_REG_BASE + IDREG_IDX(id))
> +
>  enum vcpu_sysreg {
>  	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
>  	MPIDR_EL1,	/* MultiProcessor Affinity Register */
> @@ -209,6 +217,8 @@ enum vcpu_sysreg {
>  	CNTP_CVAL_EL0,
>  	CNTP_CTL_EL0,
>  
> +	ID_REG_BASE,
> +	ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
>  	/* Memory Tagging Extension registers */
>  	RGSR_EL1,	/* Random Allocation Tag Seed Register */
>  	GCR_EL1,	/* Tag Control Register */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1d46e185f31e..2443440720b4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -273,7 +273,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
>  			  struct sys_reg_params *p,
>  			  const struct sys_reg_desc *r)
>  {
> -	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> +	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
>  	u32 sr = reg_to_encoding(r);
>  
>  	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> @@ -1059,12 +1059,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -/* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
>  {
>  	u32 id = reg_to_encoding(r);
> -	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> +	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
>  
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
> @@ -1174,6 +1173,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
>  
> +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> +{
> +	u32 id = reg_to_encoding(rd);
> +
> +	if (vcpu_has_reset_once(vcpu))
> +		return;
> +
> +	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
> +}
> +
>  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  			       const struct sys_reg_desc *rd,
>  			       const struct kvm_one_reg *reg, void __user *uaddr)
> @@ -1219,9 +1228,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  /*
>   * cpufeature ID register user accessors
>   *
> - * For now, these registers are immutable for userspace, so no values
> - * are stored, and for set_id_reg() we don't allow the effective value
> - * to be changed.
> + * We don't allow the effective value to be changed.
>   */
>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
> @@ -1375,6 +1382,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>  #define ID_SANITISED(name) {			\
>  	SYS_DESC(SYS_##name),			\
>  	.access	= access_id_reg,		\
> +	.reset	= reset_id_reg,			\
>  	.get_user = get_id_reg,			\
>  	.set_user = set_id_reg,			\
>  	.visibility = id_visibility,		\
> @@ -1830,8 +1838,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
>  	if (p->is_write) {
>  		return ignore_write(vcpu, p);
>  	} else {
> -		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> -		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +		u64 dfr = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64DFR0_EL1));
> +		u64 pfr = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64PFR0_EL1));
>  		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>  
>  		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
