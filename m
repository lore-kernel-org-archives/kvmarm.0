From: Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH 01/12] KVM: arm/arm64: vgic: Remove spurious call to
 kern_hyp_va
Date: Tue, 12 Dec 2017 11:53:04 +0000
Message-ID: <20171212115304.abzvemzihyeasasz@capper-debian.cambridge.arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
 <20171204141313.31604-2-steve.capper@arm.com>
 <d8a26134-52e2-0800-542f-603c6e8347c7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4B8040D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 06:49:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DG426IiCZS6H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Dec 2017 06:49:44 -0500 (EST)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01on0050.outbound.protection.outlook.com [104.47.1.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2A3E406D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 06:49:43 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <d8a26134-52e2-0800-542f-603c6e8347c7@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, James Morse <james.morese@arm.com>, nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 04, 2017 at 02:30:28PM +0000, Suzuki K Poulose wrote:
> On 04/12/17 14:13, Steve Capper wrote:
> > In save_elrsr(.), we use the following technique to ascertain the
> > address of the vgic global state:
> > 	(kern_hyp_va(&kvm_vgic_global_state))->nr_lr
> > 
> > For arm, kern_hyp_va(va) == va, and this call effectively compiles out.
> > 
> > For arm64, this call can be spurious as the address of kvm_vgic_global_state
> > will usually be determined by relative page/absolute page offset relocation
> > at link time. As the function is idempotent, having the call for arm64 does
> > not cause any problems.
> > 
> > Unfortunately, this is about to change for arm64 as we need to change
> > the logic of kern_hyp_va to allow for kernel addresses that are outside
> > the direct linear map.
> > 
> > This patch removes the call to kern_hyp_va, and ensures that correct
> > HYP addresses are computed via relative page offset addressing on arm64.
> > This is achieved by a custom accessor, hyp_address(.), which on arm is a
> > simple reference operator.
> 
> minor nit: I somehow feel that there word "symbol" should be part of the name of
> the macro, to make it implicit that it can only be used on a symbol and not any
> generic variable.
> 
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index 08d3bb66c8b7..34a4ae906a97 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -25,6 +25,16 @@
> >   #define __hyp_text __section(.hyp.text) notrace
> > +#define hyp_address(symbol)				\
> > +({							\
> > +	typeof(&symbol) __ret;				\
> > +	asm volatile(					\
> > +	"adrp %[ptr], " #symbol	"\n"			\
> > +	"add %[ptr], %[ptr], :lo12:" #symbol "\n"	\
> > +	: [ptr] "=r"(__ret));				\
> > +	__ret;						\
> > +})
> > +
> 
> > -	addr  = kern_hyp_va((kern_hyp_va(&kvm_vgic_global_state))->vcpu_base_va);
> > +	addr  = kern_hyp_va(hyp_address(kvm_vgic_global_state)->vcpu_base_va);
> 
> e.g, Like here, why do we use hyp_address only for the kvm_vgic_global_state and not
> the dereferenced value. Having a name, say, hyp_symbol_address() makes it clear.
> 
> Otherwise, looks good to me.
> 

Thanks Suzuki,
Marc Zyngier has a similar patch in his series:
KVM/arm64: Randomise EL2 mappings

I'll refactor my series to apply on top of Marc's
(and take advantage of the simiplified HYP logic)

Cheers,
-- 
Steve
