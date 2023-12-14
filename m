Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4188E4B5AA
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 12:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SrWVm0htSzMnmP;
	Thu, 14 Dec 2023 20:14:24 +0800 (CST)
Received: from kwepemm000007.china.huawei.com (unknown [7.193.23.189])
	by mail.maildlp.com (Postfix) with ESMTPS id B818B1404D9;
	Thu, 14 Dec 2023 20:14:32 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 20:14:31 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>
CC: "moderated list:ARM SMMU DRIVERS" <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>,
	"wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: [bug report] GICv4.1: vSGI remains pending across the guest reset
Message-ID: <7e7f2c0c-448b-10a9-8929-4b8f4f6e2a32@huawei.com>
Date: Thu, 14 Dec 2023 20:13:57 +0800
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
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000007.china.huawei.com (7.193.23.189)

Hi list,

We have observed on GICv4.1 systems that, after a guest reset, the
secondary VCPU would receive an IPI_CPU_STOP accidently and failed to
come online eventually.

| Guest User-space
|
| reset (with a vSGI pending in the
| hardware) [0]
|
| disable the distributor (write 0
| into GICD_CTLR) [1]
|
| clear pending status (write 0 into
| GICR_ISPENDR0 for each RD) [2]
|
| disable the distributor (write 0
| into GICD_CTLR) [3]
|
| enable the distributor with ARE,
| Group1 and nASSGIreq [4]

The problem is that even if user-space tries to disable the distributor
and clear pending bits for all SGIs, we don't actually propogate it into
HW (we only record it via vgic_dist->{enabled, nassgireq} and
vgic_irq->pending_latch) and the vSGI remains pending across the guest
reset.

And when we're at [4], all vSGI's vgic_irq->hw are *true* and
vgic_v4_enable_vsgis() becomes a nop.. That's not good.

The following solution can solve the problem. Not sure if this is a good
solution.Sent out early for suggestions or solutions.

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c 
b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 89117ba2528a..3678ab33f5b9 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -374,6 +374,10 @@ static int vgic_v3_uaccess_write_pending(struct 
kvm_vcpu *vcpu,
              irq->pending_latch = true;
              vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
          } else {
+             if (irq->hw && vgic_irq_is_sgi(irq->intid))
+                 irq_set_irqchip_state(irq->host_irq,
+                              IRQCHIP_STATE_PENDING,
+                              false);
              irq->pending_latch = false;
              raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
          }

