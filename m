Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAA5768FD
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 01:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740448412; cv=none; b=q0Pfac7+73E0TSUHUQDy9aMtNzTKLT39hOMDsUngRRhTxsMV3RYvwMg7yoLFC/cru5icNik0/y0Mx4ycQb3XbbaJNGwEIArvFHWvo9TfBFLWkNsf3W2In1JhJJHM75JYRCC3kUDaQWyN3DeUgi5tqqHRjFKzzCETJ7PkqEWw2V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740448412; c=relaxed/simple;
	bh=lDnDEm+dSfaeSLN9szJPpAcWhldP+uIqITh9ILIqPuo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lK2n4msK+yotI7S6te1oO9nAamEfvCQ4ozZRMUfpEtDMDX1xPm6hW6c6MBlf0Sqpx+L0xCqpC7pxGwHbaC3vhaXwnla+4x1xUi0AJ7kBTn+CC1clBPbHzr0fuySQI+PWtWq9uDkP2kKglaXwOCl0n9gCBQba6dL4zos4DR7/NEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YyrK3FVn; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YyrK3FVn"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5dedd23cdecso5459482a12.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 17:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740448409; x=1741053209; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AH9Y+qk/plKTRCQ8rdCbOXUmRPqvAGtJ+mP7kh2bkjA=;
        b=YyrK3FVnwKfY3BCt1a/xHfbvcMUQVBk6TqqU9GDAZ50IRW9ctBQ8wV05R6gyTPQ51n
         iRZkcX/a/2Z/3DVc1FdGDXITBhNvQFTWPZz3S9KItAqpOky2M2tD4ZucmNef5+wW5QvX
         wH4EL9aGvjATspYBokFXIFQZOU8GZBvr+fR2xfnA9FnI2Ar3hvyb9lmotHrgfa0x2YkK
         nuAm25aeKoaNow05ep8B8wzMrb+oCv7NCNAdCBTaTUOovfkMkRqPHx2hyVH02Mhifyx6
         M4hUc4WBn5cH7zBO4xq+SmcjaECylEUNgD2Bs2rw2JX+OhebQG5OXgrkxCTHJaz1kaC8
         BrJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740448409; x=1741053209;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AH9Y+qk/plKTRCQ8rdCbOXUmRPqvAGtJ+mP7kh2bkjA=;
        b=HDnHUP2tS0b7SbZtjVlRceo6EZkVCjwHCRZSeysM5TXI+82xzaI0ziPuqoK4UVVGV4
         7cgZDTuU+1Jna2fREeUeW4EGKS/Poxg/GjzPIxnitNnDg/seES8r/lzzn0/VcNMWpQZY
         /4Iec7JC1mC9UedB2buYZTl5MEmtkbsmpA2LQjKULoHxx8UyJ3V6DrtrhKbaRxJ+hzOx
         JUnQs51keL3TRw5hcUAKnYEtXlLSRg7ZIyylGRjL0OSFBxEeBuPYmYCPUqySIkDi32Qg
         jNqxu0Ao36GfbILx/uRRsEGzFSwdvJT6RWiVpj6RwqZ7ERFa74jbXK4OcUUWJhkoR5Kw
         ZQAw==
X-Forwarded-Encrypted: i=1; AJvYcCUOYDPySR7pB4n9XDlM1hXSu7l2VyVEDXKsrYzDPfLHEWPtV8XNWDSzDSyuFEsgzAI1KKCWuYI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyt6x6kZ0abKbSlkVgFP7GoFcxcqVHPIK91RyFAM8cMUm5nre31
	rxNj0h4NIAEXTENSX8lPA7KiGUfQ200c6SjP77Yfg6GdtVtI5ZhAWsQzR/J6JXJGtRX6kVmSN/J
	f3peD8Q==
X-Google-Smtp-Source: AGHT+IHJKOHeegcslTQv6gGnIpceJABRkLrMUljBH8OEUmqvgitKR+e8++1jZBdKvqfUQIxfPe64opEc23yp
X-Received: from edbig12.prod.google.com ([2002:a05:6402:458c:b0:5de:bbcb:2c3])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2113:b0:5e0:8ab6:65fa
 with SMTP id 4fb4d7f45d1cf-5e4469daaa1mr1165847a12.19.1740448409709; Mon, 24
 Feb 2025 17:53:29 -0800 (PST)
Date: Tue, 25 Feb 2025 01:53:23 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250225015327.3708420-1-qperret@google.com>
Subject: [PATCH v2 0/4] Selftest for pKVM ownership transitions
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi all,

This is the v2 of the pKVM selftest originally posted here [1].

Changes since v1:
 - added support for testing NP guest transitions;
 - added .data section in pKVM to allow using non-zero globals (needed
   for previous point);
 - dropped superfluous WARN() from __pkvm_host_share_guest() which is a
   pain for testing;
 - updated assertions for hyp/host transitions according to the
   discussion on v1.

Patches based on v6.14-rc4, tested on Qemu.

[1] https://lore.kernel.org/kvmarm/20241129125800.992468-1-qperret@google.com/

David Brazdil (1):
  KVM: arm64: Add .hyp.data section

Quentin Perret (3):
  KVM: arm64: Don't WARN from __pkvm_host_share_guest()
  KVM: arm64: Selftest for pKVM transitions
  KVM: arm64: Extend pKVM selftest for np-guests

 arch/arm64/include/asm/kvm_pkvm.h             |   6 +
 arch/arm64/include/asm/sections.h             |   1 +
 arch/arm64/kernel/image-vars.h                |   2 +
 arch/arm64/kernel/vmlinux.lds.S               |  18 +-
 arch/arm64/kvm/Kconfig                        |  10 +
 arch/arm64/kvm/arm.c                          |   7 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   6 +
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S             |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 198 +++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  12 ++
 arch/arm64/kvm/pkvm.c                         |   2 +
 11 files changed, 260 insertions(+), 4 deletions(-)

-- 
2.48.1.658.g4767266eb4-goog

