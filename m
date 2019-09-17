Return-Path: <SRS0=qhXz=XM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28E7C4CEC9
	for <kvmarm@archiver.kernel.org>; Tue, 17 Sep 2019 08:35:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 721BA214AF
	for <kvmarm@archiver.kernel.org>; Tue, 17 Sep 2019 08:35:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 721BA214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E65714A669;
	Tue, 17 Sep 2019 04:35:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bcW0U-vqxmjk; Tue, 17 Sep 2019 04:35:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C119E4A667;
	Tue, 17 Sep 2019 04:35:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF95C4A665
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Sep 2019 04:35:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yFCQCWbx76EQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Sep 2019 04:35:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 885A54A5E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Sep 2019 04:35:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2856928;
 Tue, 17 Sep 2019 01:35:42 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 725C53F575; Tue, 17 Sep 2019 01:35:41 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Move the GICv4 residency flow to be
 driven by vcpu_load/put
To: Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20190903155747.219802-1-maz@kernel.org>
 <5ab75fec-6014-e3b4-92a3-63d5015814c1@huawei.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <07ddb304-9a7a-64a3-386a-96eea4516346@kernel.org>
Date: Tue, 17 Sep 2019 09:35:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5ab75fec-6014-e3b4-92a3-63d5015814c1@huawei.com>
Content-Language: en-US
Cc: Andre Przywara <Andre.Przywara@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Zenghui,

On 17/09/2019 09:10, Zenghui Yu wrote:
> Hi Marc,
> 
> I've run this patch on my box and got the following messages:
> 
> ---8<
> 
> [ 2258.490030] BUG: sleeping function called from invalid context at 
> kernel/irq/manage.c:138
> [ 2258.490034] in_atomic(): 1, irqs_disabled(): 0, pid: 59278, name: CPU 
> 0/KVM
> [ 2258.490039] CPU: 32 PID: 59278 Comm: CPU 0/KVM Kdump: loaded Tainted: 
> G        W         5.3.0+ #26
> [ 2258.490041] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58 
> 10/29/2018
> [ 2258.490043] Call trace:
> [ 2258.490056]  dump_backtrace+0x0/0x188
> [ 2258.490060]  show_stack+0x24/0x30
> [ 2258.490066]  dump_stack+0xb0/0xf4
> [ 2258.490072]  ___might_sleep+0x10c/0x130
> [ 2258.490074]  __might_sleep+0x58/0x90
> [ 2258.490078]  synchronize_irq+0x58/0xd8
> [ 2258.490079]  disable_irq+0x2c/0x38
> [ 2258.490083]  vgic_v4_load+0x9c/0xc0
> [ 2258.490084]  vgic_v3_load+0x94/0x170
> [ 2258.490088]  kvm_vgic_load+0x3c/0x60
> [ 2258.490092]  kvm_arch_vcpu_load+0xd4/0x1d0
> [ 2258.490095]  vcpu_load+0x50/0x70
> [ 2258.490097]  kvm_arch_vcpu_ioctl_run+0x94/0x978
> [ 2258.490098]  kvm_vcpu_ioctl+0x3d8/0xa28
> [ 2258.490104]  do_vfs_ioctl+0xc4/0x8e8
> [ 2258.490106]  ksys_ioctl+0x8c/0xa0
> [ 2258.490108]  __arm64_sys_ioctl+0x28/0x58
> [ 2258.490112]  el0_svc_common.constprop.0+0x7c/0x188
> [ 2258.490114]  el0_svc_handler+0x34/0xb8
> [ 2258.490117]  el0_svc+0x8/0xc
> [ 2259.497070] BUG: sleeping function called from invalid context at 
> kernel/irq/manage.c:138

Thanks for reporting this.

[...]

> The logic of disabling the doorbell interrupt in vgic_v4_load() might
> need a fix?

The logic itself looks OK, but doing a full blown disable_irq() is both
counter productive (if we race against a doorbell, there is not much we
can do about it and waiting for it to end is pointless) and wrong
(despite the comment that this can be called in IRQ context, it is
pretty unsafe to do so).

Can you try turning it into a disable_irq_nosync() and let me know if
that helps?

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
