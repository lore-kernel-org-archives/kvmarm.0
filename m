Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306DA377575
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639582; cv=none; b=rnSxpoR4qewgaDbVTGuFWm4pcq9QVHF2eXNInLATyKCOnIiPHVtM/5XsMb0fhKzPZJT1Ee+xc1p1JCt3uxROb52/8KWiWZkO4y4vLJW5plfbtXI1T9kvxnitBgPyMaWVUQmU0zHaiOza1DJUc1B/JjEVfwdG3OFIWNVSyKaIUg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639582; c=relaxed/simple;
	bh=NEGC9ZEgkhW2e+UV1+jeAzhRYI9pdwrqJ+2RNbbUQhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=VJC851dpdPqynSlguGfUI5apEURZbGYEYQ2YkYZi5AHauUfekJHu6M4rHzGHwsTlWSOI4fVI6/VgWh+JpW8IyBQfHltjzpBabvq/wyZVRqUznl+tf1Xe5Sp/j0q9VczvbUWsN9vgNXQ2tmkRYahTscDRkZAA4iIRmPPo0dvlJfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IltOYsj4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IltOYsj4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eWAeOoa1Aggv8+wq6e4woSeOMPDynBiaXDMHTvXpmn8=;
	b=IltOYsj4H2kX3eC20LuLn1tRtpqLCZUipvc8dioz/+y00FKbyBUDuiXoGtqTbAJcGTvuuU
	tQ3BFi4UXbjQB82pB7kltGaiTxebe/yz2wk8f1NANrLMx846ozOYIpgfCjgEO5CMKl67Bl
	n10DujyRS1T/U5FnpI9apVFkizL/Q6s=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-446--t0Vb-m-NQunNUWAFWP68Q-1; Sat,
 10 Oct 2026 13:39:36 +0000
X-MC-Unique: -t0Vb-m-NQunNUWAFWP68Q-1
X-Mimecast-MFC-AGG-ID: -t0Vb-m-NQunNUWAFWP68Q_1791639575
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E72AC180A20A;
	Sat, 10 Oct 2026 13:39:34 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D77230000E5;
	Sat, 10 Oct 2026 13:39:30 +0000 (UTC)
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
Subject: [PATCH v10 24/26] target/arm/kvm: Introduce kvm_arm_create_init_scratch_vcpu()
Date: Sat, 10 Oct 2026 15:36:28 +0200
Message-ID: <20261010133725.642498-25-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: GLVYv7b34AhBCgC3SfS2o0U7yOKr8jlqTCIh18HkzSk_1791639575
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce kvm_arm_create_init_scratch_vcpu() that allows to create
and initialize a scratch vcpu from cpu settings. We want to use
this in arm-qmp-cmds code as well as kvm_arm_destroy_scratch_host_vcpu
so export them.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v9 -> v10:
- pass the fdarray as a param
---
 target/arm/kvm_arm.h  | 19 ++++++++++++++++++-
 target/arm/kvm-stub.c | 10 ++++++++++
 target/arm/kvm.c      | 13 +++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index ccab33e571..2e7e02e4a4 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -118,11 +118,28 @@ struct kvm_vcpu_init;
 bool kvm_arm_create_scratch_host_vcpu(int *fdarray,
                                       struct kvm_vcpu_init *init, Error **errp);
 
+/**
+ * kvm_arm_create_init_scratch_vcpu:
+ * @cpu: ARMCPU whose kvm init features to inherit
+ * @fdarray: array of fds filled as by kvm_arm_create_scratch_host_vcpu
+ *
+ * Create and initialize a scratch vcpu inheriting the features set
+ * on @cpu.
+ *
+ * Return the vcpu fd on success or -1 on failure with a corresponding
+ * Error handle. On success, @fdarray is populated and must be torn down
+ * with kvm_arm_destroy_scratch_host_vcpu().
+ */
+int kvm_arm_create_init_scratch_vcpu(ARMCPU *cpu, int *fdarray, Error **errp);
+
+
 /**
  * kvm_arm_destroy_scratch_host_vcpu:
  * @fdarray: array of fds as set up by kvm_arm_create_scratch_host_vcpu
+ *           or kvm_arm_create_init_scratch_vcpu
  *
- * Tear down the scratch vcpu created by kvm_arm_create_scratch_host_vcpu.
+ * Tear down the scratch vcpu created by kvm_arm_create_scratch_host_vcpu
+ * or kvm_arm_create_init_scratch_vcpu.
  */
 void kvm_arm_destroy_scratch_host_vcpu(int *fdarray);
 
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 8e6fae0a4d..c9387f5c8c 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -126,3 +126,13 @@ bool kvm_idreg_write_scratch_vcpu(ARMCPU *cpu, int cpufd,
 {
     g_assert_not_reached();
 }
+
+int kvm_arm_create_init_scratch_vcpu(ARMCPU *cpu, int *fdarray, Error **errp)
+{
+    g_assert_not_reached();
+}
+
+void kvm_arm_destroy_scratch_host_vcpu(int *fdarray)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 840501f9bf..ebe4f408e2 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2228,6 +2228,19 @@ static void kvm_arm_vcpu_prepare_init_features(ARMCPU *cpu)
     }
 }
 
+int kvm_arm_create_init_scratch_vcpu(ARMCPU *cpu, int *fdarray, Error **errp)
+{
+    struct kvm_vcpu_init init = {.target = cpu->kvm_target, };
+
+    kvm_arm_vcpu_prepare_init_features(cpu);
+    memcpy(init.features, cpu->kvm_init_features, sizeof(init.features));
+
+    if (!kvm_arm_create_scratch_host_vcpu(fdarray, &init, errp)) {
+        return -1;
+    }
+    return fdarray[2];
+}
+
 int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
 {
     int ret;
-- 
2.53.0

