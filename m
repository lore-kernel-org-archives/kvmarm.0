Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D0D20E030
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 15:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829967; cv=none; b=gEzoz1g4EgqOF7w8cOl9BAOTJRZhAhEqJQR7Zyy352t6WNRWBjMX8I41FETCP6td+KCsfbMFFr+ZA/N0GTGN1qX7+HNxQxSfgpw4Gl/L7lnYAdc4B7Ste1AMeHiSULKLmkxPOSOPtzVRF1SEAPQfPSBY3b0qJxToW1VL9GJLk2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829967; c=relaxed/simple;
	bh=V4PzPoOaCC/sYPuHFfUusk0N9pEzRvJQTvYtVPBjpKI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Oz4o3Ykk35hWkcVuCZbNvU/1yTZ9G8Zz7kMMV3KuEKQBLgPMTTW4Es6u5SurHpOqvYpMgAB2+5SXghwWG5s694E52wJ//SGcX03Ja+S+akbvxuIcFNRj96IwcaNOn9B7IRIYWOo+NIqYIOcEP8ykG8RyoHR10fbvcJgAuqLyTd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zzkiCJUp; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zzkiCJUp"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-87595d00ca0so206731039f.2
        for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 08:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749829963; x=1750434763; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=npODHkhgO8HUf/TrEhpf2O2lbg1BmEemgLQdrUWSQ3w=;
        b=zzkiCJUpMmbY1ogrkumOuLIquH82HSVNVBgj8tcI389dIMEhAAfQw20+Zu4V55qNTR
         7DH1yxt4CY0GAoY3i/ahuCG7CJglXUwrXBiZA9K0MSVkadnlx963B1Vw78oWF0dE/RtI
         eCqe70FlOMCw3EQR7nO46SGVzqn6JAAfb34MwyDrMyjXb5KzHP+mJb9JcD80aP5C4puc
         GVEti0viRte2cUcF0kJ5JN/HyuBpP+eF0fWLBgG8EAkm6trCKuopu47RobnCaW5mN2I6
         0oMBk3N84dsI7MA6VImYa5hSM/i/RRNrKmwhmNWmC5sRNu2mSy17fShxBsjqrQ7kl7KV
         beVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749829963; x=1750434763;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=npODHkhgO8HUf/TrEhpf2O2lbg1BmEemgLQdrUWSQ3w=;
        b=DclGjw8172TMZlpFinN2pR2+OO+pAlx/QT256DRnxZ5ZPBX+xP3K7hBv7JOxY354jJ
         4Vn6LXcBOY1DWHV1i+uwTfORwchFdKmZHpoEgURbUBhzn9q/ecjBOrlv5aAVBSd6+Pzu
         wB1nkufis9KEBxQFgHwsI/fc6U7bSzsgXia3YPk9Fce1jiixorPUBHIyVnb2XroGY6K+
         IbNiQmy5OCG6GLtIXe20Bd3a0b9wAJdSLSHM08WKE8h9VGx54WznxX408pANW74O4Q1a
         LLR6bSaOtv4NvBN0l6C3v5OtETvnJ3s4wCjj3fS1GogUYLFp/oiIhPf+LZwWokZrVbdU
         zbaw==
X-Forwarded-Encrypted: i=1; AJvYcCVg1iK3ssAk4ztxAtG0Hng3CeAnE69W2lvsYMzUnYMjKQgCKfXoKknd5etxWJytIb4dDm48eiA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyq2unYMWW00SMHsNWGq+HnWCcnHj5AoQjFtzD/fe0VYxoTLft9
	f4wRSOaJSVHweRI4LAjdHwmxMFiZt7NJy1B0yl39UYWBap31sEG8HXjZD6Xv5vnwOBKcA6Fud6m
	8svdfGw6i1g==
X-Google-Smtp-Source: AGHT+IE/scb/Nv+7qkIju6i+DJdpAZR1xpyikSby5hJxXtJQQBp8fzkrPzsEKKxna1nAOeTY0IfW56wNZKrb
X-Received: from iovg22.prod.google.com ([2002:a05:6602:3d6:b0:875:c65d:8b3])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3811:b0:861:7d39:d4d3
 with SMTP id ca18e2360f4ac-875d3c31a6fmr486593739f.3.1749829963134; Fri, 13
 Jun 2025 08:52:43 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:52:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613155239.2029059-1-rananta@google.com>
Subject: [PATCH v3 0/4] KVM: arm64: Add attribute to control GICD_TYPER2.nASSGIcap
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A shortcoming of the GIC architecture is that there's an absolute limit on
the number of vPEs that can be tracked by the ITS. It is possible that
an operator is running a mix of VMs on a system, only wanting to provide
a specific class of VMs with hardware interrupt injection support.

The series introduces KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap vGIC attribute to allow
the userspace to control GICD_TYPER2.nASSGIcap (GICv4.1) on a per-VM basis.

v1: https://lore.kernel.org/kvmarm/20250514192159.1751538-1-rananta@google.com/

v1 -> v2: https://lore.kernel.org/all/20250531012545.709887-1-oliver.upton@linux.dev/
 - Drop all use of GICv4 in the UAPI and KVM-internal helpers in favor
   of nASSGIcap. This changes things around to model a guest feature,
   not a host feature.

 - Consolidate UAPI into a single attribute and expect userspace to use
   to read the attribute for discovery, much like we do with the ID
   registers

 - Squash documentation together with implementation

 - Clean up maintenance IRQ attribute handling, which I ran into as part
   of reviewing this series

v2 -> v3:
 - Update checks in vgic-v3.c and vgic-v4.c to also include nASSGIcap (via
   vgic_supports_direct_sgis()) that's configured by the userspace. (Oliver)

Oliver Upton (2):
  KVM: arm64: Disambiguate support for vSGIs v. vLPIs
  KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling

Raghavendra Rao Ananta (2):
  KVM: arm64: Introduce attribute to control GICD_TYPER2.nASSGIcap
  KVM: arm64: selftests: Add test for nASSGIcap attribute

 .../virt/kvm/devices/arm-vgic-v3.rst          | 29 ++++++
 arch/arm64/include/uapi/asm/kvm.h             |  3 +
 arch/arm64/kvm/vgic/vgic-init.c               |  7 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 88 +++++++++++++------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 24 +++--
 arch/arm64/kvm/vgic/vgic-v3.c                 |  5 +-
 arch/arm64/kvm/vgic/vgic-v4.c                 |  6 +-
 arch/arm64/kvm/vgic/vgic.c                    |  4 +-
 arch/arm64/kvm/vgic/vgic.h                    |  7 ++
 include/kvm/arm_vgic.h                        |  3 +
 tools/testing/selftests/kvm/arm64/vgic_init.c | 41 +++++++++
 11 files changed, 176 insertions(+), 41 deletions(-)


base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
--
2.50.0.rc2.692.g299adb8693-goog

