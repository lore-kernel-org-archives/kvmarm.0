Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23411E991D
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 11:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738926231; cv=none; b=C1Uj71LQ0y1H0hJs24FbsYuwAXX/nWjnlJihmnrE4eWirkOVCJVl/11oo29VLm7EUElCz9ponTXddzg/UQqTB2GFPkEYEPAf3BO6auIA0F1Ohhm/fvp7ba8Jb3kanv24u9G73BGmGgvoE3bEy7+56ahuHOAmwU7gFMT/tPPDKo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738926231; c=relaxed/simple;
	bh=HPn2JrROJT/7TmPYNWUOlgfpNtLJCe4xorqGs8SGPBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=f/RyYLwmPSg4U8GYkPawRwqXndYKq+PtqEM1woiL9O7ZNCntW2INx8aesrB5fUKm4fghoShmq5M1yPRmMTx7qyWDse6M7zao2ASB909bBRGKUkgomVEuI3CydaFhm1SDONjPObdpHBYh4m8/HTxp4ml4sipBjraa0+u7QBqrIQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iAcAyVtN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iAcAyVtN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738926228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QhM6ratgTKBjpRGe2Psw2shNLbuzwim/PSIe0653KDs=;
	b=iAcAyVtNYoD8e2sULvUm6ump5bpoZ0oUoQwxwpTALSeB1SGGQ9HhC1XjKft+3hC5cet6Bw
	umHfw0v/lg26kefoMMD4DyiI+WHn1oS5fda21gV8vUhdvzXj0jIWYMV05Cd4iRjghfcm5k
	90evmJf2Vl5ruRCkVo/rq46b7VWCGW4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-rV1ys2iaMPmhcbAahxLC7A-1; Fri,
 07 Feb 2025 06:03:44 -0500
X-MC-Unique: rV1ys2iaMPmhcbAahxLC7A-1
X-Mimecast-MFC-AGG-ID: rV1ys2iaMPmhcbAahxLC7A
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A75C61955DB8;
	Fri,  7 Feb 2025 11:03:42 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.130])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 68A8219560AF;
	Fri,  7 Feb 2025 11:03:27 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 02/15] arm/kvm: add accessors for storing host features into idregs
Date: Fri,  7 Feb 2025 12:02:35 +0100
Message-ID: <20250207110248.1580465-3-cohuck@redhat.com>
In-Reply-To: <20250207110248.1580465-1-cohuck@redhat.com>
References: <20250207110248.1580465-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-sysregs.h |  3 +++
 target/arm/cpu64.c       | 25 +++++++++++++++++++++++++
 target/arm/kvm.c         | 30 ++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
index de09ebae91a5..54a4fadbf0c1 100644
--- a/target/arm/cpu-sysregs.h
+++ b/target/arm/cpu-sysregs.h
@@ -128,4 +128,7 @@ static const uint32_t id_register_sysreg[NUM_ID_IDX] = {
     [CTR_EL0_IDX] = SYS_CTR_EL0,
 };
 
+int get_sysreg_idx(ARMSysRegs sysreg);
+uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg);
+
 #endif /* ARM_CPU_SYSREGS_H */
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 8188ede5cc8a..9ae78253cb34 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -736,6 +736,31 @@ static void aarch64_a53_initfn(Object *obj)
     define_cortex_a72_a57_a53_cp_reginfo(cpu);
 }
 
+#ifdef CONFIG_KVM
+
+int get_sysreg_idx(ARMSysRegs sysreg)
+{
+    int i;
+
+    for (i = 0; i < NUM_ID_IDX; i++) {
+        if (id_register_sysreg[i] == sysreg) {
+            return i;
+        }
+    }
+    return -1;
+}
+
+uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg)
+{
+    return ARM64_SYS_REG((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >> CP_REG_ARM64_SYSREG_OP0_SHIFT,
+                         (sysreg & CP_REG_ARM64_SYSREG_OP1_MASK) >> CP_REG_ARM64_SYSREG_OP1_SHIFT,
+                         (sysreg & CP_REG_ARM64_SYSREG_CRN_MASK) >> CP_REG_ARM64_SYSREG_CRN_SHIFT,
+                         (sysreg & CP_REG_ARM64_SYSREG_CRM_MASK) >> CP_REG_ARM64_SYSREG_CRM_SHIFT,
+                         (sysreg & CP_REG_ARM64_SYSREG_OP2_MASK) >> CP_REG_ARM64_SYSREG_OP2_SHIFT);
+}
+
+#endif
+
 static void aarch64_host_initfn(Object *obj)
 {
 #if defined(CONFIG_KVM)
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index da30bdbb2349..3b8bb5661f2b 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -246,6 +246,36 @@ static bool kvm_arm_pauth_supported(void)
             kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
 }
 
+/* read a 32b sysreg value and store it in the idregs */
+static int get_host_cpu_reg32(int fd, ARMHostCPUFeatures *ahcf, ARMSysRegs sysreg)
+{
+    int index = get_sysreg_idx(sysreg);
+    uint64_t *reg;
+    int ret;
+
+    if (index < 0) {
+        return -ERANGE;
+    }
+    reg = &ahcf->isar.idregs[index];
+    ret = read_sys_reg32(fd, (uint32_t *)reg, idregs_sysreg_to_kvm_reg(sysreg));
+    return ret;
+}
+
+/* read a 64b sysreg value and store it in the idregs */
+static int get_host_cpu_reg64(int fd, ARMHostCPUFeatures *ahcf, ARMSysRegs sysreg)
+{
+    int index = get_sysreg_idx(sysreg);
+    uint64_t *reg;
+    int ret;
+
+    if (index < 0) {
+        return -ERANGE;
+    }
+    reg = &ahcf->isar.idregs[index];
+    ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
+    return ret;
+}
+
 static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 {
     /* Identify the feature bits corresponding to the host CPU, and
-- 
2.48.1

