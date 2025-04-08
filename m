Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797E12676DE
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 10:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744106519; cv=none; b=ZZFDylSig5aX+0dysqilr71+DjpnI1UtvR3sqqi2rj2drcdCb5k9KV1po1RhC6an2/miif/vSP17rvYjobh1fwarO/EsCjc4kbj1nP19HGJkx+F8IU7kbMm+8gDp+AF8aACvcj3an5Ra4kbq6PPdp7Yrt0QAb2SZ9Q1YakZgTEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744106519; c=relaxed/simple;
	bh=ZzsMlsyKkY/FXG3dji+XPdROB7fvB/OQJhZ1N6j73bk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OP/LbZhzyqggNy72Tv1mDLx572eDbiq/OM1DJDNLZWUMWeSysin98eoJKRB4j9xU7Xpl8niG0klX7Him1GNGo/KGuO3V+BGp4VQSPgiUZQbTUp+Kc+ykkGc4iHT9Wv7cPSYwHbRc9UuqzxzUK77GJLdlPeEXhXdHOEadw1VsPao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hf2oWxQq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hf2oWxQq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744106516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S7vwRWv9mWbyZzeYPX5lAQ7x95n9IfuU+PqoLw+Ao0U=;
	b=Hf2oWxQqETyy0yOviwH/XOxfCZAYnCCNYSzKxcIU3lU3K1kZ1Vm2sXSmvtGiPWqP+evPE4
	q/SiCohtTd03tY4Pb6XZaE3G8xMKguUohxpbhqZlft/0n1gJwnIa9CaYmM2GUd2lVBHgPR
	Z6QWmMZ5JbEke3Cu48Cx14fN6DxgL7Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-snbyz11jO32b8yd_7FGDZg-1; Tue, 08 Apr 2025 06:01:55 -0400
X-MC-Unique: snbyz11jO32b8yd_7FGDZg-1
X-Mimecast-MFC-AGG-ID: snbyz11jO32b8yd_7FGDZg_1744106514
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-391315098b2so2256943f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 08 Apr 2025 03:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744106514; x=1744711314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7vwRWv9mWbyZzeYPX5lAQ7x95n9IfuU+PqoLw+Ao0U=;
        b=pbXXjFKD762QxnLSmh5NLpwvpkwCCZUd2ZnSyn1SXn+BQGT6KGGQIoIINMBPXnzFOh
         CKWdLzhIQPhKZjoMsLZrblAVZS5i1tuOy9I9qtA9YgUaz1wZ7T6fvT199rP40ayfW0+d
         ksQCBbWcnbmYq/3ZwaYy/xYVgT+2m1xno7//Y/eHB08hoWgtYwuzK5fkGLnbRU3qTbJq
         LRkqc3MJG7cYVAz5Mx0CgzoDcQhbt+u+x6K5IAYVrWKoaRRpEX6WsqGNJT5X7vLp2e14
         +ctE19Fy81JIDiGgjiKRmbTJ+bdAktKBfLB+TE4ExUZY2pI1d8klEuZsbADdWmkRTkih
         LJbw==
X-Forwarded-Encrypted: i=1; AJvYcCWczRX2+x8wnz2Rp+4BoVdwFi5fm/t1T2i9mIIPSjeuEsDJBbmrYGjBuz/WbZwaTSvw17q9nHI=@lists.linux.dev
X-Gm-Message-State: AOJu0YykG5SKviQ4IrAfUVHPvc/x97z+BSWB/5ObqcRxrHT037wlHNtW
	rMvMbYouUSd11pP9UWPWDT5tidA1JuMt7pPdII6NEy68ykPdxDgXz6Y7Emk+RaEZ3npg5f0pRMG
	FQ+PhCKszvcaDigzBwm+TuDzhEip2sUWr43ouHk5U9xQ3sV9E0M206YY4O4qELZDP6ErzDOmVvR
	8DqLwvryJizfFWiKuubIPpzg10hG3F
X-Gm-Gg: ASbGncuV83SV3jcEf0gpFlpC2WeEJvogyasZ41NHSxatyTKsjt3958KTI+F179CsooC
	11q8KrgRh616p0uexjvzldVIzGKFE79Q3DvnE2FcJUSyWZfaq6iBj4XwGo8lomFN1wiXECapjLw
	==
X-Received: by 2002:a5d:64ce:0:b0:39c:1f19:f0c3 with SMTP id ffacd0b85a97d-39cba93ce4amr13910548f8f.46.1744106514083;
        Tue, 08 Apr 2025 03:01:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPdD0tZMwUQ1u2VI+ko0QS55Uf8DUI0x6WFuvmtj4nnFQtbx6GDlEiPL4bsRPPHCMMyvA9zIosiuYwmKcEKPs=
X-Received: by 2002:a5d:64ce:0:b0:39c:1f19:f0c3 with SMTP id
 ffacd0b85a97d-39cba93ce4amr13910507f8f.46.1744106513573; Tue, 08 Apr 2025
 03:01:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z_RubCEp4h7sAdjz@linux.dev>
In-Reply-To: <Z_RubCEp4h7sAdjz@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 8 Apr 2025 12:01:42 +0200
X-Gm-Features: ATxdqUEbr6laVVTyQ97z66VXBohS7bVQNuTHIjwemR8RnZR5JDOIXKkUoe4bM9k
Message-ID: <CABgObfa+omBgaJqEtr1Xi3bXZDR5xtA2Emko0p1SqeBNxFRiFA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64: First batch of fixes for 6.15
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Will Deacon <will@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y5u3Sau1PtQgpaRdYpVJW911TiFgPqKO0vp-QTkm3ps_1744106514
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 2:32=E2=80=AFAM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Paolo,
>
> Here's the first set of fixes for 6.15. The biggest change here is the
> __get_fault_info() rework where KVM could use stale fault information whe=
n
> handling a stage-2 abort.
>
> Rest of the details can be found in the tag. Please pull.

Done, thanks.

Paolo

> Thanks,
> Oliver
>
> The following changes since commit 369c0122682c4468a69f2454614eded71c5348=
f3:
>
>   Merge branch 'kvm-arm64/pmu-fixes' into kvmarm/next (2025-03-19 14:54:5=
2 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.15-1
>
> for you to fetch changes up to a344e258acb0a7f0e7ed10a795c52d1baf705164:
>
>   KVM: arm64: Use acquire/release to communicate FF-A version negotiation=
 (2025-04-07 15:03:34 -0700)
>
> ----------------------------------------------------------------
> KVM/arm64: First batch of fixes for 6.15
>
>  - Rework heuristics for resolving the fault IPA (HPFAR_EL2 v. re-walk
>    stage-1 page tables) to align with the architecture. This avoids
>    possibly taking an SEA at EL2 on the page table walk or using an
>    architecturally UNKNOWN fault IPA.
>
>  - Use acquire/release semantics in the KVM FF-A proxy to avoid reading
>    a stale value for the FF-A version.
>
>  - Fix KVM guest driver to match PV CPUID hypercall ABI.
>
>  - Use Inner Shareable Normal Write-Back mappings at stage-1 in KVM
>    selftests, which is the only memory type for which atomic
>    instructions are architecturally guaranteed to work.
>
> ----------------------------------------------------------------
> Chen Ni (1):
>       smccc: kvm_guest: Remove unneeded semicolon
>
> Oliver Upton (4):
>       smccc: kvm_guest: Align with DISCOVER_IMPL_CPUS ABI
>       KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid
>       arm64: Convert HPFAR_EL2 to sysreg table
>       KVM: arm64: Don't translate FAR if invalid/unsafe
>
> Raghavendra Rao Ananta (2):
>       KVM: arm64: selftests: Introduce and use hardware-definition macros
>       KVM: arm64: selftests: Explicitly set the page attrs to Inner-Share=
able
>
> Will Deacon (1):
>       KVM: arm64: Use acquire/release to communicate FF-A version negotia=
tion
>
>  arch/arm64/include/asm/esr.h                       | 44 +++++++++++++-
>  arch/arm64/include/asm/kvm_emulate.h               |  7 ++-
>  arch/arm64/include/asm/kvm_ras.h                   |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/fault.h             | 70 +++++++++++++++-=
------
>  arch/arm64/kvm/hyp/nvhe/ffa.c                      |  9 +--
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  9 ++-
>  arch/arm64/kvm/mmu.c                               | 31 ++++++----
>  arch/arm64/tools/sysreg                            |  7 +++
>  drivers/firmware/smccc/kvm_guest.c                 |  4 +-
>  .../testing/selftests/kvm/arm64/page_fault_test.c  |  2 +-
>  .../selftests/kvm/include/arm64/processor.h        | 67 ++++++++++++++++=
+++--
>  tools/testing/selftests/kvm/lib/arm64/processor.c  | 60 +++++++++++-----=
---
>  12 files changed, 234 insertions(+), 78 deletions(-)
>

