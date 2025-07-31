Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4717624679D
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 21:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753996810; cv=none; b=miWyrfArfvnp8kvG8dNQE5U+abmw7utKGuyYw+WJlKpkjbeAUJsH7i4YzE4tyjlcMydyJEJyiCcn9n1fpvoWzI0gKXcve6z4zzHjJynip4sXtM0ApMgTuYNxnO26SNTdQNkmca7ILxpQvMlk8TzRt3pGfV+d8ocyibf4DhWc/qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753996810; c=relaxed/simple;
	bh=ap4Iq3A10A/U7xF+iUIaP24oQmDfl5UInmU7sGDN7Y4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hAe5rZr6jpT2xDrKTQVXybUyEzWig81dxSogmIV9fSiM2Mb8oSjCtVlDNgNBJxjLOGHgln4AghHAC0oJrA8FnY2S1ytLwrw5QgONq8pLsIPS+6p5nzSBxavnVLmVK8o+XQbMicpTq4ufmHGC6bWmb1QUDm2DVWwFlU+fdAteQ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=15bMTwsm; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="15bMTwsm"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76bca6c73f3so1714537b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 14:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753996808; x=1754601608; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3LhBmNVj47n+/Xo2CBpWpkvNL4bzPFglARthS3E980E=;
        b=15bMTwsmK8SdEUosAU2eWbUVbelJ5aLfG7C0LHgnnQQYXMlzh6H2qE3ZHNdTyD+6+i
         mhj03u2xRJgJiC69d7RtrlgUdbdZVtRHGuVqLo5HbNlowtqpGhjriAIa8SYVqQFJprX3
         J9TSd3eNIZz0NcWMa24qECGjEtc5ej0NeeIJVEl6HNtD10ardJtbBDYrqtYw4Nh7T9y7
         sJYhBXrq2ybxA9UycAkkqb2584rROrTEggDJvvvAdUVkDoXgG2BO+XgBkmAt2ve/ELMx
         hP0rrPDpxcoWP7D3TRnqTPhzx41W7rvJVMfu7gLdDOQTLs0g067Mxym/KgrHuSOYwEo1
         vQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753996808; x=1754601608;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3LhBmNVj47n+/Xo2CBpWpkvNL4bzPFglARthS3E980E=;
        b=RIoluMJZQTgyUCnXWzd7NzjJVYB+nrt38IzI9oZv0YF15RVl7y5wpM5RCL2U3C8xIy
         zVj4zSAonSR81NO7+NqOr7rsEde6D17+mMY3Bjlwj5EITvleJGHDdSP6NfXn0xanhBNU
         RuqzMvlnKfy7fyl8L4rzs4P/5hc6I8rrbOQKQN92j6xUM1Evvl8LrgB5QZCZNfyp7vaz
         btVY1natDn/R9eg8mNnbUd9nhDqoh6be7VF533cFktkbrkAXT/CvudyQwwXu8HxfUgTR
         PzGAXsRjBlU5XSQyp9tdKgRwgrkdBBGvwR/Pv6U1Px/FigjR9EgNrMP4WyMVk+1JODxR
         dSFw==
X-Forwarded-Encrypted: i=1; AJvYcCUpZVQH6qbfhRVFudEeyPLljLgDOLkwqZhamzdnAAHGV6k0i1QSyJbSIxGz0ViqdH9/kCqrNfg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxsxNzCbZJeqzwcbFl8wn8c2A8P/WMVAypzTwmFWu+GRV0o76AS
	mR3VMG8c8sspJ9amRs5c4oxPZGA9YKo+VYrMcB1zuzEDzJ2WbJRw0h9k8s9Arxl9WGlE8M8/TPI
	3dtQnWl4CXWRI/A==
X-Google-Smtp-Source: AGHT+IHVlDuY+fYNSvzWaCl78j3JqbZZEEmbQtyEYvAT3m66mv+lhaRSlgO6MH1HydCWLvX+Ha9fBEBU/p76uA==
X-Received: from pfhx36.prod.google.com ([2002:a05:6a00:18a4:b0:75f:8367:a75a])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7f93:b0:215:d611:5d9b with SMTP id adf61e73a8af0-23de80e503cmr119146637.12.1753996807524;
 Thu, 31 Jul 2025 14:20:07 -0700 (PDT)
Date: Thu, 31 Jul 2025 21:20:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731212004.1437336-1-jiaqiyan@google.com>
Subject: [PATCH v1 0/4] A couple of improvements for VMM to inject external
 abort to guest
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	rananta@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

There are several situations where VMM is involved when handling
synchronous external instruction or data aborts, and often VMM
needs to inject external aborts to guest. In addition to manipulating
individual registers with KVM_SET_ONE_REG API, an easier way is to
use the KVM_SET_VCPU_EVENTS API.

This patchset adds two new features to the KVM_SET_VCPU_EVENTS API.
1. Extend KVM_SET_VCPU_EVENTS to support external instruction abort.
2. Allow userspace to emulate ESR_ELx.ISS by supplying ESR_ELx.
   In this way, we can also allow userspace to emulate ESR_ELx.ISS2
   in future.

The UAPI change for #1 is straightforward. However, I would appreciate
some feedback on the ABI change for #2:

  struct kvm_vcpu_events {
    struct {
        __u8 serror_pending;
        __u8 serror_has_esr;
        __u8 ext_dabt_pending;
        __u8 ext_iabt_pending;
        __u8 ext_abt_has_esr;
        __u8 pad[3];
        __u64 serror_esr;
        __u64 ext_abt_esr;  // <= +8 bytes
      } exception;
    __u32 reserved[10];     // <= -8 bytes
  };

The offset to kvm_vcpu_events.reserved changes, and the size of
exception changes. I think we can't say userspace will never access
reserved, or they will never use sizeof(exception). Theoretically this
is an ABI break and I want to call it out and ask if a new ABI is needed
for feature #2. For example, is it worthy to introduce exception_v2
or kvm_vcpu_events_v2.

Based on commit 7b8346bd9fce6 ("KVM: arm64: Don't attempt vLPI mappings
when vPE allocation is disabled")

Jiaqi Yan (3):
  KVM: arm64: Allow userspace to supply ESR when injecting SEA
  KVM: selftests: Test injecting external abort with ISS
  Documentation: kvm: update UAPI for injecting SEA

Raghavendra Rao Ananta (1):
  KVM: arm64: Allow userspace to inject external instruction abort

 Documentation/virt/kvm/api.rst                |  48 +++--
 arch/arm64/include/asm/kvm_emulate.h          |   9 +-
 arch/arm64/include/uapi/asm/kvm.h             |   7 +-
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/emulate-nested.c               |   6 +-
 arch/arm64/kvm/guest.c                        |  42 ++--
 arch/arm64/kvm/inject_fault.c                 |  16 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   7 +-
 .../selftests/kvm/arm64/external_aborts.c     | 191 +++++++++++++++---
 .../testing/selftests/kvm/arm64/inject_iabt.c |  98 +++++++++
 11 files changed, 352 insertions(+), 74 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/inject_iabt.c

-- 
2.50.1.565.gc32cd1483b-goog

