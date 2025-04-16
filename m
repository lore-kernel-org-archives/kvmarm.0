Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E1E1ADC78
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 16:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744819746; cv=none; b=oYi4W6M7GuysH9DBY/meI7Iqvdgv6Tf5gbuoieTVXIbReO+YjzwNbKcdTpb/7tG3cTfjRtLrm8jVn4PrL8aKR7//AzWWtLaxPZtQFHiFJ+RKlt5SQLzRX3Puk5XCCUSmWtYxjXTKfqGRUiwN+zItcyLdWtyuJB2+aiEzEAH4hjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744819746; c=relaxed/simple;
	bh=cEBWMBZiaKzB6xZ/YB/x5oUExde+F/u2KrlqXnVNLOE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ku4bpiptSFvUYydwBq7g6j+oOyWwhwP9/G5NDAzjeQneKJil/8HVt7cz/Wdc0D8lI0FOe2g1QT9AzJczHlzapfwiX8YZjI0/WYlem1nrmyon7n+1CaOCdFGDKYvFQp7JOtk2WYUHP9qgcmJ+bhpYYnW9+8GY68tc0LdBIkjHgqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ucrbc3GZ; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ucrbc3GZ"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5e5d9682f6eso5932340a12.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 09:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744819743; x=1745424543; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mfba1GeK9GMLIuK10iqBPbEuuHDYdzYb65zyVJOFXLI=;
        b=Ucrbc3GZ81mK/iSZqi7Jz0sFVehTJH/U0d44BSGDh85PYtbxc7zVXChybxuKrR0Jpd
         RaT0bH9k3lfFCkJAWtq0piLZBgTR2jWkghXLk3CS647aFFTLVyqf/BsM7i59ADpQcRyx
         VWwmHMynAiRFXDhGJpI+XWGxkgcfhiijRG4kjHv7wTBa80jr1UJW6wcAWm/DOtkeGwLm
         9Xr2n9vc4dQCtqfuLlDTUL72NUAm0xxINGziy6+AGdFR/7v3fzsb6Z2Sk5J39PFm8+gD
         xrUagh9Fw6qlng9DvUb3JYGZhE5iWgWvH7MAAjZPAEYvRBCvL+9bFnYXNc1KtSuiS6bj
         q58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744819743; x=1745424543;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mfba1GeK9GMLIuK10iqBPbEuuHDYdzYb65zyVJOFXLI=;
        b=SU7tceIiFAASsucHugEvN9ymgeiiFSzdO36c3NbwDrFIX+4t1VY5/1nRfqkK8vnPSD
         Gl5KHNdsts9WnJq1v/7c4fYuxs+ZJ49WX4JrTyGIcd5Pyhci/Tnejsn3O9uXn4WO4cKi
         5j8coBRKZdC9S4FwQzD8FlNNDmnWFPQzkoX/mz1v0725nSR53EfIoXFmzOBA7b4C2lQa
         gtoCJgPl5V70/52Eo0j1mjqPpmxySGb7mXzdOJfF+B+if8YZllExRKebLTQbqASt3M06
         cFwY2dR3oZAvwNsAS6lF1b+a9f3JLzbqji1pciXWw5HsGTs7VNOZoJRk71BVSAwfxT6T
         YAuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW7qSQO7S30dr1zw4FseggsjnNj8FJ5TMU9FWchU4nRP/aFq4clSaKKBo46OkERbhMUkajySc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7tFbbYqzhVywqlKr/eOnMiV6hwc6OUMKC4uHG1xi/7TJAkjaR
	c9pFntQVzc5u/eUUTNed0uNxCmwAVZ9brL7jKmIpmMAmyKE3jJFTRxoYkuMiP0Fr1WX7xagjBQi
	/npjwrA==
X-Google-Smtp-Source: AGHT+IFrirfEQ7dHJWyLJg2ZMILHkZARW2nYQJNuhY9BP7hpLfrguWr31PwCDRv8rbgrpnP6p/6BoAlGjXT/
X-Received: from edud12.prod.google.com ([2002:a05:6402:c:b0:5e4:d4fc:4841])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:27c9:b0:5e4:9726:7779
 with SMTP id 4fb4d7f45d1cf-5f4b71ea77emr2046677a12.2.1744819742333; Wed, 16
 Apr 2025 09:09:02 -0700 (PDT)
Date: Wed, 16 Apr 2025 16:08:56 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416160900.3078417-1-qperret@google.com>
Subject: [PATCH v3 0/4] Selftest for pKVM ownership transitions
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

This is the v3 of the pKVM selftest series, v2 was here [1]. This series
depends on [2] which moves the hyp tracking to the vmemmap. A full
stack on top of v6.15-rc2 with everything applied is available here:

    https://android-kvm.googlesource.com/linux qperret/pkvm-selftest-v3

Changes since v2:
 - rebased on top of v2 of the hyp-state-in-vmemmap series [2];
 - thanks to above rebase, dropped the PKVM_SELFTEST kconfig option and
   folded the selftest under the existing NVHE_EL2_DEBUG;
 - fixed commit message of patch 02

Changes since v1:
 - added support for testing NP guest transitions;
 - added .data section in pKVM to allow using non-zero globals (needed
   for previous point);
 - dropped superfluous WARN() from __pkvm_host_share_guest() which is a
   pain for testing;
 - updated assertions for hyp/host transitions according to the
   discussion on v1.

[1] https://lore.kernel.org/kvmarm/20250225015327.3708420-1-qperret@google.com/
[2] https://lore.kernel.org/kvmarm/20250416152648.2982950-1-qperret@google.com/

Thanks,
Quentin

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
 arch/arm64/kvm/arm.c                          |   7 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   6 +
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S             |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 198 +++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  12 ++
 arch/arm64/kvm/pkvm.c                         |   2 +
 10 files changed, 250 insertions(+), 4 deletions(-)

-- 
2.49.0.604.gff1f9ca942-goog

