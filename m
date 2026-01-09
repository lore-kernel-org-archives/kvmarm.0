Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1801A58D
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767968631; cv=none; b=o7egkl+F39td2YoPiFWMdJAPdnnNvjXxg6yRMStpcNsXbXMwQvTdCB8StSZ4J0Y7AMgmk3XMdmL1UHwV84+vvfD75IbnRmsGUgeNRpUjL43uzPRENl1JIRzoGxgQPm3LucifVX/0rDsoFHXA7k/KiECcVXBCGI1K00s/PGixrvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767968631; c=relaxed/simple;
	bh=v2mF8aLKfRFIoZvCzsD/JTiSuILPUbZkMqh8PP3HP94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UI7GMg7T5x9S8jzn8/C/X4mKebC0nbVyeLMATgYwDRDmUAOGOFhUfvB5Oof14EKlvmGBYz2tyE4NrZAA41kXsdifPRnz7rs8fVa2wyIKYH64J6hqs2zvDPxNXZokdxoAfeYvvaNxHknqqVqhPu1m/GxSJVxXJvDeypgdDEaStkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjXgkvzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjXgkvzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0A4C4CEF1;
	Fri,  9 Jan 2026 14:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767968631;
	bh=v2mF8aLKfRFIoZvCzsD/JTiSuILPUbZkMqh8PP3HP94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mjXgkvzwh9ohy9KFUBLSwyL4x7NxOnQEV4oodib4hze9U+aPNObV+YkvS0nApJpuF
	 Mm8n5d2VU6GIBsLvgketsGZgEA1975ZxY3Mn5lQKMkEizKXYbyYNXbHoIOJCbL3mAM
	 vW/kkmkNFU2tmLeQ2SoNDBRrP0PMc0P01jCzR8zy5Mf6xIl8gh3Sk364ikJ+M9d5oq
	 Kq2K48UjIauB6LARB7dibk4h5Q5KchAbOPheTZEWcgWG7Qc87oNokXDIqtiOftfNdv
	 aJOjd6C+25kaMY3R1AvhlZgnX8WO4MYyihLGfLgDX7nOpOwnwlWyQngjz1EmIRKkYH
	 NnPh9ZtT8W9cA==
Date: Fri, 9 Jan 2026 14:23:45 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 06/30] KVM: arm64: Remove pointless
 is_protected_kvm_enabled() checks from hyp
Message-ID: <aWEPcS40d9rwKWh5@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-7-will@kernel.org>
 <cokixmkyotfs6ts2rqn4xa7iseno6hk34eon76raujupedgsff@hmkoakf5kr44>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cokixmkyotfs6ts2rqn4xa7iseno6hk34eon76raujupedgsff@hmkoakf5kr44>

On Tue, Jan 06, 2026 at 02:40:47PM +0000, Quentin Perret wrote:
> On Monday 05 Jan 2026 at 15:49:14 (+0000), Will Deacon wrote:
> > When pKVM is not enabled, the host shouldn't issue pKVM-specific
> > hypercalls and so there's no point checking for this in the EL2
> > hypercall handling code.
> > 
> > Remove the redundant is_protected_kvm_enabled() checks.
> 
> That made me wonder if we should further divide the HVC space to have a
> 'pKVM only' range in addition to the privileged/unprivileged split, so
> we could WARN in the core HVC handler in the pretty unlikely event that
> we take a pKVM-only call in {n,h}VHE.

Good idea. I can certainly look at that as a follow-up to this series
but I'd prefer not to grow it beyond its current scope at the moment as
it's already bigger than I would really like.

> But yes there is no point in littering the code with is_protected_kvm_enabled()
> checks all over, so:
> 
>     Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,

Will
