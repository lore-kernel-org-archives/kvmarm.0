From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v11 05/10] genirq/msi-doorbell: msi_doorbell_pages
Date: Thu, 21 Jul 2016 15:38:42 +0200
Message-ID: <8b053222-3721-7f16-5de9-ee17c04d8dee@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
 <1468933367-23159-6-git-send-email-eric.auger@redhat.com>
 <alpine.DEB.2.11.1607191624400.3596@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1607191624400.3596@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org, Jean-Philippe.Brucker@arm.com, yehuday@marvell.com, Manish.Jaggi@caviumnetworks.com, robert.richter@caviumnetworks.com
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

I am confused by this comment. I was told in the past that it was better
to put the comments in the API header. On your side do you want me to
move all function kernel-doc comments to the implementation.

Looking at kernel-doc-nano-HOWTO.txt, I was not able to find any
indication about the best choice.

I will now run the kernel-doc script to check the conformance of my
comments.

Thank you for your patience!

Best Regards

Eric
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
> 
> Thanks,
> 
> 	tglx
> 
