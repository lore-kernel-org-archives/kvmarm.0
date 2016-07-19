From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v11 04/10] genirq/msi-doorbell: allow MSI doorbell
 (un)registration
Date: Tue, 19 Jul 2016 16:22:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1607191617071.3596@nanos>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
 <1468933367-23159-5-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35827412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 10:18:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UJLghYpOTQC9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2016 10:18:17 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 486FB412C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 10:18:16 -0400 (EDT)
In-Reply-To: <1468933367-23159-5-git-send-email-eric.auger@redhat.com>
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
> +
> +#include <linux/slab.h>
> +#include <linux/irq.h>
> +#include <linux/msi-doorbell.h>
> +
> +struct irqchip_doorbell {
> +	struct irq_chip_msi_doorbell_info info;
> +	struct list_head next;

Again, please align the struct members.

> +};
> +
> +static LIST_HEAD(irqchip_doorbell_list);
> +static DEFINE_MUTEX(irqchip_doorbell_mutex);
> +
> +struct irq_chip_msi_doorbell_info *
> +msi_doorbell_register_global(phys_addr_t base, size_t size,
> +			     int prot, bool irq_remapping)
> +{
> +	struct irqchip_doorbell *db;
> +
> +	db = kmalloc(sizeof(*db), GFP_KERNEL);
> +	if (!db)
> +		return ERR_PTR(-ENOMEM);
> +
> +	db->info.doorbell_is_percpu = false;

Please use kzalloc and get rid of zero initialization. If you add stuff to the
struct then initialization will be automatically 0.

> +void msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *dbinfo)
> +{
> +	struct irqchip_doorbell *db, *tmp;
> +
> +	mutex_lock(&irqchip_doorbell_mutex);
> +	list_for_each_entry_safe(db, tmp, &irqchip_doorbell_list, next) {

Why do you need that iterator? 

    db = container_of(dbinfo, struct ....., info);

Hmm?

> +		if (dbinfo == &db->info) {
> +			list_del(&db->next);
> +			kfree(db);

Please move the kfree() outside of the lock region. It does not matter much
here, but we really should stop doing random crap in locked regions.

Thanks,

	tglx
