Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E370386C03
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 08:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844590; cv=none; b=K2PljemmnMdViety58kj42tCusS7GansCuZWKRQZErAB2AcC4dSNZj1+YkZJl0WYCWk5g8wu8O7FEYyjq6PQomVBTEvICa9Dr+ESSL3YP3sGq3i/fCXCSNOOTyhtUFWTj+wyvD8NKYO83lL7Ins6cx9a4AhLX4ZyNzY5A5xraLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844590; c=relaxed/simple;
	bh=x9GdzoP9P0bFBghURdMExWBCsGVYa3xrodlBpaSCyPI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dYy4sA+cn/KWUE4M4lfG5jzsAQYeyLamnw09Ci1bF50q3Nv5rviDFc3v+S5hZVaMEutwCv31zQRNEAthwzj1HVfw/NsxU5Gs2w/CRlzg5PJbi+wLrR3gBatm2gd+EqM/24iD+d3wKHU6LdsuXhch61vzzY1Ta0/kaYe/VO01GHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mBwdXhkY; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mBwdXhkY"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4887782ab2dso5009777f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 01:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790844587; x=1791449387; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l6OQWnvlaofLL8k3CM7ZM02e20BESVixuphXWNKf53Y=;
        b=mBwdXhkYXqw4sHylrwrlFHpk+ehWu9akqz4vqC6gc8qwTE7Nccoz0zeFLtjOOt2ZTe
         QTMm0hsstuKXHgprCUNSPWbg6/7/t87yJ0xh/tFiXZVqZKT3WZSnoeJJLil2tfJrAq4Q
         3w85mcWoApnLBBN8/plmAnbxCV7bpsex8yIaC1QhTD0lz2QvGIMiJwooBSn77N0Y2Ky9
         P09q9f/4CAQygMYZMiwYHY+scmaQtXQtZM2yOc2RNtzRv81X/W0bdSvY4GKSjNMm3/WY
         +sHNQu7uqK2Fm+tqY9WMWyb15fCsHuKDpIAvuJHMHyuj7P7HKqg9HKJh6KVpgN5piXD+
         8O8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790844587; x=1791449387;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l6OQWnvlaofLL8k3CM7ZM02e20BESVixuphXWNKf53Y=;
        b=g9N8TTxMyxSb8KZ3on/xskkgOV3TyQ2WVCpYKn+rcoQpWk/xDvF1GX6L/xn+nQuZ+r
         pyujtB8iBXQHwsCfvrLPesqtPPV3K8BlF5N56duYiJrWeO9N/qm86pafygpKRV62Xich
         fDqj3/RiNJZNWGkNLWeQi8Zu3iiM5civiIOpXohsdffHL+J9mCT9MlGaoxoYaGY4zHpO
         qlB/Ak937GmoNRdiekpLR9da30iZ3eqzm9DILmi9f9PMmuDeJrK/FKr7H182zy6fGMLE
         X5D5JYF0zBTp+l5Zoqtq6A2005tUb2250lx4ZImAsT/bavlMU+PlRCeK+XvrFrvTtoOi
         B/fg==
X-Forwarded-Encrypted: i=1; AKwUvBwl2H5u/b+y68UOxx2/Rqe/VG2Lc7qnIwPDwRFpaKT36eokZCBqLI2jB9ox5EIxq58g7HeYuL8=@lists.linux.dev
X-Gm-Message-State: AFuF++k3vXVRNsr9cYhBwMbsbI4b4mbYdePjCQClzq6lVrPuLrcRI5m7
	eKOk3pBi4W70baic6HjeeyeztJ6Tt3FUdz5x1T2TAES8LBbKvWe/BlSTFtCKREIvSmOPD8N3ZrQ
	MX0oU3ZgauXFVhvaLWTsUww==
X-Received: from wryt17.prod.google.com ([2002:a05:6000:1a51:b0:48b:9d:f0bb])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4687:b0:4a0:3a3:33e2 with SMTP id 5b1f17b1804b1-4a01adde08dmr65743185e9.5.1790844586686;
 Thu, 01 Oct 2026 01:49:46 -0700 (PDT)
Date: Thu,  1 Oct 2026 09:49:04 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001084909.2937943-1-vdonnefort@google.com>
Subject: [PATCH v4 0/4] trace_hyp_printk() for pKVM/nVHE hypervisor
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi all,

This series adds a hypervisor event "hyp_printk" which enables
developers to log pretty much anything into the hypervisor tracing
buffer, just like the kernel function trace_printk().

This enables rich logging from the hypervisor, while leaving all the
string parsing burden to the kernel. This has been the main way of
debugging pKVM in Android.

Even though not strictly related to trace_hyp_printk, I have added the
following two patches:

  * KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp

    This one mainly intends to support one of the new features I have
    posted here [1], which allows to enable tracing as early as
    possible. I have added it here to limit cross-posting.

  * KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/

    This one is just a cleanup.

[1] https://lore.kernel.org/all/20260605163825.1762953-1-vdonnefort@google.com/

Changelog:

v4:
  - Store nr_args in struct hyp_string_fmt instead of using
    ring_buffer_event_length() (Sashiko)

v3 (https://lore.kernel.org/all/20260930153505.2144559-1-vdonnefort@google.com/):
  - Collect Steven's tag
  - Rebase on 7.3-rc3

v2 (https://lore.kernel.org/all/20260708075435.47419-1-vdonnefort@google.com/):
  - Collect Fuad's tags
  - Rebase on 7.2-rc2
  - Warn when trace_hyp_printk callsites are exhausted (Fuad)

v1 (https://lore.kernel.org/all/20260612142245.1015744-1-vdonnefort@google.com/)

Vincent Donnefort (4):
  KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
  KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
  tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
  KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp

 arch/arm64/include/asm/kvm_asm.h              |  4 +-
 arch/arm64/include/asm/kvm_hypevents.h        | 14 ++++
 arch/arm64/include/asm/kvm_hyptrace.h         |  9 +++
 arch/arm64/kernel/image-vars.h                |  1 +
 arch/arm64/kernel/vmlinux.lds.S               |  4 ++
 .../define_hypevents.h}                       |  0
 .../kvm/hyp/include/nvhe/define_events.h      |  2 -
 arch/arm64/kvm/hyp/include/nvhe/trace.h       | 66 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/events.c              |  6 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  2 +-
 arch/arm64/kvm/hyp_trace.c                    | 60 ++++++++++++++++-
 include/trace/define_remote_events.h          | 19 +++++-
 12 files changed, 178 insertions(+), 9 deletions(-)
 rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

