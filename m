Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE294189F3F;
	Tue,  3 Dec 2024 21:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733260959; cv=none; b=cuZXKaOYbTT9ogwcd9SyQ0jKIiKIjJrtU4PQSuVW8beaflJ2gOkJ89jSQFSvb4Sq0JlvJCGOGKKuFjrUBCGpIH89iARhPjIxW6csdCLDDLBqqMHdCYxuEtEHeowudJMeXcPru0g4XfJnbrI/stY2yiwVXYCBbjlP2U8JDrxcdhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733260959; c=relaxed/simple;
	bh=jbRhQXH5dQ926uDNBhcZ0k8QVZ1XplE+z+0UvN7Mgis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDlcT1WH+rlpHU7xML2KL5oBaS015JqABR8U4PCt53/c3rDEgPxjbr54OYnaOBGZ1oWy30Kz8knRRLCreIYL20F+1rf3VImjR37t+IMIW+irnYgU9KMvTgbUY8yqxKa34de1aRSXJVGQvgWYkiWgnUgbr61Ttb4+aGGgiOYcwiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2EFC4CECF;
	Tue,  3 Dec 2024 21:22:37 +0000 (UTC)
Date: Tue, 3 Dec 2024 21:22:35 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: Do not allow ID_AA64MMFR0_EL1.ASIDbits to be
 overridden
Message-ID: <Z092m3iNQYbKljHN@arm.com>
References: <20241203190236.505759-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241203190236.505759-1-maz@kernel.org>

On Tue, Dec 03, 2024 at 07:02:36PM +0000, Marc Zyngier wrote:
> Catalin reports that a hypervisor lying to a guest about the size
> of the ASID field may result in unexpected issues:
> 
> - if the underlying HW does only supports 8 bit ASIDs, the ASID
>   field in a TLBI VAE1* operation is only 8 bits, and the HW will
>   ignore the other 8 bits
> 
> - if on the contrary the HW is 16 bit capable, the ASID field
>   in the same TLBI operation is always 16 bits, irrespective of
>   the value of TCR_ELx.AS.
> 
> This could lead to missed invalidations if the guest was lead to
> assume that the HW had 8 bit ASIDs while they really are 16 bit wide.
> 
> In order to avoid any potential disaster that would be hard to debug,
> prenent the migration between a host with 8 bit ASIDs to one with
> wider ASIDs (the converse was obviously always forbidden). This is
> also consistent with what we already do for VMIDs.
> 
> If it becomes absolutely mandatory to support such a migration path
> in the future, we will have to trap and emulate all TLBIs, something
> that nobody should look forward to.
> 
> Fixes: d5a32b60dc18 ("KVM: arm64: Allow userspace to change ID_AA64MMFR{0-2}_EL1")
> Reported-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
