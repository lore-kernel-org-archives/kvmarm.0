Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F7120315
	for <kvmarm@lists.linux.dev>; Thu, 25 Apr 2024 22:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714085731; cv=none; b=pt8/nbyGWsSC7fZ92Bew9MVxkd8P3aWxNeDI2quSnW/AEOv2P5Ubvfl4iEKom03q25w9PSGQIQpK0refS0GozKl6+2VZ22dBIJs72Jt0oqH1PZFFxgGCFhVYCLk329UifnSJvvYjpBDSNCq17IXmaL05kOe0YKtMl1lytndyVyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714085731; c=relaxed/simple;
	bh=RAMz0EUn779STR8UIXkha6n/UjNFfCNG3tzTbrRGaKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBX6SzgKVSGuOIEJcF9A6B/Jrk7JSxlxBYIqroMnm7M519zCa4v1u02RvsTvw6grkWVxtgLgZs4MT0e2WUlfuHkGGHw01GoFv0h5Q8MKNBgUZTbKSZqCnPSwejVf5pKt2ghFYOVH2yOVdsH6JavOmOgkFpkS8pLkU3ugku9+rns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SulE+GVc; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SulE+GVc"
Date: Thu, 25 Apr 2024 22:55:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714085726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w3elffUSaCE82CNXOenDJA7CQxBzhZeR1QaB6713ugY=;
	b=SulE+GVcVBeNRj9TuhtWuWTYPVX+WtIkoj6edRWVjuBPtTm/HU97va89pxCkQ0GBoRXIjn
	ilEoGN6XHDLK1inZ4KppgvsjI5458f5p4EKqhX6Ntco+vZ0NVejZ15u8NZzY2vH+tLYeRH
	kktQcYyeYO3COYjUfGGBZIndR1QSRVA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v4 21/30] KVM: arm64: Refactor calculating SVE state size
 to use helpers
Message-ID: <ZirfWVZ-PsET5Aii@linux.dev>
References: <20240423150538.2103045-1-tabba@google.com>
 <20240423150538.2103045-22-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240423150538.2103045-22-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Fuad,

On Tue, Apr 23, 2024 at 04:05:29PM +0100, Fuad Tabba wrote:
> The main factor for determining the SVE state size is the vector
> length, and future patches will need to calculate it without
> necessarily having a vcpu as a reference.

Unless I'm missing something (which happens a lot), I don't see any
users for sve_state_size() in this series. The refactoring looks
fine, but let's only do it when there's users for it.

-- 
Thanks,
Oliver
