From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3] KVM: arm/arm64 : add lpi info in vgic-debug
Date: Fri, 23 Mar 2018 19:32:41 +0000
Message-ID: <4a8fd699-7690-9056-d0b0-3e4c30778e69@arm.com>
References: <1521852161-67603-1-git-send-email-peng.hao2@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521852161-67603-1-git-send-email-peng.hao2@zte.com.cn>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Peng Hao <peng.hao2@zte.com.cn>, cdall@kernel.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 24/03/18 00:42, Peng Hao wrote:
> Add lpi debug info to vgic-stat.
> The printed info like this:
>     SPI  287      0 000001        0        0   0 160      -1
>     LPI 8192      2 000100        0        0   0 160      -1
> 
> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
> ---
>  virt/kvm/arm/vgic/vgic-debug.c | 59 ++++++++++++++++++++++++++++++++++++++----
>  virt/kvm/arm/vgic/vgic-its.c   | 16 ++++++------
>  virt/kvm/arm/vgic/vgic.h       |  1 +
>  3 files changed, 63 insertions(+), 13 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
> index 10b3817..ddac6bd 100644
> --- a/virt/kvm/arm/vgic/vgic-debug.c
> +++ b/virt/kvm/arm/vgic/vgic-debug.c
> @@ -36,9 +36,12 @@
>  struct vgic_state_iter {
>  	int nr_cpus;
>  	int nr_spis;
> +	int nr_lpis;
>  	int dist_id;
>  	int vcpu_id;
>  	int intid;
> +	int lpi_print_count;
> +	struct vgic_irq **lpi_irqs;
>  };
>  
>  static void iter_next(struct vgic_state_iter *iter)
> @@ -52,6 +55,39 @@ static void iter_next(struct vgic_state_iter *iter)
>  	if (iter->intid == VGIC_NR_PRIVATE_IRQS &&
>  	    ++iter->vcpu_id < iter->nr_cpus)
>  		iter->intid = 0;
> +
> +	if (iter->intid >= VGIC_NR_PRIVATE_IRQS + iter->nr_spis) {
> +		if (iter->lpi_print_count < iter->nr_lpis)
> +			iter->intid = iter->lpi_irqs[iter->lpi_print_count]->intid;
> +		iter->lpi_print_count++;
> +	}
> +}
> +
> +static void vgic_debug_get_lpis(struct kvm *kvm, struct vgic_state_iter *iter)
> +{
> +	u32 *intids;
> +	int i, irq_count;
> +	struct vgic_irq *irq = NULL, **lpi_irqs;
> +
> +	iter->nr_lpis = 0;
> +	irq_count = vgic_copy_lpi_list(kvm, NULL, &intids);
> +	if (irq_count < 0)
> +		return;
> +
> +	lpi_irqs = kmalloc_array(irq_count, sizeof(irq), GFP_KERNEL);
> +	if (!lpi_irqs) {
> +		kfree(intids);
> +		return;
> +	}
> +
> +	for (i = 0; i < irq_count; i++) {
> +		irq = vgic_get_irq(kvm, NULL, intids[i]);
> +		if (!irq)
> +			continue;
> +		lpi_irqs[iter->nr_lpis++] = irq;
> +	}
> +	iter->lpi_irqs = lpi_irqs;
> +	kfree(intids);

You are still completely missing the point. Why are you allocating this
array of pointers while you have a perfectly sensible array of intids,
allowing you do treat all the irqs uniformly?

>  }
>  
>  static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
> @@ -64,6 +100,8 @@ static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
>  	iter->nr_cpus = nr_cpus;
>  	iter->nr_spis = kvm->arch.vgic.nr_spis;
>  
> +	if (vgic_supports_direct_msis(kvm) && !pos)
> +		vgic_debug_get_lpis(kvm, iter);

Again: What is the point of this?

>  	/* Fast forward to the right position if needed */
>  	while (pos--)
>  		iter_next(iter);
> @@ -73,7 +111,9 @@ static bool end_of_vgic(struct vgic_state_iter *iter)
>  {
>  	return iter->dist_id > 0 &&
>  		iter->vcpu_id == iter->nr_cpus &&
> -		(iter->intid - VGIC_NR_PRIVATE_IRQS) == iter->nr_spis;
> +		(iter->intid - VGIC_NR_PRIVATE_IRQS) >= iter->nr_spis &&
> +		((iter->nr_lpis == 0) ||
> +		(iter->lpi_print_count == iter->nr_lpis + 1));
>  }
>  
>  static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
> @@ -130,6 +170,7 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
>  
>  	mutex_lock(&kvm->lock);
>  	iter = kvm->arch.vgic.iter;
> +	kfree(iter->lpi_irqs);
>  	kfree(iter);
>  	kvm->arch.vgic.iter = NULL;
>  	mutex_unlock(&kvm->lock);
> @@ -154,7 +195,7 @@ static void print_header(struct seq_file *s, struct vgic_irq *irq,
>  			 struct kvm_vcpu *vcpu)
>  {
>  	int id = 0;
> -	char *hdr = "SPI ";
> +	char *hdr = "Global";
>  
>  	if (vcpu) {
>  		hdr = "VCPU";
> @@ -162,7 +203,10 @@ static void print_header(struct seq_file *s, struct vgic_irq *irq,
>  	}
>  
>  	seq_printf(s, "\n");
> -	seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
> +	if (vcpu)
> +		seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
> +	else
> +		seq_printf(s, "%s TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr);
>  	seq_printf(s, "---------------------------------------------------------------\n");
>  }
>  
> @@ -174,8 +218,10 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
>  		type = "SGI";
>  	else if (irq->intid < VGIC_NR_PRIVATE_IRQS)
>  		type = "PPI";
> -	else
> +	else if (irq->intid < VGIC_MAX_SPI)
>  		type = "SPI";
> +	else if (irq->intid >= VGIC_MIN_LPI)
> +		type = "LPI";
>  
>  	if (irq->intid ==0 || irq->intid == VGIC_NR_PRIVATE_IRQS)
>  		print_header(s, irq, vcpu);
> @@ -220,7 +266,9 @@ static int vgic_debug_show(struct seq_file *s, void *v)
>  	if (!kvm->arch.vgic.initialized)
>  		return 0;
>  
> -	if (iter->vcpu_id < iter->nr_cpus) {
> +	if (iter->intid >= VGIC_MIN_LPI)
> +		irq = iter->lpi_irqs[iter->lpi_print_count - 1];
> +	else if (iter->vcpu_id < iter->nr_cpus) {
>  		vcpu = kvm_get_vcpu(kvm, iter->vcpu_id);
>  		irq = &vcpu->arch.vgic_cpu.private_irqs[iter->intid];
>  	} else {
> @@ -230,6 +278,7 @@ static int vgic_debug_show(struct seq_file *s, void *v)
>  	spin_lock(&irq->irq_lock);
>  	print_irq_state(s, irq, vcpu);
>  	spin_unlock(&irq->irq_lock);
> +	vgic_put_irq(kvm, irq);

Doesn't it shock you that you're doing a "put" on something you haven't
done a "get" on?

[...]

Here's what I mean[1]. No double allocation, uniform access to the irq
pointer, no imbalance in reference management.

	M.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/vgic-debug&id=7ab86b67167698d30a93b9f5079eb9f48f885bf6
-- 
Jazz is not dead. It just smells funny...
