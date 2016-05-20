From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3] KVM: arm/arm64: Add VGICv3 save/restore API
 documentation
Date: Fri, 20 May 2016 16:11:06 +0200
Message-ID: <20160520141106.GA10370@cbox>
References: <1463150637-6896-1-git-send-email-christoffer.dall@linaro.org>
 <5735ED2F.4030104@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5735ED2F.4030104@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Peter Maydell <peter.maydell@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

[turns out I did have a few questions]

On Fri, May 13, 2016 at 04:05:19PM +0100, Marc Zyngier wrote:
> On 13/05/16 15:43, Christoffer Dall wrote:

[...]

> > +
> > +  KVM_DEV_ARM_VGIC_CPU_SYSREGS
> > +  Attributes:
> > +    The attr field of kvm_device_attr encodes two values:
> > +    bits:     | 63      ....       32 | 31  ....  16 | 15  ....  0 |
> > +    values:   |         mpidr         |      RES     |    instr    |
> > +
> > +    The mpidr field encodes the CPU ID based on the affinity information in the
> > +    architecture defined MPIDR, and the field is encoded as follows:
> > +      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
> > +      |    Aff3    |    Aff2    |    Aff1    |    Aff0   |
> > +
> > +    The instr field encodes the system register to access based on the fields
> > +    defined in the A64 instruction set encoding for system register access
> > +    (RES means the bits are reserved for future use and should be zero):
> 
> Should we call this field RES0 in order to match the various
> architecture documents?
> 

I define this below, so I don't think this is hugely important.  If you
think it clarifies things, I can fix it.

> > +
> > +      | 15 ... 14 | 13 ... 11 | 10 ... 7 | 6 ... 3 | 2 ... 0 |
> > +      |   Op 0    |    Op1    |    CRn   |   CRm   |   Op2   |
> > +
> > +    All system regs accessed through this API are (rw, 64-bit) and
> > +    kvm_device_attr.addr points to a __u64 value.
> > +
> > +    KVM_DEV_ARM_VGIC_CPU_SYSREGS accesses the CPU interface registers for the
> > +    CPU specified by the mpidr field.
> > +
> > +
> > +  Limitations:
> > +    - Priorities are not implemented, and registers are RAZ/WI
> 
> Is that still true? We should also document the lack of Group0 support.
> 

The priorities limiation must go out.  Not sure why we need to document
the lack of Group0 support on the user api?  Isn't that a strictly
internal limitation, but unlrelated to getting/setting the userspace
state?


Thanks,
-Christoffer
