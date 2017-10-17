From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 24/28] arm64/sve: KVM: Hide SVE from CPU features
 exposed to guests
Date: Tue, 17 Oct 2017 15:07:50 +0100
Message-ID: <20171017140749.GW19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-25-git-send-email-Dave.Martin@arm.com>
 <20171017135816.GF5886@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171017135816.GF5886@lvm>
Sender: linux-arch-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 06:58:16AM -0700, Christoffer Dall wrote:
> On Tue, Oct 10, 2017 at 07:38:41PM +0100, Dave Martin wrote:
> > KVM guests cannot currently use SVE, because SVE is always
> > configured to trap to EL2.
> > 
> > However, a guest that sees SVE reported as present in
> > ID_AA64PFR0_EL1 may legitimately expect that SVE works and try to
> > use it.  Instead of working, the guest will receive an injected
> > undef exception, which may cause the guest to oops or go into a
> > spin.
> > 
> > To avoid misleading the guest into believing that SVE will work,
> > this patch masks out the SVE field from ID_AA64PFR0_EL1 when a
> > guest attempts to read this register.  No support is explicitly
> > added for ID_AA64ZFR0_EL1 either, so that is still emulated as
> > reading as zero, which is consistent with SVE not being
> > implemented.
> > 
> > This is a temporary measure, and will be removed in a later series
> > when full KVM support for SVE is implemented.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index b1f7552..a0ee9b0 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/bsearch.h>
> >  #include <linux/kvm_host.h>
> >  #include <linux/mm.h>
> > +#include <linux/printk.h>
> >  #include <linux/uaccess.h>
> >  
> >  #include <asm/cacheflush.h>
> > @@ -897,8 +898,17 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> >  {
> >  	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> >  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> > +	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> >  
> > -	return raz ? 0 : read_sanitised_ftr_reg(id);
> > +	if (id == SYS_ID_AA64PFR0_EL1) {
> > +		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
> > +			pr_err_once("kvm [%i]: SVE unsupported for guests, suppressing\n",
> > +				    task_pid_nr(current));
> 
> nit: does this really qualify as an error print?

I have no strong opinion on this: maz suggested I should add this --
his concern was to make it difficult to ignore.

This is transitional: the main purpose is to circumvent bug reports from
people who find that SVE doesn't work in their guests, in the interim
before proper KVM support lands upstream.

Marc, do you still agree with this position?

> > +
> > +		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> > +	}
> > +
> > +	return val;
> >  }
> >  
> >  /* cpufeature ID register access trap handlers */
> > -- 
> > 2.1.4
> > 
> Otherwise:
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks -- I'll wait for Marc's response before applying.

Cheers
---Dave
