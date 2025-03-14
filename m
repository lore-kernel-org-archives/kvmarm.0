Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E05201012;
	Fri, 14 Mar 2025 14:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741963219; cv=none; b=LsN5iO9yeUJxfDyte4iWKiXmiU/zEqW+t8h752L1mWEnai4oQlF9Q/FAKvVdXsbDC2WQd4lsfF9dHmNXW0RHRYxw2019u9W5J9/10zYszv/2n2cLS07cKwSJOTaM2ZHX6fz+XylM1gnyqCThxe0k4TUh1uFFtoXpvQ31fH6Dgr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741963219; c=relaxed/simple;
	bh=qvFqGn2zhzp1f7FyHd/EcWNszUg7lreAGkRtmPyJdYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aE9lEyZAfkkWT6F18gsLwc7+bZahIDCdjlkc6vrDBjnYxUZ6ltLYapJOwQxXNRtXctTtCpMczVI8hwG8a5Hh/K+jzm66d7OiYhHOFhnbRy0l/baC4WQvKbIXpnogGxZ7NUhbu0VPvWoe5MOzvXT4s9cWkUyHRwK7rfNKK9a36sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C2CC4CEE3;
	Fri, 14 Mar 2025 14:40:16 +0000 (UTC)
Date: Fri, 14 Mar 2025 14:40:13 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6.12 3/8] KVM: arm64: Remove host FPSIMD saving for
 non-protected KVM
Message-ID: <Z9Q_zW_mM-v2iPHC@arm.com>
References: <20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org>
 <20250314-stable-sve-6-12-v1-3-ddc16609d9ba@kernel.org>
 <2025031427-yiddish-unrented-2bc2@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025031427-yiddish-unrented-2bc2@gregkh>

On Fri, Mar 14, 2025 at 06:32:45AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Mar 14, 2025 at 12:35:15AM +0000, Mark Brown wrote:
> > From: Mark Rutland <mark.rutland@arm.com>
> > 
> > Now that the host eagerly saves its own FPSIMD/SVE/SME state,
> > non-protected KVM never needs to save the host FPSIMD/SVE/SME state,
> > and the code to do this is never used. Protected KVM still needs to
> > save/restore the host FPSIMD/SVE state to avoid leaking guest state to
> > the host (and to avoid revealing to the host whether the guest used
> > FPSIMD/SVE/SME), and that code needs to be retained.
> > 
> > Remove the unused code and data structures.
> > 
> > To avoid the need for a stub copy of kvm_hyp_save_fpsimd_host() in the
> > VHE hyp code, the nVHE/hVHE version is moved into the shared switch
> > header, where it is only invoked when KVM is in protected mode.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Reviewed-by: Mark Brown <broonie@kernel.org>
> > Tested-by: Mark Brown <broonie@kernel.org>
> > Acked-by: Will Deacon <will@kernel.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Fuad Tabba <tabba@google.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> > Link: https://lore.kernel.org/r/20250210195226.1215254-3-mark.rutland@arm.com
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > ---
> 
> What is the upstream git id for this on?

It seems to be 8eca7f6d5100 ("KVM: arm64: Remove host FPSIMD saving for
non-protected KVM").

-- 
Catalin
