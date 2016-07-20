From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v11 06/10] genirq/msi-doorbell: msi_doorbell_safe
Date: Wed, 20 Jul 2016 10:12:18 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1607201010350.3564@nanos>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
 <1468933367-23159-7-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A80C3411BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 04:08:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CqlHUUzl4Lj1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2016 04:08:24 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36B7940C9A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 04:08:24 -0400 (EDT)
In-Reply-To: <1468933367-23159-7-git-send-email-eric.auger@redhat.com>
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
> +bool msi_doorbell_safe(void)
> +{
> +	struct irqchip_doorbell *db;
> +	bool irq_remapping = true;
> +
> +	mutex_lock(&irqchip_doorbell_mutex);
> +	list_for_each_entry(db, &irqchip_doorbell_list, next) {
> +		irq_remapping &= db->info.irq_remapping;

db->info.irq_remapping is set in msi_doorbell_register(). So you can keep book
about that there. No need to iterate here.

Thanks,

	tglx
