Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583032E2DF2
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762440262; cv=none; b=g+QQUHFxy5u0F/sdmUI+wvh+HtIka08CZTZkB+aahF1HAuizrmQOOViaf0zPdaSyigWzWxDJH1SBUchZ7PcZ5UnpfXcB4W5kTSOiX1qEOCvJlADYCshTxoVdNcmA0y4qElpb0p1qPKjzNh4pbkKxbnKrDgZs8+xMvnA+3GMLVUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762440262; c=relaxed/simple;
	bh=xCSfGYp9daQpxBgtsf3PNkytn9UidtflDRC9Kz40LUU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=utSFedT6WElSD5Jz+tq2eZ51Fv/evJ5siDNmI2bkNPPXHWRkd669y8mGhWO1w9gpSMzROuF3uSa4CKGKvpA3keq23iuzQgt4yFfKL6NLPb9+ixR1W2qAcV3X77JftZRwDDK9R97ppO1sIeGw2DKSXZkstRc07r4uT5HABEt38xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PqbSP2m+; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PqbSP2m+"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-475e032d81bso6519085e9.3
        for <kvmarm@lists.linux.dev>; Thu, 06 Nov 2025 06:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762440259; x=1763045059; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wVZ18kpXA+sZ/1GcViq9E5WK0vC57K4CnJbSROPZLAA=;
        b=PqbSP2m+K1KstP7aO5A/6oXALhbp6A5cAVtmIFOWVZdFXCqY3P/32ysAmhXp8Z2uzr
         IqmymiBv/gK5shQIa5/tqt45WmCp9ZvYDkSfkDlE19o15ER8DZ25AwglkAw61gmXoDd4
         09Ngq8McCh8qyOyhEXhsbX4d5z9zo6tBAUx1eAgf1p0zqqaj0c5ND7EOF/nNa/0BqD+W
         1fInulhmH54WhENlXk6pFyECXcJwktQ7wKdOSyaBFE/KawHy54R1Re33C4taNy5uw3Kr
         wO3KdYQVwXihr4JJsZlxXh0p49Z1kvEFST7ohI2F2hHYYV3avTxvs0Yq6wgkOjL4fUXP
         OZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762440259; x=1763045059;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wVZ18kpXA+sZ/1GcViq9E5WK0vC57K4CnJbSROPZLAA=;
        b=sMj4HN5X3gXTn6I801Um3NIG35yI+ipBTWnHbiPdMuJOe+cUpgz8FvsFl4mUYcWXsS
         qoeIDAfitbVlpcIbIcCobJc/cFm6of+pJyPV07oHJlA1U2pSETQOnTTL0haIyRT4LmuH
         FWoQRlsVsgTTvyKN5a/LmNZU21rkRjfFAlE1DcY5wq5kuD2elJUte8AB4y0ru40h2R87
         tE9C9n6Ps+fNbLzri7XDCr3uYhWrB2SofMC8yzmK7CKe/in1Bg/PL9R3SZRThM8fT6o0
         lh6xwa+kTph71jQuv/7HZylLYiYJUHDZn2tzd1xzJvE4gSbj0y68NKGdn31J7HT0+lE6
         lY6g==
X-Gm-Message-State: AOJu0Yx6Rlj2KO4lB1egVZGXCby3ZNglAkNbet+ELRHSWfP5ML/FMch2
	d0uZBBRS/26TeehiV1A6rYXSsBSPou2OVu2062zp8N9xIJwC6aCMhP2bLJiEsviwdl4FH29Sg3v
	GtKPAt+ignsGcLW+R90cS7p0g/0g9kWzecf98emEGbRZvRZRQLpkb9RgterACKaR0VomJs1l1DO
	YyVr8y/m1hSVLYPq0L5PPFROsTUpSafs8=
X-Google-Smtp-Source: AGHT+IE1wTJDTcL3U3Capu0DU6sLOo3goS3UxDUA399EZH6RrCkjUuKph4GWp7KbO9M0TnI2osZb9t2bmg==
X-Received: from wmcm6.prod.google.com ([2002:a7b:ce06:0:b0:477:1716:3f2e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:524f:b0:45b:7d77:b592
 with SMTP id 5b1f17b1804b1-4775cdbfb6fmr59398085e9.12.1762440258657; Thu, 06
 Nov 2025 06:44:18 -0800 (PST)
Date: Thu,  6 Nov 2025 14:44:12 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106144418.2847443-1-tabba@google.com>
Subject: [PATCH v2 0/5] KVM: arm64: Fixes for guest CPU feature trapping and enabling
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Hi,

This series contains several fixes for guest vCPU feature trapping and
enabling, as well as a bit of tidying up.

Changes from v1 [1]:
- Dropped the MOPS patch (Joey)
- Dropped patches in favor of reworking coarse grain trapping in general
  (Marc)
- Fix bug in Trace Buffer trapping (Suzuki)

Based on Linux 6.18-rc4.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20251104125906.1919426-1-tabba@google.com/

Fuad Tabba (5):
  KVM: arm64: Fix Trace Buffer trapping for protected VMs
  KVM: arm64: Fix Trace Buffer trap polarity for protected VMs
  KVM: arm64: Fix MTE flag initialization for protected VMs
  KVM: arm64: Prevent host from managing timer offsets for protected VMs
  KVM: arm64: Define FAR_MASK for fault IPA offset

 arch/arm64/include/asm/kvm_arm.h         |  2 ++
 arch/arm64/kvm/arch_timer.c              | 18 +++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/pkvm.c           | 12 +++++++-----
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 arch/arm64/kvm/inject_fault.c            |  2 +-
 arch/arm64/kvm/mmu.c                     |  4 ++--
 arch/arm64/kvm/sys_regs.c                |  6 ++++--
 7 files changed, 30 insertions(+), 16 deletions(-)


base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
-- 
2.51.2.1041.gc1ab5b90ca-goog

