Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CFC39A807
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 08:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278321; cv=none; b=lTd9zKTpbgX7n7sqyI+9iLE3YZnS0NSUUVwJrN5641eJUQnpqXXSpIz815DoxUV57+qE4csfZEFOdVZOWHvF8O0hLplec+LgiHiic7Wq2AC1U0SOcVVH4x5dWoWkNV2nreHxTILc6piWw3Fo5cGQlNiLyfea606u9C4rUU2yZxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278321; c=relaxed/simple;
	bh=DP0xPFCiQhucJ/Dny2Ys1P7F6Dt30IATMKjguKpLelE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HQg7CrMowgnBV01lNNeRgTora57naail0Neb9WzWZ07PeMVxIAPKLqrpiAUENXUusVyyPvCYFFU8333Sy3m8eO1KY/mOKc0vjNFHd4F7GfQ/UdDbl08h6tQvAcjmKoVx4gxaKlkCYR7dQB7EFw92T9805RA6fbZE+v/mIaOzCtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WhJICaba; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WhJICaba"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777278318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xaAdwH/ZvqVlM3qFB/XtL+Aj8QOREix0lRLn2M7hBA=;
	b=WhJICabarKVkFaH55TDW0G4KtCHrcoMoOus1ugNRjM9JbwH/NaUVajKkN6dqQNazFJUCJt
	FMGOFiI6x27wMMvy+t2DxVyc+jMhrtbb9IWGyJq6V4+oY6TKhbk7bwT9/pf0AhyoLoVGzl
	T+Xh85W0oBZ58v/Sg8R8KoHHZIp5WLo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-gO1nCCk8N72hnq9Gsu8mGQ-1; Mon, 27 Apr 2026 04:25:17 -0400
X-MC-Unique: gO1nCCk8N72hnq9Gsu8mGQ-1
X-Mimecast-MFC-AGG-ID: gO1nCCk8N72hnq9Gsu8mGQ_1777278316
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4362197d1easo8135913f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 01:25:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777278316; x=1777883116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5xaAdwH/ZvqVlM3qFB/XtL+Aj8QOREix0lRLn2M7hBA=;
        b=dUJbMgoHQR99x1Rm6hkQ78G4vBogdQHV06FKl8Wo3UWtfMNxAtQmSvXVtmnFnpFqLz
         6tkC/Y9Q+nn3s+RGkRsLU37UrtsaG0PE3eWqu0Q2bCkjESfi+cZm/GmlSDnyBHNdJPEb
         sFrwmKz/6RYOkfn2d7oFJJ2MW177NnbhDSfHfdFLya9vhyPbRevyNRtTNxTLdQREimSQ
         7au51QIgNE7s8tV86zAzTDmJDtmHBssa57GG8VqItXR1J+iYOm4/p4Em1Cyh6dhuFauV
         E/FHudYJG1sqJ4lyPunQKP9EfmDOaExqI9cO40EeEzDWne9tmG3JDCXpRbu73QViEa0f
         ezGA==
X-Forwarded-Encrypted: i=1; AFNElJ/7xnUB0Ee8MeKzJnSV8hJtv8miDsmmJpy2/tZPsIyNKtatHj1sSB6hYu9gq40Mjo6m9U0qgQE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzkIub2eHZO3pWnDgg/GdF5rP446reBlKBIQyRl1WyBkHwIWIGw
	0GM/y+WbOhQRmr8Is5g25c00dXTk66bmKP8xtcz3U2Ymwy6xAc5BUhips6MfB2KMTfq5bUFzSSn
	3K/2pYFKKOkiNipG2WAxN8m4S1k5vkCvnvMPAkgthT1ttDZi6QU/X/17fwF1Gh6FdsTpOJdgeMm
	FwMoXotfaYlDlqX3ebWqw3hBzpdo38s+8y
X-Gm-Gg: AeBDietHQWtihU3edFd4H2Q3Sm34WYTecE0S4E6osNny0KzwRxSiA0iXaKIsU4UFCIt
	zjRQYGFhJmJMCt45VP6LV6mgJYYRTkiUPFsyRUG1LKGqBakeDdHFyc6o1+ZnGASGYfvtr2dexXC
	0GBCt6DOct4ut+051DY4/boY7W3bkFlKj/YacUmzDUdAkn1lQAm6nBvOV2Vmyvv5XVFMIqypxfC
	hecBGXqG0Tena9BjD8roDpmOCzC8j9aXO/L/RcPUG0BZ/MoycndzLrhdT4B4rFSWk1qcqtIE4sD
	Lmkz8XUBGO8huGA=
X-Received: by 2002:a5d:64c3:0:b0:43f:e266:4c9c with SMTP id ffacd0b85a97d-43fe3db2e62mr64527663f8f.3.1777278315534;
        Mon, 27 Apr 2026 01:25:15 -0700 (PDT)
X-Received: by 2002:a5d:64c3:0:b0:43f:e266:4c9c with SMTP id
 ffacd0b85a97d-43fe3db2e62mr64527575f8f.3.1777278314785; Mon, 27 Apr 2026
 01:25:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260424151443.750077-1-maz@kernel.org>
In-Reply-To: <20260424151443.750077-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 27 Apr 2026 10:25:03 +0200
X-Gm-Features: AVHnY4LX4zIbvkokFvwRe85hWW9vU3Mi4qKP1vkFGw7_g8t-wfUHl7-fG7neYpg
Message-ID: <CABgObfaBf8NMM_vNKy5gPamp1gbsT7CEv=SA2X9yQ10gekgMXA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.1, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Ben Simner <ben.simner@cl.cam.ac.uk>, David Woodhouse <dwmw@amazon.co.uk>, 
	Fuad Tabba <tabba@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gBwwOWrR9chRjjVD5bj2K52LCp4rlETMol6JssP6zmE_1777278316
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 5:15=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> This is the first drop of KVM/arm64 fixes for 7.1. Nothing really
> major so far, but a rather wide range of fixes for idreg handling,
> long standing regressions, SMCCC compliance and more. Add a few
> cleanups to the fix, and that's about it. As usual, gory details in
> the tag below.
>
> Please pull,

Pulled, thanks.

Paolo

>         M.
>
> The following changes since commit 94b4ae79ebb42a8a6f2124b4d4b033b15a98e4=
f9:
>
>   Merge branch kvm-arm64/misc-7.1 into kvmarm-master/next (2026-04-08 12:=
26:11 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.1-1
>
> for you to fetch changes up to 4ce98bf0865c349e7026ad9c14f48da264920953:
>
>   KVM: arm64: Wake-up from WFI when iqrchip is in userspace (2026-04-24 1=
2:03:57 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.1, take #1
>
> - Allow tracing for non-pKVM, which was accidentally disabled when
>   the series was merged
>
> - Rationalise the way the pKVM hypercall ranges are defined by using
>   the same mechanism as already used for the vcpu_sysreg enum
>
> - Enforce that SMCCC function numbers relayed by the pKVM proxy are
>   actually compliant with the specification
>
> - Fix a couple of feature to idreg mappings which resulted in the
>   wrong sanitisation being applied
>
> - Fix the GICD_IIDR revision number field that could never been
>   written correctly by userspace
>
> - Make kvm_vcpu_initialized() correctly use its parameter instead
>   of relying on the surrounding context
>
> - Enforce correct ordering in __pkvm_init_vcpu(), plugging a
>   potential pin leak at the same time
>
> - Move __pkvm_init_finalise() to a less dangerous spot, avoiding
>   future problems
>
> - Restore functional userspace irqchip support after a four year
>   breakage (last functional kernel was 5.18...). This is obviously
>   ripe for garbage collection.
>
> - ... and the usual lot of spelling fixes
>
> ----------------------------------------------------------------
> David Woodhouse (1):
>       KVM: arm64: vgic: Fix IIDR revision field extracted from wrong valu=
e
>
> Fuad Tabba (5):
>       KVM: arm64: Fix FEAT_Debugv8p9 to check DebugVer, not PMUVer
>       KVM: arm64: Fix typo in feature check comments
>       KVM: arm64: Fix FEAT_SPE_FnE to use PMSIDR_EL1.FnE, not PMSVer
>       KVM: arm64: Fix kvm_vcpu_initialized() macro parameter
>       KVM: arm64: Fix pin leak and publication ordering in __pkvm_init_vc=
pu()
>
> Marc Zyngier (2):
>       KVM: arm64: pkvm: Adopt MARKER() to define host hypercall ranges
>       KVM: arm64: Wake-up from WFI when iqrchip is in userspace
>
> Quentin Perret (1):
>       KVM: arm64: Fix initialisation order in __pkvm_init_finalise()
>
> Sebastian Ene (1):
>       KVM: arm64: Reject non compliant SMCCC function calls in pKVM
>
> Vincent Donnefort (1):
>       KVM: arm64: Re-allow hyp tracing HVCs for [nh]VHE
>
>  arch/arm64/include/asm/kvm_asm.h   | 28 ++++++++++++++++++----------
>  arch/arm64/include/asm/kvm_host.h  |  5 +----
>  arch/arm64/kvm/arm.c               |  4 ++++
>  arch/arm64/kvm/config.c            | 23 ++++++++++++++++-------
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 30 +++++++++++++++++-------------
>  arch/arm64/kvm/hyp/nvhe/pkvm.c     | 38 +++++++++++++++++++++++++-------=
------
>  arch/arm64/kvm/hyp/nvhe/setup.c    |  6 +++---
>  arch/arm64/kvm/vgic/vgic-mmio-v2.c |  2 +-
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c |  2 +-
>  9 files changed, 86 insertions(+), 52 deletions(-)
>

