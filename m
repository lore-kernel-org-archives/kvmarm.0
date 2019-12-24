Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83894C2D0CF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 06:14:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EC27220706
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 06:14:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC27220706
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 590FF4AF4D;
	Tue, 24 Dec 2019 01:14:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dLq9vxuzTSyt; Tue, 24 Dec 2019 01:14:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69B7A4AF54;
	Tue, 24 Dec 2019 01:14:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A03264AF4B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 01:14:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HvVoJ1ECvrIn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 01:14:46 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C7634AF12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 01:14:46 -0500 (EST)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id A384698883F1BF9557CF;
 Tue, 24 Dec 2019 14:14:42 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 24 Dec 2019
 14:14:35 +0800
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Handle GICR_PENDBASER.PTZ filed as
 RAZ
To: Auger Eric <eric.auger@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20191220111833.1422-1-yuzenghui@huawei.com>
 <3a729559-d0eb-e042-d6bd-b69bacb0dd23@huawei.com>
 <c084aa29c029f97cdfb1b5dc9e6b29ac@www.loen.fr>
 <1225d839-3cf7-d513-778e-698e12e94875@huawei.com>
 <12a1e25b-617d-6b04-6a5a-4c67a39565a5@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5df2ebf7-f1e0-5d55-cdae-15b2fd1675d6@huawei.com>
Date: Tue, 24 Dec 2019 14:14:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <12a1e25b-617d-6b04-6a5a-4c67a39565a5@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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

On 2019/12/24 12:45, Auger Eric wrote:
> Hi Zenghui,
> 
> On 12/24/19 3:52 AM, Zenghui Yu wrote:
>> Hi Marc, Eric,
>>
>> On 2019/12/23 22:07, Marc Zyngier wrote:
>>> Hi Zenghui,
>>>
>>> On 2019-12-23 13:43, Zenghui Yu wrote:
>>>> I noticed there is no userspace access callbacks for GICR_PENDBASER,
>>>> so this patch will make the PTZ field also 'Read As Zero' by userspace.
>>>> Should we consider adding a uaccess_read callback for GICR_PENDBASER
>>>> which just returns the unchanged vgic_cpu->pendbaser to userspace?
>>>> (Though this is really not a big deal. We now always emulate the PTZ
>>>> field to guest as RAZ. And 'vgic_cpu->pendbaser & GICR_PENDBASER_PTZ'
>>>> only indicates whether KVM will optimize the LPI enabling process,
>>>> where Read As Zero indicates never optimize..)
>>>
>>> I don't think adding a userspace accessor would help much. All this
>>> bit tells userspace is that the guest has programmed a zero filled
>>> table. On restore, we'd avoid a rescan of the table if there was
>>> no LPI mapped.
>>
>> Yes, I agree.
>>
>>> And thinking of it, this fixes a bug for non-Linux guests: If you write
>>> PTZ=1, we never clear it. Which means that if userspace saves and
>>> restores
>>> PENDBASER with PTZ set, we'll never restore the pending bits, which is
>>> pretty bad (see vgic_enable_lpis()).
>>
>> But I'm afraid I can't follow this point. After reading the code (with
>> Qemu) a bit further, the Redistributors are restored before the ITS.
> 
> This is also part of the kernel documentation:
> Documentation/virt/kvm/devices/arm-vgic-its.txt (ITS restore sequence)

Yeah, I see. Thanks for the pointer, Eric!


Zenghui

>   So
>> there should be _no_ LPI has been mapped when we're restoring GICR_CTLR
>> and enabling LPI, which says we will not scan the whole pending table
>> and restore pending by vgic_enable_lpis()/its_sync_lpi_pending_table(),
>> regardless of what the PTZ is.
>>
>> Instead, vgic_its_restore_ite()/vgic_v3_lpi_sync_pending_status() is
>> where we actually read the guest RAM and restore the LPI pending state.
> yes the pending state is restored from
> vgic_its_restore_ite/vgic_add_lpi/vgic_v3_lpi_sync_pending_status and
> this path ignores the PTZ.
> 
> Thanks
> 
> Eric
>> Which means we will still do the right thing even for non-Linux guests.
>> Not sure if I've got things correctly here.
>>
>> In the end, let's keep the patch as it is.
>>
>>>
>>> This patch on its own fixes more than one bug!
>>>
>>
>> If so, just by luck ;-)

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
