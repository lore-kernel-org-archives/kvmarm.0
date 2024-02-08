Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642C8763E1;
	Thu,  8 Feb 2024 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707405655; cv=none; b=OLJgnqebIVjILqDX/eXiwhN9xo9yamxu8KDc5iS1OdZFjpudsF2mo1jCWttwI36V8KMqzJRMNFhHGLqWo4/H/nyAIVPt4wTVhzNGile1RlRQ6yAkmfsu2Ds2mb5GQ9i8raJsxkSCpjgpBhlcqN6JMvzGfsIPOAQtnwF8Tw4CzFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707405655; c=relaxed/simple;
	bh=BVfX9FjlV1T0IW6iWZ+w4C3pt5RI5P/OK6hVJqZyOOY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pDeAEy/BGXzognFW8oUDink0fVE132UAPSdz9O5xY7+GBOtHRgu77W/s8bZKxd/T8qzLxf0SDv1MISESGvAzNhZepdr4QESPkhP77QG5Pe5SpIXI0t8mRtHZHB7aaYKo7aQkwbIMHJfSXF3kf/Kx11FwFYTi0fBLr2UTwEyef/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW0vk73tSz6JB4R;
	Thu,  8 Feb 2024 23:17:06 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id C8BF9140B2F;
	Thu,  8 Feb 2024 23:20:49 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.202.227.28) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 15:20:43 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
CC: <kevin.tian@intel.com>, <jgg@ziepe.ca>, <alex.williamson@redhat.com>,
	<maz@kernel.org>, <oliver.upton@linux.dev>, <will@kernel.org>,
	<robin.murphy@arm.com>, <jean-philippe@linaro.org>,
	<jonathan.cameron@huawei.com>
Subject: [RFC PATCH v2 1/7] KVM: Add generic infrastructure to support pinned VMIDs
Date: Thu, 8 Feb 2024 15:18:31 +0000
Message-ID: <20240208151837.35068-2-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

Provide generic helper functions to get/put pinned VMIDs if the arch
supports it.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 include/linux/kvm_host.h | 18 ++++++++++++++++++
 virt/kvm/Kconfig         |  3 +++
 virt/kvm/kvm_main.c      | 23 +++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..610e239bea46 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2311,6 +2311,24 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+#ifdef CONFIG_HAVE_KVM_PINNED_VMID
+int kvm_arch_pinned_vmid_get(struct kvm *kvm);
+void kvm_arch_pinned_vmid_put(struct kvm *kvm);
+#endif
+
+#ifdef CONFIG_HAVE_KVM_PINNED_VMID
+int kvm_pinned_vmid_get(struct kvm *kvm);
+void kvm_pinned_vmid_put(struct kvm *kvm);
+#else
+static inline int kvm_pinned_vmid_get(struct kvm *kvm)
+{
+	return -EINVAL;
+}
+
+static inline void kvm_pinned_vmid_put(struct kvm *kvm)
+{
+}
+#endif
 /*
  * If more than one page is being (un)accounted, @virt must be the address of
  * the first page of a block of pages what were allocated together (i.e
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 184dab4ee871..a3052c8e3ac4 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -108,3 +108,6 @@ config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_PRIVATE_MEM
        bool
+
+config HAVE_KVM_PINNED_VMID
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 10bfc88a69f7..f84d6da5f464 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3918,6 +3918,29 @@ bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
 
+#ifdef CONFIG_HAVE_KVM_PINNED_VMID
+int kvm_pinned_vmid_get(struct kvm *kvm)
+{
+	int ret;
+
+	if (!kvm_get_kvm_safe(kvm))
+		return -ENOENT;
+	ret  = kvm_arch_pinned_vmid_get(kvm);
+	if (ret < 0)
+		kvm_put_kvm(kvm);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_pinned_vmid_get);
+
+void kvm_pinned_vmid_put(struct kvm *kvm)
+{
+	kvm_arch_pinned_vmid_put(kvm);
+	kvm_put_kvm(kvm);
+}
+EXPORT_SYMBOL_GPL(kvm_pinned_vmid_put);
+#endif
+
 #ifndef CONFIG_S390
 /*
  * Kick a sleeping VCPU, or a guest VCPU in guest mode, into host kernel mode.
-- 
2.34.1

