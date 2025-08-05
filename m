Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051E02777E5
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 14:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754404784; cv=none; b=sofYb4/SP84H6t9ND01d0ZyysGfdrYp0oZ2WGpvOhDcc7n0sjCyTCNy+WfuQhN8GMupcFJd6Z++fCaxWGn3pgBLd9+2JzYoFfhYLDjpI+I49FbzEL7KiAiOecESnZ1p7oAx/RRXwOxf/33iP+femIga5RZ+/NckKqy0IcObn7Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754404784; c=relaxed/simple;
	bh=zDU15c/0SyS63Ve+P/xgIY3O2R3OtWuKg0khyFNpS0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJWhm0uEAaPheTwKLiKtgRGKGvhJT6QbgQrT/UpqzMDqoqh6p+jJepjjmhvwKVVdpp4njGGUtsEirNE4mccfZSLLEzdyotTKm+QVXz4nP7AwEoZh5Uo0xt/jG+jvjo1R4nJV/FexZNiPidi0D5UGWAgnfafDqW9Iu6sU6FK5n1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiA8Rnhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiA8Rnhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4453BC4CEF0;
	Tue,  5 Aug 2025 14:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754404783;
	bh=zDU15c/0SyS63Ve+P/xgIY3O2R3OtWuKg0khyFNpS0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QiA8RnhbuUV+U394qNTDHAlY1LIU8/+1wR6oCHm2LO+o9jq2kFxVXE+1SpLfudqQF
	 BUHK6SHRnPACdpYoWgQqiOWEd74Uisk5TvAoHkbO4T+xS0A4kYKX5TryyUtcFnJZPx
	 h7XE0tcRxpVCBHz6OpClkpA8pScSfM6k4y1egE1N0KC8FiayWiojJ5XgkXa13JfuUZ
	 J69buYgraPGMEgnscbaCLiXHgwFbQoJ1itVl7JmgJEsC8EdhQgPw/1b9vysbGGH3VO
	 yDQoC5kxZUfVbGPTrAVYPmoVDkKD08aUV6OQumx7lPfqB3Q2bn9jhR8wU5u033ihmc
	 rGIoXGR8DNcAw==
Date: Tue, 5 Aug 2025 15:39:38 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com,
	sebastianene@google.com, keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v1 0/4] KVM: arm64: Fixes to handling of restricted
 registers for protected VMs
Message-ID: <aJIXqmv1_0djt82y@willie-the-truck>
References: <20250805135617.831971-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805135617.831971-1-tabba@google.com>

Hi Fuad,

On Tue, Aug 05, 2025 at 02:56:13PM +0100, Fuad Tabba wrote:
> This patch series is mainly about fixing issues we've encountered in
> pKVM (in downstream Android code), related to the handling of protected
> VM access to restricted registers and injecting undefined exceptions
> into a protected guest.
> 
> The last patch isn't pKVM specific, but a fix to the vgic-v2 code
> encountered while fixing the issues in this series. The issue it fixes
> was indirectly introduced into the code with hVHE.
> 
> Based on Linux 6.16.

Thanks for putting this together so quickly.

I left some small comments on patches 2 and 3 but, for the sake of
transparency (I already mentioned the GIC thing to Marc), please can
you add:

Reported-by: Will Deacon <will@kernel.org>

on patches 1 and 4?

Cheers,

Will
