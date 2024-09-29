Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656CB2B9BB
	for <kvmarm@lists.linux.dev>; Sun, 29 Sep 2024 07:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727594340; cv=none; b=srC/BC0NgO6Ry7J4LZ1b4zBS+qdDu/SHgIdCykSIEEKNlW7i2ee88SUU2t0A6POaWYk7aa8hFy96cti7dHqUn/uCNEVUnQZnanbd7IhQM/k6aYIRXBd0VZESI77ySjpE1jOcOGynkzv8vHqBra5KNk9sx7Bg5lDXdOUBu2ayCbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727594340; c=relaxed/simple;
	bh=xCh/nT6pWp7vQFR1lMkYtNId9TxqQXyfjWcSf0avDFc=;
	h=From:Subject:To:CC:Message-ID:Date:MIME-Version:Content-Type; b=QeOEOxyUQ/5FoC7cUSVQJlaiX8sbzr2mLcTln4z0WlHhwKCcLKFYo70WKBNn2oqBqlrxcrW33uYYRRdFv6O61l3c9Pas9eug84gf+30vb6sF1mSBV0EVOpq4SwtVe9tHgifgWx3WRcynQdzsdbuufEvOL1AGWga444v0+6Y+HF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XGb7R5P6Wz1HJ7v;
	Sun, 29 Sep 2024 15:14:59 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 6F7D814011B;
	Sun, 29 Sep 2024 15:18:54 +0800 (CST)
Received: from [10.174.176.125] (10.174.176.125) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 29 Sep 2024 15:18:53 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
Subject: [bug report] KVM: arm64: vgic-v4: Occasionally issue VMOVP to an
 unmapped VPE on GICv4.1
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, <tangnianyao@huawei.com>,
	<wangzhou1@hisilicon.com>
Message-ID: <c182ece6-2ba0-ce4f-3404-dba7a3ab6c52@huawei.com>
Date: Sun, 29 Sep 2024 15:18:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi all,

I found a problem with occasionally issuing VMOVP to an unmapped VPE on 
GICv4.1. In my test environment, operating an unmapped VPE will generate 
RAS, so I found this problem. The detailed analysis is as follows.

The vgic_v4_teardown() will be executed when VM is destroyed to free the 
GICv4 data structures. The code is as follows:
> /**
>  * vgic_v4_teardown - Free the GICv4 data structures
>  * @kvm:        Pointer to the VM being destroyed
>  */
> void vgic_v4_teardown(struct kvm *kvm)
> {
>         struct its_vm *its_vm = &kvm->arch.vgic.its_vm;
>         int i;
> 
>         lockdep_assert_held(&kvm->arch.config_lock);
> 
>         if (!its_vm->vpes)
>                 return;
> 
>         for (i = 0; i < its_vm->nr_vpes; i++) {
>                 struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, i);
>                 int irq = its_vm->vpes[i]->irq;
> 
>                 irq_clear_status_flags(irq, DB_IRQ_FLAGS);
>                 free_irq(irq, vcpu);
>         }
> 
>         its_free_vcpu_irqs(its_vm);
>         kfree(its_vm->vpes);
>         its_vm->nr_vpes = 0;
>         its_vm->vpes = NULL;
> }

[1] In irq_clear_status_flags(irq, DB_IRQ_FLAGS), the status flags of a 
doorbell are cleared. DB_IRQ_FLAGS contains IRQ_NO_BALANCING. So after 
this,the irqbalance.service can schedule the doorbell.
[2] In free_irq(), the VPE is unmaped.
[3] In its_free_vcpu_irqs(its_vm), unregister_irq_proc() is called to 
delete the contents in /proc/irq/xx/ of the doorbell.

For VPEs in large-scale VM, there is a centain time window between [2] 
and [3]. The irqbalance.service got a chance to schedule the doorbell. 
Therefore, the VMOVP is issued to an unmapped VPE.

I tried not clearing IRQ_NO_BALANCING and the problem was solved. But 
it's not clear if there's any other problem with doing so.

Thanks,
Kunkun Jiang




