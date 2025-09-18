Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8313230BF5C
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758209175; cv=none; b=KMxKd4ZMI1B2kmlv5dGh3qXJHDpNxoh0DeetDd24NSgak5wNas2Zo1mYyauTkJosPFdhq/HHmQG3QzjKJrUPzIGsvpwRRRZH2TyoTo7XLiZ43myqCcinOBYvkcVYYRSlG2dKD8CWUi2pQOFoyKmzZu4luDdTHO+EEEnexfh+Q0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758209175; c=relaxed/simple;
	bh=HgnLRXSsOYU8XaC5uGv31qfbb+RBOgrHm6h1I0Q3eXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=azF1ym+WiO7prWP5bjkYLGzg/M7kg1BA1ct8PvUpZZUYKhdXjfAWWdfuijVviLU3eI7LKPvjTmuTDe15Os1BfebIKixSsW43Inq1lxsyeQBxBDOt+jRx+HnGUDcwpAQ4z+YaVYYp+DFRCkvgCkg55qna+228V0gK2H/GSkBYhwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NwCrGLZb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NwCrGLZb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758209172;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=60bh1/8KDe5Bli2xGeThDg2WbIb0AYpA+zhbjhLgDGc=;
	b=NwCrGLZbSMB2pQRzPjOCAXltk1DHUBpviP2paCJM5Ts4O5ZTVsjzKC/SoQExCwxSFE1m7r
	O63i3QrX6mX72AAjKmeTcN74YBG5WSIeddyjlfvVaNO0u0tvVzPu/+d2bI+viz6vgeayur
	cYSAjhqiF584g5OdtYGfpMk+yr0ZKA4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-VDF4ojRgMdeWHPQcu-gJYg-1; Thu, 18 Sep 2025 11:26:11 -0400
X-MC-Unique: VDF4ojRgMdeWHPQcu-gJYg-1
X-Mimecast-MFC-AGG-ID: VDF4ojRgMdeWHPQcu-gJYg_1758209170
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45f2c41c819so7345295e9.2
        for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 08:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758209169; x=1758813969;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=60bh1/8KDe5Bli2xGeThDg2WbIb0AYpA+zhbjhLgDGc=;
        b=oKoue/2crosK/sszoI8JttlO7PL9f5Sz+ojonEqmaxPQTIj7GN9Cc1MN3oHovNILZu
         lkg0WRwaFYVWCBNUFXRjoeIHAR8xpemwJd0SW6/qn4n85lxTe+qk1yvqS5fBoF7mNWX1
         ZccHEUqY5B5PSnGJCPJKLXW2qU7XE0lDIiqR0QnMLjA1fGqsjs4wJYuCctn048DzEnlH
         wDQuG0yGf2FTVm2eFk6aSJiVxcCTral08ai0Dlq04kpR1sAjqCW8txl+zXFaQKHp8aCg
         33FrS1c8TbTZtz6DJWR5vzDBwcXyJCKpqD7rnuTEsSXML3ulxlrr7jGleQo9ZNjhbHs3
         oT/w==
X-Forwarded-Encrypted: i=1; AJvYcCUJpOpVTrf1hSWFJ02uhLqcCTTuo1EP6Rt8Bk+XMZh13BboCOxpkze3L+CsZms8a7J5UoWVV8w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yya99jE5UdiVOhTPvxAkjVUH/59FYGr7ZQ4b83i3B14WnBYuTQq
	XPIGLKxyaSgob2gsaDGQBYwU2XEKg8gO1xts6vqQprTBJ5pYiBZOyCnfFcea/PFKWS89Mnn15nK
	ezzlI+1aJ1hjeJJXT0fB+PwA9xa6C+efaiV1PH2SGNQ286+jD7Qax7WkDmQ==
X-Gm-Gg: ASbGnct3NBeIhmp3YWKr10SymVQ+RwFA60Z/n+IGKfVbHWB6KU6R3ISoWy+F7eURsw+
	9utEn4QkGW+Ingjh3YBy4YPX64CvXJPpZIA1EZGu4ETvZeLjKreAfIGwh/OLwwMVPDK7BRa9/cN
	7Qjo28YevgIJYdQvV7tbMEsHs7OhsIr8wnQGxr9ay1oxbUQlKfpxo74azOkcUXHz+zK+r+SOBM0
	V91jt52iyNiGksFIe28TJX2V+TQbUHnGqc9yqRiPY05Pn91BhhJXgD+t5gpjgdpknwEj6fIByc4
	r+Ojp+4XQB9mCYpVUUpMmKjjRzYPTn1d1Uxw7BCyzvhiYBJ/jlnm7m3TVcuVVRofvvV5Z7OVf/k
	zK08kRF2b3/8=
X-Received: by 2002:a05:600c:4eca:b0:45b:79fd:cb3d with SMTP id 5b1f17b1804b1-4634c528acamr48192855e9.36.1758209168703;
        Thu, 18 Sep 2025 08:26:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEtQw7Ad4RC9Ve+flPRrpO5OIZ1reWlCMCoXq69hJMRKQIk5PW42Rnui+NeQkSFExCkaGLOA==
X-Received: by 2002:a05:600c:4eca:b0:45b:79fd:cb3d with SMTP id 5b1f17b1804b1-4634c528acamr48192565e9.36.1758209168259;
        Thu, 18 Sep 2025 08:26:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f5d053f2sm46067075e9.20.2025.09.18.08.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 08:26:07 -0700 (PDT)
Message-ID: <22caf6ef-e1ba-4465-b587-baffb3ce4618@redhat.com>
Date: Thu, 18 Sep 2025 17:26:06 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250911144923.24259-1-sebott@redhat.com>
 <20250911144923.24259-3-sebott@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250911144923.24259-3-sebott@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qWST8DXw2_Lhyv85TceXI9wJvcoWK_-SsTHKwKIBJt4_1758209170
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 9/11/25 4:49 PM, Sebastian Ott wrote:
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  5 +++
>  target/arm/cpu.h                 |  6 +++
>  target/arm/kvm.c                 | 70 +++++++++++++++++++++++++++++++-
>  3 files changed, 80 insertions(+), 1 deletion(-)
>
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 37d5dfd15b..1d32ce0fee 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
>    the guest scheduler behavior and/or be exposed to the guest
>    userspace.
>  
> +``kvm-psci-version``
> +  Override the default (as of kernel v6.13 that would be PSCI v1.3)
> +  PSCI version emulated by the kernel. Current valid values are:
> +  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
> +
>  TCG VCPU Features
>  =================
>  
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index c15d79a106..44292aab32 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -974,6 +974,12 @@ struct ArchCPU {
>       */
>      uint32_t psci_version;
>  
> +    /*
> +     * Intermediate value used during property parsing.
> +     * Once finalized, the value should be read from psci_version.
> +     */
> +    uint32_t prop_psci_version;
> +
>      /* Current power state, access guarded by BQL */
>      ARMPSCIState power_state;
>  
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 6672344855..bc6073f395 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -483,6 +483,59 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>  
> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const char *val;
> +
> +    switch (cpu->prop_psci_version) {
> +    case QEMU_PSCI_VERSION_0_1:
> +        val = "0.1";
> +        break;
> +    case QEMU_PSCI_VERSION_0_2:
> +        val = "0.2";
> +        break;
> +    case QEMU_PSCI_VERSION_1_0:
> +        val = "1.0";
> +        break;
> +    case QEMU_PSCI_VERSION_1_1:
> +        val = "1.1";
> +        break;
> +    case QEMU_PSCI_VERSION_1_2:
> +        val = "1.2";
> +        break;
> +    case QEMU_PSCI_VERSION_1_3:
> +        val = "1.3";
> +        break;
> +    default:
> +        val = "0.2";
can you explain why you return 0.2 by default? Shouldn't we report the
default value exposed by KVM?
> +        break;
> +    }
> +    return g_strdup(val);
> +}
> +
> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    if (!strcmp(value, "0.1")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_1;
> +    } else if (!strcmp(value, "0.2")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_2;
> +    } else if (!strcmp(value, "1.0")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_0;
> +    } else if (!strcmp(value, "1.1")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_1;
> +    } else if (!strcmp(value, "1.2")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_2;
> +    } else if (!strcmp(value, "1.3")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_3;
> +    } else {
> +        error_setg(errp, "Invalid PSCI-version value");
> +        error_append_hint(errp, "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3\n");
> +    }
> +}
> +
>  /* KVM VCPU properties should be prefixed with "kvm-". */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>  {
> @@ -504,6 +557,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>                               kvm_steal_time_set);
>      object_property_set_description(obj, "kvm-steal-time",
>                                      "Set off to disable KVM steal time.");
> +
> +    object_property_add_str(obj, "kvm-psci-version", kvm_get_psci_version,
> +                            kvm_set_psci_version);
> +    object_property_set_description(obj, "kvm-psci-version",
> +                                    "Set PSCI version. "
> +                                    "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3");
>  }
>  
>  bool kvm_arm_pmu_supported(void)
> @@ -1883,7 +1942,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      if (cs->start_powered_off) {
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
>      }
> -    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
> +    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
> +        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
I don't get why this change is needed. Please can you explain?


>          cpu->psci_version = QEMU_PSCI_VERSION_0_2;
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
>      }
> @@ -1922,6 +1982,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          }
>      }
>  
> +    if (cpu->prop_psci_version) {
> +        psciver = cpu->prop_psci_version;
> +        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
> +        if (ret) {
> +            error_report("PSCI version %lx is not supported by KVM", psciver);
don't you need a PRIx64 here?
> +            return ret;
> +        }
> +    }
>      /*
>       * KVM reports the exact PSCI version it is implementing via a
>       * special sysreg. If it is present, use its contents to determine
Thanks

Eric

