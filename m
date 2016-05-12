From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 36/55] KVM: arm/arm64: vgic-new: Add GICv3 IROUTER
 register handlers
Date: Thu, 12 May 2016 14:21:19 +0200
Message-ID: <20160512122119.GH27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-37-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D98DC49B3C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 08:17:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HHG0Hz8a+HvA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 08:17:44 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FA0049B36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 08:17:43 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id n129so257021737wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 05:20:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1462531568-9799-37-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 06, 2016 at 11:45:49AM +0100, Andre Przywara wrote:
> Since GICv3 supports much more than the 8 CPUs the GICv2 ITARGETSR
> register can handle, the new IROUTER register covers the whole range
> of possible target (V)CPUs by using the same MPIDR that the cores
> report themselves.
> In addition to translating this MPIDR into a vcpu pointer we store
> the originally written value as well. The architecture allows to
> write any values into the register, which must be read back as written.
> 
> Since we don't support affinity level 3, we don't need to take care
> about the upper word of this 64-bit register, which simplifies the
> handling a bit.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog RFC..v1:
> - fold in and simplify vgic_v3_irq_change_affinity
> 
> Changelog v1 .. v2:
> - adapt to new MMIO framework
> 
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 65 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 64 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 48fba9c..3bcc2c4 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -86,6 +86,69 @@ static u32 compress_mpidr(unsigned long mpidr)
>  	return ret;
>  }
>  
> +static unsigned long decompress_mpidr(u32 value)
> +{
> +	unsigned long mpidr;
> +
> +	mpidr  = ((value >>  0) & 0xFF) << MPIDR_LEVEL_SHIFT(0);
> +	mpidr |= ((value >>  8) & 0xFF) << MPIDR_LEVEL_SHIFT(1);
> +	mpidr |= ((value >> 16) & 0xFF) << MPIDR_LEVEL_SHIFT(2);
> +	mpidr |= (u64)((value >> 24) & 0xFF) << MPIDR_LEVEL_SHIFT(3);
> +
> +	return mpidr;
> +}
> +
> +static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
> +					    gpa_t addr, unsigned int len)
> +{
> +	int intid = (addr & 0x1fff) / 8;
> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
> +	unsigned long mpidr;
> +
> +	if (!irq)
> +		return 0;
> +
> +	mpidr = decompress_mpidr(irq->mpidr);

I'm unsure here; do we ned a READ_ONCE() in lieu taking the lock or are
we guaranteed that this is a single memory access even with compiler
inlining etc.?

> +	return extract_bytes(mpidr, addr & 7, len);
> +}
> +
> +static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len,
> +				    unsigned long val)
> +{
> +	int intid = (addr & 0x1fff) / 8;
> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
> +	unsigned long mask = 0xffffffff;	/* upper word is WI */
> +	u64 mpidr;
> +
> +	if (!irq)
> +		return;
> +
> +	/*
> +	 * There are only two supported options:
> +	 * (1) aligned 64-bit access
> +	 * (2) aligned 32-bit access
> +	 *
> +	 * TODO: make this check generic and move it to dispatch_...()
> +	 */
> +	if (len != 4 && len != 8)
> +		return;
> +
> +
> +	/* The upper word is WI for us since we don't implement Aff3. */
> +	if (addr & 4)
> +		return;
> +
> +	spin_lock(&irq->irq_lock);
> +
> +	mpidr = decompress_mpidr(irq->mpidr);
> +	mpidr = (mpidr & ~mask) | (val & mask);
> +	irq->mpidr = compress_mpidr(mpidr);
> +	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, mpidr);

this is weird because it doesn't preserve read-as-written semantics but
allows a guest to write something into the RES0 field and read that back
in the Aff3 field...

> +
> +	spin_unlock(&irq->irq_lock);
> +}
> +
>  static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>  					      gpa_t addr, unsigned int len)
>  {
> @@ -174,7 +237,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 64),
> +		vgic_mmio_read_irouter, vgic_mmio_write_irouter, 64),
>  	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
>  		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
>  };
> -- 
> 2.7.3
> 
