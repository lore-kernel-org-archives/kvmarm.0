Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3126711701
	for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 07:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvXmBf97"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701242856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kImp972QN3FgRVvMXHDG7RWMY5d+pXRZAAAzWuPuZ8w=;
	b=DvXmBf97PFV8L3YqPsdlRGo9RZFLmexnpADhx7OAnsplfhdgz6RBRlzgdFbtes44/m9LZX
	7b8F7brOa4PmVNNmtkiLYlLh40NE1sPfLz78vTDwHi9ewsT9opu5ao+jVuFl0FkXKXg9Pt
	swlNFXjbczeFj82LRUiDKpdYSOSEvRA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-OI1xr56gNkmh64mcydxjVA-1; Wed,
 29 Nov 2023 02:27:30 -0500
X-MC-Unique: OI1xr56gNkmh64mcydxjVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAF9B285F99B;
	Wed, 29 Nov 2023 07:27:29 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDD561C060AE;
	Wed, 29 Nov 2023 07:27:29 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Eric Auger <eauger@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] KVM: selftests: aarch64: Add invalid filter test in pmu_event_filter_test
Date: Wed, 29 Nov 2023 02:27:07 -0500
Message-Id: <20231129072712.2667337-6-shahuang@redhat.com>
In-Reply-To: <20231129072712.2667337-1-shahuang@redhat.com>
References: <20231129072712.2667337-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Add the invalid filter test to double check if the KVM_ARM_VCPU_PMU_V3_FILTER
will return the expected error.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 .../kvm/aarch64/pmu_event_filter_test.c       | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
index 0e652fbdb37a..4c375417b194 100644
--- a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
@@ -7,6 +7,7 @@
  * This test checks if the guest only see the limited pmu event that userspace
  * sets, if the guest can use those events which user allow, and if the guest
  * can't use those events which user deny.
+ * It also checks that setting invalid filter ranges return the expected error.
  * This test runs only when KVM_CAP_ARM_PMU_V3, KVM_ARM_VCPU_PMU_V3_FILTER
  * is supported on the host.
  */
@@ -197,6 +198,39 @@ static void for_each_test(void)
 		run_test(t);
 }
 
+static void set_invalid_filter(struct vpmu_vm *vm, void *arg)
+{
+	struct kvm_pmu_event_filter invalid;
+	struct kvm_device_attr attr = {
+		.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr	= KVM_ARM_VCPU_PMU_V3_FILTER,
+		.addr	= (uint64_t)&invalid,
+	};
+	int ret = 0;
+
+	/* The max event number is (1 << 16), set a range large than it. */
+	invalid = __DEFINE_FILTER(BIT(15), BIT(15)+1, 0);
+	ret = __vcpu_ioctl(vm->vcpu, KVM_SET_DEVICE_ATTR, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter range "
+		    "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
+		    ret, errno);
+
+	ret = 0;
+
+	/* Set the Invalid action. */
+	invalid = __DEFINE_FILTER(0, 1, 3);
+	ret = __vcpu_ioctl(vm->vcpu, KVM_SET_DEVICE_ATTR, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter action "
+		    "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
+		    ret, errno);
+}
+
+static void test_invalid_filter(void)
+{
+	vpmu_vm = __create_vpmu_vm(guest_code, set_invalid_filter, NULL);
+	destroy_vpmu_vm(vpmu_vm);
+}
+
 static bool kvm_supports_pmu_event_filter(void)
 {
 	int r;
@@ -228,4 +262,6 @@ int main(void)
 	TEST_REQUIRE(host_pmu_supports_events());
 
 	for_each_test();
+
+	test_invalid_filter();
 }
-- 
2.40.1

