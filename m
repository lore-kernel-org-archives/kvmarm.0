Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A428346A0C
	for <kvmarm@lists.linux.dev>; Fri,  6 Feb 2026 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770389968; cv=pass; b=qYQk184/hfYE6BfTDcLv7dTVoZpj0Yufr0TxRwc4ZHjUw0HKoSZIPhqSVDBx2wNNvLOOckiKpUqcJ2ruvDVX/YAWM6OgxpE1e8cUUdumXezadCtfr3Yk7is3bWfqjVZpLqAcoBrTyrjMoSYL+N3Q9VQhDP22vPAcArfWINXU4e8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770389968; c=relaxed/simple;
	bh=Mkat1e2fn8fcmAPT5kCb34RZtRGfdOtY9PSHDy/Ep9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F4ty9fYIyuUS/t3P9f2feSCU7oG0mmspejakwxkQ70x+rMO07pKamGNo9CoRETan1ax+w8WhtjpbVqU+8IPD+rM+RH0QsquwxG/aTiKlzdcRYZE0vqWvg03zq633KN+YwEV/LePz35BXId1TWYt2rV2I5huTbatRIp2TC6DUsXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wUstZNGN; arc=pass smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wUstZNGN"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-795176156b1so9620397b3.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Feb 2026 06:59:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770389967; cv=none;
        d=google.com; s=arc-20240605;
        b=lwlqXCTENj+XK1UvfzbNZwYsS3sYAAMLedw4+/4GN3BGnAlWo2ag8AyHLoRIdqFdlP
         +UbZtPbt0W/H9ohm+G6h3Ke+UytB+ccVLwDoORAP62BnU6sS2GzF8RkrLGABMKdYEsX2
         LagB05OPlg4SWYLeqRDQ+wHuq09G4/aZymecwohhf7vYnzn8Nw2MsPWMdOwJJUtOsaq4
         sz7lxanl/0kX+X+0VfPqKInjGn2sCVTWFtImSBcu4giXuEjC/ynof9GFR4IxOxlILWEJ
         lEzro83S2thdTrEbROK/UrQCm0WVJAKQFf5/8cNF/i/rHn4bEkDKa2IHfyI1N3/L5/9q
         hVWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Djjd+78eL/gLTndXMnYafFf7JN6pIz42e4sPAJ7o4XM=;
        fh=Zi3IBclsd1CpRVnmqy1EO4+ZRMrRAwMPEe3M2e/1XGs=;
        b=AH82lYf9zzzKVefQXHX2Obb8oAbHDiAOgk6ihk5ScdsiI7HGh+JNGNEwnB/dLjs+an
         w0wNN56g8gkWjk5AHND0G9y1c2IZ/1+b0v0j1EwiXlrdQkLmBi1BZ6QgR2TghCKTw5q1
         ez/Kz0MNdyJu0y8Yt4AOSRXjeipivHEQt/6Nwlnjg3RyEHIpcXE9KKq83dMYPgxuXdSI
         5sv2BfMtzFkdNpJF60fGeAGRmecCw/JB65eoJtCHfJcH1NPkdmOlTKe2wbBAu5qD0hLJ
         7qHU2UW3PJ/iInGgb9SQ90KKjXpKWyOAX1smnfzVDJh7rEa4tMnajvbtOZ779ZkNREbP
         XZpA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770389967; x=1770994767; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Djjd+78eL/gLTndXMnYafFf7JN6pIz42e4sPAJ7o4XM=;
        b=wUstZNGNJcmFRyC13FChoMCHvdgnsiiThuPED9LsIFFBuOg4x827yzppjG80bP2cY2
         /yR4asNPAGNyQGbjCnrWTTyLL/D64V3g+T152A2r6e25+ryPOEUC2y9B2fHuw8AupyAV
         cd1rcBoWekLRQeSwG09HrIqJjHRzhvW680oPZ6Xvl4llLz5VaLdNm9V5hHRn6cEfUiqf
         QBM5yAls22L5EKDU7q/LM/GFwHpi63w4gjIN+4Og1rxLyyyYlSswUhTRDt7yFNMz+IJc
         ZDP9VLp5Ol3rYflm00my89Hj7JuVxme8HhsSIaXKnOp/U8/Au3rt605/qGyAR+tc9Vu3
         KQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770389967; x=1770994767;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Djjd+78eL/gLTndXMnYafFf7JN6pIz42e4sPAJ7o4XM=;
        b=XLsga5WIEuZ/pCPctpFCg2Eh3CL+4FVpG2qaX+jBuNtmwPvjfT+x/d8s4bRWhV0kL8
         H3MZCvLq3+rjEFtYhRIz6Ih3VCSrQQZlv+0A3YzIDgEh1dl0IOwyXn+hu30Z3JqDbEFG
         zKVZckt4amaRMMZSV/AKn8AOtpoADz270qk6+jzlgXyn/egjViS2+Eq2G+SChzvMpzl/
         nLAcSL1URDAKk7vgTrbtFP1zQcyA2CRitlfveEQmT+7rQr4yQLPc+TE0Bocx5Fa58knS
         /CZVTFBn0wcz2DvTCkcYkpbbg56mik6HAN/+4nC9lTGiO1UbJPqn6dQLArvvF9jO+7SG
         XiuA==
X-Forwarded-Encrypted: i=1; AJvYcCXbSHtyrEoYr1ShEueHsTEnpx0BEzQyDHUL18dS1QXf4FeJrr5+MRZml8KJ5n6b2jNCHxlLKDg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjuV+2eI1QSnJfuf/hXQgzYZeqDxEDvCxrc/4SXjt02wZsbv//
	cY7xQ+rWO+iPhDbtoB5OKtibemZQaIwY3Puo3zETDfe+0EO8A/SZlDsdAiinZqcR8LtSgdujjAc
	Xh4h4iZajm0/5He/gDkPQDlTgfeyTuliCkuCNyBRZaQ==
X-Gm-Gg: AZuq6aKIVj9obIpndv/h5JR1IWZQojg0Vv1XvsH6ZtyqSUrdpKaTK665WrAgvBO+v/x
	YrRJg2XH5uXzaILfLFY85tuBJeTwdQ34TE4Yvl3YjLntrcAOtOUy+NwY0uXFX+/B2tPkSzLNPuy
	/Wmc4at6P5C7PhBtPfeZla5lfxq/l8cEn7jir1tveCPt9VuP8eSub5n0b+TYbDG2yzW0tIo1q8Q
	+daeVTMgFZZYQFfFzOScNCnbi6deAo20vkQBkuLe3i7aIEq0cwNg3mBOS2ujxYAk+dj2TA/OJYv
	HWcy4RHJA4KTopkX+8IFa7BlGl+USk5gFj/3Le5HQjXPfWqrCQYqCLk=
X-Received: by 2002:a05:690c:88a:b0:796:2976:a452 with SMTP id
 00721157ae682-7962976ac35mr4095557b3.23.1770389966783; Fri, 06 Feb 2026
 06:59:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com>
In-Reply-To: <20251202160853.22560-3-sebott@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 6 Feb 2026 14:59:14 +0000
X-Gm-Features: AZwV_QgieJzeeTFJCFpBW88yIXQg35x305xf0x9-4d4AF9icH8OLR1uAx6S_ojM
Message-ID: <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:
>
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  5 +++
>  target/arm/cpu.h                 |  6 +++
>  target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>  3 files changed, 74 insertions(+), 1 deletion(-)

Hi; this patch seems generally reasonable to me as a way to handle
this kind of "control" register; for more discussion I wrote a
longer email in reply to Eric's series handling other kinds of
migration failure:
https://lore.kernel.org/qemu-devel/CAFEAcA-gi42JObOjLuPudABX8WRdWf5SzSbkzU-bd06ecF1Vog@mail.gmail.com/T/#me03ebff8dbd8f58189cd98c3a21812781693277e

Unless discussion in that thread reveals that we have so many of
this kind of "control" knob that we would prefer a generic
solution rather than per-knob user-friendly names and values,
I'm OK with taking this patch without completely resolving the
design discussion on that other series first.

My review comments below are fairly minor, and patch 1 of
this series has already been applied upstream now.

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

I think we could be a little more detailed here.


``kvm-psci-version``

  Set the Power State Coordination Interface (PSCI) firmware ABI version
  that KVM provides to the guest. By default KVM will use the newest
  version that it knows about (which is PSCI v1.3 in Linux v6.13).

  You only need to set this if you want to be able to migrate this
  VM to a host machine running an older kernel that does not
  recognize the PSCI version that this host's kernel defaults to.

  Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3.


> +
>  TCG VCPU Features
>  =================
>
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 39f2b2e54d..e2b6b587ea 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -1035,6 +1035,12 @@ struct ArchCPU {
>      bool kvm_vtime_dirty;
>      uint64_t kvm_vtime;
>
> +    /*
> +     * Intermediate value used during property parsing.
> +     * Once finalized, the value should be read from psci_version.
> +     */
> +    uint32_t kvm_prop_psci_version;
> +
>      /* KVM steal time */
>      OnOffAuto kvm_steal_time;
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 0d57081e69..cf2de87287 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>
> +struct psci_version {

Nit: our coding style says struct type names should be in
CamelCase, and structs should have a typedef rather than
being used as "struct foo".

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

Using ARRAY_SIZE() to set the loop bound is nicer than requiring
a sentinel value at the end of the array.

> +        if (ver->number == cpu->psci_version)
> +            return g_strdup(ver->str);
> +    }
> +
> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);

Is this ever possible?

> +}
> +
> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const struct psci_version *ver;
> +
> +    for (ver = psci_versions; ver->number != -1; ver++) {
> +        if (!strcmp(value, ver->str)) {
> +            cpu->kvm_prop_psci_version = ver->number;
> +            return;
> +        }
> +    }
> +
> +    error_setg(errp, "Invalid PSCI-version value");

"PSCI version".

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
> @@ -1959,7 +2008,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      if (cs->start_powered_off) {
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
>      }
> -    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
> +    if (cpu->kvm_prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
> +        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
> +        /*
> +         * Versions >= v0.2 are backward compatible with v0.2
> +         * omit the feature flag for v0.1 .
> +         */
>          cpu->psci_version = QEMU_PSCI_VERSION_0_2;
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
>      }
> @@ -1998,6 +2052,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          }
>      }
>
> +    if (cpu->kvm_prop_psci_version) {
> +        psciver = cpu->kvm_prop_psci_version;
> +        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
> +        if (ret) {
> +            error_report("PSCI version %"PRIx64" is not supported by KVM", psciver);

Could we make the PSCI version human-readable rather than hex here?
If hex, we need the leading 0x.

We can also suggest to the user the solution to this problem:

  error_report("KVM in this kernel does not support PSCI version 0x%" PRIx64 ");
  error_printf("Consider setting the kvm-psci-version property on the
migration source.\n")

(watch out that error_report() strings end without a trailing \n
but error_printf() ones must have a \n.)

thanks
-- PMM
