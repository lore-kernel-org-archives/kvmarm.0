From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 3/7] acpi: apei: remove the unused code
Date: Mon, 4 Sep 2017 19:43:59 +0800
Message-ID: <45c69f99-61dd-e847-368b-20acb61b4d50@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-4-git-send-email-gengdongjiu@huawei.com>
 <59A84C51.3000506@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <59A84C51.3000506@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2017/9/1 1:50, James Morse wrote:
> Hi Dongjiu Geng,
> 
> On 28/08/17 11:38, Dongjiu Geng wrote:
>> In current code logic, the two functions ghes_sea_add() and
>> ghes_sea_remove() are only called when CONFIG_ACPI_APEI_SEA
>> is defined. If not, it will return errors in the ghes_probe()
>> and not contiue. Hence, remove the unnecessary handling when
>> CONFIG_ACPI_APEI_SEI is not defined.
> 
> This doesn't match what the patch does. I get this feeling this is needed for
> some future patch you haven't included.

James, let check the code, when the ghes_probe, if the CONFIG_ACPI_APEI_SEA is not defined.
it will return -ENOTSUPP and goto error, and the ghes_sea_add has no chance to execute.
similar, if the probe is failed, it should not have chance to execute ghes_sea_remove.

static int ghes_probe(struct platform_device *ghes_dev)
{
	struct acpi_hest_generic *generic;
	struct ghes *ghes = NULL;

	int rc = -EINVAL;

	generic = *(struct acpi_hest_generic **)ghes_dev->dev.platform_data;
	if (!generic->enabled)
		return -ENODEV;

	switch (generic->notify.type) {
	case ACPI_HEST_NOTIFY_POLLED:
	case ACPI_HEST_NOTIFY_EXTERNAL:
	case ACPI_HEST_NOTIFY_SCI:
	case ACPI_HEST_NOTIFY_GSIV:
	case ACPI_HEST_NOTIFY_GPIO:
		break;

	case ACPI_HEST_NOTIFY_SEA:
		if (!IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
				generic->header.source_id);
			rc = -ENOTSUPP;
			goto err;
		}
		break;

> 
> 
>> change since v5:
>> 1. remove the SEI notification type handling, because the SEI is
>>    asynchronous exception and the address is not accurate. so
>>    not call memory_failure() to handle it.
> 
> Setting NOTIFY_SEI as the GHES entry's notification type means the OS should
> check the GHES->ErrorStatusAddress for CPER records when it receives an
> SError-Interrupt, as it may be a notification of an error from this error source.
previously I added the NOTIFY_SEI support, but consider the error address in CPER is not accurate and calling memory_failure() may not make sense.
so I remove it.

> 
> If you aren't handling the notification, why is this is in the HEST at all?
> (and if its not: its not firmware-first)
For the SEI notification, may be we can parse and handle the CPER record other than the Error physical address

> 
> 
> James
> 
> 
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index d661d452b238..c15a08db2c7c 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -813,7 +813,6 @@ static struct notifier_block ghes_notifier_hed = {
>>  	.notifier_call = ghes_notify_hed,
>>  };
>>
>> -#ifdef CONFIG_ACPI_APEI_SEA
>>  static LIST_HEAD(ghes_sea);
>>
>>  /*
>> @@ -848,19 +847,6 @@ static void ghes_sea_remove(struct ghes *ghes)
>>  	mutex_unlock(&ghes_list_mutex);
>>  	synchronize_rcu();
>>  }
>> -#else /* CONFIG_ACPI_APEI_SEA */
>> -static inline void ghes_sea_add(struct ghes *ghes)
>> -{
>> -	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not
> supported\n",
>> -	       ghes->generic->header.source_id);
>> -}
>> -
>> -static inline void ghes_sea_remove(struct ghes *ghes)
>> -{
>> -	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not
> supported\n",
>> -	       ghes->generic->header.source_id);
>> -}
>> -#endif /* CONFIG_ACPI_APEI_SEA */
>>
>>  #ifdef CONFIG_HAVE_ACPI_APEI_NMI
>>  /*
>>
> 
> 
> .
> 
