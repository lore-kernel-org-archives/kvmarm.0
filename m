Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC237C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 19:16:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5BE49EB4;
	Mon, 14 Mar 2022 15:16:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hpGS2LUBfJdL; Mon, 14 Mar 2022 15:16:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4B249EE9;
	Mon, 14 Mar 2022 15:16:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9255149EB4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 15:16:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5TsLp5zveYRz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 15:16:22 -0400 (EDT)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
 [209.85.166.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F55440B6C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 15:16:21 -0400 (EDT)
Received: by mail-io1-f41.google.com with SMTP id w7so19552174ioj.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 12:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QFzPZegi6BSy8gBbpV2H2g8SL7Kb3RMV+IzydYdfKbc=;
 b=WX2l2JjCq/N5e+MekgO2Yh3poApBSNGv54O59cMWNcKJefjW00nf6rzgVM/y2dcCEf
 RrzgSaxIZ29AUbIfMKds8zfCpFPljzjwsqHuTfFaMLnWlVIzGWyN6cjBWsOymTDNB20o
 D5ClARrEQjJJF/9C61kIJeqNxGUua5XRfYiukqgQZQD56cp86vauWk6eDoyG3+YaGzys
 RlvnMMokiCaNYAzOc+2k3xQSKRtY17DE28qfQBaGJ/hEGhIx7TGyjhAvOqRKNW8BxAoB
 bcyycpFZuwELoJ9NI3E8Dr0h+GxtMmc6D/8gikI/o4wHQPvGD43ph6yW9RVZ4I52hMYb
 V1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QFzPZegi6BSy8gBbpV2H2g8SL7Kb3RMV+IzydYdfKbc=;
 b=Xsr48wrPZbQJUEwDCDMri51n6em7zNQPOaHShcuAzN+31+7gGqhWY7yxF51AfDFbj4
 GznNcjogPxP9vQotFV7OjVBbnbsmHTktiHRRpttZY9U3penC0ae3dN2PD7r4Uo66oOg1
 LCBqsFXp5wYHjEeVWHdpWyexmoRM68K1CH6ibURpyvwBiWOrtuh9skA4DpLwwYQkPgit
 bQUbRSOJJQ7ZtW+ttRkF5nUJVrudcsL3Tnuj24TQel3xuSNlDqIRYWNpSrZbSU9LIWOS
 l1+uiuhE/11ijXAdDMlPj7WYTxm1++hdIWbKuwNpEDkexcM7hc6+RiwFspWa6hN+M7S9
 sYDQ==
X-Gm-Message-State: AOAM533OJtd2CnegyP0aBIf+7/5GTVuAv0xnIFMWik5Vp9apCxIzwdHy
 0OZNtIJFudBpserDrSm/B7b14g==
X-Google-Smtp-Source: ABdhPJzECDumhUFyHULblhiSJ2ofGepVEAx/MXsKN9xriMPRdm0H7mfQZJqPN0z6xILawg0cH8mQEw==
X-Received: by 2002:a05:6638:1925:b0:31a:195e:5b94 with SMTP id
 p37-20020a056638192500b0031a195e5b94mr1449557jal.86.1647285381125; 
 Mon, 14 Mar 2022 12:16:21 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 f4-20020a92b504000000b002c21ef70a81sm9611734ile.7.2022.03.14.12.16.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Mar 2022 12:16:20 -0700 (PDT)
Date: Mon, 14 Mar 2022 19:16:17 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 03/13] KVM: arm64: Encode the scope for firmware
 registers
Message-ID: <Yi+UgfIWfGPKfcqa@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-4-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220224172559.4170192-4-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

Hi Raghu,

On Thu, Feb 24, 2022 at 05:25:49PM +0000, Raghavendra Rao Ananta wrote:
> The psuedo-firmware registers, KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1
> and KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, can be scopped as per-VM
> registers. Hence, during the KVM_GET_REG_LIST call, encode
> KVM_REG_ARM_SCOPE_VM into the registers, but during
> KVM_[GET|SET]_ONE_REG calls, clear the scope information such that
> they can be processed like before.
> 
> For future expansion, helper functions such as
> kvm_arm_reg_id_encode_scope() and kvm_arm_reg_id_clear_scope()
> are introduced.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +
>  arch/arm64/kvm/guest.c            | 77 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hypercalls.c       | 31 +++++++++----
>  3 files changed, 100 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8132de6bd718..657733554d98 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -794,6 +794,8 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
>  
>  int kvm_trng_call(struct kvm_vcpu *vcpu);
> +int kvm_arm_reg_id_encode_scope(struct kvm_vcpu *vcpu, u64 *reg_id);
> +void kvm_arm_reg_id_clear_scope(struct kvm_vcpu *vcpu, u64 *reg_id);
>  #ifdef CONFIG_KVM
>  extern phys_addr_t hyp_mem_base;
>  extern phys_addr_t hyp_mem_size;
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 8238e52d890d..eb061e64a7a5 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -61,6 +61,83 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>  		       sizeof(kvm_vcpu_stats_desc),
>  };
>  
> +/* Registers that are VM scopped */
> +static const u64 kvm_arm_vm_scope_fw_regs[] = {
> +	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> +	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> +};

Is there a reason that KVM_REG_ARM_PSCI_VERSION is omitted? I know that
we have KVM_ARM_VCPU_PSCI_0_2, but we really don't allow for asymmetry
in the PSCI implementation between vCPUs. Logically, this is a
system-wide property. That's a complete wreck if KVM_ARM_VCPU_PSCI_0_2
isn't required to be set/clear for all vCPUs in a VM.

> +
> +/**
> + * kvm_arm_reg_id_encode_scope - Encode the KVM_REG_ARM_SCOPE info into the
> + *				 register-id
> + * @vcpu: The vcpu pointer
> + * @reg_id: Pointer to the register
> + *
> + * The function adds the register's scoping information into its encoding.
> + * If it's explicitly marked as a per-VM register, it's encoded with
> + * KVM_REG_ARM_SCOPE_VM. Else, it's marked as KVM_REG_ARM_SCOPE_VCPU, which
> + * is also the default if KVM_CAP_ARM_REG_SCOPE is disabled.
> + *
> + * For any error cases, the function returns an error code, else it returns
> + * the integer value of the encoding.
> + */
> +int kvm_arm_reg_id_encode_scope(struct kvm_vcpu *vcpu, u64 *reg_id)
> +{
> +	const u64 *vm_scope_reg_arr;
> +	unsigned int arr_size, idx;
> +
> +	if (!READ_ONCE(vcpu->kvm->arch.reg_scope_enabled))
> +		return KVM_REG_ARM_SCOPE_VCPU;
> +
> +	if (!reg_id)
> +		return -EINVAL;
> +
> +	switch (*reg_id & KVM_REG_ARM_COPROC_MASK) {
> +	case KVM_REG_ARM_FW:
> +		vm_scope_reg_arr = kvm_arm_vm_scope_fw_regs;
> +		arr_size = ARRAY_SIZE(kvm_arm_vm_scope_fw_regs);
> +		break;
> +	default:
> +		/* All the other register classes are currently
> +		 * treated as per-vCPU registers.
> +		 */
> +		return KVM_REG_ARM_SCOPE_VCPU;
> +	}
> +
> +	/* By default, all the registers encodings are scoped as vCPU.
> +	 * Modify the scope only if a register is marked as per-VM.
> +	 */
> +	for (idx = 0; idx < arr_size; idx++) {
> +		if (vm_scope_reg_arr[idx] == *reg_id) {
> +			*reg_id |=
> +				KVM_REG_ARM_SCOPE_VM << KVM_REG_ARM_SCOPE_SHIFT;
> +			return KVM_REG_ARM_SCOPE_VM;
> +		}
> +	}
> +
> +	return KVM_REG_ARM_SCOPE_VCPU;
> +}
> +
> +/**
> + * kvm_arm_reg_id_clear_scope - Clear the KVM_REG_ARM_SCOPE info from the
> + *				 register-id
> + * @vcpu: The vcpu pointer
> + * @reg_id: Pointer to the register
> + *
> + * The function clears the register's scoping information, which ultimately
> + * is the raw encoding of the register. Note that the result is same as that
> + * of re-encoding the register as KVM_REG_ARM_SCOPE_VCPU.
> + * The function can be helpful to the existing code that uses the original
> + * register encoding to operate on the register.
> + */
> +void kvm_arm_reg_id_clear_scope(struct kvm_vcpu *vcpu, u64 *reg_id)

How about just taking the reg_id by value and returning it? You could
probably just bundle this up in a macro

> +{
> +	if (!READ_ONCE(vcpu->kvm->arch.reg_scope_enabled) || !reg_id)

Shouldn't masking these bits work regardless? They must be zero without
the CAP.

> +		return;

> +
> +	*reg_id &= ~(1 << KVM_REG_ARM_SCOPE_SHIFT);

define a _MASK for KVM_REG_ARM_SCOPE and just use that.

> +}
> +
>  static bool core_reg_offset_is_vreg(u64 off)
>  {
>  	return off >= KVM_REG_ARM_CORE_REG(fp_regs.vregs) &&
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 3c2fcf31ad3d..8624e6964940 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -160,10 +160,17 @@ int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>  
>  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  {
> -	int i;
> +	int i, ret;
> +	u64 reg_id;
>  
>  	for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
> -		if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
> +		reg_id = kvm_arm_fw_reg_ids[i];
> +
> +		ret = kvm_arm_reg_id_encode_scope(vcpu, &reg_id);
> +		if (ret < 0)
> +			return ret;

You could also store the register IDs with the scope already encoded and
simply mask those bits off if the CAP is disabled. That way, its
immediately obvious what the scope of any given register is just by
looking at the register table.

> +		if (put_user(reg_id, uindices++))
>  			return -EFAULT;
>  	}
>  
> @@ -214,21 +221,23 @@ static int get_kernel_wa_level(u64 regid)
>  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
>  	void __user *uaddr = (void __user *)(long)reg->addr;
> -	u64 val;
> +	u64 val, reg_id = reg->id;
>  
> -	switch (reg->id) {
> +	kvm_arm_reg_id_clear_scope(vcpu, &reg_id);
> +
> +	switch (reg_id) {
>  	case KVM_REG_ARM_PSCI_VERSION:
>  		val = kvm_psci_version(vcpu, vcpu->kvm);
>  		break;
>  	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
>  	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> -		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> +		val = get_kernel_wa_level(reg_id) & KVM_REG_FEATURE_LEVEL_MASK;
>  		break;
>  	default:
>  		return -ENOENT;
>  	}
>  
> -	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
> +	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg_id)))
>  		return -EFAULT;
>  
>  	return 0;
> @@ -237,13 +246,15 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
>  	void __user *uaddr = (void __user *)(long)reg->addr;
> -	u64 val;
> +	u64 val, reg_id = reg->id;
>  	int wa_level;
>  
>  	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
>  		return -EFAULT;
>  
> -	switch (reg->id) {
> +	kvm_arm_reg_id_clear_scope(vcpu, &reg_id);
> +
> +	switch (reg_id) {
>  	case KVM_REG_ARM_PSCI_VERSION:
>  	{
>  		bool wants_02;
> @@ -270,7 +281,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
>  			return -EINVAL;
>  
> -		if (get_kernel_wa_level(reg->id) < val)
> +		if (get_kernel_wa_level(reg_id) < val)
>  			return -EINVAL;
>  
>  		return 0;
> @@ -306,7 +317,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  		 * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
>  		 * other way around.
>  		 */
> -		if (get_kernel_wa_level(reg->id) < wa_level)
> +		if (get_kernel_wa_level(reg_id) < wa_level)
>  			return -EINVAL;
>  
>  		return 0;
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
