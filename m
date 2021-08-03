Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEF6C432BE
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 18:05:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D46961040
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 18:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9D46961040
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20AA7407E7;
	Tue,  3 Aug 2021 14:05:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F3bBh-WdGpif; Tue,  3 Aug 2021 14:05:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 856F74A193;
	Tue,  3 Aug 2021 14:05:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C48CB40C88
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 14:05:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eVM92Ah1o0mh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 14:05:40 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83417407E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 14:05:40 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E36260F48;
 Tue,  3 Aug 2021 18:05:34 +0000 (UTC)
Date: Tue, 3 Aug 2021 19:05:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v3] memblock: make memblock_find_in_range method private
Message-ID: <20210803180526.GD5786@arm.com>
References: <20210803064218.6611-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210803064218.6611-1-rppt@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, linux-acpi@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, x86@kernel.org,
 Russell King <linux@armlinux.org.uk>, Mike Rapoport <rppt@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Len Brown <lenb@kernel.org>, devicetree@vger.kernel.org,
 Albert Ou <aou@eecs.berkeley.edu>, Vasily Gorbik <gor@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Rob Herring <robh+dt@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Morton <akpm@linux-foundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Aug 03, 2021 at 09:42:18AM +0300, Mike Rapoport wrote:
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 8490ed2917ff..0bffd2d1854f 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -74,6 +74,7 @@ phys_addr_t arm64_dma_phys_limit __ro_after_init;
>  static void __init reserve_crashkernel(void)
>  {
>  	unsigned long long crash_base, crash_size;
> +	unsigned long long crash_max = arm64_dma_phys_limit;
>  	int ret;
>  
>  	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
> @@ -84,33 +85,18 @@ static void __init reserve_crashkernel(void)
>  
>  	crash_size = PAGE_ALIGN(crash_size);
>  
> -	if (crash_base == 0) {
> -		/* Current arm64 boot protocol requires 2MB alignment */
> -		crash_base = memblock_find_in_range(0, arm64_dma_phys_limit,
> -				crash_size, SZ_2M);
> -		if (crash_base == 0) {
> -			pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
> -				crash_size);
> -			return;
> -		}
> -	} else {
> -		/* User specifies base address explicitly. */
> -		if (!memblock_is_region_memory(crash_base, crash_size)) {
> -			pr_warn("cannot reserve crashkernel: region is not memory\n");
> -			return;
> -		}
> +	/* User specifies base address explicitly. */
> +	if (crash_base)
> +		crash_max = crash_base + crash_size;
>  
> -		if (memblock_is_region_reserved(crash_base, crash_size)) {
> -			pr_warn("cannot reserve crashkernel: region overlaps reserved memory\n");
> -			return;
> -		}
> -
> -		if (!IS_ALIGNED(crash_base, SZ_2M)) {
> -			pr_warn("cannot reserve crashkernel: base address is not 2MB aligned\n");
> -			return;
> -		}
> +	/* Current arm64 boot protocol requires 2MB alignment */
> +	crash_base = memblock_phys_alloc_range(crash_size, SZ_2M,
> +					       crash_base, crash_max);
> +	if (!crash_base) {
> +		pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
> +			crash_size);
> +		return;
>  	}
> -	memblock_reserve(crash_base, crash_size);

We'll miss a bit on debug information provided to the user in case of a
wrong crash_base/size option on the command line. Not sure we care much,
though the alignment would probably be useful (maybe we document it
somewhere).

What I haven't checked is whether memblock_phys_alloc_range() aims to
get a 2MB aligned end (size) as well. If crash_size is not 2MB aligned,
crash_max wouldn't be either and the above could fail. We only care
about the crash_base to be aligned but the memblock_phys_alloc_range()
doc says that both the start and size would be aligned to this.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
