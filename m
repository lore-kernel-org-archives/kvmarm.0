From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 24/37] KVM: arm64: Prepare to handle traps on deferred
 EL0 sysregs
Date: Sun, 3 Dec 2017 20:51:45 +0100
Message-ID: <20171203195145.GJ4218@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-25-christoffer.dall@linaro.org>
 <ff71a471-4a16-806c-c355-15bf778c7d98@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ff71a471-4a16-806c-c355-15bf778c7d98@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 15, 2017 at 09:25:08AM +0000, Julien Thierry wrote:
> 
> 
> On 12/10/17 11:41, Christoffer Dall wrote:
> >We can trap access to ACTLR_EL1 which we can later defer to only
> >save/restore during vcpu_load and vcpu_put, so let's read the value
> >directly from the CPU when necessary.
> >
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >---
> >  arch/arm64/kvm/sys_regs_generic_v8.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> >diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
> >index 969ade1..348f227 100644
> >--- a/arch/arm64/kvm/sys_regs_generic_v8.c
> >+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
> >@@ -38,7 +38,10 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
> >  	if (p->is_write)
> >  		return ignore_write(vcpu, p);
> >-	p->regval = vcpu_sys_reg(vcpu, ACTLR_EL1);
> >+	if (vcpu->arch.sysregs_loaded_on_cpu)
> >+		read_sysreg(actlr_el1);
> 
> Did you mean "p->regval = read_sysreg(actlr_el1);" ?
> 
> >+	else
> >+		p->regval = vcpu_sys_reg(vcpu, ACTLR_EL1);
> >  	return true;
> >  }
> >
> 

Yes, most certainly.  Nice catch.

Thanks,
-Christoffer
