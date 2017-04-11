From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 08/22] KVM: arm64: ITS: Implement
 vgic_mmio_uaccess_write_its_iidr
Date: Tue, 11 Apr 2017 12:56:28 +0200
Message-ID: <5a908f96-86e9-6ce6-7680-a08e2968bf7e@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-9-git-send-email-eric.auger@redhat.com>
 <864lxzch9o.fsf@arm.com> <5f1423fd-8f73-364a-9cf7-b4310957e2fd@redhat.com>
 <74d62f62-c0eb-b7eb-4e3a-96b1b6d0d66d@arm.com>
 <42ca421f-3c36-2f67-1e39-ec071cea3649@redhat.com>
 <e339c732-e1da-b620-ce09-8e141d2db376@arm.com>
 <dc02a006-cef8-ac75-7cfd-5fe5c220ea22@redhat.com>
 <CAFEAcA8XYUnC6zc+EF+amX8d1fP6sTF7Bypn455QkD++RsTRJA@mail.gmail.com>
 <5b2a8ed0-bfc7-852b-07d8-8474aef25b2a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5b2a8ed0-bfc7-852b-07d8-8474aef25b2a@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, kvm-devel <kvm@vger.kernel.org>, "prasun.kapoor" <Prasun.Kapoor@cavium.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, Andre Przywara <andre.przywara@arm.com>, Juan Quintela <quintela@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Kumar, Vijaya" <Vijaya.Kumar@cavium.com>, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 11/04/2017 12:29, Marc Zyngier wrote:
> On 11/04/17 11:16, Peter Maydell wrote:
>> On 11 April 2017 at 11:08, Auger Eric <eric.auger@redhat.com> wrote:
>>> On 11/04/2017 12:05, Marc Zyngier wrote:
>>>> On 10/04/17 16:17, Auger Eric wrote:
>>>>> A (v1) -> B (v1 & v2): migration OK
>>>>> B (v1 & v2) -> C (v1): migration NOK
>>>>
>>>> So what does IIDR report on B once the A->B migration has taken place?
>>>> Does it report v2?
>>>
>>> yes that was the plan
>>
>> Hmm, the IIDR value shouldn't change across a migration I think.
>> It's guest visible so the guest should see it still the same
>> value even after migration.
> 
> That's my worry. But we then have a problem when this VM migrates again.
> How does userspace find out which ABI to use then?

Today the userspace just conveys the information from source kernel to
destination kernel through the IIDR value. This allows the destination
kernel to know what was the table layout used during the migration.

If we report the source ABI revision value on the destination, what is
the strategy we should adopt:
- limit the features to those that will be migratable through this ABI
- allow the functionalities (GICv4 for instance) but reject save?

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
