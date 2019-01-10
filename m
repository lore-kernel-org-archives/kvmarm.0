From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 04/25] ACPI / APEI: Make hest.c manage the estatus
 memory pool
Date: Thu, 10 Jan 2019 18:20:35 +0000
Message-ID: <7f1621ac-09ba-71c0-d47d-e9ad61660307@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-5-james.morse@arm.com>
 <20181211164802.GI27375@zn.tnic>
 <ad48f9a1-404e-7878-3173-f8a4a417a723@arm.com>
 <20181219144234.GA31643@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D2E4A47C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 13:20:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qsoub+4ho7JT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 13:20:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 809A94A433
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 13:20:40 -0500 (EST)
In-Reply-To: <20181219144234.GA31643@zn.tnic>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Borislav Petkov <bp@alien8.de>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Boris,

On 19/12/2018 14:42, Borislav Petkov wrote:
> On Fri, Dec 14, 2018 at 01:56:16PM +0000, James Morse wrote:
>> /me digs a bit,
>>
>> ghes_estatus_pool_init() allocates memory from hest_ghes_dev_register().
>> Its caller is behind a 'if (!ghes_disable)' in acpi_hest_init(), and is after
>> another 2 calls to apei_hest_parse().
>>
>> If ghes_disable is set, we don't call this thing.
>> If hest_disable is set, acpi_hest_init() exits early.
>> If we don't have a HEST table, acpi_hest_init() exits early.
>>
>> ... if the HEST table doesn't have any GHES entries, hest_ghes_dev_register() is
>> called with ghes_count==0, and does nothing useful. (kmalloc_alloc_array(0,...)
>> great!) But we do call ghes_estatus_pool_init().
>>
>> I think a check that ghes_count is non-zero before calling
>> hest_ghes_dev_register() is the cleanest way to avoid this.
> 
> Grrr, what an effing mess that code is! There's hest_disable *and*
> ghes_disable. Do we really need them both?

ghes_disable lets you ignore the firmware-first notifications, but still 'use'
the other error sources:
drivers/pci/pcie/aer.c picks out the three AER types, and uses apei_hest_parse()
to know if firmware is controlling AER, even if ghes_disable is set.

x86's arch_apei_enable_cmcff() looks like it disables MCE to get firmware to
handle them. hest_disable would stop this, but instead ghes_disable keeps that,
and stops the NOTIFY_NMI being registered.


> With my simplifier hat on I wanna say, we should have a single switch -
> apei_disable - and kill those other two. What a damn mess that is.

(do you consider cmdline arguments as ABI, or hard to justify and hard to remove?)

I don't think its broken enough to justify ripping them out. A user of
ghes_disable would be someone with broken firmware-first handling of AER. They
need to know firmware is changing the register values behind their back (so need
to parse the HEST), but want to ignore the junk notifications. It doesn't sound
like an unlikely scenario.


>> I wanted the estatus pool to be initialised before creating the platform devices
>> in case the order of these things is changed in the future and they get probed
>> immediately, before the pool is initialised.
> 
> Hmmm.
> 
> Actually, I meant flipping those two calls:
> 
>         rc = ghes_estatus_pool_init(ghes_count);
>         if (rc)
>                 goto out;
> 
>         rc = apei_hest_parse(hest_parse_ghes, &ghes_arr);
>         if (rc)
>                 goto err;
> 
> to
> 
>         rc = apei_hest_parse(hest_parse_ghes, &ghes_arr);
>         if (rc)
>                 goto err;
> 
>         rc = ghes_estatus_pool_init(ghes_count);
>         if (rc)
>                 goto out;
> 
> so as not to alloc the pool unnecessarily if the parsing fails.
> 
> Also, AFAICT, the order you have them in now might be a problem anyway
> if
> 
> 	apei_hest_parse(hest_parse_ghes, &ghes_arr);
> 
> fails because then you goto err and and that pool leaks, right?

Right, yes. I've been ignoring errors like this on the probe path as it implies
you've got busted ACPI tables, or so little memory you're never going to make it
to user-space. I was more worried about ghes_probe() trying to use the pool
memory before its been allocated. I doesn't seem right to register the device if
the driver wouldn't work yet. But one is an subsys_initcall(), the drivers is
device_initcall(), which is obvious enough.

Fixed.


Thanks,

James
