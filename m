Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C2B22FACE
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 14:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740666563; cv=none; b=HXqxO00haPvBVDqKSlBhwHoJFmUE7lV9GyXi+uiSMRuS+SQiATbrzL7TsF8jBrU4ioLF5D/7ShxIAVTF3e1zaYb/wZEVVeylSjLtZfaoVsYf5yzNKwArntFxpkIcsmx6k8jkQYYQAp8UMMnInIVG65uMutYEj2bLB1B+QVAvdjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740666563; c=relaxed/simple;
	bh=XsTe43ksNQ5ndq6iiWJQEJUCi6bHdDQhKJAodTgeBj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUtjxK41dfINwDmf+GP02KRtdVvzE86YdzrA33tRHCYfTdbwi0HSgcFcSsv/GnGmY9uB8IRaZEFF5ewY3sEPzgVyxN6vTRL2bHGfpq6BGICu49EwtaKLtxvBUaKUqavXykNjTRmj4t0crOClL4AjLLPpEqQVJRzF8oYF8FNQQBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lWoNuJRX; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lWoNuJRX"
Date: Thu, 27 Feb 2025 15:29:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740666559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XsTe43ksNQ5ndq6iiWJQEJUCi6bHdDQhKJAodTgeBj8=;
	b=lWoNuJRXtex0qyuDgB5xJCIRgOu7FTrGWtUehMR0mWIvN6CEHMBectu5nJi+ZD/EmlX3Wy
	G7mId45aBr+bSyK/IAoGvE2wiL48BuJoYbyPDrI+0FwLU8QAOmLWZworBvuK/ismAJPfDH
	jOPguMMKuA1+Sob/Ht/yM1OBw7B8hnU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.linux.dev, 
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3] arm64: Add basic MTE test
Message-ID: <20250227-b48587a0c6e38bff00a30934@orel>
References: <20250102111020.130788-1-vladimir.murzin@arm.com>
 <Z4aHBrpgiyWNXac2@arm.com>
 <53d73ed1-567a-4428-b4ac-3c4741218ce3@arm.com>
 <Z8BvUkBIETJvRiln@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8BvUkBIETJvRiln@raptor>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 27, 2025 at 01:57:38PM +0000, Alexandru Elisei wrote:
...
> But yeah, since most of the tests don't check for a NULL return value from
> the page allocator I guess it doesn't happen too often. This test is really
> useful and it has been on the list for quite some time, so I don't consider
> this a blocker.
>

I'm happy to merge this if it's ready. Will there be a v4?

Thanks,
drew
