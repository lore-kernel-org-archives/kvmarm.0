Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05C23FE362;
	Tue,  7 Jul 2026 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783425393; cv=none; b=ZF5XZZZJM7ykfyjxCn/IdylW4vnPvqVRGkiTUOxoG7CAdnjMaap+h/UKmezGb4jPkFIq64qp9BEm+F1RF4LoDHLyeDhwZbaOs1d/2LpsWzW8mX+9uyWhx7ZjXp7WvseEMOOIRqa5uvKFHlcgqawWFEAU86+MIi8GCR9eZ5xbRG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783425393; c=relaxed/simple;
	bh=VHyQyW91mk/rV9J35jEDjKnS65l+3GqidQKWJGCYFvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2Jqa1pNIySokgsGx9NdahPh5WoV0EMxEgFiRBGweeNTLjGsxUMKK5f9dX/mOpuGsAvuPbuO9GL+MbNpfKSNzXyeTDbuxCqa5MR+ulrBi5iSZvssp6YilZqoQIIeBtHD5pz3RPNjbGzmFINNrWjZ04FXh1EeqzvREL3kAQRD4r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLaFw+j2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLaFw+j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D371F01559;
	Tue,  7 Jul 2026 11:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783425391;
	bh=dfqKIJOu25jIvGp/MHMBBQ/zA+78h3cOEbJXVr/juXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kLaFw+j20wmNLTAhrt8SIoCgi9fuNsefFqDsKoq3ghMgJ5Coo4Ut3x6FW3iCmq2x/
	 yQHHKkJGahcmV/iDfAtzZcAIwFnChkHsZ559TRHDa+R+17elV+tA8aXeBdG5dFX0IF
	 ZQ6rKwJAz9F6j5yse9QyvZCy6y/s4KT4of1GKlH+SOA+4ICqfwTr1Bi53BtYDcWoa3
	 +eDl9knq8FmECFBkGnqsDgov0sPFtDdzYCGEj8nl9zs3C2UmmS0slodBDe68tFbgHf
	 59y6nJoHWBs1upSEtDDn3IeWxo1Ah6xvbMFs9sI3awvukoaxp8Z/RKK0nWwnyivcpT
	 vsaHe8lUAaeCg==
Date: Tue, 7 Jul 2026 12:56:24 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>, sudeep.holla@kernel.org
Cc: catalin.marinas@arm.com, oupton@kernel.org,
	Sebastian Ene <sebastianene@google.com>, jens.wiklander@linaro.org,
	joey.gouly@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	op-tee@lists.trustedfirmware.org, perlarsen@google.com,
	seiden@linux.ibm.com, smostafa@google.com, sumit.garg@kernel.org,
	suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com
Subject: Re: (subset) [PATCH v9 0/6] arm_ffa, KVM: Fix FF-A emad offset
 calculations
Message-ID: <akzpaD3VmMp8Dq4S@willie-the-truck>
References: <20260702103848.1647249-1-sebastianene@google.com>
 <178342187223.1892339.1923162787460489447.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178342187223.1892339.1923162787460489447.b4-ty@kernel.org>

On Tue, Jul 07, 2026 at 11:58:01AM +0100, Marc Zyngier wrote:
> On Thu, 02 Jul 2026 10:38:37 +0000, Sebastian Ene wrote:
> > This series fixes the Endpoint Memory Access Descriptor (EMAD) offset
> > calculations and adds the necessary bounds checks for both the core
> > FF-A driver and the pKVM hypervisor.
> > 
> > Prior to FF-A version 1.1, the memory region header didn't specify an
> > explicit offset for the EMADs, leading to the assumption that they
> > immediately follow the header.
> > However, from v1.1 onwards, the specification dictates using the
> > ep_mem_offset` field to determine the start of the memory access
> > array.
> > 
> > [...]
> 
> Applied to fixes, thanks!
> 
> [3/6] KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
>       commit: 8c6db30d79528279abbeb416e4f533f1f91b8724
> [4/6] KVM: arm64: Validate the offset to the mem access descriptor
>       commit: a6b49d27c17909608d54523220bb6f3498d4a1df
> [5/6] KVM: arm64: Ensure FFA ranges are page aligned
>       commit: 6a7a181f6921db3d9aed1bba7e15547fefd7eedc
> [6/6] KVM: arm64: Zero out the stack initialized data in the FFA handler
>       commit: 2bd3c6c702f3a9e2bcb3b536b0fbbaa645005d71

Thanks, Marc!

I think Sudeep was also happy for the driver changes to go via the KVM
tree, unless you'd prefer not to pick them up [1].

Will

[1] https://lore.kernel.org/r/20260518-heavy-intelligent-partridge-ddc80b@sudeepholla
