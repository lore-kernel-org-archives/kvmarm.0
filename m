Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3876326CE2D
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450033; cv=none; b=RMeEWKJTEGcDYdYeDimhkQqruZioXE1n6cockeEzOgWhPIL8o8H6ZfLmUvxK4T6jwq0oYlodVvnSDLa8MSnr2A5SBo0cO6TFUK3MGUo35HBWz2NKlaWALYPDctEx1Z4zF90D0TO+RNdQbL5DJwZCCgCcu3LPZlfjUTmAkCyKf/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450033; c=relaxed/simple;
	bh=RxwzWh3XxVuKEWEOsyVQrcZCvzLtNdThj6MPjs3X+5s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mq01AHGCeTES1RUa4NdWVpqb9UUgNQ1edImtvwbIMnXo8zCMDEkFLoG5wex+ttWY/VSi+ZIvzGhM2Cd7v+iGitZ1Tj3ub5h5FSVrJ7W89KNYUPeiQ8118Tcs/uPhv6Gzl8Pcia/phqIhf7OQe9eEilCDHfw0gZ/pjK44PGCFGV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qv9Vwzin; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qv9Vwzin"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so7287535e9.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 02:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765450030; x=1766054830; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mu4tnUPCP3eMMJ7r4B7pF06/VroDz+dRR+cVn01z+uk=;
        b=Qv9VwzinpcqgXxR2iEvnn7rZ2UzDB+IsqD+hiowOP+1sojuS32NkhsdwlIS5pF0kRv
         y8fs3zZgtYlStPr6JLcmw1b7jRm0quf5uo6MhdgwKJgGyx0GiXWgfbMFMlnEmSoqrW7w
         yMJ5AgS5yvW1Sj7vgK/zu+kwbKl9J+gEmQAjw2fjr60d5Kj7o6ZC5iAd9WWz19b0rgAq
         wUqE96JntiTKui87LSSi7Dce9U352QVfIOHwEzCbp1GMC04rOO58OCkWvzCG9nbam6Tu
         IhbJFKYQI1tgIyp2Jlzw8/y9xARIMvS0CTKoZkejxd6lmp9AexH7LSwswguVbhyUH3On
         eyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450030; x=1766054830;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mu4tnUPCP3eMMJ7r4B7pF06/VroDz+dRR+cVn01z+uk=;
        b=ptUdK8NyVz4J11Kjzk7N+mQRThp8KxfOA09yqinH4NNv9lRbzmfHeDDysZx9VxwMe6
         eFBJ6LEh0B98DGex4XtbTDvAjlD4AAqHxPx0G4QTZN0W1GHmjT5smzHt0pukQdA2PMsN
         JuxLD0REICyix5/pvOfKsZ5u3o7eEatOFtdwnJEi3Z/Ri0eE1cEoX849QWuVvRCX/0eG
         jTjU0xh6Mxge5ZSW5LRlnlf4bT153ELJSw+2W2gkXCgEEUNiKEumRRkHHyq5QEYfozvr
         ScL6IPXIFw0dVfdeOC3VMgKqtH6l1lMFUdQOJPJ6m173vfuY07t0P424JK0bHMKG5I6O
         jxWg==
X-Gm-Message-State: AOJu0YzdnTvOBzzh3xMs9CSokgWwavb2Ge7JChCVHApBokbv7XmRjjXA
	pwUAFucO8dxkDVeYpc1jq9tgVDndLwBdW/xeGMSO77992Ve7WYycadFhKRMLsH+rGmfb1VZHGYF
	Z5poAP0t6q7nVYZa6ACYACsJtlWj9h9YyWf+s/TP4UVfEZtWAzhWisvcczP1sxG8UDD5hRS034G
	bs5qhO3EqiR4sXydV2bi6Eo7BybBmDRtk=
X-Google-Smtp-Source: AGHT+IHc1x4pEN8TyM6QeYpLvJgYc1keTk/0h7stJTpOa4NQXbSqrXLawJVqtiBF+zdbLMz7/t4wRg9Cpg==
X-Received: from wmpc20.prod.google.com ([2002:a05:600c:4a14:b0:477:9dee:b5d5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3512:b0:471:21:554a
 with SMTP id 5b1f17b1804b1-47a83814519mr52189595e9.13.1765450030559; Thu, 11
 Dec 2025 02:47:10 -0800 (PST)
Date: Thu, 11 Dec 2025 10:47:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211104710.151771-1-tabba@google.com>
Subject: [PATCH v6 0/9] KVM: arm64: Fixes for guest CPU feature trapping and enabling
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Hi,

This series contains several fixes for guest feature trapping and
enabling in pKVM, as well as a bit of tidying up.

Changes from v6 [1]:
- Fixes to the patch that tracks KVM IOCTLs and their associated KVM
  caps. Move static header data and function definitions to arm.c.
- Introduce a capability KVM_CAP_ARM_BASIC instead of KVM_CAP_CORE,
  since it is ARM-specific and that it only checks basic ARM ioctls.
- Tidying up code and commit messages.
- Based on Linux 6.18

Cheers,
/fuad

[1] https://lore.kernel.org/all/20251118103807.707500-1-tabba@google.com/

Fuad Tabba (9):
  KVM: arm64: Fix Trace Buffer trapping for protected VMs
  KVM: arm64: Fix Trace Buffer trap polarity for protected VMs
  KVM: arm64: Fix MTE flag initialization for protected VMs
  KVM: arm64: Introduce helper to calculate fault IPA offset
  KVM: arm64: Include VM type when checking VM capabilities in pKVM
  KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest in pKVM
  KVM: arm64: Track KVM IOCTLs and their associated KVM caps
  KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
  KVM: arm64: Prevent host from managing timer offsets for protected VMs

 arch/arm64/include/asm/kvm_arm.h         |  2 +
 arch/arm64/include/asm/kvm_host.h        |  2 +
 arch/arm64/include/asm/kvm_pkvm.h        | 33 ++++++++++++++--
 arch/arm64/kvm/arch_timer.c              | 18 ++++++---
 arch/arm64/kvm/arm.c                     | 49 +++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c           | 18 ++++-----
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 arch/arm64/kvm/inject_fault.c            |  2 +-
 arch/arm64/kvm/mmu.c                     |  4 +-
 include/uapi/linux/kvm.h                 |  1 +
 10 files changed, 107 insertions(+), 24 deletions(-)


base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
-- 
2.52.0.223.gf5cc29aaa4-goog

