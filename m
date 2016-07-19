From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v11 03/10] genirq/irq: introduce msi_doorbell_info
Date: Tue, 19 Jul 2016 16:15:56 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1607191610070.3596@nanos>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
 <1468933367-23159-4-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72E18412C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 10:12:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Iv8pGNNHHTqR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2016 10:12:10 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 153DE412A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 10:12:09 -0400 (EDT)
In-Reply-To: <1468933367-23159-4-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com, joro@8bytes.org, robert.richter@caviumnetworks.com, jason@lakedaemon.net, marc.zyngier@arm.com, andre.przywara@arm.com, Manish.Jaggi@caviumnetworks.com, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, pbonzini@redhat.com, robin.murphy@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 19 Jul 2016, Eric Auger wrote:
>  
> +/* Describe all the MSI doorbell regions for an irqchip */
> +struct irq_chip_msi_doorbell_info {
> +	union {
> +		phys_addr_t __percpu *percpu_doorbells;
> +		phys_addr_t global_doorbell;
> +	};
> +	bool doorbell_is_percpu;
> +	bool irq_remapping;	/* is irq_remapping implemented? */

Please do not use tail comments. Use proper kernel doc for documentation.

> +	size_t size;				/* size of each doorbell */
> +	int prot;				/* iommu protection flag */

Please align the members proper

	union {
		phys_addr_t __percpu	*percpu_doorbells;
		phys_addr_t 		global_doorbell;
	};
	bool	doorbell_is_percpu;
	bool	irq_remapping;

> +};
> +
>  /**
>   * struct irq_chip - hardware interrupt chip descriptor
>   *
> @@ -349,6 +361,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
>   * @irq_get_irqchip_state:	return the internal state of an interrupt
>   * @irq_set_irqchip_state:	set the internal state of a interrupt
>   * @irq_set_vcpu_affinity:	optional to target a vCPU in a virtual machine
> + * @msi_doorbell_info:	return the MSI doorbell info
>   * @ipi_send_single:	send a single IPI to destination cpus
>   * @ipi_send_mask:	send an IPI to destination cpus in cpumask
>   * @flags:		chip specific flags
> @@ -394,7 +407,8 @@ struct irq_chip {
>  	int		(*irq_set_irqchip_state)(struct irq_data *data, enum irqchip_irq_state which, bool state);
>  
>  	int		(*irq_set_vcpu_affinity)(struct irq_data *data, void *vcpu_info);
> -
> +	struct irq_chip_msi_doorbell_info *(*msi_doorbell_info)(

  	irq_get_msi_doorbell_info or msi_get_doorbell_info please

> +							struct irq_data *data);

No need for a line break here. Please keep it as a single line.

Thanks

	tglx
