Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604A743B3F6
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 10:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790936439; cv=pass; b=cVUazj1tztEOj5/6UIwtMDrbvq2lJ+v3cwM67TZ92CDwNlVDXoZ0POpJy1VU09jhLz+RElBZKdpuwhoXaJOgvdFKBc86nXQtpZy/cp7WH67zL+AEaSzeOXzn3o49vAw4RIWqzK4vBKhjt9Icx4bBSKh/5WURG3Vwf0i+DbMxdWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790936439; c=relaxed/simple;
	bh=UOMj64A4DoXhOCxEjUECHTEJP1J0iaV3eziuUdVe8QI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y+z7zGszDnW+AWlHSjSUuYXhScLdWrtsQJ/Mx3vk2d8iDYCrdIAq4Y5Y42jw/AUvfZtoB0b6K05cJDBW9dTGz0QpLgqUWbTm3D51xMZARMQBs6mljXO7SFeUkovZw677wp2fB46nrzR9nlTP6BonLE7MafiMEmIjF3tn3NulSro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kew7YPrP; arc=pass smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kew7YPrP"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5ba40832934so4562e87.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Oct 2026 03:20:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790936434; cv=none;
        d=google.com; s=arc-20260327;
        b=Y8LeASSbBd5XLvMF2gGCow2BSOixuMBDvGCnDt8oy7d188QVwgLSdJrLYz/xlY4MsI
         UUjP8/OEq3VSMpq1S4DX8hnUf2DUF2EDqbmd+lrXsaFyhWAG/tJtfJjFsouS4DCb/YoR
         WdtVpzoMYSgeqcCjsIbRL3KxbnbXtd4Jm4bMM6z5Xi8AE31IwO/s3SCfH4nBMmV5d4d0
         wfG+km0FC6pptbGLGhXG5A+ojzFF61bRa23Op5SPieCCqSC3lS9zekAmm/iz/bGMxylC
         d9fMvoCev0hSKAlommlR9t79LzsmMI85+5N6UYnp0xlZeqSlXhGUORSIw5V78FQ7c1jN
         alSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=AWVQCSwR0aUoymLEu54Qp5SBrR33qbmFDxb/OCitD2E=;
        fh=yWfCUGFJoJZyMA8rh+/JZ0IceprYz6aV3Z/kfmyD2i0=;
        b=PsQiZcB57YqvuJqwKLfa2L5UXQKitwGJkWx6Ggcdvq6GdiF8hQVKZel2AnO2zWjAFY
         WVdMXVZdaP7adJ0aAwNdgn+4uAZgAqEohZ8fKxTF40IDDzhk0nBpAKaeZANvQdPaIU+E
         vhKL8vnX9AGfqh/QO1S/m/yaNh4Ixlt2Qkyjjvz6hGpJNRnkYhCWROZQirDRMqPujVqD
         H+u0Yz4FsSQw+eYzHiUe1hm+JjgXBLETSTIRVxKcRBEVEUXcR2lIarHxpou3yq5Zmx/e
         mSOwT5JxhiEL7qIKYYM671nfaMFir/ToswoKYny8xFB7IWCGhvUCdz8xQ/LPUiWFUZ8g
         D0eA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790936434; x=1791541234; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AWVQCSwR0aUoymLEu54Qp5SBrR33qbmFDxb/OCitD2E=;
        b=Kew7YPrPQH8lzf9TU3+B9DKi3xYmeACDnjjWbzA95Qjngq37SqwrSsfDDGwCfQOoI6
         pxaztmEyNAAkBg8Etaxyiwf5pKFsq+Asz0RuXk5B/3+aaGFinRitTZ/Yv/tKxXJ2D6AI
         8FbBnlwFnwJh0thmvYCN6dNO1cXQxYfqZGC6J5hIrLs6/JzENpnTbGM5lj1BgYQzNK7M
         WvzmAXreZEDUVbsAnXopxifkJ7EaX/5nmT4RJ2FcsLkvmrW88QyElXtHDLVYACLR59Dx
         EqP0bZmh3xh0mPFg9XDXn3Yif28qp6qj2ezEAJXuJKZcDAXeTCWuUIcYQrBp1M0PIxKa
         ndQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790936434; x=1791541234;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AWVQCSwR0aUoymLEu54Qp5SBrR33qbmFDxb/OCitD2E=;
        b=MeYLtJSITZ+pAa9NegNv0BYS1VZfTjA3z9JLSaDf2QB1rIrYzAhiZlYl5wgk+okfWH
         OIXdH3jziwn0ypp+jbIVXsTqvlw8Y4lXw7Q36lsquPR2cLlB1NIQdm2UOssv1PTb4azF
         9zYH6HMiVzDhyVCvPCQ7C5cbIBNrdURkxl90YDigzD7ygeFFRmFyH5vR6C0Y6Q219ua8
         vuxgicbtTuGCpGlj8HfJkIB20qNgtp1bppzbJUJq/AbyrmCmP9v0JCyrRMG2OMdAE58Y
         7ocwls5yH2XSONB/+MQ0sdrAUffrR5NmoewxmvXsCR/3qgSo10sxQBb2RIAwsLKNBzVh
         H40A==
X-Forwarded-Encrypted: i=1; AKwUvBxceuZ/oJAyObLHTy4kQEYCADTpLLmV2N0hZLA31JhNmdlDErVOcwRJmzWg+AjaStBlzW/UEro=@lists.linux.dev
X-Gm-Message-State: AFq9FYL/9ib3jC6B1/EL6bCpQdEzDiNyPpynrKRTifJ6iHUhOGQ7vzm3
	MFfvvn7KoevkaQK5sz8BxmKsjc+NwntnNaa2jJgh2w7DlKt76cZYZINAmwAzwyKLExJUrg2On3S
	kIDbwXgTaumpNJROJshMsh+NseakmAqaKWOfb0ILU
X-Gm-Gg: AYBFou0ukmzuQavKugtjxEGFMFoRY/neaUR3vr+YQWe9zjLJp46Vp3GrsXfA9pVdT6R
	Pqe6jG+8k28qQKdGIOUahXL+MLqjWobZ5uNKgyK+GRTAlZmGVyFM9X2ZGXu1ZVBP5lJj3MyaGT6
	cVlGb1SZBJ1xvImJDG4UEqNX/PO9E2u0F7s6lv7dbgMH16PwmBn5LoUPDMkxbh+2gryFuIoDJdo
	x2INcZDSAfEHDgNbjuHD6bA9VKEnqp98ENraMCtkrfpNwwYBl0gOBwJU/8jSgBLNd5aWb8mp727
	Znd4HdzksQibDpKl2GqPzkI0ssO8wTvGJS6mkkjcWkITHWoPX7g0XN6l/tO/31B2tPhSuHT527k
	UGPmTMoX1g9phr2zPAuVY/DE1
X-Received: by 2002:a05:6512:1c9:b0:5b7:6707:e44c with SMTP id
 2adb3069b0e04-5bbe0806600mr67600e87.12.1790936433781; Fri, 02 Oct 2026
 03:20:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001210703.1597150-1-suzuki.poulose@arm.com> <20261001210703.1597150-11-suzuki.poulose@arm.com>
In-Reply-To: <20261001210703.1597150-11-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 2 Oct 2026 11:19:57 +0100
X-Gm-Features: AclHuK9rOT56mg_GDAS-UKmKKcU8gCHcSak7k76HWhpeBX7f_dB7iE1PChHGrcQ
Message-ID: <CA+EHjTxCfmOqiJzYDZHunSuEyoZCbgHuzeSYC8y71Re+9PA6Kw@mail.gmail.com>
Subject: Re: [PATCH v21 10/23] KVM: arm64: Add VM specific callback for S2 MMU operations
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Thu, 01 Oct 2026 22:06:50 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
> Add VM type specific S2 MMU operation backends which can be initialized per
> VM flavor, to keep the handling cleaner.

The rows only differ where the base already branches (the pKVM TLB
flushes, the protected VM age and unmap, and from patch 12 its abort),
so the case for the table rests on the Realm row, which isn't
functional until the RMI backend lands. Beyond the flushes in patch
16, which operations do you expect it to override?

[...]
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
[...]
>  int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
[...]
> +       if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs)
> +               return 1;

Every row sets it today, but returning 1 falls back to
KVM_REQ_TLB_FLUSH, which arm64 doesn't handle, so nothing would be
flushed. Could vm_flush_remote_tlbs be mandatory, checked in
kvm_vm_init_vm_s2_ops()?

Cheers,
/fuad
