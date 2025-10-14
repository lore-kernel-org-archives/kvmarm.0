Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9F52FAC0E
	for <kvmarm@lists.linux.dev>; Tue, 14 Oct 2025 14:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760453147; cv=none; b=rIYXxS6kK/cI/17j0+13w5mjk88jPidpYrfg4BYpO7ZcDLkQ9XPU/GGDnZ0MkqBZmR4Ooy+RYnFWLVSYys7pKR4tpQ8yi53F1WY5rFEg05F4XLpYttvLm0KabB1SfZIGnH49k4DSJZv13lKI0nSPq9EpB2L3d0qlhJ0A31kPtYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760453147; c=relaxed/simple;
	bh=lZ6B11CxW1q7O+cXORcRUdlfHrH0UkzWMMy7VXqgN2Q=;
	h=From:Subject:To:CC:Message-ID:Date:MIME-Version:Content-Type; b=sU+vntMnraVEZlw5bb0BxfRhV3p45ZCI8wzgszNtyw6Eff89zaxxsBYW77Yvq9pLDEV7U1N7AijZj1leAugpw6jCneuIp0JYpnByH9TyLBiAs200xCcbPin7MGBWfpW0t1bGLZb1+3DyvryVMAYCpvbnApU8g3MxG4ryrBi39ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=dro/0FNx; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="dro/0FNx"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aW0vtNY+80ANt8g8vBvYcKAPWFdtwqr1pnE2CY5Stqs=;
	b=dro/0FNxZxUiay6DtOjZwbwDtlcfnS0Fs+LJ/+ezGGoyQ3bZYjhpRO1l7q8uIfrpgGDlB0flo
	seuAzsXwSbYnxP+sCAr8CSTYCdkLPb6FgEMF/cmrKjs7olLxbMlAR1KTENuyDdBCgd95HwIZTsb
	VL4GVyWC3PRBi0a3NFj1k18=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4cmH7f56K8zRhR7;
	Tue, 14 Oct 2025 22:45:18 +0800 (CST)
Received: from kwepemh200008.china.huawei.com (unknown [7.202.181.115])
	by mail.maildlp.com (Postfix) with ESMTPS id AD6821402DA;
	Tue, 14 Oct 2025 22:45:38 +0800 (CST)
Received: from [10.174.176.125] (10.174.176.125) by
 kwepemh200008.china.huawei.com (7.202.181.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 22:45:37 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
Subject: [Question] Received vtimer interrupt but ISTATUS is 0
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Joey
 Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
CC: "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
	<linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE FOR
 ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>, open list
	<linux-kernel@vger.kernel.org>, "wanghaibin.wang@huawei.com"
	<wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <14b30b59-12bb-fc69-8447-aae86fcafcd1@huawei.com>
Date: Tue, 14 Oct 2025 22:45:37 +0800
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
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemh200008.china.huawei.com (7.202.181.115)

Hi all,

I'm having a very strange problem that can be simplified to a vtimer 
interrupt being received but ISTATUS is 0. Why dose this happen? 
According to analysis, it may be the timer condition is met and the 
interrupt is generated. Maybe some actions(cancel timer?) are done in 
the VM, ISTATUS becomes 0 and he hardware needs to clear the interrupt. 
But the clear command is sent too slowly, the OS has already read the 
ICC_IAR_EL1. So hypervisor executed kvm_arch_timer_handler but ISTATUS is 0.
The code flow is as follows:
kvm_arch_timer_handler
     ->if (kvm_timer_should_fire)
         ->the value of SYS_CNTV_CTL is 0b001(ISTATUS=0,IMASK=0,ENABLE=1)
     ->return IRQ_HANDLED

Because ISTATUS is 0, kvm_timer_update_irq will not be executed to 
inject this interrupt into the VM. Since EOImode is 1 and the vtimer 
interrupt has IRQD_FORWARDED_TO_VCPU flag, hypervisor will not write 
ICC_DIR_EL1 to deactivate the interrupt. This interrupt remains in 
active state, blocking subsequent interrupt from being process. 
Fortunately, in kvm_timer_vcpu_load it will be determined again whether 
an interrupt needs to be injected into the VM. But the delay will 
definitely increase.

What I want to discuss is the solution to this problem. My solution is 
to add a deactivation action:
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index dbd74e4885e2..46baba531d51 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -228,8 +228,13 @@ static irqreturn_t kvm_arch_timer_handler(int irq, 
void *dev_id)
         else
                 ctx = map.direct_ptimer;

-       if (kvm_timer_should_fire(ctx))
+       if (kvm_timer_should_fire(ctx)) {
                 kvm_timer_update_irq(vcpu, true, ctx);
+       } else {
+               struct vgic_irq *irq;
+               irq = vgic_get_vcpu_irq(vcpu, timer_irq(timer_ctx));
+               gic_write_dir(irq->hwintid);
+       }

         if (userspace_irqchip(vcpu->kvm) &&
             !static_branch_unlikely(&has_gic_active_state))

If you have any new ideas or other solutions to this problem, please let 
me know.

Looking forward to your reply.

Kunkun Jiang



