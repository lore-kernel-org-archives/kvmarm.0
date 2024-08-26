Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D054E14B08E;
	Mon, 26 Aug 2024 10:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724668903; cv=none; b=mlcelXgTi1iqnDoeSzDjM5ApIi/w1kxgKmVNF1J/ZIbnc80d0M7+b4xkXeTgNkDeF/mTTz6u4oTEEEPeWvU3dGpxUgdbDaKxmRSqVE7fqETdmeRuBZ+wPRVMB2SPVlPtKyCZDOxxEHEBIRXELeprJtPnt2CaD4Myaf3YSg/C7Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724668903; c=relaxed/simple;
	bh=OaR1tbVDdm/m5K9cLg9sPIowmN8GOxy2+PGzwGloHPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPtJUCap5IYCO9bKLp/WGL/3lSH8Bcmi+ZqVBdteupLRD/VrVWLKvtnzLC9PWE6af9ysf2oY2zommqA+J0Pu+2zfH7mG/65zUajdO8ICqZSmnM0f+lsocgHOnfM2MAgR3AtSeNRKQqjni/FGNKc+hzesAETSjn8gEBEVv24CkFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC6BC51408;
	Mon, 26 Aug 2024 10:41:39 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:41:48 +0300
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 15/19] arm64: mm: Avoid TLBI when marking pages as
 valid
Message-ID: <Zsxb7MpUklPK3Chf@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-16-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-16-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:20PM +0100, Steven Price wrote:
> When __change_memory_common() is purely setting the valid bit on a PTE
> (e.g. via the set_memory_valid() call) there is no need for a TLBI as
> either the entry isn't changing (the valid bit was already set) or the
> entry was invalid and so should not have been cached in the TLB.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
