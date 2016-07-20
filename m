From: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v11 04/10] genirq/msi-doorbell: allow MSI doorbell
	(un)registration
Date: Wed, 20 Jul 2016 09:50:14 +0200
Message-ID: <cfd24f24-a7ff-2657-f88b-43537f6316dd@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
	<1468933367-23159-5-git-send-email-eric.auger@redhat.com>
	<alpine.DEB.2.11.1607191617071.3596@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1607191617071.3596@nanos>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yehuday-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, andre.przywara-5wv7dgnIgG8@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Thomas,
On 19/07/2016 16:22, Thomas Gleixner wrote:
> On Tue, 19 Jul 2016, Eric Auger wrote:
>> +
>> +#include <linux/slab.h>
>> +#include <linux/irq.h>
>> +#include <linux/msi-doorbell.h>
>> +
>> +struct irqchip_doorbell {
>> +	struct irq_chip_msi_doorbell_info info;
>> +	struct list_head next;
> 
> Again, please align the struct members.
> 
>> +};
>> +
>> +static LIST_HEAD(irqchip_doorbell_list);
>> +static DEFINE_MUTEX(irqchip_doorbell_mutex);
>> +
>> +struct irq_chip_msi_doorbell_info *
>> +msi_doorbell_register_global(phys_addr_t base, size_t size,
>> +			     int prot, bool irq_remapping)
>> +{
>> +	struct irqchip_doorbell *db;
>> +
>> +	db = kmalloc(sizeof(*db), GFP_KERNEL);
>> +	if (!db)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	db->info.doorbell_is_percpu = false;
> 
> Please use kzalloc and get rid of zero initialization. If you add stuff to the
> struct then initialization will be automatically 0.
OK
> 
>> +void msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *dbinfo)
>> +{
>> +	struct irqchip_doorbell *db, *tmp;
>> +
>> +	mutex_lock(&irqchip_doorbell_mutex);
>> +	list_for_each_entry_safe(db, tmp, &irqchip_doorbell_list, next) {
> 
> Why do you need that iterator? 
> 
>     db = container_of(dbinfo, struct ....., info);
> 
> Hmm?

definitively
> 
>> +		if (dbinfo == &db->info) {
>> +			list_del(&db->next);
>> +			kfree(db);
> 
> Please move the kfree() outside of the lock region. It does not matter much
> here, but we really should stop doing random crap in locked regions.
OK

Thanks

Eric
> 
> Thanks,
> 
> 	tglx
> 
