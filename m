Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB264171C7
	for <kvmarm@lists.linux.dev>; Fri, 16 Jun 2023 09:42:38 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A5B21FB;
	Fri, 16 Jun 2023 02:43:16 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6FEF13F5A1;
	Fri, 16 Jun 2023 02:42:30 -0700 (PDT)
Date: Fri, 16 Jun 2023 10:42:27 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
	oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
	mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/6] arm: pmu: Add extra DSB barriers
 in the mem_access loop
Message-ID: <ZIwug0Oz0RUFisRp@monolith.localdoman>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
 <20230531201438.3881600-4-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531201438.3881600-4-eric.auger@redhat.com>

Hi,

On Wed, May 31, 2023 at 10:14:35PM +0200, Eric Auger wrote:
> The mem access loop currently features ISB barriers only. However
> the mem_access loop counts the number of accesses to memory. ISB
> do not garantee the PE cannot reorder memory access. Let's
> add a DSB ISH before the write to PMCR_EL0 that enables the PMU
> to make sure any previous memory access aren't counted in the
> loop, another one after the PMU gets enabled (to make sure loop
> memory accesses cannot be reordered before the PMU gets enabled)
> and a last one after the last iteration, before disabling the PMU.

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> ---
> 
> v1 -> v2:
> - added yet another DSB after PMU enabled as suggested by Alexandru
> 
> This was discussed in https://lore.kernel.org/all/YzxmHpV2rpfaUdWi@monolith.localdoman/
> ---
>  arm/pmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 51c0fe80..74dd4c10 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -301,13 +301,16 @@ static void mem_access_loop(void *addr, long loop, uint32_t pmcr)
>  {
>  	uint64_t pmcr64 = pmcr;
>  asm volatile(
> +	"       dsb     ish\n"
>  	"       msr     pmcr_el0, %[pmcr]\n"
>  	"       isb\n"
> +	"       dsb     ish\n"
>  	"       mov     x10, %[loop]\n"
>  	"1:     sub     x10, x10, #1\n"
>  	"       ldr	x9, [%[addr]]\n"
>  	"       cmp     x10, #0x0\n"
>  	"       b.gt    1b\n"
> +	"       dsb     ish\n"
>  	"       msr     pmcr_el0, xzr\n"
>  	"       isb\n"
>  	:
> -- 
> 2.38.1
> 
