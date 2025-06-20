Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B792BDC01
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750439381; cv=none; b=I+RKI8u+HMEBIWePXPGp1RuYLKGOIZj8aCMOLy/XwzThyiXtg79h6fX/cXp6uDhJcRvhnsx212tszPMWkmR9DUH5VRLLH/t/L+13090Aw/W541iVzHrfhdkc/XrudM3G9L3Y/Bg6zA9Ji6j1JZ1lDmRyZAkXW/xf8St8utdfhIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750439381; c=relaxed/simple;
	bh=O1FN+t9jZIBycusZ3Q/T1AKbU3YiywXzYlVXWllgfE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kuU+8JzIj0tLmRnIunuQUBWStW3+vDmNVG4wWGFL9pzdmj67grdQTu+AHbQh4Ngmogz2PUpY92C9pWZugbgvxiSM4mYvahpN/ngpLUDCxgbdIABMyjrrQybj3g7/n9Kn8mqHLnT9R+t9lcBK2JC4xgrXRIUMJxyxsDn662rylzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MTrLYwbf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MTrLYwbf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750439378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M1ekRqR8sclf5kjPGwfD2Er+4fHOBAml7GmI5iGuA8A=;
	b=MTrLYwbfky1IFmoqyYSZsgVnivv6AdVPgz2+sGQyl98/BPrrLirpp5orb+jTya9yfWW0sP
	yxa1CfeQC7QUbbOyRjsvzR8I0S+h36TNeNkv4EIS/V+f0Y7YrXm9R6EBryUy8wZtNKC5dM
	SthsFbQp8RazXlJyO5cvxegEBs1KjgM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-dHW1JEzKNKCimBkuRRcgTA-1; Fri, 20 Jun 2025 13:09:37 -0400
X-MC-Unique: dHW1JEzKNKCimBkuRRcgTA-1
X-Mimecast-MFC-AGG-ID: dHW1JEzKNKCimBkuRRcgTA_1750439376
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4532514dee8so15669785e9.0
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 10:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750439376; x=1751044176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M1ekRqR8sclf5kjPGwfD2Er+4fHOBAml7GmI5iGuA8A=;
        b=eSluXHrch0gkGAJCMzb9ZTWRS2p4XUJHQN1K7Eg698BR8TyLIp56HeEU2Atv9SqQca
         L383MVQ9nbBz4B8bvTH0XtemB65YkDpFqhBM23hTuiF3iior8zZh2ap5B7F2s0jx1uL5
         iRUxYwT2Fht1zBd1cDaPEfjgARhgm4RTfrs0iEn4U1UjMlkFA7VhM79hSWfC6+8chw/m
         PAjBq6qqNFv2B+eOQnwNxN1KXF+BSQe6t5dgNUzkzJdGtYwN44G4jUc6Xpn6A7CxUBuj
         aoW7zXWEE+6biL+w77W6wfCrBtNXixYjJMQH/ZmKnjTR1v9qrL0pHf+tecRlMzTPJN0y
         WNXg==
X-Forwarded-Encrypted: i=1; AJvYcCXjgQoQ/ltMQ3atwE8+dSbHB5wLOgsDqE2jSAncAZBrlBfpfM+V7gVp/g0kqtMsg7B1FSkQIig=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4aLQqdJcSdoo3gKxLn/QXj4C2DiC9n3oSzintWHoCgvUoeOFx
	sZJRu8nTPxdpoy2S2Sb9iWK0ksCUH/Df06k6LsgGe4UgVlA4mpT9Ao9XILYK83uoBQnFzffJrwt
	Caw2YJAqTSogl3Pn55CDggMSrVrplztaWTGSrasSTey+UCaApIrlB2OmPFEX1YDIBbQ7jcVL6jd
	tbietJ/lEa4BUpLgTHG+z/bN0B0qVjTsR8
X-Gm-Gg: ASbGncsPd7Go677ZHp8BKgZEmTEYC7DwtM7su0/proS+Oxu136jzaa/zxAiyLM38Yp3
	/sKWZATFUQfg3oFUZSST8UQ2ObevaKAxIzcfsB2WfdMlo47gX74p6mwab/qu0T+ePejDyYh9Ws0
	mG3Nc=
X-Received: by 2002:a05:6000:481e:b0:3a4:fb33:85ce with SMTP id ffacd0b85a97d-3a6d130cb6cmr3215806f8f.46.1750439375698;
        Fri, 20 Jun 2025 10:09:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIC2N1+6qyCY+73jGybmhqG2lkoyl7bI3OfwoPqdXTWp1p58WQ3hVSE1JBPnpkmVDoWah0q9odmoL6/U/X/s0=
X-Received: by 2002:a05:6000:481e:b0:3a4:fb33:85ce with SMTP id
 ffacd0b85a97d-3a6d130cb6cmr3215780f8f.46.1750439375305; Fri, 20 Jun 2025
 10:09:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250619130049.3133524-1-maz@kernel.org>
In-Reply-To: <20250619130049.3133524-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 20 Jun 2025 19:09:23 +0200
X-Gm-Features: Ac12FXyeUmiA3r9jYilzHr01DzOSd5DLfk5ROg5WkKSbcqmWMU5McoHSJ-zkNws
Message-ID: <CABgObfZ=9ZEJ8ouESTVfRiRLrQpyURo7pe04OBDgfwbjz6q9eQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>, 
	Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Miguel Luis <miguel.luis@oracle.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Sebastian Ott <sebott@redhat.com>, 
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UHY9hv9sQkskqq6cMeN1BrdsCntWHPwOisLr9vqUFzs_1750439376
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025 at 3:01=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the third set of KVM/arm64 fixes for 6.16. The most notable
> thing is yet another batch of FP/SVE fixes from Mark, this time
> addressing NV, and additionally plugging some missing synchronisation.
> The rest is a mix of interrupt stuff (routing change, mishandling of
> shadow LRs) and selftest fixes.
>
> Please pull,

Done, thanks.

Paolo

>         M.
>
> The following changes since commit e04c78d86a9699d136910cfc0bdcf01087e326=
7e:
>
>   Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.16-3
>
> for you to fetch changes up to 04c5355b2a94ff3191ce63ab035fb7f04d036869:
>
>   KVM: arm64: VHE: Centralize ISBs when returning to host (2025-06-19 13:=
34:59 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.16, take #3
>
> - Fix another set of FP/SIMD/SVE bugs affecting NV, and plugging some
>   missing synchronisation
>
> - A small fix for the irqbypass hook fixes, tightening the check and
>   ensuring that we only deal with MSI for both the old and the new
>   route entry
>
> - Rework the way the shadow LRs are addressed in a nesting
>   configuration, plugging an embarrassing bug as well as simplifying
>   the whole process
>
> - Add yet another fix for the dreaded arch_timer_edge_cases selftest
>
> ----------------------------------------------------------------
> Marc Zyngier (1):
>       KVM: arm64: nv: Fix tracking of shadow list registers
>
> Mark Rutland (7):
>       KVM: arm64: VHE: Synchronize restore of host debug registers
>       KVM: arm64: VHE: Synchronize CPTR trap deactivation
>       KVM: arm64: Reorganise CPTR trap manipulation
>       KVM: arm64: Remove ad-hoc CPTR manipulation from fpsimd_sve_sync()
>       KVM: arm64: Remove ad-hoc CPTR manipulation from kvm_hyp_handle_fps=
imd()
>       KVM: arm64: Remove cpacr_clear_set()
>       KVM: arm64: VHE: Centralize ISBs when returning to host
>
> Sean Christopherson (1):
>       KVM: arm64: Explicitly treat routing entry type changes as changes
>
> Zenghui Yu (1):
>       KVM: arm64: selftests: Close the GIC FD in arch_timer_edge_cases
>
>  arch/arm64/include/asm/kvm_emulate.h               |  62 ---------
>  arch/arm64/include/asm/kvm_host.h                  |   6 +-
>  arch/arm64/kvm/arm.c                               |   3 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h            | 147 +++++++++++++++=
++++--
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   5 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c                   |  59 ---------
>  arch/arm64/kvm/hyp/vhe/switch.c                    | 107 ++-------------
>  arch/arm64/kvm/vgic/vgic-v3-nested.c               |  81 ++++++------
>  .../selftests/kvm/arm64/arch_timer_edge_cases.c    |  16 ++-
>  9 files changed, 215 insertions(+), 271 deletions(-)
>

