Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E5D51FCC0
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 13:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789651045; cv=pass; b=VlomSmwemRtRtRYaW+Ujqb/XHv1if8fV4cEQvfu7BEd+L7lw9o0Jh2NoxPJA049s7G2iRPClPI7qx0eI6r424LsY5KVWpNLXAH1HWXq7UiRN4bkoNjC+nKZUqXk6sSKjK5O24mmecSfD+DsH3NK733ztohx3kvmE8cdrNaejW/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789651045; c=relaxed/simple;
	bh=kO4HLKikSv+g/tlkono8w2r9mfJw0DOnYzMEnSqFOZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HV9+yEI7cgtmZ8pYoqAyaf7BgM4E0ijBqTB4Kj3rJFJiXZ7xfaii46gCd+RZQZ542/v5N3y526h0Xl8NY7HIQvcPnOsQMUNph0KumDGZz7NR8EGhuNwcgaVtWHcUZicuHHDpXx7pXDbZtdInvAd9nBqUwTk5ivEcfzT1tl1JFY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wZRpOz5H; arc=pass smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wZRpOz5H"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b7658501ccso1867e87.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 06:17:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789651042; cv=none;
        d=google.com; s=arc-20260327;
        b=CKNYZXwefRqwvn2pGt5iVbq2Z3V4y4E/iPuKhqqSQdAx0RbKt0rNEHfXGek2JKKwRT
         3uSyrr9TP6Zcis+GU/IDZ6ehvXIE16aDvIYLKmQYOyRxFkExaVKJWpVhiQ9FVVR4+9mD
         FW29WsU8eUNpHjlc2A3QLC3YsLqNkhhMte53fSDnHHqKSPQ0JdsBy7zRcX5XBgrz988M
         e2pfXRt/2cVKij4E4J35AfxXR8lQqBa+U65JxwCqvyTD5PkmJQwF27hc5xZR7xYzzQtn
         YRc9y+2uxwljjoM3TMC4dTq//3CDSamvKjuxT6R42z2X8be6gWwP91zaPipCFlY/ygBF
         9jvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yvMJselGvAoMrhysUaGitx662yndDSgH+0mQM9lz22E=;
        fh=45kMozODe+KgLIKjwLKKd9NepntzlUj+/rxut3l/0pE=;
        b=XXHcjE+gblOk5Vz/ytVzRPOQ1WpgERU+WkiKdiAlIICRxLTmbuz+DmyMua+4mg+WgA
         8m73oi9o4vzkZVJBzDmms1IZUxkO2+oXs0W+dtVkwFxSaqiUSTY/PHpvEnnuhUwkMhqN
         O2aKnKk+i8X0wt2aoMvTjk1uptjsZe/qA4oQb+fUD3yfGk6cEIQf84ezPlFAR6P4l891
         tjA27NZCPDRXqTERlZ1D9eTwHVvFx1XrKquIMdNf2S299HyxC5/gng0LGIDzs+ulmaAu
         9isIXF3jHw2hUArye69+aZy73CnJOGJbqWYAKwu4nte1VASu2tVqmc7rIac61R27fayZ
         O9eQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789651041; x=1790255841; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yvMJselGvAoMrhysUaGitx662yndDSgH+0mQM9lz22E=;
        b=wZRpOz5HQwYjIvmx/8gyhh+ZLjQFIdNmketC08Ayd6oJ71aWP18IgGAVp1zTcr74UU
         XlP6AAxyTuuuXCDVGdsory87YFTxJtT8YxP6lbf7FFp4Uxy/RKru+T2URkx4d1Nzhs55
         RG3xee0y/9Yl4Be3wOizB3YXYYgaaHRLdqL8n9ZfbrJ+rZH7kOFg0locYnNVQrXQWJE7
         PE2i6cmz99NHAMbSHXZdkvDNlypbcColPN1wsA6abwCWmUVGsUHDE0gYEqFm5pUdwvZK
         DYC40h7wr+FpXHacZvJuAR2UcgvTS1zIsA29pwgWGaMq02ukX9sSHYFElH/vk9IzMTn/
         ZbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789651042; x=1790255842;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yvMJselGvAoMrhysUaGitx662yndDSgH+0mQM9lz22E=;
        b=tOakYBVWrmlFu/ZPCjFne52zb5kDyZ5DPKJ8r4d1EG0518oeNfy59zF0kahYUsmY+4
         9WTvkBXUWMRwCdeFh1gVbqcFmpfpcHPdum7E6PB2AiA41pJumApfV1UJGk2aPdKJJeAT
         OfnzSnvniQhSUPhk+gOBtaCOYModaOW0AiTkcs9YmvKskQAvyxh4eUupEYPMgQHnn4En
         kqzwYoo/Gzb1QmY4kABK3mAmfVGUObZwuNevxpXXiJx/d3Hl3UbuvOAN01G14HMJv5zL
         KwKufOwFmyYa+Af1edDr0SvcyyVKPDkyCV6owmAdwVDYGskiIQe5Szn4m2qGyTak1FuZ
         +ySA==
X-Forwarded-Encrypted: i=1; AKwUvByHKVq3t1nGj0OZT9GXnFkKOA92e0sieDcUgH+BGERsP7iOd2dCkpOhweT14sv+r0CccC1NA44=@lists.linux.dev
X-Gm-Message-State: AFuF++nN1q8+69umy75L/hPdBBdH7vsoXWdAvSS9cpTfghF9yOIG6fKf
	yPMIg+lnhiBReMFt81xb260ZfSfDRZ0pOLCvxlhnLWlsILXuwyR0HQY2WNFboidTOmelwn05hs+
	QCkPdey/U9jFfTqjE1dZU5EW5Ox2wx4TPpQYz0vIU
X-Gm-Gg: AYBFou0mFWm2PmxzTj1OH69bOrPVkqiRJgEyTp585YSw2oxQboiKFyCX8gOF+oeJUqK
	QOaHKWebwD6Z/yAJcXAFMfS6FCxaepCgQjZy9DxO7QgBZ4WJSfQLgrSp/sPKfIqMcPbMFfifecy
	EDXiCOUolxAs7XIob1/RBIGP/JFWR0u+Ty76jikeAfeNdUXKqvjoPRg7S28KBLTCWuV/mabN7YQ
	Tw6cfc5iyR4d4YxLGDncXLX1xT1L7G8fFUDEyQJV2LznmebbjeXkp1wzBrfozYgTLsJPoEeeKu6
	OMML55YsFsq7prAOHM6pWBjfNSH1fkZcDpyf/isifSjIqiqYy64TGxqBsCGe90AuHcsn/dTKbqF
	VxRakFKuvf7tXXQ==
X-Received: by 2002:ac2:4c50:0:b0:5b2:8963:e5d4 with SMTP id
 2adb3069b0e04-5b8bff1d051mr39681e87.5.1789651041084; Thu, 17 Sep 2026
 06:17:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915160141.3543048-1-suzuki.poulose@arm.com> <20260915160141.3543048-21-suzuki.poulose@arm.com>
In-Reply-To: <20260915160141.3543048-21-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 17 Sep 2026 14:16:44 +0100
X-Gm-Features: AcwNN1VtWWKyrr6h6sFHMUccgZH0Chs5OMidTNSOoiZ_fDx_6ZmQhtU1SR2DO2Y
Message-ID: <CA+EHjTwYqTFzGdNPproWW5L6j5pNqmuWeFuu9HbHa8LBLPvY2A@mail.gmail.com>
Subject: Re: [PATCH v18 20/23] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Tue, 15 Sep 2026 17:01:38 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
[...]
> +static inline bool kvm_realm_ext_allowed(long ext)
> +{
> +        switch (ext) {
> +        case KVM_CAP_ARM_PSCI:
> +        case KVM_CAP_ARM_PSCI_0_2:
> +        case KVM_CAP_NR_VCPUS:
> +        case KVM_CAP_MAX_VCPUS:
> +        case KVM_CAP_MAX_VCPU_ID:
> +        case KVM_CAP_MSI_DEVID:
> +        case KVM_CAP_ARM_VM_IPA_SIZE:
> +        case KVM_CAP_ARM_SVE:
> +        case KVM_CAP_ONE_REG:
> +        case KVM_CAP_ARM_PTRAUTH_ADDRESS:
> +        case KVM_CAP_ARM_PTRAUTH_GENERIC:
> +        case KVM_CAP_SYNC_MMU:
> +                return true;
> +        }
> +        return false;
> +}

I'd keep KVM_CAP_IRQCHIP in this list. api.rst has it advertising
KVM_IRQ_LINE as well as KVM_CREATE_IRQCHIP, so the cap means in-kernel
irqchip rather than GICv2, and the GICv2 case is already rejected by
patch 18 in kvm_vgic_create(). It also keeps the two protected lists
the same where the support is the same. And could this live in
kvm_rmi.h, next to where kvm_pkvm_ext_allowed() lives in kvm_pkvm.h,
rather than in arm.c?

[...]
> +static inline bool kvm_arch_vm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
> +{
> +        long ext;
> +        int r;
> +
> +        r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
> +        if (WARN_ON_ONCE(r < 0))
> +                return false;

You told Sashiko my fix covers this one [1], but that fix changes
kvm_pkvm_ioctl_allowed(), which this patch deletes, so the `if (r <
0)` has to go into this copy too. The guard you posted for the second
finding still leaves the WARN reachable on pKVM and Realm hosts, which
is the case the fix removed.

nit: kvm_arch_ is the prefix generic KVM uses for the hooks it calls
into the arch. For two static helpers in arm.c, kvm_vm_ext_allowed()
and kvm_vm_ioctl_allowed() would avoid the collision, and the same for
kvm_arch_vm_ext_allowed() above.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260914093838.1082637-1-fuad.tabba@linux.dev/
