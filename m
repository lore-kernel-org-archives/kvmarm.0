From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 5/5] arm/arm64: KVM: Don't panic on failure to properly
 reset system registers
Date: Wed, 30 Jan 2019 10:51:02 +0100
Message-ID: <20190130095102.GG13482@e113682-lin.lund.arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-6-christoffer.dall@arm.com>
 <20190129163337.nbwivspcvlcmzrmo@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190129163337.nbwivspcvlcmzrmo@kamzik.brq.redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 29, 2019 at 05:33:37PM +0100, Andrew Jones wrote:
> On Fri, Jan 25, 2019 at 10:46:56AM +0100, Christoffer Dall wrote:
> > From: Marc Zyngier <marc.zyngier@arm.com>
> > 
> > Failing to properly reset system registers is pretty bad. But not
> > quite as bad as bringing the whole machine down... So warn loudly,
> > but slightly more gracefully.
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> > ---
> >  arch/arm/kvm/coproc.c     | 4 ++--
> >  arch/arm64/kvm/sys_regs.c | 4 ++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> > index 222c1635bc7a..e8bd288fd5be 100644
> > --- a/arch/arm/kvm/coproc.c
> > +++ b/arch/arm/kvm/coproc.c
> > @@ -1450,6 +1450,6 @@ void kvm_reset_coprocs(struct kvm_vcpu *vcpu)
> >  	reset_coproc_regs(vcpu, table, num);
> >  
> >  	for (num = 1; num < NR_CP15_REGS; num++)
> > -		if (vcpu_cp15(vcpu, num) == 0x42424242)
> > -			panic("Didn't reset vcpu_cp15(vcpu, %zi)", num);
> > +		WARN(vcpu_cp15(vcpu, num) == 0x42424242,
> > +		     "Didn't reset vcpu_cp15(vcpu, %zi)", num);
> >  }
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 86096774abcd..4f067545c7d2 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2609,6 +2609,6 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
> >  	reset_sys_reg_descs(vcpu, table, num);
> >  
> >  	for (num = 1; num < NR_SYS_REGS; num++)
> > -		if (__vcpu_sys_reg(vcpu, num) == 0x4242424242424242)
> > -			panic("Didn't reset __vcpu_sys_reg(%zi)", num);
> > +		WARN(__vcpu_sys_reg(vcpu, num) == 0x4242424242424242,
> > +		     "Didn't reset __vcpu_sys_reg(%zi)\n", num);
> >  }
> > -- 
> > 2.18.0
> >
> 
> If we only get halfway through resetting, then we'll get a warn splat,
> complete with a backtrace, for each register. Should we do something
> like the following instead?
> 
>   for (num = 1; num < NR_SYS_REGS; num++)
>      if (__vcpu_sys_reg(vcpu, num) == 0x4242424242424242)
>         failed++;
>   WARN(failed, "Didn't reset %d system registers", failed);
> 

I don't care stongly whichever way we do it, but when we actually saw
this, it seemed useful to see which system register was not initialized.

Thanks for the review.

    Christoffer
