Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2222B17FEB
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 11:54:22 +0000 (UTC)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so14491a12.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 04:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690804461; x=1691409261;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gz0q8+TIeyvXDOgRq+KfnkJDaIgp0/SlphpP3zWMP/E=;
        b=XRNsIN1avnppiien8YxCEWFle10nCOmQ+kwurgqaTXK0d2hjk8sJ+Ez1rQAOq3cAGX
         b/Kd3eGu49FAfCui72UHxLWSCtAf6qJDx2di4Zfl60Y14XySIsSPy8mV+P76SFt+BpLa
         eHR3EWbi1KvWolPrA9VVohRqCOM6koDVX1cOGBtK+4ThU6XoZW/v4FnWXP+OVQ25lfwI
         DmErcvzFD3HDVpRQKPSzNEc+GltK8yySRKypZw9dKIx5BHmSu0cS9vqhQuG1LoLcpD06
         TaZg0uTME4TA9uAedn2CS7DEBVPlsDhIgYO19YgP/80uUvbfqMV0RObGTudCVNhI7IwJ
         1s4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690804461; x=1691409261;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gz0q8+TIeyvXDOgRq+KfnkJDaIgp0/SlphpP3zWMP/E=;
        b=QwmPaBE6AUJGLL1/uOgi0kuzF9Q6qxOJFxel7zTWcEYSCx6sXGy8H3Vxfn48ACv9xd
         EJSwx0hu6RiAjkutkU2HOMmEldjyxy2RX7uGNTFu6MwV5gwm4Afs+97YsbdySR16ToJB
         i35CLvmoC2fLvSNfW6gczJBfGCrg0Esmh/OJfFQufSdUc4TfU1Mk6dXiMowduVPqywpK
         trLVGdqcgbw5vql45xz7MrmZSxjsBFQxtM5RSJgI/HiGWVAtRumTFy4V0nDA/83vPxIU
         AbM707GPx6izFvDkLsvISmGngz0MZvxA5XjZZTDIIlga1GIp1bY7hsOuwZvF0otUQ7Q5
         BKsg==
X-Gm-Message-State: ABy/qLb2Yi71x8mXTvENE+eFglG8d/YEPJKAJldofhPjfXa40rD0/02f
	WCCA8wt/NG56n3G+WjG+U888BiJNorGXhlik+rZmHQ==
X-Google-Smtp-Source: APBJJlH9ttptvP7TRn9A19ifvlq3YB7zBN0BwZYm9jpsOz2Ht0ztBRLCTPm1vh9MkDMgZpKHpde9CgVynyUPQZ/Yfsc=
X-Received: by 2002:a50:f69e:0:b0:522:3c11:1780 with SMTP id
 d30-20020a50f69e000000b005223c111780mr155438edn.0.1690804460991; Mon, 31 Jul
 2023 04:54:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com> <20230728181907.1759513-3-reijiw@google.com>
 <ZMQckrDB7tg9gPfw@linux.dev>
In-Reply-To: <ZMQckrDB7tg9gPfw@linux.dev>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 31 Jul 2023 04:54:04 -0700
Message-ID: <CAAeT=FyC42s=kcS3QTC6A-s6EZjhoQL7XJyxWCb5YyisJrQvdg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: PMU: Disallow vPMU on non-uniform
 PMUVer systems
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

> This doesn't actually disallow userspace from configuring a vPMU, it
> only hides the KVM cap. kvm_host_pmu_init() will still insert the host
> PMU instance in the list of valid PMUs, and there doesn't appear to be
> any check against the static key anywhere on that path.

In v6.5-rc3, which I used as the base, or even in v6.5-rc4,
it appears kvm_reset_vcpu() checks against the static key.
So, the initial KVM_ARM_VCPU_INIT with vPMU configured will
fail on the systems.  Or am I missing something ? (Or is that
going to be removed by other patches that are already queued?)

But, right, it still insert the host PMU instance in the list,
which is unnecessary.

> I actually prefer where we flip the static key, as PMU context switching
> depends on both KVM support as well as the PMU driver coming up successfully.
> Instead, you could hoist the check against the sanitised PMU version into
> kvm_host_pmu_init(), maybe something like:

Thank you, it looks better.  I will fix this in v3.

Thank you,
Reiji

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 560650972478..f6a0e558472f 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -672,8 +672,11 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
>  {
>         struct arm_pmu_entry *entry;
>
> -       if (pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_NI ||
> -           pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> +       /*
> +        * Check the sanitised PMU version for the system, as KVM does not
> +        * support implementations where PMUv3 exists on a subset of CPUs.
> +        */
> +       if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
>                 return;
>
>         mutex_lock(&arm_pmus_lock);
>
> --
> Thanks,
> Oliver
