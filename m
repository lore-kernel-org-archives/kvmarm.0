Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C428C389DF0;
	Wed, 13 May 2026 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778693029; cv=none; b=bSU96bTLDHWcEACBQa9/rcL2ZwvKGu7RicHGiJlClY5Nfk/rAy1EZ9cQmeaNpA0nKdzC1E+LcNjcc1w83SJyQ/RDNrnHOgt/N4ujofI55ErwXpWJjwa4skQ2jeoYbcxpVG3sP6wsKAiXFChHH9lM5zlXQI5FU6kTnACBqFYqgsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778693029; c=relaxed/simple;
	bh=bVCUB+XEkZ4ZZOEMStNH8O+vVXyBxeWbiKPyxemPMoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dAbioTxXLbKKYt8GtcvHfwvEXnDzjfL1S6Q5c2ju3dDlSk9L9d9Et6bn3O35e6z4mmvqAMgmjxgMr/x0baVUv8v1YvcEDMlvpxjCDrvZ9tlUzQ4/lmbr0b0nRm88LDuzWboSNDh7F0cSVEbRrsmZgTkkM9CbIDN/v6LIt1SauDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKKGdtbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKKGdtbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651B7C2BCB7;
	Wed, 13 May 2026 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778693028;
	bh=bVCUB+XEkZ4ZZOEMStNH8O+vVXyBxeWbiKPyxemPMoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AKKGdtbP2IKmlSlB/reSdavwF9cRGIGy/x+5lin8na7Xy3QaAhy82iwgCj4ObYrrF
	 lPbtThIyK2Toh7Hvxenq+NZB2Kscd1J9UrtdiDL80aoOUK7+/Q5w6bD0dZAeggDk2A
	 YMNoM57+WSWlCJxJ6RCelyJxDa3HUCY94Xh+uWxHkj1We4sK9hn0W2S6rd8Mej3/U+
	 /7OsGzJX9FaUyKhUyFTp1QfltlBxBmzgrDTsLnbboqLZvf8Uh7smupTvRbhCLcsktA
	 S7ffRftzKjWsmjPwocyv6KgzFWGyo3NYlD3/8h/f8RzTiRb9mehDZF8AjBGwqPrzX1
	 cthG00VUIrhNA==
Date: Wed, 13 May 2026 18:23:43 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>, will@kernel.org,
	joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3 0/2] arm_ffa, KVM: Fix FF-A emad offset calculations
Message-ID: <20260513-ludicrous-beautiful-cuttlefish-34271d@sudeepholla>
References: <20260512124442.1899107-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512124442.1899107-1-sebastianene@google.com>

On Tue, May 12, 2026 at 12:44:40PM +0000, Sebastian Ene wrote:
> Hi all,
> 
> This series fixes the Endpoint Memory Access Descriptor (EMAD) offset calculations
> and adds the necessary bounds checks for both the core FF-A driver and the pKVM
> hypervisor.
> 
> Prior to FF-A version 1.1, the memory region header didn't specify an explicit offset
> for the EMADs, leading to the assumption that they immediately follow the header.
> However, from v1.1 onwards, the specification dictates using the `ep_mem_offset` field
> to determine the start of the memory access array.
> 
> The patches in this series address this by:
> 1. Updating the core `arm_ffa` firmware driver to correctly calculate the descriptor
>    offset using `ep_mem_offset` rather than defaulting to `sizeof(struct ffa_mem_region)`.
>    It also introduces bounds checking against `max_fragsize`.
> 2. Enhancing the pKVM hypervisor validation logic to no longer strictly enforce that
>    the descriptor strictly follows the header, aligning it with the driver behavior
>    and the FF-A specification, while also ensuring the offset falls within the mailbox
>    buffer bounds.
>

Looks good apart from the minor nits, but how do you plan to route these
changes as they are dependent for functionality but not for the build IIUC.

I don't think I have any conflicting change so far, so it can go along with
other pKVM changes. Let me know.

> Changelog
> #########
> 
> v2 -> this:
> - Fixed typo in nvhe/ffa.c (missing sizeof)
> 
> v1 -> v2:
> - For pKVM, removed the strict placement enforcement for `ep_mem_offset` as it is not
>   compliant with the spec, and avoids making assumptions about the driver's memory
>   layout.
> 
> Link to:
> ########
> 
> v2: https://lore.kernel.org/all/20260430160241.1934777-1-sebastianene@google.com/
> v1: https://lore.kernel.org/all/ae9KN9nkOgDYJcGP@google.com/T/#t
> 
> Sebastian Ene (2):
>   firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset
>     calculation
>   KVM: arm64: Validate the offset to the mem access descriptor
> 
>  arch/arm64/kvm/hyp/nvhe/ffa.c     | 24 ++++++++++++++++++------
>  drivers/firmware/arm_ffa/driver.c | 14 ++++++++++----
>  include/linux/arm_ffa.h           |  2 +-
>  3 files changed, 29 insertions(+), 11 deletions(-)
> 
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 

-- 
Regards,
Sudeep
