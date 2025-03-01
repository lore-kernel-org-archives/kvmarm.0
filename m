Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA211C5D59;
	Sat,  1 Mar 2025 07:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740815936; cv=none; b=QwoMTqQLm1evpzOEvwEP7ICrCkJ2NMAbs7xLW8vuU1LljotkQKHNViGZhtvKk93CH028+SR4Y/dYpt8bekeFkW4OFSxm8AF3ZueIx12eoZUxcpk6LfinRBREVNaDbsHGfc35HODDVADVAApQp94hY3kXloas6IumZ7EIh6mE+ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740815936; c=relaxed/simple;
	bh=+7SBZeyhvdU8q8qqLxjcyLKtSgS5euL5/BSRG+GzYnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SNMp0qgc7JgmZ7DJFBErW3wgl73qHmLFwXfkIpQ+ntbWEEaymTYHpvGDWgakLjlS0tXJ+aCD0WzsanfhUiLUA2vlxJRt2m+XABawYJerjnMH4CvkriEPoTqQqJRfN6dEXK8qFD0Wqm2vkwaADMEXrLfvZVUw2LsHdyFrMFMuu3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niS/4gm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niS/4gm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EE6C4CEE5;
	Sat,  1 Mar 2025 07:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740815936;
	bh=+7SBZeyhvdU8q8qqLxjcyLKtSgS5euL5/BSRG+GzYnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=niS/4gm5vcOZNiqb4rtWstswYmO9WOXfWp21xuJROGBuwNHHrzN2JlaXdUA36BDDA
	 6Uq+KW1rsVqqQKvu+WC0aqBezbeYx4JJhg5iq6BMQYEaeywqD/GVztbNLdumonJFZ5
	 5jsf3qdLSn4GXlAGw4BDgAjbcLwTk2xqu64PV12c8Wv3FVgmMADpr0wk+gupPTr7JD
	 Q59K3Xp8pdgR2I4WLH5bZYpmYSSuzNs5m9oKbvYA2xMKnWE8ik8XYN2F37PZu4Rn5C
	 IAGLbfEgShX/o5ZK1Fnf0FavSAyqnuMEa8njKofeJL3Xq5DIxfwoPhm7l1MM8GprJn
	 MqyVkDZDfMLOQ==
Date: Sat, 1 Mar 2025 07:58:50 +0000
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Mark Brown <robh@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/7] arm64/boot: Enable EL2 requirements for
 FEAT_PMUv3p9
Message-ID: <20250301075849.GA28249@willie-the-truck>
References: <20250203050828.1049370-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203050828.1049370-1-anshuman.khandual@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Feb 03, 2025 at 10:38:21AM +0530, Anshuman Khandual wrote:
> This series adds fine grained trap control in EL2 required for FEAT_PMUv3p9
> registers like PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 which are already
> being used in the kernel. This is required to prevent their EL1 access trap
> into EL2.
> 
> PMZR_EL0 register trap control i.e HDFGWTR2_EL2.nPMZR_EL0 remains unchanged
> for now as it does not get accessed in the kernel, and there is no plan for
> its access from user space.
> 
> I have taken the liberty to pick up all the review tags for patches related
> to tools sysreg update from the KVM FGT2 V2 patch series posted earlier.
> 
> https://lore.kernel.org/all/20241210055311.780688-1-anshuman.khandual@arm.com/
> 
> Rob had earler mentioned about FEAT_FGT2 based trap control requirement for
> FEAT_PMUv3p9 registers that are currently being used in kernel. The context
> can be found here.
> 
> https://lore.kernel.org/all/20241216234251.GA629562-robh@kernel.org/
> 
> This series is based on v6.14-rc1
> 
> Changes in V2:
> 
> - Rebased on v6.14-rc1
> - Updated tools sysreg patches with latest DDI0601 2024-12 definitions
> - Updated document version as DDI0601 2024-12 in all commit messages
> - Added latest tags from Rob Herring for the last patch

I know these have been applied already but, fwiw, patches 1-6 look correct
when compared against the .xml:

Acked-by: Will Deacon <will@kernel.org>

I presume Catalin will drop/replace the last patch.

Will
