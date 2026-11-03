Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793725395;
	b=UJwun41eU8M2tP+WYMxhylgMmI9HD/wyNRSpChpukWCNL8+TBJRpotvyyRwajAISkawi
	 LdKwAOnPcH6080vrGlioE9fcVZnfpemI/WACUo9K2WpXWvrZBqn1x0qCknz3hJKbPUkE8
	 a9XrUxzuOSqaFcR+B48vwDrZfLiMO6CZ/illw86YxnGbdgQmdhtLN4LOZ8Lo03HjOgSlD
	 EotW8ae5hq/c/n89eodNkMQYob0uiHPA6f7ud4wOPXWYZXPcgJBSMOPXp5lwbcaHiwAc2
	 zLgBC0lUch2NvJ1WklTF8FYlhNlt1AGa+zaFdY5lkuG5p1rvQO2YA7b4GtOcO15ar3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725395;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XniwFWmdWJJxTKlBX3jUY4ryliNwdMdnocDo12kQRnA=;
	b=RtIx1PnNhcJjDvnigWpdNJShhrGsta+WG8hYOewyDh04c/afdRvZmd32m2eojKSMuBgO
	 ZMXOdX3UELlfMlKtntxg00qVL++eGpwKM2YAjkhCbd/1GxTDXw4yICFcVMrRqdyZUKFJn
	 AKK4Co7d4otTD5PKjuMVIbm4zRSrAcUBOSvuHPz32CaLJlynRevYE4le895N1HKi1AZNu
	 0Yj0UhpvVM5PH/VTiRvzpPcwNV357o7/d1C9RrBP+aQWZHw4s816dxgecUYTCBmuQ5FJ7
	 db3ggi6Hd1vbZzY5VZvaL14o1eJjyEuyTOIr7hxoked4PRkkvxCF7hQm6bsFX9L7XFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n5NEqPng;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C66606A328;
	Tue,  3 Nov 2026 17:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n5NEqPng
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D354A1F000C1;
	Tue,  3 Nov 2026 17:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793725395;
	bh=XniwFWmdWJJxTKlBX3jUY4ryliNwdMdnocDo12kQRnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n5NEqPng3ViSCzXGdS1xqMMiuW9nsrOJq+jQasw2mK1EPAC+gI42YyFFbJFiWm6V7
	 DgBZ+c1W/VFRIzCeaqA4gYXHf7Og6X6+kuzd9UTGwVXY6hJfadCJec5LnpnO5ANZuO
	 yCxTUBy9I7NoufAXyvjWWjOTXw6Cql6g9B6SV9BTuWa5twkN2kCUSDYop54lrvpvaA
	 0cgZVwOUklAlNjQkjzRAfWnKfLtPaJsJPSzqM7feSHWl78prGoYPgFUUDSnZa7gBVE
	 VMRcGI/OW4vZbCEPaIgaOPOn8u9hL7DrLbL+gmL9zhVECMxg/BEQYFaBIcLwU3OF45
	 rnlnyXGEzftHA==
Date: Tue, 3 Nov 2026 09:03:13 -0800
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Stop stage-2 teardown scaling with the
 IPA size
Message-ID: <auoT0b1LxuDlZOnc@kernel.org>
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103084742.1302597-1-fuad.tabba@linux.dev>

Hi Fuad,

On Tue, Nov 03, 2026 at 08:47:39AM +0000, Fuad Tabba wrote:
> Hi folks,
> 
> Two fixes for stage-2 teardown, which since 4ddfab5436b6 takes time
> proportional to the size of the IPA space rather than to what is mapped.
> 
> Under QEMU TCG ('-cpu max', 16K pages with LPA2), destroying even an
> empty VM takes about 7 seconds in pKVM. Without pKVM it takes about 19
> seconds if the VM requests a 52-bit IPA (crosvm requests the host's
> limit). I would expect it to scale the same way in hardware. I tested
> only under QEMU, since I don't have hardware with LPA2.
> 
> pKVM gives every VM the host's IPA limit. The first makes it release the
> VM's mappings from its tree instead of walking that space. My series
> honoring KVM_VM_TYPE_ARM_IPA_SIZE in pKVM [1] (respinning it soon)
> doesn't replace the fix, as crosvm requests the limit there too.
> 
> The second makes the non-pKVM teardown step over an empty entry larger
> than the largest block in one go, rather than start a new walk for each
> block-sized chunk of it. It depends on the first, as the lookup it adds
> reads fields that hold the mapping tree on a pKVM stage-2.
> 
> The third moves the pKVM/non-pKVM split in the teardown into
> kvm_vm_s2_ops, with no functional change. The first two apply back to
> 7.1, except that a backport of the second drops the flags argument 7.4
> added to kvm_pgtable_get_leaf().

I don't see why optimized destroy walks for CCA and pKVM is
fundamentally incompatible with driving them from a loop that
reschedules. Non-preemptible kernels are still very much a thing, I'd
rather not undo the fix we took for that exact use case.

So unless I'm missing something completely obvious, I'd rather that CCA
and pKVM do teardowns from that loop.

Thanks,
Oliver
