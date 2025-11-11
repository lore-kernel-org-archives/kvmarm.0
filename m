Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB143A1D06
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762883879; cv=none; b=ddWyv5U9//qG+h4LgLWtEG9VH8IG5I1z+6YTNJWTvHCcI0VTgePK1oqQ5l6nn3UfAA643taDnHMuGAzjBAqKwibk09nzzMomSlj+O/76UL52ZIKBAOyBtFvmmvj4jaFdm/1SwaM4kjJSHSTVo15mE1nvWr6JVSY3Lej4OUFaV48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762883879; c=relaxed/simple;
	bh=Ua18poE0n61krzU4ifKvt7+6Dr5IAwrjucPZPapN7G8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+Qu8RyqqXsSVv3JjYEapyPJgVLyrXZMVXWzErZ9blLemLNCZJvtI5WbY0rebB+0RxVoD7uKp3Y1dNtNS1DTX+VHT9dPljxhftO0fqQe3E9e98zxuOUZN7rj33dvh+3fPltSuv4plXWMPFuJ9fEaXA/32h1h5oiUEwUrAnCPAEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HWl9CdVM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HWl9CdVM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762883874;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lgu0Ck5YyznAWG1i65dblATGVHtQNlg1aO/WGnU5EJc=;
	b=HWl9CdVM8O7fOQhQDhumldLFDD/dl3Px1ymvUDUyI8StkZ47u5R93CPIpU71Wdl5tnbIVQ
	JCZD46AJCGj3gyzowRUTlXK5vxt1FR6X9gs24vHtFQvgwmUCjUjS80Hs0vfgkqWwgtNFkq
	YS4dhtrxpd5zbRaID6wXDzBmvNfpAmA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-IRBd4MLaP0uk2bEbuYflLg-1; Tue, 11 Nov 2025 12:57:51 -0500
X-MC-Unique: IRBd4MLaP0uk2bEbuYflLg-1
X-Mimecast-MFC-AGG-ID: IRBd4MLaP0uk2bEbuYflLg_1762883871
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ed6855557aso26000831cf.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 09:57:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762883871; x=1763488671;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lgu0Ck5YyznAWG1i65dblATGVHtQNlg1aO/WGnU5EJc=;
        b=EjoDis4XtM4vmjX4M2ephnBHa0xskUXZV4MN+v8fH47L5L6KwBIePDalAGLc/xialy
         KsPP8+TppO2lXmSuH6nwzaMEV6wICWzqY3qGzFPrr9moWYjU21Fjobpgb8VfY/fN5AJA
         MP9GHjLt11gZx2N9oLThDRkRxBaArB3ngaDmQMhKrsEBX1AEh/3WSIEvAMiFckVPxCQN
         sup8MUTQOTEz9XUuUSv5f6pCv9ksPUGwERMeEeMjOAlyZ0sJM43XM8UH+w+4OOZKbTlU
         1L2+wrj6ftaNnoRYl+xvmPEGWQmc2FZe/93yhIwVXOWBx2EiCzsZIiNYfThH6aIMQDCM
         7WXw==
X-Forwarded-Encrypted: i=1; AJvYcCWhTSxE9ZrHHCTQl9ZQfrWGFffOZGd9wCiIeSil5kqhVlVZBDDQ6NOkiL/CAzTZCNkOCSUxAR0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4dMTBwyKT+P5c3I7AHBvE2QK1qzabaULDWx5i6oostuuEwXtS
	nskrk1SNrAf07uxkVetgDM/MiX1S7uuFfRCrdV4gt5/mkns+clYdHWzDkEvmnxaxv9XE8U1b/0b
	cdr/LaCuZUhNZ4Qk+2AmSEj0hxM62RaPJWDU9w0tIu5tfywa7VUObThIjDg==
X-Gm-Gg: ASbGncskp/P+886U/qSimVbE86ury9DuF9gb69KbBn4QkmmnlSN7t3evsfhNGwrVP2z
	qNJWdPr6AViMUCfoWVSaMCpobGFJiwHYBRtXPkHoCC1mMBdxGCOt2VgiXXHrjZ//whltfoaDvAo
	rYmv8zF+7oDXwnsNInObWh66JPZZE+N7VqGah5LN1Yx1EFkvXbLkb6UZly75dJBZ81Fk1ppD6rl
	gknFW59d0wb6qwXS7Kp+po2OJjUnKN6LljqU7Vsg+qVZGItrnPkT+wxYQzO2LL4uO02s5wHOQ/p
	qDH02VWF2WH+w36fUXib/cmxhktWwfjjcfAUB+ItApMpyObH5g16t/BaLt0JPuPve+6kl6HSNDL
	nrnraEeexiQqT2WZhrx6NuMb9qcbEuIulDb+oxuDtAiIA6ZAMK9JZgZwr
X-Received: by 2002:a05:622a:188d:b0:4ed:1ccb:e604 with SMTP id d75a77b69052e-4eddb82b388mr2963221cf.11.1762883870999;
        Tue, 11 Nov 2025 09:57:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgy8Y2ETN6jhMS8VG62OyFcw269nFSuIGAcybI6nZ8cge2kSlujkUzY+J9XzGPpFYAEfeCTQ==
X-Received: by 2002:a05:622a:188d:b0:4ed:1ccb:e604 with SMTP id d75a77b69052e-4eddb82b388mr2962891cf.11.1762883870608;
        Tue, 11 Nov 2025 09:57:50 -0800 (PST)
Received: from [10.188.251.182] (cust-east-par-46-193-65-163.cust.wifirst.net. [46.193.65.163])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda5956968sm71729391cf.6.2025.11.11.09.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 09:57:50 -0800 (PST)
Message-ID: <0795ff4a-50d1-4b2d-84bf-e1bc9da11ba6@redhat.com>
Date: Tue, 11 Nov 2025 18:57:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251030165905.73295-1-sebott@redhat.com>
 <20251030165905.73295-3-sebott@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20251030165905.73295-3-sebott@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nz-N3NuUpP0Or0zAt7QfbvrX6RNRByq37MXUn74oYdo_1762883871
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/30/25 5:59 PM, Sebastian Ott wrote:
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  5 +++
>  target/arm/cpu.h                 |  6 ++++
>  target/arm/kvm.c                 | 60 +++++++++++++++++++++++++++++++-
>  3 files changed, 70 insertions(+), 1 deletion(-)
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
> index 39f2b2e54d..c2032070b7 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -981,6 +981,12 @@ struct ArchCPU {
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
> index 0d57081e69..c53b307b76 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>  
> +struct psci_version {
> +    uint32_t number;
> +    const char *str;
> +};
> +
> +static const struct psci_version psci_versions[] = {
> +    { QEMU_PSCI_VERSION_0_1, "0.1" },
> +    { QEMU_PSCI_VERSION_0_2, "0.2" },
> +    { QEMU_PSCI_VERSION_1_0, "1.0" },
> +    { QEMU_PSCI_VERSION_1_1, "1.1" },
> +    { QEMU_PSCI_VERSION_1_2, "1.2" },
> +    { QEMU_PSCI_VERSION_1_3, "1.3" },
> +    { -1, NULL },
> +};
> +
> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const struct psci_version *ver;
> +
> +    for (ver = psci_versions; ver->number != -1; ver++) {
> +        if (ver->number == cpu->prop_psci_version)
I still have the same question/comment as on v1. In case the end user
does not override the psci version I think you want to return the
default value, retrieved from KVM through KVM_REG_ARM_PSCI_VERSION and
which populates cpu->psci_version. So to me you should use
cpu->psci_version instead

> +            return g_strdup(ver->str);
> +    }
> +
> +    g_assert_not_reached();
> +}
> +
> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const struct psci_version *ver;
> +
> +    for (ver = psci_versions; ver->number != -1; ver++) {
> +        if (!strcmp(value, ver->str)) {
> +            cpu->prop_psci_version = ver->number;
> +            return;
> +        }
> +    }
> +
> +    error_setg(errp, "Invalid PSCI-version value");
> +}
> +
>  /* KVM VCPU properties should be prefixed with "kvm-". */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>  {
> @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
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
> @@ -1959,7 +2008,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      if (cs->start_powered_off) {
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
>      }
> -    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
> +    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
I don't understand what this change stands for. Please document it
through both a comment and a commit msg explanation

Thanks

Eric
> +        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
>          cpu->psci_version = QEMU_PSCI_VERSION_0_2;
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
>      }
> @@ -1998,6 +2048,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          }
>      }
>  
> +    if (cpu->prop_psci_version) {
> +        psciver = cpu->prop_psci_version;
> +        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
> +        if (ret) {
> +            error_report("PSCI version %"PRIx64" is not supported by KVM", psciver);
> +            return ret;
> +        }
> +    }
>      /*
>       * KVM reports the exact PSCI version it is implementing via a
>       * special sysreg. If it is present, use its contents to determine

