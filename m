Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D8B1F30A4
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402681; cv=none; b=EX0jAKyacNpzJ4Dzyx5mTCzWZ1/8OB4MfQcRNVNsFDvvFJEyjSmy/GZaX+gqoEhuAkWYmkUUO5v96mGHPzNoFIKI+ysjbgaoUWiJTmeyWI73JnK16MM1CGIM5o9dKkJdgRd1+i1ZXLmQO5YcQIIGiW2ChG+xLl8FPkjMfZ43t/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402681; c=relaxed/simple;
	bh=zf5g9JVbffHwDWLfAsqx3YYCXepP/f3rF8cm6T8Oh1I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bpfqRCFGw2RO7JzTBAFqsLvPbjC3qFU3vxmOkIdSw+zsnm+oHBYDsTdeJM1qZK+fcanIU+1KyzGBtSqQycOGVw2oUzPY40V/Ln057vpwQ8GkLBqPZa4jRLT421B89Veg84CCjLkQ6utJB67xAEg2oHW613qDqkdnSE5OlwWYLVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ooks1ANK; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ooks1ANK"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45cb6d8f42bso50224425e9.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 00:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757402678; x=1758007478; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4jsEz9fgJmk0ksX4kLPAefA4ve+DQm6tpFhq1fTW05k=;
        b=Ooks1ANKV60F/SZ64iBo0gqkphZ29AJquYz6ISiJkew7njvVVISKjFmyj32D5cK1PD
         7QsFdBXIi4ApgN5HyO1qqiCX16gG4nCEJ1MHuh30SiohPZ87hp4RtpZMoiaWhh4ogLxB
         Im7V0t4oY89Oh4ACjckXEwyUtyq4AmmD0xbLw6/KE4tl/h7xPUxDaiXMzAfnR1ZMydt1
         MnpXA27IGeE3I7FzASDl5OLc84zrRID0f9+4CENvGmoIvRSo1Dtd94YVh4jYh9G/T6HW
         0nxWyV7Ts9fvEQB4Qp7Y4HSK9N3HpI7IHjb7nYL5DE15s/MbwSBUEa7RV3gWMZ6bfN3R
         FOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757402678; x=1758007478;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4jsEz9fgJmk0ksX4kLPAefA4ve+DQm6tpFhq1fTW05k=;
        b=t6KheVl9IpAthLmewHaYtY9Sap388mIdp0MhXMNwH1WPtcRz8vuS5F6c/ARHllqUOT
         Ce110GaBRVPVfglwsxuaE+mxj0Fej65Qs3b6z9LIbN+1xzLJ0T9wyu5T94LAcEbBVAos
         wpA+33406b7q5ALO9bhSG8tiMmoKoIQUQN3VuB9Q3Q8iqpij805UP/ztRGPIelHUCZjG
         JTCGFx2MXSXBACbCgFIiDR+2OMCVTVfUBQaIEVAZMQ8iz/7yg4tYzjFPkVahOgeXOOb8
         WdwiP1ZfglDMcFLMEtw0yyPl6fFilNTtT5KnQlcFAT/jO7bl4GEhElSAv/vwKE4Gwvkz
         Irdw==
X-Gm-Message-State: AOJu0Ywq9plCgd2u41G9nyjYWIBN35w9WZEMHKk3TWYzk6lVyKONijZ0
	wFkljg/2+Vwy+BCEiRVY7xZcmGLBoBR1lHphLTwlk+Tt4mhy4+Nch8GmGDM0twUhTEE+7kKMK88
	tOB/ZVXWwoS+pw9MyoatKfKfIISHwfOp2kg81FZk2vDGLq+mCeDVWxgsHC8lD1fj7+ndKc5u8VW
	4HImtM78/S+Xt+oZFNBlhYfZ/n6vCRcdg=
X-Google-Smtp-Source: AGHT+IEJrT7+VCqOsjnlAYQHGj+Hsu9QmUjEOE0MGoJ33in3RdQuQRwfShGEQa2Lrq6j1uzXWgMfX9wydA==
X-Received: from wmbei18.prod.google.com ([2002:a05:600c:3f12:b0:458:bdde:5c9b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5493:b0:45d:98be:ee9e
 with SMTP id 5b1f17b1804b1-45ddde6a3f0mr85599835e9.1.1757402677896; Tue, 09
 Sep 2025 00:24:37 -0700 (PDT)
Date: Tue,  9 Sep 2025 08:24:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909072437.4110547-1-tabba@google.com>
Subject: [PATCH v4 0/9] KVM: arm64: Reserve pKVM VM handle during initial VM setup
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes since v3 [1]:
- NOTE: only the last patch (9/9) has changed.
- Fix bug reported by Mark [2]. The existing call to pkvm_init_host_vm()
  wasn't gated by protected mode being enabled, unlike the call to
  pkvm_destroy_hyp_vm(). This imbalance caused failures in non-protected
  mode, especially when creating and destroying multiple VMs. Tested
  with kvm demand_paging_test using nvhe, vhe, and protected.
- Rebase on Linux 6.17-rc5

All VMs in pKVM identified by their handle, a unique per-VM ID. This
handle is shared between the host kernel and the hypvervisor, and used
to track the VM across both.

In pKVM, this handle is allocated when the VM is initialized at the
hypervisor, which is on the first vCPU run. However, the host starts
initializing the VM and setting up its data structures earlier. MMU
notifiers for the VMs are also registered before VM initialization at
the hypervisor, and rely on the handle to identify the VM [3].
Therefore, there is a potential gap between when the VM is (partially)
setup at the host, but still without a valid pKVM handle to identify it
when communicating with the hypervisor.

Additionally, in the future, the host needs to communicate with
TrustZone about the before the VM first run. Therefore, move handle
creation to when the VM is first initialized at the host.

This patch series also takes the oportunity to do some refactoring
(mostly renaming and fixing documentation) of the code. We are in the
process of upstreaming pKVM. Refactoring this code now would generate
less churn than postponing it, as the upstreamed codebase grows.
Moreover, the exsiting names and documentation are at best misleading
(and in cases actually wrong), which could lead to more confusion and
problems reviewing code in the future.

This patch series is divided into two parts:

- Patches 1-5: Renaming, refactoring, and tidying up to lay the
  groundwork for moving handle initialization and to fix existing
  issues.
- Patches 6-9: Decouple handle creation from VM initialization at the
  hypervisor and move the handle creation to VM initialization at the
  host.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250827101949.4089456-1-tabba@google.com/
[2] https://lore.kernel.org/all/1a248f14-60f2-4f8f-8b4d-3c63e602fd54@sirena.org.uk/
[3] https://lore.kernel.org/all/20250303214947.GA30619@willie-the-truck/

Fuad Tabba (9):
  KVM: arm64: Add build-time check for duplicate DECLARE_REG use
  KVM: arm64: Rename pkvm.enabled to pkvm.is_protected
  KVM: arm64: Rename 'host_kvm' to 'kvm' in pKVM host code
  KVM: arm64: Clarify comments to distinguish pKVM mode from protected
    VMs
  KVM: arm64: Decouple hyp VM creation state from its handle
  KVM: arm64: Separate allocation and insertion of pKVM VM table entries
  KVM: arm64: Consolidate pKVM hypervisor VM initialization logic
  KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and
    initialization
  KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()

 arch/arm64/include/asm/kvm_asm.h              |   2 +
 arch/arm64/include/asm/kvm_host.h             |   5 +-
 arch/arm64/include/asm/kvm_pkvm.h             |   1 +
 arch/arm64/kvm/arm.c                          |  14 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   4 +-
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  14 ++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 177 +++++++++++++-----
 arch/arm64/kvm/pkvm.c                         |  76 +++++---
 9 files changed, 221 insertions(+), 75 deletions(-)


base-commit: 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c
-- 
2.51.0.384.g4c02a37b29-goog

