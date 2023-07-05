Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC7E6FB3
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 11:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688558207; x=1720094207;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ynw6AXf7dszPcSqeI9Ih/R2B7n1Okp1K4vyVoT0Ge+c=;
  b=NRUmmAu/8MQ+exTlqWgnpp3G9zdes8odyXT/nBTr78tVl2/CLkjmD4ak
   5k8TIMSj+ZkoiO+nWjymg/Q8XHfJk4nl8JvjbE4LF9HeYJCRsEBgXRFjP
   dtqT8wsvKT9gFwvIye4Mcv7qgoH3PQcQkt2G7aZTVLTlheN5OTNWyJAzQ
   RnFUeTVqFr/IQRQdCO5WWp6BiQUolOud7OcwG2FqdlKG3aAvLcBek2vMX
   qNm+jSjlbkfsBj5BEvbPNKOLVFgpSs+FZZLlYCgM5SFHkdqr3onDA9u7P
   V1JhIZTPrD8NqLCrHea9QiAIHEYI37dV042E7D49PIid/ow308oHhixEO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="343651493"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="343651493"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 04:56:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="1049670901"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="1049670901"
Received: from jialinji-mobl4.ccr.corp.intel.com (HELO localhost) ([10.255.30.200])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 04:56:41 -0700
Date: Wed, 5 Jul 2023 19:56:53 +0800
From: Yu Zhang <yu.c.zhang@linux.intel.com>
To: David Stevens <stevensd@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
Message-ID: <20230705115653.5whvhvcvmflqmcse@linux.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-4-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704075054.3344915-4-stevensd@google.com>
User-Agent: NeoMutt/20171215

On Tue, Jul 04, 2023 at 04:50:48PM +0900, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Make it so that __kvm_follow_pfn does not imply FOLL_GET. This allows
> callers to resolve a gfn when the associated pfn has a valid struct page
> that isn't being actively refcounted (e.g. tail pages of non-compound
> higher order pages). For a caller to safely omit FOLL_GET, all usages of
> the returned pfn must be guarded by a mmu notifier.
> 
> This also adds a is_refcounted_page out parameter to kvm_follow_pfn that
> is set when the returned pfn has an associated struct page with a valid
> refcount. Callers that don't pass FOLL_GET should remember this value
> and use it to avoid places like kvm_is_ad_tracked_page that assume a
> non-zero refcount.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  include/linux/kvm_host.h | 10 ++++++
>  virt/kvm/kvm_main.c      | 67 +++++++++++++++++++++-------------------
>  virt/kvm/pfncache.c      |  2 +-
>  3 files changed, 47 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ef2763c2b12e..a45308c7d2d9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1157,6 +1157,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
>  void kvm_release_page_clean(struct page *page);
>  void kvm_release_page_dirty(struct page *page);
>  
> +void kvm_set_page_accessed(struct page *page);
> +void kvm_set_page_dirty(struct page *page);
> +
>  struct kvm_follow_pfn {
>  	const struct kvm_memory_slot *slot;
>  	gfn_t gfn;
> @@ -1164,10 +1167,17 @@ struct kvm_follow_pfn {
>  	bool atomic;
>  	/* Allow a read fault to create a writeable mapping. */
>  	bool allow_write_mapping;
> +	/*
> +	 * Usage of the returned pfn will be guared by a mmu notifier. Must
> +	 * be true if FOLL_GET is not set.
> +	 */
> +	bool guarded_by_mmu_notifier;

And how? Any place to check the invalidate seq?

B.R.
Yu
