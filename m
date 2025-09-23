Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021A62E7F39
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 16:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644487; cv=none; b=Owgwq+qcUBKj2B1u45aFf4NJGEuuKpe4iB23gTdlAIqUcGj92VNa1DwcHAsW3LjdNI909But3FCY/gT1ulvogB7vPhadXoO3wtlPXKQwU20v1ymHjPcF34OXF8aqOXxCRNfMraasGoecizNNhAje4ojJlDOEBlTslxAA/F6SosQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644487; c=relaxed/simple;
	bh=BhQPNjONdoE+7ilTpDDFABWglhl8U6mMn7Ekr60/kI8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=abTkswd/5rE/+TfuUjdkUa4wnb1+x+LrLYcRadLsu7Pm6UtxEx6cDgfz7unDIuF9iNLvzNFWiyJvbqLYAb++9xs4ZYppwENJK5+n7l4iqzqbng/Dr/qvy98RtITf45aZ9UDQDyL7ANCWedsoD7lM5cPOC/u4KiHwgq0ltqAlrmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26597497;
	Tue, 23 Sep 2025 09:21:17 -0700 (PDT)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B5FD3F694;
	Tue, 23 Sep 2025 09:21:24 -0700 (PDT)
Date: Tue, 23 Sep 2025 17:21:15 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Will Deacon <will@kernel.org>, Julien Thierry
 <julien.thierry.kdev@gmail.com>, Marc Zyngier <maz@kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH kvmtool v3 6/6] arm64: Generate HYP timer interrupt
 specifiers
Message-ID: <20250923172115.4a739ac5@donnerap.manchester.arm.com>
In-Reply-To: <aJDIG8cJQjzbwj3w@raptor>
References: <20250729095745.3148294-1-andre.przywara@arm.com>
	<20250729095745.3148294-7-andre.przywara@arm.com>
	<aJDIG8cJQjzbwj3w@raptor>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 Aug 2025 15:47:55 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> On Tue, Jul 29, 2025 at 10:57:45AM +0100, Andre Przywara wrote:
> > From: Marc Zyngier <maz@kernel.org>
> > 
> > FEAT_VHE introduced a non-secure EL2 virtual timer, along with its
> > interrupt line. Consequently the arch timer DT binding introduced a fifth
> > interrupt to communicate this interrupt number.
> > 
> > Refactor the interrupts property generation code to deal with a variable
> > number of interrupts, and forward five interrupts instead of four in case
> > nested virt is enabled.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arm64/arm-cpu.c           |  4 +---
> >  arm64/include/kvm/timer.h |  2 +-
> >  arm64/timer.c             | 29 ++++++++++++-----------------
> >  3 files changed, 14 insertions(+), 21 deletions(-)
> > 
> > diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
> > index 1e456f2c6..abdd6324f 100644
> > --- a/arm64/arm-cpu.c
> > +++ b/arm64/arm-cpu.c
> > @@ -12,11 +12,9 @@
> >  
> >  static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
> >  {
> > -	int timer_interrupts[4] = {13, 14, 11, 10};
> > -
> >  	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip,
> >  				kvm->cfg.arch.nested_virt);
> > -	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
> > +	timer__generate_fdt_nodes(fdt, kvm);
> >  	pmu__generate_fdt_nodes(fdt, kvm);
> >  }
> >  
> > diff --git a/arm64/include/kvm/timer.h b/arm64/include/kvm/timer.h
> > index 928e9ea7a..81e093e46 100644
> > --- a/arm64/include/kvm/timer.h
> > +++ b/arm64/include/kvm/timer.h
> > @@ -1,6 +1,6 @@
> >  #ifndef ARM_COMMON__TIMER_H
> >  #define ARM_COMMON__TIMER_H
> >  
> > -void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs);
> > +void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm);
> >  
> >  #endif /* ARM_COMMON__TIMER_H */
> > diff --git a/arm64/timer.c b/arm64/timer.c
> > index 861f2d994..2ac6144f9 100644
> > --- a/arm64/timer.c
> > +++ b/arm64/timer.c
> > @@ -5,31 +5,26 @@
> >  #include "kvm/timer.h"
> >  #include "kvm/util.h"
> >  
> > -void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs)
> > +void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm)
> >  {
> >  	const char compatible[] = "arm,armv8-timer\0arm,armv7-timer";
> >  	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
> > -	u32 irq_prop[] = {
> > -		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
> > -		cpu_to_fdt32(irqs[0]),
> > -		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
> > +	int irqs[5] = {13, 14, 11, 10, 12};
> > +	int nr = ARRAY_SIZE(irqs);
> > +	u32 irq_prop[nr * 3];
> >  
> > -		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
> > -		cpu_to_fdt32(irqs[1]),
> > -		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
> > +	if (!kvm->cfg.arch.nested_virt)
> > +		nr--;  
> 
> I'm confused.
> 
> FEAT_VHE introduced the EL2 virtual timer, and my interpretation of the Arm ARM
> is that the EL2 virtual timer is present if an only if FEAT_VHE:
> 
> "In an implementation of the Generic Timer that includes EL3, if EL3 can use
> AArch64, the following timers are implemented:
> [..]
> * When FEAT_VHE is implemented, a Non-secure EL2 virtual timer."
> 
> Is my interpretation correct?
> 
> KVM doesn't allow FEAT_VHE and FEAT_E2H0 to coexist (in
> nested.c::limit_nv_id_reg()), to force E2H to be RES0. Assuming my interpretion
> is correct, shouldn't the check be:

Even at the risk of going even deeper into that nitpicking rabbit hole:
"If FEAT_E2H0 is implemented, then FEAT_VHE is implemented."
So we have that timer, regardless of FEAT_E2H0, and regardless of whether
HCR_EL2.E2H is actually 0 or 1?
And indeed the configuration stanza and the pseudocode in "D24.10.9
CNTHV_CTL_EL2, Counter-timer Virtual Timer Control Register (EL2)" do not
mention SCR_EL2.E2H0 at all, just FEAT_VHE.

Cheers,
Andre

> 	if (!kvm->cfg.arch.nested_virt || kvm->cfg.arch.e2h0)
> 		nr--;
> 
> Thanks,
> Alex
> 
> >  
> > -		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
> > -		cpu_to_fdt32(irqs[2]),
> > -		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
> > -
> > -		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
> > -		cpu_to_fdt32(irqs[3]),
> > -		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
> > -	};
> > +	for (int i = 0; i < nr; i++) {
> > +		irq_prop[i * 3 + 0] = cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
> > +		irq_prop[i * 3 + 1] = cpu_to_fdt32(irqs[i]);
> > +		irq_prop[i * 3 + 2] = cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW);
> > +	}
> >  
> >  	_FDT(fdt_begin_node(fdt, "timer"));
> >  	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
> > -	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
> > +	_FDT(fdt_property(fdt, "interrupts", irq_prop, nr * 3 * sizeof(irq_prop[0])));
> >  	_FDT(fdt_property(fdt, "always-on", NULL, 0));
> >  	if (kvm->cfg.arch.force_cntfrq > 0)
> >  		_FDT(fdt_property_cell(fdt, "clock-frequency", kvm->cfg.arch.force_cntfrq));
> > -- 
> > 2.25.1
> >   

