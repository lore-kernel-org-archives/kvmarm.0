Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44A93E5EF8;
	Tue, 13 Oct 2026 09:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885116; cv=none; b=kyspcAyPVBqVhw8Nilp4omF0V73E+uAtGM4vDUJdzltaj5q/RfkaQPA3VaMJgvH9PuRIZ+48qzQQ3HLYXFquRJMqXlIMMRdjgJeHnJJy8fqs4QothIl05cSWrkyBBetdob2Ok9yEoAG/y7l2ojW+KLGLiYWEvxJI20CY85MN85U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885116; c=relaxed/simple;
	bh=2L7HIEuwrKsGQPkUmHA8GltpZbVB3LGSooIReo/UXGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FMPtkFkA2rOKyciVCuGOIN6Q4k44XGcDbUgjiP3f1Nu6uNoDaHt34cHRhHbO8CJaUu3NxRRhGCPxz6KwBT4saFJuvRxvVokG12YxGwMk5KxV/4/J8toiNJe1dfG/rkuz+3mMqaxtx6V0OWmYhOTuxbXvPausP/gPMXawxwtmPa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+RdwBM9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+RdwBM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8D11F000FF;
	Tue, 13 Oct 2026 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791885115;
	bh=PyCzwXp6skk6xuTNd5K7xv+NS33CqBs/aqCiNCjofPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D+RdwBM9UNxHRLePRTKBR9LdQwEtGhFzrPCerxIXBjRJcRKecovsPLJDZf1Wo/A0e
	 DVAOJcbY54iNO3N24ta5Mb34ynrLmDJllTvriiN+45+xPf+B08wwGD3iHsQc5a8ZfI
	 C5GXwXL2/Qc9MLL4FJ8DRWz8MgAw2ZYcIQ9z713vjPsS2LMNak6J04CbMVRIlMKg/9
	 mEnhAZB3z+TjgEeOuok2njcVeiisvuoFNo7zM2CfSar7SCrLAeUNxR4e7M+eOzQB9L
	 dhe5J7ep9XjoNsnZnXrc/As1NDC6dL25BMfsEr7L4tYfvcDpLenhuJQ1wcNzr4vqtV
	 2p4w25BGmaHHw==
Date: Tue, 13 Oct 2026 02:51:48 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: vgic-its: Fix LPI double mapping and
 DISCARD
Message-ID: <as3_NKT20MNdqaJR@kernel.org>
References: <20261013081646.933312-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013081646.933312-1-fuad.tabba@linux.dev>

On Tue, Oct 13, 2026 at 09:16:44AM +0100, Fuad Tabba wrote:
> Hi folks,
> 
> Changes since v1 [1]:
>   - Dropped the second mapping of an LPI at MAPTI, instead of keeping a
>     doubly mapped LPI out of GICv4 forwarding. (Marc)
>   - Keyed that check on whether an ITE maps the LPI, not on whether its
>     vgic_irq exists.
>   - Added a patch that makes DISCARD remove the pending state. (Marc)
> 
> Two fixes to the ITS emulation. The first stops a guest from mapping
> one LPI from two events, which can oops a GICv4 host when the VMM then
> routes an assigned device's MSI to the second event. The second makes
> DISCARD remove the LPI's pending state, as the spec requires.
> 
> Tested on QEMU, which emulates a GICv4 ITS. A local reproducer with two
> vCPUs DISCARDs an LPI that's pending in the other vCPU's list register.
> On rc3, and with patch 2 but without its halt, the guest still takes
> the LPI. With the series applied, it doesn't.
> 
> Based on Linux 7.3-rc3 (fd73f4a665989).
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20261012084743.2228612-1-fuad.tabba@linux.dev/
> 
> Fuad Tabba (2):
>   KVM: arm64: vgic-its: Don't map an LPI from more than one event
>   KVM: arm64: vgic-its: Remove the pending state of a discarded LPI

Looks good. As all of these VGIC fixes depend on reliably synchronizing
hwstate I'll assume Marc will apply this patchset after his own series.

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver
