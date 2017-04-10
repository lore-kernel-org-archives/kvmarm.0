From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 01/22] KVM: arm/arm64: Add vITS save/restore API
 documentation
Date: Mon, 10 Apr 2017 12:18:34 +0200
Message-ID: <c4571a9a-46e1-441b-0162-29f75a24cb0d@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-2-git-send-email-eric.auger@redhat.com>
 <86y3vbcj20.fsf@arm.com> <20170408131552.GA29201@lvm>
 <86y3vabycb.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <86y3vabycb.fsf@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: eric.auger.pro@gmail.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc, Christoffer,

On 08/04/2017 19:31, Marc Zyngier wrote:
> On Sat, Apr 08 2017 at 02:15:52 PM, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>> On Sat, Apr 08, 2017 at 11:03:51AM +0100, Marc Zyngier wrote:
>>> On Mon, Mar 27 2017 at 10:30:51 AM, Eric Auger <eric.auger@redhat.com> wrote:
>>>> Add description for how to access vITS registers and how to flush/restore
>>>> vITS tables into/from memory
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
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
>>>>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 118 +++++++++++++++++++++
>>>>  1 file changed, 118 insertions(+)
>>>>
>>>> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>>>> index 6081a5b..0902d20 100644
>>>> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>>>> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>>>> @@ -36,3 +36,121 @@ Groups:
>>>>      -ENXIO:  ITS not properly configured as required prior to setting
>>>>               this attribute
>>>>      -ENOMEM: Memory shortage when allocating ITS internal data
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
>>>> +        will be re-executed after CWRITER setting. Writing this register is
>>>> +        allowed if the ITS is not enabled (GITS_CTLR.enable = 0). Also it
>>>> +        needs to be restored after GITS_CBASER since a write to GITS_CBASER
>>>> +        resets GITS_CREADR.
>>>> +      - GITS_IIDR. Its Revision field encodes the table layout ABI revision.
>>>> +
>>>> +      For other registers, getting or setting a register has the same
>>>> +      effect as reading/writing the register on real hardware.
>>>> +  Errors:
>>>> +    -ENXIO: Offset does not correspond to any supported register
>>>> +    -EFAULT: Invalid user pointer for attr->addr
>>>> +    -EINVAL: Offset is not 64-bit aligned
>>>> +    -EBUSY: one or more VCPUS are running
>>>> +
>>>> +  KVM_DEV_ARM_VGIC_GRP_ITS_TABLES
>>>> +  Attributes
>>>> +       The attr field of kvm_device_attr must be zero.
>>>> +
>>>> +       request the flush-save/restore of the ITS tables, namely
>>>> +       the device table, the collection table, all the ITT tables,
>>>> +       the LPI pending tables. On save, the tables are flushed
>>>> +       into guest memory at the location provisioned by the guest
>>>> +       in GITS_BASER (device and collection tables), in the MAPD
>>>> +       command (ITT_addr), GICR_PENDBASERs (pending tables).
>>>
>>> May I echo Andre's concern here? Seeing the GICR_PENDBASER registers
>>> here feels wrong. The pending table is a redistributor concept, and is
>>> local to it. Even more, it is perfectly possible to use the
>>> redistributors (and its pending tables) without an ITS by using the
>>> GICR_SETLPIR registers.
>>>
>>> Granted, we do not support this (and I'm *not* looking forward to
>>> supporting it), but I would rather implement a redistributor flush than
>>> using the ITS to indirectly force it. That's not how the HW works, and I
>>> don't think we should deviate from it.
>>>
>>> I appreciate this brings additional complexity to userspace (having to
>>> iterate over the vcpus or the redistributors is likely more costly than
>>> hitting the ITS which is likely to be unique), but sticking to the
>>> letter of the architecture is probably our best bet. Each time we tried
>>> to deviate from it, we've had to backtrack.
>>
>> I agree.  I think the possibility of using LPIs without an ITS is the
>> winning argument.
>>
>> However, I could see it being reasonable to have a single call that
>> userspace can make on the vgic device to ask it to flush all the
>> redistributors at the same time.  We defined the cpu sysreg interface
>> via the vgic device as well, so I don't think we're breaking anything,
>> and in fact, it may be good to have a single sync-point where the kernel
>> can atomically say "all redistributors are flushed correctly" or
>> "something bad happened".  Do we have any arguments for wanting to be
>> able flush redistributors independently?
> 
> Not as such. The redistributors may support implementation-specific ways
> of ensuring synchronization with the PT (for power management purposes,
> for example), but there is no architected way of ensuring it.
> 
> So I agree that having a single synchronization hook for all
> redistributors in the system is probably the right thing to do. This is
> simple enough for userspace, and we already have the required code in
> this series -- we just need to tie it to an additional property on the
> GICv3 group.
> 
> Eric: can you explore this and let us know if there is any issue we
> haven't foreseen yet?
Yes I am going to investigate this. The extra complexity I foresee is
that I need to implement coarse mapping in the first kB of the pending
table to guess what LPI is pending and thus become independent on the
restoration of the ITS - which is the goal -.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
