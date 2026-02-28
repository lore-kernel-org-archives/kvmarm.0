Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693CF44CF5C
	for <kvmarm@lists.linux.dev>; Sat, 28 Feb 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772291090; cv=none; b=R3btkN+gj0ocXJm/hY9yNT6gvKPrmTbxteOUz3tMTHtk4+SBR2zqtEZg7iBrMVd6zyYPTQ/A/wXCDqdptHD2cnP+9nEmC11uZav2iiR0CK3QOeCtVvbQf0PEWFeEZVNrdintyBkElgtFhF0EGi/wnlI7tGO7kPCzRmaBLEMwjxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772291090; c=relaxed/simple;
	bh=SdKoZ3P29SBChdW2+DAlKUHQS957CCriW5kGfebxdJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rBFMaH0AE8zM9kvGWR86cQMKFK4qBRs4LaZUa3lDpmovuHIWUu9yyYdNqlGFHEjZFOrmPrdVaqCcNeg+p4AAbC3ScYBt6zg5tmfpIzT5XKK3PLh0udQbsl2JCT/oJqc9/hDjiBYC/VOJ2qsNA9/TCR2AFXVFtwYQ6Hda9PZ5qYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C1Qov9MJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C1Qov9MJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772291088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zx/41eGZi0CJBh+Og8Z1FttBS/rIdtUYQz5ebE6xc1E=;
	b=C1Qov9MJYH58L1DOZ+5r8pIpA25LuoYo/9PHiiwDiMydpbC7/SUVEHcNsGWdgNgOM3yTPE
	nCTAlShPdHkryfz+7zMHI+iBEVUdox65iukJ9kBhG+NV6EuytqtrseHlAiwkDGmVplGj3b
	yzGVo8bV/OguKLLxZM5psPFoEOOPAzc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-UWc8fji7NFuPxSsTopQyrA-1; Sat, 28 Feb 2026 10:04:47 -0500
X-MC-Unique: UWc8fji7NFuPxSsTopQyrA-1
X-Mimecast-MFC-AGG-ID: UWc8fji7NFuPxSsTopQyrA_1772291086
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4376e25bb4dso1749415f8f.0
        for <kvmarm@lists.linux.dev>; Sat, 28 Feb 2026 07:04:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772291082; x=1772895882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zx/41eGZi0CJBh+Og8Z1FttBS/rIdtUYQz5ebE6xc1E=;
        b=WBaIPXmBOKzItaMnRHVseEqVIT0vslVVnzlBeBY42fVt/ZAqmDhYxSN32Cbw0u8Z3R
         GOIm2hKgTPOmmS0NsRb9SOtg96mVqckXDMdZog/69GgFRWdVaHqtSEvjUW+WqJORcESX
         pF6iJBdtNW7azB7XpdYZ2UhQh2Xs6gZwlk3FmfSNXu2jSm3kf/CG1oC2kppYSu8yS1iv
         W+Z+uK3+TldG6CclwYxfZ0yLhPZiPTgxpEA2NF3CVzUUf6A89xhITgeYUy4mbi+DRMit
         8QIcVRVeuCY/v+3A943cmFgLnWM4vJXec+84qGglywWymB3rYm3i2FMHf8cvtG++9v0i
         Z8tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDqAG9/9Ot0MSIti76fMaPYWACkW55Jaug+udMC6gGdROqQahs0mv4yV2nWEEi0sC6rvDlFVs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDJjaklYgVtl64ZQ4C8lale855oOhWYIVR2O7z6hsV7M96CZnv
	jRaYVpUcWGfg87VWOK63kZiX47k7LYfl/MyGm5qrHXvKE31aryKF3QkOmhoWKC5cCmBflnNfedD
	oqC4kUMV6EATkX+Iz+9+SfatkpgKGz5rP7xUw8qRLCm1Fv2u5Vedl3y7GN7YhAurmGj16ThrCzI
	jBTR6xtIFFDg+7Ccx9rNm2SrqqQ9tPIzxq
X-Gm-Gg: ATEYQzyLZz+voHSe4/T5TIHjBeU2eX+Ff+nlXT7mBb0s4QuiXNHT9jx6N3I1GAMFygD
	XXwtbgRAfusRc/iqJ5QcjOQItP+q7G9GgayJSIEG0E+vVICIpT9yYcDPAt/R5ehvj0gNfHg5zAI
	catV4B4Y9tKD9J46UPkk7Y0l5M/krOwcPm5ECchp1ka6aAzBXYUvEdH8HHCqxH5rjNUcBc/UThu
	viFRSkSHvKXQbsDOZhQqQstDlY/ry0bv/fZg6dUBYAiEGUD5NFy8xdgRZSc7M5fZjx1YqZYLKnL
	xiWrBPM=
X-Received: by 2002:a05:6000:26c6:b0:435:faa5:c15e with SMTP id ffacd0b85a97d-4399de28393mr11435489f8f.30.1772291081986;
        Sat, 28 Feb 2026 07:04:41 -0800 (PST)
X-Received: by 2002:a05:6000:26c6:b0:435:faa5:c15e with SMTP id
 ffacd0b85a97d-4399de28393mr11435430f8f.30.1772291081553; Sat, 28 Feb 2026
 07:04:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260226105048.28066-1-maz@kernel.org>
In-Reply-To: <20260226105048.28066-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 28 Feb 2026 16:04:26 +0100
X-Gm-Features: AaiRm535mUPGGS-9UDvB7slsNDUQ3q2gpNPHAuAWbj3L_0kYm4R6oOTjJd7rRXg
Message-ID: <CABgObfZ=4+MwQt1axbAeDsstRUOi3nemmiXndV51POgMw7u=nw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.0, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Kees Cook <kees@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Sascha Bischoff <sascha.bischoff@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5QzTrEwfUz1aPZFwHyVx7F3YO2fAv0wQhLoWWQBaHcs_1772291086
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 26, 2026 at 11:51=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's the first set of KVM/arm64 fixes for 7.0. Most of it affects
> pKVM (feature set, MMU), but we also have a GICv5 fix and a couple of
> small cleanups. Details in the tag below.
>
> Note that there is a very minor conflict with Linus' tree due to Kees'
> patch having been applied to both trees. Whatever is in Linus' tree is
> the right thing.
>
> Please pull,

Pulled, thanks.

Paolo

>         M.
>
> The following changes since commit 6316366129d2885fae07c2774f4b7ae0a45fb5=
5d:
>
>   Merge branch kvm-arm64/misc-6.20 into kvmarm-master/next (2026-02-05 09=
:17:58 +0000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.0-1
>
> for you to fetch changes up to 54e367cb94d6bef941bbc1132d9959dc73bd4b6f:
>
>   KVM: arm64: Deduplicate ASID retrieval code (2026-02-25 12:19:33 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.0, take #1
>
> - Make sure we don't leak any S1POE state from guest to guest when
>   the feature is supported on the HW, but not enabled on the host
>
> - Propagate the ID registers from the host into non-protected VMs
>   managed by pKVM, ensuring that the guest sees the intended feature set
>
> - Drop double kern_hyp_va() from unpin_host_sve_state(), which could
>   bite us if we were to change kern_hyp_va() to not being idempotent
>
> - Don't leak stage-2 mappings in protected mode
>
> - Correctly align the faulting address when dealing with single page
>   stage-2 mappings for PAGE_SIZE > 4kB
>
> - Fix detection of virtualisation-capable GICv5 IRS, due to the
>   maintainer being obviously fat fingered...
>
> - Remove duplication of code retrieving the ASID for the purpose of
>   S1 PT handling
>
> - Fix slightly abusive const-ification in vgic_set_kvm_info()
>
> ----------------------------------------------------------------
> Fuad Tabba (5):
>       KVM: arm64: Hide S1POE from guests when not supported by the host
>       KVM: arm64: Optimise away S1POE handling when not supported by host
>       KVM: arm64: Fix ID register initialization for non-protected pKVM g=
uests
>       KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state(=
)
>       KVM: arm64: Revert accidental drop of kvm_uninit_stage2_mmu() for n=
on-NV VMs
>
> Kees Cook (1):
>       KVM: arm64: vgic: Handle const qualifier from gic_kvm_info allocati=
on type
>
> Marc Zyngier (2):
>       KVM: arm64: Fix protected mode handling of pages larger than 4kB
>       KVM: arm64: Deduplicate ASID retrieval code
>
> Sascha Bischoff (1):
>       irqchip/gic-v5: Fix inversion of IRS_IDR0.virt flag
>
>  arch/arm64/include/asm/kvm_host.h   |  3 +-
>  arch/arm64/include/asm/kvm_nested.h |  2 ++
>  arch/arm64/kvm/at.c                 | 27 ++--------------
>  arch/arm64/kvm/hyp/nvhe/pkvm.c      | 37 ++++++++++++++++++++--
>  arch/arm64/kvm/mmu.c                | 12 +++----
>  arch/arm64/kvm/nested.c             | 63 ++++++++++++++++++-------------=
------
>  arch/arm64/kvm/sys_regs.c           |  3 ++
>  arch/arm64/kvm/vgic/vgic-init.c     |  2 +-
>  drivers/irqchip/irq-gic-v5-irs.c    |  2 +-
>  9 files changed, 81 insertions(+), 70 deletions(-)
>

