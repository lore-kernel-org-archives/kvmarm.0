Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A33F30ACF0
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 05:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791265642; cv=none; b=otkRqrFSOLpc8bxwjVyO/FCS7ld1H4kmgF5ITeyyR/FO0axm8rChZlRXuLjaTCA/EtABsMfxVV7Oo/zB3CQstl70b3LQUljY3mHc5u/oNni/Bt2mp0as45c1cl+KPX3848GF3CyvLH8SpVlFoLxkCPS1voH+TM5O5NvrvpCxSLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791265642; c=relaxed/simple;
	bh=L60XLPchJCqLgVnWNEpOMl7/7A30HgAIiZRysxNy0xg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U0PUICpEYKtgfa8EnH7/KnMu3JnHlTe/wbRWS4b3yLruPvtEScX7j0MF2X8GOVfkyrAFagIblMli5EXuwoLg9oPbFqDkIZ7CjyLe+HcJ/Szg5nuYLNyo/wyTeVxJ9QHc27VGakdeybEzAOh8Fo+QvcxAXljuBZCvkK1S1umQ8aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HgDUh8ez; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HgDUh8ez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791265639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SVWHebib2+PaxqGfX8DYOd3/6naf8L3Knlt4kbfFSlY=;
	b=HgDUh8ezzFbFkLXf/VanLzQtDB+1cUdCWSXw7ivSXQsDCGJg+oKH4m39290PSIAL0mldd+
	IIGTSC+mbUKZwMkpFq04xwKTPq6AhmcGA2mDfA2WdJRSWIZAk/XUO3hAut2n9SMbRMJwqM
	fPh9P7gkU80yw3SSIqH5AsrE2jTxZs8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-DLaLeQPVNFuqlQqeE6JAJA-1; Tue, 06 Oct 2026 01:47:18 -0400
X-MC-Unique: DLaLeQPVNFuqlQqeE6JAJA-1
X-Mimecast-MFC-AGG-ID: DLaLeQPVNFuqlQqeE6JAJA_1791265637
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d6f80c76e6so29297375ad.3
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 22:47:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791265637; x=1791870437;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SVWHebib2+PaxqGfX8DYOd3/6naf8L3Knlt4kbfFSlY=;
        b=OaZcLGKcwyStX7MnNgoqKfMdKklFgX2zRih1zAQUBiYUBdelICLRfEXczss0W/45hf
         tx5GxvsBlhlg4NtZH0fgiXR37ZrSQ58qwmHQ4P4Z7GfY4GTZe9upxDOdPbVnr4VkPJM8
         vjQ9+jgL0G5Z/Cdzu7YtJHQVYuTHdRSkOVKqZVQ0f04pMNG0IK4fmHCYjywtnvK1O7jl
         8DtIk1uAAEEa2ykK/UOvDtgyCy/NZaMCpQ8PelE7C/jMrMvzt3XI73s0BGHtY/Mfxsb+
         tETJIFhEnXFxQo2zmsqD5IRrQucTlnjMsQ42O6cX71wk8B9kUtZavLfd9s4GOd7/oDZq
         DEBg==
X-Forwarded-Encrypted: i=1; AKwUvBzDqyc6rgaQkVamgRr/rz9WURfIXQuXd2ISySKIaq2bHIE+Qs+nL/Yh2nam21824LgVM4wFu8g=@lists.linux.dev
X-Gm-Message-State: AFq9FYL4Xk5VCE2ViU9c2WjzNz+wYCKSPCudCWxA3mdbhxODeRUC6V8o
	LUPeW3GB4c3Z1qm88181AY+8zwp2/fdi6DpuPr0ILB20N9XedxXeL8JnFmhpPlQSCOm6a82j76c
	zgz6tJYvTVsbIVLALdRw7nUfY8fmMg/G0gmAM8SpSEw9nWveAXGBlkUJFTw==
X-Gm-Gg: AYBFou2xxSsTL0Q8yOId57YabX063bU6ctT+bmdfqTw1KzMYUCKGmhz2SiV4z00z8aA
	K+RCDuGbT0czGJI/JyLz2wvx/vxplRK79YbLC4nopOOrlPtnaloMLWoEAAQslwCy+6MajY6JkJu
	g5/io2uc7orIQLKuAjNC33nGcMPVtfjufiLwn57hbHrCTfJXcHLYVs3bfjiGSiDEmqRaWyh7Yu0
	foW71SkmVAyFazeuMnSCxc4XCpZHAWLTJ42AL7k4F28cz/JxGKJfgAizwt9QNMIimYvdA7wgUoN
	Xq9GbxUmrpDEp/ogBfgweAjF7AWOm+6vHxoJgc5kMO2+vyAP53xT/RAyPbahFWCkDBnZV28YfEV
	Bg1WaQfnG9EaYVxJ+AAPFC9uPyNjT8Zs3bL66JVSRyA==
X-Received: by 2002:a17:902:d4c9:b0:2e3:913:31a2 with SMTP id d9443c01a7336-2e5dcdd5eb5mr3865075ad.66.1791265636612;
        Mon, 05 Oct 2026 22:47:16 -0700 (PDT)
X-Received: by 2002:a17:902:d4c9:b0:2e3:913:31a2 with SMTP id d9443c01a7336-2e5dcdd5eb5mr3864895ad.66.1791265636092;
        Mon, 05 Oct 2026 22:47:16 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5caea69sm16749185ad.16.2026.10.05.22.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 22:47:15 -0700 (PDT)
Message-ID: <52e3e45a-751e-40b2-8dd3-3db589ddebee@redhat.com>
Date: Tue, 6 Oct 2026 15:47:05 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 23/23] KVM: arm64: CCA: Control user register access
 for Realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-24-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-24-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FI_NkiSaPdc2MxYIY49bD-7tLrxhv6JI6Bf6-nsRuDc_1791265637
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM restricts the access to the register states that the host can
> read/modify for a given Realm.
> 
> e.g., At VCPU creation, can modify GPRS (x0-x30) and PC.
>        While servicing SMCCC calls via RSI_HOST_CALL or servicing PSCI
>        requests.
>        MMIO emulation in the unprotected space.
> 
> Additionally we use the sysreg configuration to advertise/configure the
> following Realm parameters, which are required before the Realm Descriptor
> is created:
>   - SVE Vector Length
>   - Number of HW Breakpoints/Watchpoints
>   - PMU Counters.
> 
> Thus KVM also additionally allows access to ID_AA64DFR0_EL1 and SVE_VLS for
> the configuration of Realm creation parameters. We don't support PMUs for
> the Realm VMs yet, so PMCR is not exposed.
> 
> The RMM makes similar restrictions for reading of the guest's registers
> (this is *confidential* compute after all), however we don't impose the
> restriction here. This allows the VMM to read (stale) values from the
> registers which might be useful to read back the initial values even if
> the RMM doesn't provide the latest version. For migration of a realm VM,
> a new interface will be needed so that the VMM can receive an
> (encrypted) blob of the VM's state.
> 
> Reflect the above in KVM_GET_REG_LIST, KVM_SET_ONE_REG calls.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Co-developed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/kvm/guest.c      | 63 +++++++++++++++++++++++++++++++++++++
>   arch/arm64/kvm/hypercalls.c |  4 +--
>   arch/arm64/kvm/sys_regs.c   | 28 +++++++++++++----
>   3 files changed, 87 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index c3ca369882273..ffe3f5ce4b3cf 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -73,6 +73,25 @@ static u64 core_reg_offset_from_id(u64 id)
>   	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
>   }
>   
> +static bool kvm_realm_validate_core_reg(u64 off)
> +{
> +	/*
> +	 * Note that GPRs can only sometimes be controlled by the VMM.
> +	 * For PSCI only X0-X6 are used, higher registers are ignored (restored
> +	 * from the REC).
> +	 * For HOST_CALL all of X0-X30 are copied to the RsiHostCall structure.
> +	 * For emulated MMIO X0 is always used.
> +	 * PC can only be set before the realm is activated.
> +	 */
> +	switch (off) {
> +	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
> +	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
> +	case KVM_REG_ARM_CORE_REG(regs.pc):
> +		return true;
> +	}
> +	return false;
> +}
> +
>   static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>   {
>   	int size;
> @@ -553,6 +572,9 @@ static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
>   		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
>   		int size = core_reg_size_from_offset(vcpu, i);
>   
> +		if (vcpu_is_rec(vcpu) && !kvm_realm_validate_core_reg(i))
> +			continue;
> +
>   		if (size < 0)
>   			continue;
>   
> @@ -598,6 +620,9 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
>   	if (!vcpu_has_sve(vcpu))
>   		return 0;
>   
> +	if (kvm_vm_is_realm(vcpu->kvm))
> +		return 1; /* KVM_REG_ARM64_SVE_VLS */
> +
>   	if (!kvm_arm_vcpu_sve_finalized(vcpu))
>   		return 1; /* KVM_REG_ARM64_SVE_VLS */
> 

Aren't above two checks conflicting to each other?

   
> @@ -625,6 +650,10 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>   		return -EFAULT;
>   	++num_regs;
>   
> +	/* For Realms only support SVE_VLS */
> +	if (kvm_vm_is_realm(vcpu->kvm))
> +		return num_regs;
> +
>   	if (!kvm_arm_vcpu_sve_finalized(vcpu))
>   		return num_regs;
>   

Same question here.

> @@ -705,6 +734,11 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
>   		return -EINVAL;
>   
> +	/*
> +	 * We don't filter out the register reads for Realms, like we do for
> +	 * the user writes. We expose junk data for the VMM instead of
> +	 * denying the requests.
> +	 */
>   	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>   	case KVM_REG_ARM_CORE:	return get_core_reg(vcpu, reg);
>   	case KVM_REG_ARM_FW:
> @@ -716,12 +750,41 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	return kvm_arm_sys_reg_get_reg(vcpu, reg);
>   }
>   
> +#define KVM_REG_ARM_ID_AA64DFR0_EL1	ARM64_SYS_REG(3, 0, 0, 5, 0)
> +/*
> + * The RMI ABI only enables setting some GPRs and PC. The selection of GPRs
> + * that are available depends on the Realm state and the reason for the last
> + * exit.  All other registers are reset to architectural or otherwise defined
> + * reset values by the RMM, except for a few configuration fields that
> + * correspond to Realm parameters.
> + */
> +static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg)
> +{
> +	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE) {
> +		u64 off = core_reg_offset_from_id(reg->id);
> +
> +		return kvm_realm_validate_core_reg(off);
> +	}
> +
> +	switch (reg->id) {
> +	case KVM_REG_ARM_ID_AA64DFR0_EL1:
> +	case KVM_REG_ARM64_SVE_VLS:
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>   int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   {
>   	/* We currently use nothing arch-specific in upper 32 bits */
>   	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
>   		return -EINVAL;
>   
> +	if (kvm_vm_is_realm(vcpu->kvm) && !validate_realm_set_reg(vcpu, reg))
> +		return -EINVAL;
> +
>   	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>   	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
>   	case KVM_REG_ARM_FW:
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index b11b8821c9fbc..2b1e6fdeb4d5c 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -414,14 +414,14 @@ void kvm_arm_teardown_hypercalls(struct kvm *kvm)
>   
>   int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>   {
> -	return ARRAY_SIZE(kvm_arm_fw_reg_ids);
> +	return vcpu_is_rec(vcpu) ? 0 : ARRAY_SIZE(kvm_arm_fw_reg_ids);
>   }
>   
>   int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   {
>   	int i;
>   
> -	for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
> +	for (i = 0; i < kvm_arm_get_fw_num_regs(vcpu); i++) {
>   		if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
>   			return -EFAULT;
>   	}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d7..47ebde943a09e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5638,18 +5638,18 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>   				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
>   }
>   
> -static unsigned int num_demux_regs(void)
> +static inline unsigned int num_demux_regs(struct kvm_vcpu *vcpu)
>   {
> -	return CSSELR_MAX;
> +	return vcpu_is_rec(vcpu) ? 0 : CSSELR_MAX;
>   }
>   
> -static int write_demux_regids(u64 __user *uindices)
> +static int write_demux_regids(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   {
>   	u64 val = KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
>   	unsigned int i;
>   
>   	val |= KVM_REG_ARM_DEMUX_ID_CCSIDR;
> -	for (i = 0; i < CSSELR_MAX; i++) {
> +	for (i = 0; i < num_demux_regs(vcpu); i++) {
>   		if (put_user(val | i, uindices))
>   			return -EFAULT;
>   		uindices++;
> @@ -5693,11 +5693,27 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
>   	return true;
>   }
>   
> +static inline bool kvm_realm_sys_reg_hidden_user(const struct kvm_vcpu *vcpu,
> +						 u64 reg)
> +{
> +	if (!vcpu_is_rec(vcpu))
> +		return false;
> +
> +	switch (reg) {
> +	case SYS_ID_AA64DFR0_EL1:
> +		return false;
> +	}
> +	return true;
> +}
> +
>   static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
>   			    const struct sys_reg_desc *rd,
>   			    u64 __user **uind,
>   			    unsigned int *total)
>   {
> +	if (kvm_realm_sys_reg_hidden_user(vcpu, reg_to_encoding(rd)))
> +		return 0;
> +
>   	/*
>   	 * Ignore registers we trap but don't save,
>   	 * and for which no custom user accessor is provided.
> @@ -5735,7 +5751,7 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
>   
>   unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
>   {
> -	return num_demux_regs()
> +	return num_demux_regs(vcpu)
>   		+ walk_sys_regs(vcpu, (u64 __user *)NULL);
>   }
>   
> @@ -5748,7 +5764,7 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   		return err;
>   	uindices += err;
>   
> -	return write_demux_regids(uindices);
> +	return write_demux_regids(vcpu, uindices);
>   }
>   
>   #define KVM_ARM_FEATURE_ID_RANGE_INDEX(r)			\

Thanks,
Gavin

