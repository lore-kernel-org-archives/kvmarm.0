Received: from out-17.mta0.migadu.com (out-17.mta0.migadu.com [91.218.175.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913F43C39
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 10:16:35 +0000 (UTC)
Date: Wed, 15 Feb 2023 09:01:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676451722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YL8FiqAZyLUCZq4oRgddDuK5I4P8SovwyZCvVTtHnXk=;
	b=OGlGrYwouICg6hFpdMRLwXqbG2GLzb2w7hSFELpA3PKXT2pYqZhfKouhG1coiXX8YyPoFf
	H8npIW+vdAxBv6oZxYNVu9JTkcle+ULMzDt8c9pGZygNTt6RZCH/pVxzr3tmJZpUugERSF
	OUWBBu5KeP1+VYjhINHl1dinyKkEvXM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Ben Gardon <bgardon@google.com>,
	David Matlack <dmatlack@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 4/8] kvm: Allow hva_pfn_fast to resolve read-only faults.
Message-ID: <Y+yfhELf/TbsosO9@linux.dev>
References: <20230215011614.725983-1-amoorthy@google.com>
 <20230215011614.725983-5-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215011614.725983-5-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 15, 2023 at 01:16:10AM +0000, Anish Moorthy wrote:
> The upcoming mem_fault_nowait commits will make it so that, when the
> relevant cap is enabled, hva_to_pfn will return after calling
> hva_to_pfn_fast without ever attempting to pin memory via
> hva_to_pfn_slow.
> 
> hva_to_pfn_fast currently just fails for read-only faults. However,
> there doesn't seem to be a reason that we can't just try pinning the
> page without FOLL_WRITE instead of immediately falling back to slow-GUP.
> This commit implements that behavior.
> 
> Suggested-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d255964ec331e..dae5f48151032 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2479,7 +2479,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
>  }
>  
>  /*
> - * The fast path to get the writable pfn which will be stored in @pfn,
> + * The fast path to get the pfn which will be stored in @pfn,
>   * true indicates success, otherwise false is returned.  It's also the
>   * only part that runs if we can in atomic context.
>   */
> @@ -2487,16 +2487,18 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
>  			    bool *writable, kvm_pfn_t *pfn)
>  {
>  	struct page *page[1];
> +	bool found_by_fast_gup =
> +		get_user_page_fast_only(
> +			addr,
> +			/*
> +			 * Fast pin a writable pfn only if it is a write fault request
> +			 * or the caller allows to map a writable pfn for a read fault
> +			 * request.
> +			 */
> +			(write_fault || writable) ? FOLL_WRITE : 0,
> +			page);
>  
> -	/*
> -	 * Fast pin a writable pfn only if it is a write fault request
> -	 * or the caller allows to map a writable pfn for a read fault
> -	 * request.
> -	 */
> -	if (!(write_fault || writable))
> -		return false;
> -
> -	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
> +	if (found_by_fast_gup) {

You could have a smaller diff (and arrive at something more readable)
using a local for the gup flags:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384b5ae0..57f92ff3728a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2494,6 +2494,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 			    bool *writable, kvm_pfn_t *pfn)
 {
+	unsigned int gup_flags;
 	struct page *page[1];
 
 	/*
@@ -2501,10 +2502,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 	 * or the caller allows to map a writable pfn for a read fault
 	 * request.
 	 */
-	if (!(write_fault || writable))
-		return false;
+	gup_flags = (write_fault || writable) ? FOLL_WRITE : 0;
 
-	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+	if (get_user_page_fast_only(addr, gup_flags, page)) {
 		*pfn = page_to_pfn(page[0]);
 
 		if (writable)

-- 
Thanks,
Oliver
