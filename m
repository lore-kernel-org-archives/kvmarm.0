Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C091A9B24
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793761; cv=none; b=XSws8wAUj87sAk7pndW7btuuldcfGF2jQR0CXiubs9heuQU7K3HyABDrPVE37lK+0/JalT4Ma9ZTyQtVMOVdRJkn5WN7p+a/z8e01YfevJL9FbdNbvt+q1Gkt9CLNqr+xm2dSw6jDKtnq3N8Oaidmu44BLerhTh1oMm2eW2T8xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793761; c=relaxed/simple;
	bh=z0rgn38u1I6WO1hRod4yjLXLrqJJv5CcmgAfkIiWS2s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=lk/JOWeBgfGydFMI+AdqDs6VFrWkUBRPbYTr5D+vOUK4liWb2YqNaP7GoUiFBnes1fHAYssaaIlI+ItoV7vkJWzcxy2rEe5vfzi6lOFg4jGbIurV90ua0t4l5Xc7eFC4+ojJlUMeFLqQmNMFc1vZJMzXDIcw3jJFftehfZlKFac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eMM6RV4o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eMM6RV4o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eJbqFxtHUzeCNhZy2Eqbtv3ldmKnEXIaIpe/lLouE+8=;
	b=eMM6RV4okjL7RSYH6VrUfuOoQuaoP4WmghtPJ/PkbSqlG02hiOpF/QimD9aYKmp7RHeYas
	KFs1V+S4KIV6rAK2LQcYUzgKWioyVsFIBN7FjdlDgEAddtrIxqWG09xvdFbf2xKlwU0mD3
	EXfnZPkKgu9VjJ3STytWSxRFnt36VP8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-p8La373fM-iT3TSbbUu7nw-1; Sun,
 03 May 2026 03:35:55 -0400
X-MC-Unique: p8La373fM-iT3TSbbUu7nw-1
X-Mimecast-MFC-AGG-ID: p8La373fM-iT3TSbbUu7nw_1777793754
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76029195608B;
	Sun,  3 May 2026 07:35:53 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 047FA1801481;
	Sun,  3 May 2026 07:35:46 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	cohuck@redhat.com,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@linaro.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v4 00/17] kvm/arm: Introduce a customizable aarch64 KVM host model
Date: Sun,  3 May 2026 09:33:20 +0200
Message-ID: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: tRGUQVuFz8pjLi8x8yxnWJgD5oPGxTiE47NZKztmtUE_1777793754
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

QEMU retrieves the writable ID fields from KVM UAPI [1] and
match them against a generated description of ID regs and their
named fields that stem from AARCHMRS Registers.json file.
Current description is based on latest 2026-03 edition.
The content of the generated files was compared against kernel
linux/arch/arm64/tools/sysreg file [3] . It is not straightforward
to have unit tests for python scripts as there are many cases for
field extraction.

For each writable named field a uint64 property is created
following the "SYSREG_<REG>_<FIELD>" naming convention. REG and
FIELD names are those described in ARM ARM Reference manual.

The list of SYSREG_ID properties can be retrieved through the qmp
monitor using query-cpu-model-expansion [2].

Connie & Eric

This series can be found at:
https://github.com/eauger/qemu/tree/arm-cpu-model-v4

References:

[1]
KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES
KVM_ARM_GET_REG_WRITABLE_MASKS
Documentation/virt/kvm/api.rst

[2]
qemu-system-aarch64 -qmp unix:/home/augere/TEST/QEMU/qmp-sock,server,nowait -M virt --enable-kvm -cpu custom
sudo build/run qmp-shell /home/augere/TEST/QEMU/qmp-sock
Welcome to the QMP low-level shell!
Connected to QEMU 11.0.50
(QEMU) query-cpu-model-expansion type=full model={"name":"host"}

[3]
linux/arch/arm64/tools/sysreg and gen-sysreg.awk
./tools/include/generated/asm/sysreg-defs.h


Cornelia Huck (4):
  target/arm/kvm: Introduce kvm_get_writable_id_regs
  arm/cpu: accessors for writable id registers
  arm-qmp-cmds: introspection for ID register props
  arm/cpu-features: document ID reg properties

Eric Auger (13):
  scripts: introduce scripts/update-aarch64-cpu-sysregs-header.py
  target/arm/cpu-sysregs.h.inc: Sort by name alphabetical order
  target/arm/cpu-sysregs.h.inc: Update with automatic generation
  arm/cpu: Add infra to handle generated ID register definitions
  scripts: Introduce scripts/aarch64_sysreg_helpers module
  scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
  target/arm/cpu-sysreg-properties.c: Generate code with new script
  arm/kvm: Allow reading all the writable ID registers
  arm/kvm: write back modified ID regs to KVM
  target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
  target/arm/kvm: Special case REVIDR_EL1 and AIDR_EL1
  target/arm/kvm: Special case ID_AA64ISAR0_EL1 RES0 [24, 27] bits
  arm/cpu: Expose writable ID reg field properties on the kvm host vcpu
    model

 docs/system/arm/cpu-features.rst              | 104 ++-
 scripts/aarch64_sysreg_helpers.py             | 109 +++
 .../update-aarch64-cpu-sysreg-properties.py   | 169 +++++
 scripts/update-aarch64-cpu-sysregs-header.py  |  51 ++
 target/arm/arm-qmp-cmds.c                     |  19 +
 target/arm/cpu-idregs.h                       |  59 ++
 target/arm/cpu-sysreg-properties.c            | 673 ++++++++++++++++++
 target/arm/cpu-sysregs.h.inc                  |  57 +-
 target/arm/cpu.c                              |  12 +
 target/arm/cpu.h                              |  36 +
 target/arm/cpu64.c                            |  26 +-
 target/arm/kvm-stub.c                         |   3 +-
 target/arm/kvm.c                              | 313 +++++++-
 target/arm/kvm_arm.h                          |  19 +-
 target/arm/meson.build                        |   3 +-
 target/arm/trace-events                       |   6 +
 16 files changed, 1622 insertions(+), 37 deletions(-)
 create mode 100644 scripts/aarch64_sysreg_helpers.py
 create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
 create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py
 create mode 100644 target/arm/cpu-idregs.h
 create mode 100644 target/arm/cpu-sysreg-properties.c

-- 
2.53.0

