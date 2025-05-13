Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5881D555
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 15:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747148950; cv=none; b=nf3c5Fphp9Zon7gRtKI+VVGPTWCV54un8rOJj2Bd5ftoMtPi2xiZA2qTf+sbikxQwBpxsYXUEfTQVFDhDauijvtidb6Glcnit75C6ZBY4lnifTY/ido0N2KnH3u5ccAB7VNbPO8aU2e/e6HCo3xevV4qn4eNoq9T6kdI0GuC6Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747148950; c=relaxed/simple;
	bh=6mk1hotmqVKU6SwEnuxoH9Pj7Z2MV7cYoKM3p2xLpAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sZ7Ha3lNV/i8uBWdig2pXoICl/bzfNQYL3+Qnq7WM0N25U+9OTBXQroouNWuq6efwSyVswGY8MMo2/PVNZGynt0uHLX4ArsHAYDLdmznJA5Lqrk10pPGF0eqFs7DIsYIiV234chab4fFzzRGY1cYdOiRiuWDrkoCv7y/+iKF4WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yrvm6Z+O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yrvm6Z+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747148947;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tsf45tDGJpQUW9ECsgv4qDKfMcOicJK49979YGwTnvk=;
	b=Yrvm6Z+ObhwB3gsARIaS/v7TZrbLvUxO/ZiI/G9MkXmfE13TXvTU1ToK3ZIBUhkllA7xNu
	5wgp/Jmzpqeq3J8bN0cSICdp2gnJNhbaPdXGoQq4KRTxlL0Xz5X+9Fs6KC8k8b+hTKxPsD
	x0xuvTLJkgrbMnZ+fA5f2jI/nMkdb+Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-TiSJhp--P6GFS0sP9YeJ0A-1; Tue, 13 May 2025 11:09:06 -0400
X-MC-Unique: TiSJhp--P6GFS0sP9YeJ0A-1
X-Mimecast-MFC-AGG-ID: TiSJhp--P6GFS0sP9YeJ0A_1747148945
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-442ccf0eb4eso42536375e9.1
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 08:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747148945; x=1747753745;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tsf45tDGJpQUW9ECsgv4qDKfMcOicJK49979YGwTnvk=;
        b=iscp0+8SxnJmXKghZtdchLPUrWH2kny+dWntfwN4QwK2wCrBRszSOWcVc8/NEvuahy
         BzHR3PDD+Jhyrz3C6KOWn1EypKHWE0xpheZt7KVSgJNXGHFmJROBdenQfXEGZj2dKRU4
         Wm5AiVa8eeKu3BA9sajz87tb1iUAtHhg73qA/2FZGRYj4wtOA3cW8r0q0RKXgwv5EM6z
         Bl4c/hNj04/fEXuWlKje/vgu35Aqwveo+c0GnKyCWOiRbYHmfRonVlq3Id/n1aHcyo4o
         5DqQlXk2tJU98Wv5ipPL3n90F2T/165D0IjyAwvSYuUOC+sT7BaOCCkuwSaDaZlt4eJv
         LONw==
X-Forwarded-Encrypted: i=1; AJvYcCUqAg9BWEY9beBI86FlqTqSYWtZYeS3BdIyb+rUle72wNgkrFFDgc4JrdV/gzP5V3BUxeLM2YE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHURC9HgwuZJebjncXQJTt3cFuRFBLLhZ+xqtkhke+nsiSmJOL
	Mvp0pBoWTuVkugZCuLA34yERCLdKSTyjmDPqCIKY4KAh0GTEn6b9VqoByMP7agStBh1NKOpI51v
	QwoAFS6vQle7nurkOqNHO1lzHxvWskp1VZCORe2EAeYzaFY+aBNUazQ==
X-Gm-Gg: ASbGncv/pPZlQMLpd2BB0YjnsVYMs0X6lpn23AqfFnGslJOKPpi2BIdO2OCRsKM0pIc
	6Iiags+YVbSf6q+XdDr7LQ85D3fuLGVub1F4Dv71YeJNzYNn3yK3to91C/CjBIIiUNVM5wdEGCf
	Tlurdh/z64fyDTvWVGtF97jmhfTLTIvKiLva2TdbeAFzn9wlHECVfZmZvZRX2y//wjduGUfjidu
	nVYjauMY5s296B4AMUvMVGqx3RyiZmRxwmwD7Dq8+LJP/Tid1irw5P2GdmUOR4MaTwI8YC6YB7z
	+ALor+uWLZ+X82udF45Kvhug+9iwQkhLxUmQSWD+zoWEECeLxEQDl36FOik=
X-Received: by 2002:a05:600c:384a:b0:43c:ea36:9840 with SMTP id 5b1f17b1804b1-442d6dd24a4mr147700055e9.22.1747148944934;
        Tue, 13 May 2025 08:09:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpRtJWlGyhg+ZesNw4pZ1+fqHD/MY1cSehn8K8lk/qRmYG1nUKTsLP1T0Aem2/15rVxgGAHg==
X-Received: by 2002:a05:600c:384a:b0:43c:ea36:9840 with SMTP id 5b1f17b1804b1-442d6dd24a4mr147699335e9.22.1747148944357;
        Tue, 13 May 2025 08:09:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d687ad31sm170026065e9.34.2025.05.13.08.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 08:09:03 -0700 (PDT)
Message-ID: <131502e7-d487-48f6-84de-02a296116fb4@redhat.com>
Date: Tue, 13 May 2025 17:09:02 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 10/10] arm/cpu-features: document ID reg properties
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-11-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250414163849.321857-11-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zd-i2ak-3qZY_YrHpE2XcNhNsBoNHRItYH2jIEU6-l0_1747148945
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Connie,
On 4/14/25 6:38 PM, Cornelia Huck wrote:
> Add some documentation for how individual ID registers can be
> configured with the host cpu model.
>
> [CH: adapt to removal of the 'custom' model, added some more
>  explanations about using the ID register props]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst | 104 ++++++++++++++++++++++++++++---
>  1 file changed, 96 insertions(+), 8 deletions(-)
>
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 37d5dfd15b34..22faefd76edd 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -2,7 +2,10 @@ Arm CPU Features
>  ================
>  
>  CPU features are optional features that a CPU of supporting type may
> -choose to implement or not.  In QEMU, optional CPU features have
> +choose to implement or not.  QEMU provides two different mechanisms
> +to configure those features:
> +
> +1. For most CPU models, optional CPU features may have
>  corresponding boolean CPU proprieties that, when enabled, indicate
>  that the feature is implemented, and, conversely, when disabled,
>  indicate that it is not implemented. An example of an Arm CPU feature
> @@ -29,6 +32,16 @@ supports the feature.  While ``aarch64`` currently only works with KVM,
>  it could work with TCG.  CPU features that are specific to KVM are
>  prefixed with "kvm-" and are described in "KVM VCPU Features".
>  
> +2. Additionally, the ``host`` CPU model on KVM allows to configure optional
> +CPU features via the corresponding ID registers. The host kernel allows
> +to write a subset of ID register fields. The host model exposes
> +properties for each writable ID register field. Those options are named
> +SYSREG_<IDREG>_<FIELD>. IDREG and FIELD names are those used in the
> +ARM ARM Reference Manual. They can also be found in the Linux
> +arch/arm64/tool/sysreg file which is used to automatically generate the
> +description for those registers and fields. This currently only has been
> +implemented for KVM.
> +
>  CPU Feature Probing
>  ===================
>  
> @@ -124,13 +137,20 @@ A note about CPU models and KVM
>  
>  Named CPU models generally do not work with KVM.  There are a few cases
>  that do work, e.g. using the named CPU model ``cortex-a57`` with KVM on a
> -seattle host, but mostly if KVM is enabled the ``host`` CPU type must be
> -used.  This means the guest is provided all the same CPU features as the
> -host CPU type has.  And, for this reason, the ``host`` CPU type should
> -enable all CPU features that the host has by default.  Indeed it's even
> -a bit strange to allow disabling CPU features that the host has when using
> -the ``host`` CPU type, but in the absence of CPU models it's the best we can
> -do if we want to launch guests without all the host's CPU features enabled.
> +seattle host, but mostly if KVM is enabled, the ``host`` CPU model must be
> +used.
> +
> +Using the ``host`` type means the guest is provided all the same CPU
> +features as the host CPU type has.  And, for this reason, the ``host``
> +CPU type should enable all CPU features that the host has by default.
> +
> +In case some features need to be hidden to the guest, and the host kernel
> +supports it, the ``host`` model can be instructed to disable individual
> +ID register values. This is especially useful for migration purposes.
> +However, this interface will not allow configuring an arbitrary set of
> +features; the ID registers must describe a subset of the host's features,
> +and all differences to the host's configuration must actually be supported
> +by the kernel to be deconfigured.
>  
>  Enabling KVM also affects the ``query-cpu-model-expansion`` QMP command.  The
>  affect is not only limited to specific features, as pointed out in example
> @@ -167,6 +187,13 @@ disabling many SVE vector lengths would be quite verbose, the ``sve<N>`` CPU
>  properties have special semantics (see "SVE CPU Property Parsing
>  Semantics").
>  
> +Additionally, if supported by KVM on the host kernel, the ``host`` CPU model
> +may be configured via individual ID register field properties, for example::
> +
> +  $ qemu-system-aarch64 -M virt -cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> +
> +This forces ID_AA64ISAR0_EL1 DP field to 0.
> +
>  KVM VCPU Features
>  =================
>  
> @@ -466,3 +493,64 @@ Legal values for ``S`` are 30, 34, 36, and 39; the default is 30.
>  
>  As with ``x-rme``, the ``x-l0gptsz`` property may be renamed or
>  removed in some future QEMU release.
> +
> +Configuring CPU features via ID register fields
> +===============================================
> +
> +Note that this is currently only supported under KVM, and with the
> +``host`` CPU model.
> +
> +Querying available ID register fields
> +-------------------------------------
> +
> +QEMU will create properties for all ID register fields that are
> +reported as being writable by the kernel, and that are known to the
> +QEMU instance. Therefore, the same QEMU binary may expose different
> +properties when run under a different kernel.
> +
> +To find out all available writable ID register fields, use the
> +``query-cpu-model-expansion`` QMP command::
> +
> +  (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
> +  {"return": {
> +   "model": {"name": "host", "props": {
> +   "SYSREG_ID_AA64PFR0_EL1_EL3": 1, "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0,
> +   "SYSREG_CTR_EL0_L1Ip": 3, "SYSREG_CTR_EL0_DminLine": 4,
> +   "SYSREG_ID_AA64MMFR0_EL1_BIGEND": 1, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0,
> +   "SYSREG_ID_AA64MMFR2_EL1_CnP": 1, "SYSREG_ID_DFR0_EL1_PerfMon": 4,
> +   "SYSREG_ID_AA64PFR0_EL1_DIT": 0, "SYSREG_ID_AA64MMFR1_EL1_HAFDBS": 2,
> +   "SYSREG_ID_AA64ISAR0_EL1_FHM": 0, "SYSREG_ID_AA64ISAR2_EL1_CSSC": 0,
> +   "SYSREG_ID_AA64ISAR0_EL1_DP": 1, (...)
> +   }}}}
> +
> +If a certain field in an ID register does not show up in this list, it
> +is not writable with the specific host kernel.
> +
> +A note on compatibility
> +-----------------------
> +
> +A common use case for providing a defined set of ID register values is
> +to be able to present a fixed set of features to a guest, often referred
> +to as "stable guest ABI". This may take the form of ironing out differences
> +between two similar CPUs with the intention of being able to migrate
> +between machines with those CPUs, or providing the same CPU across Linux
> +kernel updates on the host.
> +
> +Over the course of time, the Linux kernel is changing the set of ID register
> +fields that are writable by userspace. Newly introduced writable ID
> +registers should be initialized to 0 to ensure compatibility. However, ID
why 0? shouldn't they just be ommitted from the explicit command line?
> +registers that have already been introduced that undergo a change as to
> +which fields are writable may introduce incompatibities that need to be
Aren't incompatibilities due to changed default values only. The fact a
new writable field gets exposed does not change the default value in
general. If it was not exposed before, the end user couldn't change its
value, no?

Thanks

Eric
> +addressed on a case-by-case basis for the systems that you wish to migrate
> +inbetween.
> +
> +A note on Arm CPU features (FEAT_xxx)
> +-------------------------------------
> +
> +Configuring CPUs is done on a feature level on other architectures, and this
> +would imply configuring FEAT_xxx values on Arm. However, differences between
> +CPUs may not map to FEAT_xxx, but to differences in other registers in the
> +ID register range; for example, differences in the cache architecture exposed
> +via ``CTR_EL0``. We therefore cannot rely on configuration via FEAT_xxx. A
> +feature-based interface more similar to other architectures may be implemented
> +on top of the ID register interface in the future.

