Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B5016EC0D;
	Fri, 21 Jun 2024 09:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718960745; cv=none; b=OBNZiQQjDxcwAXqc5abrx86beSHr/FGxDPicxXnQfkAr/l22IDa70h5za0G9ivuUOg2AQP/fP4pFlEhDWIxdVtEyKeDUTHxtPzoeY6gy6PnijkdtSi7yOAIIJWUCd3CzBhMPFm40ga/KacruFLF/Gi5Hi2JuJA45NXAfs1BXTPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718960745; c=relaxed/simple;
	bh=V3V3ryEvfuk9Oh1Yj4N9vt5Y8XhKqDvU6couN4ROQtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lwINgy2QnVLFqJnpPB1qDLuCiJ0JxbrOltvXzFh8hpMI5iCvwU7bsMQPoP6Pva8mFyBTXz/iOlgwZSDclCVxVy/+MvSSusDw5VsDhPpU2bD/NDPqmLxYi28/CUPh9n7H9OP17LFZcRhhtOiwCeehpstYVzxCVZAin7gVLQxDlQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE7EC4AF09;
	Fri, 21 Jun 2024 09:05:41 +0000 (UTC)
Date: Fri, 21 Jun 2024 10:05:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 09/14] arm64: Enable memory encrypt for Realms
Message-ID: <ZnVCYzqBgndMzOb3@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-10-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605093006.145492-10-steven.price@arm.com>

On Wed, Jun 05, 2024 at 10:30:01AM +0100, Steven Price wrote:
> +static int __set_memory_encrypted(unsigned long addr,
> +				  int numpages,
> +				  bool encrypt)
> +{
> +	unsigned long set_prot = 0, clear_prot = 0;
> +	phys_addr_t start, end;
> +	int ret;
> +
> +	if (!is_realm_world())
> +		return 0;
> +
> +	if (!__is_lm_address(addr))
> +		return -EINVAL;
> +
> +	start = __virt_to_phys(addr);
> +	end = start + numpages * PAGE_SIZE;
> +
> +	/*
> +	 * Break the mapping before we make any changes to avoid stale TLB
> +	 * entries or Synchronous External Aborts caused by RIPAS_EMPTY
> +	 */
> +	ret = __change_memory_common(addr, PAGE_SIZE * numpages,
> +				     __pgprot(0),
> +				     __pgprot(PTE_VALID));
> +
> +	if (encrypt) {
> +		clear_prot = PROT_NS_SHARED;
> +		ret = rsi_set_memory_range_protected(start, end);
> +	} else {
> +		set_prot = PROT_NS_SHARED;
> +		ret = rsi_set_memory_range_shared(start, end);
> +	}

While reading Michael's replies, it occurred to me that we need check
the error paths. Here for example we ignore the return code from
__change_memory_common() by overriding the 'ret' variable.

I think the only other place where we don't check at all is the ITS
allocation/freeing. Freeing is more interesting as I think we should not
release the page back to the kernel if we did not manage to restore the
original state. Better have a memory leak than data leak.

-- 
Catalin
