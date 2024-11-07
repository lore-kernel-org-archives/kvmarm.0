Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34BF1E5714
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 09:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972433; cv=none; b=L3MvB6fNE+T2EGQQoTB0QctXm8nURrLzwquTW09Ao4liKI7D7CG3JdjQpI8sPEu6U0Qs7XmfsWO6kxL5Erh9s8Q4fCDPtBbnsg+e16pm08yB///iTQSzgLFfb7wQF8O8qndnIW6tUfeJ3utEhx/L9rTgM8d/NSRvL34lOgX1yVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972433; c=relaxed/simple;
	bh=b8QiS4iAgyveI0VnUcGujWpksK44ypQ4/17QHKTahCI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNiX+XnLNITbo2MQGGWtnw0c9I9C1M0eaUNIyUIOTZivYqrEsFNlhhGfEkaYYSwVtrhfmpkKiFBT2bd9m8CSiulZv1I9HMJOC3zL0negOOMadCE54+Bmix7hIvIQOAr7h8VABet2sXuuxdVQ3WWQHwKlcSoRiE1Pm45/iohkDCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IPV5fYLL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPV5fYLL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730972430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8TfljcNBhF9C0Z/2BV2Oaq2DDL+Em2rYM63JxIdUTLQ=;
	b=IPV5fYLLPa7id/AqtcQyX21+5hnCR+otTcetmo5fA1iJkZoXkJy4Bf+TZIFfnWenlXwJod
	wL3HBQBUWteOIFKNfwjgdqU9TmDJgSsHvmT8sOBdcwEVsnMeQGuDymjVvRGT1Wwt6mlG7O
	KeDyKVFJTIcw7YD0+l5qU9xkIYuxXN0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-1h42Cmh5OJOPx15S4PD9GA-1; Thu,
 07 Nov 2024 04:40:24 -0500
X-MC-Unique: 1h42Cmh5OJOPx15S4PD9GA-1
X-Mimecast-MFC-AGG-ID: 1h42Cmh5OJOPx15S4PD9GA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F0801954B0E;
	Thu,  7 Nov 2024 09:40:22 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.192.86])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7765A1955F40;
	Thu,  7 Nov 2024 09:40:19 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	broonie@kernel.org,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	joey.gouly@arm.com,
	oliver.upton@linux.dev,
	shuah@kernel.org,
	pbonzini@redhat.com
Subject: [PATCH  3/3] KVM: selftests: Handle dead VM in vgic_init test
Date: Thu,  7 Nov 2024 10:38:50 +0100
Message-ID: <20241107094000.70705-4-eric.auger@redhat.com>
In-Reply-To: <20241107094000.70705-1-eric.auger@redhat.com>
References: <20241107094000.70705-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Commit df5fd75ee305 ("KVM: arm64: Don't eagerly teardown the vgic on init
error") changed the way the error is handled in case of incomplete
vgic setup. Now a KVM_REQ_VM_DEAD request is sent causing subsequent
KVM ioctl to fail. This now triggers a test assertion failure in
kvm_vm_free() which calls KVM_SET_USER_MEMORY_REGION2 ioctl.

Update the test so that it checks that after the partial vgic setup
the KVM_REQ_VM_DEAD has been sent and use the new kvm_vm_dead_free()
helper to free the resources.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/all/3f0918bf-0265-4714-9660-89b75da49859@sirena.org.uk/
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 41 +++++++++++--------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index b3b5fb0ff0a9..845108afce5e 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -101,6 +101,12 @@ static void vm_gic_destroy(struct vm_gic *v)
 	kvm_vm_free(v->vm);
 }
 
+static void vm_dead_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_dead_free(v->vm);
+}
+
 struct vgic_region_attr {
 	uint64_t attr;
 	uint64_t size;
@@ -335,7 +341,7 @@ static void test_vgic_then_vcpus(uint32_t gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
-	int ret, i;
+	int i;
 
 	v = vm_gic_create_with_vcpus(gic_dev_type, 1, vcpus);
 
@@ -345,10 +351,10 @@ static void test_vgic_then_vcpus(uint32_t gic_dev_type)
 	for (i = 1; i < NR_VCPUS; ++i)
 		vcpus[i] = vm_vcpu_add(v.vm, i, guest_code);
 
-	ret = run_vcpu(vcpus[3]);
-	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
+	run_vcpu(vcpus[3]);
+	TEST_ASSERT(vm_dead(v.vm), "dist/rdist overlap detected on 1st vcpu run");
 
-	vm_gic_destroy(&v);
+	vm_dead_gic_destroy(&v);
 }
 
 /* All the VCPUs are created before the VGIC KVM device gets initialized */
@@ -356,16 +362,15 @@ static void test_vcpus_then_vgic(uint32_t gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
-	int ret;
 
 	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS, vcpus);
 
 	subtest_dist_rdist(&v);
 
-	ret = run_vcpu(vcpus[3]);
-	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
+	run_vcpu(vcpus[3]);
+	TEST_ASSERT(vm_dead(v.vm), "dist/rdist overlap detected on 1st vcpu run");
 
-	vm_gic_destroy(&v);
+	vm_dead_gic_destroy(&v);
 }
 
 #define KVM_VGIC_V2_ATTR(offset, cpu) \
@@ -415,9 +420,9 @@ static void test_v3_new_redist_regions(void)
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
-	ret = run_vcpu(vcpus[3]);
-	TEST_ASSERT(ret == -ENXIO, "running without sufficient number of rdists");
-	vm_gic_destroy(&v);
+	run_vcpu(vcpus[3]);
+	TEST_ASSERT(vm_dead(v.vm), "running without sufficient number of rdists");
+	vm_dead_gic_destroy(&v);
 
 	/* step2 */
 
@@ -428,10 +433,10 @@ static void test_v3_new_redist_regions(void)
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
-	ret = run_vcpu(vcpus[3]);
-	TEST_ASSERT(ret == -EBUSY, "running without vgic explicit init");
+	run_vcpu(vcpus[3]);
+	TEST_ASSERT(vm_dead(v.vm), "running without vgic explicit init");
 
-	vm_gic_destroy(&v);
+	vm_dead_gic_destroy(&v);
 
 	/* step 3 */
 
@@ -604,8 +609,8 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
-	int ret, i;
 	uint64_t addr;
+	int i;
 
 	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1, vcpus);
 
@@ -626,11 +631,11 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
 	/* Attempt to run a vcpu without enough redist space. */
-	ret = run_vcpu(vcpus[2]);
-	TEST_ASSERT(ret && errno == EINVAL,
+	run_vcpu(vcpus[2]);
+	TEST_ASSERT(vm_dead(v.vm),
 		"redist base+size above PA range detected on 1st vcpu run");
 
-	vm_gic_destroy(&v);
+	vm_dead_gic_destroy(&v);
 }
 
 static void test_v3_its_region(void)
-- 
2.41.0

