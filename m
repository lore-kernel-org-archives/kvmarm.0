Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914D71DE2BF;
	Fri, 25 Jul 2025 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753460820; cv=none; b=nG1IVaXYbVdrYRipTmyIPjCJGoSVsVPqFlr5lXm9Gv2PF/uWb2gNLp60mPB+JJ90kPYzVEuOteKKQ0DZu6pugBonzKDpCpZh43B+ZMIUCbwqaYptM5VjYkuO4LdMJ8wLB/3NUKLkw+jhz8cdAAaGvWluGU5kBZkcfu0ec51J6gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753460820; c=relaxed/simple;
	bh=3eYsDk8pu6SR1Cnt13efDyi3HIRyBbspXwtf/n8uEOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eeSM7AiwMu00cbY1m5YWnbdGu6Nl0y/rcOQ5Ocu5dOkb8mQi1a1X06bVwWGKLSmOfLiwMtabJrTFN7nWuwxDippp1jgo7RfMddut0BXdNHZhBrT6jA+J586NzQeKYR3pYubx5pP85D/Zo+IQjBbg5cOU29uAa24Ujl/lYRq/vso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpIORBJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpIORBJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5AEC4CEE7;
	Fri, 25 Jul 2025 16:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753460820;
	bh=3eYsDk8pu6SR1Cnt13efDyi3HIRyBbspXwtf/n8uEOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bpIORBJMxAPx1S1E3OMZq/aNbSK5qd+hauvg1UdVYAJ3pJ7GXuIjpzY3tn6d0Me+c
	 6M1QecyL3T49tOAOIoUBdVEz2n9ejlO7TjUhAyqWHSIOvPGWqnEjZluqe7XzJYTmY3
	 KE3yz3KeGHH7lmeaM9EB02ae0zkYjl8CBq1OV9rgSL/LdbyO1ORf5h3Vldy+swdY7P
	 jtlDnR+/uWF6u/EfvZnLRYskPiWW6Pql3Y69o9CdR7LThdkiWrnSsExaP6kAxgK7s0
	 hPnoGiQH/pF3e2ItgDWWX1zRKjsZVuW6BIZPZu4z/4KpI9x+BAb0lFX+njywTN51zS
	 jYJIhA2JyG7sA==
Date: Fri, 25 Jul 2025 09:26:54 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Tom Rix <trix@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.1.y] KVM: arm64: silence -Wuninitialized-const-pointer
 warning
Message-ID: <20250725162654.GA684490@ax162>
References: <20250724-b4-clidr-unint-const-ptr-v1-1-67c4d620b6b6@google.com>
 <86frek9182.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86frek9182.wl-maz@kernel.org>

On Fri, Jul 25, 2025 at 08:30:21AM +0100, Marc Zyngier wrote:
> The correct fix would be to backport the series described in
> e8789ab7047a8, which should be easy enough to apply. it would also
> make 6.1 less of a terrible kernel.

If doing that is reasonable to clear this up, I think that would be fine
to do. This is the only stable-only instance of that warning that I have
seen in the build logs, I have sent patches to deal with all the other
instances upstream. We would need this in 5.15 to avoid failures from
-Werror as well but if it is too hard to backport that series there, we
could just disable this warning for this file since we know it is a
false positive.

The whole reason the warning occurs is due to the constness of the
sys_reg_desc parameter in the function created by FUNCTION_INVARIANT(),
which I am guessing cannot be removed because it is present in
->access() and it proliferates out from there?

Cheers,
Nathan
