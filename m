Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC6447F3DF;
	Fri, 11 Sep 2026 13:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789131748; cv=none; b=i3L4IB1aWa/ZaNU/M1r2cCCsDr0RfUwbo9nxXefaoxL2Jvp9ka+04TO4Tw1n72lUILQjL9MHznhdcntddj9iQhBooyYekAyTTVB4/wPVrqm1dol8A76G0CXflKgxuL3QQNRSEm8emcMS8m3Z6UWwecO5JALj6RmcV6VPwWSTJaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789131748; c=relaxed/simple;
	bh=DAshUoISkNtI2aqMygseUKniDThl7E5agzDNpoCsHl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=leVpvicmR4ubKZ7NlgN8FWL2zuWTJOzqoWFMMxMN/onbpRwFrconXUFDTvOR8OuMaCTMpfJFvESFqo/qXbYqDMFI58EKCD4CYVIcCbm/CA8Ukpl5l5qLTPXt6ANMYAS4AfGmrJEK+ABpc8ZygjSkfjdAXCoRs62qak0bKz7wRb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ocr7i/XK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ocr7i/XK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CF81F000FF;
	Fri, 11 Sep 2026 13:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789131744;
	bh=+G1OKXoNBIKzsbl+jc8rigOgfUUb72KCyBt1gFKV3Cw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ocr7i/XKsT0RN6w6ujzcRthZNm2ket/5ZIMILTxA1DtiBBAgEN7aDLFJfOxJOdCR0
	 yTOHSaBzobg8rtZzQhaEJ96Aikqkhg0mW8VaSZkVI9NLXHSLYihIZgyCjiI3Uuk383
	 tVG+BGjmZXW7lREFwrLg/tC2dHg+bLkMwjvCOtLIgbYUd54MCgEkwqq7+quMERF1th
	 wf+VpD+mq5ZnF+GB9UglKAcgLAZ8XsuRF85QJatVv2jJd8bg4tkAU3/iJ7RSsE0vLi
	 nTTcwL3tjYM7Q56E3amwa8g1/xV5z7ZvAOJ1vZAemQGPWGETPI+B5piU/PrH+giWyu
	 bFrV8bAeTrZZg==
Date: Fri, 11 Sep 2026 14:02:18 +0100
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org, maz@kernel.org,
	pavan.kondeti@oss.qualcomm.com, tabba@google.com,
	aneesh.kumar@kernel.org, mark.rutland@arm.com,
	sdonthineni@nvidia.com, steven.price@arm.com, gshan@redhat.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev
Subject: Re: [PATCH v17 0/1] arm64: mm: Handle Granule Protection Faults
 (GPFs)
Message-ID: <aqP72gst-Y0KtxA5@willie-the-truck>
References: <20260907162204.1479401-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907162204.1479401-1-suzuki.poulose@arm.com>

On Mon, Sep 07, 2026 at 05:22:03PM +0100, Suzuki K Poulose wrote:
> This single patch teaches the arm64 fault handling code about Granule
> Protection Faults, introduced by FEAT_RME. This was posted with KVM CCA
> support series, but split from that, to allow for other users of GPF.
> 
> The immediate user is KVM CCA, where the host may fault if it accesses
> granules that have been delegated for use by a Realm. However, the fault
> handling itself is architectural and not KVM-specific. It should also be useful
> for other FEAT_RME users where an access to secure memory or root memory can
> result in a GPF.
> 
> GPFs during a page table walk are treated as kernel bugs, while non-page-walk
> faults can be reported to userspace with SIGBUS. The patch also allows existing
> exception-table fixups to handle known in-kernel accesses such as
> load_unaligned_zeropad() while private memory remains mapped in the linear map.

I assume you can't handle GUP for realm memory, so you must be using
guest_memfd to avoid userspace mappings of realm memory. In that case,
why don't you unmap it from the linear map entirely? There's ongoing work
to do that afaik, it can be done largely outside of arch code and it
seems like people want it to defend against side channels anyway.

Will
