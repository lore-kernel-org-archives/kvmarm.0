Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D81357D17
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639476; cv=none; b=mwnIiAK0fEMMxSlMfxxcoQAfM3UBy689w6amie7a1QC2BVBsNbPJpVt0KNhTwFXxhUErpAw+4nWietAiqiBMSWHOWJnuXurOlmXhipv/lnNzZ67FsUDapyc+ERjWRXOMI0Dbs2905wX0OeSh2L9hFUb5AIFIktu87Df8u6my3UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639476; c=relaxed/simple;
	bh=e6rbygT3V+nOhK8HrMKOJY9RElCONZFANLiuDg8o2lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mDZf3PKqnOqtE/lVA+AJrT0kIckvRO0ALtLv1lVGIZoPYXfnNl2rIeGQTVB+ujUE3CdtvfF/86eEODpLVGJvC6sB+jEsHBpFVlMJHuo/+62qBP5UqnWdZfOy2enNc/HrsodcIKCY01kYUkBxjcDCwHU/Xu0iM/EjHfwtCbNMstQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=baFPPfLI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="baFPPfLI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iWQgwG64LSjw/q9IlyJDOWXuDx5P7x5+Mk1gkqqoXd4=;
	b=baFPPfLIfjw3/FeV7jccJXb2Eyf+LXMtJJkypmykf2RO46poK9V7yH63bb6fFsHY6TQLIn
	u3cOlKYGnXMNY2t0GyhA4rUecQuRSeXr5RltyvXCAOU1qoX6w3K/y2W4KZmYS4G14+7hRT
	RuhIuDXXoDFWms+kivBpQoRsijAIR/A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-l7bGL70SNLqaCXgtZg-jfA-1; Sat,
 10 Oct 2026 13:37:52 +0000
X-MC-Unique: l7bGL70SNLqaCXgtZg-jfA-1
X-Mimecast-MFC-AGG-ID: l7bGL70SNLqaCXgtZg-jfA_1791639470
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5742B19560B7;
	Sat, 10 Oct 2026 13:37:50 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4B06630001BB;
	Sat, 10 Oct 2026 13:37:45 +0000 (UTC)
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
Subject: [PATCH v10 03/26] target/arm: Enforce MPIDR into isar.idregs[] storage
Date: Sat, 10 Oct 2026 15:36:07 +0200
Message-ID: <20261010133725.642498-4-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 5JZG8CaKhx02r2smcLQetYen7CHshzRetN4-EYwXjuA_1791639470
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

At the moment MPIDR_EL1 has no real storage. Instead cpu
mp_affinity field stores the Aff0-Aff2 bits only and the
ID register is reconstructed when needed. There is also
an mp-affinity property used for TCG only.

Keep the mp-affinity property and its associated storage
while making sure the MPIDR_EL1 full register is stored
in cpu->isar.idregs[] as other ID registers.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/cpu.h             |  8 +++++++-
 target/arm/cpu-sysregs.h.inc |  1 +
 target/arm/cpu.c             | 17 +++++++++++++++++
 target/arm/helper.c          | 14 +-------------
 target/arm/hvf/hvf.c         |  2 +-
 target/arm/kvm.c             |  1 +
 target/arm/whpx/whpx-all.c   |  2 +-
 7 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index dcdd4eb18e..639be0713e 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1128,7 +1128,13 @@ struct ArchCPU {
     uint32_t reset_sctlr;
     uint64_t pmceid0;
     uint64_t pmceid1;
-    uint64_t mp_affinity; /* MP ID without feature bits */
+    /*
+     * MP ID without feature bits, ie. Aff0..Aff3 only
+     * used to store the corresponding property value for TCG vcpus.
+     * The MPIDR_EL1 value (affinity + feature bits) is stored in a
+     * consistent manner in isar.idregs[MPIDR_EL1_IDX].
+     */
+    uint64_t mp_affinity;
     uint64_t reset_cbar;
     uint32_t reset_auxcr;
     bool reset_hivecs;
diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index 709dc8fc97..f148f6f565 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -42,6 +42,7 @@ DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
 DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
 DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
 DEF(MIDR_EL1, 3, 0, 0, 0, 0)
+DEF(MPIDR_EL1, 3, 0, 0, 0, 5)
 DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
 DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
 DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 2f545482bc..bee74c0f94 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2174,6 +2174,23 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
                                                  ARM_DEFAULT_CPUS_PER_CLUSTER);
     }
 
+    /* Consistently update MPIDR_EL1 in isar.idregs[] by adding feature bits */
+    {
+        uint64_t mpidr = cpu->mp_affinity;
+
+        if (arm_feature(env, ARM_FEATURE_V7MP)) {
+            mpidr |= (1U << 31);
+            /*
+             * Uniprocessor (non-coherent) cores that still implement the MP
+             * extensions set U (bit 30), e.g. Cortex-R5.
+             */
+            if (cpu->mp_is_up) {
+                mpidr |= (1u << 30);
+            }
+        }
+        SET_IDREG(&cpu->isar, MPIDR, mpidr);
+    }
+
     if (cpu->reset_hivecs) {
             cpu->reset_sctlr |= (1 << 13);
     }
diff --git a/target/arm/helper.c b/target/arm/helper.c
index dfd71f1b51..36e8119f79 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -3176,20 +3176,8 @@ static uint64_t midr_read(CPUARMState *env, const ARMCPRegInfo *ri)
 static uint64_t mpidr_read_val(CPUARMState *env)
 {
     ARMCPU *cpu = env_archcpu(env);
-    uint64_t mpidr = cpu->mp_affinity;
 
-    if (arm_feature(env, ARM_FEATURE_V7MP)) {
-        mpidr |= (1U << 31);
-        /*
-         * Cores which are uniprocessor (non-coherent)
-         * but still implement the MP extensions set
-         * bit 30. (For instance, Cortex-R5).
-         */
-        if (cpu->mp_is_up) {
-            mpidr |= (1u << 30);
-        }
-    }
-    return mpidr;
+    return GET_IDREG(&cpu->isar, MPIDR);
 }
 
 static uint64_t mpidr_read(CPUARMState *env, const ARMCPRegInfo *ri)
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index f9f3d22014..4b947e9ba5 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1476,7 +1476,7 @@ int hvf_arch_init_vcpu(CPUState *cpu)
     assert_hvf_ok(ret);
 
     ret = hv_vcpu_set_sys_reg(cpu->accel->fd, HV_SYS_REG_MPIDR_EL1,
-                              arm_cpu->mp_affinity);
+                              GET_IDREG(&arm_cpu->isar, MPIDR));
     assert_hvf_ok(ret);
 
     pfr = GET_IDREG(&arm_cpu->isar, ID_AA64PFR0);
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 3d905f8565..9d68801c26 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2096,6 +2096,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (ret) {
         return ret;
     }
+    SET_IDREG(&cpu->isar, MPIDR, mpidr);
     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
 
     return kvm_arm_init_cpreg_list(cpu);
diff --git a/target/arm/whpx/whpx-all.c b/target/arm/whpx/whpx-all.c
index 18009d6c8d..024d18df04 100644
--- a/target/arm/whpx/whpx-all.c
+++ b/target/arm/whpx/whpx-all.c
@@ -842,7 +842,7 @@ int whpx_init_vcpu(CPUState *cpu)
 
     clean_whv_register_value(&val);
 
-    val.Reg64 = deposit64(arm_cpu->mp_affinity, 31, 1, 1 /* RES1 */);
+    val.Reg64 = GET_IDREG(&arm_cpu->isar, MPIDR);
     whpx_set_reg(cpu, WHvArm64RegisterMpidrEl1, val);
 
     clamp_id_aa64mmfr0_parange_to_ipa_size(&arm_cpu->isar);
-- 
2.53.0

