Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB5AC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 08:42:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 712B749EF5;
	Tue,  1 Feb 2022 03:42:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R7diZ1OGfYWV; Tue,  1 Feb 2022 03:42:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E221B49EED;
	Tue,  1 Feb 2022 03:42:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B2B649EE6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 03:41:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W+Ykj2Or7SmZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 03:41:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1313449EE4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 03:41:07 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86F9F6D;
 Tue,  1 Feb 2022 00:41:07 -0800 (PST)
Received: from [192.168.1.11] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A9A3D3F40C;
 Tue,  1 Feb 2022 00:41:05 -0800 (PST)
Subject: Re: [PATCH][kvmtool] virtio/pci: Signal INTx interrupts as level
 instead of edge
To: Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20220131160242.2665191-1-maz@kernel.org>
 <CAMj1kXHyxfe8E028OnN3Ac2PCC4HdyDdonHo785YTDjyXv=1qQ@mail.gmail.com>
From: Pierre Gondois <pierre.gondois@arm.com>
Message-ID: <a95adee4-bad2-08f7-af11-ef2f63935b12@arm.com>
Date: Tue, 1 Feb 2022 09:41:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXHyxfe8E028OnN3Ac2PCC4HdyDdonHo785YTDjyXv=1qQ@mail.gmail.com>
Content-Language: en-US
X-Mailman-Approved-At: Tue, 01 Feb 2022 03:42:34 -0500
Cc: Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Sami Mujawar <sami.mujawar@arm.com>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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



On 1/31/22 5:04 PM, Ard Biesheuvel wrote:
> On Mon, 31 Jan 2022 at 17:03, Marc Zyngier <maz@kernel.org> wrote:
>>
>> It appears that the way INTx is emulated is "slightly" out of spec
>> in kvmtool. We happily inject an edge interrupt, even if the spec
>> mandates a level.
>>
>> This doesn't change much for either the guest or userspace (only
>> KVM will have a bit more work tracking the EOI), but at least
>> this is correct.
>>
>> Reported-by: Pierre Gondois <pierre.gondois@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Cc: Ard Biesheuvel <ardb@kernel.org>
>> Cc: Sami Mujawar <sami.mujawar@arm.com>
>> Cc: Will Deacon <will@kernel.org>
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Hi,
Just to confirm, I tried the patch and everything is working for me,
Regards,
Pierre

> 
>> ---
>>   pci.c        | 2 +-
>>   virtio/pci.c | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/pci.c b/pci.c
>> index e5930331..a769ae27 100644
>> --- a/pci.c
>> +++ b/pci.c
>> @@ -61,7 +61,7 @@ int pci__assign_irq(struct pci_device_header *pci_hdr)
>>          pci_hdr->irq_line       = irq__alloc_line();
>>
>>          if (!pci_hdr->irq_type)
>> -               pci_hdr->irq_type = IRQ_TYPE_EDGE_RISING;
>> +               pci_hdr->irq_type = IRQ_TYPE_LEVEL_HIGH;
>>
>>          return pci_hdr->irq_line;
>>   }
>> diff --git a/virtio/pci.c b/virtio/pci.c
>> index 41085291..2777d1c8 100644
>> --- a/virtio/pci.c
>> +++ b/virtio/pci.c
>> @@ -413,7 +413,7 @@ int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
>>                          kvm__irq_trigger(kvm, vpci->gsis[vq]);
>>          } else {
>>                  vpci->isr = VIRTIO_IRQ_HIGH;
>> -               kvm__irq_trigger(kvm, vpci->legacy_irq_line);
>> +               kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_HIGH);
>>          }
>>          return 0;
>>   }
>> --
>> 2.34.1
>>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
