Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC037C4742C
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 11:27:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC7C922240
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 11:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HVhROgdD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC7C922240
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3837E4BBE2;
	Fri, 13 Nov 2020 06:27:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uWWmHbpPGj7v; Fri, 13 Nov 2020 06:27:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED6624BC7B;
	Fri, 13 Nov 2020 06:27:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A6E14BBD9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 06:27:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 716ur9dlllJ3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 06:27:38 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F00474BBCB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 06:27:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605266857;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3OaLcK30zyS9d26ShuW8WJDhvXGFXLhcNrnmUEgtQSc=;
 b=HVhROgdDD7ToUpRTxS1lwpztOvOH+NGDI2n/bKngomHsOiQ60zI45Lp56O8k4HBpnxmLRk
 4ICbAl4rDYJ7Qc2EWORzJ/xEpqJtBsyUr8TV4kZ9DVS9mSQ8ulJdo5G3VxSu+757qsuA1/
 4Ag+oe7jd5KxIjlSRgtZCqlXy+52O8Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-P9kuGGXQOO6qsu0cTNT3wA-1; Fri, 13 Nov 2020 06:27:36 -0500
X-MC-Unique: P9kuGGXQOO6qsu0cTNT3wA-1
Received: by mail-wm1-f71.google.com with SMTP id o19so3775802wme.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 03:27:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=3OaLcK30zyS9d26ShuW8WJDhvXGFXLhcNrnmUEgtQSc=;
 b=o6Q3D7BZu/K2LjrcNkeTsyOWDfxJt1w+bGtWE53IrnzF1fb5Hiu+NxyAieSgD1BVs3
 Xo4sl1pnv6f41Ih0wGg0B7HnhBLwcsRzE/LE/D5r3je2A+wN1dF6IQ2fbWIeNdLCxpMA
 CYKBHovodF7qQun90V3FTBSJgWrsECBxOzhvIaiwfuubXZIpn+Uk/H3/2dt+OqxAJ599
 gygawL3BM3fj0izr132dntwMK8aVgwAyekczmJlRAByHWLugq4ETRordvJ/r5UjplHnN
 wCES9bweWvoKoswuIdO4xhlQLK7st0XzfgDDvF88WkOJBnqnft2ZjMnOo80oV05BeuzB
 8zHw==
X-Gm-Message-State: AOAM5322Gw90j1e+5X2ONtKVfew4DXHjZpn5YqR+Vb6CWNby8sTn26qX
 SSAHWhSFHZayEPBiiMq4FX5kqSFEf78OkjXIpO4pTsHE+kLZLydM3HtdNJzvvqlvfjZ5cepcUo7
 4Z/l6GsdM1LEowzrWXqARf4+q
X-Received: by 2002:a1c:1b85:: with SMTP id b127mr2107430wmb.163.1605266851838; 
 Fri, 13 Nov 2020 03:27:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzN6TPvbWBpgvXVH4WOd5o3163TN9IqXb6tDnXc611TYDRh/hPCRCufm84JFkhFpHTJzcpyOw==
X-Received: by 2002:a1c:1b85:: with SMTP id b127mr2107392wmb.163.1605266851436; 
 Fri, 13 Nov 2020 03:27:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id b73sm17126050wmb.0.2020.11.13.03.27.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 13 Nov 2020 03:27:30 -0800 (PST)
Subject: Re: [PATCH 0/3] KVM/arm64 fixes for 5.10, take #3
To: Marc Zyngier <maz@kernel.org>
References: <20201112222139.466204-1-maz@kernel.org>
 <20201112222139.466204-2-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d594534d-dba9-8585-da66-af355b99abaa@redhat.com>
Date: Fri, 13 Nov 2020 12:27:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201112222139.466204-2-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 12/11/20 23:21, Marc Zyngier wrote:
> We now expose ID_AA64PFR0_EL1.CSV2=1 to guests running on hosts
> that are immune to Spectre-v2, but that don't have this field set,
> most likely because they predate the specification.
> 
> However, this prevents the migration of guests that have started on
> a host the doesn't fake this CSV2 setting to one that does, as KVM
> rejects the write to ID_AA64PFR0_EL2 on the grounds that it isn't
> what is already there.
> 
> In order to fix this, allow userspace to set this field as long as
> this doesn't result in a promising more than what is already there
> (setting CSV2 to 0 is acceptable, but setting it to 1 when it is
> already set to 0 isn't).
> 
> Fixes: e1026237f9067 ("KVM: arm64: Set CSV2 for guests on hardware unaffected by Spectre-v2")
> Reported-by: Peng Liang <liangpeng10@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Will Deacon <will@kernel.org>
> Link: https://lore.kernel.org/r/20201110141308.451654-2-maz@kernel.org
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 ++
>   arch/arm64/kvm/arm.c              | 16 ++++++++++++
>   arch/arm64/kvm/sys_regs.c         | 42 ++++++++++++++++++++++++++++---
>   3 files changed, 56 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 781d029b8aa8..0cd9f0f75c13 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -118,6 +118,8 @@ struct kvm_arch {
>   	 */
>   	unsigned long *pmu_filter;
>   	unsigned int pmuver;
> +
> +	u8 pfr0_csv2;
>   };
>   
>   struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a3b32df1afb0..a6e25a4b4dc5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -102,6 +102,20 @@ static int kvm_arm_default_max_vcpus(void)
>   	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>   }
>   
> +static void set_default_csv2(struct kvm *kvm)
> +{
> +	/*
> +	 * The default is to expose CSV2 == 1 if the HW isn't affected.
> +	 * Although this is a per-CPU feature, we make it global because
> +	 * asymmetric systems are just a nuisance.
> +	 *
> +	 * Userspace can override this as long as it doesn't promise
> +	 * the impossible.
> +	 */
> +	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
> +		kvm->arch.pfr0_csv2 = 1;
> +}
> +
>   /**
>    * kvm_arch_init_vm - initializes a VM data structure
>    * @kvm:	pointer to the KVM struct
> @@ -127,6 +141,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	/* The maximum number of VCPUs is limited by the host's GIC model */
>   	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
>   
> +	set_default_csv2(kvm);
> +
>   	return ret;
>   out_free_stage2_pgd:
>   	kvm_free_stage2_pgd(&kvm->arch.mmu);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6d287eefd9f1..0aa86250e354 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1128,9 +1128,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>   		if (!vcpu_has_sve(vcpu))
>   			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
>   		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
> -		if (!(val & (0xfUL << ID_AA64PFR0_CSV2_SHIFT)) &&
> -		    arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
> -			val |= (1UL << ID_AA64PFR0_CSV2_SHIFT);
> +		val &= ~(0xfUL << ID_AA64PFR0_CSV2_SHIFT);
> +		val |= ((u64)vcpu->kvm->arch.pfr0_csv2 << ID_AA64PFR0_CSV2_SHIFT);
>   	} else if (id == SYS_ID_AA64PFR1_EL1) {
>   		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
>   	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> @@ -1213,6 +1212,40 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>   	return REG_HIDDEN;
>   }
>   
> +static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> +			       const struct sys_reg_desc *rd,
> +			       const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	const u64 id = sys_reg_to_index(rd);
> +	int err;
> +	u64 val;
> +	u8 csv2;
> +
> +	err = reg_from_user(&val, uaddr, id);
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> +	 * it doesn't promise more than what is actually provided (the
> +	 * guest could otherwise be covered in ectoplasmic residue).
> +	 */
> +	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV2_SHIFT);
> +	if (csv2 > 1 ||
> +	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
> +		return -EINVAL;
> +
> +	/* We can only differ with CSV2, and anything else is an error */
> +	val ^= read_id_reg(vcpu, rd, false);
> +	val &= ~(0xFUL << ID_AA64PFR0_CSV2_SHIFT);
> +	if (val)
> +		return -EINVAL;
> +
> +	vcpu->kvm->arch.pfr0_csv2 = csv2;
> +
> +	return 0;
> +}
> +
>   /*
>    * cpufeature ID register user accessors
>    *
> @@ -1472,7 +1505,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   
>   	/* AArch64 ID registers */
>   	/* CRm=4 */
> -	ID_SANITISED(ID_AA64PFR0_EL1),
> +	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
> +	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
>   	ID_SANITISED(ID_AA64PFR1_EL1),
>   	ID_UNALLOCATED(4,2),
>   	ID_UNALLOCATED(4,3),
> 

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
