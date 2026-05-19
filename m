Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A121285CAE
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197449; cv=none; b=TI5l0hAwAxr/UlbqL4bPP5ejFrESdx7zWRsku7MRMrSKavFM1VIpG3MEk6iM2lVHvAk8uvycD/JaZraAp4afYm+tlQpKj8PqFF5Y3TPnsm1YRoct8WepP+boO0epqpysbGFulY8itmDxPlWDWDXFCWDqXiejDwuWsTfH2m88RVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197449; c=relaxed/simple;
	bh=0othz6bYeRa0aaZjgXSYMGp6K2i06S0HHsDH+2S5qDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=EEMqq5xnKMuEEqZPwdou/VlJ6JGSxGPI7wuyRoyMMVs9n9ntTs0A8iKlsKjUDnpqsxQaqmfDIgBNEjI2J6WtQ+uOtPWEF0+Vot3p/Qqy4oPTLums5GDKCj6yF+tXpTVmHuHKw48Cl/HNIZsly9GZb87C66FsAm6HWje5qLQgshY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fBvNs8E/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fBvNs8E/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0JfsTkaVVhnWdu4t9R24wJS1oRYKNcqs6QcOWn6v2Ik=;
	b=fBvNs8E/LJ6D9cdn4YN5SpdAoMIDNkotgDH+8ZE6Uk3FvSlb8i8DwDmdbDkWmM8stNd6Op
	VZYaxf+cK1ERxUubevOCekJhwzFqoq5AxNQXWMfK3IAmGzNZi/VieFzVx0D1DG7RmnOOx5
	brmTLR+yN59z+1MYcC8zX1UJyf4zt08=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-9f2ia-YmOj2Kp4fTFrDhgA-1; Tue,
 19 May 2026 09:30:39 -0400
X-MC-Unique: 9f2ia-YmOj2Kp4fTFrDhgA-1
X-Mimecast-MFC-AGG-ID: 9f2ia-YmOj2Kp4fTFrDhgA_1779197435
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEC281956095;
	Tue, 19 May 2026 13:30:35 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8CBC11800352;
	Tue, 19 May 2026 13:30:29 +0000 (UTC)
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
Subject: [PATCH v5 12/18] arm/kvm: write back modified ID regs to KVM
Date: Tue, 19 May 2026 15:27:26 +0200
Message-ID: <20260519132905.145643-13-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 5J6GR1M7KnEz2W2eeKi9xD_BngNlNTTGnRjQA7-VovM_1779197435
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In case some ID reg values were overriden after their
initialization in kvm_arm_get_host_cpu_features() we need to
copy the new value stored in isar.idregs array back to the
cpreg_list and then sync the cpreg_list to KVM.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

v4 -> v5:
- only call kvm_arm_writable_idregs_to_cpreg_list and
  write_list_to_kvmstate if writable_map is allocated
- reinitialize the cpreg list after sync (Jinqian)
---
 target/arm/kvm.c        | 69 ++++++++++++++++++++++++++++++++++++++++-
 target/arm/trace-events |  1 +
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 92219ee62e..30c5175c68 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -274,6 +274,21 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
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
@@ -1189,6 +1204,40 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
     return true;
 }
 
+/*
+ * Copy writable ID regs from isar.idregs[] to cpreg_list
+ * in case their value differs from the original init cpreg value
+ */
+static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
+{
+    for (int i = 0; i < KVM_ARM_FEATURE_ID_RANGE_SIZE; i++) {
+        uint64_t writable_mask = cpu->writable_map[i];
+
+        if (writable_mask) {
+            int idx = kvm_feature_idx_to_idregs_idx(i);
+            ARM64SysReg *sysregdesc;
+            uint64_t previous, new;
+            uint64_t *cpreg;
+            uint32_t sysreg;
+
+            if (idx == -1) {
+                /* sysreg writable, but we don't know it */
+                continue;
+            }
+            sysregdesc = &arm64_id_regs[idx];
+            sysreg = id_register_sysreg[idx];
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
@@ -2140,7 +2189,25 @@ int kvm_arch_init_vcpu(CPUState *cs)
     }
     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
 
-    return kvm_arm_init_cpreg_list(cpu);
+    ret = kvm_arm_init_cpreg_list(cpu);
+    if (ret) {
+        return ret;
+    }
+    /* overwrite writable ID regs with their updated property values */
+    if (cpu->writable_map) {
+        kvm_arm_writable_idregs_to_cpreg_list(cpu);
+        ret = write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
+        if (!ret) {
+            return -1;
+        }
+        /*
+         * modified values may have changed the visibility of some regs,
+         * reinitialize the cpreg_list accordingly
+         */
+         ret = kvm_arm_init_cpreg_list(cpu);
+    }
+
+    return ret;
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

