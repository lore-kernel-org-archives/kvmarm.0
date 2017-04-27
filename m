From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 01/22] KVM: arm/arm64: Add ITS save/restore API
 documentation
Date: Thu, 27 Apr 2017 17:23:00 +0100
Message-ID: <0551f729-2499-bf2b-7aac-6e56991de373@arm.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-2-git-send-email-eric.auger@redhat.com>
 <20170426123120.GL4104@cbox>
 <88a194fa-9143-960e-e0a6-6b5c388cef82@redhat.com>
 <20170427085709.GB50776@lvm>
 <db5d0eb9-67eb-8b9a-50ca-816d217b3f53@redhat.com>
 <20170427110223.GH50776@lvm>
 <d0aa6771-a8c3-276e-0f70-d709cdf678d6@redhat.com>
 <20170427144516.GL50776@lvm>
 <c3dd2ad2-b068-f158-10d7-53e27bd2b1bf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <c3dd2ad2-b068-f158-10d7-53e27bd2b1bf@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Christoffer Dall <cdall@linaro.org>, drjones@redhat.com, kvm@vger.kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, Prasun.Kapoor@cavium.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On 27/04/17 16:29, Auger Eric wrote:
> 
> 
> On 27/04/2017 16:45, Christoffer Dall wrote:
>> Hi Eric,
>>
>> On Thu, Apr 27, 2017 at 02:51:00PM +0200, Auger Eric wrote:
>>> On 27/04/2017 13:02, Christoffer Dall wrote:
>>>> On Thu, Apr 27, 2017 at 11:33:39AM +0200, Auger Eric wrote:
>>>>> On 27/04/2017 10:57, Christoffer Dall wrote:
>>>>>> On Wed, Apr 26, 2017 at 05:48:32PM +0200, Auger Eric wrote:
>>>>>>> On 26/04/2017 14:31, Christoffer Dall wrote:
>>>>>>>> On Fri, Apr 14, 2017 at 12:15:13PM +0200, Eric Auger wrote:
>>>>>>>>> Add description for how to access ITS registers and how to save/restore
>>>>>>>>> ITS tables into/from memory.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>>>>>>
>>>>>>>>> ---
>>>>>>>>> v4 -> v5:
>>>>>>>>> - take into account Christoffer's comments
>>>>>>>>> - pending table save on GICV3 side now
>>>>>>>>>
>>>>>>>>> v3 -> v4:
>>>>>>>>> - take into account Peter's comments:
>>>>>>>>>   - typos
>>>>>>>>>   - KVM_DEV_ARM_VGIC_GRP_ITS_TABLES kvm_device_attr = 0
>>>>>>>>>   - add a validity bit in DTE
>>>>>>>>>   - document all fields in CTE and ITE
>>>>>>>>>   - document ABI revision
>>>>>>>>> - take into account Andre's comments:
>>>>>>>>>   - document restrictions about GITS_CREADR writing and GITS_IIDR
>>>>>>>>>   - document -EBUSY error if one or more VCPUS are runnning
>>>>>>>>>   - document 64b registers only can be accessed with 64b access
>>>>>>>>> - itt_addr field matches bits [51:8] of the itt_addr
>>>>>>>>>
>>>>>>>>> v1 -> v2:
>>>>>>>>> - DTE and ITE now are 8 bytes
>>>>>>>>> - DTE and ITE now indexed by deviceid/eventid
>>>>>>>>> - use ITE name instead of ITTE
>>>>>>>>> - mentions ITT_addr matches bits [51:8] of the actual address
>>>>>>>>> - mentions LE layout
>>>>>>>>> ---
>>>>>>>>>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 99 ++++++++++++++++++++++
>>>>>>>>>  1 file changed, 99 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>>>>>>>>> index 6081a5b..b5f010d 100644
>>>>>>>>> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>>>>>>>>> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>>>>>>>>> @@ -32,7 +32,106 @@ Groups:
>>>>>>>>>      KVM_DEV_ARM_VGIC_CTRL_INIT
>>>>>>>>>        request the initialization of the ITS, no additional parameter in
>>>>>>>>>        kvm_device_attr.addr.
>>>>>>>>> +
>>>>>>>>> +    KVM_DEV_ARM_ITS_SAVE_TABLES
>>>>>>>>> +      save the ITS table data into guest RAM, at the location provisioned
>>>>>>>>> +      by the guest in corresponding registers/table entries.
>>>>>>>>> +
>>>>>>>>> +      The layout of the tables in guest memory defines an ABI. The entries
>>>>>>>>> +      are laid out in little endian format as described in the last paragraph.
>>>>>>>>> +
>>>>>>>>> +    KVM_DEV_ARM_ITS_RESTORE_TABLES
>>>>>>>>> +      restore the ITS tables from guest RAM to ITS internal structures.
>>>>>>>>> +
>>>>>>>>> +      The GICV3 must be restored before the ITS and all ITS registers but
>>>>>>>>> +      the GITS_CTLR must be restored before restoring the ITS tables.
>>>>>>>>> +
>>>>>>>>> +      The GITS_IIDR read-only register must also be restored before
>>>>>>>>> +      the table restore as the IIDR revision field encodes the ABI revision.
>>>>>>>>> +
>>>>>>>>
>>>>>>>> what is the expected sequence of operations.  For example, to restore
>>>>>>>> the ITS, do I call KVM_DEV_ARM_VGIC_CTRL_INIT first, then restore all
>>>>>>>> the memory and registers, and finally call KVM_DEV_ARM_ITS_RESTORE_TABLES?
>>>>>>> Yes KVM_DEV_ARM_VGIC_CTRL_INIT comes first, then restore all registers
>>>>>>> except GITS_CTLR, then table restore, then GITS_CTLR
>>>>>>>>
>>>>>>>> Is there any interaction between when you call KVM_DEV_ARM_ITS_RESTORE_TABLES
>>>>>>>> and restore GITS_CTLR (which enables the ITS)?
>>>>>>>
>>>>>>> Yep, when GITS_CTLR is set, LPIs may be enabled and this on that event
>>>>>>> that the pending table is read. But the whole pending table is not read
>>>>>>> as we only iterate on registered LPIs. So the ITT must have been
>>>>>>> restored previously.
>>>>>>>
>>>>>>> I became aware that the pending table sync is done twice, once in the
>>>>>>> pending table restore,  and once in the GITS_CTLR restore. So if we
>>>>>>> leave this order specification, I should be able to remove the sync on
>>>>>>> table restore. This was the original reason why GITS_CTLR restore has
>>>>>>> been done at the very end.
>>>>>>
>>>>>> I'm sorry, I'm a bit confused.  Do we not need
>>>>>> KVM_DEV_ARM_ITS_RESTORE_TABLES at all then?
>>>>>
>>>>> Yes you do. I was talking about the RDIST pending table sync. The save
>>>>> is explicit using GICV3 device KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES.
>>>>> However the sync is implicit on GITS_CTLR restore if LPIs are enabled.
>>>>> and today I do it also on ITS device KVM_DEV_ARM_ITS_RESTORE_TABLES
>>>>> which is not requested I think since GITS_CTLR restore does it already.
>>>>
>>>> Shouldn't restoring the pending tables happen when restoring some
>>>> redeistributor state and not anything related to the ITS?
>>>
>>> Marc wrote:
>>> "
>>> I don't think you necessarily need a coarse map. When restoring the ITS
>>> tables, you can always read the pending bit when creating the LPI
>>> structure (it has been written to RAM at save time). Note that we
>>> already do something like this in vgic_enable_lpis().
>>> "
>>>
>>> This is currently what is implemented I think. the pending tables are
>>> currently sync'ed on GITS_CTLR set (if LPI are enabled) + erroneously
>>> also on on ITS table restore
>>>
>>> The problematic is: Either you know in advance which LPI INTIDare used
>>> or you need to parse the whole pending table (possibly using the 1st kB
>>> as coarse mapping).
>>>
>>> If you don't know the LPI INTIDs in advance it is only possible to
>>> restore the pending bit of pending LPIs. At that time you would
>>> re-allocate those pending LPI (vgic_add_lpi) and when you restore the
>>> ITS ITT you would do the same for those which were not pending. Looks
>>> really heavy to me: coarse mapping + dual vgic_add_lpi path.
>>>
>>> Otherwise we would need to add another dependency between RDIST pending
>>> table restore and ITS table restore but this looks even more weird, no?
>>>
>>>
>> So I just sat down with Andre and Marc and we tried to work through this
>> and came up with the best scheme.  I apologize in advance for the
>> one-way nature of this e-mail, and I am of course open to discussing the
>> following proposal again if you do not agree.
>>
>> What I think this document should say, is that the following ordering
>> must be followed when restoring the GIC and the ITS:
>>
>>   First, restore all guest memory
>>
>>   Second, restore ALL redistributors
>>
>>   Third, restore the ITS, in the following order:
>>     1. Initialize the ITS (KVM_DEV_ARM_VGIC_CTRL_INIT)
>>     2. Restore GITS_CBASER
>>     3. Restore all other GITS_ registers, except GITS_CTLR!
>>     4. Load the ITS table data (KVM_DEV_ARM_ITS_RESTORE_TABLES)
>>     5. Restore GITS_CTLR
>>
>> The rationale is that we really want the redistributor and the ITS
>> restore to be independent and follow the architecture.  This means that
>> our ABI for the redistributor should still work without restoring an ITS
>> (if we ever decide to support LPIs for KVM without the ITS).
> 
> OK. Note I already mentioned that GICv3 must be restored before the ITS.
> To me this comprised the RDIST.
> 
> I understand the above description of the ordering comes in addition to
> the existing text, right? in other words I keep the GITS_READR,
> GITS_IIDR specific text as well as KVM_DEV_ARM_ITS_SAVE/RESTORE_TABLES
> section.
> 
>>
>> In terms of our current implementation this means that vgic_add_lpi()
>> should ask the redistributor what the state of the LPI is (priority,
>> enabled, pending).
> this practically means I move update_lpi_config call from
> vgic_its_restore_ite to vgic_add_lpi(). OK
> 
> However for getting the LPI pending state I must know which RDIST the
> LPI is attached to. This is not known at LPI allocation time. Do I
> misunderstand something?

Once you have rebuilt the ITS data structures and allocated the IRQ
structures, you should have a target_cpu field pointing to the right
vcpu. From there, you can surely find the corresponding redistributor
and the pending table.

BTW, we should document the fact that vcpus must have been created
before reloading the ITS (that's not completely obvious).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
