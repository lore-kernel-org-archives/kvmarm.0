Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2604114AD24
	for <kvmarm@lists.linux.dev>; Tue, 19 Nov 2024 23:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732060067; cv=none; b=ZLtEflMTFHEC/Y0YAu5aYFaUFG3Z0WudkInx4c9xZ42adyJPg5jzN1j4R+YLVPCVy2yq8eLkBFTMW9Bb4kNVkmePT0hHfUvsU3JQk5T5gK1jMw37LvCpG2D5b4GfbUx+DrxfNZ3xK2L0I9IB3u34FQAPrs4EcHUzrprC3r5UBJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732060067; c=relaxed/simple;
	bh=lZG6nmiBJ9FJvKHabziU9M7uN2ZF6JpMF4z61RRVNxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a964UyTPIOlMm0V7JQ79srquGp9YLXPx4RGz8atAAOcI6BOGSNBl+jla95/pNkKE+MkwzPY8kefT6UcTvCkc7k19gI3K8pdkfTFM6pOGfpFnxZPZBS8OKC7V2+kv5PZ9KYyj85M7k2GUDYF3UoHoXCtl/6z06bqsr88tDwTD9qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oIQ2Syfl; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oIQ2Syfl"
Date: Tue, 19 Nov 2024 15:47:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732060061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=txvjGg/xDtaIUmdcEWY1LrlQC+N7Iwaw7oIJUyV0+DA=;
	b=oIQ2Syfljioi3BHubscZHs/uSHZwesPTCLkDzX08O/Ej37eWZeoNwd+BSfau0HQ1C3AF4O
	5Q4RUv3yN+4x6r46H4Sth8+k8fflCloOH0qSDqnv5eBderG5I+RFGpslucCeuDfPiJpxrN
	CK8H0zKHUWfptj1M4PE3AQIV045FAcY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/4] KVM: arm64: vgic: Collection of fixes for 6.13
Message-ID: <Zz0jibnQ5v_Pkl47@linux.dev>
References: <20241117165757.247686-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241117165757.247686-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 17, 2024 at 04:57:53PM +0000, Marc Zyngier wrote:
> This is a more or less random collection of vgic fixes, addressing
> issues ranging from "purely cosmetic" all the way to "pretty annoying"
> (of which patch #1 is an example).
> 
> The general theme is around the tightening of the internal API in
> order to make it a bit more difficult to get things wrong, something
> that I'm particularly good at. There is a bit more I'd like to do on
> the ITS, but I'm testing the waters here.
> 
> Patches on top of kvmarm-6.13, tested on the funky x1e box.

I'm quite happy with the look of these patches. FYI I'll start picking
up fixes in a few days.

-- 
Thanks,
Oliver
