Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AE751B192
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 10:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678250; cv=none; b=AV4VOvm8/Ce3XiUa4zQJ/BqZbqeA45IkaEnqKuHd4iVSsUs5Ix0GO1JW0mnw1IxLh3RDJPaYQNKWwm7UBaNuPtn0fTQ8kjFlgQ2/sbZTUOcvkXOMdxlCGkn1WnSyGEZKaVjmY/8y7UB2PjF2gsj59jPRjHQ0e3vud3SxzM7Vzlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678250; c=relaxed/simple;
	bh=+5LXgvRrHafgY1U80BTcKmqn+Tr3cpw3rQZZ4XzqF4w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LRKF3XiGqfv7obSC6Muv4M50GueHdVw67pZcZe9Iqcb0T7lzWLbwStIBlI8qRFW8WMoQl8G51/E9ztg23h1t4NU+wMZdS2S1r6wExyiKls9vG/ZD3WACA9mNg/Em7AoOrxGEQmp7Xt8twXnBraITQABU2fuAmVSC5unee7RydBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=DjC2iA7j; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="DjC2iA7j"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZJAd5Fzr/+97dvVwRiv6inP1iXx4xlncs5YPyHz47Yk=;
	b=DjC2iA7jJ8wi304eZdQG3npFe8quE4JO6ISTERGuGDtYPaStoSDqJEpUdOWC19TIwG5K6jiDI
	J+VCUy3ZoWOviqJNuKaX7eBrnRTslCCV2FfgHFu7F0F9rEmY2RMBrXtPxn6stnJPR8EYfi1dwNP
	Sv/JqNUA99Zbx5pMtrTL8Zk=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hvDnj3YJBz1K9Ck;
	Tue, 29 Sep 2026 18:24:57 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id BE9064055B;
	Tue, 29 Sep 2026 18:37:06 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 18:37:05 +0800
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
Subject: [PATCH v5 13/15] KVM: arm64: Add HDBSS buffer size ioctl for dirty-bitmap mode
Date: Tue, 29 Sep 2026 18:36:53 +0800
Message-ID: <20260929103655.85107-14-zhengtian10@huawei.com>
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

In dirty-bitmap mode, a larger HDBSS buffer lets the guest dirty more
pages between VM exits, at the cost of memory. The default of one page
per vCPU is a reasonable starting point, so allow userspace to opt
into a larger buffer via KVM_CAP_ARM_HDBSS_BUFFER_SIZE.

The size is specified in bytes through KVM_ENABLE_CAP and must be a
power of two in [PAGE_SIZE, SZ_2M]: the upper bound is the largest
HDBSSBR_EL2.SZ encoding, and the power-of-two requirement matches the
buddy allocator. It must be set before any vCPU is created: -EINVAL
after vCPUs exist, -EBUSY if already set.

The capability is rejected in dirty-ring mode, where the size is
pinned by kvm_arch_dirty_ring_size_updated().

KVM_CHECK_EXTENSION returns the configured size for a VM, or SZ_2M
when queried globally with a NULL kvm.

Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/kvm/arm.c     | 34 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h |  1 +
 2 files changed, 35 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5a7046acb62e..eadbf3a88d31 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -19,6 +19,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
+#include <linux/log2.h>
 #include <linux/sched/stat.h>
 #include <linux/psci.h>
 #include <trace/events/kvm.h>
@@ -203,6 +204,31 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_EXIT_SEA, &kvm->arch.flags);
 		break;
+	case KVM_CAP_ARM_HDBSS_BUFFER_SIZE: {
+		u64 size = cap->args[0];
+
+		if (!system_supports_hdbss())
+			break;
+		if (kvm->dirty_ring_size)
+			break;
+		if (size < KVM_ARM_HDBSS_DEFAULT_SIZE ||
+		    size > KVM_ARM_HDBSS_MAX_SIZE)
+			break;
+		if (!is_power_of_2(size))
+			break;
+
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus) {
+			r = -EINVAL;
+		} else if (kvm->arch.hdbss_buffer_size) {
+			r = -EBUSY;
+		} else {
+			kvm->arch.hdbss_buffer_size = size;
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		break;
+	}
 	default:
 		break;
 	}
@@ -500,6 +526,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		else
 			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
 		break;
+	case KVM_CAP_ARM_HDBSS_BUFFER_SIZE:
+		if (!system_supports_hdbss())
+			r = 0;
+		else if (kvm)
+			r = kvm->arch.hdbss_buffer_size ?: KVM_ARM_HDBSS_DEFAULT_SIZE;
+		else
+			r = KVM_ARM_HDBSS_MAX_SIZE;
+		break;
 	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
 		r = kvm_supported_block_sizes();
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac2d77d14963..59eb211494e4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -999,6 +999,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_HPAGE_2G 249
 #define KVM_CAP_PPC_COMPAT_CAPS 250
 #define KVM_CAP_ARM_PMU_V3_STRICT 251
+#define KVM_CAP_ARM_HDBSS_BUFFER_SIZE 252

 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
--
2.43.0

