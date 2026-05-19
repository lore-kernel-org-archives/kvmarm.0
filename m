Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B33233920
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197365; cv=none; b=OuSCFABwkpOIWTQw2ws8sBjUiZCPVvDRQENRYH5ZG0FN6xL/Qlk9ycvQo74WiQ+K+oJ+1HEb1uzZxq+2y/8boTJNMfMEWh5hAEfTR3t/clu2rdR0Zw0KJcEk+ldql1DFkc50s59Q8/xADhXLdut7TBoq7ufTvcMXILCCYiWIoSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197365; c=relaxed/simple;
	bh=BMRRWVanCoc5j9gnRhs2cXOaSGWWrc4RLiS/iF+j/3g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Z2OpRqPjhEGtnc/pti9vUnd1wxM9TwFHp9zWD6ftzIJDo7JBiy2BEIMwOECBTurnc84n5qnze2CoXvV7tqGcc44jGxniTW4xCAC2ZbHgJdvl6Wr6W4JByZVDeh2VIycxI4ppOSPTy5t89FCxdXqHzRufomsOUVHkfeQ6Y4WdOfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bs5yamtd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bs5yamtd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3fC5NExt4dPUL7IgU7wrj6+Uy2zcCLD4IM4/bVknki4=;
	b=Bs5yamtdSz383DLO4PwB5UKhQ5mBv1veNRHj9vqWJcgUZhaQ1q4C6rI7W+b/0JhR8m16eN
	y17KLBLfSJi0hwiMb/qdZ0Tu6ch8PrC7vOMQ5usOhMRddjZN7dQuDCjst5zBaQOnm+arrk
	dXO603bt48akMOEmCEGDfI3h3N+SNl0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-574-Mb8VD7t7NjiWOv6AxMR54g-1; Tue,
 19 May 2026 09:29:20 -0400
X-MC-Unique: Mb8VD7t7NjiWOv6AxMR54g-1
X-Mimecast-MFC-AGG-ID: Mb8VD7t7NjiWOv6AxMR54g_1779197357
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3E881956058;
	Tue, 19 May 2026 13:29:16 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3AE121800576;
	Tue, 19 May 2026 13:29:08 +0000 (UTC)
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
	philmd@linaro.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v5 00/18] kvm/arm: Introduce a customizable aarch64 KVM host model
Date: Tue, 19 May 2026 15:27:14 +0200
Message-ID: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Qo0Gu2wOEFrO9a7oYqzcqIXekGv0hHp_MZHPiCwNmvw_1779197357
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
linux/arch/arm64/tools/sysreg file. It is not straightforward
to have unit tests for python scripts as there are many cases for
field extraction.

For each writable named field a uint64 property is created
following the "SYSREG_<REG>_<FIELD>" naming convention. REG and
FIELD names are those described in ARM ARM Reference manual.

The list of SYSREG_ID properties can be retrieved through the qmp
monitor using query-cpu-model-expansion [2].

Connie & Eric

This series can be found at:
https://github.com/eauger/qemu/tree/arm-cpu-model-v5

History:
--------

v4 -> v5:
- generate target/arm/cpu-idregs.h.inc that look similar to
  the format used in [RFC PATCH v1 02/13] target/arm:
  named_cpu_model: Add ID Register Fields without the
  description of the value values nor safe policy/value.
  I guess valid values could be generated from the Registers.json
  file too. Safe policy/values cannot.
  I reused one patch from the above series.
  Let's see how both series can progress/coexist without any
  anticipated bias.
- Addressed all comments from Shameer on v4
- Addressed 2 comments from v4 that were missed including the
  issue of IDreg visibility affected by some other settings.
  Unfortunately I was not able to test it.
- Further look at overrides between low level id reg field
  properties versus legacy CPU options. I have the feeling they
  can coexist as long as we document the hierarchy between them:
  host kvm default -> ID reg field props -> legacy CPU options
- Noticed more writable fields that are RES0/RAZ
- Improved commit messages in general

References:
-----------

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


Cornelia Huck (3):
  target/arm/kvm: Introduce kvm_get_writable_id_regs
  arm-qmp-cmds: introspection for ID register props
  arm/cpu-features: document ID reg properties

Eric Auger (14):
  scripts: introduce scripts/update-aarch64-cpu-sysregs-header.py
  target/arm/cpu-sysregs.h.inc: Sort by name alphabetical order
  target/arm/cpu-sysregs.h.inc: Update with automatic generation
  arm/cpu: Add infra to handle generated ID register definitions
  scripts: Introduce scripts/aarch64_sysreg_helpers module
  scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
  target/arm/cpu-idregs.h.inc: generate with script
  target/arm/cpu64: Retrieve writable ID reg map in
    aarch64_host_initfn()
  arm/kvm: Initialize all writable ID registers from host
  arm/kvm: write back modified ID regs to KVM
  target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
  target/arm/kvm: Special case REVIDR_EL1 and AIDR_EL1
  target/arm/kvm: Ignore some writable bits that shouldn't be
  target/arm/cpu: Expose writable ID reg field properties on the kvm
    host vcpu model

Shaju Abraham (1):
  target/arm/cpu_idregs: generate tables for Arm64 ID registers and
    fields

 docs/system/arm/cpu-features.rst              | 106 ++-
 scripts/aarch64_sysreg_helpers.py             | 109 ++++
 .../update-aarch64-cpu-sysreg-properties.py   | 168 +++++
 scripts/update-aarch64-cpu-sysregs-header.py  |  51 ++
 target/arm/arm-qmp-cmds.c                     |  19 +
 target/arm/cpu-idregs.c                       |  50 ++
 target/arm/cpu-idregs.h                       |  33 +
 target/arm/cpu-idregs.h.inc                   | 617 ++++++++++++++++++
 target/arm/cpu-sysregs.h.inc                  |  57 +-
 target/arm/cpu.h                              |   3 +
 target/arm/cpu64.c                            |  14 +
 target/arm/kvm-stub.c                         |   5 +
 target/arm/kvm.c                              | 320 ++++++++-
 target/arm/kvm_arm.h                          |  12 +
 target/arm/meson.build                        |   1 +
 target/arm/trace-events                       |   6 +
 16 files changed, 1539 insertions(+), 32 deletions(-)
 create mode 100644 scripts/aarch64_sysreg_helpers.py
 create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
 create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py
 create mode 100644 target/arm/cpu-idregs.c
 create mode 100644 target/arm/cpu-idregs.h
 create mode 100644 target/arm/cpu-idregs.h.inc

-- 
2.53.0

