Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C279948A2A0;
	Mon, 18 May 2026 13:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779111958; cv=none; b=A2CI9DKEg3eewPKTV34brSQsFrzFIXL8wgNa3hAMyy0r/X8AG5X5muRClVhW04DQ0cxQfnyJMn2Ls1lzttiyletbKSX2oKGMJJfP+PslCTqAAUSQS+fbaNH1Hk5rzZeOSj2aBUiP6bDuNx+TGdxZVj7CUJ8PFEM0zhh9oBkAkT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779111958; c=relaxed/simple;
	bh=75yRSP2IEDju9uSJUM5mcUQkVTRaXUsmfsv1K2TMIPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUV074ccuK6vc3APFHIaK4gCN4bGMgPeF2XEicn6Togp6vhcha7aKmsA8LT+xcQOT5p4gAyxFunZZausGlQqZEzy74Ctzcp79EgHXi0rqPMUtSoYn6ttctEcqwIf0EViLjCO1bqtcn4MGKsQUeyQciLs1h+vU9/bLXfoUTx6PSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4dnHL8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4dnHL8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC738C2BCB8;
	Mon, 18 May 2026 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779111958;
	bh=75yRSP2IEDju9uSJUM5mcUQkVTRaXUsmfsv1K2TMIPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g4dnHL8iK3ErA20o/kJ5NoQ3Hl3LZ05nbGlKx0sywbn27A12YzQRvH36tNFS9q9LY
	 tsFcH/mBIh4iVIpMvtQXwZEQioYhVRnprWCe1o1E122IJSnhHcSFaPx4CEjgTggtZ2
	 z0QiAQ7hM0o/b4JcqFmR/7um/MOGzAZK3dXoH7WxxS/e7BmXCWfDus+B9JRCkT8J6Y
	 XFaD7Q7F7hLEm0cMdJ81/mHqzLhk/JWDhhWubYYZ59nJnzpYYZ6E5ITKyU3Z2oi32i
	 hbGDtL/8okaPEtPFKdLxndLHIBYAfF/4RsBEobWYZS4vdETBL/Cid4N48jsoznz7K9
	 LiBvXPZq1LZAQ==
Date: Mon, 18 May 2026 14:45:53 +0100
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
Message-ID: <20260518-heavy-intelligent-partridge-ddc80b@sudeepholla>
References: <20260512124442.1899107-1-sebastianene@google.com>
 <20260513-ludicrous-beautiful-cuttlefish-34271d@sudeepholla>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513-ludicrous-beautiful-cuttlefish-34271d@sudeepholla>

On Wed, May 13, 2026 at 06:23:43PM +0100, Sudeep Holla wrote:
> On Tue, May 12, 2026 at 12:44:40PM +0000, Sebastian Ene wrote:
> > Hi all,
> > 
> > This series fixes the Endpoint Memory Access Descriptor (EMAD) offset calculations
> > and adds the necessary bounds checks for both the core FF-A driver and the pKVM
> > hypervisor.
> > 
> > Prior to FF-A version 1.1, the memory region header didn't specify an explicit offset
> > for the EMADs, leading to the assumption that they immediately follow the header.
> > However, from v1.1 onwards, the specification dictates using the `ep_mem_offset` field
> > to determine the start of the memory access array.
> > 
> > The patches in this series address this by:
> > 1. Updating the core `arm_ffa` firmware driver to correctly calculate the descriptor
> >    offset using `ep_mem_offset` rather than defaulting to `sizeof(struct ffa_mem_region)`.
> >    It also introduces bounds checking against `max_fragsize`.
> > 2. Enhancing the pKVM hypervisor validation logic to no longer strictly enforce that
> >    the descriptor strictly follows the header, aligning it with the driver behavior
> >    and the FF-A specification, while also ensuring the offset falls within the mailbox
> >    buffer bounds.
> >
> 
> Looks good apart from the minor nits, but how do you plan to route these
> changes as they are dependent for functionality but not for the build IIUC.
>

You can add (with minor nit fixed) my

Reviewed-by:  Sudeep Holla <sudeep.holla@kernel.org>

if it is routed via KVM or other tree.

-- 
Regards,
Sudeep
