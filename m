Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1CFC54FCB
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 11:35:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3964E2077D
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 11:35:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3964E2077D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB43D4B15D;
	Thu, 23 Apr 2020 07:35:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I8NaGUDO-Ky7; Thu, 23 Apr 2020 07:35:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 574A64B14D;
	Thu, 23 Apr 2020 07:35:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DE4D4B142
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 07:35:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YGJimH6pdPSS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 07:35:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31B5B4B117
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 07:35:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9566531B;
 Thu, 23 Apr 2020 04:35:38 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33A933F68F;
 Thu, 23 Apr 2020 04:35:37 -0700 (PDT)
Subject: Re: [PATCH v3 5/6] KVM: arm64: vgic-v3: Retire all pending LPIs on
 vcpu destroy
To: Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
References: <20200422161844.3848063-1-maz@kernel.org>
 <20200422161844.3848063-6-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
Date: Thu, 23 Apr 2020 12:35:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422161844.3848063-6-maz@kernel.org>
Content-Language: en-GB
Cc: Julien Grall <julien@xen.org>, kvm@vger.kernel.org,
 Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc, Zenghui,

On 22/04/2020 17:18, Marc Zyngier wrote:
> From: Zenghui Yu <yuzenghui@huawei.com>
> 
> It's likely that the vcpu fails to handle all virtual interrupts if
> userspace decides to destroy it, leaving the pending ones stay in the
> ap_list. If the un-handled one is a LPI, its vgic_irq structure will
> be eventually leaked because of an extra refcount increment in
> vgic_queue_irq_unlock().

> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index a963b9d766b73..53ec9b9d9bc43 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -348,6 +348,12 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  
> +	/*
> +	 * Retire all pending LPIs on this vcpu anyway as we're
> +	 * going to destroy it.
> +	 */

Looking at the other caller, do we need something like:
|	if (vgic_cpu->lpis_enabled)

?

> +	vgic_flush_pending_lpis(vcpu);
> +

Otherwise, I get this on a gic-v2 machine!:
[ 1742.187139] BUG: KASAN: use-after-free in vgic_flush_pending_lpis+0x250/0x2c0
[ 1742.194302] Read of size 8 at addr ffff0008e1bf1f28 by task qemu-system-aar/542
[ 1742.203140] CPU: 2 PID: 542 Comm: qemu-system-aar Not tainted
5.7.0-rc2-00006-g4fb0f7bb0e27 #2
[ 1742.211780] Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development
Platform, BIOS EDK II Jul 30 2018
[ 1742.222596] Call trace:
[ 1742.225059]  dump_backtrace+0x0/0x328
[ 1742.228738]  show_stack+0x18/0x28
[ 1742.232071]  dump_stack+0x134/0x1b0
[ 1742.235578]  print_address_description.isra.0+0x6c/0x350
[ 1742.240910]  __kasan_report+0x10c/0x180
[ 1742.244763]  kasan_report+0x4c/0x68
[ 1742.248268]  __asan_report_load8_noabort+0x30/0x48
[ 1742.253081]  vgic_flush_pending_lpis+0x250/0x2c0
[ 1742.257718]  __kvm_vgic_destroy+0x1cc/0x478
[ 1742.261919]  kvm_vgic_destroy+0x30/0x48
[ 1742.265773]  kvm_arch_destroy_vm+0x20/0x128
[ 1742.269976]  kvm_put_kvm+0x3e0/0x8d0
[ 1742.273567]  kvm_vm_release+0x3c/0x60
[ 1742.277248]  __fput+0x218/0x630
[ 1742.280406]  ____fput+0x10/0x20
[ 1742.283565]  task_work_run+0xd8/0x1f0
[ 1742.287245]  do_exit+0x87c/0x2640
[ 1742.290575]  do_group_exit+0xd0/0x258
[ 1742.294254]  __arm64_sys_exit_group+0x3c/0x48
[ 1742.298631]  el0_svc_common.constprop.0+0x10c/0x348
[ 1742.303529]  do_el0_svc+0x48/0xd0
[ 1742.306861]  el0_sync_handler+0x11c/0x1b8
[ 1742.310888]  el0_sync+0x158/0x180
[ 1742.315716] The buggy address belongs to the page:
[ 1742.320529] page:fffffe002366fc40 refcount:0 mapcount:0 mapping:000000007e21d29f index:0x0
[ 1742.328821] flags: 0x2ffff00000000000()
[ 1742.332678] raw: 2ffff00000000000 0000000000000000 ffffffff23660401 0000000000000000
[ 1742.340449] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[ 1742.348215] page dumped because: kasan: bad access detected
[ 1742.355304] Memory state around the buggy address:
[ 1742.360115]  ffff0008e1bf1e00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1742.367360]  ffff0008e1bf1e80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1742.374606] >ffff0008e1bf1f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1742.381851]                                   ^
[ 1742.386399]  ffff0008e1bf1f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1742.393645]  ffff0008e1bf2000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1742.400889] ==================================================================
[ 1742.408132] Disabling lock debugging due to kernel taint


With that:
Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
