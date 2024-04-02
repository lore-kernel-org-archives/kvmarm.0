Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C4414B062
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 16:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712075202; cv=none; b=YYmqDApDUX0Zhydw6o6rpFGAezzM7fn9x3P+w838hP2Z9LW7myUOdCwf8NfCXmL6oXRZms+Btvg02QksxNQ78U/IqdOEqUrVtw1+D9QgdAl0uMTYnxmzDWF0BEZ/2YqZEY2dHhJiX3UKNFxD68EeazOFXl/bxuoFpJrfL9qAqvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712075202; c=relaxed/simple;
	bh=3Jl3Yz1Oy6YTRF6EccJdpuHPxyjDbAAptzdu3ELlGBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oBVphI6M7w1L4D8zLSXKzl0r4V4eCcIrBHjGSRu/F0a3oo5vj5VeRGzdM9rnZKmaPL/vKt4CADINGIH5FEBAfxMg4CP0WCmHW37+tB24rQ8r0/P6mS7SZBCe8hr9kXuqxSmrpsA2w4vnBzxqgxuG6OGyrsfAcSrWT5fOebKpW4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WiulLA45; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WiulLA45"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712075199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nfya0XqLjDIkZU61E28MjHAOQnpGGQegnLSefoc+snI=;
	b=WiulLA450LyMiDWLN1nsb7PhT4oZXNBvWAXFk4IWk8gFIWcGNZDz3IBCcVRZVxAGgZJmbD
	xyazU6bwgvtvt19CaLtKb08g+GPy74kQxMK1tODfg/CVvlKRUXGhK4sZLX/5HH2FOGmhNS
	3wfGmCe8i/i7GqTC80g7EUnCBzdAcAQ=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-yzCTEDH4NIq_Zhw2i0mNxA-1; Tue, 02 Apr 2024 12:26:38 -0400
X-MC-Unique: yzCTEDH4NIq_Zhw2i0mNxA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-515d1395657so3138992e87.1
        for <kvmarm@lists.linux.dev>; Tue, 02 Apr 2024 09:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712075196; x=1712679996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nfya0XqLjDIkZU61E28MjHAOQnpGGQegnLSefoc+snI=;
        b=RkgbyIN9L3h3inpvIHi47/pO4GFJclAFmALhBJ/lwizd4wogYtwiPfbctRpKPQx5Rw
         xfQ/cOmSScRDmNBIZSAqvGjAOct6QnVcUrXnk1IVXdTPEefvkZkD239AepS4mq9OOyqe
         NXBhLuR8siuOoSgjM2uERdRN4kVg4PY04AdtAk0mwA0ExTNjONab94KXP7cYAt5D+ViK
         9q2rTsGvq9JDHvuvcHoLsReoD4YLJJSEJv+N5ombAeOr35ek+bPLdeRFF0PImp/po+le
         ImAxfIT75H1VYVEmu4oYK/ddNhA/AQ/0V9kp5GvUN8DeTOKb28VY2J1A1sVn24U/0M+h
         uMUg==
X-Forwarded-Encrypted: i=1; AJvYcCVCtI7vO59WS04l2YgogzH5V26KpUZTGprH6igqkXCXHmRsC+BDaRbQJEYMlhLcfaiSM1X9ziQyqFNOFLlQfkqRPrWWeIHK
X-Gm-Message-State: AOJu0YwaGa4jbSgd4rZyGds9yicmiG3GPeiirlXpKFvqv/YKtSXzJnW7
	L9+v3wE6c4TMHFXHBRfPYcmZgBR9D2J8AWfXa8gv3/UgFkz/dvxuNB8qBJhQI/O4bCiEicCK8bP
	b/yeNiBhYQYhQDrCBft7n1r/F44OHTLwzxpzsPkGyLJM7c4ggF9XfWMHGkVWqsMRaXJhCnB85Wo
	cRcERz/peq14qRBIKXI6ljG/a5PvJ4
X-Received: by 2002:a05:6512:4010:b0:515:acdc:fcd5 with SMTP id br16-20020a056512401000b00515acdcfcd5mr10195302lfb.69.1712075196591;
        Tue, 02 Apr 2024 09:26:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4fIR4ifChkyBxcpbQ5BccmNBt6HkOaAt39Q793pgYuKUyyygEdmyaaUbcyhEHk1/jdVPqy4hiifqZPupUJuo=
X-Received: by 2002:a05:6512:4010:b0:515:acdc:fcd5 with SMTP id
 br16-20020a056512401000b00515acdcfcd5mr10195294lfb.69.1712075196248; Tue, 02
 Apr 2024 09:26:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZgtsA88wkIDaKEXk@linux.dev> <ZgupcZjEGLTmed_5@linux.dev>
In-Reply-To: <ZgupcZjEGLTmed_5@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 2 Apr 2024 18:26:24 +0200
Message-ID: <CABgObfb8759GL7NtSY-_s=qcXWQzRko78Wd6NAoDV2K_+7weDA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.9, part #1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 8:45=E2=80=AFAM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> +cc lists...
>
> On Mon, Apr 01, 2024 at 07:23:13PM -0700, Oliver Upton wrote:
> > Hi Paolo,
> >
> > Here's the first set of fixes for 6.9. Several good fixes piled up here=
,
> > partly because I've had limited availability due to travel.
> >
> > Details are in the tag. Please pull.
> >
> > --
> > Best,
> > Oliver
> >
> > The following changes since commit 4cece764965020c22cff7665b18a01200635=
9095:
> >
> >   Linux 6.9-rc1 (2024-03-24 14:10:05 -0700)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/=
kvmarm-fixes-6.9-1
> >
> > for you to fetch changes up to d96c66ab9fb3ad8b243669cf6b41e68d0f7f9ecd=
:
> >
> >   KVM: arm64: Rationalise KVM banner output (2024-04-01 01:33:52 -0700)

Pulled, thanks.

Paolo

> > ----------------------------------------------------------------
> > KVM/arm64 fixes for 6.9, part #1
> >
> >  - Ensure perf events programmed to count during guest execution
> >    are actually enabled before entering the guest in the nVHE
> >    configuration.
> >
> >  - Restore out-of-range handler for stage-2 translation faults.
> >
> >  - Several fixes to stage-2 TLB invalidations to avoid stale
> >    translations, possibly including partial walk caches.
> >
> >  - Fix early handling of architectural VHE-only systems to ensure E2H i=
s
> >    appropriately set.
> >
> >  - Correct a format specifier warning in the arch_timer selftest.
> >
> >  - Make the KVM banner message correctly handle all of the possible
> >    configurations.
> >
> > ----------------------------------------------------------------
> > Marc Zyngier (2):
> >       arm64: Fix early handling of FEAT_E2H0 not being implemented
> >       KVM: arm64: Rationalise KVM banner output
> >
> > Oliver Upton (1):
> >       KVM: arm64: Fix host-programmed guest events in nVHE
> >
> > Sean Christopherson (1):
> >       KVM: selftests: Fix __GUEST_ASSERT() format warnings in ARM's arc=
h timer test
> >
> > Will Deacon (4):
> >       KVM: arm64: Don't defer TLB invalidation when zapping table entri=
es
> >       KVM: arm64: Don't pass a TLBI level hint when zapping table entri=
es
> >       KVM: arm64: Use TLBI_TTL_UNKNOWN in __kvm_tlb_flush_vmid_range()
> >       KVM: arm64: Ensure target address is granule-aligned for range TL=
BI
> >
> > Wujie Duan (1):
> >       KVM: arm64: Fix out-of-IPA space translation fault handling
> >
> >  arch/arm64/kernel/head.S                         | 29 +++++++++++++---=
--------
> >  arch/arm64/kvm/arm.c                             | 13 ++++-------
> >  arch/arm64/kvm/hyp/nvhe/tlb.c                    |  3 ++-
> >  arch/arm64/kvm/hyp/pgtable.c                     | 23 ++++++++++++----=
---
> >  arch/arm64/kvm/hyp/vhe/tlb.c                     |  3 ++-
> >  arch/arm64/kvm/mmu.c                             |  2 +-
> >  include/kvm/arm_pmu.h                            |  2 +-
> >  tools/testing/selftests/kvm/aarch64/arch_timer.c |  2 +-
> >  8 files changed, 43 insertions(+), 34 deletions(-)
>

