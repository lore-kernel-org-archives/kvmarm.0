Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D671CE6E3
	for <kvmarm@lists.linux.dev>; Wed, 21 Aug 2024 09:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724233905; cv=none; b=e4JsDsfVhDDpHg3VUhBv/CrGQtsrs9Hzgo3VIZVANQrmYV1g2POFwCiIGZDzSNuLLQsIX5PAa+bZPoFrN1Ur8pf8HYxTTnSeHh7j/lHHwhYw5CvBWN72h8tgUYij6pRcE1Eo/mqG57OYvwZ67LDTx1ps5o4sn1Sc9V0iBv77P/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724233905; c=relaxed/simple;
	bh=bmfvD/wKQE7hV1kUr3oVrQytakrPuOmhdrBTE/biIbI=;
	h=From:Subject:To:CC:Message-ID:Date:MIME-Version:Content-Type; b=qLuzzW80JtOHrzU7SQkaNwv4PefPyeynqQzs0MlarDPotyisC96SMLBM9MLdIk5ujZO57zOAmJ2+0AXL++neqfWLHmPDQ8lMyUWMridEv+9cAF7D3iqkhjFmDpa4Uos2qyCELjUMwxWh4luHrGwN2UWRIxtgs+AU5FXxIw5b1iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WphLp5PhMz20l5l;
	Wed, 21 Aug 2024 17:46:58 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D7DC1400CA;
	Wed, 21 Aug 2024 17:51:40 +0800 (CST)
Received: from [10.174.176.125] (10.174.176.125) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 17:51:39 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
Subject: [bug report] GICv4.1: multiple vpus execute vgic_v4_load at the same
 time will greatly increase the time consumption
To: Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
CC: "open list:IRQ SUBSYSTEM" <linux-kernel@vger.kernel.org>, "moderated
 list:ARM SMMU DRIVERS" <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, "wanghaibin.wang@huawei.com"
	<wanghaibin.wang@huawei.com>, <nizhiqiang1@huawei.com>,
	"tangnianyao@huawei.com" <tangnianyao@huawei.com>, <wangzhou1@hisilicon.com>
Message-ID: <a7fc58e4-64c2-77fc-c1dc-f5eb78dbbb01@huawei.com>
Date: Wed, 21 Aug 2024 17:51:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi all,

Recently I discovered a problem about GICv4.1, the scenario is as follows:
1. Enable GICv4.1
2. Create multiple VMs.For example, 50 VMs(4U8G)
3. The business running in VMs has a frequent mmio access and need to exit
   to qemu for processing.
4. Or modify the kvm code so that wfi must trap to kvm
5. Then the utilization of pcpu where the vcpu is located will be 100%,and
   basically all in sys.
6. This problem does not exist in GICv3.

According to analysis, this problem is due to the execution of vgic_v4_load.
vcpu_load or kvm_sched_in
     kvm_arch_vcpu_load
     ...
         vgic_v4_load
             irq_set_affinity
             ...
                 irq_do_set_affinity
                     raw_spin_lock(&tmp_mask_lock)
                     chip->irq_set_affinity
                     ...
                       its_vpe_set_affinity

The tmp_mask_lock is the key. This is a global lock. I don't quite 
understand
why tmp_mask_lock is needed here. I think there are two possible 
solutions here:
1. Remove this tmp_mask_lock
2. Modify the gicv4 driver,do not perfrom VMOVP via irq_set_affinity.

Everyone is welcome to discuss.

Thanks,
Kunkun Jiang

