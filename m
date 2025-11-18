Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BF32F1FC8
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462385; cv=none; b=UumI14Iucemse3VTS47Jqwt8/Q4hB7qSkJGdjNpHfWZGfLFnFIcKdS9ydq7/bQGAPjjYjxI/ibC6SBSLPf1CMoLPka9Cg3shg5rCf3e+UDLtq+G/ZdpQ+Zq1WMYdJUB9PckWnfupXslbIxdq/RGbJVuTjNpJVLvYZBYWRNJ036Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462385; c=relaxed/simple;
	bh=2eGJfH9Fvrs9Q2j26nj1pJcG/v5qQ2e3DafswTVyPwM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HT3we2KtD232doc154L4vRPRs8DNEDgYHq2wQJ9cV1l18y3c29/Rg4ssaZM49eiup+/6g/mKS2I6AjDjO90dXkWX/xi2JCSRxtoljXwzG0xe2LOw0gA5jCG15DRRRkFy9ETSWfSiHjT92BOyKJia/Fn38d8RAcuCXjO9E6OZdEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jnvkUw1X; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jnvkUw1X"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee243b98caso193521cf.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462382; x=1764067182; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A3fuFPmq7u+4TfWmna4IMO/rExqShukKvoJZ1nxd6fI=;
        b=jnvkUw1XxSkzQGYiWibY8uCXxM7yzp5HvvuO92gHmsOEMQ1iJNm4kBbtKG66/L7f3f
         Ajp8bOfW+yP0NnUDt2gwR9qPPPbfdOYvTT9xY7QXOlZqVjgb1EiEYpj5E/If4oillQkl
         dN9/qsDoykI/UFMtLPlMtnLqW2FWpW01TCE+aRQyIBOvlrN/a55y5sbJaoiGJ5OKR19N
         TboXYth02lfVWn1kyRTCKblTVDhkv0/fIFFRyaI1jiHXZp7Jlk3pLQgQpDH8B/fqeG69
         jOsTpbEsrWZaYOpDhbjimi2xn9OyeffmQ/ij6AIyXY7XI6WrIEqQsewlGjjsNAqbIzU/
         JDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462382; x=1764067182;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A3fuFPmq7u+4TfWmna4IMO/rExqShukKvoJZ1nxd6fI=;
        b=Cjf+U5u/bzQqzjdbzVCrwo99FSGb9OxOOD9pwQVR+IYIyTzg8Zk44Tu5UUAtb6/hu5
         QuO0KpHrUJsF7sR73R9oLYEKWRDpV8JAODd6ienex9YJ1khIhG9wwBgoddie8JXjSpeE
         4818H1mOm0p8TXzli7xV6DJJxMD3RUIxGAOjo9na2XBo+XrPbJ9qzx2W6G00DyXlaARD
         rzr2RvVPvlavOp9H2CAuLhOMmzatVxu+S5OK0VC47cfkJRF+reOsOCV7Vpw3WWscYsiT
         ATrricdMLh+S+SkFtHu5H1IjmnUG9FHcw62WqHHjQ9UjDlozoaxCvtGySLRfCFOb7LkZ
         5EpA==
X-Gm-Message-State: AOJu0YwAyedcKEmqb/wjroO31oLNsOgULHSbAcyGTHkDCByeY/zGnhAL
	6NN1Q0MBczEJMPZUl8uGWAHdzuHuWylR95k0nv4LbRgvkOfq3ZS6N6tNg9lDTSXGaeOOa8beEVI
	t9KntcG7fl0RQaHZ2vlwoE36nuyWy+29rEv1TtM6OEFl8/xU6jywR/aoCygU=
X-Gm-Gg: ASbGncvmy2aGOKLiIvi4Dksyp1eVaJciJyjSspKNqZOle6OeJ5OhzFxese//xxezqwb
	zO3SJceeaaxrF4sLaJedHPSyCC4hrvbhshtGtUAPvhe8n7eDVcgxNpXrdoS3TJ/5sVOgP3vhFEs
	/FlphvHAcXf5iXFBBjV2plHTnxkPzI2tD644unRI3BhEUeITpiFL3PLYAzP62Jdtx2eOLAsJ1sY
	shfdumlkXLUCOaLnsNwMkH6dM5IDXPk4oo20Tk9T2KNXklxaZ/RlQahidn0nfHO5P+YEjaY7W0N
	q37ZdQFXN6OzI7a/ZrB6saCr/8GZJc4/qHc=
X-Google-Smtp-Source: AGHT+IF7R3581QqoxLfrWmpw9+FLNMOBldbaqa1DkyFXRRv3ZqD8SWk+0oLgf3+nvFRitSGahBgPq/81NnTTID7GzXw=
X-Received: by 2002:ac8:7254:0:b0:4b3:7533:c1dd with SMTP id
 d75a77b69052e-4ee3a8f3a62mr327971cf.1.1763462381839; Tue, 18 Nov 2025
 02:39:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com>
In-Reply-To: <20251118103807.707500-1-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 18 Nov 2025 10:39:05 +0000
X-Gm-Features: AWmQ_bkg3Pxo8Nt-K_kohdqRusQj83AOJuZTIGZVKLHFt3_L0-eui3763G3uKAs
Message-ID: <CA+EHjTz0tUL9Q0d2tS9D_w=csuz+7t5KVfvfr-4WRjmeTf+3=A@mail.gmail.com>
Subject: Re: [PATCH v5 0/9] KVM: arm64: Fixes for guest CPU feature trapping
 and enabling
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Nov 2025 at 10:38, Fuad Tabba <tabba@google.com> wrote:
>
> Hi,
>
> This series contains several fixes for guest feature trapping and
> enabling, as well as a bit of tidying up.
>
> Changes from v3 [1]:

This should be
Changes from v4 [1]:
[1] https://lore.kernel.org/all/20251112092051.1376245-1-tabba@google.com/

Cheers,
/fuad

> - Add a map of KVM capabilities to IOCTLs (Oliver)
> - Based on Linux 6.18-rc6
>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/20251110134525.3768197-1-tabba@google.com/
>
> Fuad Tabba (9):
>   KVM: arm64: Fix Trace Buffer trapping for protected VMs
>   KVM: arm64: Fix Trace Buffer trap polarity for protected VMs
>   KVM: arm64: Fix MTE flag initialization for protected VMs
>   KVM: arm64: Introduce helper to calculate fault IPA offset
>   KVM: arm64: Include VM type when checking VM capabilities in pKVM
>   KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest in pKVM
>   KVM: arm64: Track KVM IOCTLs and their associated KVM caps
>   KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
>   KVM: arm64: Prevent host from managing timer offsets for protected VMs
>
>  arch/arm64/include/asm/kvm_arm.h         |  2 ++
>  arch/arm64/include/asm/kvm_host.h        | 42 ++++++++++++++++++++++++
>  arch/arm64/include/asm/kvm_pkvm.h        | 33 ++++++++++++++++---
>  arch/arm64/kvm/arch_timer.c              | 18 +++++++---
>  arch/arm64/kvm/arm.c                     |  7 ++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c           | 18 +++++-----
>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
>  arch/arm64/kvm/inject_fault.c            |  2 +-
>  arch/arm64/kvm/mmu.c                     |  4 +--
>  include/uapi/linux/kvm.h                 |  1 +
>  10 files changed, 105 insertions(+), 24 deletions(-)
>
>
> base-commit: 6a23ae0a96a600d1d12557add110e0bb6e32730c
> --
> 2.52.0.rc1.455.g30608eb744-goog
>
