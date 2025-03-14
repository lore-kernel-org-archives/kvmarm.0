Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539C61E86E;
	Fri, 14 Mar 2025 05:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741930369; cv=none; b=oAq5LbL/XvXAE7exWKk9Gzv0BdLckShlDm9SaGHrFYjITIsOer/Vnk8/HLYZfakaDOB4h7iKr458ultMGtFiK+xEJ9PCNcNLgIdX1Lh5TOYozD3ctzTWumw3srjXr6zGb4J0WafgOOSUvsozBcLeeoFdmlOsU5OxiDyaeDAPqqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741930369; c=relaxed/simple;
	bh=Gqip2u1dKZM5ihrffxMctAlWaVDbG4jUMPKuit18Zpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cfp7Cj2EXUJRCTihtpYTGON6k+HrlIf5BuKp00yi5+dml6iSWzWDie+xUhUuhVLzP+5W+uYw14FfG0azqH2JFZq2a69ctREbNyJZwtxn7IHcpbt0r9pfp5PtBiDdtPAp/NVgs7wWPNfBjojY7qbhbJ012nbuOofHAlFAyatb4y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfQoWP7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfQoWP7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9B6C4CEE3;
	Fri, 14 Mar 2025 05:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741930368;
	bh=Gqip2u1dKZM5ihrffxMctAlWaVDbG4jUMPKuit18Zpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RfQoWP7UNXyhVa14p9u5HeB1t3Ss4Pk8U9FROmk/VakXRN9O8U43W9QH75Ya2wT0P
	 oecQf01nK6rnaGaQBWjE1efeNDTDt4CZkqvC+mG6/7Jwo+l78UF6rMpxXT11zZYTZP
	 wSz3x4mxwDPsCW/CP1BR6Xhh9H/pvZdF/Tcpkl4Q=
Date: Fri, 14 Mar 2025 06:32:45 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6.12 3/8] KVM: arm64: Remove host FPSIMD saving for
 non-protected KVM
Message-ID: <2025031427-yiddish-unrented-2bc2@gregkh>
References: <20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org>
 <20250314-stable-sve-6-12-v1-3-ddc16609d9ba@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314-stable-sve-6-12-v1-3-ddc16609d9ba@kernel.org>

On Fri, Mar 14, 2025 at 12:35:15AM +0000, Mark Brown wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> Now that the host eagerly saves its own FPSIMD/SVE/SME state,
> non-protected KVM never needs to save the host FPSIMD/SVE/SME state,
> and the code to do this is never used. Protected KVM still needs to
> save/restore the host FPSIMD/SVE state to avoid leaking guest state to
> the host (and to avoid revealing to the host whether the guest used
> FPSIMD/SVE/SME), and that code needs to be retained.
> 
> Remove the unused code and data structures.
> 
> To avoid the need for a stub copy of kvm_hyp_save_fpsimd_host() in the
> VHE hyp code, the nVHE/hVHE version is moved into the shared switch
> header, where it is only invoked when KVM is in protected mode.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Tested-by: Mark Brown <broonie@kernel.org>
> Acked-by: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Link: https://lore.kernel.org/r/20250210195226.1215254-3-mark.rutland@arm.com
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---

What is the upstream git id for this on?

thanks,

greg k-h
