Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0A129CA
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 12:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BDDC433D6;
	Wed, 19 Oct 2022 12:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666183483;
	bh=rhpWY7O0NQoBza1n1SpZHiZbXLW4xC6Pj2/Iz8lNLpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kYFIGw0Bnwks1cn+rqik2vs8XaJxuEP9taOpstfraaTKvFBqXKvlXqZuwXjihv8fR
	 Qa/RdkogYTG3MdYA//0X5LrjioyWQntYxEeAs1dPfPRTe6fjeuUBj/9Z28ZHCDluZj
	 9RoaLumJpjfGABVo/H3+pJU4mbQnYT17F2cOV6AVTOCQqLDmx+x2J7OGFhrG4Edkwr
	 eEkcNUa2p20uM48Zft9pweaPwiBsbcNYvyqwmir158/9e9Z3sJK5baPTwxQ3lJSsnY
	 b7ECEKmeTXgaCqq1eDqT9sv1uqSVhitGo6yazsuUdf+sj9WQIL4ek2rrNkexNInpqu
	 g/P2RoQRLAg3w==
Date: Wed, 19 Oct 2022 13:44:36 +0100
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <20221019124435.GB4220@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
 <Y07W63YlwZ6yClOi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y07W63YlwZ6yClOi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Oct 18, 2022 at 04:40:11PM +0000, Quentin Perret wrote:
> On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > +static void *map_donated_memory_noclear(unsigned long host_va, size_t size)
> > +{
> > +	void *va = (void *)kern_hyp_va(host_va);
> > +
> > +	if (!PAGE_ALIGNED(va))
> > +		return NULL;
> > +
> > +	if (__pkvm_host_donate_hyp(hyp_virt_to_pfn(va),
> > +				   PAGE_ALIGN(size) >> PAGE_SHIFT))
> > +		return NULL;
> > +
> > +	return va;
> > +}
> > +
> > +static void *map_donated_memory(unsigned long host_va, size_t size)
> > +{
> > +	void *va = map_donated_memory_noclear(host_va, size);
> > +
> > +	if (va)
> > +		memset(va, 0, size);
> > +
> > +	return va;
> > +}
> > +
> > +static void __unmap_donated_memory(void *va, size_t size)
> > +{
> > +	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
> > +				       PAGE_ALIGN(size) >> PAGE_SHIFT));
> > +}
> > +
> > +static void unmap_donated_memory(void *va, size_t size)
> > +{
> > +	if (!va)
> > +		return;
> > +
> > +	memset(va, 0, size);
> > +	__unmap_donated_memory(va, size);
> > +}
> > +
> > +static void unmap_donated_memory_noclear(void *va, size_t size)
> > +{
> > +	if (!va)
> > +		return;
> > +
> > +	__unmap_donated_memory(va, size);
> > +}
> 
> Nit: I'm not a huge fan of the naming here, these do more than just
> map/unmap random pages. This only works for host pages, the donation
> path has permission checks, etc. Maybe {admit,return}_host_memory()?

Hmm, so I made this change locally and I found return_host_memory() to be
really hard to read, particularly on error paths where we 'goto' an error
label and have calls to 'return_host_memory' before an actual 'return'
statement.

So I've left as-is, not because I'm tied to the existing names, but because
I did struggle with your suggestion. At the end of the day, these are static
functions so it's really easy to change the name later on if we can think
of something better.

Will
