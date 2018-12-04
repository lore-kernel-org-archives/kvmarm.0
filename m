From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 03/25] ACPI / APEI: Switch estatus pool to use vmalloc
 memory
Date: Tue, 4 Dec 2018 14:01:24 +0100
Message-ID: <20181204130124.GE11803@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-4-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85BCF4A1DC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 08:01:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QK3X1wDsTEtZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 08:01:33 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7AA54A1D8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 08:01:33 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-4-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 03, 2018 at 06:05:51PM +0000, James Morse wrote:
> The ghes code is careful to parse and round firmware's advertised
> memory requirements for CPER records, up to a maximum of 64K.
> However when ghes_estatus_pool_expand() does its work, it splits
> the requested size into PAGE_SIZE granules.
> 
> This means if firmware generates 5K of CPER records, and correctly
> describes this in the table, __process_error() will silently fail as it
> is unable to allocate more than PAGE_SIZE.
> 
> Switch the estatus pool to vmalloc() memory. On x86 vmalloc() memory
> may fault and be fixed up by vmalloc_fault(). To prevent this call
> vmalloc_sync_all() before an NMI handler could discover the memory.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  drivers/acpi/apei/ghes.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index e8503c7d721f..c15264f2dc4b 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -170,40 +170,40 @@ static int ghes_estatus_pool_init(void)
>  	return 0;
>  }
>  
> -static void ghes_estatus_pool_free_chunk_page(struct gen_pool *pool,
> +static void ghes_estatus_pool_free_chunk(struct gen_pool *pool,
>  					      struct gen_pool_chunk *chunk,
>  					      void *data)
>  {
> -	free_page(chunk->start_addr);
> +	vfree((void *)chunk->start_addr);
>  }
>  
>  static void ghes_estatus_pool_exit(void)
>  {
>  	gen_pool_for_each_chunk(ghes_estatus_pool,
> -				ghes_estatus_pool_free_chunk_page, NULL);
> +				ghes_estatus_pool_free_chunk, NULL);
>  	gen_pool_destroy(ghes_estatus_pool);
>  }
>  
>  static int ghes_estatus_pool_expand(unsigned long len)
>  {
> -	unsigned long i, pages, size, addr;
> -	int ret;
> +	unsigned long size, addr;
>  
>  	ghes_estatus_pool_size_request += PAGE_ALIGN(len);

So here we increment with page-aligned len...

>  	size = gen_pool_size(ghes_estatus_pool);
>  	if (size >= ghes_estatus_pool_size_request)
>  		return 0;
> -	pages = (ghes_estatus_pool_size_request - size) / PAGE_SIZE;
> -	for (i = 0; i < pages; i++) {
> -		addr = __get_free_page(GFP_KERNEL);
> -		if (!addr)
> -			return -ENOMEM;
> -		ret = gen_pool_add(ghes_estatus_pool, addr, PAGE_SIZE, -1);
> -		if (ret)
> -			return ret;
> -	}
>  
> -	return 0;
> +	addr = (unsigned long)vmalloc(PAGE_ALIGN(len));
> +	if (!addr)
> +		return -ENOMEM;

... and if we return here due to the ENOMEM, that increment above
remains.

I see you're reworking all that stuff in the next patches which is cool,
thx. So I guess we should leave it as is, as the code before was broken
too.

IOW,

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
