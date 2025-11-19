Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65162DF71B
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 05:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763531074; cv=none; b=nki1pLhMMgwk8UvxMbysRJNnr31QKW8tBaa8J6XWKPbOHLDMUuteo3iEOgy892tvLocCf3Ali1DldPowfotWIIa4J+DcnE/Yaq85C6oVrrKnd5aScpb1MQyxeKjco9i6rz9c9Q+ItRPRvMa68VUVN6OIoTJkI4Db6SjUXg5laS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763531074; c=relaxed/simple;
	bh=TGnNqb2r1cDMuthDYBk4lgr4HJ549ORduiyXUtwDnS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e3OjeYlDVzox+SEGFTiaeRgqUeQh0AO7avDFGyctAWwZTx4HD+l5V1djVxX+c4fsh8pabj5Rtr5SwOIGo/xMpGueA0Dw6A/Ra4nJ+WO/jGGV+WHTGNbWmvG1EiCFNE5WCvN1oVCOS4l2Tl3pdE6l9VPVnqQApH1MlEGHbG+Gwb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D8E6068AFE; Wed, 19 Nov 2025 06:44:28 +0100 (CET)
Date: Wed, 19 Nov 2025 06:44:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <20251119054428.GC19925@lst.de>
References: <20251117173530.43293-1-vishal.moola@gmail.com> <20251117173530.43293-2-vishal.moola@gmail.com> <20251118224448.GA998046@ax162>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118224448.GA998046@ax162>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 18, 2025 at 03:44:48PM -0700, Nathan Chancellor wrote:
> where kvm_arch_alloc_vm() from arch/arm64/kvm/arm.c is
> 
>   struct kvm *kvm_arch_alloc_vm(void)
>   {
>       size_t sz = sizeof(struct kvm);
> 
>       if (!has_vhe())
>           return kzalloc(sz, GFP_KERNEL_ACCOUNT);
> 
>       return __vmalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_HIGHMEM | __GFP_ZERO);
>   }
> 
> Should __GFP_HIGHMEM be dropped from the call to __vmalloc?

Yes.  vmalloc uses highmem internally where useful (on arm64 it won't be
useful of course).

