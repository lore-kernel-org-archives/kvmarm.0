Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C762A1AA
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 14:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747146022; cv=none; b=PlWJ0DEOZf2sPinGZrtpiPOWK8LghYi/2ELE0uJDzITBfo+9ctyOCFwQ8hAiyxiGmrbdQH+UOr8c11deC4jiVLpLaEHpZHlVCFcLbEJu9mvSEeVfVKDdGMouK7V1PX/i5hzdps7hJ3Gz42SsPM4KwdCjFMxrUBNWfFUFoZg33iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747146022; c=relaxed/simple;
	bh=5Sm+ZR/56MOb7Cv1LtyLA+MQ4JCiVuH0be1bybqD8c0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AoOqtDaB/SvgQ/H8zE7xsHH3K1QpHz+AsGoOF8EwWSjrakNCsXBIw8w0bS8acTwGFhFESw3W+NBBQRcxBuR7IvxEtHPUKqKJNW+J9zzCX/5l7bvMb7ZkMNoWWci1hkS20KTBOYp5p7txhheOkYxtHc73K0KkvkHi9J8V138si/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y3bN8z4x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y3bN8z4x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747146019;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eyscc4t3yNl1uSrVJZkh3Y4b61e+bOq9gii8cVcyfdc=;
	b=Y3bN8z4xfKcAnZOMPw4SiZJa3AIm9bmR9ijo689OLUH6+bzz1Yw0QzYJfLKtxqZ5/8mIbu
	/TmafPBA+AWfoFxDrYPDUI1p4geE/1fI0U92O52GY+Shs3G50Kiqk+eVRwj55xeDde1LGG
	Qy55YBRm8Kr0PwP2n2dAKQQkamTD968=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-C0nMnHPQOV-29WDVZMm3Cw-1; Tue, 13 May 2025 10:20:18 -0400
X-MC-Unique: C0nMnHPQOV-29WDVZMm3Cw-1
X-Mimecast-MFC-AGG-ID: C0nMnHPQOV-29WDVZMm3Cw_1747146014
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so32409405e9.1
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 07:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747146014; x=1747750814;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eyscc4t3yNl1uSrVJZkh3Y4b61e+bOq9gii8cVcyfdc=;
        b=tPhAfhP1IsKvu8IA3stSk0DaKAeZ0acRebZSVk08UXXNMkfDORJvOHZHORoTQvvwy9
         qyDiVryAXiR1cENF+cPYea8o8YLKd8gEDnW1cuVb2Xehw6wUV48mo7481owbte8jVGcg
         +7sT8u4Egg2oOd2GIWHqUGHlczw8mOe+veO5iINkB/bNga1cAKJVVsPT1VsN6DnhvBSY
         SltyELsp6P996j/MTiAeOWtT8nN6Aj1cq0bcB3rk0YMX0ieMldJb/UaUtjg0FvL6jIl6
         ZMgZJIX4hUcUh0VA7U05dYQC37quTHQ+9Asxf4Tcsk61Qdfsp6PVP3WoSkiMNwo03cNd
         +5nw==
X-Forwarded-Encrypted: i=1; AJvYcCUKaWWfbg8bPhZKkUkWlvIRhcpmrYlsnzsApOeqX4bDuph111vCEG6KTpOVYSYoZFOKOHvzZuQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwsgKbzzQMgqObIUoXh+1Ofwk+PqkHYY3WATHgLseTYjh+qleh3
	x00y2sJDAOKNNIvmkMUC2peg7ZxX8BrqRNogUz460UM7RezCX3ih5NWtnfssGJKGuvFk6rCUbXd
	ROjP3wZge4RVP7zym6JSFYMFGO7qEGxjjrsBM9Mh+Bcd2C/9RBHGwNg==
X-Gm-Gg: ASbGncsqREQC06gJgrVhRmF/zHalIIYTlrgYZgo7zFyHCyzdSiJL+H+iMGGHQgvg4Oa
	M3wD1xEEitcN9KkFoUw6tK5875Jl6N8TmFZSRQ7n3mTR0E0v3P0G9PVovb4TPmfQMLWSpxF79f6
	xCX1YUKpjDvWhA4oZUIDTuXQM2lmI/0PwHE2AaM9MYmh4i+UswbSFPaIjLxoJQzr7DivuUYHOzI
	mn08Sxs/4xCjGWHF7Pd6GJNY7zRAtZTDiiPbli+YFvgUX8Omj8d5ubDjqeeB6uG0FQasPGSCMoM
	I5ylx3ReG6Tk6vlWwXeRKWEHXPbdZlQhhnOCKyKVuvbLBXD2gX/UaVC1sxI=
X-Received: by 2002:a05:600c:8887:b0:440:6a37:be0d with SMTP id 5b1f17b1804b1-442d6d6ac34mr142266705e9.15.1747146013765;
        Tue, 13 May 2025 07:20:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMJd0Y4ol20KqwlD/xjV97DJlvepa/eAx0yECTHw2Xv6k+BGIX3yLcJJl1tDp+QEbkSi1Nbw==
X-Received: by 2002:a05:600c:8887:b0:440:6a37:be0d with SMTP id 5b1f17b1804b1-442d6d6ac34mr142266335e9.15.1747146013344;
        Tue, 13 May 2025 07:20:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3285f9sm215246655e9.8.2025.05.13.07.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 07:20:12 -0700 (PDT)
Message-ID: <4f370fae-8234-48ca-97e2-3b7038092974@redhat.com>
Date: Tue, 13 May 2025 16:20:10 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 04/10] kvm: kvm_get_writable_id_regs
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-5-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250414163849.321857-5-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RGFi5AGHL-rqp8uOQEmJCf5cCoLsB-cuVZbFcxVr0Ps_1747146014
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Connie,

On 4/14/25 6:38 PM, Cornelia Huck wrote:
> Add an helper to retrieve the writable id reg bitmask. The
> status of the query is stored in the CPU struct so that an
> an error, if any, can be reported on vcpu realize().
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu.h     | 26 ++++++++++++++++++++++++++
>  target/arm/kvm.c     | 32 ++++++++++++++++++++++++++++++++
>  target/arm/kvm_arm.h |  7 +++++++
>  3 files changed, 65 insertions(+)
>
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index d27134f4a025..bbee7ff2414a 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -856,6 +856,26 @@ typedef struct {
>      uint32_t map, init, supported;
>  } ARMVQMap;
>  
> +typedef enum ARMIdRegsState {
> +    WRITABLE_ID_REGS_UNKNOWN,
> +    WRITABLE_ID_REGS_NOT_DISCOVERABLE,
> +    WRITABLE_ID_REGS_FAILED,
> +    WRITABLE_ID_REGS_AVAIL,
> +} ARMIdRegsState;
> +
> +/*
> + * The following structures are for the purpose of mapping the output of
> + * KVM_ARM_GET_REG_WRITABLE_MASKS that also may cover id registers we do
> + * not support in QEMU
> + * ID registers in op0==3, op1=={0,1,3}, crn=0, crm=={0-7}, op2=={0-7},
> + * as used by the KVM_ARM_GET_REG_WRITABLE_MASKS ioctl call.
> + */
> +#define NR_ID_REGS (3 * 8 * 8)
We may rename this define to better associate to the KVM API. I tend to
mix it with NUM_ID_IDX now ;-)
maybe something like KVM_NR_EXPOSED_ID_REGS
> +
> +typedef struct IdRegMap {
> +    uint64_t regs[NR_ID_REGS];
> +} IdRegMap;
I would add a comment saying this is the mask array, just to prevent the
reading from thinking it is the actual reg content.
> +
>  /* REG is ID_XXX */
>  #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
>      ({                                                                  \
> @@ -1044,6 +1064,12 @@ struct ArchCPU {
>       */
>      bool host_cpu_probe_failed;
>  
> +    /*
> +     * state of writable id regs query used to report an error, if any,
> +     * on KVM custom vcpu model realize
> +     */
> +    ARMIdRegsState writable_id_regs;
maybe rename into writable_id_reg_status that would better reflect what
it is.
> +
>      /* QOM property to indicate we should use the back-compat CNTFRQ default */
>      bool backcompat_cntfrq;
>  
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 8491f42a18d2..6e3cd06e9bc5 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -50,6 +50,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>  static bool cap_has_mp_state;
>  static bool cap_has_inject_serror_esr;
>  static bool cap_has_inject_ext_dabt;
> +static int cap_writable_id_regs;
>  
>  /**
>   * ARMHostCPUFeatures: information about the host CPU (identified
> @@ -488,6 +489,37 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>      env->features = arm_host_cpu_features.features;
>  }
>  
> +int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap)
> +{
> +    struct reg_mask_range range = {
> +        .range = 0, /* up to now only a single range is supported */
> +        .addr = (uint64_t)idregmap,
> +    };
> +    int ret;
> +
> +    if (!kvm_enabled()) {
> +        cpu->writable_id_regs = WRITABLE_ID_REGS_NOT_DISCOVERABLE;
> +        return -ENOSYS;
> +    }
> +
> +    cap_writable_id_regs =
> +        kvm_check_extension(kvm_state, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
> +
> +    if (!cap_writable_id_regs ||
> +        !(cap_writable_id_regs & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
> +        cpu->writable_id_regs = WRITABLE_ID_REGS_NOT_DISCOVERABLE;
> +        return -ENOSYS;
> +    }
> +
> +    ret = kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
> +    if (ret) {
> +        cpu->writable_id_regs = WRITABLE_ID_REGS_FAILED;
> +        return ret;
> +     }
> +    cpu->writable_id_regs = WRITABLE_ID_REGS_AVAIL;
> +    return ret;
> +}
> +
>  static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
>  {
>      return !ARM_CPU(obj)->kvm_adjvtime;
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 05c3de8cd46e..8d1f20ca8d89 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -221,6 +221,8 @@ int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level);
>  
>  void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
>  
> +int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap);
> +
>  #else
>  
>  /*
> @@ -247,6 +249,11 @@ static inline bool kvm_arm_mte_supported(void)
>      return false;
>  }
>  
> +static inline int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap)
> +{
> +    return -ENOSYS;
> +}
> +
>  /*
>   * These functions should never actually be called without KVM support.
>   */
Cheers

Eric

