Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2D822A7E8
	for <kvmarm@lists.linux.dev>; Mon,  2 Jun 2025 21:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748900570; cv=none; b=ghH0HXGSlBxacL1rs9FLE4BCC+R0z5Rgnj5LJE1/n+1GPqixXqs6u4WxvfUREFOu8F8sGX3IWdLKz3Y0CVlK3mQMXmq9dcX4h6I64XVpCqoFfgVv8Nh1xkQSDvs8rqv1kuYRNFyVlhl18grCcI3VV01tMy33BNaM0odNNTqStAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748900570; c=relaxed/simple;
	bh=ckaYtR2Fj0bTMmLPJv/DKzJ6ZVnPamOnPCJGUN8RsNU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E+ZV3j1tEXKPi/pnk4lPH2208yCk+BhJ74CuS15VnjPLhgjoFDrSrhe9hdHDbmwPYy1oUyWTXoaLwURynCWtG4x2PpkZjfB5qfckbmGwA77RQs7fyln15XIi5sMEa7FclIO+rQS3mC1CtBlm8I4v37mdYtZUQm72mWrHTfP/w5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sHRYBGpQ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sHRYBGpQ"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74292762324so3707168b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Jun 2025 14:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748900567; x=1749505367; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dq9rWg0WQtk35a/syIdVrxIN1jVZ3Xs4zsk5PWEtjOs=;
        b=sHRYBGpQr04gpU+hWdIbsEEZ4qBEk4ZoKYpqm2zp9leb+AFsICXAt2eVrVHXyLhR0p
         FjWGa1L+HJPrKkzDhus9/fsWR6h+F8XcdWMYEEB7JMSysxSChoHED9O6otn4tsudLQu2
         qWMqgMQw6EaqW0Skl3eRrQ0kfm6GlEZfZUwt94rOmREI4UzW1DRm5UQnShhzDYBZ324Q
         FW7o6EoR2PGl/qtVictV8alcaYzy4Asc5rZD6pgPs8kDNFKWF7ph1W5nZ6Xd5OJ4PKVi
         UG2TzrvcbsReIOgwztDzn4IZNAAPhPAKu6bmCZYHXN3qe7883iPF0btZeQUHaQZYBuo/
         P4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748900567; x=1749505367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dq9rWg0WQtk35a/syIdVrxIN1jVZ3Xs4zsk5PWEtjOs=;
        b=IZAtuDtCaX2GYKbYsrMJSG8Zn+DC9P/uKGUppZuzltFwi74AnpvLzqPkrVZoJ6TsI1
         1J0P2mI2xvFnJ13+TiH+cDw45ekz7tzChnnmowPwte2I686Cab6bIGJopgIlOwJ30Q0O
         vroL2XeIPhf20Z7iVvo4UcEAhflv9n1lKx/flUPv1fVKhPE+x2QtpYxowwF4sZ/drmeL
         duRbdNmazsizL9G9Djh8fM4caSVGmG9yDbf6BbUfZnpLfBnckwLZRoY5SaIw3QR7/63s
         czxegFZMTc2mz42w2vUz2Kcr0SFd67cKA8DyrURpK52E+p5lEdhPSnw4D1zHigk1T7oP
         sSeg==
X-Forwarded-Encrypted: i=1; AJvYcCUGyrivOu2B9AAqnqkZ0b3dS++JTbc33rxuHmIVWAoPJLi8pCgAson4VVng52ybTr7LdpQWwrk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSAaqnq4OK9AjazBomngUS2iK20lcY0l2J6PxkLkge1jQfKVk1
	QQ7JO+wjFAnv7CxBNre9Wx8ig64UUgYSShgiKFkZt2wy6ljcZW9dtjOrCI8frYqoPoZbCJXvdPz
	YHSa+Hg==
X-Google-Smtp-Source: AGHT+IGP+igBSt2KbXYpY47Cum6/12d7ZKaJ7lAPbHVwRqO4FufM1cqAilI67WNoocjAfjBEbiMhF3OvXWQ=
X-Received: from pfbhd7.prod.google.com ([2002:a05:6a00:6587:b0:746:2e5d:3e6a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:238b:b0:736:a540:c9ad
 with SMTP id d2e1a72fcca58-747bda1a68amr19816923b3a.20.1748900567066; Mon, 02
 Jun 2025 14:42:47 -0700 (PDT)
Date: Mon, 2 Jun 2025 14:42:45 -0700
In-Reply-To: <20250602192702.2125115-5-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250602192702.2125115-1-coltonlewis@google.com> <20250602192702.2125115-5-coltonlewis@google.com>
Message-ID: <aD4a1T7ZmBLNunxi@google.com>
Subject: Re: [PATCH 04/17] KVM: arm64: Cleanup PMU includes
From: Sean Christopherson <seanjc@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 02, 2025, Colton Lewis wrote:
> * Delete kvm/arm_pmu.h. These functions are mostly internal to KVM and
>   should go in asm/kvm_host.h.

Ha!  I'm a hair too late, as usual.  I _just_ resurrected a patch[*] to move and
rename all of the <kvm/arm_xxx.h> headers to <asm/kvm_xxx.h>.  If only I had
posted on Friday when they were ready :-)

It's a relatively small series (mostly arm64 code movement), but it does touch
all architectures due to giving the same treatment to kvm/iodev.h (and purging
include/kvm entirely).

Any preference/thoughts on how to proceed?  My stuff obviously isn't urgent since
I sat on the patches for almost two years.  On the other hand, the almost pure
code movement would be a nice precursor to this patch, e.g. move and rename to
asm/kvm_pmu.h before extracting chunks of code into asm/kvm_host.h.

[*] https://lore.kernel.org/all/20230916003118.2540661-15-seanjc@google.com


Diff stats for context:
---
Anish Ghulati (1):
  KVM: arm64: Move arm_{psci,hypercalls}.h to an internal KVM path

Sean Christopherson (7):
  KVM: arm64: Include KVM headers to get forward declarations
  KVM: arm64: Move ARM specific headers in include/kvm to arch directory
  KVM: Move include/kvm/iodev.h to include/linux as kvm_iodev.h
  KVM: MIPS: Stop adding virt/kvm to the arch include path
  KVM: PPC: Stop adding virt/kvm to the arch include path
  KVM: s390: Stop adding virt/kvm to the arch include path
  KVM: Standardize include paths across all architectures

 MAINTAINERS                                                | 1 -
 .../arm64/include/asm/kvm_arch_timer.h                     | 2 ++
 arch/arm64/include/asm/kvm_host.h                          | 7 +++----
 include/kvm/arm_pmu.h => arch/arm64/include/asm/kvm_pmu.h  | 2 ++
 .../kvm/arm_vgic.h => arch/arm64/include/asm/kvm_vgic.h    | 2 +-
 arch/arm64/kvm/Makefile                                    | 2 --
 arch/arm64/kvm/arch_timer.c                                | 5 ++---
 arch/arm64/kvm/arm.c                                       | 6 +++---
 {include => arch/arm64}/kvm/arm_hypercalls.h               | 0
 {include => arch/arm64}/kvm/arm_psci.h                     | 0
 arch/arm64/kvm/guest.c                                     | 2 +-
 arch/arm64/kvm/handle_exit.c                               | 2 +-
 arch/arm64/kvm/hyp/Makefile                                | 6 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h                    | 4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c                           | 4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c                            | 4 ++--
 arch/arm64/kvm/hypercalls.c                                | 4 ++--
 arch/arm64/kvm/pmu-emul.c                                  | 4 ++--
 arch/arm64/kvm/psci.c                                      | 4 ++--
 arch/arm64/kvm/pvtime.c                                    | 2 +-
 arch/arm64/kvm/reset.c                                     | 3 +--
 arch/arm64/kvm/trace_arm.h                                 | 2 +-
 arch/arm64/kvm/trng.c                                      | 2 +-
 arch/arm64/kvm/vgic/vgic-debug.c                           | 2 +-
 arch/arm64/kvm/vgic/vgic-init.c                            | 2 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c                           | 2 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c                      | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                         | 4 ++--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                         | 4 ++--
 arch/arm64/kvm/vgic/vgic-mmio.c                            | 6 +++---
 arch/arm64/kvm/vgic/vgic-v2.c                              | 2 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c                       | 3 +--
 arch/arm64/kvm/vgic/vgic-v3.c                              | 2 +-
 arch/loongarch/include/asm/kvm_eiointc.h                   | 2 +-
 arch/loongarch/include/asm/kvm_ipi.h                       | 2 +-
 arch/loongarch/include/asm/kvm_pch_pic.h                   | 2 +-
 arch/mips/include/asm/kvm_host.h                           | 3 +--
 arch/mips/kvm/Makefile                                     | 2 --
 arch/powerpc/kvm/Makefile                                  | 2 --
 arch/powerpc/kvm/mpic.c                                    | 2 +-
 arch/riscv/kvm/Makefile                                    | 2 --
 arch/riscv/kvm/aia_aplic.c                                 | 2 +-
 arch/riscv/kvm/aia_imsic.c                                 | 2 +-
 arch/s390/kvm/Makefile                                     | 2 --
 arch/x86/kvm/Makefile                                      | 1 -
 arch/x86/kvm/i8254.h                                       | 2 +-
 arch/x86/kvm/ioapic.h                                      | 2 +-
 arch/x86/kvm/irq.h                                         | 2 +-
 arch/x86/kvm/lapic.h                                       | 2 +-
 include/{kvm/iodev.h => linux/kvm_iodev.h}                 | 0
 virt/kvm/Makefile.kvm                                      | 2 ++
 virt/kvm/coalesced_mmio.c                                  | 3 +--
 virt/kvm/eventfd.c                                         | 2 +-
 virt/kvm/kvm_main.c                                        | 3 +--
 54 files changed, 64 insertions(+), 77 deletions(-)
 rename include/kvm/arm_arch_timer.h => arch/arm64/include/asm/kvm_arch_timer.h (98%)
 rename include/kvm/arm_pmu.h => arch/arm64/include/asm/kvm_pmu.h (99%)
 rename include/kvm/arm_vgic.h => arch/arm64/include/asm/kvm_vgic.h (99%)
 rename {include => arch/arm64}/kvm/arm_hypercalls.h (100%)
 rename {include => arch/arm64}/kvm/arm_psci.h (100%)
 rename include/{kvm/iodev.h => linux/kvm_iodev.h} (100%)


base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
--
