Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AEF345EA9
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737086; cv=none; b=ov95KfPokgSFGNUP1IB4LWKfPzyh5FJKf3wYKnJNxRbn5mU19rXWCjsKQ7IAxNXXJpTA8ZiftdEDdddCfQtwpeK1k6rguShr/yuorHNHh6tO9XuMm2Gct6B4pa8fPC5D+7XSF8i1wVUqrU6bVyEjTR3nPem1jV4epG+ms+MSOmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737086; c=relaxed/simple;
	bh=JC+ONpHwSsdaWBESNo65yVYlUc+YWDBzZjFOHWnegEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=dmeNBhoV98A5Sqaln++KF5rSbpNZc4CXsDMrTGLVfOdMLLbDyrpO+v20AgCpuGAsb9ck6hjZ3ydkikVMarkPTMvxpujQQ8yYAC8jiJpkGek0jsKYdWu5WxEWZPILxLIv4tTb0SMJWRhtKJAqZCCialosYBzdwWjqphQoHtP2OaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HB8lsnac; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HB8lsnac"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787737083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FJp4l3dVaEpF/wIz9uWIw4z6hu4ommx+SYhUrHPTo8Y=;
	b=HB8lsnacQu0pvPoGrRTRlvsi9apHX5AEjXxN01Fw/a5wq0WR6NmXBWwTvQU+infWXF/3yG
	lPpSlfpob9nULNBIOsfcZrqvvysxMGAk4iLvDj1x6U81RXcA/psRJbN8QJqEGJQfqWsAQq
	aNyCJyLCPecnzK94EW9gijCGTeJTEKM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-423-4WQ0XhNRN4aW_93gmPkCsA-1; Wed,
 26 Aug 2026 05:37:59 -0400
X-MC-Unique: 4WQ0XhNRN4aW_93gmPkCsA-1
X-Mimecast-MFC-AGG-ID: 4WQ0XhNRN4aW_93gmPkCsA_1787737077
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA9B21953988;
	Wed, 26 Aug 2026 09:37:56 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7F4CB1955F05;
	Wed, 26 Aug 2026 09:37:49 +0000 (UTC)
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
Subject: [RFC PATCH v8 00/20] kvm/arm: Introduce a customizable aarch64 KVM host model
Date: Wed, 26 Aug 2026 11:36:05 +0200
Message-ID: <20260826093747.1670077-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: LjcjtmmwhIWC5lmo9R6uigP8VfaXC3IFRJaT2q6EAgQ_1787737077
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
monitor using query-cpu-model-expansion.

Connie & Eric

This series can be found at:
https://github.com/eauger/qemu/tree/arm-cpu-model-v8

History:
--------
v7 -> v8:
- fixed make check errors
- removed demux regs from cpu-sysregs.h.inc
- Proper handling of ValueRange messed up on v7
- removed ArmIdRegArchVal
- introduced kvm_arm_create_scratch_max_host_vcpu and pass
  error handle to kvm_arm_create_scratch_host_vcpu()


Cornelia Huck (3):
  target/arm/kvm: Retrieve writable ID reg map
  arm/cpu-features: document ID reg properties
  arm-qmp-cmds: introspection for ID register props

Eric Auger (16):
  scripts: introduce scripts/update-aarch64-cpu-sysregs-header.py
  target/arm/cpu-sysregs.h.inc: Sort by name alphabetical order
  target/arm/cpu-sysregs.h.inc: Update with automatic generation
  arm/cpu: Add infra to handle generated ID register definitions
  scripts: Introduce scripts/aarch64_sysreg_helpers module
  scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
  target/arm/cpu-idregs.h.inc: generate with script
  target/arm/cpu-idregs.h.inc: Generate enum values
  arm/kvm: Initialize all writable ID registers from host
  target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
  target/arm/cpu: Expose writable ID reg field properties on the kvm
    host vcpu model
  target/arm/cpu-idregs.h.inc: Generate reserved fields
  target/arm/kvm: Ignore and trace unexpected writable reserved fields
  target/arm/kvm: add utility to write idregs in scratch vcpu
  target/arm/kvm: Add an error handle to
    kvm_arm_create_scratch_host_vcpu
  kvm: Introduce kvm_arm_create_scratch_max_host_vcpu

Shaju Abraham (1):
  target/arm/cpu_idregs: generate tables for Arm64 ID registers and
    fields

 docs/system/arm/cpu-features.rst              |  106 +-
 target/arm/cpu-idregs.h                       |   36 +
 target/arm/kvm_arm.h                          |   36 +-
 target/arm/cpu-idregs.h.inc                   | 2512 +++++++++++++++++
 target/arm/cpu-sysregs.h.inc                  |   55 +-
 target/arm/arm-qmp-cmds.c                     |   73 +
 target/arm/cpu-idregs.c                       |   96 +
 target/arm/cpu64.c                            |    5 +
 target/arm/kvm-stub.c                         |   18 +
 target/arm/kvm.c                              |  480 +++-
 scripts/aarch64_sysreg_helpers.py             |  121 +
 .../update-aarch64-cpu-sysreg-properties.py   |  299 ++
 scripts/update-aarch64-cpu-sysregs-header.py  |   51 +
 target/arm/meson.build                        |    1 +
 target/arm/trace-events                       |    8 +
 15 files changed, 3813 insertions(+), 84 deletions(-)
 create mode 100644 target/arm/cpu-idregs.h
 create mode 100644 target/arm/cpu-idregs.h.inc
 create mode 100644 target/arm/cpu-idregs.c
 create mode 100644 scripts/aarch64_sysreg_helpers.py
 create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
 create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py

-- 
2.53.0

