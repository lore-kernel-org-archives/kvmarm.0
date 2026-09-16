Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C7527FD5B
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570186; cv=none; b=OQ9M4q2Fo1SAR89h5mfe76WxmeWiq9+mqa3mdst2YilZBOOjkKOi3njBxiNqp7urlbs+s2lP65LAdzmR39jznHAhlCCW2CAf++HBH6suKhYHqrrI2RT8pEkVtIIYIxnUm58dX4wKihSXpSltS4Xm2jkTAKGwYMeKQgRkeyHPYus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570186; c=relaxed/simple;
	bh=Vjjp5x7hxXsD/bKTUbJk5d0Q3BmKOl3ILW8xTWbd6IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=plb3P4TAkYHdYXozKRjOgY0aqXYf8bFv7vrc+6J6YKWBradFlTv2QfHywgRPZDe6eW8MqzA3sovh5Wtgp+sReZEF0r7LE3YsRQU3BsUfprglZ6FjcOleIuhHZnsKoQqhovd+ViY+H/MD9xi6MyYzMDJm8Ntlx1xs3PGJZq7fd1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZE9dludX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZE9dludX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dBJ5GLKEsBXPj8B/DijWFLtxBgu3dGuSeoZoL9j1+VQ=;
	b=ZE9dludXJLprUcgY+dpbg/eXWISQRDmu5/l2v9KpzSNNCXcyONHpxZk4A8ObdAeeNCHHJT
	U0LEx82jCXuJO0UwxL37XBphW7Lb3MilgqcFfLf8K1l9Vm7cbSCKckwCIqVe6nm+sHRDgK
	fnD0eIkb0z+N8mSbsChzAQe3tms289M=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-112-V_-kREX8MniLi9F5W18BYw-1; Wed,
 16 Sep 2026 10:49:40 -0400
X-MC-Unique: V_-kREX8MniLi9F5W18BYw-1
X-Mimecast-MFC-AGG-ID: V_-kREX8MniLi9F5W18BYw_1789570178
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FA1D18005BA;
	Wed, 16 Sep 2026 14:49:38 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 39E2E19560AB;
	Wed, 16 Sep 2026 14:49:33 +0000 (UTC)
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
Subject: [PATCH v9 24/26] target/arm/kvm: Introduce kvm_arm_create_init_scratch_vcpu()
Date: Wed, 16 Sep 2026 16:45:47 +0200
Message-ID: <20260916144721.751810-25-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: q2RLd7AXl7CLNi4oo3zqomOZZY1HSOd84GwakksnmQQ_1789570178
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce kvm_arm_create_init_scratch_vcpu() that allows to create
and initialize a scratch vcpu from cpu settings. We want to use
this in arm-qmp-cmds code as well as kvm_arm_destroy_scratch_host_vcpu
so export them.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm_arm.h  | 11 +++++++++++
 target/arm/kvm-stub.c | 10 ++++++++++
 target/arm/kvm.c      | 14 ++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 185018e00c..4ce58d6b0e 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -118,6 +118,17 @@ struct kvm_vcpu_init;
 bool kvm_arm_create_scratch_host_vcpu(int *fdarray,
                                       struct kvm_vcpu_init *init, Error **errp);
 
+/**
+ * kvm_arm_create_init_scratch_vcpu:
+ * Create and initialize a scratch vcpu inheriting the features set
+ * on the vcpu
+ *
+ * Return the vcpu fd on success or -1 on failure with a corresponding
+ * Error handle
+ */
+int kvm_arm_create_init_scratch_vcpu(ARMCPU *cpu, Error **errp);
+
+
 /**
  * kvm_arm_destroy_scratch_host_vcpu:
  * @fdarray: array of fds as set up by kvm_arm_create_scratch_host_vcpu
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 8e6fae0a4d..dd2e94e45f 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -126,3 +126,13 @@ bool kvm_idreg_write_scratch_vcpu(ARMCPU *cpu, int cpufd,
 {
     g_assert_not_reached();
 }
+
+int kvm_arm_create_init_scratch_vcpu(ARMCPU *cpu, Error **errp)
+{
+    g_assert_not_reached();
+}
+
+void kvm_arm_destroy_scratch_host_vcpu(int *fdarray)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index a459942a73..800e5f3020 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2485,6 +2485,20 @@ static void kvm_arm_vcpu_prepare_init_features(ARMCPU *cpu)
     }
 }
 
+int kvm_arm_create_init_scratch_vcpu(ARMCPU *cpu, Error **errp)
+{
+    struct kvm_vcpu_init init = {.target = cpu->kvm_target, };
+    int fdarray[3];
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

