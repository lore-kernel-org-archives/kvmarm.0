Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57782D3739
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224779; cv=pass; b=e4ASI62ZhJoEv2p3dpDRiUUgI8DoengHuWe8hpZUtXM62UoiD2PSDj16MPurVpnSfFWxtdBmpaEndfdtFLBfaXMBy43fRvS2VjxKaW/Io/yfWbrDq8S8uiR861h42lDNZ6xr6Tg6o3lxmR7P1Ia6UdLvUjcHXAnKm7up0IFStPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224779; c=relaxed/simple;
	bh=XDOy1xUF8/xjDBQBG3duHOgCtVglv/8wJ7bfKMdJjEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PFHCFc687BIMJsWXIzU46u2BCpWS9fX13/KxfO7m8zcNr5XKP666Ig0zFYXdPOTl52TJKCfcV3ZPRjPo5sIzE3D9RGVBgqKGXW7wtpU9YYpTiItv4dQfLgKCQEoV2PtpCz07GfHeBetBvS8Jpeu0VxJxJ8FE+80LdoEy8AzvVC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ssv459zy; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ssv459zy"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50906a98ffeso522281cf.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:26:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224776; cv=none;
        d=google.com; s=arc-20240605;
        b=g18Jxrz9rIp7wYw9F2bHa/tQlW2rhTMB0nd1bygK9e2ZuNVRdkq0UHfAFU+MfLQw4v
         hn/C9dh3J3u1gL6OZ+cJwA3N7rFmpSz2jfjZv7NZ6myXZ2uAEd7djgUkaB7+g8vTuiMq
         pibC0QNSt+yEZ1Dz4OUdMVKqVLCf2Yz/1g4GD6lG34xWrWZj0SOc8sXjUk75CuiT0wyt
         wFoai2Yf/tvLUWYDiJFf8zrJ+ptSwcy7H8n/B3p8VwowtO1hkirlxefOqDKj03C/FH1X
         KiDq9jXA1nh5PTg6Z8zTVDqlsvKfBWmfBS6GBfgZtvQp6KT53z2cd4DyNSNu1x2OLbaW
         K8BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WpltYrqI900oLO2+c+Mia5fE0FAYeJkzONbbl9ulaVs=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=AkgOfemzYjj0/kZv9OPr4fFfPBnZNJmdQ86jcTLcHiEfDpdjnxejCxA36RtQSd8Jec
         68l0fKhvmDPL9KuSb8MXqryObNrlgydjTVqteDDKi5U3pCtEheR4lPBGbgx3V/rR95uh
         TAGC2C2rCcTS5OY7/6gTcPBFoxTyV69vi/YFMrn4KTOx5PHVqI2KEPAUWvhlpMz1o7SN
         QAUgPHzC1YzvxkAi4B+JRhuq9tBppPsSVvAJueqsGD6QFpsDvgLY6RhzDQ/5atxxcglu
         kmBWNhQmRsmPwt61k4VDBYuNVZ+kAoRobn66yVY6Tfza8YFJm2S9hI8PuzmihDLpvbBV
         MCZQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224776; x=1773829576; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WpltYrqI900oLO2+c+Mia5fE0FAYeJkzONbbl9ulaVs=;
        b=ssv459zyCgSXc/x8nmcOZjOoyI3nxa/mAiX1uElyL2K3sKfYdn9GarATu8J+XSCv9G
         L2mINu4awSi6dYWmkZqhomuxXSI/TsaVEvuN613tjtvrtOM32LMm51Dw7a3YQbXwwrMN
         PCfzf0Iyyc7uzPbi5hrf4THHPgANSJcsVyXjsBjwEUKGI4+WiREl3taX8fg8x58E165U
         Zg7ewcYBDx6+V9H4NnxdFzqlmanEtv/GpSD/7zeP1F9WB141vlpactx4X0BcesoHTmao
         uAEriQ2N0dKNaod3BDIihtBufCTqEVHJmBNM1pzrCiF8FGbdADsy5GY6fRA73rMOJIFR
         zUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224776; x=1773829576;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WpltYrqI900oLO2+c+Mia5fE0FAYeJkzONbbl9ulaVs=;
        b=bNy+cXHMvWJrpZn9NHwhdBinZjcgvFfjGwTjMQFp+yN7UsjlW3BD+zU4dMtBCapZvS
         4GUsUaNMDGbdZ8UeZq4yKSXvnD96vonFKYzncBGEH8iQxrQxL2rGG9LBpKsG4tXaNQSo
         iqV7gVSAeDL35J47rkY9HWF+eQFg+CdJmnY9amACQAzjOQWSGNZWWOkwtLKLR2yWR3VH
         JPkLxgkcQtDr8gARqT8NQVLaqTQ73EdwjCIFwSPhqNUIFpCpfQfGN1YVBu+1edejScH9
         k90M++UNu+FPtg6Sz/Jc0isgWm0kRd5eI2yUju/3nwSk9h3Q8CdzsgfVfZYLna8rXxaS
         SLow==
X-Gm-Message-State: AOJu0Yzty5Wn2z6dTxL9I8sjfbI6fZpALDKoX3ZPxPirF8Uh7h0GZYE+
	PwJrrCaUCvVxYKmc5xwKtGpS5T4Qma1GkeXbBEFnxgyvhVYcaNYz6lX5HjASo9Pml/7wuGpM3DZ
	pfJZo8zJCcr19t7hxbU9KwiEinEyroNfKSEl8SWu8
X-Gm-Gg: ATEYQzyd8tmWHCYCSrrb854hxLhxySI3327ulPCqVsl/SOSuSgWPCuBoJjrtE4qMf9/
	Qza9N6TuvCOZaelG5oWHUSrAEnw9Esv/WEmVy5ThJ5RRh79sSzEHEYc8sqdqvkVP6LHDhuXZHJN
	l9JDFdJY2KTjcnql2gd2tjIJd24hTjm7NausR8ErL67jac0GqlU7+OL9H9GODJR+/zk5aC9cygj
	OMQGtOhwtKqc54rxqnFK+sPxwtj1i8dmvAajyH0JX6hjf1GPi7gvs4Gfd0ubDwWb5EGb/kzx8pP
	OJ+PH93vDgQbZKtlLAZEqQzQCRTVKB6a53RPdQ==
X-Received: by 2002:a05:622a:c9:b0:509:208f:3876 with SMTP id
 d75a77b69052e-509382cc3e9mr11000291cf.18.1773224775604; Wed, 11 Mar 2026
 03:26:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-32-will@kernel.org>
In-Reply-To: <20260305144351.17071-32-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:25:38 +0000
X-Gm-Features: AaiRm53cCc9AyEq5QAjsIdDAy2W7kWDmuADjtYNUVtV6GRZJQapB8eqkdi0jMXw
Message-ID: <CA+EHjTwk8c0RGqCLJFRr0PeyFtOzsjmbab33tLZPfBJhdPqtFA@mail.gmail.com>
Subject: Re: [PATCH v3 31/36] KVM: arm64: Add some initial documentation for pKVM
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:45, Will Deacon <will@kernel.org> wrote:
>
> Add some initial documentation for pKVM to help people understand what
> is supported, the limitations of protected VMs when compared to
> non-protected VMs and also what is left to do.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  .../admin-guide/kernel-parameters.txt         |   4 +-
>  Documentation/virt/kvm/arm/index.rst          |   1 +
>  Documentation/virt/kvm/arm/pkvm.rst           | 103 ++++++++++++++++++
>  3 files changed, 106 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/virt/kvm/arm/pkvm.rst
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index cb850e5290c2..c14d80204f88 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3246,8 +3246,8 @@ Kernel parameters
>                         for the host. To force nVHE on VHE hardware, add
>                         "arm64_sw.hvhe=0 id_aa64mmfr1.vh=0" to the
>                         command-line.
> -                       "nested" is experimental and should be used with
> -                       extreme caution.
> +                       "nested" and "protected" are experimental and should be
> +                       used with extreme caution.
>
>         kvm-arm.vgic_v3_group0_trap=
>                         [KVM,ARM,EARLY] Trap guest accesses to GICv3 group-0
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index ec09881de4cf..0856b4942e05 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -10,6 +10,7 @@ ARM
>     fw-pseudo-registers
>     hyp-abi
>     hypercalls
> +   pkvm
>     pvtime
>     ptp_kvm
>     vcpu-features
> diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
> new file mode 100644
> index 000000000000..8258c93bed6e
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/pkvm.rst
> @@ -0,0 +1,103 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +====================
> +Protected KVM (pKVM)
> +====================
> +
> +**NOTE**: pKVM is currently an experimental, development feature and
> +subject to breaking changes as new isolation features are implemented.
> +Please reach out to the developers at kvmarm@lists.linux.dev if you have
> +any questions.
> +
> +Overview
> +========
> +
> +Booting a host kernel with '``kvm-arm.mode=protected``' enables
> +"Protected KVM" (pKVM). During boot, pKVM installs a stage-2 identity
> +map page-table for the host and uses it to isolate the hypervisor
> +running at EL2 from the rest of the host running at EL1/0.
> +
> +If ``CONFIG_PROTECTED_VM_UAPI=y``, pKVM permits creation of protected
> +virtual machines (pVMs) by passing the ``KVM_VM_TYPE_ARM_PROTECTED``
> +machine type identifier to the ``KVM_CREATE_VM`` ioctl(). The hypervisor
> +isolates pVMs from the host by unmapping pages from the stage-2 identity
> +map as they are accessed by a pVM. Hypercalls are provided for a pVM to
> +share specific regions of its IPA space back with the host, allowing
> +for communication with the VMM. See hypercalls.rst for more details.
> +
> +Isolation mechanisms
> +====================
> +
> +pKVM relies on a number of mechanisms to isolate PVMs from the host:
> +
> +CPU memory isolation
> +--------------------
> +
> +Status: Isolation of anonymous memory and metadata pages.
> +
> +Metadata pages (e.g. page-table pages and '``struct kvm_vcpu``' pages)
> +are donated from the host to the hypervisor during pVM creation and
> +are consequently unmapped from the stage-2 identity map until the pVM is
> +destroyed.
> +
> +Similarly to regular KVM, pages are lazily mapped into the guest in
> +response to stage-2 page faults handled by the host. However, when
> +running a pVM, these pages are first pinned and then unmapped from the
> +stage-2 identity map as part of the donation procedure. This gives rise
> +to some user-visible differences when compared to non-protected VMs,
> +largely due to the lack of MMU notifiers:
> +
> +* Memslots cannot be moved or deleted once the pVM has started running.
> +* Read-only memslots and dirty logging are not supported.
> +* With the exception of swap, file-backed pages cannot be mapped into a
> +  pVM.
> +* Donated pages are accounted against ``RLIMIT_MLOCK`` and so the VMM
> +  must have a sufficient resource limit or be granted ``CAP_IPC_LOCK``.
> +  The lack of a runtime reclaim mechanism means that memory locked for
> +  a pVM will remain locked until the pVM is destroyed.
> +* Changes to the VMM address space (e.g. a ``MAP_FIXED`` mmap() over a
> +  mapping associated with a memslot) are not reflected in the guest and
> +  may lead to loss of coherency.
> +* Accessing pVM memory that has not been shared back will result in the
> +  delivery of a SIGSEGV.
> +* If a system call accesses pVM memory that has not been shared back
> +  then it will either return ``-EFAULT`` or forcefully reclaim the
> +  memory pages. Reclaimed memory is zeroed by the hypervisor and a
> +  subsequent attempt to access it in the pVM will return ``-EFAULT``
> +  from the ``VCPU_RUN`` ioctl().
> +
> +CPU state isolation
> +-------------------
> +
> +Status: **Unimplemented.**
> +
> +DMA isolation using an IOMMU
> +----------------------------
> +
> +Status: **Unimplemented.**
> +
> +Proxying of Trustzone services
> +------------------------------
> +
> +Status: FF-A and PSCI calls from the host are proxied by the pKVM
> +hypervisor.
> +
> +The FF-A proxy ensures that the host cannot share pVM or hypervisor
> +memory with Trustzone as part of a "confused deputy" attack.
> +
> +The PSCI proxy ensures that CPUs always have the stage-2 identity map
> +installed when they are executing in the host.
> +
> +Protected VM firmware (pvmfw)
> +-----------------------------
> +
> +Status: **Unimplemented.**
> +
> +Resources
> +=========
> +
> +Quentin Perret's KVM Forum 2022 talk entitled "Protected KVM on arm64: A
> +technical deep dive" remains a good resource for learning more about
> +pKVM, despite some of the details having changed in the meantime:
> +
> +https://www.youtube.com/watch?v=9npebeVFbFw
> --
> 2.53.0.473.g4a7958ca14-goog
>
