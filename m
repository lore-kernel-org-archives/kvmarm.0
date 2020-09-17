Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E851EC43461
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 07:36:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1811E2072E
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 07:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fJYbkkDb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1811E2072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C8FC4B842;
	Thu, 17 Sep 2020 03:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ajXB-DEZPLQ0; Thu, 17 Sep 2020 03:36:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B4C74B7FB;
	Thu, 17 Sep 2020 03:36:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 171F54B7FB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 03:36:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2AqeLWXH70Yy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 03:36:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6FD54B712
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 03:36:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600328211;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=3rlyAdPxuDDdYl6D+KuRAOOnbWwfRjh+5D1CNq4eG4k=;
 b=fJYbkkDb273CmADocibRrZ6Gb8D7VzTEOb7zCjTUxWsL1koMcLeRZUYM9xfxTKkvaEnhX3
 gM4617c9qyj8TidMyWxza/87etWksQJcr4xqN/dqqJ1vZR8JWKnofHIW8MxSlTaliIcPOz
 u66ua7W626R0oqP7+ehn0pfYYGXOhP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-7wc_RQFJMu-8OGuZyN-5Ng-1; Thu, 17 Sep 2020 03:36:47 -0400
X-MC-Unique: 7wc_RQFJMu-8OGuZyN-5Ng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 989451084D6E;
 Thu, 17 Sep 2020 07:36:45 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.179])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EA1D67600;
 Thu, 17 Sep 2020 07:36:42 +0000 (UTC)
Date: Thu, 17 Sep 2020 09:36:39 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ying Fang <fangying1@huawei.com>
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
Message-ID: <20200917073639.zjwae3izyyxl6p6w@kamzik.brq.redhat.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200917023033.1337-3-fangying1@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, maz@kernel.org,
 alex.chen@huawei.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 17, 2020 at 10:30:33AM +0800, Ying Fang wrote:
> Allow userspace to set MPIDR using vcpu ioctl KVM_ARM_SET_MP_AFFINITY,
> so that we can support cpu topology for arm.
> 
> Signed-off-by: Ying Fang <fangying1@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  5 +++++
>  arch/arm64/kvm/arm.c              |  8 ++++++++
>  arch/arm64/kvm/reset.c            | 11 +++++++++++
>  arch/arm64/kvm/sys_regs.c         | 30 +++++++++++++++++++-----------
>  include/uapi/linux/kvm.h          |  2 ++
>  5 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e52c927aade5..7adc351ee70a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -372,6 +372,9 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +
> +	/* vCPU MP Affinity */
> +	u64 mp_affinity;

We probably don't need to introduce new state since we already have a
place for it in the sys_regs array.

>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> @@ -685,6 +688,8 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  
> +int kvm_arm_vcpu_set_mp_affinity(struct kvm_vcpu *vcpu, uint64_t mpidr);
> +
>  #define kvm_arm_vcpu_sve_finalized(vcpu) \
>  	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 913c8da539b3..5f1fa625dc11 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1178,6 +1178,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  
>  		return kvm_arm_vcpu_finalize(vcpu, what);
>  	}
> +	case KVM_ARM_SET_MP_AFFINITY: {
> +		u64 mpidr;
> +
> +		if (get_user(mpidr, (const unsigned int __user *)argp))
> +			return -EFAULT;
> +
> +		return kvm_arm_vcpu_set_mp_affinity(vcpu, mpidr);
> +	}

Why introduce a new ioctl? We already have SET_ONE_REG.

>  	default:
>  		r = -EINVAL;
>  	}
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index ee33875c5c2a..4918c967b0c9 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -188,6 +188,17 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
>  	return -EINVAL;
>  }
>  
> +int kvm_arm_vcpu_set_mp_affinity(struct kvm_vcpu *vcpu, uint64_t mpidr)
> +{
> +	if (!(mpidr & (1ULL << 31))) {
> +		pr_warn("invalid mp_affinity format\n");
> +		return -EINVAL;
> +	}
> +
> +	vcpu->arch.mp_affinity = mpidr;

No sanity checks? If you look at what I once posted [*] you'll see that I
checked reserved bits, flags consistency, and ID uniqueness.

[*] https://www.spinics.net/lists/kvm-arm/msg23879.html

> +	return 0;
> +}
> +
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 077293b5115f..e76f483475ad 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -646,17 +646,25 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 mpidr;
>  
> -	/*
> -	 * Map the vcpu_id into the first three affinity level fields of
> -	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
> -	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
> -	 * of the GICv3 to be able to address each CPU directly when
> -	 * sending IPIs.
> -	 */
> -	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> -	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> -	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> -	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
> +	if (vcpu->arch.mp_affinity) {
> +		/* If mp_affinity is set by userspace, it means an customized cpu
> +		 * topology is defined. Let it be MPIDR of the vcpu
> +		 */
> +		mpidr = vcpu->arch.mp_affinity;
> +	} else {
> +		/*
> +		 * Map the vcpu_id into the first three affinity level fields of
> +		 * the MPIDR. We limit the number of VCPUs in level 0 due to a
> +		 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
> +		 * of the GICv3 to be able to address each CPU directly when
> +		 * sending IPIs.
> +		 */
> +		mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> +		mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> +		mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> +		mpidr |= (1ULL << 31);
> +	}
> +	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
>  }
>  
>  static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c4874905cd9c..ae45876a689d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1475,6 +1475,8 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
>  /* Memory Encryption Commands */
>  #define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
> +/* Available with KVM_CAP_ARM_MP_AFFINITY */
> +#define KVM_ARM_SET_MP_AFFINITY    _IOWR(KVMIO, 0xbb, unsigned long)
>  
>  struct kvm_enc_region {
>  	__u64 addr;
> -- 
> 2.23.0
> 

I suggest approaching this the same way Alex Graf approached PMCR in
https://www.spinics.net/lists/arm-kernel/msg837016.html but also add
sanity checks. The previous patch can also be squashed into this patch.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
