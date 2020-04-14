Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7B7C2BB86
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 11:18:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2204F20644
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 11:18:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2204F20644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C5A84B0D7;
	Tue, 14 Apr 2020 07:18:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cqZNv7jWHQTj; Tue, 14 Apr 2020 07:18:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71C694B119;
	Tue, 14 Apr 2020 07:18:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48E394B0D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 07:18:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BM8LwDs2OWbm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 07:18:01 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73C834B0D4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 07:18:01 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 1D8E5BC680AC97D09CAD;
 Tue, 14 Apr 2020 19:17:58 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Tue, 14 Apr 2020
 19:17:50 +0800
Subject: Re: [PATCH 1/2] KVM: arm64: vgic-v3: Retire all pending LPIs on vcpu
 destroy
To: Marc Zyngier <maz@kernel.org>
References: <20200414030349.625-1-yuzenghui@huawei.com>
 <20200414030349.625-2-yuzenghui@huawei.com> <20200414115417.451f8b66@why>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <a1c67c96-56f0-2976-ba1b-0991972254b3@huawei.com>
Date: Tue, 14 Apr 2020 19:17:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200414115417.451f8b66@why>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2020/4/14 18:54, Marc Zyngier wrote:
> On Tue, 14 Apr 2020 11:03:47 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
> Hi Zenghui,
> 
>> It's likely that the vcpu fails to handle all virtual interrupts if
>> userspace decides to destroy it, leaving the pending ones stay in the
>> ap_list. If the un-handled one is a LPI, its vgic_irq structure will
>> be eventually leaked because of an extra refcount increment in
>> vgic_queue_irq_unlock().
>>
>> This was detected by kmemleak on almost every guest destroy, the
>> backtrace is as follows:
>>
>> unreferenced object 0xffff80725aed5500 (size 128):
>> comm "CPU 5/KVM", pid 40711, jiffies 4298024754 (age 166366.512s)
>> hex dump (first 32 bytes):
>> 00 00 00 00 00 00 00 00 08 01 a9 73 6d 80 ff ff ...........sm...
>> c8 61 ee a9 00 20 ff ff 28 1e 55 81 6c 80 ff ff .a... ..(.U.l...
>> backtrace:
>> [<000000004bcaa122>] kmem_cache_alloc_trace+0x2dc/0x418
>> [<0000000069c7dabb>] vgic_add_lpi+0x88/0x418
>> [<00000000bfefd5c5>] vgic_its_cmd_handle_mapi+0x4dc/0x588
>> [<00000000cf993975>] vgic_its_process_commands.part.5+0x484/0x1198
>> [<000000004bd3f8e3>] vgic_its_process_commands+0x50/0x80
>> [<00000000b9a65b2b>] vgic_mmio_write_its_cwriter+0xac/0x108
>> [<0000000009641ebb>] dispatch_mmio_write+0xd0/0x188
>> [<000000008f79d288>] __kvm_io_bus_write+0x134/0x240
>> [<00000000882f39ac>] kvm_io_bus_write+0xe0/0x150
>> [<0000000078197602>] io_mem_abort+0x484/0x7b8
>> [<0000000060954e3c>] kvm_handle_guest_abort+0x4cc/0xa58
>> [<00000000e0d0cd65>] handle_exit+0x24c/0x770
>> [<00000000b44a7fad>] kvm_arch_vcpu_ioctl_run+0x460/0x1988
>> [<0000000025fb897c>] kvm_vcpu_ioctl+0x4f8/0xee0
>> [<000000003271e317>] do_vfs_ioctl+0x160/0xcd8
>> [<00000000e7f39607>] ksys_ioctl+0x98/0xd8
>>
>> Fix it by retiring all pending LPIs in the ap_list on the destroy path.
>>
>> p.s. I can also reproduce it on a normal guest shutdown. It is because
>> userspace still send LPIs to vcpu (through KVM_SIGNAL_MSI ioctl) while
>> the guest is being shutdown and unable to handle it. A little strange
>> though and haven't dig further...
> 
> What userspace are you using? You'd hope that the VMM would stop
> processing I/Os when destroying the guest. But we still need to handle
> it anyway, and I thing this fix makes sense.

I'm using Qemu (master) for debugging. Looks like an interrupt
corresponding to a virtio device configuration change, triggered after
all other devices had freed their irqs. Not sure if it's expected.

>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>>   virt/kvm/arm/vgic/vgic-init.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>> index a963b9d766b7..53ec9b9d9bc4 100644
>> --- a/virt/kvm/arm/vgic/vgic-init.c
>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>> @@ -348,6 +348,12 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>>   {
>>   	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>   
>> +	/*
>> +	 * Retire all pending LPIs on this vcpu anyway as we're
>> +	 * going to destroy it.
>> +	 */
>> +	vgic_flush_pending_lpis(vcpu);
>> +
>>   	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
>>   }
>>   
> 
> I guess that at this stage, the INIT_LIST_HEAD() is superfluous, right?

I was just thinking that the ap_list_head may not be empty (besides LPI,
with other active or pending interrupts), so leave it unchanged.

> Otherwise, looks good. If you agree with the above, I can fix that
> locally, no need to resend this patch.

Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
