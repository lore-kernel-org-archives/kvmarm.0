From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 3/7] acpi: apei: remove the unused code
Date: Mon, 11 Sep 2017 20:04:21 +0800
Message-ID: <b06c680c-93a3-7e20-1118-c6a9a24704df@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-4-git-send-email-gengdongjiu@huawei.com>
 <59A84C51.3000506@arm.com> <45c69f99-61dd-e847-368b-20acb61b4d50@huawei.com>
 <59B2DEBA.6030608@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <59B2DEBA.6030608@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

James,
   Thanks for the review.

On 2017/9/9 2:17, James Morse wrote:
> Hi gengdongjiu,
> 
> On 04/09/17 12:43, gengdongjiu wrote:
>> On 2017/9/1 1:50, James Morse wrote:
>>> On 28/08/17 11:38, Dongjiu Geng wrote:
>>>> In current code logic, the two functions ghes_sea_add() and
>>>> ghes_sea_remove() are only called when CONFIG_ACPI_APEI_SEA
>>>> is defined. If not, it will return errors in the ghes_probe()
>>>> and not contiue. Hence, remove the unnecessary handling when
>>>> CONFIG_ACPI_APEI_SEI is not defined.
>>>
>>> This doesn't match what the patch does. I get this feeling this is needed for
>>> some future patch you haven't included.
>>
>> James, let check the code, when the ghes_probe, if the CONFIG_ACPI_APEI_SEA is not defined.
>> it will return -ENOTSUPP and goto error, and the ghes_sea_add has no chance to execute.
>> similar, if the probe is failed, it should not have chance to execute ghes_sea_remove.
> 
> It's the 'unnecessary handling when CONFIG_ACPI_APEI_SEI' in the commit message
> that confuses me: this patch doesn't reference that Kconfig symbol. I guess that
> sentence needs removing for this v6?
 thanks for the pointing out, That needs to be removed for v6.

> 
> Re-reading without that part of the commit-message:
> 
> You're relying on the compiler's dead-code elimination to spot unused static
> functions and silently drop them. Great!
> (there is the small risk that gcc 3.2[0] can't do this, x86 still has to support
> this gcc version)
> 
> As this is just clean-up patch can you break it out of this series, it isn't
> needed to add support for SEI.
sure, I will.

> 
> (This series adds support for what should be an APEI notification, but the only
> code that touches APEI removes some code from a different notification method.)

understand.

> 
> 
>>> Setting NOTIFY_SEI as the GHES entry's notification type means the OS should
>>> check the GHES->ErrorStatusAddress for CPER records when it receives an
>>> SError-Interrupt, as it may be a notification of an error from this error source.
> 
>> previously I added the NOTIFY_SEI support,
> 
> (Yes, I saw that in v5 and expected this series to add some APEI support code )
> 
> 
>> but consider the error address in CPER is not accurate and calling memory_failure() may not make sense.
>> so I remove it.
> 
> 'not accurate'... this is going to be a problem, but lets keep that discussion
> on the cover-letter.

Ok.


> 
> 
>>> If you aren't handling the notification, why is this is in the HEST at all?
>>> (and if its not: its not firmware-first)
> 
>> For the SEI notification, may be we can parse and handle the CPER record other than the Error physical address
> 
> Sure, but I only see this cleanup patch in this series, where does APEI learn
> about NOTIFY_SEI? As this is nothing will ever touch those CPER records, if
> you're using GHESv2 firmware will be prevented from delivering subsequent
> notifications.
James, whether it is possible you can review the previous v5 patch which adds the support for NOTIFY_SEI? thanks in advancecIn that patch, I share the SEI notification handling with the SEA notification handling to avoid duplicated code.

https://www.spinics.net/lists/arm-kernel/msg601767.html

> 
> 
> Thanks,
> 
> James
> 
> [0]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/admin-guide/README.rst#n251
> 
> .
> 

