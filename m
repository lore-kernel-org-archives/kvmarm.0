Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59DD39A80E
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 14:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771943691; cv=pass; b=qDNtQ2G3DWFWIS99Jb5AzMKCKuol74pHRdrbC5FfXqTFv4C0E50kU6+MtQYgfiskb15PQPdbdM/e67i3QxjxFwCF0Hau+YhzCLEsOIXHI7PfxUiMuXbuPreDgMZS4GVBocaczuGymCzXjNHPGpasxKCr4+NtMmBH79pSGL/psDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771943691; c=relaxed/simple;
	bh=LQS9s54PGR0RH5bznKavqJ+ILVh4MiTnEjfub296dow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PFNi3Vc4RwYlmE6j62+LRkbprK9OLCkZgv+drGwbUaHC+vdAMx4HfGy1QvB6+d67RSk4c41AIfdPvwL5Vr8VEadUQ05pxTfrzo0cpQkIlr4ySjjfHVA0QOUKqtITUqzC+kaZ75K+1kMFmBm9FeV72wvVXQGrWaMDDBtAdpdk7fE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qmoRiq+u; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qmoRiq+u"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-64ad79dfb6eso5480326d50.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 06:34:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771943689; cv=none;
        d=google.com; s=arc-20240605;
        b=YcoujcvG7tQsnS5oBPj55/91bKfupfIe1mwj9jYwP1iyJ0UURdz9MxLfugsckftQfU
         /2Jrlj+wl02Z7u+6Jk8ayqhkMGaao8Egk7+rYdNbPGQVWs331KJBEpQNKfbngqG7oGbN
         ccpAaFsFMceOS5Z72QNfMEOal4KsaG5jxcQSzth9HGoJnmLLiz+vV6MWAgHkQWFl3Spx
         eJs0lLcgdxQ/m+rNiD55xr4FFCKa4YSceJnE+hZf6CP/8zS5uzNnKOuZIRJub443bvFN
         j5WA5pbjdlYm/N1HouHx0ckKZv3OeHll65/rKI5sZg94g9wUXcqCEnektV8y1pCBRluQ
         GPIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=aflH0qDkgG4fC1sHybb7ibjojgZXGjJ7kgR08XJSBto=;
        fh=LBybSM6JyT8aGWLgk3XFn491F2MRww83vZm2SFQcCV8=;
        b=jwjvmbXXBBHjYPmWPJbGSCcZ2cq3gG5MhMNKFCg1OMMv1KIsHyzaHMGto6Je/gBoCT
         J3nVwvmIlf+4b5x4E8O+ahQ0pwqi+UKz/0VHaVvns7i+HcvV+regFqe3Aqufwx8dUsnO
         4SQDgOHJLGe0XP4/SaZVSEskSR57tngT1fZmIXfzAf4H1HkKPSlQ5lzL8Fw1j0//2rH9
         DvFRU4wvHQsJS8oLw4Z/W8PCl+ePiy3g+sm+1H/WY9hfT1weSrDXPlNigxqov4G07avl
         Ta4QsS406GfkZlIL+bcpR6cMBxic8nBwbVTCvVd9ERDHiRFDIN56EBv8gNe8aAmDot3e
         VWNA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771943689; x=1772548489; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aflH0qDkgG4fC1sHybb7ibjojgZXGjJ7kgR08XJSBto=;
        b=qmoRiq+uNpbLLtNX9bkvWQ+N43cJc5AvX+kXOCWxrw4SquWL4dw7+QlcXJLoC+uLeB
         3N3eV8gw1oK/jlnLdbqetKOX+qKP6lzIbLxfxGoAF8FhMP5u5fxP26roBoTdM0JC06rg
         tYVR6t8dcdAVLZrycmStVPbnmhRbKGQP6zzg+kOmXGT3n8WlqOYSpZ8bNM0LSu4Sry3w
         EUw3denNPJpEcNw1TU6AP9uDwCGceDbspQbFdTS0/7Tru/js6KSPJLB6ZEK4Eabz4byS
         xxKTTqrL5HhA6lHm92QZU0HL6KWQJJ51ugNSwCG3wotfNg2Pfv/6GQ3gRVO4cvSM8lns
         HyDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771943689; x=1772548489;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aflH0qDkgG4fC1sHybb7ibjojgZXGjJ7kgR08XJSBto=;
        b=DPsTOwJwIevLzdajwz2bglYCTb1GbeAZztSB6FisvL4erN9yCJcl3x9JNkfu9Douo2
         WEskBSkPWPcqC+qMhxUicGIEiljVWLJH/cZcDpF0TEYguuoWXYOHhbtK8cqv4clMpabS
         urXzYj1bhST957VADVw8wnmKgP4xTy4iGPoHgbn3QhNUc7UzDVqCP2xrePciDXe/us6l
         11HB7XepFuz1Bazr84Agc6w6k8ig+hx0V5Syh4Nf+j2jF3q1+4Sfc4lqm9arXywIQUnk
         tm3Y9QojokGSn7gXU7kfwJ08pN8wljz6QBxvv5+SsGWogDd09WPjzfsFWCFUfkxwJZEi
         e4jg==
X-Forwarded-Encrypted: i=1; AJvYcCWrnrjON3ZbFp6Lr20JL+by1vVdPtIecdJS8ff8BKNUMov6EFybzDiHCCvXWuFGGHk6rOPP32w=@lists.linux.dev
X-Gm-Message-State: AOJu0YzR7NCLQhe+e2mhPno23Zx1/4Celi9YUtswAbx7SviLoM7ZVGr6
	HKverKjp+/S/451LEF073sqttDO4jrn+hNB8mOkXmW5hd+rB7H1VJITXLcQylrrmIODE+IRMOt3
	8on0T8I4NOcbRMa+XEjyirkjVQf0sS7d+UENuRFV6Qw==
X-Gm-Gg: ATEYQzzglCfwT/pJl4oCc2m9MyuLgToBBSTnU0EBdIpMxC6lIHw+FUha02E0TD8Za5n
	VN8m+hH5On5Br61kcq8eCevwjiaoIIvvjGsncQdG3Vtpa3xyDKffO7JxiBy60lb5sTCymwXJHIQ
	mszGbLOiYNz95u7vxXBgZMGW9++hU9pDybOvD5wcbahUfLHGhOF1gYrx0ReM3Cjugpgl9YLybR3
	DXUuSJ6I7bb6Nn9R+5jIjFTS+5kfZpWdri7l7mGJmq1XchvLGTvPkD+3JMgUNZ5oJT9J4Uhzmxs
	BvwpRMMBwypSNhpllzdOIeGGv96w6a425dP6PI2wBnHK8g8UCx/QmDD7HlI2V0AOTAg=
X-Received: by 2002:a05:690e:dc2:b0:64a:d9f5:d412 with SMTP id
 956f58d0204a3-64c78c1054cmr9104750d50.43.1771943688633; Tue, 24 Feb 2026
 06:34:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260220115656.4831-1-sebott@redhat.com> <20260220115656.4831-2-sebott@redhat.com>
In-Reply-To: <20260220115656.4831-2-sebott@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 24 Feb 2026 14:34:37 +0000
X-Gm-Features: AaiRm515uOhz39gYNVWQiyM_zHuBmfxeUElFEXao9Pe5eZx0PQvwmWIjvVpaqkY
Message-ID: <CAFEAcA8O2UEKToJ+zXA6=vvgkRyPKrPwtfHnti7yyGgCGwoJeA@mail.gmail.com>
Subject: Re: [PATCH v6 1/1] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: qemu-devel@nongnu.org, eric.auger@redhat.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, qemu-arm@nongnu.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 20 Feb 2026 at 11:57, Sebastian Ott <sebott@redhat.com> wrote:
>
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Tested-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst | 11 ++++++++
>  target/arm/cpu.c                 |  8 +++++-
>  target/arm/kvm.c                 | 48 ++++++++++++++++++++++++++++++--
>  3 files changed, 64 insertions(+), 3 deletions(-)
>
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 3db1f19401..ce19ae6a04 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,17 @@ the list of KVM VCPU features and their descriptions.
>    the guest scheduler behavior and/or be exposed to the guest
>    userspace.
>
> +``kvm-psci-version``
> +  Set the Power State Coordination Interface (PSCI) firmware ABI version
> +  that KVM provides to the guest. By default KVM will use the newest
> +  version that it knows about (which is PSCI v1.3 in Linux v6.13).
> +
> +  You only need to set this if you want to be able to migrate this
> +  VM to a host machine running an older kernel that does not
> +  recognize the PSCI version that this host's kernel defaults to.
> +
> +  Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3.
> +
>  TCG VCPU Features
>  =================
>
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 10f8280eef..60f391651d 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1144,7 +1144,13 @@ static void arm_cpu_initfn(Object *obj)
>       * picky DTB consumer will also provide a helpful error message.
>       */
>      cpu->dtb_compatible = "qemu,unknown";
> -    cpu->psci_version = QEMU_PSCI_VERSION_0_1; /* By default assume PSCI v0.1 */
> +    if (!kvm_enabled()) {
> +        /* By default KVM will use the newest PSCI version that it knows about.
> +         * This can be changed using the kvm-psci-version property.
> +         * For others assume PSCI v0.1 by default.
> +         */
> +        cpu->psci_version = QEMU_PSCI_VERSION_0_1;
> +    }
>      cpu->kvm_target = QEMU_KVM_ARM_TARGET_NONE;
>
>      if (tcg_enabled() || hvf_enabled()) {
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index ded582e0da..5453460965 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -485,6 +485,28 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>
> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    return g_strdup_printf("%d.%d",
> +                           (int) PSCI_VERSION_MAJOR(cpu->psci_version),
> +                           (int) PSCI_VERSION_MINOR(cpu->psci_version));
> +}
> +
> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    uint16_t maj, min;
> +
> +    if (sscanf(value, "%hd.%hd", &maj, &min) != 2) {

%hd is a signed value, so this will accept "-3.-5" I think ?
Probably we want %hu.

(If you agree I can just make this fix locally, no need for you to respin.)

-- PMM
