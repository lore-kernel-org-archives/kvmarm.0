Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDB551EDF5
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790865017; cv=none; b=f8nISc08SHbbHYwHvghGxVmi8QbEWsf9VGYM/UaBbl11N1x9wuU4QdmILcQfjoxualcgC4NBGtHugM6nLaCMEe64JTfOoVSy+ddQ875sVi72wNUgW1xnpf9K5T6BoP8r0shT2XUVGPjNg9rAd3Qt85ABm6Q6sVs75n/BKj7Su3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790865017; c=relaxed/simple;
	bh=5mvgGeuPCB2KBmgjDQaNpor0vwNSwx8Tq+5I+M2VeUM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=inj73Oaxxc9pHxp/jOcW+8Z9g8Lnja0p0ACaE+171xfbo0A/UrzTyO/82H+iUbaBmdNJZg6YdHY/JEh5q7A3a24oB3Z+sSBWMAzAWekcSW1M6RQCYfiM0drm2Rde7kpF2oex9QjpPEGy6meDtXHmof+zY41yYZdKhoaxnGyQKwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fg0CsvEE; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fg0CsvEE"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a004b70f99so26730285e9.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790865008; x=1791469808; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vGROxTAoiBlO/qGW7LpK0wVm5fz+qLqAH2WB+gf4z8M=;
        b=fg0CsvEE3QehhpHjMyrc+/p15ZO9teMn1NcuGCzvEk5qALiOl4qZp/mhfJXvqdXt10
         rSy7n+1lgMZyL2yoWKdbSfFx2Yd6UfcE7dfy83JYMaQoVJE9QNQ072DTYvrBABR4pn6h
         YTQbn9g1req01B6u/uOECOl2Fjkt9yTGkLnUrKDkD3AnqVDsMiqEVn98XsMWFu9bXdLO
         E4ofVSIBNuIVqtNOHqwrCo5gr4cXOwLQLrmiOywZp197iF/cmeKwpLmT4xpBbAg4E9VE
         kNNAVThsFgRs4JYu26PKKmAffCslSjgfNYd4A6uGytOUcEeVFTzf5gIQkBPvnT+dT77C
         W4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790865008; x=1791469808;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vGROxTAoiBlO/qGW7LpK0wVm5fz+qLqAH2WB+gf4z8M=;
        b=c8uV+HUqOySQVpoBNT0o9FMOOw8Yu/xlrfhmwnCaFDOmaE2meOurLRONXgIuWGOO5w
         SRtCrger5hN+4aszKw4KpMlARuRG3ouzzbmbcul1w9YrWbn5Spco5lvuXZmSeJ9Z+NFw
         ZWQPvjzKrGdFf6XTf6o/+FFcTwm/zWVsaHA+ErGRuKs12KWn3jz8YTCoaMoxWInrFly8
         cxj+TZzfXRZcBYtCuI8vvdeKWYrm8DjS/gF+i+j/weCF9d4tqeW93wUqMdRg73qmib7o
         CDCJZmZ21UO02mIXKMc63YUQ7IvY+WCo021GzZ0JTk1SC6pD29FgEZwq0Ut3lZg2cS0k
         3j0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxFBL62dDf8355vezo7f5NAT25RlPgK4xUQJujYEA9ZPKSbB2mcR0yxQfQcgwB83syMu/73wFw=@lists.linux.dev
X-Gm-Message-State: AFuF++nk+n1W8X5fgP9ItmLfcBRgHiOlKCxZmMUwHHmPVwiHSNvwCIdV
	y/IzXJT/XZuzulsif/g9xVe1Ec5mQQ4mOAKIt3dOklF4j69CYNiMdtZWW971hGC4xTQ6ceGVALL
	F02dcdpoA1UpB6j7gxd92XQ==
X-Received: from wmbje22.prod.google.com ([2002:a05:600c:1f96:b0:4a0:7fd:46])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3152:b0:49f:ce78:356f with SMTP id 5b1f17b1804b1-4a01b13286emr78459645e9.32.1790865007673;
 Thu, 01 Oct 2026 07:30:07 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:29:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001143000.3371786-1-vdonnefort@google.com>
Subject: [PATCH v5 0/4] trace_hyp_printk() for pKVM/nVHE hypervisor
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

v5:
  - Move hyp_string_fmts into its own output section (Sashiko)
  - const hyp_string_fmt declarations and definitions
  - Guard trace_seq_used() before indexing seq->buffer in __hyp_trace_printk() (Sashiko)
  - Fix format string quoting in REMOTE_EVENT_CUSTOM_PRINTK() (Sashiko)

v4 (https://lore.kernel.org/all/20261001084909.2937943-1-vdonnefort@google.com/):
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
 arch/arm64/kernel/vmlinux.lds.S               |  8 +++
 .../define_hypevents.h}                       |  0
 .../kvm/hyp/include/nvhe/define_events.h      |  2 -
 arch/arm64/kvm/hyp/include/nvhe/trace.h       | 66 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/events.c              |  6 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  2 +-
 arch/arm64/kvm/hyp_trace.c                    | 63 +++++++++++++++++-
 include/trace/define_remote_events.h          | 19 +++++-
 12 files changed, 185 insertions(+), 9 deletions(-)
 rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

