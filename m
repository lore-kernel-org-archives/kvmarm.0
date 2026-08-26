Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799FD3546D6
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737171; cv=none; b=nVWD3QRGArGW5H7ksz5Lk/U/aX8EFzKUh3CZyhGQnjWFHTM8pJplbbJmVt2E0iwIj+6EkazdhZe+ORMlEd8LE4QcaAI5Y/cu8i+8PLfTh9xK4bj1CpcOYEw/8ZfDhO/L+Vp+9TPivXNGJewObrwT20hSm6RV6Axbn/lsTsK7r2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737171; c=relaxed/simple;
	bh=kqlGnjMK8ddnKZwZTia8DFvAmlvBYAMUhgHhKwJmjWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=T7dMLUcdkWIj+GD55sTDuVzrdVm18P53rVhlae/BQtL/hK44KF4tlBCGD8NycKNKa+9tVRb3+/xWuaXYZ72QFBqXO78nU5f+dDdX0KPnGJ67EKqgFoEdcHhpp4iVOQTJig/h1V2AAyhH8J5jlN/qBXEx5/PU+5ERcQgg8ButNPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O9QR4NNU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O9QR4NNU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787737169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gBiQ/WZ8FDSS7QTiXrmQ5xLbPQJvAU6T5QyffYoE+7o=;
	b=O9QR4NNUvncoZiFrDdSO1LT041Waq5EkyzG8YpTXwVYSXppf5lAkOGk47yzAK1k8QLq5F5
	fHJVrVormjGHZrTmT1M6HikU1Em3M2e9NOQn00t22nWKVF6bpCNmXIl/hHiMVt+Qgj/Lvt
	REBP5PI7B5UV50sf7XFNjj506ZLj7zY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-Heccs6UcOpCnlujPZ9KGsA-1; Wed,
 26 Aug 2026 05:39:24 -0400
X-MC-Unique: Heccs6UcOpCnlujPZ9KGsA-1
X-Mimecast-MFC-AGG-ID: Heccs6UcOpCnlujPZ9KGsA_1787737163
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D5A618CC4B7;
	Wed, 26 Aug 2026 09:39:23 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 550851955F05;
	Wed, 26 Aug 2026 09:39:17 +0000 (UTC)
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
Subject: [RFC PATCH v8 13/20] target/arm/cpu: Expose writable ID reg field properties on the kvm host vcpu model
Date: Wed, 26 Aug 2026 11:36:18 +0200
Message-ID: <20260826093747.1670077-14-eric.auger@redhat.com>
In-Reply-To: <20260826093747.1670077-1-eric.auger@redhat.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: X4t-QyPTgmkvDYl38OrbgWA3Pl3PcG9lYnOd0KlIXs8_1787737163
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If the host supports KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES and
KVM_ARM_GET_REG_WRITABLE_MASKS ioctl successfully retrieved the mask
of writable fields for all ID regs, expose uint64 SYSREG properties
for all the writable ID reg fields exposed by the host kernel which
can be matched in target/arm/cpu-idregs.h.inc.

Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
being those used ARCHMRS Registers.json.

When such properties are set, they override the default field value
retrieved from the host and reinjected into KVM. Then the actual value
being applied at KVM depends on the register, ie. it can be sanitized.
In case the field value is rejected by KVM, the vpcu init fails.

Anyway there is a first attempt to write back this value into KVM.

Then legacy CPU options (virtualization, secure, ...) can still
override the previous value. So low level IDREG field properties
apply before the legacy ones.

An example of invocation is:
-cpu host,SYSREG_ID_AA64MMFR0_EL1_ECV=0x0
which sets ECV field of ID_AA64MMFR0_EL1 to 0 (enhanced counter
virtualization).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Sebastian Ott <sebott@redhat.com>

---
v5 -> v6:
- do not check writable_map anymore

v4 -> v5:
- get rid of ret local variable, dynamically allocate and free writable_map
  here
---
 target/arm/cpu64.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 4e8c472530..e04062e848 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -37,6 +37,7 @@
 #include "hw/core/qdev-properties.h"
 #include "internals.h"
 #include "cpu-features.h"
+#include "cpu-idregs.h"
 
 /* convert between <register>_IDX and SYS_<register> */
 #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
@@ -807,6 +808,10 @@ void aarch64_host_initfn(Object *obj)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
     kvm_arm_set_cpu_features_from_host(cpu);
     aarch64_add_sve_properties(obj);
+
+    /* generate SYSREG properties according to writable masks */
+    kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
+
 #elif defined(CONFIG_HVF)
     hvf_arm_set_cpu_features_from_host(cpu);
 #elif defined(CONFIG_WHPX)
-- 
2.53.0

