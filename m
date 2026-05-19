Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D85A409635
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197437; cv=none; b=WeXSl8+89NP4Qgf5DhDTqOrA9Jz3rpE6ooybKepJ9ddMBGnZCUJet1HnWY2+CSm2gkmy/Q9N5LXfM8SO+Pbymg2eiHpLiH2/nW1+fIsmEGhlhCHS86NVaW0f7gDUjefWeWOjxbIJMERpAXUXEczTEOFtXsyCHcdnWE9BddiMYuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197437; c=relaxed/simple;
	bh=JDc9kXjkRmwIoYHNLVLgPsQfCG2sb9qAy+6SUAbiFng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=c69/jDMdosuX3zhA0tVpHz3f/9XgqqdE8m/LJYDIUkA040MaHIMw/CuEjscgkq1mbVwDTvFe81QYuVU0FD4hPYuMGgS1q2D1hKho3Tlz6m5rRBPDQYFe+5D8Jt5OcDOl8GnyNIT3clnFtBsUmvm73THMIvpBEZsOyK3/DdVLMdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KAaP1H6i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KAaP1H6i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JE0HLZrwJsrBKolW/r84ZwL1/ywjoY3zz9XZRBLF7mk=;
	b=KAaP1H6iKIiH9I2cOfhsiXbu65aawl/CzcPXN1UrNKsgeocxocme+9Ld/LL16oHQojZaZf
	Do8eJuaDD4ErWENcj13oNaoVa20XY67UlvIsJO9yKGUbRG036dKrV0Ox+cjFK4aULwbrB4
	VcbZPGoles/quS1BH/zoiGSo3IM4u5Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-391-1eztZgn9OzObXBXA7DPV-g-1; Tue,
 19 May 2026 09:30:28 -0400
X-MC-Unique: 1eztZgn9OzObXBXA7DPV-g-1
X-Mimecast-MFC-AGG-ID: 1eztZgn9OzObXBXA7DPV-g_1779197423
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF04E19560AD;
	Tue, 19 May 2026 13:30:22 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 224A11800352;
	Tue, 19 May 2026 13:30:16 +0000 (UTC)
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
Subject: [PATCH v5 10/18] target/arm/cpu64: Retrieve writable ID reg map in aarch64_host_initfn()
Date: Tue, 19 May 2026 15:27:24 +0200
Message-ID: <20260519132905.145643-11-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: zkBU0W4f6lGR6PxMPduczrVEvSLMPJ8Ydx356RT8Q48_1779197423
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Store the writable_map array in the CPU state and populate it
in aarch64_host_initfn(). In case the retrieval fails we simply
free and null the pointer: this will indicate that the writable_map
is not usable in subsequent patches.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/cpu.h   | 3 +++
 target/arm/cpu64.c | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index a0a1d7fbe3..3558460333 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1073,6 +1073,9 @@ struct ArchCPU {
     /* KVM steal time */
     OnOffAuto kvm_steal_time;
 
+    /* ID reg writable bitmask */
+    uint64_t *writable_map;
+
     /* Uniprocessor system with MP extensions */
     bool mp_is_up;
 
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index a93ad2da5a..f2edbfc437 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -851,6 +851,7 @@ static void kvm_arm_set_cpreg_mig_tolerances(ARMCPU *cpu)
 static void aarch64_host_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    int ret;
 
 #if defined(CONFIG_NITRO)
     if (nitro_enabled()) {
@@ -861,6 +862,14 @@ static void aarch64_host_initfn(Object *obj)
 
 #if defined(CONFIG_KVM)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
+
+    cpu->writable_map = g_new(uint64_t, KVM_ARM_FEATURE_ID_RANGE_SIZE);
+
+    ret = kvm_arm_get_writable_id_regs(cpu->writable_map);
+    if (ret) {
+        g_free(cpu->writable_map);
+        cpu->writable_map = NULL;
+    }
     kvm_arm_set_cpu_features_from_host(cpu);
     aarch64_add_sve_properties(obj);
 #elif defined(CONFIG_HVF)
-- 
2.53.0

