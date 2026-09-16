Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B25B342514
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570145; cv=none; b=Ek05Pl2nZtsrcL6+Df/eDgM7MpaqJVwpKW+woYq5OvuvDCF+nKFV5CweVM2lLgDpB2Ru5/+VKx/jst85ZCglXgH8WmTF+EQEUNlfRgok5fJf7/Ie2fq4W00stWC2QngFSZxsZzGSQdCq1fwcBTRhIp/G+2NlzqM9aa6D4aRr3tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570145; c=relaxed/simple;
	bh=H5/u1PHYPY7SGFc29Qn+VOaM+aWSW2hQgg5le1UVhow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=VbdU8YQVnIk/DapTQnpbYgaB4spzd7namPR8bCidIGo+hzY2+CnsEtcslOpqPEXEFihoPfktPzo4cx1vlqUI9OcFtmLth+FHUbXcQr3vAF5k/DhT7PDw+r3NnNqhqQ2By1LpZxlg9ALu1MFDfekadvuAOsgwt+oNrdO5HoiaNVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vq0nkDtj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vq0nkDtj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=el/7Ne3b49tKOZNplBEhsA61ndHX7VAWjhSTSblc2bE=;
	b=Vq0nkDtjUA6qp4jsbHdbwId/Tue6wY0tSqZHJwjj/slNehU1AQU7sHDY8I5SfSFLJOSJGN
	0Gp36C9xGaexar1vidrRB0LRs7FdFGqSPWY1efimas5PtB6xFg0FOyUububmLyH6q0jSpb
	XCqST2Bw/2AIZaANO3SCkAUxm61cXEk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-OTaXgNFQOWyIUXfkyY1qvA-1; Wed,
 16 Sep 2026 10:48:57 -0400
X-MC-Unique: OTaXgNFQOWyIUXfkyY1qvA-1
X-Mimecast-MFC-AGG-ID: OTaXgNFQOWyIUXfkyY1qvA_1789570135
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA3341800EF6;
	Wed, 16 Sep 2026 14:48:55 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A1EF195604D;
	Wed, 16 Sep 2026 14:48:51 +0000 (UTC)
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
Subject: [PATCH v9 16/26] target/arm/kvm: Apply SYSREG props to the final vcpu
Date: Wed, 16 Sep 2026 16:45:39 +0200
Message-ID: <20260916144721.751810-17-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: uGCHBI8HicqBcIHQAzmf1MMsQY_HCX5r_9LoT4Nn6tU_1789570135
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

SYSREG prop settings were recorded in a hashtable but they
are not yet injected on guest. Iterate over all set fields and
apply the new value through KVM_SET_ONE_REG. The new field
value overrides the current observable vcpu register value.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm.c        | 65 +++++++++++++++++++++++++++++++++++++++++
 target/arm/trace-events |  1 +
 2 files changed, 66 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 3ec2618cc1..ddf320d0e6 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -343,6 +343,9 @@ static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
 #define MAKE_IDREG_KEY(reg_idx, field_shift) \
     (((uint64_t)(reg_idx) << 8) | ((uint64_t)(field_shift) & 0xFF))
 
+#define KEY_TO_REG_IDX(key)     ((uint32_t)(((uint64_t)(key)) >> 8))
+#define KEY_TO_SHIFT(key)       ((uint8_t)(((uint64_t)(key)) & 0xFF))
+
 static void set_sysreg_prop(Object *obj, Visitor *v,
                             const char *name, void *opaque,
                             Error **errp)
@@ -2215,6 +2218,63 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
+static int kvm_arm_apply_sysreg_props(ARMCPU *cpu, Error **errp)
+{
+    uint64_t *idregs = cpu->isar.idregs;
+    gpointer key_ptr, value_ptr;
+    CPUState *cs = CPU(cpu);
+    GHashTableIter iter;
+
+    g_hash_table_iter_init(&iter, cpu->sysreg_props);
+
+    while (g_hash_table_iter_next(&iter, &key_ptr, &value_ptr)) {
+        uint64_t key = (uint64_t)key_ptr;
+        uint64_t value = (uint64_t)value_ptr;
+        uint32_t reg_idx = KEY_TO_REG_IDX(key);
+        uint8_t lower    = KEY_TO_SHIFT(key);
+        ARM64SysReg *reg = &arm64_id_regs[reg_idx];
+        struct kvm_one_reg kvm_reg;
+        uint64_t current, old, mask;
+        uint64_t kvm_idx;
+        ARM64SysRegField *field = get_field(lower, reg);
+        int length = field->length;
+        uint64_t oldfv;
+        int ret;
+
+        mask = MAKE_64BIT_MASK(lower, length);
+        value = value << lower;
+
+        old = idregs[reg_idx];
+
+        kvm_idx = idregs_sysreg_to_kvm_reg(id_register_sysreg[reg_idx]);
+        ret = read_sys_reg64(cs->kvm_fd, &current, kvm_idx);
+        if (ret) {
+            error_setg(errp, "failed to read the current value of %s",
+                       reg->name);
+            return ret;
+        }
+        oldfv = (current & mask) >> lower;
+
+        idregs[reg_idx] = current & ~mask;
+        idregs[reg_idx] |= value;
+
+        kvm_reg.id = kvm_idx;
+        kvm_reg.addr = (uintptr_t)&idregs[reg_idx];
+
+        ret = ioctl(cs->kvm_fd, KVM_SET_ONE_REG, &kvm_reg);
+        if (ret) {
+            error_setg(errp, "failed to apply new value 0x%"PRIx64" for field %s.%s "
+                       "(previous is 0x%"PRIx64"): %m", idregs[reg_idx],
+                       reg->name, field->name, oldfv);
+            return ret;
+        }
+
+        trace_apply_sysreg_prop(reg->name, field->name, old, current,
+                                mask, value, idregs[reg_idx]);
+    }
+    return 0;
+}
+
 int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
 {
     int ret;
@@ -2315,6 +2375,11 @@ int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
     }
     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
 
+    ret = kvm_arm_apply_sysreg_props(cpu, errp);
+    if (ret) {
+        return ret;
+    }
+
     return kvm_arm_init_cpreg_list(cpu);
 }
 
diff --git a/target/arm/trace-events b/target/arm/trace-events
index d72ad6b671..b4d2b45a7d 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -18,6 +18,7 @@ kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint6
 decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "%s [%d:%d] is writable (prop %s)"
 get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
 set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
+apply_sysreg_prop(const char *reg_name, const char *field_name, uint64_t old, uint64_t current, uint64_t mask, uint64_t field_value, uint64_t new) "%s.%s old=0x%"PRIx64" current=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new=0x%"PRIx64
 nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
 
 # cpu.c
-- 
2.53.0

