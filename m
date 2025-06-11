Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907851A9B32
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 18:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749666355; cv=none; b=jYQKu3sNetWM2m1oW9s8bRu3BCLYGTMPTQU8vicwszVSBKAKlx5BZV361xbRvRr2O7ZTduRRDEWRpuyuv7dvC4lVpEEfUnbKIs+tmpK550wQ9zqporMtclhPU+sS3bh3uKE7tWnMTa3Ltg7/afLN9I73B/1w+HnB8H+cRX5b59s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749666355; c=relaxed/simple;
	bh=QGXUcJIhIQ30ANDc0g0NUebN9lT2jTMPVVFunQbRRKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EOrc2qnRRas1B3Wyj/fugNKQ8q26PIe2p2mxlRkSCJB+kOUpHaILHvPYSY1h0mdphhXQXXbjzRANtkVNiD0L4cJO69thXqyMmVgUx0xnmwtW08nqyP4nlAaXdNMSUxA9dkterTTANmuWa23DUboHQj1TaHwjD7PyFnPAz5EalDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bpo2y7fZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bpo2y7fZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749666352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOOIslp7Z9nXASpzhAXfaGcmmRlsRSek7f7fvNs7EhY=;
	b=Bpo2y7fZwjlIfMH5DBPIDfVZgRtEghb0WbH3foldo2TdYQOaFt5KYf/YjuqdTqnHwzVv97
	1mD3RI14Upa5UUqRlvsevZ5zgsXsziNFrYazYHIv64lWBM+bF7F7+43eA5/6guZRmGYaaC
	cz3UGX3Pvl0+k52O+ExRlSvfCxbbZEI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-VvlomgJ5O-yCKdT6RK-DVg-1; Wed, 11 Jun 2025 14:25:51 -0400
X-MC-Unique: VvlomgJ5O-yCKdT6RK-DVg-1
X-Mimecast-MFC-AGG-ID: VvlomgJ5O-yCKdT6RK-DVg_1749666350
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4fabcafecso104529f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 11:25:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749666350; x=1750271150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOOIslp7Z9nXASpzhAXfaGcmmRlsRSek7f7fvNs7EhY=;
        b=Zu7p7QyaM4ilN3sFdesY2qmL4Kg16JUMaCwmSnSSey9XgY6KLfw07EcO/w30RI+CS3
         IvrLZUAAL0sh/gVviXyTKHZeoTMdFvy3D2qdzVwCbCeQKnznMAy1ZqW+c40XmOgwqk6e
         3Tr6a32oW15f22kz+8iLsuCzwYWh9qY3NxovIfe1BDd1bk7VCSZqfIU5AR1GuViqp36f
         Q1rN4PRYaSJ/wH/zK2nohK98a6w4q8LMcRSkK/ZJtx7L/OcZWSpEYr2UyUSR3PvSe1NX
         Tx61fsPJziuJi+dINrduarsAWy1EP8vCc4MNw0RPPPHbB5Z/rm/BJCdDBLJazZBDOcbX
         zqDQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/qz4d1NeeVwZlV8L0kt5fViDBgs+FXE56GOlqDrkzWD3LdJx11fJDNG5mjI0h83oXnQ1pQGE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbLD6uxuM2LiknSuPRw2tv+MXyp6gwHphBGOQwXiZzCDqLDxWZ
	+a9W/DFtzjPGm2E7UT1xRmgdoC5lpkz3wbr9vkLyy+QDQixAFL+Sj5bcaH4B5h1tPw4ReVPVu6T
	3goKqdogvgznXTgBpvpIR9lxuuj+q6PryFIMDzctwMzScmk8o45iHO3or66LSu7SW9OL3NXww0K
	+8Keeqy/l4N32CuNfpziFVtLUYuExUIkjF
X-Gm-Gg: ASbGncsn/iPaKjB5rV6dN4TTyuRnZ0oRfI1VsD+3shXNihKGf6SYkbqNQ+dMT74DvAY
	f982ItC58MHi8IAC2ysL0ogBiEmMrEWB5MR/FqoJ0lPHYz8jD/P61iUMZxc10ucLwJecUaDEDAU
	TX+A==
X-Received: by 2002:a05:6000:420f:b0:3a5:2f23:3783 with SMTP id ffacd0b85a97d-3a55869b8e1mr3427924f8f.24.1749666350203;
        Wed, 11 Jun 2025 11:25:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFw1W0p/OeOmX200drwAxajGEghfRNt/CGI93zVm1UqIQ+I2s8lkCVrViNK/rTG856Z88dFFfkE8v1yeaf2mxA=
X-Received: by 2002:a05:6000:420f:b0:3a5:2f23:3783 with SMTP id
 ffacd0b85a97d-3a55869b8e1mr3427915f8f.24.1749666349830; Wed, 11 Jun 2025
 11:25:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250606094350.1318309-1-maz@kernel.org>
In-Reply-To: <20250606094350.1318309-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 11 Jun 2025 20:25:37 +0200
X-Gm-Features: AX0GCFsgTrXBmCEi1cZ9vmBCByY8mT5dVXknZ_pqZHoWTAQJcrp5JqwyhfcBkUo
Message-ID: <CABgObfbd=Jx4UdXKXyCb+8bQotLk-rc8P_BD-Aafx_rttgHMYA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Miguel Luis <miguel.luis@oracle.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Sebastian Ott <sebott@redhat.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0HwawxoQJKwLfoZOmCHkEO1z-qyXkipMYy2dhofpWWI_1749666350
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 11:44=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here the second batch of fixes for 6.16. We have a significant rework
> of our system register accessors so that the RES0/RES1 sanitisation
> gets applied at the right time, and a bunch of fixes for a single
> selftest that really *never* worked.
>
> Please pull,

Pulled, thanks.

Paolo

>         M.
>
> The following changes since commit 4d62121ce9b58ea23c8d62207cbc604e98ecdc=
0a:
>
>   KVM: arm64: vgic-debug: Avoid dereferencing NULL ITE pointer (2025-05-3=
0 10:24:49 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.16-2
>
> for you to fetch changes up to fad4cf944839da7f5c3376243aa353295c88f588:
>
>   KVM: arm64: selftests: Determine effective counter width in arch_timer_=
edge_cases (2025-06-05 14:28:44 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.16, take #2
>
> - Rework of system register accessors for system registers that are
>   directly writen to memory, so that sanitisation of the in-memory
>   value happens at the correct time (after the read, or before the
>   write). For convenience, RMW-style accessors are also provided.
>
> - Multiple fixes for the so-called "arch-timer-edge-cases' selftest,
>   which was always broken.
>
> ----------------------------------------------------------------
> Marc Zyngier (4):
>       KVM: arm64: Add assignment-specific sysreg accessor
>       KVM: arm64: Add RMW specific sysreg accessor
>       KVM: arm64: Don't use __vcpu_sys_reg() to get the address of a sysr=
eg
>       KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand
>
> Sebastian Ott (4):
>       KVM: arm64: selftests: Fix help text for arch_timer_edge_cases
>       KVM: arm64: selftests: Fix thread migration in arch_timer_edge_case=
s
>       KVM: arm64: selftests: Fix xVAL init in arch_timer_edge_cases
>       KVM: arm64: selftests: Determine effective counter width in arch_ti=
mer_edge_cases
>
>  arch/arm64/include/asm/kvm_host.h                  | 32 ++++++++++--
>  arch/arm64/kvm/arch_timer.c                        | 18 +++----
>  arch/arm64/kvm/debug.c                             |  4 +-
>  arch/arm64/kvm/fpsimd.c                            |  4 +-
>  arch/arm64/kvm/hyp/exception.c                     |  4 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |  4 +-
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  6 +--
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  4 +-
>  arch/arm64/kvm/hyp/vhe/switch.c                    |  4 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 | 48 ++++++++--------=
-
>  arch/arm64/kvm/nested.c                            |  2 +-
>  arch/arm64/kvm/pmu-emul.c                          | 24 ++++-----
>  arch/arm64/kvm/sys_regs.c                          | 60 +++++++++++-----=
------
>  arch/arm64/kvm/sys_regs.h                          |  4 +-
>  arch/arm64/kvm/vgic/vgic-v3-nested.c               | 10 ++--
>  .../selftests/kvm/arm64/arch_timer_edge_cases.c    | 39 +++++++++-----
>  16 files changed, 151 insertions(+), 116 deletions(-)
>

