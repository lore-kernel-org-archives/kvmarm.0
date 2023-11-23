Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4163A11738
	for <kvmarm@lists.linux.dev>; Thu, 23 Nov 2023 06:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c0CxIWJ3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700721491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nWktWqMM4G/wXCLhrelXgnsFw3mwZMTHYGnEyrCPhDA=;
	b=c0CxIWJ3ZCV3HGXXTGLc/IFrLh8fqhw63Dr/XUsd5K1NDJ0pjYpVr0QAtY6YbQSwkWmWWV
	tbSVZzql33+wWXMQcdCQO0q8ETNjnLarf7M3eq7Es3YUYAXisAbjK5BrgcDBmLe1kJeWIr
	WVso71Pa+h3XhROSWabxp5EdSX/Kzno=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-AC3FAiN5OAO27fE9bMEl8A-1; Thu, 23 Nov 2023 01:38:06 -0500
X-MC-Unique: AC3FAiN5OAO27fE9bMEl8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B813899EC2;
	Thu, 23 Nov 2023 06:38:06 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F04E21C060AE;
	Thu, 23 Nov 2023 06:38:05 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	James Morse <james.morse@arm.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v1 0/3] KVM: selftests: aarch64: Introduce pmu_event_filter_test
Date: Thu, 23 Nov 2023 01:37:42 -0500
Message-Id: <20231123063750.2176250-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

The test is inspired by the pmu_event_filter_test which implemented by x86. On
the arm64 platform, there is the same ability to set the pmu_event_filter
through the KVM_ARM_VCPU_PMU_V3_FILTER attribute. So add the test for arm64.

The series first move some pmu common code from vpmu_counter_access to lib/
which can be used by pmu_event_filter_test. Then implements the test itself.

Shaoqin Huang (3):
  KVM: selftests: aarch64: Make the [create|destroy]_vpmu_vm() can be
    reused
  KVM: selftests: aarch64: Move the pmu helper function into lib/
  KVM: selftests: aarch64: Introduce pmu_event_filter_test

 tools/testing/selftests/kvm/Makefile          |   2 +
 .../kvm/aarch64/pmu_event_filter_test.c       | 227 ++++++++++++++++++
 .../kvm/aarch64/vpmu_counter_access.c         | 218 ++---------------
 .../selftests/kvm/include/aarch64/vpmu.h      | 139 +++++++++++
 .../testing/selftests/kvm/lib/aarch64/vpmu.c  |  74 ++++++
 5 files changed, 466 insertions(+), 194 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vpmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vpmu.c

-- 
2.40.1

