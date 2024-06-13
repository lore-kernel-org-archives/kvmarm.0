Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6622F13DDBA
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 08:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718267043; cv=none; b=JDNrYY7I1tvdmGdtKALTz6GkTKFypkqoNmKAiW6eeGRWGTEtt0VzYBIqHLvKpHzQ6ojVwQcqDQ1U1224KXEHWhupmEGTnJ1+Ci8ck+yxhtELZutl8/WBNtHVeJYp7K2flKmPmAYsmVKaCZ2j0kALhtqMZi1Hd1qzVDclamY2l3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718267043; c=relaxed/simple;
	bh=lvZJNz+i9EDaQCjhUC22E8ddQlH97BuhqNxoVVu5sHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=beA07lcOD/XzbRbnL5Aw9UzfKpvznZhVNaEhUjPWhTbrbzXTBSdsQGEH/Pn+kf1nJ4gnadtniycTu7qy8ESaG3ZjR07myGahPc3ogwS5HKlkZNurHaNJgGS8Ew8zNK2G+4BKU3xKPzMZmf5HZWscNQkovjrUlUkj5sOOjkVsY0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C8SM2elN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C8SM2elN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718267039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NaPbyJRxJ7+BuxaunDSaKOHKTF/69OqVmW3jjFNQASA=;
	b=C8SM2elNnKwTcwcpXBJNlADvtf28iwVBXiniH48cb5812D9y9knsYSzMWLFgLXdG18f8PY
	nY/CTq4RNCijl2aEFcQJe4ZwXSkC7wxPspeBjTVXM9jdXkuUFKcu4zg/wq1EO4KTOy6hes
	I3zw1plGhfR+E2++Xf/P2MZHJJrlOtQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-464-QHU8lVdbMei7qJ-e2UhoyA-1; Thu,
 13 Jun 2024 04:23:53 -0400
X-MC-Unique: QHU8lVdbMei7qJ-e2UhoyA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90AB019560B4;
	Thu, 13 Jun 2024 08:23:51 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 798A519560BF;
	Thu, 13 Jun 2024 08:23:49 +0000 (UTC)
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
Subject: [PATCH v9 0/3] KVM: selftests: aarch64: Introduce pmu_event_filter_test
Date: Thu, 13 Jun 2024 04:23:38 -0400
Message-Id: <20240613082345.132336-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The test is inspired by the pmu_event_filter_test which implemented by x86. On
the arm64 platform, there is the same ability to set the pmu_event_filter
through the KVM_ARM_VCPU_PMU_V3_FILTER attribute. So add the test for arm64.

The series first create the helper function which can be used
for the vpmu related tests. Then, it implement the test.

Changelog:
----------
v8->v9:
  - Rebased to latest kvm-arm/next.

v7->v8:
  - Rebased to kvm-arm/next.
  - Deleted the GIC layout related staff.
  - Fixed the checking logic in the kvm_pmu_support_events.

v6->v7:
  - Rebased to v6.9-rc3.

v5->v6:
  - Rebased to v6.9-rc1.
  - Collect RB.
  - Add multiple filter test.

v4->v5:
  - Rebased to v6.8-rc6.
  - Refactor the helper function, make it fine-grained and easy to be used.
  - Namimg improvements.
  - Use the kvm_device_attr_set() helper.
  - Make the test descriptor array readable and clean.
  - Delete the patch which moves the pmu related helper to vpmu.h.
  - Remove the kvm_supports_pmu_event_filter() function since nobody will run
  this on a old kernel.

v3->v4:
  - Rebased to the v6.8-rc2.

v2->v3:
  - Check the pmceid in guest code instead of pmu event count since different
  hardware may have different event count result, check pmceid makes it stable
  on different platform.                        [Eric]
  - Some typo fixed and commit message improved.

v1->v2:
  - Improve the commit message.                 [Eric]
  - Fix the bug in [enable|disable]_counter.    [Raghavendra & Marc]
  - Add the check if kvm has attr KVM_ARM_VCPU_PMU_V3_FILTER.
  - Add if host pmu support the test event throught pmceid0.
  - Split the test_invalid_filter() to another patch. [Eric]

Shaoqin Huang (3):
  KVM: selftests: aarch64: Add helper function for the vpmu vcpu
    creation
  KVM: selftests: aarch64: Introduce pmu_event_filter_test
  KVM: selftests: aarch64: Add invalid filter test in
    pmu_event_filter_test

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/pmu_event_filter_test.c       | 340 ++++++++++++++++++
 .../kvm/aarch64/vpmu_counter_access.c         |  32 +-
 .../selftests/kvm/include/aarch64/vpmu.h      |  28 ++
 4 files changed, 375 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vpmu.h

-- 
2.40.1

