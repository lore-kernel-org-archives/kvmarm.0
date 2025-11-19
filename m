Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD41621B9C0;
	Wed, 19 Nov 2025 00:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763513645; cv=none; b=hZ/1h/tPf5SRVssYPzxd5XQfqpjx2fkFhAui6uUAu7vbA8NFSERmwyrhYaI6N/UaJ8+bs0FVPNW371BJWDN83LfJxUxObbsTxdwR64zQNLVCuNfIYXh10oiHzeLQiXULwpOoN7aVPKW8zNp631fs4QBUEAv61z7DeFj2Ymmf7UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763513645; c=relaxed/simple;
	bh=SpJfGIQpV72H2dtRGzaRjB5DzZJk8SmDJ++Y4B2SDVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXMGMFCqg+NZjZ8Chq3dLHDTEIJuGuFo/HwAXJsICzXxgyIf08B6H4MD3aRYBqS601jdpWBHlNdGwfGN3tGkMnOxF97tlUuzMuqmAj0pC+gC+rYMuWAxwA2zHdxDGqpwgMLGEbQ6tz3EXzVPoingY8J3RobFMNZ8pv976As1b8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoM/x51p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoM/x51p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A199C2BCB6;
	Wed, 19 Nov 2025 00:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763513643;
	bh=SpJfGIQpV72H2dtRGzaRjB5DzZJk8SmDJ++Y4B2SDVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VoM/x51pdvlXZkIb0y3a2nU1/4bS8NbLwuWP8QVhR9Fzbb1Ck9yOE0LIMEknJsCAo
	 1c9Yhj9WTIQXytyIyDy6nfVDBVBMq+gAvmLp7bnRqegoCvV3VQb9BMygT2ThCGVrdi
	 +VqP7NQW36mTUNW5FJkoqhN2A1qlskv9KIh79BMOTPCiAxifEM9z6kIla+ApCNo7Ks
	 iok/zofUPYMqLDTFHA8i1Yc1mLW8zGjQ8zV6hENvF4+jYkEVKEABR44GfcHXucN+R/
	 cqyrQTrXN9Fos0LGQ9TO3XmXg2enU1p7+bBPOgai8Fg4Q5Igs9Rb3WaNyzPISxpFTH
	 x0I98fWDWnRmQ==
Date: Tue, 18 Nov 2025 16:54:01 -0800
From: Oliver Upton <oupton@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <aR0VKf8bdvU72Pq8@kernel.org>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
 <20251117173530.43293-2-vishal.moola@gmail.com>
 <20251118224448.GA998046@ax162>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118224448.GA998046@ax162>

Hi Nathan,

Thanks for reporting this.

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
> Should __GFP_HIGHMEM be dropped from the call to __vmalloc? It looks
> like it was added by commit 115bae923ac8 ("KVM: arm64: Add memcg
> accounting to KVM allocations") back in 5.16.

Yep. May as well switch to kvzalloc() while we're at it.

Thanks,
Oliver
