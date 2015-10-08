From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 08 Oct 2015 12:10:35 +0300
Message-ID: <005e01d101a9$31ee80f0$95cb82d0$@samsung.com>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
 <003a01d10199$58e96590$0abc30b0$@samsung.com> <20151008082302.GE14315@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151008082302.GE14315@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 'Andre Przywara' <andre.przywara@arm.com>, 'Peter Maydell' <peter.maydell@linaro.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> >  One concern about this... Does it already have "We are Bosses, we Decided it, It's not
> subject to
> > change, We do not care" status?
> 
> That's a rather negative question.

 Sorry, didn't want to offend anyone. I just wanted to tell that i know that you, as maintainers,
have much more power than i do, and you can always say "it's political decision, we just want it and
that's final", and if you choose to do this, i'm perfectly OK with that, just say it.

> The architecture defines how to address a specific CPU, and that's using
> the MPIDR, not inventing our own scheme, so that's what we should do.

 But doesn't the same apply to GICv2 then? It just happened so that we had Aff0 == idx, therefore
looks like nobody cared.
 My argument is to have GICv3 API as similar to GICv2 as possible, IMHO that would make it easier to
maintain the code, and perhaps give some way to reusing it.

> For example, I don't think you had the full 32-bits available to address
> a CPU in your proposal, so if nothing else, that proposal had less
> expressive power than what the architecture defines.

 My proposal was:

--- cut ---
  KVM_DEV_ARM_VGIC_GRP_DIST_REGS
  Attributes:
    The attr field of kvm_device_attr encodes two values:
    bits:     |  63  | 62 .. 52 | 51 ..  32  |  31   ....    0 |
    values:   | size | reserved |  cpu idx   |      offset     |

    All distributor regs can be accessed as (rw, 32-bit)
    For GICv3 some regsisters are actually (rw, 64-bit) according to the
    specification. In order to perform full 64-bit access 'size' bit should be
    set to 1. KVM_DEV_ARM_VGIC_64BIT flag value is provided for this purpose.
--- cut ---

 Bit 63 was meant to specify access size (u64 or u32), and bits 62 - 52 were reserved just in order
to match ARM64_SYS_REG() macro, which uses these bits for own purpose.

 But, since your proposal suggests that all GICv3 accesses are 64-bit wide, and we use own system
register encoding (i don't see any serious problems with this), it is possible just to use bits
63...32 for vCPU index. So, maximum number of CPUs would be the same 0xFFFFFFFF as in your proposal,
and the API would be fully compatible with GICv2 one (well, except access size), and we would use
the same definitions and the same approach to handle both. This would bring more consistency and
less confusion to userspace developers who use the API.

 By the way, the rest of KVM API (KVM_IRQ_LINE, for example), also uses vCPU index.

 That's all my arguments for vCPU index instead of affinity value, and if you say "that doesn't
count, we don't have to be compatible with GICv2", i'll accept this and proceed with the rewrite.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


