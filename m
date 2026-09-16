Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E102C33DED9
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570061; cv=none; b=Ox2HcYwECipNTpKEHGyClVmO5R8N88QA3KdRjxY20lI3YzS6823+Ja08YT1cdJ8RKv38BPDuGj5k0Q3gS+HyCF6OcD5xEjyEDDTOKncpsnw0S9+JLaUvxqrfzBsfKbuobaI03JVRKfWVCcTk4TQwUjGNK5yb0dgQS8hG88nKv4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570061; c=relaxed/simple;
	bh=0ML8ZjNMKlw1vSopdBJk6ZDpW4ix60LIonU2wOih8+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=P/ebqZairqVLMOc0Y/CdNpNpcdoiK+U2pmrzpE/7NzKPrhggFU7GOt/8Of4l7hKzzIZ5si8NpTt6MNGpOPKohmG8zrKYZ53v4GURWNnKcXkfXUN00yyhB8Y+GwJl2hU5ZKzKHpsMeTl1wMkm/yzvfj4bIpymd9x+6y/E5CHJums=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IKSsdP4w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IKSsdP4w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o6TLEUfsuWnfnPaMNFtZXD1NQjE9HnCmVJlsx/1A0Zw=;
	b=IKSsdP4w3EslYvCFhHyTW0c3R2ORHEJ64SGZEzmlvxg0hag9UmtGO6wAgPeEE5t7f4WYLH
	Ju/n0qhoH+VAJotqEjYfxSXJFnDKdIrvqlDOPTQbinUrlyzJRagKDK+MaxzglbYJHnVHW9
	oXZzDkE8c//9+7Y91hHxyXZbV4BvYmY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-150-aAoA-kzTMNC2zKC3hZEiFw-1; Wed,
 16 Sep 2026 10:47:34 -0400
X-MC-Unique: aAoA-kzTMNC2zKC3hZEiFw-1
X-Mimecast-MFC-AGG-ID: aAoA-kzTMNC2zKC3hZEiFw_1789570052
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72CEE1800DB5;
	Wed, 16 Sep 2026 14:47:31 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E852D19560AB;
	Wed, 16 Sep 2026 14:47:25 +0000 (UTC)
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
Subject: [PATCH v9 00/26] kvm/arm: Introduce a customizable aarch64 KVM host model
Date: Wed, 16 Sep 2026 16:45:23 +0200
Message-ID: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: lB6gDYrA0qCPZ-65ee8OM8t1dheHrIFzVKd5cIt2h_g_1789570052
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
between different host hardware.

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
https://github.com/eauger/qemu/tree/arm-cpu-model-v9

History:
--------
v8 -> v9:
- Eventually turned this series into non RFC series as main
  blockers have been removed I think
- Changed the way SYSREG props are applied, first stored into
  a hashkey and applied at the very end of the init chain, after
  legacy composite options. This fixes the issue with NV.
- Also we are running the expansion code on a scratch vcpu mode
  that should be similar to the final one, initialized with the
  right composite options.
- Introduced the static support for expansion. In static mode,
  we don't run checks against the scratch vcpu
- Added consistency checks between legacy composite options and
  SYSREG props
- Addressed the 2 bugs reported by Khushit & Shameer (scrach vcpu
  leak in expansion code and RES field handling)
- pass errp to kvm_arch_init_vcpu()
- introduced kvm_arm_vcpu_prepare_init_features

Cornelia Huck (3):
  target/arm/kvm: Retrieve writable ID reg map
  arm-qmp-cmds: introspection for ID register props
  arm/cpu-features: document ID reg properties

Eric Auger (22):
  scripts: introduce scripts/update-aarch64-cpu-sysregs-header.py
  target/arm/cpu-sysregs.h.inc: Sort by name alphabetical order
  target/arm/cpu-sysregs.h.inc: Update with automatic generation
  arm/cpu: Add infra to handle generated ID register definitions
  scripts: Introduce scripts/aarch64_sysreg_helpers module
  scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
  target/arm/cpu-idregs.h.inc: generate with script
  target/arm/cpu-idregs.h.inc: Generate enum values
  hw/arm/virt: Make sure virt_get_caches() keeps on reading CLIDR_EL1 as
    0
  arm/kvm: Initialize isar.idregs[] with all writable host ID regs
  target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
  target/arm/kvm: Implement SYSREG property setter and getter
  target/arm/kvm: Pass an Error handle to kvm_arch_init_vcpu
  target/arm/kvm: Apply SYSREG props to the final vcpu
  target/arm/kvm: Add consistency checking for SYSREG props
  target/arm/cpu: Expose writable ID reg field properties on the kvm
    host vcpu model
  target/arm/cpu-idregs.h.inc: Generate reserved fields
  target/arm/kvm: Ignore and trace unexpected writable reserved fields
  target/arm/kvm: add helper to test SYSREG props against a scratch vcpu
  target/arm/kvm: Add an error handle to
    kvm_arm_create_scratch_host_vcpu
  target/arm/kvm: Introduce kvm_arm_vcpu_prepare_init_features helper
  target/arm/kvm: Introduce kvm_arm_create_init_scratch_vcpu()

Shaju Abraham (1):
  target/arm/cpu_idregs: generate tables for Arm64 ID registers and
    fields

 docs/system/arm/cpu-features.rst              |  100 +-
 include/system/kvm.h                          |    2 +-
 target/arm/cpu-idregs.h                       |   36 +
 target/arm/cpu.h                              |    2 +
 target/arm/kvm_arm.h                          |   28 +-
 target/arm/cpu-idregs.h.inc                   | 2512 +++++++++++++++++
 target/arm/cpu-sysregs.h.inc                  |   55 +-
 accel/kvm/kvm-all.c                           |   15 +-
 hw/arm/virt.c                                 |    4 +
 target/arm/arm-qmp-cmds.c                     |  107 +-
 target/arm/cpu-idregs.c                       |   96 +
 target/arm/cpu.c                              |    5 +-
 target/arm/cpu64.c                            |    5 +
 target/arm/kvm-stub.c                         |   17 +
 target/arm/kvm.c                              |  560 +++-
 target/i386/kvm/kvm.c                         |   22 +-
 target/loongarch/kvm/kvm.c                    |   24 +-
 target/ppc/kvm.c                              |    6 +-
 target/riscv/kvm/kvm-cpu.c                    |    3 +-
 target/s390x/kvm/kvm.c                        |    2 +-
 scripts/aarch64_sysreg_helpers.py             |  121 +
 .../update-aarch64-cpu-sysreg-properties.py   |  299 ++
 scripts/update-aarch64-cpu-sysregs-header.py  |   51 +
 target/arm/meson.build                        |    1 +
 target/arm/trace-events                       |    9 +
 25 files changed, 3987 insertions(+), 95 deletions(-)
 create mode 100644 target/arm/cpu-idregs.h
 create mode 100644 target/arm/cpu-idregs.h.inc
 create mode 100644 target/arm/cpu-idregs.c
 create mode 100644 scripts/aarch64_sysreg_helpers.py
 create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
 create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py

-- 
2.53.0

