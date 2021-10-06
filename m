Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713A3C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 10:25:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E2263611C5
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 10:24:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E2263611C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E6274B2B2;
	Wed,  6 Oct 2021 06:24:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8SigvYoG+izt; Wed,  6 Oct 2021 06:24:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18E7F4B26D;
	Wed,  6 Oct 2021 06:24:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 824CC4B249
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 06:24:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5XE3o+Gc7z3N for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 06:24:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EBE44B1E1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 06:24:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633515895;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=MmWiCgB8uSNl6DOPQQvudamwXwcTydeBRX/uLyQwgQA=;
 b=Ps6uFmceHlYkWsq0hQtEbRVq6i+J46HWCTYaWHNhJ+iF3NyDOPJ7ehcwq/arrsgjhcMgM9
 e16iV6dXwrs/dtDnreU+ODnXYiZRk64PJDQYYQ+/YQQlbsrtGVldmWzY1KAoj7KHu7erWK
 17Und4MWUuM3bavHCvfTIe1VoYEcfxY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-W1IivcOhM2KrF0LwLiHwmQ-1; Wed, 06 Oct 2021 06:24:54 -0400
X-MC-Unique: W1IivcOhM2KrF0LwLiHwmQ-1
Received: by mail-ed1-f71.google.com with SMTP id
 h12-20020aa7c5cc000000b003dad185759bso2206978eds.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Oct 2021 03:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MmWiCgB8uSNl6DOPQQvudamwXwcTydeBRX/uLyQwgQA=;
 b=tBf87N2NG0YxBo2u3gQWHIX8hcSlGPpcqxiGdK8Mj5yWTdXOmGEaEBnTSHDUfJ5HSu
 NnMxpA9cmp7viQZoxP9DmA+farslvUCGOyJJ7wrTCSI2GsEHRWbsYgjmP2P17VWFLyhK
 n2+ML39Zn3NIRbKuKa3qJuG71joo3pxfV06mLtzTbM0SLsXEpHGC96XsABnCoVC7+Lxv
 vgEjFPr3nOlwkWmiv0SXkg+ODlpT1icvA0CveT5TlwHUJ+ECpLK2Wu3kNB+J8ONxCE9t
 ck+ViRVQms7anpWIsxYqay4j6x1wqX20nh2OBwCt6LleacwKMVgMR+vPosOZ6ROzZ3ih
 fXSQ==
X-Gm-Message-State: AOAM532eFLWSU4FSjePuiRXfIIo72HJDLJGNL76BUmgw6oZgdFol0RXS
 4hCz+RTge2gH2trvB+FKCRcD3g/7vCTqW0TNtxgw/XeDYX6l/TT1hzyR5LA9PIP/g1JsoW4Gebf
 Xd3C6i19TBjWWGiuHOdaVe47y
X-Received: by 2002:a17:906:7ac4:: with SMTP id
 k4mr32292465ejo.430.1633515893289; 
 Wed, 06 Oct 2021 03:24:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0zZ6sW7WDT3oke9j4TDRc16AgVPN/PNWxEB0jdSUXa+T95wQObvHtsiMesHktZL1B3vMLxQ==
X-Received: by 2002:a17:906:7ac4:: with SMTP id
 k4mr32292427ejo.430.1633515893066; 
 Wed, 06 Oct 2021 03:24:53 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id m13sm3872442eda.41.2021.10.06.03.24.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Oct 2021 03:24:52 -0700 (PDT)
Date: Wed, 6 Oct 2021 12:24:50 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 01/16] KVM: arm64: Generalise VM features into a set
 of flags
Message-ID: <20211006102450.4fkn46yqfbbh7i6y@gator.home>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-2-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211004174849.2831548-2-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Oct 04, 2021 at 06:48:34PM +0100, Marc Zyngier wrote:
> We currently deal with a set of booleans for VM features,
> while they could be better represented as set of flags
> contained in an unsigned long, similarily to what we are
> doing on the CPU side.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 12 +++++++-----
>  arch/arm64/kvm/arm.c              |  5 +++--
>  arch/arm64/kvm/mmio.c             |  3 ++-
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..f63ca8fb4e58 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -122,7 +122,10 @@ struct kvm_arch {
>  	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
>  	 * supported.
>  	 */
> -	bool return_nisv_io_abort_to_user;
> +#define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
> +	/* Memory Tagging Extension enabled for the guest */
> +#define KVM_ARCH_FLAG_MTE_ENABLED			1
> +	unsigned long flags;
>  
>  	/*
>  	 * VM-wide PMU filter, implemented as a bitmap and big enough for
> @@ -133,9 +136,6 @@ struct kvm_arch {
>  
>  	u8 pfr0_csv2;
>  	u8 pfr0_csv3;
> -
> -	/* Memory Tagging Extension enabled for the guest */
> -	bool mte_enabled;
>  };
>  
>  struct kvm_vcpu_fault_info {
> @@ -786,7 +786,9 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  #define kvm_arm_vcpu_sve_finalized(vcpu) \
>  	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
>  
> -#define kvm_has_mte(kvm) (system_supports_mte() && (kvm)->arch.mte_enabled)
> +#define kvm_has_mte(kvm)					\
> +	(system_supports_mte() &&				\
> +	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
>  #define kvm_vcpu_has_pmu(vcpu)					\
>  	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe102cd2e518..ed9c89ec0b4f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -89,7 +89,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  	switch (cap->cap) {
>  	case KVM_CAP_ARM_NISV_TO_USER:
>  		r = 0;
> -		kvm->arch.return_nisv_io_abort_to_user = true;
> +		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> +			&kvm->arch.flags);
>  		break;
>  	case KVM_CAP_ARM_MTE:
>  		mutex_lock(&kvm->lock);
> @@ -97,7 +98,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			r = -EINVAL;
>  		} else {
>  			r = 0;
> -			kvm->arch.mte_enabled = true;
> +			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
>  		}
>  		mutex_unlock(&kvm->lock);
>  		break;
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index 3e2d8ba11a02..3dd38a151d2a 100644
> --- a/arch/arm64/kvm/mmio.c
> +++ b/arch/arm64/kvm/mmio.c
> @@ -135,7 +135,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  	 * volunteered to do so, and bail out otherwise.
>  	 */
>  	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
> -		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
> +		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> +			     &vcpu->kvm->arch.flags)) {
>  			run->exit_reason = KVM_EXIT_ARM_NISV;
>  			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
>  			run->arm_nisv.fault_ipa = fault_ipa;
> -- 
> 2.30.2
> 

Maybe a kvm_arm_has_feature(struct kvm *kvm) helper would be nice to avoid
all the &vcpu->kvm->arch.flags types of references getting scattered
around.

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
