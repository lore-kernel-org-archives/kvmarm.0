Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8430514A609
	for <kvmarm@lists.linux.dev>; Thu,  9 May 2024 09:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715245562; cv=none; b=lJlNHrPzysPg/tDxHQGg0739IWOZEKJvW7tNGVLXfkJhvh35cJCT8m9KlP3HJisTeY1DetekMEB8u/hh4HoNSXgaHv/wAvrHsiG2pUdHz0oPjnJXqSkwoNNufIZUMl7iHJlMQlUDHB8ypQI4ciZy6eRMJAyA/YDDdhISgrmVTg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715245562; c=relaxed/simple;
	bh=gEWxJ58OcCXVPf/+/oXFf84VWQLDYJynMCHfovbxfX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QGjsHW/VcyQA799Wb9Ox/XVYXUeutxWvpBc0vxrtCFhK0969T5EUvHEbp1RvsFOFD3YYDDqFd2ztfcnxzbbtC5cJpERFaOvrsXU2U8LnTuVNxmYzL+vZYJQYxqhb8NiZ5Ekk3B6pQagzoO5PJMuHV2N7Vt1w8F8yJrTKjfFXI1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DCqZFQm5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DCqZFQm5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715245560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GETQ3hrHxWoIrW04sjlQA664+5zLvUuddQRMF0aOQ08=;
	b=DCqZFQm59NPKQWFBNUaMTUHxpwg0+E0MEg0u1q67FEMSEkVmdBS+VQPxxvzxRqubEN7Ndn
	WthHnHLsSAyJi2AY4mKnwfzGWWG4UmvfZ+Cm5+lz48UJSG/Vxpc/SgJY8CfAR4dJZKEyvG
	nU6/hqOltmYuejkrXFCX3UaJ4ttuObg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-FsTpJ-IwNHixTG-iDSQclg-1; Thu,
 09 May 2024 05:05:56 -0400
X-MC-Unique: FsTpJ-IwNHixTG-iDSQclg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B90D83C0BE32;
	Thu,  9 May 2024 09:05:55 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 75EF1100046E;
	Thu,  9 May 2024 09:05:55 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 3/3] KVM: selftests: aarch64: Add invalid filter test in pmu_event_filter_test
Date: Thu,  9 May 2024 05:05:40 -0400
Message-Id: <20240509090544.2063429-4-shahuang@redhat.com>
In-Reply-To: <20240509090544.2063429-1-shahuang@redhat.com>
References: <20240509090544.2063429-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Add the invalid filter test which sets the filter beyond the event
space and sets the invalid action to double check if the
KVM_ARM_VCPU_PMU_V3_FILTER will return the expected error.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 .../kvm/aarch64/pmu_event_filter_test.c       | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
index fb0fde1ed436..5423ffb659ba 100644
--- a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
@@ -8,6 +8,7 @@
  * This test checks if the guest only see the limited pmu event that userspace
  * sets, if the guest can use those events which user allow, and if the guest
  * can't use those events which user deny.
+ * It also checks that setting invalid filter ranges return the expected error.
  * This test runs only when KVM_CAP_ARM_PMU_V3, KVM_ARM_VCPU_PMU_V3_FILTER
  * is supported on the host.
  */
@@ -178,6 +179,41 @@ static void destroy_vpmu_vm(void)
 	kvm_vm_free(vpmu_vm.vm);
 }
 
+static void test_invalid_filter(void)
+{
+	struct kvm_pmu_event_filter invalid;
+	int ret;
+
+	pr_info("Test: test_invalid_filter\n");
+
+	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
+
+	vpmu_vm.vm = vm_create(1);
+	vpmu_vm.vcpu = vm_vcpu_add_with_vpmu(vpmu_vm.vm, 0, guest_code);
+	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
+					GICD_BASE_GPA, GICR_BASE_GPA);
+	__TEST_REQUIRE(vpmu_vm.gic_fd >= 0,
+		       "Failed to create vgic-v3, skipping");
+
+	/* The max event number is (1 << 16), set a range largeer than it. */
+	invalid = __DEFINE_FILTER(BIT(15), BIT(15) + 1, 0);
+	ret = __kvm_device_attr_set(vpmu_vm.vcpu->fd, KVM_ARM_VCPU_PMU_V3_CTRL,
+				    KVM_ARM_VCPU_PMU_V3_FILTER, &invalid);
+	TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter range "
+		    "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
+		    ret, errno);
+
+	/* Set the Invalid action. */
+	invalid = __DEFINE_FILTER(0, 1, 3);
+	ret = __kvm_device_attr_set(vpmu_vm.vcpu->fd, KVM_ARM_VCPU_PMU_V3_CTRL,
+				    KVM_ARM_VCPU_PMU_V3_FILTER, &invalid);
+	TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter action "
+		    "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
+		    ret, errno);
+
+	destroy_vpmu_vm();
+}
+
 static void run_test(struct test_desc *t)
 {
 	pr_info("Test: %s\n", t->name);
@@ -300,4 +336,6 @@ int main(void)
 	TEST_REQUIRE(kvm_pmu_support_events());
 
 	run_tests();
+
+	test_invalid_filter();
 }
-- 
2.40.1

