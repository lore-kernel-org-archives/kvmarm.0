Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E4A7B3E1
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939255; cv=none; b=nuH5TNjMWZNI3mIW5l+oO+5weLNI++2RrUgbLcMoJBkbCm6p0DtVhJD4Kfp08A3iR70CGBfQyGVYF0j+3E3v5ZuHzujsN/3om6fM0ssf2gmjkzx5apoOoGl3CxZ74zF2wg3o8mkenKfFV0avYNCHnLTOtfASjAKbwk9K+odYC9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939255; c=relaxed/simple;
	bh=Em4+hdLSQR0U2Z2EKTtt17DGGx/7NT175qMPydT8ekQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=q9jz97Ae81Xg8iqmfe0PXZDklO69/kzaGB+XQhWyzx+3nGasDmYgcV7KitNJMtaYKL4dpcPjOEZUgieelp81Uwx5QX2zhgOKBl4vB7NY50AsXMohcDiq8LrfcfFZuNBz+5EmghGbWZZhgWVBqpb2B5MgV0shiW4gyJA6088uCO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gvKrKtpx; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gvKrKtpx"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6407e61783fso556835a12.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 01:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762939252; x=1763544052; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hgEcLDRr6Tuu7IvCUwV3SctU6MLFo2MRbp0TndvBGx0=;
        b=gvKrKtpxDh2T3KPvXsiZbvLo8VfB8R49fM9sHfT8D7lgRW5mEDu5Jo+PedmhgMZUDX
         se0JJMS1zBLP/onAaM7MLIG8gtv286lzuniXrAM24xFDfMgc4r3Q3csWFWdAchb6+Oqy
         NvbvwD/a0+gbKptSrgm63zMyBZNZ6HwdpIKgxX93ayk4xyss7gYatIg23z661t134hqz
         lz8z9DVrCSdQ6/rZBwF9CrngRWgr/hGgoaqb1d8MESxhFCT4U+cgX/YsNmKP3G9DV9h6
         sRl5g//OOJosmJswKRxmsGGq5XDuRU8ErSxucHmzbLbt0G7mcRWbe/X5Hq4mYyxGBdmc
         52RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939252; x=1763544052;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hgEcLDRr6Tuu7IvCUwV3SctU6MLFo2MRbp0TndvBGx0=;
        b=uLeiGPPIficyv6MQm/bo4e6Wv4hwM2sE5KZVUxMUm+RrlAo0/2VuTBZJpi6/SElHxE
         3zN3gKtzdXrxrNq7IwWl8/z8KGOjWY0kiCq+YcOrJR1zq3CytEIhkZatjpgWw9rRJTsz
         oNXpIT/Wjfr7XZzBeox1oh9ZvHfaHba48L4w6V1JCSD31SgZe0TJflrt5SUu+dp6517l
         gdbuglJ3do4iWr9+KEMuUZ/g9bRnB3nu7uigAcxKif5uCRxPaPXrJKhFtKQWlF/VIs7a
         rEtNvdq7SsiiLhOWvj0rwz+c6VRbET7TQ+ffApgPtjeTl5z/FjjcSJlCagOmgZffj4mY
         BUCQ==
X-Gm-Message-State: AOJu0Yw7M7a9S1r8hhN5TJw7yrUVitspUnlOp+tA0saFjt6yu4be2Q61
	Rtl898wdvaK1TyR5mc6w36aujnzaepBf8Ull639MpgwEK6ClC4p5GJtGbaZWl8H58eqLkCo7u58
	6N7uccvGkUNcYBIdILIt6Z6bM4H2BIDp5WLx+uHG+S+ZV9YyFBn2bNyBgvIlGdiWAmfjptCMShU
	yzY0Z9+weIfBoW/ygGzu1Z1rJs8nL9LoU=
X-Google-Smtp-Source: AGHT+IHPPe+NMCZTO15BeXq0hd/6XgQYGiDPSJtHZiUQftHC3g+VM72JYLtBxstJSv5eAuQh+oTPoWs5iA==
X-Received: from edbes19.prod.google.com ([2002:a05:6402:3813:b0:641:3344:d26d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:455c:b0:641:8f8d:e633
 with SMTP id 4fb4d7f45d1cf-6431a55e40bmr1677415a12.28.1762939251927; Wed, 12
 Nov 2025 01:20:51 -0800 (PST)
Date: Wed, 12 Nov 2025 09:20:43 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112092051.1376245-1-tabba@google.com>
Subject: [PATCH v4 0/8] KVM: arm64: Fixes for guest CPU feature trapping and enabling
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Hi,

This series contains several fixes for guest feature trapping and
enabling, as well as a bit of tidying up.

Changes from v3 [1]:
- Fix MTE flag propagation (Ben)
- Include all ARM-specific VM IOCTLs that don't belong to a basic
  capability in the pKVM IOCTL check
- Based on Linux 6.18-rc5

Cheers,
/fuad

[1] https://lore.kernel.org/all/20251110134525.3768197-1-tabba@google.com/

Fuad Tabba (8):
  KVM: arm64: Fix Trace Buffer trapping for protected VMs
  KVM: arm64: Fix Trace Buffer trap polarity for protected VMs
  KVM: arm64: Fix MTE flag initialization for protected VMs
  KVM: arm64: Introduce helper to calculate fault IPA offset
  KVM: arm64: Include VM type when checking VM capabilities in pKVM
  KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest in pKVM
  KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
  KVM: arm64: Prevent host from managing timer offsets for protected VMs

 arch/arm64/include/asm/kvm_arm.h         |  2 ++
 arch/arm64/include/asm/kvm_pkvm.h        | 41 +++++++++++++++++++++---
 arch/arm64/kvm/arch_timer.c              | 18 ++++++++---
 arch/arm64/kvm/arm.c                     |  7 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c           | 18 +++++------
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 arch/arm64/kvm/inject_fault.c            |  2 +-
 arch/arm64/kvm/mmu.c                     |  4 +--
 8 files changed, 70 insertions(+), 24 deletions(-)


base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
-- 
2.51.2.1041.gc1ab5b90ca-goog

