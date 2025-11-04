Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC1F2EC54B
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 12:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762261151; cv=none; b=NXQHeO2WssRx1ncKT8wVYW5GG+6PLJCTDAAHlpztFiR1sBCWb1VKVk3uFM6NTmHlEJUsHO4q/2dOU55o4taJnLOs7lEQijBiC9ytbMFAgbXpWjUilZi0qTyOB3x5DO5Y33nre8vK853LdBs0yR9kJO1MV4k/mZz+6fHluQWJAIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762261151; c=relaxed/simple;
	bh=HWxiGiUOcrQmVTlmxXl5TGvIH6I9GP3tfmCQoWcAfvM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oJijI90iDWydFR9YvtomY27Dyd54tdnpFSx/rKIcytiOe72q+ktc0rTOD2sGegh+ZfJSWD5dLBPHDV72Frp/PQNuaNB4BRLzRCUo67daM4alkPO/V1VUh1vWMgpK8zGeivVdueAgFfip3WQcNSq0SpA7AYFzn+4OW4DV09jY90Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wP036HQV; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wP036HQV"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-470fd92ad57so64804155e9.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 04:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762261147; x=1762865947; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bkXH7eosyb2JItJ6a+jHxlEQOajEabKKXGhxw0oKMn8=;
        b=wP036HQVO07//bRutBhfIRJK4IQp1WmNwLpy8oUFBLBL8Yk20C3eRMDZ3gw1j6ELPf
         P5fkEa5E3cSGN+wygKlcayKGl/aBz0Hum7lFs+yMceQ6TvjcOLqyKsJ9t2r2ATksotvW
         MByZ6Fq+D4ScqxAtK1L9jyezDRcLShJFM5m1tt3JKBV7EKhYDjKK9Sw9ft8qqsdzqENQ
         j1Tr+IRFXEeYLBEbNBs8KzVHZNRKV5QFeJbavJ0AvE2o/c1CkXTHpBEhFZ+pbRtspgOW
         haFpyoFj3EbECd6f2IEmbLq6yz7VFBE9FgzV0mWXNCJW7aKERVjNdmUeFre7QAWK39wg
         J7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762261147; x=1762865947;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bkXH7eosyb2JItJ6a+jHxlEQOajEabKKXGhxw0oKMn8=;
        b=knFs7zXep28gtCQWXSKAF4WoD0aGdZdUqTx3fM0+n/X0m0yl3bqSpGVh/PVl7vrZQL
         6OdONZM4QfTRs5zn+DpYzzkaW/wvWBFXr8XMLNBVsNXg+4+OrBgPAnmEOxMRKA8hc8TO
         +cUEzvnEgQLIqNtRBSRuJlljH3XlHYrMX/vAL2xW1tZO4m+Lnfio88pEhu8W/Jama7EE
         lSRJdpw9dwLsk1kjypQX2mmS8qqiuEIH+iC/wR4TpEL8BcklQQbue9PNf/zuzqRK6NTJ
         Aql4+tdWCc9rAJhixBkPjTIy1p3r+6EPlstzNRZGbGlHPdPU7kD3wjQyHufyD/HaMjvS
         TRfg==
X-Gm-Message-State: AOJu0Yz80yB9RN4ktpvdTx1I6CMx25VhXpdo9x5mL5EgD9SKJuQnhk6W
	YCGvwgOeI8wry7z62Be67wNWmRoSVNqMAB81pJ07Q1OmTkJ6U0R4L8GVP34N1iWt+95emzh7XX6
	cnnYIjnfIURT7TRz6NZUygucS6DAcA271UmtaKurfw3uaS7g1Pf914PsMA+ix/0H8h8Ph5Xe/Nl
	sG3LnrOk0BauYsAWbLNOvmUKgOgIGVFSw=
X-Google-Smtp-Source: AGHT+IFgYT4bLPXRk9AhJP2mOSaIQSkoHLrXRLVjVTxY3d2ElH76yRZQ1l6Yg9mlWEQgXIjTMp8drNDtYw==
X-Received: from wmcq3.prod.google.com ([2002:a05:600c:c103:b0:476:4b14:2edf])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:8388:b0:477:3e07:217a
 with SMTP id 5b1f17b1804b1-4773e0722b7mr66876485e9.36.1762261146749; Tue, 04
 Nov 2025 04:59:06 -0800 (PST)
Date: Tue,  4 Nov 2025 12:58:58 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104125906.1919426-1-tabba@google.com>
Subject: [PATCH v1 0/8] KVM: arm64: Fixes for guest CPU feature trapping and enabling
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Hi,

This series contains several fixes for guest vCPU feature trapping and
enabling, correcting logic for both non-protected and protected guests.

It fixes inverted logic for MOPS exception routing and pKVM Trace Buffer
trapping, and add missing traps for features like FEAT_NMI. It also
ensures that supported features like FEAT_LS64 (LD/ST64B) are correctly
enabled for the guest and not trapped.

For pKVM, this series also ensures MTE is correctly detected and enabled
when it is on the allow-list.

Additionally, a simple refactoring of vcpu_set_hcrx() is included to
reduce indentation and improve readability.

Based on Linux 6.18-rc4.

Cheers,
/fuad

Fuad Tabba (8):
  KVM: arm64: Route MOPS exceptions to EL2 when guest lacks support
  KVM: arm64: Trap access to ALLINT if FEAT_NMI not supported by the
    guest
  KVM: arm64: Enable LS64 instructions when supported by guest
  KVM: arm64: Refactor vcpu_set_hcrx() to reduce indentation
  KVM: arm64: Fix Trace Buffer trap polarity for protected VMs
  KVM: arm64: Fix MTE flag initialization for protected VMs
  KVM: arm64: Prevent host from managing timer offsets for protected VMs
  KVM: arm64: Define FAR_MASK for faulting IPA offset

 arch/arm64/include/asm/kvm_arm.h         |  2 +
 arch/arm64/include/asm/kvm_emulate.h     | 48 +++++++++++++++---------
 arch/arm64/kvm/arch_timer.c              | 18 ++++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c           | 10 +++--
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 arch/arm64/kvm/inject_fault.c            |  2 +-
 arch/arm64/kvm/mmu.c                     |  4 +-
 arch/arm64/kvm/sys_regs.c                |  6 ++-
 8 files changed, 60 insertions(+), 32 deletions(-)


base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
-- 
2.51.2.997.g839fc31de9-goog

