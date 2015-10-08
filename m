From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 8 Oct 2015 11:28:58 +0200
Message-ID: <20151008092858.GA16100@cbox>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
 <003a01d10199$58e96590$0abc30b0$@samsung.com>
 <20151008082302.GE14315@cbox>
 <005e01d101a9$31ee80f0$95cb82d0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C7794155B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 05:26:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VbrpmuAqx0By for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 05:26:46 -0400 (EDT)
Received: from mail-lb0-f179.google.com (mail-lb0-f179.google.com
 [209.85.217.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C1D441338
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 05:26:45 -0400 (EDT)
Received: by lbcao8 with SMTP id ao8so40572651lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Oct 2015 02:28:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <005e01d101a9$31ee80f0$95cb82d0$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 08, 2015 at 12:10:35PM +0300, Pavel Fedin wrote:
>  Hello!
> 
[...]
> 
> > The architecture defines how to address a specific CPU, and that's using
> > the MPIDR, not inventing our own scheme, so that's what we should do.
> 
>  But doesn't the same apply to GICv2 then? It just happened so that we had Aff0 == idx, therefore
> looks like nobody cared.

I don't think it's about caring, but we (I) didn't consider it when
designing that API.

>  My argument is to have GICv3 API as similar to GICv2 as possible, IMHO that would make it easier to
> maintain the code, and perhaps give some way to reusing it.

Plenty of things are broken about the VGICv2 implementation and API, so
my goal is not to have GICv3 be similar to GICv2, but to design a good
API.

> 
> > For example, I don't think you had the full 32-bits available to address
> > a CPU in your proposal, so if nothing else, that proposal had less
> > expressive power than what the architecture defines.
> 
>  My proposal was:
> 
> --- cut ---
>   KVM_DEV_ARM_VGIC_GRP_DIST_REGS
>   Attributes:
>     The attr field of kvm_device_attr encodes two values:
>     bits:     |  63  | 62 .. 52 | 51 ..  32  |  31   ....    0 |
>     values:   | size | reserved |  cpu idx   |      offset     |
> 
>     All distributor regs can be accessed as (rw, 32-bit)
>     For GICv3 some regsisters are actually (rw, 64-bit) according to the
>     specification. In order to perform full 64-bit access 'size' bit should be
>     set to 1. KVM_DEV_ARM_VGIC_64BIT flag value is provided for this purpose.
> --- cut ---
> 
>  Bit 63 was meant to specify access size (u64 or u32), and bits 62 - 52 were reserved just in order
> to match ARM64_SYS_REG() macro, which uses these bits for own purpose.
> 
>  But, since your proposal suggests that all GICv3 accesses are 64-bit wide, and we use own system
> register encoding (i don't see any serious problems with this), it is possible just to use bits
> 63...32 for vCPU index. So, maximum number of CPUs would be the same 0xFFFFFFFF as in your proposal,
> and the API would be fully compatible with GICv2 one (well, except access size), and we would use
> the same definitions and the same approach to handle both. This would bring more consistency and
> less confusion to userspace developers who use the API.

I don't agree; using the same API with slightly different semantics
depending on which device you created is much more error prone than
having a clear separation between the two different APIs, IMHO.

> 
>  By the way, the rest of KVM API (KVM_IRQ_LINE, for example), also uses vCPU index.
> 
>  That's all my arguments for vCPU index instead of affinity value

I'm not convinced that we should be compatible with GICv2 at all.  (The
deeper argument here is that GICv2 had an architectural limitation to 8
CPUs so all the CPU addressing is simple in that case.  This is a
fundamental evolution from GICv2 to GICv3 so it is only natural that
there are substantial changes in this area.)

I'll let Marc or Peter chime in if they disagree.

>, and if you say "that doesn't
> count, we don't have to be compatible with GICv2", i'll accept this and proceed with the rewrite.
> 

Cool!

Thanks,
-Christoffer
