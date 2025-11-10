Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EB015A86D
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 13:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762782329; cv=none; b=DJL9Gua8BUwDkrjGQ6TBXoxeQKUAz6ZIFWPeVqn325kxZJtkynUVYh+0EV8UepH7QMzcR5idXaIqUXWPAyv7EUG5CD+5gHVp5w+nZ5YLDc3ocCjJHC+ZvyPlIrlNUvN1yFxIgEt9gaOzzFv0BIhF9JSh7/BLGU9hM0zE6raauw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762782329; c=relaxed/simple;
	bh=jY9fc5A0aQeKcNk1/F2uwB5+3AuvzlfVSp6toxcyNOw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=l9P8GGSRnR1xWtwQuD6JVCiE8Z1p9OSa0SWu2FsEoK5DTTILK9J/U4l34nJVocJ5nr+Tw+zYYADjOWtm+rY0e3A95ENlgNMe312c0J0fumAQfVYnM/Ek8GWc1D1a2sTzgIzRGRXqFwMZxA24ToQd3hPfh8Q/UDyw5hdMlEpmL0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DuZTogeL; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DuZTogeL"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b70be4f20e0so208802466b.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 05:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762782327; x=1763387127; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IHvbo6SnYwSsQd+ne/bFLjjWVF4qCjyFEL/r++b9u/M=;
        b=DuZTogeLN9RDoVLDmgaE9EdUxJHs7Tt3xjhZqpieRKYFS/iYd8Gn4sPnp/yPQUQJep
         /QiNxk5/DcL7GbJUm4w0YlmTznj9aTsZwpMJ3ZdireDBZyN/Kc22wSVZHwY0dy97E+2P
         150gJfJKyYgj6/V1FuvmmfsvZhAS0hleezQOQDLyt+Obpt886TVFjtC3Vxehdy8afJ70
         raqU628bxT6SgEufmoEhFR3vL19vz+EXJ/8Ph43086Zn+MlJLZ6djdHdNLFgtYzX2syq
         g7k6GOCoi0P7qL2jur1NB8vNZRCcWmdC38KbSJNW5DmX5GCdMMjkNGc5q9X/y67x+7zf
         sZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782327; x=1763387127;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IHvbo6SnYwSsQd+ne/bFLjjWVF4qCjyFEL/r++b9u/M=;
        b=Cr+1JgjWn0SjGyzBLPR2mte2M7sKrqStbYy9Kp5e2vE0VUbZiTchIFg53RnKvbNCjF
         +wDa4gl4Gg/3BVePFwdl7rL19e22vqrLclZxixGl+FEOGF55JIXnEWHylKjlj9RQcA77
         DzgphbyWWrrRkKs5xRAAcUzeLVN026Ovh/7mXGDtf4kQ6+4XoKWYPnz2+K2DqCDaP+N5
         l48i5jfDAbxUrmGnd8+5MXZ0WViDBu9Zqf+C0yXe5AZqCox1Fe1gyzDdztKo0y8/XFEO
         l0KSrL+h3KF10+OBSsZv2d+4f4WLavW9hTI1GYiOSFlkewHnpq7A4NlJaMXzWKRsC35c
         fG4Q==
X-Gm-Message-State: AOJu0YyxqkPYwolzwI7QEsnPcjOhkRJ7xLVFlnyqZ3jlzBzsflrQLUYG
	3+1IA595KxNf9S6XRhab+zmxtXfXakCZ9sRoNvYrpDhuX7sWtDEjUgfMbsBJIx2RdqG4qwfE/oC
	au6L+MmsmoQmn6egZFyfvXqsMZkOFYg/ph8O0Ia/q1ruQ0/53rmtFB2FYKl+cotppRF71PNSdGW
	ewxxblAGNPeLtqDZAMXBDvJk/bTorUg/M=
X-Google-Smtp-Source: AGHT+IFvfbA62aZamyfGa4Rdc51rYmcB6jnaOM59MZ66aybSKMWuythr1PeqI/zas+fnnP1SNWeNo+j6zg==
X-Received: from ejcuv8.prod.google.com ([2002:a17:907:cf48:b0:b71:4b98:8fe3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7b96:b0:b40:fba8:4491
 with SMTP id a640c23a62f3a-b72e0310d6fmr936142966b.17.1762782326602; Mon, 10
 Nov 2025 05:45:26 -0800 (PST)
Date: Mon, 10 Nov 2025 13:45:17 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251110134525.3768197-1-tabba@google.com>
Subject: [PATCH v3 0/8] KVM: arm64: Fixes for guest CPU feature trapping and enabling
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Hi,

This series contains several fixes for guest feature trapping and
enabling, as well as a bit of tidying up.

Changes from v2 [1]:
- Instead of a FAR_MASK, introduce a helper FAR_TO_FIPA_OFFSET() to
  extract the offset (Oliver)
- Expanded capability check in pKVM to include the VM type, since
  certain capabilities are restricted for all VM types in pKVM, whereas
  others are restricted for only protected VMs.
- Do not allow KVM_CAP_ARM_MTE for any VM type in pKVM
- Restrict which VM IOCTLs are allowed in pKVM based on the allowed
  capabilities for that VM (Oliver)
- Remove unnecessary checks for VM type when setting/getting arch timer
  state (Oliver)
- Based on Linux 6.18-rc5.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20251106144418.2847443-1-tabba@google.com/

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
 arch/arm64/include/asm/kvm_pkvm.h        | 33 +++++++++++++++++++++---
 arch/arm64/kvm/arch_timer.c              | 18 +++++++++----
 arch/arm64/kvm/arm.c                     |  7 +++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c           | 20 +++++++-------
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 arch/arm64/kvm/inject_fault.c            |  2 +-
 arch/arm64/kvm/mmu.c                     |  4 +--
 8 files changed, 64 insertions(+), 24 deletions(-)


base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
-- 
2.51.2.1041.gc1ab5b90ca-goog

