Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFD91A5B90
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793846; cv=none; b=sezTmNtCG6wHsYvBUZ+qPpjr8xO1JB26AvL2Bcmreyg/9svkoYE+/c9uIe1qIenppa1tVhD8xCrsi73LFVqN4cecQiR8bVxWrLtcEbspaa3MHErPeFZfoJ+ffsj2Nlqf4OzQ73TdvsWC8dSWb+H9o4y0JjjsMXSbmdFTn65wa2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793846; c=relaxed/simple;
	bh=XMdAcXfuNh0r2GYv/OvFR3sdZfDmLabgc/mmxbJ9q7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=jQwXLDfNn32VFn4U4Ydi1QNq2EXmgd87FDN1jg6DTA+hlihszc06A13eBL6eVib9XrnuzJWPffECoO83nE0JHm6oofnmGYH8OpaDAoFfGQvZRt0mM/oYwFACBWFILEx/ZNqXuncYRDcV+Se7mTZVAKy0BCnwE6v54Ods4tPsZc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f7dfSILK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f7dfSILK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lo1xZC+bUky6RlKCN7yKN2S97GkmDXuYJWggWFfqIMk=;
	b=f7dfSILKEy4mmLuIksYdb4lL0jDB96m7/orqj2BzTg/3XCwyMMkLW60JlbIAKlxSwx3NLI
	pIRclRksJgCCSa80JfSG4Ir9aCW/lbQhOhpVZpTpbqRs6kI2HMTcTyKVe3kf2cWH8HLNJP
	O2g9EPyQTA4nD4NV91eWFNXNiq7bt8E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-f1QDHV5KOTicn_yLJnnKCA-1; Sun,
 03 May 2026 03:37:20 -0400
X-MC-Unique: f1QDHV5KOTicn_yLJnnKCA-1
X-Mimecast-MFC-AGG-ID: f1QDHV5KOTicn_yLJnnKCA_1777793839
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C29C195608E;
	Sun,  3 May 2026 07:37:19 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D1A31800345;
	Sun,  3 May 2026 07:37:13 +0000 (UTC)
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
Subject: [PATCH v4 15/17] arm/cpu: Expose writable ID reg field properties on the kvm host vcpu model
Date: Sun,  3 May 2026 09:33:35 +0200
Message-ID: <20260503073541.790215-16-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: EtDka0O4A8yuk8tkXaL7LqQVPFA2v7YBHmq5McqUdrQ_1777793839
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If the host supports KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES and
KVM_ARM_GET_REG_WRITABLE_MASKS ioctl successfully retrieved the mask
of writable fields for all ID regs, expose uint64 SYSREG properties
for all the writable ID reg fields exposed by the host kernel which
can be matched in target/arm/cpu-sysreg-properties.c.

Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
being those used in linux arch/arm64/tools/sysreg or in the AARCHMRS
Registers.json.

This is achieved by matching the writable fields retrieved from the
host kernel against the generated description of ID regs and their
fields in target/arm/cpu-sysreg-properties.c.

An example of invocation is:
-cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
which sets DP field of ID_AA64ISAR0_EL1 to 0.

[CH: add properties to the host model instead of introducing a new
"custom" model]
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu.c   | 12 ++++++++++++
 target/arm/cpu64.c | 23 ++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 10feb639c4..10ce4eb0cb 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1824,6 +1824,18 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
+    /*
+     * If we failed to retrieve the set of writable ID registers for the "host"
+     * CPU model, report it here. No error if the interface for discovering
+     * writable ID registers is not available.
+     * In case we did get the set of writable ID registers, set the features to
+     * the configured values here and perform some sanity checks.
+     */
+    if (cpu->writable_id_regs_status == WRITABLE_ID_REGS_FAILED) {
+        error_setg(errp, "Failed to discover writable id registers");
+        return;
+    }
+
     if (!cpu->gt_cntfrq_hz) {
         /*
          * 0 means "the board didn't set a value, use the default". (We also
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 1b3d3fb245..d66cb00a21 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -852,6 +852,8 @@ static void kvm_arm_set_cpreg_mig_tolerances(ARMCPU *cpu)
 static void aarch64_host_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    bool expose_id_regs = true;
+    int ret;
 
 #if defined(CONFIG_NITRO)
     if (nitro_enabled()) {
@@ -862,8 +864,27 @@ static void aarch64_host_initfn(Object *obj)
 
 #if defined(CONFIG_KVM)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
-    kvm_arm_set_cpu_features_from_host(cpu, false);
+
+    cpu->writable_map = g_malloc(sizeof(IdRegMap));
+
+    /* discover via KVM_ARM_GET_REG_WRITABLE_MASKS */
+    ret = kvm_arm_get_writable_id_regs(cpu, cpu->writable_map);
+    if (ret == -ENOSYS) {
+        /* legacy: continue without writable id regs */
+        expose_id_regs = false;
+    } else if (ret) {
+        /* function will have marked an error */
+        return;
+    }
+
+    kvm_arm_set_cpu_features_from_host(cpu, expose_id_regs);
     aarch64_add_sve_properties(obj);
+
+    if (expose_id_regs) {
+        /* generate SYSREG properties according to writable masks */
+        kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
+    }
+
 #elif defined(CONFIG_HVF)
     hvf_arm_set_cpu_features_from_host(cpu);
 #elif defined(CONFIG_WHPX)
-- 
2.53.0

