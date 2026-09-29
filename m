Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB7D51AFFA
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 10:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678248; cv=none; b=q+PHLEvPefGocUzveG2r3bqjscI8bozQaxjfh4EtI10kv+/EGKVzP8ySm5fuKGyUCCqZGJ8QeYxqyWlXUZ7E1gewJ/gZ6BYpVnI6kThq+LNTkFR62/1KiasMz4Klz4FWLe/e1KN4MZpebW+llwah5PLsZkIamz00X4V3Xk/A3gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678248; c=relaxed/simple;
	bh=/34ynkesFSAcSxO89K8xVk+DM9LauRzHE6wmn2UCaSc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PsBIMDTK2s1g9d6oRJtmtG2odmihVebUTZubix50GmAHHu38noKN/yfjYda7v/p6JCw8lpwD19qdLWXQvHyIgbarbiKY9Gbk65TVOzsIqxuLFXLkO38rmVNx+K78RQ0ouDJ4rzV2BwMau+5aUnYiptuJHOmE3xpppOhfR2e2pk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=HXEyhcQi; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="HXEyhcQi"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4x36drenHC31a65AUAmISM+E18V5XgYGEXDL6/a05K8=;
	b=HXEyhcQipW8cTovkTLfbN3Ra9WRx0WOhjMNGAo+9/HNiZzbp0qFABbhzNayLfuwRX/maeiISE
	hKwzDJSGVwGZdO8X8NrCCYqD7pZqTX2aOsl7blLNDtukSOaeGInylpquqBM4pTqoDgXBPeVLecl
	u01kqFu3Yu1zWnO6EEvtOkU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hvDnh6V19zmVCD;
	Tue, 29 Sep 2026 18:24:56 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 34E964048B;
	Tue, 29 Sep 2026 18:37:05 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 18:37:04 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<zhengtian10@huawei.com>, <leo.bras@arm.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<yangjinqian1@huawei.com>, <caijian11@h-partners.com>,
	<liuyonglong@huawei.com>, <tangchengchang@huawei.com>,
	<yezhenyu2@huawei.com>, <yubihong@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>,
	<mark.rutland@arm.com>, <seanjc@google.com>, <rdunlap@infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<skhan@linuxfoundation.org>
Subject: [PATCH v5 11/15] KVM: arm64: Reserve dirty ring space for the HDBSS buffer
Date: Tue, 29 Sep 2026 18:36:51 +0800
Message-ID: <20260929103655.85107-12-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260929103655.85107-1-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)

The dirty ring reserves room for CPU-side dirty buffers via
kvm_cpu_dirty_log_size(). Report the HDBSS buffer entry count
through it, so a full buffer flush always fits in the ring.

Pin the HDBSS buffer size to PAGE_SIZE when dirty-ring is enabled,
via kvm_arch_dirty_ring_size_updated(): a larger buffer only
shrinks the soft_limit and forces more frequent userspace drains.

Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/kvm/arm.c | 8 ++++++++
 arch/arm64/kvm/mmu.c | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9d7bdece149a..5a7046acb62e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -215,6 +215,14 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }

+void kvm_arch_dirty_ring_size_updated(struct kvm *kvm)
+{
+	if (!system_supports_hdbss())
+		return;
+
+	kvm->arch.hdbss_buffer_size = KVM_ARM_HDBSS_DEFAULT_SIZE;
+}
+
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7bf82d65041c..c1e09ba98d48 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2841,3 +2841,11 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)

 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+int kvm_cpu_dirty_log_size(struct kvm *kvm)
+{
+	if (!system_supports_hdbss())
+		return 0;
+
+	return kvm_hdbss_buffer_size(kvm) / sizeof(u64);
+}
--
2.43.0

