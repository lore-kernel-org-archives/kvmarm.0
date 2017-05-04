From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v6 01/24] KVM: arm/arm64: Add ITS save/restore API
 documentation
Date: Thu, 4 May 2017 18:52:39 +0200
Message-ID: <20170504165239.GR5923@cbox>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-2-git-send-email-eric.auger@redhat.com>
 <20170504132321.GN5923@cbox>
 <8acbd1b6-0fbe-a9d4-6495-b48e07ca9108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9550240948
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 12:49:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eYaxa9gvyT9l for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 12:49:36 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 233B940905
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 12:49:36 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id w64so2305430wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 May 2017 09:52:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <8acbd1b6-0fbe-a9d4-6495-b48e07ca9108@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 04:50:23PM +0200, Auger Eric wrote:
> Hi,
> 
> On 04/05/2017 15:23, Christoffer Dall wrote:
> > On Thu, May 04, 2017 at 01:44:21PM +0200, Eric Auger wrote:
> >> Add description for how to access ITS registers and how to save/restore
> >> ITS tables into/from memory.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >> v5 -> v6:
> >> - add restoration ordering
> >> - 256B -> 256 Byte aligned
> >> - DTE Size is number of bits for the EVENTID
> >> - s/GITS_READR/GITS_CREADR
> >>
> >> v4 -> v5:
> >> - take into account Christoffer's comments
> >> - pending table save on GICV3 side now
> >>
> >> v3 -> v4:
> >> - take into account Peter's comments:
> >>   - typos
> >>   - KVM_DEV_ARM_VGIC_GRP_ITS_TABLES kvm_device_attr = 0
> >>   - add a validity bit in DTE
> >>   - document all fields in CTE and ITE
> >>   - document ABI revision
> >> - take into account Andre's comments:
> >>   - document restrictions about GITS_CREADR writing and GITS_IIDR
> >>   - document -EBUSY error if one or more VCPUS are runnning
> >>   - document 64b registers only can be accessed with 64b access
> >> - itt_addr field matches bits [51:8] of the itt_addr
> >>
> >> v1 -> v2:
> >> - DTE and ITE now are 8 bytes
> >> - DTE and ITE now indexed by deviceid/eventid
> >> - use ITE name instead of ITTE
> >> - mentions ITT_addr matches bits [51:8] of the actual address
> >> - mentions LE layout
> >> ---
> >>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 117 +++++++++++++++++++++
> >>  1 file changed, 117 insertions(+)
> >>
> >> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> >> index 6081a5b..863c359 100644
> >> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> >> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> >> @@ -32,7 +32,124 @@ Groups:
> >>      KVM_DEV_ARM_VGIC_CTRL_INIT
> >>        request the initialization of the ITS, no additional parameter in
> >>        kvm_device_attr.addr.
> >> +
> >> +    KVM_DEV_ARM_ITS_SAVE_TABLES
> >> +      save the ITS table data into guest RAM, at the location provisioned
> >> +      by the guest in corresponding registers/table entries.
> >> +
> >> +      The layout of the tables in guest memory defines an ABI. The entries
> >> +      are laid out in little endian format as described in the last paragraph.
> >> +
> >> +    KVM_DEV_ARM_ITS_RESTORE_TABLES
> >> +      restore the ITS tables from guest RAM to ITS internal structures.
> >> +
> >> +      The GICV3 must be restored before the ITS and all ITS registers but
> >> +      the GITS_CTLR must be restored before restoring the ITS tables.
> >> +
> >> +      The GITS_IIDR read-only register must also be restored before
> >> +      the table restore as the IIDR revision field encodes the ABI revision.
> > 
> > the table restore?  "before calling KVM_DEV_ARM_ITS_RESTORE_TABLES" ?
> > (there's a potential confusion between calling this ioctl and simply
> > restoring the memory containing the tables).
> OK
> > 
> >> +
> >> +      The expected ordering when restoring the GICv3/ITS is described in section
> >> +      "ITS Restoration Sequence".
> >> +
> >>    Errors:
> >>      -ENXIO:  ITS not properly configured as required prior to setting
> >>               this attribute
> >>      -ENOMEM: Memory shortage when allocating ITS internal data
> >> +    -EINVAL: Inconsistent restored data
> >> +    -EFAULT: Invalid guest ram access
> >> +    -EBUSY:  One or more VCPUS are running
> >> +
> >> +  KVM_DEV_ARM_VGIC_GRP_ITS_REGS
> >> +  Attributes:
> >> +      The attr field of kvm_device_attr encodes the offset of the
> >> +      ITS register, relative to the ITS control frame base address
> >> +      (ITS_base).
> >> +
> >> +      kvm_device_attr.addr points to a __u64 value whatever the width
> >> +      of the addressed register (32/64 bits). 64 bit registers can only
> >> +      be accessed with full length.
> >> +
> >> +      Writes to read-only registers are ignored by the kernel except for:
> >> +      - GITS_CREADR. It needs to be restored otherwise commands in the queue
> >> +        will be re-executed after restoring CWRITER. GITS_CREADR must be
> >> +        restored before restoring the GITS_CTLR which is likely to enable the
> >> +        ITS. Also it needs to be restored after GITS_CBASER since a write to
> >> +        GITS_CBASER resets GITS_CREADR.
> > 
> > uber nit: s/needs to be/must be/g in all occurences above.
> OK
> > 
> >> +      - GITS_IIDR. Its Revision field encodes the table layout ABI revision.
> > 
> > s/Its/The/
> OK. Argh, I meant its (~his) ;-)

You wrote it correctly, it's just that it can be misleading, so I'm
really in the business of beutifying the ABI text here :)

> > the revision of the table layout ABI.
> > 
> >> +        In the future we might implement direct injection of virtual LPIS.
> > 
> > LPIs
> OK
> > 
> >> +        This will require an upgrade of the table layout and an evolution of
> >> +        the ABI. GITS_IIDR must be restored before the table restoration.
> > 
> > before calling KVM_DEV_ARM_ITS_RESTORE_TABLES.
> OK
> > 
> >> +
> >> +      For other registers, getting or setting a register has the same
> >> +      effect as reading/writing the register on real hardware.
> >> +  Errors:
> >> +    -ENXIO: Offset does not correspond to any supported register
> >> +    -EFAULT: Invalid user pointer for attr->addr
> >> +    -EINVAL: Offset is not 64-bit aligned
> >> +    -EBUSY: one or more VCPUS are running
> >> +
> >> + ITS Restoration Sequence:
> > 
> > s/Restoration/restore/
> OK
> > 
> >> + -------------------------
> >> +
> >> +The following ordering must be followed when restoring the GIC and the ITS:
> >> +a) restore all guest memory and create vcpus
> >> +b) initialize the GIC and ITS (KVM_DEV_ARM_VGIC_CTRL_INIT)
> > 
> > are these really coupled or can you do everything related to the gic
> > first, and then everything related to the ITS afterwards?
> no they aren't.
> 
> > 
> >> +c) provide GIC and ITS base addresses (KVM_DEV_ARM_VGIC_GRP_ADDR)
> > 
> > same
> no they aren't
> 
> 
> > 
> >> +d) restore all redistributors
> >> +e) restore the ITS in the following order:
> >> +   1. Restore GITS_CBASER
> >> +   2. Restore all other GITS_ registers, except GITS_CTLR!
> >> +   3. Load the ITS table data (KVM_DEV_ARM_ITS_RESTORE_TABLES)
> >> +   4. Restore GITS_CTLR
> >> +f) start vcpus
> > 
> > I would omit (f) from here.
> 
> In that case I think it would make sense to describe the restore
> sequence for GICV3 RDIST in GICV3 device doc and not here. This would
> alleviate this very description.
> 
> restoring RDIST regs require a previous GICV3 KVM_DEV_ARM_VGIC_CTRL_INIT
> and KVM_DEV_ARM_VGIC_GRP_ADDR I think.
> 
> So description here would become
> 
> "
> a) restore all guest memory and create vcpus
> b) restore all redistributors
> c) initialize the ITS and then provide its base address    	
> (KVM_DEV_ARM_VGIC_CTRL_INIT, KVM_DEV_ARM_VGIC_GRP_ADDR)
> c) restore the ITS in the following order:
> 	1. Restore GITS_CBASER
> 	2. Restore all other GITS_ registers, except GITS_CTLR!
> 	3. Load the ITS table data (KVM_DEV_ARM_ITS_RESTORE_TABLES)
> 	4. Restore GITS_CTLR
> 
> Then vcpus can be started.
> "
> 
> What do you think?

Yes, looks good.

> 
> 
> > 
> >> +
> >> + ITS Table ABI REV0:
> >> + -------------------
> >> +
> >> + Revision 0 of the ABI only supports physical LPIs.
> >> +
> >> + The device table and ITT are indexed by the deviceid and eventid,
> >> + respectively. The collection table is not indexed by collectionid:
> >> + CTE are written in the table in the order of collection creation. All
> > 
> > nit: CTEs
> OK
> > 
> >> + entries are 8 bytes.
> >> +
> >> + Device Table Entry (DTE):
> >> +
> >> + bits:     | 63| 62 ... 49 | 48 ... 5 | 4 ... 0 |
> >> + values:   | V |   next    | ITT_addr |  Size   |
> >> +
> >> + where;
> >> + - V indicates whether the entry is valid. If not, other fields
> >> +   are not meaningful.
> >> + - next: equals to 0 if this entry is the last one; otherwise it
> >> +   corresponds to the deviceid offset to the next DTE, capped by
> >> +   2^14 -1.
> >> + - ITT_addr matches bits [51:8] of the ITT address (256 Byte aligned).
> >> + - Size specifies the supported number of bits for the eventid,
> >> +   minus one
> >> +
> >> + Collection Table Entry (CTE):
> >> +
> >> + bits:     | 63| 62 ..  52  | 51 ... 16 | 15  ...   0 |
> >> + values:   | V |    RES0    |  RDBase   |    ICID     |
> >> +
> >> + where:
> >> + - V indicates whether the entry is valid. If not, other fields are
> >> +   not meaningful.
> >> + - RES0: reserved field with Should-Be-Zero-or-Preserved behavior.
> >> + - RDBase is the PE number (GICR_TYPER.Processor_Number semantic),
> >> + - ICID is the collection ID
> >> +
> >> + Interrupt Translation Entry (ITE):
> >> +
> >> + bits:     | 63 ... 48 | 47 ... 16 | 15 ... 0 |
> >> + values:   |    next   |   pINTID  |  ICID    |
> >> +
> >> + where:
> >> + - next: equals to 0 if this entry is the last one; otherwise it corresponds
> >> +   to the eventid offset to the next ITE capped by 2^16 -1.
> >> + - pINTID is the physical LPI ID; if zero, it means the entry is not valid
> >> +   and other fields are not meaningful.
> >> + - ICID is the collection ID
> >> +
> >> -- 
> >> 2.5.5
> >>
> > 
> > The only outstanding issue here is the restore order part.  I don't wont
> > to specify a stronger order than absolutely necessary here.
> see above
> 

Yep, I think we're there.

Thanks,
-Christoffer
