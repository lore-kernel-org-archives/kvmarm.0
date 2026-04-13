Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB1A3542E5
	for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 20:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113197; cv=none; b=TV+25WZpF0TunF7P0Dn27D4QS2ih9baPkVNw+B7PG0lMelpBBhGTUYGYZXeuBWRxWEplnNAFN1J0iE53fqzYsTg5COHsAr3FugjXGtWzzWmzTNnJnsvnu98sUc+R0ydKPPm4NghtgA0kaSnoUlVmL6B3VsHOzlfMjByhk4eBa/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113197; c=relaxed/simple;
	bh=uprHKwXObO+AE6bDi/TNr7PFtVJVYS3qu7Pa4B009Uk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=a18R0nT/FVjgYmBEeRrGTTn7p3JbFRwAsOMt7pgzCN5Nn+0Sy10KhzcVNEzrPu2JCPd6GR9BHTrFg9V3eEpPYM2+R3SOT20O7hDk8pq0W9pJUD5U53wkmGmQnncFQuTIH11DxtVY2bAWsoxzK7iQqZ91p1m46yk4kiWmzOU14qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QTLjRnhN; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QTLjRnhN"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f45dadbe6so1398427b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 13:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776113196; x=1776717996; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I7eiz8y/l7lCP2hNqNsnkSrKMhwpC7fnrESdccwzjeo=;
        b=QTLjRnhNTkL5M4pMLbLcHh0UEXXML/xB0K2of6HBNQPNrKfTZP5xjbbTlnzcCLHETv
         SLBwhqJ+4NJRfkrXYH3Tc2Q1mxozsrhdjlmn4gMTyFw0WiF6GjvCILwpvneStWkeJAWj
         4YQujrwhw4PTfRRBMoTQ+9L/4oEV0YecTWL4JA7efK4eY4wUAcgDATebAtJTF7qxZ9BJ
         pAugv5BwnG/UruepHD7DSup5ucrvciN7KRG1uzNMD6GDs810N+zvxUKewYbFfsveEShU
         h5Um1KuXtESmWzSjpymyEGMXIL4DFAXFmpEy+7BGycpISrKEJrt2XkgbT0CIKoOBuLS3
         /IOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776113196; x=1776717996;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I7eiz8y/l7lCP2hNqNsnkSrKMhwpC7fnrESdccwzjeo=;
        b=kCPdor7Vcql68jWX265ZoTxjbCyjvGX68vp3dYCt3pPNPuuYxtr+knHJPEu5VuzElR
         oOtaoNqhtRn9xHdJORY1fuQTHqf5kFfaJbFoZEixB4LD5L1jPfMVI7enLJiFJmA795K0
         2L3hR90/ZlH1uLorEKnGTBIR34Ky/9LL/LkCF16PFpV4SKIJB2XRIwRnZJyc1mYPltfY
         LhqRllIjraGYYVN2FRUiOLiNdOwH9fogWC8TbTtVtsmvRy5sHDgihQb0sXc3oPUE7Zle
         q0NsuSv44z1Ai9ax6z/Kb5ZWMTcZpX3xpED6A0o8mviUJXiim5HahiJx/Ffp74Y/qBH6
         +2ow==
X-Forwarded-Encrypted: i=1; AFNElJ9dBHtZ0BkMMDaJC4L5ekUm2fWR1e6bqNx3cX1xA8fwhvz02kxCS1bK4Ukazc6YasGOVfPb9nk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWrEi6ZS0Oz3IRHfuI24+/QWNcpPw2C9zGYvC2/kCMhP+yFZvM
	o0LprjeSsh2/aRfGGt8YeEu9CeUHoKZE2mGsfQNmhLg2EMz211W+WpeIL0dpdF0/fW49wLXYLjE
	X35BUd8f+K8AaUsGdm+rfoVUO4A==
X-Received: from pfbfb22.prod.google.com ([2002:a05:6a00:2d96:b0:827:1713:6de8])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1a8e:b0:82f:3828:a00a with SMTP id d2e1a72fcca58-82f3828b18dmr6883092b3a.41.1776113195294;
 Mon, 13 Apr 2026 13:46:35 -0700 (PDT)
Date: Mon, 13 Apr 2026 13:46:23 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
Message-ID: <20260413204630.1149038-1-jingzhangos@google.com>
Subject: [kvm-unit-tests PATCH v2 0/7] arm64: Add Stage-2 MMU and Nested Guest Framework
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series introduces a lightweight infrastructure for managing ARM64
Stage-2 translation tables and executing nested guests. These components are
essential for testing advanced virtualization features such as nested
virtualization (NV) and GICv4 direct interrupt injection.

The series provides a generic Stage-2 MMU library supporting multiple
translation granules (4K, 16K, 64K) and dynamic page table management.
Building on this, it adds a guest execution framework that handles guest
lifecycle management, context switching and guest exit routing. A new test
case for Stage-2 MMU demand paging to verify fault handling.

Please note that this is a very preliminary implementation intended as a
startup baseline for future work in virtualization testing. Users should be
aware that because this is an early-stage baseline, some portions of the code
may just happen to work in its current state. There might be critical
architectural elements or edge-case handling missing that will need to be
addressed as the framework matures.

---

* v1 -> v2
  - Used generated `struct guest` offset instead of hardcoding.
  - Cleaned up register definitions.
  - Refined EL1/EL2 exception vector tables.
  - Split monolithic patches into a series of granular commits.
  - Addressed other review feedbacks.

[1] https://lore.kernel.org/kvmarm/20260316224349.2360482-1-jingzhangos@google.com/

---

Jing Zhang (7):
  lib: arm64: Generalize ESR exception class definitions for EL2 support
  lib: arm64: Add stage2 page table management library
  lib: arm64: Generalize exception vector definitions for EL2 support
  lib: arm64: Add foundational guest execution framework
  lib: arm64: Add support for guest exit exception handling
  lib: arm64: Add guest-internal exception handling (EL1)
  arm64: Add Stage-2 MMU demand paging test

 arm/Makefile.arm64         |   4 +
 arm/debug.c                |   6 +-
 arm/gic.c                  |   2 +-
 arm/micro-bench.c          |   4 +-
 arm/mte.c                  |   6 +-
 arm/pl031.c                |   2 +-
 arm/pmu.c                  |   2 +-
 arm/psci.c                 |   2 +-
 arm/selftest.c             |   6 +-
 arm/stage2-mmu-test.c      | 107 ++++++++++
 arm/timer.c                |   6 +-
 lib/arm64/asm-offsets.c    |  15 ++
 lib/arm64/asm/esr.h        |   5 +-
 lib/arm64/asm/guest.h      |  91 +++++++++
 lib/arm64/asm/processor.h  |  32 +--
 lib/arm64/asm/stage2_mmu.h |  70 +++++++
 lib/arm64/asm/sysreg.h     |   7 +
 lib/arm64/guest.c          | 158 +++++++++++++++
 lib/arm64/guest_arch.S     | 248 +++++++++++++++++++++++
 lib/arm64/processor.c      |  18 +-
 lib/arm64/stage2_mmu.c     | 403 +++++++++++++++++++++++++++++++++++++
 21 files changed, 1149 insertions(+), 45 deletions(-)
 create mode 100644 arm/stage2-mmu-test.c
 create mode 100644 lib/arm64/asm/guest.h
 create mode 100644 lib/arm64/asm/stage2_mmu.h
 create mode 100644 lib/arm64/guest.c
 create mode 100644 lib/arm64/guest_arch.S
 create mode 100644 lib/arm64/stage2_mmu.c


base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
-- 
2.53.0.1213.gd9a14994de-goog

