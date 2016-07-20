From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v11 05/10] genirq/msi-doorbell: msi_doorbell_pages
Date: Wed, 20 Jul 2016 09:50:19 +0200
Message-ID: <cb446d2e-2e8f-80a7-eac9-8eda188c3dbf@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
 <1468933367-23159-6-git-send-email-eric.auger@redhat.com>
 <alpine.DEB.2.11.1607191624400.3596@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A21C411BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 03:44:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WbPzlJ6ZDJTK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2016 03:44:17 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83E2448531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 03:44:16 -0400 (EDT)
In-Reply-To: <alpine.DEB.2.11.1607191624400.3596@nanos>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com, joro@8bytes.org, robert.richter@caviumnetworks.com, jason@lakedaemon.net, marc.zyngier@arm.com, andre.przywara@arm.com, Manish.Jaggi@caviumnetworks.com, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, pbonzini@redhat.com, robin.murphy@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Thomas,
On 19/07/2016 16:38, Thomas Gleixner wrote:
> On Tue, 19 Jul 2016, Eric Auger wrote:
>> msi_doorbell_pages sum up the number of iommu pages of a given order
> 
> adding () to the function name would make it immediately clear that
> msi_doorbell_pages is a function.
> 
>> +/**
>> + * msi_doorbell_pages: compute the number of iommu pages of size 1 << order
>> + * requested to map all the registered doorbells
>> + *
>> + * @order: iommu page order
>> + */
> 
> Why are you adding the kernel doc to the header and not to the implementation?
> 
>> +int msi_doorbell_pages(unsigned int order);
>> +
>>  #else
>>  
>>  static inline struct irq_chip_msi_doorbell_info *
>> @@ -47,6 +55,12 @@ msi_doorbell_register_global(phys_addr_t base, size_t size,
>>  static inline void
>>  msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *db) {}
>>  
>> +static inline int
>> +msi_doorbell_pages(unsigned int order)
> 
> What's the point of this line break?

> 
>> +{
>> +	return 0;
>> +}
>> +
>>  #endif /* CONFIG_MSI_DOORBELL */
>>  
>>  #endif
>> diff --git a/kernel/irq/msi-doorbell.c b/kernel/irq/msi-doorbell.c
>> index 0ff541e..a5bde37 100644
>> --- a/kernel/irq/msi-doorbell.c
>> +++ b/kernel/irq/msi-doorbell.c
>> @@ -60,3 +60,55 @@ void msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *dbinfo)
>>  	mutex_unlock(&irqchip_doorbell_mutex);
>>  }
>>  EXPORT_SYMBOL_GPL(msi_doorbell_unregister_global);
>> +
>> +static int compute_db_mapping_requirements(phys_addr_t addr, size_t size,
>> +					   unsigned int order)
>> +{
>> +	phys_addr_t offset, granule;
>> +	unsigned int nb_pages;
>> +
>> +	granule = (uint64_t)(1 << order);
>> +	offset = addr & (granule - 1);
>> +	size = ALIGN(size + offset, granule);
>> +	nb_pages = size >> order;
>> +
>> +	return nb_pages;
>> +}
>> +
>> +static int
>> +compute_dbinfo_mapping_requirements(struct irq_chip_msi_doorbell_info *dbinfo,
>> +				    unsigned int order)
> 
> I'm sure you can find even longer function names which require more line
> breaks.
> 
>> +{
>> +	int ret = 0;
>> +
>> +	if (!dbinfo->doorbell_is_percpu) {
>> +		ret = compute_db_mapping_requirements(dbinfo->global_doorbell,
>> +						      dbinfo->size, order);
>> +	} else {
>> +		phys_addr_t __percpu *pbase;
>> +		int cpu;
>> +
>> +		for_each_possible_cpu(cpu) {
>> +			pbase = per_cpu_ptr(dbinfo->percpu_doorbells, cpu);
>> +			ret += compute_db_mapping_requirements(*pbase,
>> +							       dbinfo->size,
>> +							       order);
>> +		}
>> +	}
>> +	return ret;
>> +}
>> +
>> +int msi_doorbell_pages(unsigned int order)
>> +{
>> +	struct irqchip_doorbell *db;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&irqchip_doorbell_mutex);
>> +	list_for_each_entry(db, &irqchip_doorbell_list, next) {
> 
> Pointless braces
> 
>> +		ret += compute_dbinfo_mapping_requirements(&db->info, order);
>> +	}
>> +	mutex_unlock(&irqchip_doorbell_mutex);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(msi_doorbell_pages);
> 
> So here is a general rant about your naming choices.
> 
>    struct irqchip_doorbell
>    struct irq_chip_msi_doorbell_info
> 
>    struct irq_chip {
>    	  ....	  *(*msi_doorbell_info);
>    }
> 
>    irqchip_doorbell_mutex
> 
>    msi_doorbell_register_global
>    msi_doorbell_unregister_global
> 
>    msi_doorbell_pages
> 
> This really sucks. Your public functions start sensibly with msi_doorbell.
> 
> Though what is the _global postfix for the register/unregister functions for?
> Are there _private functions in the pipeline?
global is to be opposed to per-cpu (doorbell). Currently gicv2m and
gicv3-its expose a single "global" doorbell and I have not yet coped
with irqchips exposing per-cpu doorbells.
> 
> msi_doorbell_pages() is not telling me what it does. msi_calc_doorbell_pages()
> would describe it right away.
> 
> You doorbell info structure can really do with:
> 
>     struct msi_doorbell_info;
> 
> And the wrapper struct around it is fine with:
> 
>     struct msi_doorbell;
Yes you're right I will revisit the names and fix all style issues you
reported.

Thank you for your time

Eric
> 
> Thanks,
> 
> 	tglx
> 
