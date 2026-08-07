Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3B53BCD38
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121023; cv=none; b=qAsQSZuJXoA1rsvVgSSih9hVA1rY8dj4ccpkFbw2+dgcu7bszzOJ+/31xNlmOs7OVzQso9JkoE4whOOg4bS1PGwSE+TytnqSZgKTd7nTxcOmMWIjS62nE/HGo24gsZ44VnHBpVEIT8xVZ6IDYymyB8r63gP+7DtDu30Q/25v7yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121023; c=relaxed/simple;
	bh=jdHHkjwb6MG0GrU8fafIHmKkzKn89yZDgBACaHICmHk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GoCesUZYTRIc6okDUH0XdFkCPHMx+oUC0hBy5PLcE4nb6gEtPsftOuZabUxm3gqV+Hx8hSpwHThDu2bi77jvq6lXxI0HsgFEjG1nS6sewewunU20fcR41lbjQ1lNchbDWhZPJ2EsUlpraj02BKRnDh/zHKoUhJpV/p8WuqnkJmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pUYz2unA; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pUYz2unA"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-698a99b6140so3434228a12.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121018; x=1786725818; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v26QekWjf9eH2OeAer5pKNY67Fs+em5JTtiXnChoKig=;
        b=pUYz2unAbIVewYVuYdGt9oXemUUDUROb+cyhL4u78LwyDvCvrpE9MPnTAERaGMOuCa
         LYy4sLHUjYjmQhuwTQ14EIVqoZIWFVfMuNCXqEhvhJU0p8OXDcAj6pWCtEM8DZS5fpCB
         WtXjBO59BFVXYuN1ZoXoHXfnGDJv5eW4Vr9vuoXOjidr1nhHdE6oOmONAl7e1EVK8W1I
         MBbnwfouHMBwpyc2s+njzf6BbQqDCZfun53e9DAk6x3hU7EMOLM2WqSbzE2+BClb1ZRg
         KIgZOMbHlZLkJSNL5WMqQGupRi/MWCjYJfWdpddQdLkYo3ZJqRGu8f3FIlgkR7aPGGaC
         gcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121018; x=1786725818;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v26QekWjf9eH2OeAer5pKNY67Fs+em5JTtiXnChoKig=;
        b=QN7AaAtW87a/QY1OZ6HBZJndcyTQsdxkIBIib8aazpJx/XYBMN1Y5UN2talyHAB1RV
         izwT5LUuh6yvTI1Zxw1hiPXZhbVqySaBOPgLPLLkGmslhQjVu+JhnpkHs7iwCjHHEsJZ
         jKz9YDD5B0pV+kpjX2bzZgbF3MJllcfRn5aQoTys/gGVoQ4v+27mYLma7KWsL6BD8CSj
         mXeT+8NO12BpjtMqRgpu8o7LBiEP4WzyLMvP++27E+S7ieU7MOwpSzam9wGmCq6rxOQd
         F7cZxu5FMxwcYxsVrO/BPHaqsHzG2S+aC2bbOTFQihNZR279yhfkM60Xl+3HLvoO6+b0
         cEAA==
X-Gm-Message-State: AOJu0YxANAlr5N+/6OEC0iJiNwGkU5za0og2xAuFwQeAa6xhWPOwnSjd
	a44mF4rwpDAyBm+0xPI7InBcudjgdUTAc9NfdJs6CKLyiqCVtRukezJOpSOGvPzXUoSnnoSrrI0
	x5pycSyUU4B3j8JeN7UHrpjjov5oStA==
X-Received: from educ11.prod.google.com ([2002:a05:6402:100b:b0:6a0:7d05:aecc])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5416:b0:699:fbe4:16d5 with SMTP id 4fb4d7f45d1cf-6a14f07bde3mr14496650a12.1.1786121018308;
 Fri, 07 Aug 2026 09:43:38 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-2-sebastianene@google.com>
Subject: [PATCH v2 00/13] KVM: ITS hardening for pKVM
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

This series introduces the necessary machinery to perform trap & emulate
on device access in pKVM. Furthermore, it hardens the GIC/ITS controller to
prevent an attacker from tampering with the hypervisor protected memory
through this device. 

In pKVM, the host kernel is initially trusted to manage the boot process but
its permissions are revoked once KVM initializes. The GIC/ITS device is
configured before the kernel deprivileges itself. Once the hypervisor
becomes available, sanitize the accesses to the ITS controller by
trapping and emulating certain registers and by shadowing some memory
structures used by the ITS.

This is required because the ITS is in complete host control and can issue
transactions on the memory bus without having any protection in front of it
(IOMMU or SMMU). With pKVM this makes it an interesting target for crossing the
hypervisor privilege boundary because with pKVM the security model is
that the host is untrusted. 

Patches overview
================

The first patch is an adaptation of Mostafa's patch for donating MMIO to
the hypervisor which can be found here [1]

[1] https://lore.kernel.org/all/20260715115906.2664882-3-smostafa@google.com/

The only difference is that this maps MMIO in the linear space of the
hypervisor, but after discussing with him on the list [2]
(https://lore.kernel.org/all/anMwxy9gEEt_Wu6M@google.com/) he seems to be
more inclined to having the IO in the private VA mapping space. For
simplicity, I used the linear map but I am happy to change it this is
required as it doesn't change the code too much.

The next 2 patches add some basic infrastructure to be able to keep
track of the unmapped MMIO regions from the host and invoke a handler
when a stage-2 data abort happens in that region.

The 4th patch looks up the ITS node from the device tree and adds it to
an array of unmapped devices. It install a handler that forwards all the
MMIO request to mediate the host access inside the emulation layer and
to prevent breaking ITS functionality. 

The 5th patch changes the GIC/ITS driver to exposes two new methods
which will be called from the KVM layer to setup the shadow state and
to take the appropriate locks.

Patch 6 adds the entry point into the emulation setup and sets up the
shadow command queue. It adds some helper macros to define the offset
register and the associate action that we want to execute in the
emulation. It also unmaps the state passed from the host kernel
to prevent it from playing nasty games later on. The patch
traps accesses to CWRITER register and copies the commands from the
host command queue to the shadow command queue. 

Patch 7 prevents the host from directly accessing the first layer of the
indirect tables held in GITS_BASER<n>. It also prevents the host from
directly accesssing the last layer of the Device Table (since the entries
in this table hold the address of the ITT table) and of the vPE Table
(since the vPE table entries hold the address of the virtual LPI pending
table.

Patches [8-10] sanitize the commands sent to the ITS and their
arguments.

The next patches restrict the access of the host to certain registers
and prevent undefined behaviour. Prevent the host from re-programming
the tables held in the GITS_BASER register.

The last patch introduces an hvc to setup the ITS emulation and calls
into the ITS driver to setup the shadow state. 

Design
======


1. Command queue shadowing

The ITS hardware supports a command queue which is programmed by the driver
in the GITS_CBASER register. When ITS emulation is enabled, the ITS
driver allocated a copy of the original command queue and uses the copy
and the emulation layer restricts the access to the original queue for
the host. When the driver sends a command to the mirrored queue, the
emulation traps on the write to GITS_CWRITER register and validates the
command before writing it over to the original queue. 


2. Indirect tables first level shadowing

The ITS hardware supports indirection to minimize the space required to
accommodate large tables (eg. deviceId space used to index the Device Table
is quite sparse). This is a 2-level indirection, with entries from the
first table pointing to a second table.

An attacker in control of the host can insert an address that points to
the hypervisor protected memory in the first level table and then use
subsequent ITS commands to write to this memory (MAPD).

To shadow this tables, we rely on the driver to allocate space for it
and we copy the original content from the table into the copy. When
pKVM becomes available we switch the pointers that hold the orginal
tables to point to the copy.
To keep the tables from the hypervisor in sync with what the host
has, we update the tables when commands are sent to the ITS.


3. Hiding the last layer of the Device Table and vPE Table from the host

An attacker in control of the host kernel can alter the content of these
tables directly (the Arm IHI 0069H.b spec says that is undefined behavior
if entries are created by software). Normally these entries are created in
response of commands sent to the ITS.

A Device Table entry that has the following structure:

type DeviceTableEntry is (
	boolean Valid,
	Address ITT_base,
	bits(5) ITT_size
) 

This can be maliciously created by an attacker and the ITT_base can be
pointed to hypervisor protected memory. The MAPTI command can then be
used to write over the ITT_base with an ITE entry.

Similarly a vCPU Table entry has the following structure:

type VCPUTableEntry is (
	boolean Valid,
	bits(32) RDbase,
	Address VPT_base,
	bits(5) VPT_size
)

VPT_base can be pointed to hypervisor protected memory and then a
command can be used to raise interrupts and set the corresponding
bit. This would give a 1-bit write primitive so is not "as generous"
as the others.

Testing
=======

Verified that it boots in Qemu using the following arguments:
"-machine virt,virtualization=true,gic-version=4,its=true,iommu=smmuv3,acpi=off"

and enabled Qemu tracing using the following argument: '--trace "gicv3_its_*"'
Qemu reports a bunch of events due to virtio-block using the ITS to
raise MSIs and I can see the accesses made by the device to the
GITS_TRANSLATER register.

Wrote a PoC [3] which uses a DEVMEM like interface to poke the ITS
directly from userspace to achieve controlled write to hyp protected
memory and verified that this is not possible anymore when the
sanitization is in place.

[3] [https://github.com/sebastianene07/gic-its-poc/blob/main/its.c]


What is not covered
===================

Only a subset of the commands is sanitized & covered: vLPI commands are
not covered at all and the Redistributor hardeninig is not covered. 


Changelog
=========

v1 -> v2:
 - fixed a bunch of functional errors in the parsing of the MAPD command
 - renamed the functions exported from the GIC driver, made the
   allocation GFP_ATOMIC, make it accepts a flags arg
 - renamed the entry point in the emulation and make it so that it
   accepts the size of pages that we use for the private state
 - added support for rollback on certain commands that timeout on
   hardware
 - clarified commit messages 

Previous posting:
################

v1: https://lore.kernel.org/all/20260310124933.830025-1-sebastianene@google.com/


 Mostafa Saleh (1):
  KVM: arm64: Donate MMIO to the hypervisor

Sebastian Ene (12):
  KVM: arm64: Track host-unmapped MMIO regions in a static array
  KVM: arm64: Support host MMIO trap handlers for unmapped devices
  KVM: Parse the device tree and register the ITS region with pKVM
  irqchip/gic-v3-its: Add support for the ITS emulation setup
  KVM: arm64: Shadow the ITS command queue and setup emulation
  KVM: arm64: Restrict host access to the private ITS tables
  KVM: arm64: Trap & emulate the ITS MAPD command
  KVM: arm64: Trap & emulate the ITS MAPC command
  KVM: arm64: Restrict host updates to GITS_CTLR
  KVM: arm64: Prevent the host from specifying a different command queue
  KVM: arm64: Prevent the host from programming new GITS_BASER tables
  KVM: arm64: Implement HVC interface for ITS emulation setup

 arch/arm64/include/asm/kvm_arm.h              |   2 +
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_pkvm.h             |  18 +
 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h |  14 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   7 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  16 +
 arch/arm64/kvm/hyp/nvhe/its_emulate.c         | 827 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 189 +++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  27 +
 arch/arm64/kvm/hyp/pgtable.c                  |  11 +-
 arch/arm64/kvm/pkvm.c                         |  76 +-
 drivers/irqchip/irq-gic-v3-its.c              | 169 +++-
 include/linux/irqchip/arm-gic-v3.h            |  51 ++
 14 files changed, 1379 insertions(+), 32 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/its_emulate.c

-- 
2.55.0.654.g21b8a5bc05-goog

