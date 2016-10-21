From: Andrew Jones <drjones@redhat.com>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 15:06:39 +0200
Message-ID: <20161021130639.6kxvi73kmagf2gwu@kamzik.brq.redhat.com>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
 <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
 <99c7d3b5-0495-083f-b4b7-b58b20cf859e@redhat.com>
 <5a5e4ed5-a575-f720-36f0-acb545a170f4@arm.com>
 <e52f2867-102f-8aad-4815-2a682586f129@redhat.com>
 <20161021114951.gm3u6msvl4jz2kv7@kamzik.brq.redhat.com>
 <CAFEAcA-K+Fnw7Fwh3tK0nqLxhUrtLB7XrJVtswXwTb7d2X+Y+Q@mail.gmail.com>
 <20161021120732.bl5p5vji25zibap3@kamzik.brq.redhat.com>
 <bf32d77e-93e1-c943-e6b6-953b3d8c9e20@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bf32d77e-93e1-c943-e6b6-953b3d8c9e20@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Auger Eric <eric.auger@redhat.com>, Daniel Thompson <daniel.thompson@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Robert Richter <robert.richter@caviumnetworks.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 21, 2016 at 01:52:43PM +0100, Marc Zyngier wrote:
> On 21/10/16 13:07, Andrew Jones wrote:
> > On Fri, Oct 21, 2016 at 12:57:37PM +0100, Peter Maydell wrote:
> >> On 21 October 2016 at 12:49, Andrew Jones <drjones@redhat.com> wrote:
> >>> I also read the register before writing it and saw it was 3. I tried
> >>> writing 3 instead of 0 to see what would happen, but the failure
> >>> persisted. I did read back the register after writing it to confirm the
> >>> change took affect.
> >>
> >> So what does it read back as after you write 0? The GICv3 spec
> >> says it can't read back as zero...
> >>
> > 
> > I read back zero
> > 
> > pre-read  bpr1=3
> > post-read bpr1=0
> > FAIL: gicv3: ipi: self: Timed-out (5s). ACKS: missing=1 extra=0 unexpected=0
> 
> Gah... I guess we'll have to either roll a dice, or get someone from
> Cavium to tell us what's happening here. In the meantime, can you give
> the following patch a go? It doesn't fire on my FSL box, but everything
> hunky dory on it so far...
> 
> Thanks,
> 
> 	M.
> 
> diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
> index a808829..5c03171 100644
> --- a/arch/arm/include/asm/arch_gicv3.h
> +++ b/arch/arm/include/asm/arch_gicv3.h
> @@ -222,6 +222,11 @@ static inline void gic_write_bpr1(u32 val)
>  	write_sysreg(val, ICC_BPR1);
>  }
>  
> +static inline u32 gic_write_bpr1(void)
> +{
> +	return read_sysreg(ICC_BPR1);
> +}
> +
>  /*
>   * Even in 32bit systems that use LPAE, there is no guarantee that the I/O
>   * interface provides true 64bit atomic accesses, so using strd/ldrd doesn't
> diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
> index f8ae6d6..74fe2c9 100644
> --- a/arch/arm64/include/asm/arch_gicv3.h
> +++ b/arch/arm64/include/asm/arch_gicv3.h
> @@ -184,6 +184,13 @@ static inline void gic_write_bpr1(u32 val)
>  	asm volatile("msr_s " __stringify(ICC_BPR1_EL1) ", %0" : : "r" (val));
>  }
>  
> +static inline u32 gic_read_bpr1(void)
> +{
> +	u64 val;
> +	asm volatile("mrs_s %0, " __stringify(ICC_BPR1_EL1) : "=r" (val));
> +	return val;
> +}
> +
>  #define gic_read_typer(c)		readq_relaxed(c)
>  #define gic_write_irouter(v, c)		writeq_relaxed(v, c)
>  
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 9b81bd8..db90286 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -482,6 +482,8 @@ static int gic_populate_rdist(void)
>  
>  static void gic_cpu_sys_reg_init(void)
>  {
> +	u32 bpr1_old, bpr1_new;
> +
>  	/*
>  	 * Need to check that the SRE bit has actually been set. If
>  	 * not, it means that SRE is disabled at EL2. We're going to
> @@ -499,9 +501,19 @@ static void gic_cpu_sys_reg_init(void)
>  	 * Some firmwares hand over to the kernel with the BPR changed from
>  	 * its reset value (and with a value large enough to prevent
>  	 * any pre-emptive interrupts from working at all). Writing a zero
> -	 * to BPR restores is reset value.
> +	 * to BPR restores is reset value (though there seems to be some
> +	 * less than compliant implementations around, hence the warning...).
>  	 */
> +	bpr1_old = gic_read_bpr1();
>  	gic_write_bpr1(0);
> +	isb();
> +	bpr1_new = gic_read_bpr1();
> +
> +	if (bpr1_new == 0) {
> +		pr_warn("Failed to reset BPR1 (%d), restoring previous (%d)\n",
> +			bpr1_new, bpr1_old);
> +		gic_write_bpr1(bpr1_old);
> +	}
>  
>  	if (static_key_true(&supports_deactivate)) {
>  		/* EOI drops priority only (mode 1) */
>

FWIW, the equivalent implementation didn't help kvm-unit-tests. Still
timing-out. Even after attempting to set it back to old, which was 3,
when I read it again I still get zero,

pre-read  bpr1=3
post-read bpr1=0
new = 0, old = 3
resetting to old and doing post-post-read...
post-post-read bpr1=0
FAIL: gicv3: ipi: self: Timed-out (5s). ACKS: missing=1 extra=0 unexpected=0


drew 
