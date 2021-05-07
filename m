Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C55EC433B4
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 09:58:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C755613D6
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 09:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C755613D6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE2364B579;
	Fri,  7 May 2021 05:58:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AXamqFzqIUeG; Fri,  7 May 2021 05:58:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B1384B57D;
	Fri,  7 May 2021 05:58:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E2F44B578
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 05:58:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PPlOm6KlAerZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 05:58:36 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 404C54B569
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 05:58:36 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fc5Rw5QgTzkX9h;
 Fri,  7 May 2021 17:55:56 +0800 (CST)
Received: from [10.67.77.175] (10.67.77.175) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0;
 Fri, 7 May 2021 17:58:23 +0800
Subject: Re: Question on guest enable msi fail when using GICv4/4.1
To: Marc Zyngier <maz@kernel.org>
References: <3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com>
 <87k0oaq5jf.wl-maz@kernel.org>
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <cf870bcf-1173-a70b-2b55-4209abcbcbc3@hisilicon.com>
Date: Fri, 7 May 2021 17:58:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87k0oaq5jf.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.67.77.175]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, linux-pci@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Bjorn Helgaas <bhelgaas@google.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

Thanks for your quick reply.

On 2021/5/7 17:03, Marc Zyngier wrote:
> On Fri, 07 May 2021 06:57:04 +0100,
> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>
>> [This letter comes from Nianyao Tang]
>>
>> Hi,
>>
>> Using GICv4/4.1 and msi capability, guest vf driver requires 3
>> vectors and enable msi, will lead to guest stuck.
> 
> Stuck how?

Guest serial does not response anymore and guest network shutdown.

> 
>> Qemu gets number of interrupts from Multiple Message Capable field
>> set by guest. This field is aligned to a power of 2(if a function
>> requires 3 vectors, it initializes it to 2).
> 
> So I guess this is a MultiMSI device with 4 vectors, right?
> 

Yes, it can support maximum of 32 msi interrupts, and vf driver only use 3 msi.

>> However, guest driver just sends 3 mapi-cmd to vits and 3 ite
>> entries is recorded in host.  Vfio initializes msi interrupts using
>> the number of interrupts 4 provide by qemu.  When it comes to the
>> 4th msi without ite in vits, in irq_bypass_register_producer,
>> producer and consumer will __connect fail, due to find_ite fail, and
>> do not resume guest.
> 
> Let me rephrase this to check that I understand it:
> - The device has 4 vectors
> - The guest only create mappings for 3 of them
> - VFIO calls kvm_vgic_v4_set_forwarding() for each vector
> - KVM doesn't have a mapping for the 4th vector and returns an error
> - VFIO disable this 4th vector
> 
> Is that correct? If yes, I don't understand why that impacts the guest
> at all. From what I can see, vfio_msi_set_vector_signal() just prints
> a message on the console and carries on.
> 

function calls:
--> vfio_msi_set_vector_signal
   --> irq_bypass_register_producer
      -->__connect

in __connect, add_producer finally calls kvm_vgic_v4_set_forwarding and fails to
get the 4th mapping. When add_producer fail, it does not call cons->start, calls
kvm_arch_irq_bypass_start and then kvm_arm_resume_guest.

Thanks,
Shaokun

>> Do we support this case, Guest function using msi interrupts number
>> not aligned to a power of 2?  Or qemu should provide correct msi
>> interrupts number?
> 
> QEMU cannot know how many vectors are in use, and the guest is free to
> issue mappings for the exact number of vectors it wants to service.
> 
> Please describe what breaks the guest here.
> 
> Thanks,
> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
