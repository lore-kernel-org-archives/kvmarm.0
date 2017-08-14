From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH V15 06/11] acpi: apei: handle SEA notification type for
 ARMv8
Date: Mon, 14 Aug 2017 15:55:12 +0800
Message-ID: <6a5ef607-ac92-a616-8e60-06c4e51bba04@huawei.com>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-7-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1492556723-9189-7-git-send-email-tbaicar@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vg
List-Id: kvmarm@lists.cs.columbia.edu

Hi Tyler,

On 2017/4/19 7:05, Tyler Baicar wrote:
> ARM APEI extension proposal added SEA (Synchronous External Abort)
> notification type for ARMv8.
> Add a new GHES error source handling function for SEA. If an error
> source's notification type is SEA, then this function can be registered
> into the SEA exception handler. That way GHES will parse and report
> SEA exceptions when they occur.
> An SEA can interrupt code that had interrupts masked and is treated as
> an NMI. To aid this the page of address space for mapping APEI buffers
> while in_nmi() is always reserved, and ghes_ioremap_pfn_nmi() is
> changed to use the helper methods to find the prot_t to map with in
> the same way as ghes_ioremap_pfn_irq().
> 
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Reviewed-by: James Morse <james.morse@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---

> @@ -518,6 +520,17 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>  	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>  		inf->name, esr, addr);
>  
> +	/*
> +	 * Synchronous aborts may interrupt code which had interrupts masked.
> +	 * Before calling out into the wider kernel tell the interested
> +	 * subsystems.
> +	 */
> +	if (IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
> +		nmi_enter();
> +		ghes_notify_sea();
> +		nmi_exit();
> +	}
> +
>  	info.si_signo = SIGBUS;
>  	info.si_errno = 0;
>  	info.si_code  = 0;
For instruction abort, if there exists memory section in ghes, we will call memory_failure() in ghes_notify_sea()
and reread the instruction from the disk. In this case, we don't have to send SIGBUS to the application.
But memory_failure() is scheduled in a work queue, we don't what the result of memory_failure will be when ghes_notify_sea() returned.
Do you have any idea about how to fix this, so we don't have to kill the application in the instruction abort case.

Thanks,
Wang Xiongfeng


> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
> index b0140c8..de14d49 100644
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -39,6 +39,21 @@ config ACPI_APEI_PCIEAER
>  	  PCIe AER errors may be reported via APEI firmware first mode.
>  	  Turn on this option to enable the corresponding support.
>  
> +config ACPI_APEI_SEA
> +	bool "APEI Synchronous External Abort logging/recovering support"
> +	depends on ARM64 && ACPI_APEI_GHES
> +	default y
> +	help
> +	  This option should be enabled if the system supports
> +	  firmware first handling of SEA (Synchronous External Abort).
> +	  SEA happens with certain faults of data abort or instruction
> +	  abort synchronous exceptions on ARMv8 systems. If a system
> +	  supports firmware first handling of SEA, the platform analyzes
> +	  and handles hardware error notifications from SEA, and it may then
> +	  form a HW error record for the OS to parse and handle. This
> +	  option allows the OS to look for such hardware error record, and
> +	  take appropriate action.
> +
>  config ACPI_APEI_MEMORY_FAILURE
>  	bool "APEI memory error recovering support"
>  	depends on ACPI_APEI && MEMORY_FAILURE
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index dfb7dd2..2d387f8 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -115,11 +115,7 @@
>   * Two virtual pages are used, one for IRQ/PROCESS context, the other for
>   * NMI context (optionally).
>   */
> -#ifdef CONFIG_HAVE_ACPI_APEI_NMI
>  #define GHES_IOREMAP_PAGES           2
> -#else
> -#define GHES_IOREMAP_PAGES           1
> -#endif
>  #define GHES_IOREMAP_IRQ_PAGE(base)	(base)
>  #define GHES_IOREMAP_NMI_PAGE(base)	((base) + PAGE_SIZE)
>  
> @@ -158,10 +154,14 @@ static void ghes_ioremap_exit(void)
>  static void __iomem *ghes_ioremap_pfn_nmi(u64 pfn)
>  {
>  	unsigned long vaddr;
> +	phys_addr_t paddr;
> +	pgprot_t prot;
>  
>  	vaddr = (unsigned long)GHES_IOREMAP_NMI_PAGE(ghes_ioremap_area->addr);
> -	ioremap_page_range(vaddr, vaddr + PAGE_SIZE,
> -			   pfn << PAGE_SHIFT, PAGE_KERNEL);
> +
> +	paddr = pfn << PAGE_SHIFT;
> +	prot = arch_apei_get_mem_attribute(paddr);
> +	ioremap_page_range(vaddr, vaddr + PAGE_SIZE, paddr, prot);
>  
>  	return (void __iomem *)vaddr;
>  }
> @@ -771,6 +771,50 @@ static int ghes_notify_sci(struct notifier_block *this,
>  	.notifier_call = ghes_notify_sci,
>  };
>  
> +#ifdef CONFIG_ACPI_APEI_SEA
> +static LIST_HEAD(ghes_sea);
> +
> +void ghes_notify_sea(void)
> +{
> +	struct ghes *ghes;
> +
> +	/*
> +	 * synchronize_rcu() will wait for nmi_exit(), so no need to
> +	 * rcu_read_lock().
> +	 */
> +	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
> +		ghes_proc(ghes);
> +	}
> +}
> +
> +static void ghes_sea_add(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	list_add_rcu(&ghes->list, &ghes_sea);
> +	mutex_unlock(&ghes_list_mutex);
> +}
> +
> +static void ghes_sea_remove(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	list_del_rcu(&ghes->list);
> +	mutex_unlock(&ghes_list_mutex);
> +	synchronize_rcu();
> +}
> +#else /* CONFIG_ACPI_APEI_SEA */
> +static inline void ghes_sea_add(struct ghes *ghes)
> +{
> +	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
> +	       ghes->generic->header.source_id);
> +}
> +
> +static inline void ghes_sea_remove(struct ghes *ghes)
> +{
> +	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
> +	       ghes->generic->header.source_id);
> +}
> +#endif /* CONFIG_ACPI_APEI_SEA */
> +
>  #ifdef CONFIG_HAVE_ACPI_APEI_NMI
>  /*
>   * printk is not safe in NMI context.  So in NMI handler, we allocate
> @@ -1016,6 +1060,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  	case ACPI_HEST_NOTIFY_EXTERNAL:
>  	case ACPI_HEST_NOTIFY_SCI:
>  		break;
> +	case ACPI_HEST_NOTIFY_SEA:
> +		if (!IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
> +			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
> +				generic->header.source_id);
> +			rc = -ENOTSUPP;
> +			goto err;
> +		}
> +		break;
>  	case ACPI_HEST_NOTIFY_NMI:
>  		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
>  			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
> @@ -1081,6 +1133,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  		list_add_rcu(&ghes->list, &ghes_sci);
>  		mutex_unlock(&ghes_list_mutex);
>  		break;
> +	case ACPI_HEST_NOTIFY_SEA:
> +		ghes_sea_add(ghes);
> +		break;
>  	case ACPI_HEST_NOTIFY_NMI:
>  		ghes_nmi_add(ghes);
>  		break;
> @@ -1124,6 +1179,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
>  		mutex_unlock(&ghes_list_mutex);
>  		synchronize_rcu();
>  		break;
> +	case ACPI_HEST_NOTIFY_SEA:
> +		ghes_sea_remove(ghes);
> +		break;
>  	case ACPI_HEST_NOTIFY_NMI:
>  		ghes_nmi_remove(ghes);
>  		break;
> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
> index b89361a..ef0040893 100644
> --- a/include/acpi/ghes.h
> +++ b/include/acpi/ghes.h
> @@ -1,3 +1,6 @@
> +#ifndef GHES_H
> +#define GHES_H
> +
>  #include <acpi/apei.h>
>  #include <acpi/hed.h>
>  
> @@ -95,3 +98,7 @@ static inline void *acpi_hest_get_payload(struct acpi_hest_generic_data *gdata)
>  
>  	return gdata + 1;
>  }
> +
> +void ghes_notify_sea(void);
> +
> +#endif /* GHES_H */
> 

