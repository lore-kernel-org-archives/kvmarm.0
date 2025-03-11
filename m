Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C3918870C
	for <kvmarm@lists.linux.dev>; Tue, 11 Mar 2025 16:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741710569; cv=none; b=SHrx5sbPciFl0YAwCNHQ22kwLWszYcvBWEzZebsU4azcYAS2clepHIgfAzNv1i1xWnTFdd4QHdp/TyJuLkvBW7gGXLwJEK+QftTgEF2tvWC7g9CugRgHY7OBic071j9iJ9cNe6inS4l5KNzNVHP5edM+cuaid6SOz32hFjzrRyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741710569; c=relaxed/simple;
	bh=QP/rr/gFJk7LkS22yvJhQ8JLMeLI6srDNzkm1jTI5h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=jevkm5IwHD6iTBxx7euwEPsIlaGe8uzJYkxQC76K26peeKu5YE+2E75FLsRd+FJ/AaTTHviu91BtwkFrFbRSJhsi1s8qgDSdZ4TpHsbDeemz7uc432HPe7xxZtOlelqoCnfJhzr/JI3MzudVPRpEHX6FO8cLsBQmFWjxtq5R06w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vb+QmMU+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vb+QmMU+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741710566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LGStgYV+NoDUM0TFlnGX24zS6GH+FXY3wLNCNMI/HLk=;
	b=Vb+QmMU+jfzbaRABbD1tIRrw+en3ILy/H8IRDn6/h6ECObJsz4yrIbFMJdOpNmwrc+8pOJ
	Bq+uC496IyrA74NIpeuLd6YGJQl8MyLAUaiiCt3g0h7PEMaiqzVbWkjWPhlKtfevV4F58z
	ILZdsaNG54Ouh0uSLA4Zkc7wUZoa4Gs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-398-3wSJKhmTNJicwPWxYgBg6w-1; Tue,
 11 Mar 2025 12:29:21 -0400
X-MC-Unique: 3wSJKhmTNJicwPWxYgBg6w-1
X-Mimecast-MFC-AGG-ID: 3wSJKhmTNJicwPWxYgBg6w_1741710559
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 113011801A00;
	Tue, 11 Mar 2025 16:29:19 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.185])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE87F180AF7C;
	Tue, 11 Mar 2025 16:29:03 +0000 (UTC)
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
	jdenemar@redhat.com,
	agraf@csgraf.de
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 02/14] arm/kvm: add accessors for storing host features into idregs
Date: Tue, 11 Mar 2025 17:28:12 +0100
Message-ID: <20250311162824.199721-3-cohuck@redhat.com>
In-Reply-To: <20250311162824.199721-1-cohuck@redhat.com>
References: <20250311162824.199721-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-sysregs.h |  4 ++++
 target/arm/kvm.c         | 22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
index b95320b5b595..68a7de737185 100644
--- a/target/arm/cpu-sysregs.h
+++ b/target/arm/cpu-sysregs.h
@@ -34,4 +34,8 @@ extern const uint32_t id_register_sysreg[NUM_ID_IDX];
 
 int get_sysreg_idx(ARMSysRegs sysreg);
 
+#ifdef CONFIG_KVM
+uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg);
+#endif
+
 #endif /* ARM_CPU_SYSREGS_H */
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index da30bdbb2349..a0551f8a5a23 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -246,6 +246,28 @@ static bool kvm_arm_pauth_supported(void)
             kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
 }
 
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
+/* read a sysreg value and store it in the idregs */
+static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf, ARMIDRegisterIdx index)
+{
+    uint64_t *reg;
+    int ret;
+
+    reg = &ahcf->isar.idregs[index];
+    ret = read_sys_reg64(fd, reg,
+                         idregs_sysreg_to_kvm_reg(id_register_sysreg[index]));
+    return ret;
+}
+
 static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 {
     /* Identify the feature bits corresponding to the host CPU, and
-- 
2.48.1

