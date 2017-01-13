From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 01/13] KVM: arm/arm64: Add vITS save/restore API
 documentation
Date: Fri, 13 Jan 2017 10:07:56 +0100
Message-ID: <e58a566d-e100-d31a-fb26-a15a793d3623@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
 <1484236613-24633-2-git-send-email-eric.auger@redhat.com>
 <4fe81c1b-9956-d458-b0ef-b7219f1249fe@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F175405A8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 04:06:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vCwf1D+1jDts for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jan 2017 04:06:16 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7E93403F8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 04:06:15 -0500 (EST)
In-Reply-To: <4fe81c1b-9956-d458-b0ef-b7219f1249fe@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, Prasun.Kapoor@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 12/01/2017 17:52, Marc Zyngier wrote:
> Hi Eric,
> 
> On 12/01/17 15:56, Eric Auger wrote:
>> Add description for how to access vITS registers and how to flush/restore
>> vITS tables into/from memory
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 70 ++++++++++++++++++++++
>>  1 file changed, 70 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>> index 6081a5b..bd74613 100644
>> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>> @@ -36,3 +36,73 @@ Groups:
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
>> +      of the addressed register (32/64 bits).
>> +
>> +      Writes to read-only registers are ignored by the kernel except
>> +      for a single register, GITS_READR. Normally this register is RO
>> +      but it needs to be restored otherwise commands in the queue will
>> +      be re-executed after CWRITER setting.
>> +
>> +      For other registers, Getting or setting a register has the same
>> +      effect as reading/writing the register on real hardware.
>> +  Errors:
>> +    -ENXIO: Offset does not correspond to any supported register
>> +    -EFAULT: Invalid user pointer for attr->addr
>> +    -EINVAL: Offset is not 64-bit aligned
>> +
>> +  KVM_DEV_ARM_VGIC_GRP_ITS_TABLES
>> +  Attributes
>> +       The attr field of kvm_device_attr is not used.
>> +
>> +       request the flush-save/restore of the ITS tables, namely
>> +       the device table, the collection table, all the ITT tables,
>> +       the LPI pending tables. On save, the tables are flushed
>> +       into guest memory at the location provisionned by the guest
> 
> 					    provisioned
> 
>> +       in GITS_BASER (device and collection tables), on MAPD command
>> +       (ITT_addr), GICR_PENDBASERs (pending tables).
>> +
>> +       This means the GIC should be restored before the ITS and all
>> +       ITS registers but the GITS_CTRL must be restored before
>> +       restoring the ITS tables.
>> +
>> +       Note the LPI configuration table is read-only for the
>> +       in-kernel ITS and its save/restore goes through the standard
>> +       RAM save/restore.
>> +
>> +       The layout of the tables in guest memory defines an ABI.
>> +       The entries are laid out in memory as follows;
>> +
>> +    Device Table Entry (DTE) layout: entry size = 16 bytes
>> +
>> +    bits:     | 63   ...  32  | 31 ... 6 | 5 | 4   ...   0 |
>> +    values:   |   DeviceID    |   Resv   | V |    Size     |
>> +
>> +    bits:     | 63 ... 44 | 43  ...  0  |
>> +    values:   |    Resv   |  ITT_addr   |
> 
> While I appreciate this layout represents the absolute maximum an ITS
> could implement, I'm a bit concerned about the amount of memory we may
> end-up requiring here. All the ITSs implementations I know of seem to
> get away with 8 bytes per entry. Maybe I'm just too worried.

OK so I would propose a 16b DeviceId and 16b eventid

bits:     | 63   ...  48  | 47 ... 4 | 3   ...   0 |
values:   |   DeviceID    | ITT_addr |    Size     |

I can use the size field as a validity indicator

> 
> Also, please mention that ITT_addr is actually ITT_addr[51:8], as we're
> guaranteed to have an ITT that is 256 byte aligned.
sure
> 
>> +
>> +    Collection Table Entry (CTE) layout: entry size = 8 bytes
>> +
>> +    bits:     | 63| 62 ..  52  | 51 ... 16 | 15  ...   0 |
>> +    values:   | V |    RES0    |  RDBase   |    ICID     |
>> +
>> +    Interrupt Translation Table Entry (ITTE) layout: entry size = 16 bytes
> 
> The actual name is Interrupt Translation Entry (ITE). I have a patch
> renaming this all over the vgic-its.c file...
ok
> 
>> +
>> +    bits:     | 63   ...  32  | 31 ... 17 | 16 | 15  ...  0 |
>> +    values:   |   DeviceID    |    RES0   | V  |    ICID    |
>> +
>> +    bits:     | 63 ...  32    | 31      ...        0 |
>> +    values:   |   pINTID      |        EventID       |
> 
> Same concern here. 32bit DevID, EventID and INTID seem a bit over the
> top. But maybe we shouldn't be concerned about memory... ;-)
So I would suggest encoding
16b DeviceId
16b eventid
16b collection ID
16b pINTID

bits:     | 63   ...  48  | 47 ... 32 | 31 ... 15 | 15  ...  0 |
values:   |   DeviceID    |   pINTID  |  EventId  |   ICID     |

a null pINTID would meen the ITE is invalid.

Does that make sense or should I instead reduce the number of bits
allocated to collections and keep the pINTID bit number larger?


> 
>> +
>> +    LPI Pending Table layout:
>> +
>> +    As specified in the ARM Generic Interrupt Controller Architecture
>> +    Specification GIC Architecture version 3.0 and version 4. The first
>> +    1kB contains only zeros.
>>
> 
> You definitely want to relax this. An ITS implementation is allowed (and
> actually encouraged) to maintain a coarse map in the first kB, and use
> this to quickly scan the table, which would be very useful on restore.
Maybe I miss something here. Currently I restore the ITEs before the
pending tables. So considering all the ITEs I know which LPI are defined
and which pending bits need to be restored. Why would I need to use a
coarse map for?

I understand the CPU cannot write the pending tables in our back, spec
says behavior would be unpredictable, right?

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
