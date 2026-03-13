Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8877221F2F
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 07:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773385788; cv=none; b=bgfs7RclcQgxBMQiTRDSLj2AYDl98um/nF3xyGbYMbnFFf/NbIGbf5nUi4sP21ZKkkkLxo/EJcvWI7NX6pTfMrBKSwFe/ZHPfSMJ5D6aVj+btM6QYUcXz9NYyDVn6xJ+FMaCp5Stt86Tt7KjAat46idP5an37GHCdHAGdg8zXUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773385788; c=relaxed/simple;
	bh=3xVk4mmj2wCCsXZ43LAreS377CxuwmAl2eqzX3MGy6c=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:Content-Type; b=cnIBfE0CEPtlCXDItLax04ozPhzzkjd3VJzwb+Ipbbx3EzUQ82EE7X9Vr9wNYB2SnZs63DQKttg0JitVbFr7qCeBVvnCj8l8Nk4u4t6r315xySORIxJ9fboF1ID4RPOfRmuk3xuVaxiPxktqtAlBt7uH7qIwvtNXXnhyw7rbgf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fXFq3698Vz1K9C2;
	Fri, 13 Mar 2026 15:04:47 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F91740363;
	Fri, 13 Mar 2026 15:09:42 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Mar 2026 15:09:41 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Mar 2026 15:09:41 +0800
Message-ID: <704b6126-f1ad-4d8a-5709-a12e4c8c79ca@hisilicon.com>
Date: Fri, 13 Mar 2026 15:09:40 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
From: Zhou Wang <wangzhou1@hisilicon.com>
Subject: Question about ARM KVM stage2 contiguous bit support for contiguous
 hugetlb
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
CC: <tangnianyao@huawei.com>, jiangkunkun <jiangkunkun@huawei.com>, "xuwei
 (O)" <xuwei5@huawei.com>, "Zengtao (B)" <prime.zeng@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200004.china.huawei.com (7.202.195.237)

Hi,

Current KVM stage2 supports contiguous hugetlb, e.g.4KB basic page size, 64KB hugetlb.
However, contiguous bit is not set in PTE, so there is no hint for hardware to create one
TLB for a contiguous huge page.

Seems to support this feature. We should do:

1. In user_mem_abort, do not force to do PTE map for CONT_PMD_SHIFT/CONT_PTE_SHIFT,
   just map all contiguous pages at one time.

2. Add contiguous bit in above process.

3. Modify the permission fault related code. As in the first point, we change vma_pagesize
   actually, vma_pagesize will be not equal with fault_granule, we will fail to enter into
   kvm_pgtable_stage2_relax_perms.

4. The split of contiguous hugetlb should be considered. We need remove all related contiguous
   bits, once one PTE has been changed.

Note sure if I miss any point to implement this feature. And do we have any plan to support this?

Best,
Zhou
