Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08023330B2E
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682834; cv=pass; b=nL8ALdsg3TV3CqAbKfGzmAidIxWbpFVOBqsUGA1BBvrbinW70l3jx3jhpXQYjpTAuNUMyyugXurawbbbblpUxymZyUoxVo0ciw/zjvrgPtMmWH2lR7o9mnrXzgA2CHIKe+ZWT3ftCcJumFSdlcOfzMchkNm+oQZ4gS2MlDyzgkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682834; c=relaxed/simple;
	bh=DGzVcna+YZoIrSiQKxzXzqmC/BL0oS3xfFoJRzhycH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=JGPvyQEGdTtzQn2AQcfWB7VUgqi2nnFQjLzV0O9e/NLG/ViXuYYR6cVUqbSpNGCTUgJIqeNJCy5mnwrwV9fLJvE/wFaUwuDpTpkOwoZ4QJ7/dk09igAZHACQH5eISiCDs3aC+EsCsdBomKD6pR8Z1VAzyca6BL6v3OZJmLvPuuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PXKtL2eq; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PXKtL2eq"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-509069a7a7fso62851cf.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:40:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773682832; cv=none;
        d=google.com; s=arc-20240605;
        b=YpnQIoLNe8hHPR3zIPvqRzhVHkptQSndPjjrTsmABJ/wi8zMo9idlSqBa72vgsILM0
         I0LqoFYWbIDBwWaPeTbHSSNWDP03f7GilgXbGi7Te3igD1sGsEe4BwCiiyCa0rvzINRd
         h3XftsC2Nk+K2w4xEwWGdjaLjJCtXbqS+/Y9hkOhAq6hBZ4QzpNfRPWSqOVLvG29H0V+
         0vmuJ7GjQH8pNiT1CvzlYhKRjMlHKIeBtVmUdKdn+sMUvM0HT4PLyu6ZaZQOuwu4/DRR
         ucXZAUmV1X+QNL8nhmqnckhACjTc4uPRUiBG6lqT7DVbDJOoJNloBK4eTq48fUpD12yy
         a7xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2B/Hw24N6OrkUr4MKnYANAo96l5CjLsjEOK0CMTu1R8=;
        fh=rWKU4KWcE+vJrVHirs2AdKbVjnPM8AWp6mdoObryan8=;
        b=VzkoEMv8hiY1Zs7ukwQfvdDXnOsVIb3AdLVzXb1o2+iJHWWGlxQbuqJo7kR4zNtUBx
         +BVOBdqL12JSor4/Wn8sp5KoFBNGaVjtvNnnGonqFEci/E9Zi4z1LbShGNYM6/UtewvF
         QQy7qBz8fI4ZnGARm9YXUuhU4RcGy+gdQRvGqVxeKfM4QDeXk80zYXSkbO1ohIN4bEtQ
         E3w2G+f2Q96ob60l1ycO2ByOGhq7wTokJJx5uM9V/ePS29yMdPZAvYhYkydeMgFB92h0
         FKzV7fNT22ONVKCaUvQkeCSAZpDRibpvlFogWqEadFyiP88p7CEN4q2dFfZiowa0qPvp
         S7fw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682832; x=1774287632; darn=lists.linux.dev;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2B/Hw24N6OrkUr4MKnYANAo96l5CjLsjEOK0CMTu1R8=;
        b=PXKtL2eqhrq58UkeQhIAQzf9v4QOrxrHGfm2C+3vNfpGIBZZGl9UkhANGXbi9G7bgF
         pZCxJz9CjxeMphmAWRRQTdJF8VQErr6pAX+wV6lUtNyVqo+Y/p9iZkvQyTwoRVLSWyaL
         39g/y/bCnc5bUKUJRGDn8jMO6XpVEcvu1eMlWAAOBHzR5oq3/ezNkkxQ4cmvWzyKM3Lw
         ywFI0JezQ3gFVSCFPVJ/L5HkxR9el42vLAw5K0TFd5CHGGHHkVNz4HzI6zWCT59pAPNc
         jqnbTeiPx9Hceh/TqQnB9Js5o+NCOQrMyoydM4ySWBbvyddjlOjK+6nfWbGJiqbX7BLc
         ZI+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682832; x=1774287632;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2B/Hw24N6OrkUr4MKnYANAo96l5CjLsjEOK0CMTu1R8=;
        b=biT+SzsqaXe2yBtnLd/nyXKiBG+AAeB0cuGeudAOSPHBD1TRmNr3A1TJes1CizOL1T
         ErFQeUPTLxAa5oHgXQMW0wxi3dMRNPfxHXaEgob1B8SjmUBJIZGzHNVI82N2Vgzx5WLY
         lx7I7A7JAgfhwS1YszMgC5qFN02SswV1f2e0I+Py+8nfO0My05kpG6M4Ndkh5ZjWMSv9
         Df1h4+oc9NKlbxjLAD0Tb5OPOWh67gjxSWXfzEdg07jq64YCCQ1kCECuELzfd4fsKRCq
         IiLymFlSG7hf93ZvQLtU78pDSxSis5GfxKMF7QD+wN0evGyd6AtaguYplro4ar359TMR
         rckg==
X-Forwarded-Encrypted: i=1; AJvYcCVOEE4fY/XQhKQbdUNacQkYl8zhGq4KwRPltIRvbHJ7bFGl8NZeQUAePo544q7FY4ySTrhw1yA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yydf1Q7LakziVvNYVF0PXzDxlQNFnEh2IJ47IDuFzkAlLCVDnvd
	kdbkrBTEkGNcNNzopw3+hLUH208ChdmlFc54AI06vRkkk76r27HjwkQilb7mbgkQwrhacOBvDyb
	Gb7d8qO2pJonKkaWDdmUMCkIMChY5ptWC1BEBqQuJ
X-Gm-Gg: ATEYQzxqbalnaZlyLh2VfJcqaN6/qQ9K4O2jWZ8n1xmfJR5zZFWRVf3lfOCwSalMckx
	iroQ1kHWnR5M0hzLcCMOLQjuhbN1/69zS0iU/7qQi55duDdoRiiXCzaUNnwAlXCO4t/sCInXJGT
	9jhS7TH9kzT6BZVhtyAqfRMPDaR/WX2ctxRhghwNx6SHuLZdavY4slxJOETUsYdKbyfRyV4V5mz
	ylM4eBI/Hq3zZc7GSSfkmFNyo6nixicDxkxSYEdA9oSMI3z92o6JxVsWbP0C2rOurCegu5tf2h4
	ENMXFbz0
X-Received: by 2002:a05:622a:19a2:b0:506:9852:75ec with SMTP id
 d75a77b69052e-50998e55e96mr506131cf.9.1773682831265; Mon, 16 Mar 2026
 10:40:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 16 Mar 2026 17:39:54 +0000
X-Gm-Features: AaiRm51MmyCvtm_bSDH6RlSuyxS1mhei1yUIraU7TS88YvROq1cCmUBLQf9Svp4
Message-ID: <CA+EHjTz6yJeEj4NT3N7iti03HruaTncKuAiwxR7nqkp=twgAHw@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: arm64: Adopt scoped resource management
 (guard) for EL1 and EL2
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi again,

On Mon, 16 Mar 2026 at 17:35, Fuad Tabba <tabba@google.com> wrote:
>
> Hi everyone,

This was my first time using b4, and I thought it would strip the
Change-id's, and this was supposed to be a "reflect" run, but
obviously something went wrong there :)

Other than that, this series is ready for review. Sorry for the Change-id n=
oise!

Cheers,
/fuad

>
> I stumbled upon a lock leak while reviewing Sebastien's recent GIC Harden=
ing
> series [1] on an early error path. It reminded me that we've run into thi=
s exact
> kind of bug pretty often while working on pKVM. Since we're going to be
> hopefully upstream even more pKVM code soon, I'd like to try and fix this
> pattern once and for all.
>
> This series refactors a good chunk of KVM/arm64 codebase=E2=80=94covering=
 both the host
> at EL1 and the hypervisor at EL2=E2=80=94to use the guard() and scoped_gu=
ard() macros
> from <linux/cleanup.h>.
>
> By tying our locks to the scope:
> - We can safely use early returns (like return -EINVAL;) without accident=
ally
>   leaking locks.
> - We can get rid of a lot of tangled goto exit labels.
> - Reviewing patches gets a lot easier since we don't have to mentally tra=
ck lock
>   states across giant functions.
>
> A common concern with these RAII-style macros is that they might bloat th=
e
> generated assembly. However, looking at the compiled code, it actually do=
es the
> opposite. As an example, looking at the EL2 object file
> arch/arm64/kvm/hyp/nvhe/pkvm.nvhe.o before and after this series:
> - Instruction count: Dropped by 39 lines of assembly.
> - .text segment size: Shrank by 166 bytes.
>
> This happens because the compiler no longer has to generate dedicated bra=
nch
> targets for exit blocks, nor the stack frame unwinding jumps just to call
> hyp_spin_unlock. It just efficiently inlines the unlock instruction right=
 where
> the return happens.
>
> The series is split into two parts:
> - Patches 1-5 (EL2): Adds the DEFINE_LOCK_GUARD_1 wrapper for hyp_spinloc=
k and
>   cleans up the nvhe/ directory.
> - Patches 6-10 (EL1): Cleans up manual mutex_lock and spin_lock calls acr=
oss the
>   standard KVM host code (mmu.c, arm.c, psci.c, reset.c, pkvm.c).
>
> There are definitely other parts of the KVM codebase that could benefit f=
rom
> this (especially the vGIC), but I'm stopping here for now to see what eve=
ryone
> thinks of the approach before touching anything else.
>
> Based on Linux 7.0-rc3.
>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/CA+EHjTy051kjdReuESmk3HpMsBEW=3Ds3DxhJXa8=
vQJFHz--wG2Q@mail.gmail.com/
>
> To:
>
> ---
> Fuad Tabba (10):
>       KVM: arm64: Add scoped resource management (guard) for hyp_spinlock
>       KVM: arm64: Use guard(hyp_spinlock) in page_alloc.c
>       KVM: arm64: Use guard(hyp_spinlock) in ffa.c
>       KVM: arm64: Use guard(hyp_spinlock) in mm.c
>       KVM: arm64: Use guard(hyp_spinlock) in pkvm.c
>       KVM: arm64: Use guard(mutex) in mmu.c
>       KVM: arm64: Use scoped resource management in arm.c
>       KVM: arm64: Use guard(spinlock) in psci.c
>       KVM: arm64: Use guard(spinlock) in reset.c
>       KVM: arm64: Use guard(mutex) in pkvm.c
>
>  arch/arm64/kvm/arm.c                       |  53 +++++--------
>  arch/arm64/kvm/hyp/include/nvhe/spinlock.h |   5 ++
>  arch/arm64/kvm/hyp/nvhe/ffa.c              |  86 +++++++++-----------
>  arch/arm64/kvm/hyp/nvhe/mm.c               |  37 +++------
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c       |  13 +--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c             | 122 ++++++++++++-----------=
------
>  arch/arm64/kvm/mmu.c                       |  95 +++++++++-------------
>  arch/arm64/kvm/pkvm.c                      |  19 ++---
>  arch/arm64/kvm/psci.c                      |  19 ++---
>  arch/arm64/kvm/reset.c                     |   8 +-
>  10 files changed, 182 insertions(+), 275 deletions(-)
> ---
> base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
> change-id: 20260316-tabba-el2_guard-2f7e3fa06f69
>
> Best regards,
> --
> Fuad Tabba <tabba@google.com>
>
