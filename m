Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052E713956C
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 17:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714585667; cv=none; b=X8xfjpN8zq4+WF947jQ69JJlmVJnoDn4fJbBF04ZSZUmSoSh6E5OEJNe0EcWBqVY4rmvUgS2m62ccteXREuOcCpHwx3C4YsRiH4eCh80j4bGu4V5/05mp6ryVPA6iR1Y4OKTCdMM9UUhr8yeQfv305KCLAsJQERvUCo8+AaTk/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714585667; c=relaxed/simple;
	bh=1r75VJD3uLrEM2FgDudvBma3OWX9G59FhcRd3YA8xWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIhWIAe1RNBam01AfVLJ+k1PyWY8PU1j+XjkGI6u7zGbO/nQG+9yp+bVUdRVVnTwk93t3V2BK+9uqkYlW57lYkEqe6iEgwq7nbOijeuqr+l4yvgvJDsmkeqbLJXeaSMaNJpigJFDQSM3i35PDouVAxybFhXgMl6OQiH4i70uv+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T8PE2vzt; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T8PE2vzt"
Date: Wed, 1 May 2024 17:47:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714585664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yDJUUdp8ULPIC4L+2eqNBMvqRsFS5KecxcGEHAt4XSo=;
	b=T8PE2vztU71RhSxxtea777/ypUHS02ctMoptEmeyo+QqDRtvOscpSfQhBNsgbNow1P1l/U
	BlqwL1C5N9zRcGVes9ydIZelZPzcszVTrT1bDx5/nRncpempgSRuAojz9Cejm7zZjkaGA0
	KTX1iGWinS5wWCbHqKv335DoitrXDFs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: Use hVHE in pKVM by default on CPUs with
 VHE support
Message-ID: <ZjKAPHJEy_WAtjsg@linux.dev>
References: <20240501163400.15838-1-will@kernel.org>
 <20240501163400.15838-3-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501163400.15838-3-will@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, May 01, 2024 at 05:34:00PM +0100, Will Deacon wrote:
> The early command line parsing treats "kvm-arm.mode=protected" as an
> alias for "id_aa64mmfr1.vh=0", forcing the use of nVHE so that the host
> kernel runs at EL1 with the pKVM hypervisor at EL2.
> 
> With the introduction of hVHE support in ad744e8cb346 ("arm64: Allow
> arm64_sw.hvhe on command line"), the hypervisor can run using the EL2+0
> translation regime. This is interesting for unusual CPUs that have VH
> stuck to 1, but also because it opens the possibility of a hypervisor
> "userspace" in the distant future which could be used to isolate vCPU
> contexts in the hypervisor (see Marc's talk from KVM Forum 2022 [1]).
> 
> Repaint the "kvm-arm.mode=protected" alias to map to "arm64_sw.hvhe=1",
> which will use hVHE on CPUs that support it and remain with nVHE
> otherwise.
> 
> [1] https://www.youtube.com/watch?v=1F_Mf2j9eIo
> Signed-off-by: Will Deacon <will@kernel.org>

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
