Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5361E485;
	Thu,  8 Feb 2024 15:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707405671; cv=none; b=CyXwQF0rLdKVmYgtvrgJu8XTLi6fOpG+9pyGNMEF4NBgVrbLlCmahmrUOEczqM4UJxX8lHREYxga8ED3OIkdoS6fmO/5QTxRN0ATBQPA0X1i33oDlFDExJby7OGAf6DcUOWA8OvAw18R6KTHAafcNdslWLiZzo+kIBzR1ghx4Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707405671; c=relaxed/simple;
	bh=o0oKlt2zyLm0sk+tRl7QZ1Rwlqzrtwuvy0AV4mwLL4o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jSIK9iFo5GbnAVw/xjtVcsLlEFaaFym2eVFcmc61+xoCCumYaP8j+JEzyOORRELIIti2j5HrBk61/H3MJY+XiX0j88yWdXb57SgOKXtdMstmqNwlH/zW/9Mp9M+VAcIPunWWknm0usF0dk0wZEO0YpTvS7o+BB0aPGno6FFCdrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW0wV03qPz6K5dp;
	Thu,  8 Feb 2024 23:17:46 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id E75E1140B73;
	Thu,  8 Feb 2024 23:21:07 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.202.227.28) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 15:21:01 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
CC: <kevin.tian@intel.com>, <jgg@ziepe.ca>, <alex.williamson@redhat.com>,
	<maz@kernel.org>, <oliver.upton@linux.dev>, <will@kernel.org>,
	<robin.murphy@arm.com>, <jean-philippe@linaro.org>,
	<jonathan.cameron@huawei.com>
Subject: [RFC PATCH v2 3/7] KVM: arm64: Add interfaces for pinned VMID support
Date: Thu, 8 Feb 2024 15:18:33 +0000
Message-ID: <20240208151837.35068-4-shameerali.kolothum.thodi@huawei.com>
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

Provide interfaces to get/put pinned VMIDs from KVM VMID allocator.
This will be used by SMMUv3 driver in subsequent patch.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/kvm/Kconfig |  1 +
 arch/arm64/kvm/arm.c   | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 6c3c8ca73e7f..29ff79f112ba 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -40,6 +40,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select XARRAY_MULTI
+	select HAVE_KVM_PINNED_VMID
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..ed905da6e9ab 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -711,6 +711,20 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+int kvm_arch_pinned_vmid_get(struct kvm *kvm)
+{
+	int vmid;
+
+	vmid = kvm_arm_pinned_vmid_get(&kvm->arch.mmu.vmid);
+
+	return (vmid == 0) ? -EINVAL : vmid;
+}
+
+void kvm_arch_pinned_vmid_put(struct kvm *kvm)
+{
+	kvm_arm_pinned_vmid_put(&kvm->arch.mmu.vmid);
+}
+
 bool kvm_arch_intc_initialized(struct kvm *kvm)
 {
 	return vgic_initialized(kvm);
-- 
2.34.1

