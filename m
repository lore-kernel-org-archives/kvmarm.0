From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v11 06/10] genirq/msi-doorbell: msi_doorbell_safe
Date: Fri, 22 Jul 2016 14:44:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1607221443090.3906@nanos>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
 <1468933367-23159-7-git-send-email-eric.auger@redhat.com>
 <alpine.DEB.2.11.1607201010350.3564@nanos>
 <3f188661-1d68-199b-3fcc-4da432bae633@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02C6849B34
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 08:40:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dU55MZ4yKIJQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 08:40:03 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE9DD49B2C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 08:40:03 -0400 (EDT)
In-Reply-To: <3f188661-1d68-199b-3fcc-4da432bae633@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com, joro@8bytes.org, robert.richter@caviumnetworks.com, jason@lakedaemon.net, marc.zyngier@arm.com, andre.przywara@arm.com, Manish.Jaggi@caviumnetworks.com, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, pbonzini@redhat.com, robin.murphy@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 21 Jul 2016, Auger Eric wrote:
> On 20/07/2016 10:12, Thomas Gleixner wrote:
> > On Tue, 19 Jul 2016, Eric Auger wrote:
> >> +bool msi_doorbell_safe(void)
> >> +{
> >> +	struct irqchip_doorbell *db;
> >> +	bool irq_remapping = true;
> >> +
> >> +	mutex_lock(&irqchip_doorbell_mutex);
> >> +	list_for_each_entry(db, &irqchip_doorbell_list, next) {
> >> +		irq_remapping &= db->info.irq_remapping;
> > 
> > db->info.irq_remapping is set in msi_doorbell_register(). So you can keep book
> > about that there. No need to iterate here.
> Yes makes sense to store the info at registration time. Currently this
> function is not in any fast path but that's cleaner from a general
> perspective. I will need to do such iteration at un-registration though.

Two simple counter should be sufficient.

  nr_registered_bells;
  nr_remapped_bells;

....

Thanks,

	tglx
