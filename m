From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 01/22] KVM: arm/arm64: Add vITS save/restore API
 documentation
Date: Mon, 10 Apr 2017 16:26:14 +0200
Message-ID: <e60aa03e-b6af-3be3-6afd-ae795c45cf33@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-2-git-send-email-eric.auger@redhat.com>
 <20170408181712.GB29201@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170408181712.GB29201@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 08/04/2017 20:17, Christoffer Dall wrote:
> Hi Eric,
> 
> Most of my comments below are just me being picky about text when
> defining a user space ABI, so I think this mainly looks good, but just
> needs a bit of clarify, except the versioning aspect and exporting the
> pending table vie the redistributor instead, as Marc and Andre have
> pointed out.
> 
> On Mon, Mar 27, 2017 at 11:30:51AM +0200, Eric Auger wrote:
>> Add description for how to access vITS registers and how to flush/restore
>> vITS tables into/from memory
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v3 -> v4:
>> - take into account Peter's comments:
>>   - typos
>>   - KVM_DEV_ARM_VGIC_GRP_ITS_TABLES kvm_device_attr = 0
>>   - add a validity bit in DTE
>>   - document all fields in CTE and ITE
>>   - document ABI revision
>> - take into account Andre's comments:
>>   - document restrictions about GITS_CREADR writing and GITS_IIDR
>>   - document -EBUSY error if one or more VCPUS are runnning
>>   - document 64b registers only can be accessed with 64b access
>> - itt_addr field matches bits [51:8] of the itt_addr
>>
>> v1 -> v2:
>> - DTE and ITE now are 8 bytes
>> - DTE and ITE now indexed by deviceid/eventid
>> - use ITE name instead of ITTE
>> - mentions ITT_addr matches bits [51:8] of the actual address
>> - mentions LE layout
>> ---
>>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 118 +++++++++++++++++++++
>>  1 file changed, 118 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>> index 6081a5b..0902d20 100644
>> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>> @@ -36,3 +36,121 @@ Groups:
>>      -ENXIO:  ITS not properly configured as required prior to setting
>>               this attribute
>>      -ENOMEM: Memory shortage when allocating ITS internal data
>> +
>> +  KVM_DEV_ARM_VGIC_GRP_ITS_REGS
>> +  Attributes:
>> +      The attr field of kvm_device_attr encodes the offset of the
>> +      ITS register, relative to the ITS control frame base address
>> +      (ITS_base).
>> +
>> +      kvm_device_attr.addr points to a __u64 value whatever the width
>> +      of the addressed register (32/64 bits). 64 bit registers can only
>> +      be accessed with full length.
>> +
>> +      Writes to read-only registers are ignored by the kernel except for:
>> +      - GITS_READR. It needs to be restored otherwise commands in the queue
>> +        will be re-executed after CWRITER setting. Writing this register is
>                                      ^^^^^^^^^^^^^^^
> 
> "after restoring CWRITER." ?
OK
> 
>> +        allowed if the ITS is not enabled (GITS_CTLR.enable = 0). Also it
> 
> Does that mean that you can only save/restore a disabled ITS or does it
> mean that initially after creating the ITS it is disabled and userspace
> should restore the CWRITER before restoring GITS_CTLR (which may enable
> the ITS) ?
No I meant the second. As normally the ITS is responsible for updating
the GITS_READR, if the userspace plays with it while the ITS is enabled
this can mess everything. So the userspace is supposed to restore the
GITS_READR *before* restoring the GITS_CTLR which is likely to enable
the ITS.
> 
>> +        needs to be restored after GITS_CBASER since a write to GITS_CBASER
>> +        resets GITS_CREADR.
>> +      - GITS_IIDR. Its Revision field encodes the table layout ABI revision.
> 
> How is this really going to work?  Your ABI here must be backwards
> compatible for future revisions, so what is userspace supposed to do,
> when it reads a newer revision than it was programmed for?
destination ABI revision must be >= source ABI revision
By restoring the IIDR value on the destination side, the userspace
informs destination KVM about the layout of the table. If the
destination KVM does not support this ABI revision, the restoration of
the ITS table fails. Is that wrong?

> 
> I think we need a more clear description of how the revision is going to
> be used, such that each operation on the ITS here is described as
> requiring a minimum revision X, and making sure that userspace can
> safely ignore things that are of a higher revision number, while at the
> same time userspace can decide not to use newer features with older
> kernels.

At the moment I did not plan to implement any way for the userspace to
force the ITS state save in a specified ABI revision. Today it uses the
higher revision. Let's say that ABI V2 supports GICv4, save of source
ITS with be done in v2 layout. A destination only supporting GICv3 (ABI
v1) won't be able to read that format. Does it make sense?

> 
>> +
>> +      For other registers, getting or setting a register has the same
>> +      effect as reading/writing the register on real hardware.
>> +  Errors:
>> +    -ENXIO: Offset does not correspond to any supported register
>> +    -EFAULT: Invalid user pointer for attr->addr
>> +    -EINVAL: Offset is not 64-bit aligned
>> +    -EBUSY: one or more VCPUS are running
>> +
>> +  KVM_DEV_ARM_VGIC_GRP_ITS_TABLES
> 
> Shouldn't this be called KVM_DEV_ARM_VGIC_GRP_FLUSH_ITS_TABLES ?
At the moment this group is used for flush and restore. But as you have
the same remark as Andre I guess it is worth having separate commands in
KVM_DEV_ARM_VGIC_GRP_CTRL then.
> 
>> +  Attributes
>> +       The attr field of kvm_device_attr must be zero.
>> +
>> +       request the flush-save/restore of the ITS tables, namely
> 
> Nit: Request (upper case R)
OK
> 
> what does flush-save/restore mean as opposed to just flush?
meant flush/restore
> 
>> +       the device table, the collection table, all the ITT tables,
>> +       the LPI pending tables. On save, the tables are flushed
> 
> , and the LPI pending table.
OK
> 
>> +       into guest memory at the location provisioned by the guest
>> +       in GITS_BASER (device and collection tables), in the MAPD
>> +       command (ITT_addr), GICR_PENDBASERs (pending tables).
>> +
>> +       This means the GIC should be restored before the ITS and all
> 
> should or must?  Is this enforced?
must. yes it is.
> 
>> +       ITS registers but the GITS_CTLR must be restored before
>> +       restoring the ITS tables.
>> +
>> +       The GITS_READR and GITS_IIDR read-only registers must also
>> +       be restored before the table restore. The IIDR revision field
>> +       encodes the ABI revision of the table layout. If not set by
>> +       user space, the restoration of the tables will fail.
> 
> consider rewording: ", restoring the ITS tables will fail."
OK
> 
>> +
>> +       Note the LPI configuration table is read-only for the
> 
> Note that
OK
> 
>> +       in-kernel ITS and its save/restore goes through the standard
> 
> and saving/restoring it is done via the normal process to save/restore
> guest RAM.
OK
> 
>> +       RAM save/restore.
>> +
>> +       The layout of the tables in guest memory defines an ABI.
>> +       The entries are laid in little endian format as follows;
> 
> s/;/:/
OK
> 
> It's a bit weird to say "as follows:" and then proceed with the error
> descriptions.  I would simply say "as described in the following
> paragraph."
OK
> 
>> +
>> +  Errors:
>> +    -EINVAL: kvm_device_attr not equal to 0, invalid table data
>> +    -EFAULT: invalid guest ram access
>> +    -EBUSY: one or more VCPUS are running
>> +
>> +    ITS Table ABI REV1:
>> +    -------------------
>> +
>> +    The device table and ITE are respectively indexed by device id and
> 
> s/ITE/ITT/
right
> 
> are indexed by the device id and eventid, respectively.
> 
>> +    eventid. The collection table however is not indexed by collection id:
> 
> ...by collection id, instead all the CTEs are written...
> 
>> +    CTE are written at the beginning of the buffer.
> 
> in any particular order, or?
no order or creation
> 
>> +
>> +    Device Table Entry (DTE) layout: entry size = 8 bytes
>> +
>> +    bits:     | 63| 62 ... 49 | 48 ... 5 | 4 ... 0 |
>> +    values:   | V |   next    | ITT_addr |  Size   |
>> +
>> +    where;
>> +    - V indicates whether the entry is valid,
>> +    - ITT_addr matches bits [51:8] of the ITT address (256B aligned),
>> +    - next field is meaningful only if the entry is valid.
> 
> is the ITT_addr meaningful if the entry is not valid?
no, I will add this detail.
> 
>> +    It equals to 0 if this entry is the last one; otherwise it corresponds
>> +    to the minimum between the offset to the next device id and 2^14 -1.
> 
> I don't easily understand this last paragraph and the indentation is
> weird and makes it look like it's not explaining the next field.

reworded:
It equals to 0 if this entry is the last one; otherwise it corresponds
to the the deviceid offset to the next DTE, capped by 2^14 -1.
> 
> You're missing a description of the size field.  Size in what unit?
> Size of what?
right, added "size matches the MAPD Size semantic."
> 
> 
>> +
>> +    Collection Table Entry (CTE) layout: entry size = 8 bytes
>> +
>> +    bits:     | 63| 62 ..  52  | 51 ... 16 | 15  ...   0 |
>> +    values:   | V |    RES0    |  RDBase   |    ICID     |
>> +
>> +    where:
>> +    - V indicates whether the entry is valid,
> 
> Do we explain anywhere what RES0 means?
Added RES0: reserved field with Should-Be-Zero-or-Preserved behavior.
> 
>> +    - RDBase matches the PE number (GICR_TYPER.Processor_Number),
> 
> is 'matches' the right verb to use here?
is
> 
> What exactly is the format of GICR_TYPER.Processor_Number ?
> 
>> +    - ICID matches the collection ID
> 
> again, is 'matches' the right verb to use here?
is
> 
>> +
>> +    Interrupt Translation Entry (ITE) layout: entry size = 8 bytes
>> +
>> +    bits:     | 63 ... 48 | 47 ... 16 | 15 ... 0 |
>> +    values:   |    next   |   pINTID  |  ICID    |
>> +
>> +    where:
>> +    - pINTID is the physical LPI ID,
>> +    - ICID is the collection ID,
> 
> here you use 'is' intead of 'matches'.  At leat be consistent.
is
> 
>> +    - next field is meaningful only if the entry is valid (pINTID != 0).
>> +    It equals to 0 if this entry is the last one; otherwise it corresponds
>> +    to the minimum between the eventid offset to the next ITE and 2^16 -1.
> 
> same comments, as above.
ok
> 
> also, can you list the field in the order they appear?
ok
> 
>> +
>> +    LPI Pending Table layout:
>> +
>> +    As specified in the ARM Generic Interrupt Controller Architecture
>> +    Specification GIC Architecture version 3.0 and version 4. The first
> 
> "...version 4, the first".  ("As specified in X." is not a sentence).
> 
>> +    1kB is not modified and therefore should contain zeroes.
> 
> should or must?  or always contains zeros?  Will you return an error if
> userspace puts something non-zero in there?
no I don't. Spec says it should initialized to zero. $
> 
>> +
>> +    Future evolutions of the ITS table layout:
>> +
>> +    At the moment the table layout is defined and optimized for physical
>> +    LPI support.
> 
> This comment is a bit confusing, because this is all about virtual
> interrupts really, so 'physical from the point of view of the VM', but I
> think you should just drop this sentence.
OK
> 
>> +
>> +    In the future we might implement direct injection of virtual LPIS.
> 
> For nesting, yes?  (on the host this should not be visible here, should
> it?)
yes for nesting.
> 
>> +    This will require an upgrade of the table layout and an evolution of
>> +    the ABI. The ABI revision is encoded in the GITS_IIDR revision field.
>> +    That register must be restored before the table restoration, otherwise
>> +    the operation will fail.
> 
> Hmm, I thought we dealt with that before, feels a bit out of place.

OK moved to the register description.
> 
>> +
>> +    ABI V1: GITS_IIDR.Revision = 1
> 
> I feel like this should go in the ITS register description of the IIDR.
> Most likely, I think this particular line can be dropped, but all other
> definitions in this file can be annoted with a minimum revision number
> ensuring that future revisions implement this, plus potentially more
> stuff.
I already put the following title, "ITS Table ABI REV1" for the table
layout description. My intent was to create a new chapter per revision.
Is it OK?

Thanks

Eric

> 
> Thanks,
> -Christoffer
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
