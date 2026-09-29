Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78C850AC18
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 10:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678238; cv=none; b=PHWp0UHL3s0yKIjvxjBypbccxO7NcjMVVACpWEx5RG4TrXXwgpBwcrg/FaYwPeQ4ZE+KLWz8i9SRtx+NfcnZDLFosgZx9q99FHplpcjZ44CqRTwSR4jhEs5UbdhPh7x+zdVtzm78sY8c/UOWdc3dN9YG1YuC/AgAPYIN2sYc/a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678238; c=relaxed/simple;
	bh=69fvRkToTeX+F/KMnL03LHrqFoA/tWT4JJWe2Rr5SjE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXJphkZfbS1BCTWOXJf0wE80AR32PAB9AovzHBhFvbsuHgEt/VPrbKmdhOAlULozcZlitCP3ugTtkFehupyJASlczzxjXqsfe7NHUscTolEu2sOcwFCtC2ztp8lLVMngpinMtOM1YK0KYTEIMp8ibzgHE/4SEIOrIBUE8A3kQIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=I8GkUGEY; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="I8GkUGEY"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xOVL/ev52VgGnekwG/3m+mVjJWWVs31DVf2kAXdZSbk=;
	b=I8GkUGEYFz/IyJR89y3PpljGHROkV3uzvpo0o85CwNU0uwy8xop+8WpfuHAF56cropz3WZvs/
	w+Z9RJ9CHS9wdYpPEGDYsQbmtHhai4AziCPZ1s/ZPkiaNGqykONORyg1DtzLXixbCgt6AyPJX/J
	ukSnbe7QgnLI/KO8XM6rN1U=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hvDnr2Qwpz1T4Fq;
	Tue, 29 Sep 2026 18:25:04 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 6CAA34058E;
	Tue, 29 Sep 2026 18:37:04 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 18:37:03 +0800
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
Subject: [PATCH v5 10/15] KVM: Add kvm_arch_dirty_ring_size_updated() hook
Date: Tue, 29 Sep 2026 18:36:50 +0800
Message-ID: <20260929103655.85107-11-zhengtian10@huawei.com>
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

Draining a CPU-side dirty log buffer into the dirty ring requires
sizing that buffer against the ring, which reserves room for a full
flush. Add a kvm_arch_dirty_ring_size_updated() hook called right
after kvm->dirty_ring_size is recorded, with a __weak no-op default.

arm64 will use it to pin its HDBSS buffer size in dirty-ring mode.

Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 include/linux/kvm_dirty_ring.h | 1 +
 virt/kvm/dirty_ring.c          | 4 ++++
 virt/kvm/kvm_main.c            | 1 +
 3 files changed, 6 insertions(+)

diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index eb10d87adf7d..c2b922791530 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -73,6 +73,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */

 int kvm_cpu_dirty_log_size(struct kvm *kvm);
+void kvm_arch_dirty_ring_size_updated(struct kvm *kvm);
 bool kvm_use_dirty_bitmap(struct kvm *kvm);
 bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm);
 u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm);
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 572b854edf74..784f53c95b54 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -16,6 +16,10 @@ int __weak kvm_cpu_dirty_log_size(struct kvm *kvm)
 	return 0;
 }

+void __weak kvm_arch_dirty_ring_size_updated(struct kvm *kvm)
+{
+}
+
 u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm)
 {
 	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size(kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 85f42289748d..d109062f6a1c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5011,6 +5011,7 @@ static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
 		r = -EINVAL;
 	} else {
 		kvm->dirty_ring_size = size;
+		kvm_arch_dirty_ring_size_updated(kvm);
 		r = 0;
 	}

--
2.43.0

