Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8D7282F26
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773293; cv=none; b=Ta8w+Zvt+y/pQNuL4Y32078ZU+i5IQjNIc1KycHKG+dDQNqBJIlY3zNsZz2vT93fBWAiFu/ieGCqnViEA65iHSzK0NxnAK8AiC2I4CcBZytydt0fmxJNgKQpCIKTaVLRkuwgaBNUJ/wgeWEIpdQaB5pzKm3b4OTyta2TS+dswTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773293; c=relaxed/simple;
	bh=JF8xaUxAEefrhGeYdLmqjBr/6MU50meqkgMYwRq5apI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cxMzU1NqC1ZnRxAWiu+wROOrB03CPYyFrp+r0XLLBX2GWClK7ZoMV/z0+y2VDy8bQTR4qBefqe/r7weSFovjPsbHQWGP+5p6yEjecMHtUPLS8/kBSkLYiRw++IW9CBYVPRJLY49+1W4HlBsRSvD9qhNoQZlu0BPAeDyPU0gpwNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LjfjV9Ss; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LjfjV9Ss"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b37e1f48so4225855e9.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 02:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781773290; x=1782378090; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jYtovqB7kdiINejrOv1fG0IAw5VWPSFbwH/MJT2FPq0=;
        b=LjfjV9SsUP542PIwpWk/2ro1LJ2KJtjy4W2FFSEctiy6ozwmWXQxYTHEB2Ydi829Ix
         coRCVqUJisFVNJXqFpAgathZgadhxIQ4vLDPG8C/+/0b6I0+FfHzQcYkBnR9aCCsxHI5
         rJwwx1EGMx8fdb/FsoXaB4DPcBCj20Nrs8dUd7bEtS24OqrmsVnHhGytIzb09LIIx/Un
         UGChbgf4R7c8Fzg2jIoO5WbFWndMPmU6S1LXIc1yKQrveXDV1S0P/R2UhGRS+by6/U9e
         Sl3d+IIlRhgo9Qycect9qn7qXKNMiufWTUD8ej7abxDmBv71iwX+xOUE1O9rk/wdoc6k
         S+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781773290; x=1782378090;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jYtovqB7kdiINejrOv1fG0IAw5VWPSFbwH/MJT2FPq0=;
        b=p/hQ5Eh0TCQF3dtzd5xu2XvtlgJoUQZotiBnGVcXCRtY5CmoM3UtJ+TBGo5R/Tlt8E
         pBR1ul9Itz7H/L/OBT3YIgmViNp6Pg/Gri8Sbz0v7aZtrPB1amm1/3RMutNZhC3uAlpT
         2/S24bIU3Q63oean4IuZ+LUadN4w44Id7kWU6cpxlbNOSazqNP2WT3LPBESfzqGzatSA
         xRonYOKCdv7h6g80Zw3V0G+8KmF+ZGg0UzCO8CY70Q/tWEiPL/GmIyInoRkjIfnoxywL
         krwBsreIB1i+AK6NIN3o+2IC1JXFU0+cdeTfApCNszPqFoqII+I+ezJI4MmHyCws8S/d
         7BHQ==
X-Forwarded-Encrypted: i=1; AFNElJ/SjCe1wdadkNb/oKDhRFV7QbDo90T2Ard1BT0B4QZfGkTTfs5pVWczFmOYcESDCvzTsd0SL3E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAJranbkOn1OWgS3C7FNplYu552Z2IodHXc7cXzjaUqtxqi0PC
	YI60VkDFMabN6hhBWhFKi38TsJ5z2asoa+YS0v/b+DjAZfsdsWWLcZtD1+Qz+zW02ddy7AgzVbP
	aKA==
X-Received: from wmrk26.prod.google.com ([2002:a05:600c:b5a:b0:492:2566:3b6e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fcf:b0:490:c024:2ec8
 with SMTP id 5b1f17b1804b1-4923819e3f0mr44387665e9.0.1781773289396; Thu, 18
 Jun 2026 02:01:29 -0700 (PDT)
Date: Thu, 18 Jun 2026 10:01:25 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618090128.3913688-1-tabba@google.com>
Subject: [PATCH 0/3] KVM: arm64: pKVM is_created cleanup
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Keir Fraser <keirf@google.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This small series tidies up the host-side kvm->arch.pkvm.is_created flag,
which tracks whether the hypervisor-side (EL2) VM has been instantiated.

It comes out of the ongoing pKVM (protected KVM) upstreaming work and runs
in parallel with it. The changes only remove dead or redundant code around
the flag, not any of the functional paths that work touches, so there is no
dependency in either direction and the two can be applied in any order.

is_created stays: the pKVM handle is reserved early (so host MMU-notifier
TLB invalidations have a valid handle before the first vCPU run), so a
non-zero handle no longer implies the EL2 VM exists. is_created is what
distinguishes "reserved" from "created", and the teardown path relies on it.
Only the cruft around it goes.

Cheers,
/fuad

Fuad Tabba (3):
  KVM: arm64: Drop the unused EL2-side is_created write
  KVM: arm64: Remove unreachable early checks in pkvm_init_host_vm()
  KVM: arm64: Drop redundant READ_ONCE() in pkvm_hyp_vm_is_created()

 arch/arm64/kvm/hyp/nvhe/pkvm.c |  1 -
 arch/arm64/kvm/pkvm.c          | 13 +++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

-- 
2.54.0.1189.g8c84645362-goog

