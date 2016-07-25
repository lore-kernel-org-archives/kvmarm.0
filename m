From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v11 09/10] genirq/msi: map/unmap the MSI doorbells on
 msi_domain_alloc/free_irqs
Date: Mon, 25 Jul 2016 18:21:45 +0200
Message-ID: <75f5e846-6ca4-4178-e7aa-fed90e45e546@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
 <1468933367-23159-10-git-send-email-eric.auger@redhat.com>
 <alpine.DEB.2.11.1607201016060.3564@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1607201016060.3564@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org, Jean-Philippe.Brucker@arm.com, yehuday@marvell.com, Manish.Jaggi@caviumnetworks.com, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Thomas,

On 20/07/2016 11:04, Thomas Gleixner wrote:
> On Tue, 19 Jul 2016, Eric Auger wrote:
>>  /**
>> + * msi_handle_doorbell_mappings: in case the irq data corresponds to an
>> + * MSI that requires iommu mapping, traverse the irq domain hierarchy
>> + * to retrieve the doorbells to handle and iommu_map/unmap them according
>> + * to @map boolean.
>> + *
>> + * @data: irq data handle
>> + * @map: mapping if true, unmapping if false
>> + */
> 
> 
> Please run that through the kernel doc generator. It does not work that way.
> 
> The format is:
> 
> /**
>  * function_name - Short function description    
>  * @arg1:	Description of arg1
>  * @argument2:	Description of argument2
>  *
>  * Long explanation including documentation of the return values.
>  */
> 
>> +static int msi_handle_doorbell_mappings(struct irq_data *data, bool map)
>> +{
>> +	const struct irq_chip_msi_doorbell_info *dbinfo;
>> +	struct iommu_domain *domain;
>> +	struct irq_chip *chip;
>> +	struct device *dev;
>> +	dma_addr_t iova;
>> +	int ret = 0, cpu;
>> +
>> +	while (data) {
>> +		dev = msi_desc_to_dev(irq_data_get_msi_desc(data));
>> +		domain = iommu_msi_domain(dev);
>> +		if (domain) {
>> +			chip = irq_data_get_irq_chip(data);
>> +			if (chip->msi_doorbell_info)
>> +				break;
>> +		}
>> +		data = data->parent_data;
>> +	}
> 
> Please split that out into a seperate function
> 
> struct irq_data *msi_get_doorbell_info(data)
> {
> 	.....
> 		if (chip->msi_doorbell_info)
> 			return chip->msi_get_doorbell_info(data);
> 	}
> 	return NULL;
> }
> 
>        info = msi_get_doorbell_info(data);
>        .....
> 
>> +	if (!data)
>> +		return 0;
>> +
>> +	dbinfo = chip->msi_doorbell_info(data);
>> +	if (!dbinfo)
>> +		return -EINVAL;
>> +
>> +	if (!dbinfo->doorbell_is_percpu) {
>> +		if (!map) {
>> +			iommu_msi_put_doorbell_iova(domain,
>> +						    dbinfo->global_doorbell);
>> +			return 0;
>> +		}
>> +		return iommu_msi_get_doorbell_iova(domain,
>> +						   dbinfo->global_doorbell,
>> +						   dbinfo->size, dbinfo->prot,
>> +						   &iova);
>> +	}
> 
> You can spare an indentation level with a helper function
> 
>     	if (!dbinfo->doorbell_is_percpu)
> 		return msi_map_global_doorbell(domain, dbinfo);
> 
>> +
>> +	/* percpu doorbells */
>> +	for_each_possible_cpu(cpu) {
>> +		phys_addr_t __percpu *db_addr =
>> +			per_cpu_ptr(dbinfo->percpu_doorbells, cpu);
>> +
>> +		if (!map) {
>> +			iommu_msi_put_doorbell_iova(domain, *db_addr);
>> +		} else {
>> +
>> +			ret = iommu_msi_get_doorbell_iova(domain, *db_addr,
>> +							  dbinfo->size,
>> +							  dbinfo->prot, &iova);
>> +			if (ret)
>> +				return ret;
>> +		}
>> +	}
> 
> Same here:
> 
> 	for_each_possible_cpu(cpu) {
> 		ret = msi_map_percpu_doorbell(domain, cpu);
> 		if (ret)
> 			return ret;
> 	}
>      	return 0;
>      
> Hmm?
> 
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>>   * msi_domain_alloc_irqs - Allocate interrupts from a MSI interrupt domain
>>   * @domain:	The domain to allocate from
>>   * @dev:	Pointer to device struct of the device for which the interrupts
>> @@ -352,17 +423,29 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
>>  
>>  		virq = __irq_domain_alloc_irqs(domain, virq, desc->nvec_used,
>>  					       dev_to_node(dev), &arg, false);
>> -		if (virq < 0) {
>> -			ret = -ENOSPC;
>> -			if (ops->handle_error)
>> -				ret = ops->handle_error(domain, desc, ret);
>> -			if (ops->msi_finish)
>> -				ops->msi_finish(&arg, ret);
>> -			return ret;
>> -		}
>> +		if (virq < 0)
>> +			goto error;
>>  
>>  		for (i = 0; i < desc->nvec_used; i++)
>>  			irq_set_msi_desc_off(virq, i, desc);
>> +
>> +		for (i = 0; i < desc->nvec_used; i++) {
>> +			struct irq_data *d = irq_get_irq_data(virq + i);
>> +
>> +			ret = msi_handle_doorbell_mappings(d, true);
>> +			if (ret)
>> +				break;
>> +		}
>> +		if (ret) {
>> +			for (; i >= 0; i--) {
>> +				struct irq_data *d = irq_get_irq_data(virq + i);
>> +
>> +				msi_handle_doorbell_mappings(d, false);
>> +			}
>> +			irq_domain_free_irqs(virq, desc->nvec_used);
>> +			desc->irq = 0;
>> +			goto error;
> 
> How is that supposed to work? You clear desc->irq and then you call
> ops->handle_error.
if I don't clear the desc->irq I enter an infinite loop in pci_enable_msix_range.
This happens because msix_capability_init and pcie_enable_msix returns 1.

In msix_capability_init, at out_avail: we enumerate the msi_desc which have a non
zero irq, hence the returned value equal to 1.

Currently the only handle_error ops I found, pci_msi_domain_handle_error does not
use irq field so works although questionable.

As for the irq_domain_free_irqs I think I can remove it since handled later.

How do you advise to handle the above situation?

Thanks

Eric

> 
> Why are you adding this extra stuff here? Look at the call sites of
> msi_domain_alloc_irqs(). All of them use msi_domain_free_irqs() in case of
> error. There is no reason why you can't do the same....
> 
>>  /**
>> @@ -396,6 +486,9 @@ void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
>>  		 * entry. If that's the case, don't do anything.
>>  		 */
>>  		if (desc->irq) {
>> +			msi_handle_doorbell_mappings(
>> +				irq_get_irq_data(desc->irq),
>> +				false);
>>  			irq_domain_free_irqs(desc->irq, desc->nvec_used);
>>  			desc->irq = 0;
> 
> Can you please restructure the code so it reads
> 
> 		if (desc->irq)
> 			continue;
> 
> 		msi_handle_doorbell_mappings(irq_get_irq_data(desc->irq),
> 					     false);	
> 		irq_domain_free_irqs(desc->irq, desc->nvec_used);
> 		desc->irq = 0;
> 
> Just blindly whacking stuff into the 80 char limit is not helping readability.
> 
> Thanks,
> 
> 	tglx
> 
