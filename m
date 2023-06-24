Received: from out-3.mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE31441A
	for <kvmarm@lists.linux.dev>; Sat, 24 Jun 2023 10:13:23 +0000 (UTC)
Date: Sat, 24 Jun 2023 12:13:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687601601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TP//9uOXaQPIhCd8w8M1tweFn2VFp9RaPFS617DoYxE=;
	b=AIN2KWxBORHkjJJNs8z7iCtuhsw5OJu5kOdtA2QjLH+DDBX6GsINgrLU44Hz6cVwIkgnaw
	/rzRUf0PSfw3Q9GrsN7I4+93ONgFzQRwnYK3y904Q8IeRnKtQydP09n7Z+BwGMwiLlht7I
	ZiBxr2AA1M8kkCnma4FlLPdNvJNNQ9g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH 2/6] lib/stack: print base addresses on efi
Message-ID: <20230624-9983c4a6d41751719785a95c@orel>
References: <20230617014930.2070-1-namit@vmware.com>
 <20230617014930.2070-3-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230617014930.2070-3-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 17, 2023 at 01:49:26AM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Making sense from dumped stacks when running EFI tests is very hard due
> to the relocation. Fix it by adjusting the address back to the original
> address.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  lib/stack.c | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/stack.c b/lib/stack.c
> index bdb23fd..c3c7c24 100644
> --- a/lib/stack.c
> +++ b/lib/stack.c
> @@ -6,13 +6,38 @@
>   */
>  
>  #include <libcflat.h>
> +#include <stdbool.h>
>  #include <stack.h>
>  
>  #define MAX_DEPTH 20
>  
> +#ifdef CONFIG_EFI

We also relocate when building non-efi arm64 unit tests, so this should be

#if defined(CONFIG_EFI) || defined(__aarch64__)

Or, we could create a new config, CONFIG_RELOC, which gets set by
--enable-efi and --arch=arm64.

> +extern char _text, _etext;
> +
> +static bool base_address(const void *rebased_addr, unsigned long *addr)
> +{
> +	unsigned long ra = (unsigned long)rebased_addr;
> +	unsigned long start = (unsigned long)&_text;
> +	unsigned long end = (unsigned long)&_etext;
> +
> +	if (ra < start || ra >= end)
> +		return false;
> +
> +	*addr = ra - start;
> +	return true;
> +}
> +#else
> +static bool base_address(const void *rebased_addr, unsigned long *addr)
> +{
> +	*addr = (unsigned long)rebased_addr;
> +	return true;
> +}
> +#endif
> +
>  static void print_stack(const void **return_addrs, int depth,
>  			bool top_is_return_address)
>  {
> +	unsigned long addr;
>  	int i = 0;
>  
>  	printf("\tSTACK:");
> @@ -20,12 +45,14 @@ static void print_stack(const void **return_addrs, int depth,
>  	/* @addr indicates a non-return address, as expected by the stack
>  	 * pretty printer script. */
>  	if (depth > 0 && !top_is_return_address) {
> -		printf(" @%lx", (unsigned long) return_addrs[0]);
> +		if (base_address(return_addrs[0], &addr))
> +			printf(" @%lx", addr);
>  		i++;
>  	}
>  
>  	for (; i < depth; i++) {
> -		printf(" %lx", (unsigned long) return_addrs[i]);
> +		if (base_address(return_addrs[i], &addr))
> +			printf(" %lx", addr);
>  	}
>  	printf("\n");
>  }
> -- 
> 2.34.1
>

Thanks,
drew
