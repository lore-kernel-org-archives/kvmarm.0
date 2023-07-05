Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A6A137F
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 07:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688541814; x=1720077814;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NS28w+WymzMKhKs2KK3bH5xOvIImsi/4GcjzUcK6qWc=;
  b=DycUrvykXu/+MQPUVrs7LVJidAJ4S4ABZgrmiwHHzL7If6Yb+JPr87+9
   i70UtabVFNNybSWKNN2frODEGnns7wbNchDA9AEMcfaupmCpXHAyW8lsv
   O8RGLbxzvV9gYaxUvkqwHdKLCcEkKW45YxNo53fS/vvG26YfHaPggVtnF
   F+SOEcmQdjfS4yZ0zEjN5IVi4Ywe4tR9OtPX3BQ83NsAHV1Q6cw7eKzmb
   RUQXakVHfHrhzH3yvPT9Bjy2ME4nN/67DjP/KVOtNiDHFTm/zkwjH4/Gm
   pXPe+01Hmy398lhdOJaVUMqCREcdyo5nL8WDK9XV6uXrXHaHOiiDMVNsM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="365838936"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="365838936"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 00:23:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="789062435"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="789062435"
Received: from jialinji-mobl4.ccr.corp.intel.com (HELO localhost) ([10.255.30.200])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 00:23:29 -0700
Date: Wed, 5 Jul 2023 15:23:35 +0800
From: Yu Zhang <yu.c.zhang@linux.intel.com>
To: David Stevens <stevensd@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
Message-ID: <20230705072335.xfest7csh27f67v3@linux.intel.com>
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

>  
> +void kvm_set_page_accessed(struct page *page);
> +void kvm_set_page_dirty(struct page *page);
> +
No one calls these 2 routines in this patch. How about move this change to
[PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn ?

...

> @@ -2930,17 +2933,19 @@ static bool kvm_is_ad_tracked_page(struct page *page)
>  	return !PageReserved(page);
>  }
>  
> -static void kvm_set_page_dirty(struct page *page)
> +void kvm_set_page_dirty(struct page *page)
>  {
>  	if (kvm_is_ad_tracked_page(page))
>  		SetPageDirty(page);
>  }
> +EXPORT_SYMBOL_GPL(kvm_set_page_dirty);
>  
> -static void kvm_set_page_accessed(struct page *page)
> +void kvm_set_page_accessed(struct page *page)
>  {
>  	if (kvm_is_ad_tracked_page(page))
>  		mark_page_accessed(page);
>  }
> +EXPORT_SYMBOL_GPL(kvm_set_page_accessed);

Same here.

B.R.
Yu
