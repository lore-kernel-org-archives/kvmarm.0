From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 01/22] KVM: arm/arm64: Add vITS save/restore API
 documentation
Date: Sat, 08 Apr 2017 11:03:51 +0100
Message-ID: <86y3vbcj20.fsf@arm.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-2-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1D3A40CE4
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Apr 2017 06:01:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xCB8dkMJLFSf for <kvmarm@lists.cs.columbia.edu>;
 Sat,  8 Apr 2017 06:01:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D34140CA2
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Apr 2017 06:01:51 -0400 (EDT)
In-Reply-To: <1490607072-21610-2-git-send-email-eric.auger@redhat.com> (Eric
 Auger's message of "Mon, 27 Mar 2017 11:30:51 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, vijayak@caviumnetworks.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 27 2017 at 10:30:51 AM, Eric Auger <eric.auger@redhat.com> wrote:
> Add description for how to access vITS registers and how to flush/restore
> vITS tables into/from memory
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
> v3 -> v4:
> - take into account Peter's comments:
>   - typos
>   - KVM_DEV_ARM_VGIC_GRP_ITS_TABLES kvm_device_attr = 0
>   - add a validity bit in DTE
>   - document all fields in CTE and ITE
>   - document ABI revision
> - take into account Andre's comments:
>   - document restrictions about GITS_CREADR writing and GITS_IIDR
>   - document -EBUSY error if one or more VCPUS are runnning
>   - document 64b registers only can be accessed with 64b access
> - itt_addr field matches bits [51:8] of the itt_addr
>
> v1 -> v2:
> - DTE and ITE now are 8 bytes
> - DTE and ITE now indexed by deviceid/eventid
> - use ITE name instead of ITTE
> - mentions ITT_addr matches bits [51:8] of the actual address
> - mentions LE layout
> ---
>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 118 +++++++++++++++++++++
>  1 file changed, 118 insertions(+)
>
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> index 6081a5b..0902d20 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> @@ -36,3 +36,121 @@ Groups:
>      -ENXIO:  ITS not properly configured as required prior to setting
>               this attribute
>      -ENOMEM: Memory shortage when allocating ITS internal data
> +
> +  KVM_DEV_ARM_VGIC_GRP_ITS_REGS
> +  Attributes:
> +      The attr field of kvm_device_attr encodes the offset of the
> +      ITS register, relative to the ITS control frame base address
> +      (ITS_base).
> +
> +      kvm_device_attr.addr points to a __u64 value whatever the width
> +      of the addressed register (32/64 bits). 64 bit registers can only
> +      be accessed with full length.
> +
> +      Writes to read-only registers are ignored by the kernel except for:
> +      - GITS_READR. It needs to be restored otherwise commands in the queue
> +        will be re-executed after CWRITER setting. Writing this register is
> +        allowed if the ITS is not enabled (GITS_CTLR.enable = 0). Also it
> +        needs to be restored after GITS_CBASER since a write to GITS_CBASER
> +        resets GITS_CREADR.
> +      - GITS_IIDR. Its Revision field encodes the table layout ABI revision.
> +
> +      For other registers, getting or setting a register has the same
> +      effect as reading/writing the register on real hardware.
> +  Errors:
> +    -ENXIO: Offset does not correspond to any supported register
> +    -EFAULT: Invalid user pointer for attr->addr
> +    -EINVAL: Offset is not 64-bit aligned
> +    -EBUSY: one or more VCPUS are running
> +
> +  KVM_DEV_ARM_VGIC_GRP_ITS_TABLES
> +  Attributes
> +       The attr field of kvm_device_attr must be zero.
> +
> +       request the flush-save/restore of the ITS tables, namely
> +       the device table, the collection table, all the ITT tables,
> +       the LPI pending tables. On save, the tables are flushed
> +       into guest memory at the location provisioned by the guest
> +       in GITS_BASER (device and collection tables), in the MAPD
> +       command (ITT_addr), GICR_PENDBASERs (pending tables).

May I echo Andre's concern here? Seeing the GICR_PENDBASER registers
here feels wrong. The pending table is a redistributor concept, and is
local to it. Even more, it is perfectly possible to use the
redistributors (and its pending tables) without an ITS by using the
GICR_SETLPIR registers.

Granted, we do not support this (and I'm *not* looking forward to
supporting it), but I would rather implement a redistributor flush than
using the ITS to indirectly force it. That's not how the HW works, and I
don't think we should deviate from it.

I appreciate this brings additional complexity to userspace (having to
iterate over the vcpus or the redistributors is likely more costly than
hitting the ITS which is likely to be unique), but sticking to the
letter of the architecture is probably our best bet. Each time we tried
to deviate from it, we've had to backtrack (and I'm using the royal "we"
here).

Any chance you could revisit this aspect?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
