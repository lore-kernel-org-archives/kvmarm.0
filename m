Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9103039BFE5
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793824; cv=none; b=NjmsqwcIFO0nm2LUQXH3K7yr8bhy0XbmipJB4C9quPBUopstOb8+rf2xtcvjqJ4XTCmwaa72LTFS64ak82FNPwUgK4LggzbNZQniCTT67gQ1hxuv09NM4aVP2t7gGhMcsSDDu09qJl3K6evpDVIqNEnbAm4jOvdv1bq+xK9YVlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793824; c=relaxed/simple;
	bh=92Y8plxw/d+1E0S4jxsp8Eai+WYgeO37LdbUx0M/fAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=iUznDJ8Ut+zwzL6cadfz9ANRT9JFwG6vKK7JUyjCYW9ofld08dEKE48E0GbtHM3Jm+pWcJ31EYWS4eyyL/rfe5k4TV9p6xLZ/vt4/ItoJf7RL4u/omonN0Fg2CNN5ujnuovBfGnsRNumfB8cTZ/FkZ5qVA5ZL0PmZHO03CcsFqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EUGOn4/p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EUGOn4/p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lW1RxLjyBAHEYglWJkPrIno8W4NRQgIUmy0VBomca+0=;
	b=EUGOn4/piGz8z2stA0oLCAx5GtkeMVh+cumQHWQWsy4otZXzq332b5nIioYt6746xJnk62
	quruGGNLkOrukCs/InsDeFgsai6VM28L5WVNYple3Yc7LTIlT8h1un444b8kA2h5hiXuD2
	6x8p/1VnXXHM/oNWmwitq7bXDF5hgrM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-jw1-1R8VOLaBWuXaExnpog-1; Sun,
 03 May 2026 03:36:59 -0400
X-MC-Unique: jw1-1R8VOLaBWuXaExnpog-1
X-Mimecast-MFC-AGG-ID: jw1-1R8VOLaBWuXaExnpog_1777793816
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CFAC1956046;
	Sun,  3 May 2026 07:36:56 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A79B1800345;
	Sun,  3 May 2026 07:36:50 +0000 (UTC)
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
Subject: [PATCH v4 11/17] arm/kvm: write back modified ID regs to KVM
Date: Sun,  3 May 2026 09:33:31 +0200
Message-ID: <20260503073541.790215-12-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: jGoO13QoGFAxupzf6lf8NCi9WEul1L8nad6fmTGeoYM_1777793816
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We want to give a chance to override the value of host ID regs.
In a previous patch we made sure all their values could be fetched
through kvm_get_one_reg() calls before their modification. After
their potential modification we need to make sure we write back
the values through kvm_set_one_reg() calls.

Make sure the cpreg_list is modified with updated values and
transfer those values back to kvm.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/kvm.c        | 59 ++++++++++++++++++++++++++++++++++++++++-
 target/arm/trace-events |  1 +
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 1a9b91bf8a..ca9a7d9439 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -275,6 +275,21 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
     return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
 }
 
+static int kvm_feature_idx_to_idregs_idx(int kidx)
+{
+    int op1, crm, op2;
+    ARMSysRegs sysreg;
+
+    op1 = kidx / 64;
+    if (op1 == 2) {
+        op1 = 3;
+    }
+    crm = (kidx % 64) / 8;
+    op2 = kidx % 8;
+    sysreg = ENCODE_ID_REG(3, op1, 0, crm, op2);
+    return get_sysreg_idx(sysreg);
+}
+
 static int idregs_idx_to_kvm_feature_idx(ARMIDRegisterIdx idx)
 {
     ARMSysRegs sysreg = id_register_sysreg[idx];
@@ -1197,6 +1212,39 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
     return true;
 }
 
+static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
+{
+    if (!cpu->writable_map) {
+        return;
+    }
+    for (int i = 0; i < NR_ID_REG_MASKS; i++) {
+        uint64_t writable_mask = cpu->writable_map->regs[i];
+        uint64_t *cpreg;
+
+        if (writable_mask) {
+            uint64_t previous, new;
+            int idx = kvm_feature_idx_to_idregs_idx(i);
+            ARM64SysReg *sysregdesc;
+            uint32_t sysreg;
+
+            if (idx == -1) {
+                /* sysreg writable, but we don't know it */
+                continue;
+            }
+            sysregdesc = &arm64_id_regs[idx];
+            sysreg = sysregdesc->sysreg;
+            cpreg = kvm_arm_get_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
+            previous = *cpreg;
+            new = cpu->isar.idregs[idx];
+            if (previous != new) {
+                *cpreg = new;
+                trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc->name,
+                                                            previous, new);
+            }
+        }
+    }
+}
+
 void kvm_arm_reset_vcpu(ARMCPU *cpu)
 {
     int ret;
@@ -2148,7 +2196,16 @@ int kvm_arch_init_vcpu(CPUState *cs)
     }
     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
 
-    return kvm_arm_init_cpreg_list(cpu);
+    ret = kvm_arm_init_cpreg_list(cpu);
+    if (ret) {
+        return ret;
+    }
+    /* overwrite writable ID regs with their updated property values */
+    kvm_arm_writable_idregs_to_cpreg_list(cpu);
+
+    write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
+
+    return 0;
 }
 
 int kvm_arch_destroy_vcpu(CPUState *cs)
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 8c7faf57c7..c25d2a1191 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -14,6 +14,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
+kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

