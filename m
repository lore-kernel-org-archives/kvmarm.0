From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix HYP unmapping going off limits
Date: Mon, 11 Dec 2017 09:19:42 +0000
Message-ID: <61a6f0bd-cdfc-e569-6289-b969b80a1f2f@arm.com>
References: <20171207114545.23845-1-marc.zyngier@arm.com>
 <20171211090520.GC910@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D660E49D1F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 04:16:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IySlXqMFdVrC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 04:16:19 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC95449D14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 04:16:19 -0500 (EST)
In-Reply-To: <20171211090520.GC910@cbox>
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
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/12/17 09:05, Christoffer Dall wrote:
> On Thu, Dec 07, 2017 at 11:45:45AM +0000, Marc Zyngier wrote:
>> When we unmap the HYP memory, we try to be clever and unmap one
>> PGD at a time. If we start with a non-PGD aligned address and try
>> to unmap a whole PGD, things go horribly wrong in unmap_hyp_range
>> (addr and end can never match, and it all goes really badly as we
>> keep incrementing pgd and parse random memory as page tables...).
>>
>> The obvious fix is to let unmap_hyp_range do what it does best,
>> which is to iterate over a range.
> 
> Would you mind terribly if I add the following to the commit message?
> 
>   The size of the linear mapping, which begins at PAGE_OFFSET, can be
>   easily calculated by subtracting PAGE_OFFSET form high_memory, because
>   high_memory is defined as the linear map address of the last byte of
>   DRAM, plus one.
>   
>   The size of the vmalloc region is given trivially by VMALLOC_END -
>   VMALLOC_START.

Please do!

> Otherwise:
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
