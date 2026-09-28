Received: from mail-oo2-f36.google.com (mail-oo2-f36.google.com [74.125.231.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25084D8DBD
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 14:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790604476; cv=pass; b=lx7UI+fwlM9I45jpSYougm1wr2jfyQ/2Z1DfVSzPt6Zn7FBXLUJS/019zUO/hsOlC7mfraDdbOi9YnlcpOh4T5kXq2FHfASwTE5CXdCoIrbiKHOnQ0kShae4YptrWFXXfh9mQQFts0tyV5SxDyQSXMOJB3VwwmSE0FC/aYg7Sh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790604476; c=relaxed/simple;
	bh=g/9FLDAua0C/8CqfTr7Fn8gQSHiF4d0O4k+A5Uh+fvY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p54WDmoEvc8jr/dhhe3LfnIIY3osjta144i6DuTW7YmU3GC0ktQZJ3xtryrS98SIceZx1AaL7CHX8JF0Mi9OBpP0e6Yo75szBRJxxVzC+Xdcgq5Gt8HCJFqq1Tu2LHCDP50Az/zv5TIYCbtD02U0idOK6Cif23nWaw18g87Rk3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jPJJc1+3; arc=pass smtp.client-ip=74.125.231.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jPJJc1+3"
Received: by mail-oo2-f36.google.com with SMTP id 006d021491bc7-6d77aa5735aso1026765eaf.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 07:07:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790604470; cv=none;
        d=google.com; s=arc-20260327;
        b=jDPIrNTBnR/9WXUkZywmUVaInuSEptPuVF/aecfwumZgmGaNl4st4SXs1csvAIsHDM
         eeA0Y1fqw4dyIP2eB94CVC5Re/TkiNvnlwIXQ84OBKi3/IqGNIOla3k4tVgzrtDxkSmB
         ft4vXYC+5xBDi6u2H8AMIoHdfDVu2zX4uk1E6WtuArgD9JOsmTGojT2CA6lbMYlMy2Po
         6ETS1N/MteQRqRAiph+qSR55WUj4KY8+zVLMdOGolCYcaMXz5PQ89/VqVJsrbCP7slJH
         38bjldELvsUrRvLxl/7M/kjzriz/5tOro1WEoqWyAyafyhGbbVtQ1KyY7VSKZrxpgA0E
         2LeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gVo78a/wlP80EbN8BDeCX3xsqSYxql3c+VM4RzW0dd4=;
        fh=N/KNPtvrYaLbuwAJ+rDRgPOgh4L1gguFZdezrIE+g18=;
        b=Hl+bdIJFHgeqlp5wJf/jYsUZWDdvTPAuXnqdNrLQLqo0+yrsgcrunoM6DcErqloCDg
         RlFh8Ocz/HsAdKowOs76P9nBZH+zXIfx3j3ClXhMMndFPFdzoUug5Ip6Iz9FQjhKAXBi
         fsni+lnvDaTdXzah9ps3PMbViUoRLWREzlu137GcfT5Df4sRiHa/CqGsuD2jfDz64qJx
         XHt/oG5J84d5LXJK4onnNJaq6/6ERxqkLPMfliXh2Wws18f3v3HVbcsGRaN2Tl/PalJ4
         8qFRdIOAPRdD29HQQAycJVw3ZErkN9V4Bi9TJVZNUjjb+muGNVO6gAiYAc6hrFrAJ3l6
         1H1w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1790604470; x=1791209270; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gVo78a/wlP80EbN8BDeCX3xsqSYxql3c+VM4RzW0dd4=;
        b=jPJJc1+33T7zQJ1glsO79W91hNRivAwqMh/nNUZg1HQOybVH59+Jup9EBX/RDbXpFN
         fbyHUkh1QfozZdq0rrPt/Nj+efRNoNVNx5oICBu5MQ+AN6HuCIc6J72iut1HhRNrlLyB
         /UVYZsmLf/EWX+OeNbq2/QkA270Oi26XDFcVWcc3EGYUiGvzm2d2sJXrG0i/IsP8OU0P
         +aPN8k177myzg0sQUHr9adWSIb22uGe+PmmMNcMMukX4Pf/peyyAT0xoseDleEkQfi6M
         C7VRguO161LOcY75MigKQGB6nO///9C4rqL2oqPBmc0xtZVUyp48SoIjMC3n5eKDZA+B
         J6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790604470; x=1791209270;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gVo78a/wlP80EbN8BDeCX3xsqSYxql3c+VM4RzW0dd4=;
        b=aWopKQyCTW+qmxZ9lBMc0m1e2d5EE0u+PmdhlOQgkP9PrDxKZGi3JO1v2breo7Pcjj
         Aa6/AQ17+s2jAnL6BEqo4PowABvcW2HMrTFii8kcXM5om0QBwh/LN/BPmRRIyFKE2vJJ
         vk86219/aTCf1qVXUTHIv5t8ucUFwWwgMXx0ZRoKVTTAOj4MK8sMG5tyyjwNahhDVsZt
         vlmE6kignOBvO/LFV7OXAyI2vXNgubLRWaDruTmkTir6wHv3tUqN8DOJwNRMwbPWh7xZ
         3AgspiMfUKu4KvxIM9/BNRvIzibB6RI2YZaR8JtAw7sf2lkA+sVSxsQ7nz411cfzFth4
         aoEg==
X-Forwarded-Encrypted: i=1; AKwUvByivX167r33GK8Db6m9LtfDbZcER/bnH1exXFiWkvSSJMpiBYmWVSl2GTNM6Uw1eGZJxy43mPk=@lists.linux.dev
X-Gm-Message-State: AFuF++lqkVX/78eVaKISYPSmW9aLk+6K8FHq+fMZVHZABgmBdZ4vDTbR
	+fNjmHTkRcxehRXmOA5ZqFEs3fLkUo5c3Vnsqj5XVNNe9f7/fsNzNotyDVtGdLGYZA69lil9S5d
	qBMZjmhAMU2piWc/yGrLaqWjpkt1DJdpyIQyZz89yY65XRY8ukqe1aqA=
X-Gm-Gg: AYBFou0qHpRMszCGSBFgHAGLHf/FAk6hbJeEQ2zeeUxnEIXru2GUJ2b4W+EmvxCcOYr
	yR1snSQC3w1FFQik+2rSsgKh88aiM2bbEys3DdJUjZ8ObmhFX7Vy4fJmNHBskw7IpRLi/ohIFJL
	4GBm1VgZBT3pek8yr36Pq3tMgjZijeO7lTYI7gfwxhQCAykEH1OW0asZfqZfLxsIUY6yystM2Hd
	kL18lBgcYSbOG6I7xSbD7uLn1aUVU9z5ho6b3oVTi7Ek19F7BkQdKBT+8e3JmRTBBzzl2DdgHTy
	dTPClzeZWL18AldFzpb/AyZpmmZJe7ujJLBPUYC7JygKMVCQrrsd4IkZkZo+GKtvoWsSfhXN98T
	lDdb3NyRE5J3ECtOXuwKcd3MwcjkRVarK/CrT0gw=
X-Received: by 2002:a05:690e:169e:b0:667:b503:4d2e with SMTP id
 956f58d0204a3-672ed1d4e4bmr6799180d50.37.1790604105100; Mon, 28 Sep 2026
 07:01:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com> <20260924173051.2117637-1-coltonlewis@google.com>
In-Reply-To: <20260924173051.2117637-1-coltonlewis@google.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 28 Sep 2026 15:01:32 +0100
X-Gm-Features: AclHuK-1ibztR8QVF_T1w6zQp7WvVuCy3F9mqxT4-ubotzdPTVl79C5Fj0zkGKo
Message-ID: <CAFEAcA9Rwrffx8bYiOxrtQGdg31QAz1oBm8okzpfqHZ6yK0Y7A@mail.gmail.com>
Subject: Re: [PATCH] target/arm: Enable KVM PMU partitioning and counter limit
To: Colton Lewis <coltonlewis@google.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Will Deacon <will@kernel.org>, James Clark <james.clark@linaro.org>, 
	Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 24 Sept 2026 at 18:30, Colton Lewis <coltonlewis@google.com> wrote:
>
> Add CPU properties to configure KVM ARM64 PMU counter partitioning:
> - 'pmu-partition' (bool): enables KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION
> - 'pmu-num-counters' (uint32): sets KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS
>
> When 'pmu-partition=on' and 'pmu-num-counters=N' are passed via -cpu,
> QEMU enables hardware PMU partitioning and reserves N general-purpose
> event counters for the guest prior to calling KVM_ARM_VCPU_PMU_V3_INIT.
>
> Note that this patch is an example to demonstrate the KVM ARM64 PMU
> Partitioning uAPI [1]. That is why it aborts immediately if setting the
> device attributes does not succeed.
>
> [1] https://lore.kernel.org/kvmarm/20260924172928.2110956-1-coltonlewis@google.com/
>
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

FYI for next time around, QEMU patches that depend on not-yet-accepted
kernel ABI changes should be tagged RFC, please.

> ---
>  target/arm/cpu.c | 20 ++++++++++++++++++++
>  target/arm/cpu.h |  4 ++++
>  target/arm/kvm.c | 32 ++++++++++++++++++++++++++++++++

New CPU properties should be documented in docs/system/arm/cpu-features.rst .

>  3 files changed, 56 insertions(+)
>
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index f58a1db843..7538c6a24c 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1359,6 +1359,20 @@ static bool arm_get_pmu(Object *obj, Error **errp)
>      return cpu->has_pmu;
>  }
>
> +static bool arm_get_pmu_partition(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    return cpu->kvm_pmu_partition;
> +}
> +
> +static void arm_set_pmu_partition(Object *obj, bool value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    cpu->kvm_pmu_partition = value;
> +}

If your getter/setter are only updating the struct field,
you can use a DEFINE_PROP_BOOL to avoid having to have them
(compare arm_cpu_has_el2_property etc.)

> +
>  static void arm_set_pmu(Object *obj, bool value, Error **errp)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> @@ -1604,6 +1618,12 @@ static void arm_cpu_post_init(Object *obj)
>      if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
>          cpu->has_pmu = true;
>          object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
> +        object_property_add_bool(obj, "pmu-partition",
> +                                 arm_get_pmu_partition,
> +                                 arm_set_pmu_partition);
> +        object_property_add_uint32_ptr(obj, "pmu-num-counters",
> +                                       &cpu->kvm_pmu_nr_counters,
> +                                       OBJ_PROP_FLAG_READWRITE);

What should we do with these properties if we're not using KVM
(i.e. for TCG, hvf, etc) ?

thanks
-- PMM
