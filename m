Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D16B368D47
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639463; cv=none; b=fxB2tBZ3OjMSI7Dt5tRihAP0QGjS58jCNBQ8mp0kv8W2wYvxbRzFRzPuE+MBNw453dKhmJQvs4LNOztBi4v0F5z7nLIznt9ZPRFSwzXc3G6/JhCcsfeYlAtIQbTn7oU7gQpmvmh9yZIoGGc8MIrGOmO2s34AsSMYW/RR6xxWvo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639463; c=relaxed/simple;
	bh=3EzhadgVCMcc4C0tv6pELzwcwU/TvanphK16zQmT0nI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Nn4NlpTbCX7co8U0cjZLhX8NBEc9VP79e65/jPMMC6mbtR8M5OM13fM64o0wntbzm4qe8SKDFiRdjAEjZzuWov3kBl33m71eZb2AmWQPKcd+t34B4934Hlc2KdXYFHnoK9HEKYT85Ry6T1RF6kEjfVzYn8Y2omXxnt/61AxS2mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lq3WTeZa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lq3WTeZa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OmQRkZaRefWX9vEaWYuPJGOsveEoUMffw7qGb8MUp1A=;
	b=Lq3WTeZanPUHvJ8yW9eAWyAiuhSQd1jTWCHoIjaFIdNVtttEAH5x85dPVXqhjjdKbLWIO7
	3d41wb0Sn2o90byqOYW55WbrapYkGmw3JrIaRd0PKMywf+zVowly3raxww03iSLT0WYtwp
	vfKzVvTTmagV/tFN32tTKRDGSMppTII=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-7r4Zq5NpNrimLB4f2b4X6w-1; Sat,
 10 Oct 2026 13:37:36 +0000
X-MC-Unique: 7r4Zq5NpNrimLB4f2b4X6w-1
X-Mimecast-MFC-AGG-ID: 7r4Zq5NpNrimLB4f2b4X6w_1791639454
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C906F1809CA0;
	Sat, 10 Oct 2026 13:37:33 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 53E4930000E5;
	Sat, 10 Oct 2026 13:37:27 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v10 00/26] kvm/arm: Introduce a customizable aarch64 KVM host model
Date: Sat, 10 Oct 2026 15:36:04 +0200
Message-ID: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: CkB5jsKj7ZK3hiDNaYrp7vSValY3hedLosWYSZArZAQ_1791639454
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This series enhances the current host KVM model with capability to
set writable ID reg fields.

Since v6.7 kernel, KVM/arm allows the userspace to overwrite the values
of a subset of ID regs. The list of writable fields continues to grow.
The feature ID range is defined as the AArch64 System register space
with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
  
The end goal is to get more flexibility when migrating guests
between different host hardware. This series is a prerequisite for
aarch64 named vcpu models.

QEMU retrieves the writable ID fields from KVM UAPI and
match them against a generated description of ID regs and their
named fields that stem from AARCHMRS Registers.json file.
Current description is based on latest 2026-03 edition.
The content of the generated files was compared against kernel
linux/arch/arm64/tools/sysreg file. It is not straightforward
to have unit tests for python scripts as there are many cases for
field extraction.
  
For each writable named field a uint64 property is created
following the "SYSREG_<REG>_<FIELD>" naming convention. REG and
FIELD names are those described in ARM ARM Reference manual.

SYSREG properties are applied at the end of the initialization
chain, after legacy composite options (sve, pauth, ...). They
do not substitute to them because legacy options do more than
just changing the value of ID registers. They may also interact
with KVM to init the vcpu with specific features or set some
VM capabilities. SYSREG properties just affect the corresponding
ID register field. Some checks are performed to make sure their
value is not inconsistent with legacy composite options.

The list of SYSREG properties can be retrieved through the qmp
monitor using query-cpu-model-expansion. They return the current
value for the corresponding field. The qmp command also allows to
test  setting new values. In static mode, they are tested at qemu
level only, against field length, arch enum values if any and
consistency with legacy composite options. With full expansion,
the values are tested against KVM using a scratch vcpu initialized
with the right legacy composite property values.

Connie & Eric

This series can be found at:
https://github.com/eauger/qemu/tree/arm-cpu-model-v10

History:
--------
v9 -> v10:
addressed all Khushit's comments/suggestions. Here is the
list of main changes.

- MIDR, REVIDIR, MPIDR storage move (this may be sent as a
  separate prerequisite series)
- rebase on demux register handler that has just landed
  - update the json extractor accordingly
- Generate conditional enum values
- reorganize script patches to have the generated header
  in the same patch which is much easier to maintain
- New macro to encode arch enum value and ValueRanges which
  gives a much more compact header. Also enabled to remove
  check-patch error
- Put a maximum of code in cpu64.c instead of kvm.c to
  pave the way for other acceleration support. Also
  changed the consistency check handling by skipping potential
  new props that are known to collide with legacy composite options
- add writable_only param to pave the way for exposing all fields
  as props
- fixes in the qmp expansion code


Cornelia Huck (3):
  target/arm/kvm: Retrieve writable ID reg map
  arm-qmp-cmds: introspection for ID register props
  arm/cpu-features: Document ID reg properties

Eric Auger (22):
  target/arm: Move REVIDR into isar.idregs[] storage
  target/arm: Move MIDR into isar.idregs[] storage
  target/arm: Enforce MPIDR into isar.idregs[] storage
  target/arm/cpu-sysregs.h.inc: Update with automatic generation
  arm/cpu: Add infra to handle generated ID register definitions
  target/arm/cpu-idregs.h.inc: Generate with script
  target/arm/cpu-idregs.h.inc: Generate enum values
  target/arm/cpu-idregs.h.inc: Generate reserved fields
  hw/arm/virt: Make sure virt_get_caches() keeps on reading CLIDR_EL1 as
    0
  arm/kvm: Initialize isar.idregs[] with all writable host ID regs
  target/arm/cpu64: Add properties for writable IDReg fields
  target/arm/kvm: Implement SYSREG property setter and getter
  target/arm/kvm: Let kvm_arm_init_cpreg_list propagate an error handle
  target/arm/kvm: Pass an Error handle to kvm_arch_init_vcpu
  target/arm/kvm: Introduce kvm_arm_override_idreg_field helper
  target/arm/cpu64: Introduce arm_cpu_apply_sysreg_props
  target/arm/kvm: Apply SYSREG props
  target/arm/kvm: Add consistency checking for SYSREG props
  target/arm/cpu64: Add helper to test SYSREG props against a scratch
    vcpu
  target/arm/kvm: Add an error handle to
    kvm_arm_create_scratch_host_vcpu
  target/arm/kvm: Introduce kvm_arm_vcpu_prepare_init_features helper
  target/arm/kvm: Introduce kvm_arm_create_init_scratch_vcpu()

Shaju Abraham (1):
  target/arm/cpu_idregs: Generate tables for Arm64 ID registers and
    fields

 docs/system/arm/cpu-features.rst              |  111 +-
 include/system/kvm.h                          |    2 +-
 target/arm/cpu-idregs.h                       |   76 +
 target/arm/cpu.h                              |   12 +-
 target/arm/kvm_arm.h                          |   26 +-
 target/arm/cpu-idregs.h.inc                   | 1549 +++++++++++++++++
 target/arm/cpu-sysregs.h.inc                  |   13 +
 accel/kvm/kvm-all.c                           |   15 +-
 hw/arm/virt.c                                 |   11 +
 hw/intc/armv7m_nvic.c                         |    4 +-
 target/arm/arm-qmp-cmds.c                     |  130 +-
 target/arm/cpu-idregs.c                       |   93 +
 target/arm/cpu-max.c                          |    4 +-
 target/arm/cpu.c                              |   24 +-
 target/arm/cpu64.c                            |  330 +++-
 target/arm/helper.c                           |   29 +-
 target/arm/hvf/hvf.c                          |    6 +-
 target/arm/kvm-stub.c                         |   17 +
 target/arm/kvm.c                              |  277 ++-
 target/arm/tcg/cpu-v7m.c                      |   18 +-
 target/arm/tcg/cpu32.c                        |   37 +-
 target/arm/tcg/cpu64.c                        |   42 +-
 target/arm/whpx/whpx-all.c                    |    6 +-
 target/i386/kvm/kvm.c                         |   22 +-
 target/loongarch/kvm/kvm.c                    |   27 +-
 target/ppc/kvm.c                              |    6 +-
 target/riscv/kvm/kvm-cpu.c                    |    3 +-
 target/s390x/kvm/kvm.c                        |    2 +-
 scripts/aarch64_sysreg_helpers.py             |  118 ++
 .../update-aarch64-cpu-sysreg-properties.py   |  331 ++++
 scripts/update-aarch64-cpu-sysregs-header.py  |   59 +
 target/arm/meson.build                        |    1 +
 target/arm/trace-events                       |    9 +
 33 files changed, 3232 insertions(+), 178 deletions(-)
 create mode 100644 target/arm/cpu-idregs.h
 create mode 100644 target/arm/cpu-idregs.h.inc
 create mode 100644 target/arm/cpu-idregs.c
 create mode 100644 scripts/aarch64_sysreg_helpers.py
 create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
 create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py

-- 
2.53.0

