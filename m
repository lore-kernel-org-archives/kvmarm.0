Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B961B416853
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 12:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153646; cv=none; b=PPPZDbUYtj/w5QZbPqYgossU/UTYHfZGP+1XKNs2VmSxVl3g4Fh1CvHurr8Sv1oyXkWgV6g6A03Fc5TZqHxLYrZgF4kXveHK+1cGMyaqHBdC2WeEJQbSGb20jXEtU/XWk9g3ryTTl5aGRUPGuapbBNkddDJ5/ryj+UdElGmrxYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153646; c=relaxed/simple;
	bh=iXO7kMhBQgjVYBeTU0+qd0uPZv80SkDHisGXaHkMy6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gFxXale2KiO7DYm+weJ5XpCmGA6Shvqq12IN7CANcXNh45dH+BU2z/D8jYjmTwW7aha8hIZWcSbRU5JK8wIijrIe8Ze1trVssR2Qzs6dSeOnV3ylpjTess5Fv4xstwMsqKyAw450tsG/pGL+BGHZHGhhoqsK8GBeisfPeuO2gL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BgJfdGbF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BgJfdGbF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792153643;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BlxikIztOcmCD0oPJfrv0Y7gX8E5iK379iIKvtymFhg=;
	b=BgJfdGbFkV/G5XvpM/B0DttAlh8pFxGH0bl9Mf/kxAIisumOxdriBlO4yzyciBHuu8M47V
	xV3dsFe6OP+VCP8iuEkHRiGk0duhkJo37tmFiN162+bcZEwnvN0G0ymu1eFEU0t+CANIys
	j/VLrVpOgHiyzhkdn4Yhjau8hIba9pk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-AWMz2lBpM1i-EYe00Ldl1Q-1; Fri, 16 Oct 2026 12:27:22 +0000
X-MC-Unique: AWMz2lBpM1i-EYe00Ldl1Q-1
X-Mimecast-MFC-AGG-ID: AWMz2lBpM1i-EYe00Ldl1Q_1792153641
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a1b11e7837so33085035e9.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 05:27:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792153641; x=1792758441;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BlxikIztOcmCD0oPJfrv0Y7gX8E5iK379iIKvtymFhg=;
        b=mv+fxYgzUT3AyaxLgglPPvUNmMnqrdO7HP/Vc4j+AryVLTpy0KHxmezXnmMqcItHb/
         i+eRu/1FR2KAqd6VvZL8XdYLAlHol0+J+Z2uS+pn1eq3VSaZ5DxmY9ZvsimTdjn3VYSq
         jj8h6Q4dekYoYAKzBB3IfWaNbjV6jTbKCKbRo0U7oqt6PeeWiZX4U3bYvcOamRKTWNLB
         zbB45wsBChp5IE+nRshrJtJmtXqh0xONt45QqHrOWPvx5HKTrdr5jer5wwiY+BCgmxJL
         vD0Yo0GM0yjdqrfCGDhAO9+Sf3uYRMXoHyiolkwTg+UuHRfVY8SV0xdsR/38jqzzju52
         bhiQ==
X-Forwarded-Encrypted: i=1; AKwUvBxcymfcX5dyhOMBb9zItxIkfo+pCP0Gh30CHKtjH8T3dd1yppVNiwIlHGswb5maC43zaFSqQl0=@lists.linux.dev
X-Gm-Message-State: AFq9FYLO2oaRJbdQ3yfkq2RUAC/9w2UIkqb0yb6/XiUBklhD13P8DS1i
	MnqOIOdFCE7W3pRhtP8A99BnRsHLN28UUDeQrAvcvLBahj3SUobmOC23JT77wtmPt79zJPw/QK4
	wqTEl/cxSuP/aaMvRWWWmRV5ZeiutdpnINycJdm0ZiqUzA3gn31v65/2zlw==
X-Gm-Gg: AYBFou1Uu6gqh8vKcRdHHU0Z1jBgdywZr43LOI+Pa48ktLipwFqg4NH95HElVGpCo7n
	5L0Ufa97RoZOIXUj/23fG078Ki2ly3sa0jWBdxw6km22FJJ2IR1IIdN+4xRikmzLk/qd3DocO6s
	x/ZzC74+y/VNZYDkDdLlr1R4takSvPeBGaFRdzYeUePppO8noCppOtxiA7SZvIXW0la9zF4+RbV
	yuzW9XWIsS2BPmtKsHMUYg2aSJOFhqLuLzSFW3nZbZ/EK+c0tDJhLn5Kg8YdVtAzqgxfZd/Pwf/
	HcjhfkrAk2lBvhXAy9rbAfnL5ye77G8rGnpDXA4WnlqwTLU+0XPcWGwVvDjdi2UgLuKAieHfTwB
	p3piqf2ZwytNzXnqNwvoL7ry0f91//6T1BUuwk/PBxUK2mdNF
X-Received: by 2002:a05:600c:1c10:b0:4a1:d0e4:2bc7 with SMTP id 5b1f17b1804b1-4a1d0e42e91mr30622155e9.15.1792153641095;
        Fri, 16 Oct 2026 05:27:21 -0700 (PDT)
X-Received: by 2002:a05:600c:1c10:b0:4a1:d0e4:2bc7 with SMTP id 5b1f17b1804b1-4a1d0e42e91mr30621305e9.15.1792153640583;
        Fri, 16 Oct 2026 05:27:20 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd9a8a15sm144945085e9.4.2026.10.16.05.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 05:27:20 -0700 (PDT)
Message-ID: <09800653-48cd-4cbb-a2ca-3d3cc65253f9@redhat.com>
Date: Fri, 16 Oct 2026 14:27:18 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 17/25] target/arm: fail named CPU models on unknown
 non-zero feature ID regs
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 ping@khushitshah.com, sandesh.patel@nutanix.com
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-18-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-18-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xgjrRoBtLI-KeTvccQl_qvk3708kZ5yKi9IfwiKTu8A_1792153641
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit
On 9/21/26 2:32 PM, Khushit Shah wrote:
> Named CPU models zero the ID registers QEMU knows about and then apply
> SYSREG_ properties. However, the host and KVM might expose ID
> registers that QEMU does not know about yet. In this scenario, named
this may also happen with reserved fields becoming named, no?
> CPU models might
\n
> leak host features to the guest.
>
> Part of the problem can be addressed because the Arm Architecture
> Reference Manual specifies that unused encodings in the space (op1==0,
> CRn==0, CRm=={2-7}) may be treated as RES0. This range includes all
> ID_AA64* registers.
actually the KVM writable API covers AArch64 System register space

with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
so do you mean you only check part of the space. In the positive don't we need to be more precise and check for a given opcode if it is known


>
> Error out if KVM returns a non-zero value for a register in the above
> space which QEMU does not know about yet.
>
> get_sysreg_idx() now returns -1 for encodings that are not known ID
> registers, and kvm_arm_read_sys_reg64() exposes a KVM GET_ONE_REG
> read for this probe.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/cpu-models.c  | 74 ++++++++++++++++++++++++++++++++++++++++
>  target/arm/cpu-sysregs.h |  2 +-
>  target/arm/cpu64.c       |  3 +-
>  target/arm/kvm-stub.c    |  7 ++++
>  target/arm/kvm.c         |  7 ++++
>  target/arm/kvm_arm.h     | 12 +++++++
>  6 files changed, 103 insertions(+), 2 deletions(-)
>
> diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
> index 4e92909755..855eb5ee6b 100644
> --- a/target/arm/cpu-models.c
> +++ b/target/arm/cpu-models.c
> @@ -362,6 +362,78 @@ static void reset_res1_fields(ARMCPU *cpu)
>      }
>  }
>  
> +/*
> + * From ARM ARM:
> + *
> + *     For unused encodings in the part of the space that has op1==0 and
> + *     CRm=={2-7}, direct reads that are not trapped behave as Reserved,
> + *     RES0 to ensure correct behavior if the encodings are used for ID
> + *     registers in the future.
> + *
> + * It includes every ID_AA64* register.
> + *
> + * For named CPU models, we can check if any of the unknown ID registers
> + * that fall into this space is non-zero on the host. If so, the named CPU
> + * model leaks those host features. Error out in such case.
> + *
> + * We cannot do the same for the remaining Feature ID space (op1==0 and
> + * CRm==0, or op1=={1,3}). Unused encodings there are UNDEFINED. The
> + * implemented registers in that space (MIDR_EL1, CTR_EL0, DCZID_EL0,
> + * CCSIDR_EL1, ...) are identification or cache geometry.
> + */
> +static void arm_named_cpu_zero_unknown_feature_ids(ARMCPU *cpu, Error **errp)
> +{
> +    uint32_t init_features0 = 0;
> +    static bool checked;
> +    uint32_t target;
> +    int fdarray[3];
> +    int crm, op2;
> +    int fd;
> +
> +    if (checked) {
> +        return;
> +    }
> +
> +    if (!kvm_arm_create_scratch_max_host_vcpu(fdarray, &init_features0,
> +                                              &target, errp)) {
can't we do that when we retrieve the host features on the 1st created
scratch vcpu. We shall avoid creating too many of them if possible
> +        return;
> +    }
> +
> +    fd = fdarray[2];
> +    for (crm = 2; crm <= 7; crm++) {
> +        for (op2 = 0; op2 <= 7; op2++) {
> +            uint64_t val = 0;
> +            int ret;
> +
> +            if (get_sysreg_idx(ENCODE_ID_REG(3, 0, 0, crm, op2)) != -1) {
> +                continue;
> +            }
> +
> +            ret = kvm_arm_read_sys_reg64(fd, &val, 3, 0, 0, crm, op2);
> +            if (ret) {
> +                continue;
> +            }
> +
> +            /*
> +             * TODO: if this encoding is writable, try to write 0?
> +             */
> +            if (val) {
> +                error_setg(errp,
> +                           "unknown Feature ID register "
> +                           "(op0=3, op1=0, CRn=0, CRm=%d, op2=%d) "
> +                           "reads as 0x%" PRIx64 " on the host; named CPU "
> +                           "models cannot hide it",
> +                           crm, op2, val);
> +                kvm_arm_destroy_scratch_host_vcpu(fdarray);
> +                return;
> +            }
> +        }
> +    }
> +
> +    kvm_arm_destroy_scratch_host_vcpu(fdarray);
> +    checked = true;
> +}
> +
>  static void arm_named_cpu_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> @@ -401,6 +473,8 @@ static void arm_named_cpu_initfn(Object *obj)
>  
>      /* 3. Realize the model chain. */
>      arm_realize_model_chain(obj, model, &error_abort);
> +
> +    arm_named_cpu_zero_unknown_feature_ids(cpu, &error_abort);
>  }
>  
>  void arm_register_named_cpu_models(void)
> diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
> index 7877a3b06a..d48b44705f 100644
> --- a/target/arm/cpu-sysregs.h
> +++ b/target/arm/cpu-sysregs.h
> @@ -37,6 +37,6 @@ typedef enum ARMSysRegs {
>  
>  extern const uint32_t id_register_sysreg[NUM_ID_IDX];
>  
> -int get_sysreg_idx(ARMSysRegs sysreg);
> +int get_sysreg_idx(ARMSysRegs sysreg); /* -1 if @sysreg is not a known ID register */
>  
>  #endif /* ARM_CPU_SYSREGS_H */
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index a0114b0fa2..3cc698d65a 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -57,8 +57,9 @@ int get_sysreg_idx(ARMSysRegs sysreg)
>  {
>      switch (sysreg) {
>  #include "cpu-sysregs.h.inc"
> +    default:
> +        return -1;
>      }
> -    g_assert_not_reached();
>  }
>  
>  #undef DEF
> diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
> index eae2e1ec2c..d263adc921 100644
> --- a/target/arm/kvm-stub.c
> +++ b/target/arm/kvm-stub.c
> @@ -50,6 +50,13 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>      g_assert_not_reached();
>  }
>  
> +int kvm_arm_read_sys_reg64(int fd, uint64_t *val,
> +                           uint8_t op0, uint8_t op1,
> +                           uint8_t crn, uint8_t crm, uint8_t op2)
> +{
> +    g_assert_not_reached();
> +}
> +
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>  {
>      g_assert_not_reached();
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 70d9a07580..6f704c0509 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -263,6 +263,13 @@ static int read_sys_reg64(int fd, uint64_t *pret, uint64_t id)
>      return ioctl(fd, KVM_GET_ONE_REG, &idreg);
>  }
>  
> +int kvm_arm_read_sys_reg64(int fd, uint64_t *val,
> +                           uint8_t op0, uint8_t op1,
> +                           uint8_t crn, uint8_t crm, uint8_t op2)
> +{
> +    return read_sys_reg64(fd, val, ARM64_SYS_REG(op0, op1, crn, crm, op2));
> +}
> +
>  static uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg)
>  {
>      return ARM64_SYS_REG((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >> CP_REG_ARM64_SYSREG_OP0_SHIFT,
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 997120966f..4e563fab96 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -154,6 +154,18 @@ bool kvm_arm_create_scratch_max_host_vcpu(int *fdarray,
>   */
>  void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
>  
> +/**
> + * kvm_arm_read_sys_reg64:
> + * @fd: vCPU fd
> + * @val: filled with the register value on success
> + * @op0/@op1/@crn/@crm/@op2: System ID register encoding
> + *
> + * Returns: 0 on success, -1 on failure.
> + */
> +int kvm_arm_read_sys_reg64(int fd, uint64_t *val,
> +                           uint8_t op0, uint8_t op1,
> +                           uint8_t crn, uint8_t crm, uint8_t op2);
> +
>  /**
>   * kvm_arm_add_vcpu_properties:
>   * @cpu: The CPU object to add the properties to
Thanks

Eric

