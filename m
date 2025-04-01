Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30ED2144BB
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 17:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527142; cv=none; b=a4WGx9NXRlUj4UymqT9BJArwe97TVdDl6u8b5YXBqcHnbVmIOgiZb8uv3yh9jV+SX5o5/wJJV4gjBCa+igYO7szdqbCz1uH3J+n44iddvbAxmIFYn0rRR+wn1ifW4MIk3yzTLuxL1ipYa5ZtH/jWploF28zDdkdmCRyI/ZxsSAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527142; c=relaxed/simple;
	bh=bK8cIX3OFP4rUiDQsRwujwFmajdJ1YJWxtYFE3tvf+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ruQK8u/D6hUzDXB/GL7KtzVpSbxHwZ+DrWdd4oOh0Me+66+HoG+C7gX1kU4FORui2zquMY2YN1JkvG1uOXJARRCVoQIwz6JSrDkmuXwnom6bgKiZoQGfYJI/1ZivGyCTRtoaScp6Eiu56ZLcnYQrsKyg+WNf39ta6Wc3orO441U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eDykC+gl; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eDykC+gl"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-227c7e57da2so87667335ad.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 10:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527140; x=1744131940; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lwYo+vpHICGEFIrFsDjs61lUmWGjlXmdbGdB6t1/xV8=;
        b=eDykC+glW5AlLwRlw5dAOyWqn5RHBw8QkMLxUYZASZVdMpI8SJXdaqoI7dEB5Bf0G1
         rxkriIzWO7vtITG4mlbhYBwG03StNHQmxHS4GbeiGVWfIAXTUdcwR7+qYUeHQTewX7W2
         HZ7TGJIQK4Nfp3h1RDIexAKfU2wh3pr3lPsaH7C004JAZbiU2uXwYZ4LQpEa73yRh4+B
         nUGUj46w5gc7hw6L1IZrn0iJcj/ETyS5WpFhdHBYiStLOaA8lmK1XsUNm/13gt413VxA
         4W6sHUUQ9JkRX4adXmrQgRGoKpT127JTug3YCB5dTuxP9hkRDbJvQ60DlYd42gT+uqVd
         oT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527140; x=1744131940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lwYo+vpHICGEFIrFsDjs61lUmWGjlXmdbGdB6t1/xV8=;
        b=jAIm5QZCMPw7jvenwsRn0NlsZTn9d/l8hR0gFNY0eyNGCiX6qPYF4STlElWKgbtN2U
         ueIKNk9VUC0lJYkTK4DULV1Q+ljqLgb5Sc6EKdCccQAI6kO7Eka2YOwGF2Wi8Qrm9oH7
         uZm5eHH/fPNa73y6PNQPpbbTvkKG3xlQ9fnGWLUlOc/zeM3eqKcuFk+Dtvs4hiXAb6Yv
         itgzZH8mlK+HfyWHj+jUOGJN2Mx8D7Y/u4odhKJPkzlOro7TGTXd0GHss25XKwz3OaH6
         HaNdbHYdHxvvM1OCojnA4l4gh28QtC5yT3+ZlcjYPESlI7vACdtvmGVjYp2I/gYnuWnn
         MmHA==
X-Gm-Message-State: AOJu0Yyf3dvxWNJnAatXTPemXcqPZ7fe847IAdHUEWH+PPqHDme+2tbh
	cRue5jmwSR2lNK32+QCaB2iLZ5rbaJHxvTElOPymBechNf2h+T7+5FijsTTY
X-Gm-Gg: ASbGnct5KbS64AutJaVjUssD9ELiZC7JHCjkMXLsAIerBU/C1utJg7TGRi5ALvr3/CQ
	FlcWtp8zJ8JMQHjtKpgrVy8iFgqDqZ7r95pc+s7RZpb0BUYP5ndnJZdYg1OKRPKPxvzAqsOWUd+
	tVYjj1iiZENNM5tMCKt8U/+9hkjEeGxe6G3FFSGnGjfUuwbNgrHUshyRYX2BDLbeqGWK3Lrz1gc
	9hsFikpc+XcfjlSHy7G33Jgtff0H0lw8Fv7ncy6iBhtkwRVBs0PjjBM0focm4g6RNdf+8hAkkVp
	amA/trbKJHwBYcL1i0LWl7S7d6JdJQcqpsujKpyl
X-Google-Smtp-Source: AGHT+IFEvYytRdg391G6CjRRcmMIVZzT4FP14E79ln6almPrbWMBy0MiYqFatLnKZGuIRrmb5n4fMQ==
X-Received: by 2002:a17:903:1c7:b0:21f:4b01:b978 with SMTP id d9443c01a7336-2292f9e8394mr200725215ad.36.1743527139697;
        Tue, 01 Apr 2025 10:05:39 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:05:39 -0700 (PDT)
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	jens.wiklander@linaro.org,
	sumit.garg@kernel.org,
	mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	pbonzini@redhat.com,
	praan@google.com,
	Yuvraj Sakshith <yuvraj.kernel@gmail.com>
Subject: [RFC PATCH 0/7] KVM: optee: Introduce OP-TEE Mediator for exposing secure world to KVM guests
Date: Tue,  1 Apr 2025 22:35:20 +0530
Message-ID: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A KVM guest running on an arm64 machine will not be able to interact with a trusted execution environment
(which supports non-secure guests) like OP-TEE in the secure world. This is because, instructions provided
by the architecture (such as, SMC)  which switch control to the firmware, are trapped in EL2 when the guest
is executes them.

This series adds a feature into the kernel called the TEE mediator abstraction layer, which lets
a guest interact with the secure world. Additionally, a OP-TEE specific mediator is also implemented, which
hooks itself to the TEE mediator layer and intercepts guest SMCs targetted at OP-TEE.

Overview
=========

Essentially, if the kernel wants to interact with OP-TEE, it makes an "smc - secure monitor call instruction",
after loading in arguments into CPU registers. What these arguments consists of and how both these entities 
communicate can vary. If a guest wants to establish a connection with the secure world, its not possible. 
This is because of the fact that "smc" by the guest are trapped by the hypervisor in EL2. This is done by setting
the HCR_EL2.TSC bit before entering the guest.

Hence, this feature which I we may call TEE mediator, acts as an intermediary between the guest and OP-TEE.
Instead of denying the guest SMC and jumping back into the guest, the mediator forwards the request to
OP-TEE.

OP-TEE supports virtualization in the normal world and expects 6 things from the NS-hypervisor:

1. Notify OP-TEE when a VM is created.
2. Notify OP-TEE when a VM is destroyed.
3. Any SMC to OP-TEE has to contain the VMID in x7. If its the hypervisor sending, then VMID is 0.
4. Hypervisor has to perform IPA->PA translations of the memory addresses sent by guest.
5. Memory shared by the VM to OP-TEE has to remain pinned.
6. The hypervisor has to follow the OP-TEE protocol, so the guest thinks it is directly speaking to OP-TEE.

Its important to note that, if OP-TEE is built with NS-virtualization support, it can only function if there is 
a hypervisor with a mediator in normal world.

This implementation has been heavily inspired by Xen's OP-TEE mediator.

Design
======

The unique design of KVM makes it quite challenging to implement such a mediator. OP-TEE is not aware of the host-guest
paradigm. Hence, the mediator treats the host as a VM with VMID 1. The guests are assigned VMIDs starting from 2 (note,
these are not the VMIDs tagged in TLB, rather we implement our own simple indexing mechanism).

When the host's OP-TEE driver is initialised or released, OP-TEE is notified about VM 1 being created/destroyed.

When a VMM (such as, QEMU) created a guest through KVM ioctls, a call to the TEE mediator layer is made, which in-turn
calls OP-TEE mediator which eventually assigns a VM context, VMID, etc. and notifies OP-TEE about guest creation. The
opposite happens on guest destruction.

When the guest makes an SMC targetting OP-TEE, it is trapped by the hypervisor and the register state (kvm_vcpu) is sent to
the OP-TEE mediator through the TEE layer. Here there are two possibilities.

The guest may make an SMC with arguments which are simple numeric values, exchanging UUID, version information, etc.
In this case, the mediator has much less work. It has to attach VMID into X7 and pass the register state to OP-TEE.

But, when guest passes memory addresses as arguments, the mediator has to translate these into physical addresses from
intermediate physical addresses (IPA). According to the OP-TEE protocol (as documented in optee_smc.h and optee_msg.h),
the guest OP-TEE driver would share a buffer filled with pointers, which the mediator translates.

The OP-TEE mediator also keeps track of active calls between each guest and OP-TEE, and pins pages which are already shared.
This is to avoid swapping of shared pages by the host under memory pressure. These pages are unpinned as soon as guest's
transaction completes with OP-TEE.

Testing
=======

The feature has been tested on QEMU virt platform using "xtest" as the test suite. As of now, all of 35000+ tests pass.
The mediator has also been stressed under memory pressure and all tests pass too. Any suggestions on further testing the
feature are welcome.

Call for review
===============
Any insights/suggestions regarding the implementation are appreciated.

Yuvraj Sakshith (7):
  firmware: smccc: Add macros for Trusted OS/App owner check on SMC
    value
  tee: Add TEE Mediator module which aims to expose TEE to a KVM guest.
  KVM: Notify TEE Mediator when KVM creates and destroys guests
  KVM: arm64: Forward guest CPU state to TEE mediator on SMC trap
  tee: optee: Add OPTEE_SMC_VM_CREATED and OPTEE_SMC_VM_DESTROYED
  tee: optee: Add OP-TEE Mediator
  tee: optee: Notify TEE Mediator on OP-TEE driver initialization and
    release

 arch/arm64/kvm/hypercalls.c        |   15 +-
 drivers/tee/Kconfig                |    5 +
 drivers/tee/Makefile               |    1 +
 drivers/tee/optee/Kconfig          |    7 +
 drivers/tee/optee/Makefile         |    1 +
 drivers/tee/optee/core.c           |   13 +-
 drivers/tee/optee/optee_mediator.c | 1319 ++++++++++++++++++++++++++++
 drivers/tee/optee/optee_mediator.h |  103 +++
 drivers/tee/optee/optee_smc.h      |   53 ++
 drivers/tee/optee/smc_abi.c        |    6 +
 drivers/tee/tee_mediator.c         |  145 +++
 include/linux/arm-smccc.h          |    8 +
 include/linux/tee_mediator.h       |   39 +
 virt/kvm/kvm_main.c                |   11 +-
 14 files changed, 1721 insertions(+), 5 deletions(-)
 create mode 100644 drivers/tee/optee/optee_mediator.c
 create mode 100644 drivers/tee/optee/optee_mediator.h
 create mode 100644 drivers/tee/tee_mediator.c
 create mode 100644 include/linux/tee_mediator.h

-- 
2.43.0

