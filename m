Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0051487F4
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176898; cv=none; b=R1jKJgY89/Dit6ssv3qB2nVDGlrdvVvxHuzB8JWHXjpu5nU3rpYDpBY832SQxBS3jwbe4t8sYmYH9CuYFxLkJn6AvFLgaRzrpYAwgQjm9MPuzYuAX9EaI2a522aPQSBVtjvs7bB018MMlGu+CgReeFnIAnmkUljcOurD0dgTgW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176898; c=relaxed/simple;
	bh=TvF0BdnnasXnvVAlrGP/rcowFd5S3sI7xypEK0IOEmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pFKOKAGlTuw4F50rRLHtKC/LjWnsORotEGWZilf1JY+wEY8zfwVfVYQzDhH+hXWczZrh98QsKGYI+Dv4XLg4r2fPuUfMOr25mBDuu5lgy6PlEb6Zut42tS73pKLC8dEyqYk261JpJxPmY9EkUrMVtOkXdlPcebZ6zQfvSmpzxmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KFbOsI+6; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KFbOsI+6"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4361d5730caso85765e9.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jan 2025 07:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736176895; x=1736781695; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8VLGhRXRhm+EanfgmiYZ10sk2VNENqbOi9U2rWlFtFA=;
        b=KFbOsI+6MoDvgyoIU89v8YH/XiTm4GZVzVdPLSrybU9Z5f1kjuM4rv5NuCy+EILVyU
         U3jTZT4B4dXe5SFsx3DuqkRC2AiIfIvhkyNeQBIcHB4L8faFsBae/bJlrtgUm+Rah/G3
         yXr+rIjrv6yNaLAaoK2ii5WWfwyWXvRvJnoyjAinDDoNNWTqQd8nAbNB1btzNSdxO4ni
         z4SSeFfRo3qboZN6a1ILpZTBUkxa3ggB4kNMpQrUGVzGtGcbXF5ihgoHElStsKpeASKh
         G9p/aV75a8tnV5e9Kome5hcbXjX5iJF+GCqjy2a0FDVts5loO2h56ui6Wiiun19tNu+w
         xY7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736176895; x=1736781695;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8VLGhRXRhm+EanfgmiYZ10sk2VNENqbOi9U2rWlFtFA=;
        b=bUyWkso/w45PUqMt9u60MN8QAFNCZqJY+vvcAB0gu7YfLFdQSuP0UVN57CPFrOTks+
         P3BTKgiyr0Sp3pV0kdaGnHFp4uevqhxNfVeN+3+Oyjr7D2T7sHUVOLr+rK6yym25BC7i
         6zha+L7nA5L3kBwkmh/15jBy5eeLOxwnKfi7cAal/22dmlOOszVXG15L367M6NMX/H79
         Dg75LyB7pl86tliosPJl8CRzn06Q3rd5jmp9Rw1pK/tDFQ5FQfyplJqtarYSGSBo7ihT
         mBk8Qe7lKK/da48NGkzuBkIXINftvMQj/wA368wuDAHJQYGpnhjx/uZzXdrOop/hiEqH
         JUFQ==
X-Gm-Message-State: AOJu0YyVTo1/i4Czw/yytDSdUNXJc9+tzsYG+PjMF2WQJ9KA9FigjGXm
	9ec29xTT6QuXpvsHo9/KLYn3OmJklG49hmJ9NZyaF0vKVNWwUEUKAuDN6fuQA6cDtYD7bjrhcuG
	u8ot6zBMFHnzbCrIcaJbLwHYnfijJu+RVjGyRWLsFjJ/lV0cOPHge
X-Gm-Gg: ASbGncshiKZrYDC6BqAY9k8CKHL16squdF5Gun34pZ7udb7EqsCZeUdgi2MuHLELpwn
	SAU9rrJ3z5xDZFi1uIJWqwAQz/DkQZJFTKnHZ
X-Google-Smtp-Source: AGHT+IGC8VLyPIwHx7vhg/p8yA7AkIK5cOV6MJ0XpM9NWZgr3JLjKUO9xxoaBHwIZGZXV+Kv3c9Vay9BVqC0RQa+FWs=
X-Received: by 2002:a05:600c:4994:b0:434:c967:e4b5 with SMTP id
 5b1f17b1804b1-436d09d9bf2mr2439775e9.1.1736176894499; Mon, 06 Jan 2025
 07:21:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106112421.65355-1-vladimir.murzin@arm.com>
In-Reply-To: <20250106112421.65355-1-vladimir.murzin@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 6 Jan 2025 15:20:58 +0000
Message-ID: <CA+EHjTym54=Jqs_rpQ8Ak+GhX4jCbQzDpdiZ0uGTo1+M-4OgRQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix FEAT_MTE in pKVM
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, maz@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Vladimir,

On Mon, 6 Jan 2025 at 11:24, Vladimir Murzin <vladimir.murzin@arm.com> wrote:
>
> Make sure we do not trap access to Allocation Tags.
>
> Fixes: b56680de9c64 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  arch/arm64/kvm/hyp/nvhe/pkvm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 071993c16d..dd55bff6a6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -229,6 +229,9 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>
>         if (vcpu_has_ptrauth(vcpu))
>                 vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
> +
> +       if (kvm_has_mte(vcpu->kvm))
> +               vcpu->arch.hcr_el2 |= HCR_ATA;
>  }
>
>  /*
> @@ -332,6 +335,9 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
>         struct kvm *kvm = &hyp_vm->kvm;
>         DECLARE_BITMAP(allowed_features, KVM_VCPU_MAX_FEATURES);
>
> +       if (test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &host_kvm->arch.flags))
> +               set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
> +
>         /* No restrictions for non-protected VMs. */
>         if (!kvm_vm_is_protected(kvm)) {
>                 bitmap_copy(kvm->arch.vcpu_features,
> --
> 2.24.0
>
