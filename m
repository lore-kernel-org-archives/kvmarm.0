From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 3/7] acpi: apei: remove the unused code
Date: Fri, 08 Sep 2017 19:17:30 +0100
Message-ID: <59B2DEBA.6030608@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-4-git-send-email-gengdongjiu@huawei.com>
 <59A84C51.3000506@arm.com> <45c69f99-61dd-e847-368b-20acb61b4d50@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9EEB49C65
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 14:16:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3C31lJCgppR5 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Sep 2017 14:16:34 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7524A49C5D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 14:16:34 -0400 (EDT)
In-Reply-To: <45c69f99-61dd-e847-368b-20acb61b4d50@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: wangkefeng.wang@huawei.com, kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, tbaicar@codeaurora.org, will.deacon@arm.com, linuxarm@huawei.com, robert.moore@intel.com, lv.zheng@intel.com, zjzhang@codeaurora.org, mingo@kernel.org, stefan@hello-penguin.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, huangshaoyu@huawei.com, huangdaode@hisilicon.com, bp@suse.de, Dave.Martin@arm.com, lenb@kernel.org, wuquanming@huawei.com, marc.zyngier@arm.com, john.garry@huawei.com, kristina.martsenko@arm.com, cov@codeaurora.org, jonathan.cameron@huawei.com, zhengqiang10@huawei.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com, mst@redhat.com, shiju.jose@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 04/09/17 12:43, gengdongjiu wrote:
> On 2017/9/1 1:50, James Morse wrote:
>> On 28/08/17 11:38, Dongjiu Geng wrote:
>>> In current code logic, the two functions ghes_sea_add() and
>>> ghes_sea_remove() are only called when CONFIG_ACPI_APEI_SEA
>>> is defined. If not, it will return errors in the ghes_probe()
>>> and not contiue. Hence, remove the unnecessary handling when
>>> CONFIG_ACPI_APEI_SEI is not defined.
>>
>> This doesn't match what the patch does. I get this feeling this is needed for
>> some future patch you haven't included.
> 
> James, let check the code, when the ghes_probe, if the CONFIG_ACPI_APEI_SEA is not defined.
> it will return -ENOTSUPP and goto error, and the ghes_sea_add has no chance to execute.
> similar, if the probe is failed, it should not have chance to execute ghes_sea_remove.

It's the 'unnecessary handling when CONFIG_ACPI_APEI_SEI' in the commit message
that confuses me: this patch doesn't reference that Kconfig symbol. I guess that
sentence needs removing for this v6?

Re-reading without that part of the commit-message:

You're relying on the compiler's dead-code elimination to spot unused static
functions and silently drop them. Great!
(there is the small risk that gcc 3.2[0] can't do this, x86 still has to support
this gcc version)

As this is just clean-up patch can you break it out of this series, it isn't
needed to add support for SEI.

(This series adds support for what should be an APEI notification, but the only
code that touches APEI removes some code from a different notification method.)


>> Setting NOTIFY_SEI as the GHES entry's notification type means the OS should
>> check the GHES->ErrorStatusAddress for CPER records when it receives an
>> SError-Interrupt, as it may be a notification of an error from this error source.

> previously I added the NOTIFY_SEI support,

(Yes, I saw that in v5 and expected this series to add some APEI support code )


> but consider the error address in CPER is not accurate and calling memory_failure() may not make sense.
> so I remove it.

'not accurate'... this is going to be a problem, but lets keep that discussion
on the cover-letter.


>> If you aren't handling the notification, why is this is in the HEST at all?
>> (and if its not: its not firmware-first)

> For the SEI notification, may be we can parse and handle the CPER record other than the Error physical address

Sure, but I only see this cleanup patch in this series, where does APEI learn
about NOTIFY_SEI? As this is nothing will ever touch those CPER records, if
you're using GHESv2 firmware will be prevented from delivering subsequent
notifications.


Thanks,

James

[0]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/admin-guide/README.rst#n251
