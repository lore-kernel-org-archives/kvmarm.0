Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FBA1EDA26
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 22:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758236191; cv=none; b=EFJjLfVLBbDSTotbajBwsib7hPJujXqcsHXD5Ift1Nx/14/FX1TZAoIFTbypzembtWvgUeWPpCCwZbt6teNxIR1ex1Nsy0kXO583HPgqFwHEdjTRPS/MxT8vHdaJw8iv584p2jvOoqG5padbRMT0mtb0Nc4trxtCayoPL2V1EKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758236191; c=relaxed/simple;
	bh=p2FbMvES0pW13XDTv7tWhGYTAp4G7GyMWeS/HsjJmoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QkSVrre0PuA8yeqic8OTOSHCT8faE323zVqDotRCfE4F7rdElGRiq1qLfh0GgL8Db93HvB28ccYSy0cJ7WfypvAxtMGkGVvsCc5mzAiQ4KkJ201RDGY0H0Azw4jBpde+Y9HloQT3Zg/+z7NXvrYLjB+oBc/Im24ZNnT1IorJ1G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UaOUPbMC; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UaOUPbMC"
Date: Thu, 18 Sep 2025 15:55:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758236187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S7tcm7gIvs3mPznoioDvbHluXETuPjcDS5qaJu1wJ4w=;
	b=UaOUPbMCzSeFuKu7wAixpOMBlkVIwVa2qAbhceGlM26KTqyYCGtmPUPGsVW3IFJN94lYx3
	t6altnG5OHuVP6+2bLREMUp4HACdEIWymLlidP700jvugtZsPH5bTOAUgNhBO8oaGqhqMP
	ZsN7ivK7VJ7UMiJjdb0PUZfVv/gH1X8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Itaru Kitayama <itaru.kitayama@linux.dev>
Subject: Re: [PATCH] KVM: arm64: nv: Allow userspace to de-feature stage-2
 TGRANs
Message-ID: <aMyN73yHDdSEONvN@linux.dev>
References: <20250918165505.415017-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918165505.415017-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 18, 2025 at 09:55:05AM -0700, Oliver Upton wrote:
> KVM advertises the stage-2 TGRAN fields as writable to userspace but
> prevents any modification for NV-enabled VMs. Update the special-cased
> sanitization to permit de-featuring a particular TGRAN without allowing
> the legacy value which refers to the stage-1 field for support.
> 
> Cc: Itaru Kitayama <itaru.kitayama@linux.dev>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Marc, if you wind up taking this as-is can you please change
s/Cc/Reported-by/ ?

Itaru found this and I just forgot to add the right footer.

Thanks,
Oliver
