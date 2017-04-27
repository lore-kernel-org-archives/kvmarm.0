From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 01/22] KVM: arm/arm64: Add ITS save/restore API
 documentation
Date: Thu, 27 Apr 2017 11:33:39 +0200
Message-ID: <db5d0eb9-67eb-8b9a-50ca-816d217b3f53@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-2-git-send-email-eric.auger@redhat.com>
 <20170426123120.GL4104@cbox>
 <88a194fa-9143-960e-e0a6-6b5c388cef82@redhat.com>
 <20170427085709.GB50776@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170427085709.GB50776@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Christoffer Dall <cdall@linaro.org>, drjones@redhat.com, kvm@vger.kernel.org, peter.maydell@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, Prasun.Kapoor@cavium.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 27/04/2017 10:57, Christoffer Dall wrote:
> On Wed, Apr 26, 2017 at 05:48:32PM +0200, Auger Eric wrote:
>> Hi Christoffer,
>>
>> On 26/04/2017 14:31, Christoffer Dall wrote:
>>> On Fri, Apr 14, 2017 at 12:15:13PM +0200, Eric Auger wrote:
>>>> Add description for how to access ITS registers and how to save/restore
>>>> ITS tables into/from memory.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
>>>> v4 -> v5:
>>>> - take into account Christoffer's comments
>>>> - pending table save on GICV3 side now
>>>>
>>>> v3 -> v4:
>>>> - take into account Peter's comments:
>>>>   - typos
>>>>   - KVM_DEV_ARM_VGIC_GRP_ITS_TABLES kvm_device_attr = 0
>>>>   - add a validity bit in DTE
>>>>   - document all fields in CTE and ITE
>>>>   - document ABI revision
>>>> - take into account Andre's comments:
>>>>   - document restrictions about GITS_CREADR writing and GITS_IIDR
>>>>   - document -EBUSY error if one or more VCPUS are runnning
>>>>   - document 64b registers only can be accessed with 64b access
>>>> - itt_addr field matches bits [51:8] of the itt_addr
>>>>
>>>> v1 -> v2:
>>>> - DTE and ITE now are 8 bytes
>>>> - DTE and ITE now indexed by deviceid/eventid
>>>> - use ITE name instead of ITTE
>>>> - mentions ITT_addr matches bits [51:8] of the actual address
>>>> - mentions LE layout
>>>> ---
>>>>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 99 ++++++++++++++++++++++
>>>>  1 file changed, 99 insertions(+)
>>>>
>>>> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>>>> index 6081a5b..b5f010d 100644
>>>> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>>>> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>>>> @@ -32,7 +32,106 @@ Groups:
>>>>      KVM_DEV_ARM_VGIC_CTRL_INIT
>>>>        request the initialization of the ITS, no additional parameter in
>>>>        kvm_device_attr.addr.
>>>> +
>>>> +    KVM_DEV_ARM_ITS_SAVE_TABLES
>>>> +      save the ITS table data into guest RAM, at the location provisioned
>>>> +      by the guest in corresponding registers/table entries.
>>>> +
>>>> +      The layout of the tables in guest memory defines an ABI. The entries
>>>> +      are laid out in little endian format as described in the last paragraph.
>>>> +
>>>> +    KVM_DEV_ARM_ITS_RESTORE_TABLES
>>>> +      restore the ITS tables from guest RAM to ITS internal structures.
>>>> +
>>>> +      The GICV3 must be restored before the ITS and all ITS registers but
>>>> +      the GITS_CTLR must be restored before restoring the ITS tables.
>>>> +
>>>> +      The GITS_IIDR read-only register must also be restored before
>>>> +      the table restore as the IIDR revision field encodes the ABI revision.
>>>> +
>>>
>>> what is the expected sequence of operations.  For example, to restore
>>> the ITS, do I call KVM_DEV_ARM_VGIC_CTRL_INIT first, then restore all
>>> the memory and registers, and finally call KVM_DEV_ARM_ITS_RESTORE_TABLES?
>> Yes KVM_DEV_ARM_VGIC_CTRL_INIT comes first, then restore all registers
>> except GITS_CTLR, then table restore, then GITS_CTLR
>>>
>>> Is there any interaction between when you call KVM_DEV_ARM_ITS_RESTORE_TABLES
>>> and restore GITS_CTLR (which enables the ITS)?
>>
>> Yep, when GITS_CTLR is set, LPIs may be enabled and this on that event
>> that the pending table is read. But the whole pending table is not read
>> as we only iterate on registered LPIs. So the ITT must have been
>> restored previously.
>>
>> I became aware that the pending table sync is done twice, once in the
>> pending table restore,  and once in the GITS_CTLR restore. So if we
>> leave this order specification, I should be able to remove the sync on
>> table restore. This was the original reason why GITS_CTLR restore has
>> been done at the very end.
> 
> I'm sorry, I'm a bit confused.  Do we not need
> KVM_DEV_ARM_ITS_RESTORE_TABLES at all then?

Yes you do. I was talking about the RDIST pending table sync. The save
is explicit using GICV3 device KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES.
However the sync is implicit on GITS_CTLR restore if LPIs are enabled.
and today I do it also on ITS device KVM_DEV_ARM_ITS_RESTORE_TABLES
which is not requested I think since GITS_CTLR restore does it already.

KVM_DEV_ARM_ITS_RESTORE_TABLES restores all the ITS tables (device,
collection, ITT)

Hope it clarifies.

Thanks

Eric

> 
>>>
>>>>    Errors:
>>>>      -ENXIO:  ITS not properly configured as required prior to setting
>>>>               this attribute
>>>>      -ENOMEM: Memory shortage when allocating ITS internal data
>>>> +    -EINVAL: Inconsistent restored data
>>>> +    -EFAULT: Invalid guest ram access
>>>> +    -EBUSY:  One or more VCPUS are running
>>>> +
>>>> +  KVM_DEV_ARM_VGIC_GRP_ITS_REGS
>>>> +  Attributes:
>>>> +      The attr field of kvm_device_attr encodes the offset of the
>>>> +      ITS register, relative to the ITS control frame base address
>>>> +      (ITS_base).
>>>> +
>>>> +      kvm_device_attr.addr points to a __u64 value whatever the width
>>>> +      of the addressed register (32/64 bits). 64 bit registers can only
>>>> +      be accessed with full length.
>>>> +
>>>> +      Writes to read-only registers are ignored by the kernel except for:
>>>> +      - GITS_READR. It needs to be restored otherwise commands in the queue
>>>> +        will be re-executed after restoring CWRITER. GITS_READR must be restored
>>>> +        before restoring the GITS_CTLR which is likely to enable the ITS.
>>>> +        Also it needs to be restored after GITS_CBASER since a write to
>>>> +        GITS_CBASER resets GITS_CREADR.
>>>> +      - GITS_IIDR. Its Revision field encodes the table layout ABI revision.
>>>> +        In the future we might implement direct injection of virtual LPIS.
>>>> +        This will require an upgrade of the table layout and an evolution of
>>>> +        the ABI. GITS_IIDR must be restored before the table restoration.
>>>> +
>>>> +      For other registers, getting or setting a register has the same
>>>> +      effect as reading/writing the register on real hardware.
>>>> +  Errors:
>>>> +    -ENXIO: Offset does not correspond to any supported register
>>>> +    -EFAULT: Invalid user pointer for attr->addr
>>>> +    -EINVAL: Offset is not 64-bit aligned
>>>> +    -EBUSY: one or more VCPUS are running
>>>
>>>
>>> It may be helpful to state the ordering requirements somewhere:
>>>
>>> Restoring the ITS:
>>> ------------------
>>> Restoring the ITS requires certain things to happen in order.
>>> Specifically:
>>>  1. Initialize the ITS (KVM_DEV_ARM_VGIC_CTRL_INIT)
>>>  2. Restore GITS_IIDR
>>>  3. Restore GITS_CBASER
>>>  4. Restore GITS_READR
>>>  5. Restore remainin registers except GITS_CTLR
>>>  6. Make sure all guest memory is restored
>>>  7. Load the ITS table data (KVM_DEV_ARM_ITS_RESTORE_TABLES)
>>
>> OK I will try to fit that description somewhere.
>>
> 
> Thanks,
> -Christoffer
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
