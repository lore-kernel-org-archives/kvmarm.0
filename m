Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE11C20D4E1
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 16:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743525642; cv=none; b=vFucUc5QQkyjKWwmRFyLciaC0dvWWVCqtP+xog2Pv4NXxVyg5/MI1Vuecqj4hLGvSSk1Oie9YL7ZyVSsyWqbuqzCA3sFGHzB/Z2pRQ/G9DWe+KU16uFxKRAJUxQNDz7a3JAnV1FKTHcgg2U6cTdoqXU/77uyoSLvPirmvBzsCXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743525642; c=relaxed/simple;
	bh=N4MdmZu2J+XMwLnFNKCoeXGOo7RyEpt6SzVgSso22NQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n82xaBQyQ8wVXQJ6JoiXg/lh3p4kebCdK23o6Hak4UEuS4Ujt8CFJUGPOsQDez4OiuXTF5GkCUCq4PUFwzFpll8qMmoQolr5iZfqGCA0RaIoZdwBiLpKGk8+hv2XCXi1YSBHbwTHwfMMh+wGPRqUOnyhzkZF3DF5EYQpLrGpRUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HEewnL3a; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HEewnL3a"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743525637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zYUajYEgIu0kpaRr9fhK6rfntAAkCeN1QZWeY8TpPJ8=;
	b=HEewnL3aSqSTJodBjO9Q/F6cT66uYFLhtAAB8L7njw3uHxAFspi49V5xwXrZuMqGnW4z+I
	lgnp74R5M5Pri28awW+Ajqb5Gxa9ENbB6S9YoDL/zLtrSlDpr6y6sw0RCU048kgYAUzI/+
	iT0iZJCaWTOjeoz6u7FWFPq6FNnL+A4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH] smccc: kvm_guest: Align with DISCOVER_IMPL_CPUS ABI
Date: Tue,  1 Apr 2025 09:40:26 -0700
Message-Id: <174352555798.2753071.8481161802308155159.b4-ty@linux.dev>
In-Reply-To: <20250327163613.2516073-1-oliver.upton@linux.dev>
References: <20250327163613.2516073-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 27 Mar 2025 09:36:15 -0700, Oliver Upton wrote:
> The ABI of the hypercall requires that R2 and R3 are 0. Explicitly pass
> 0 for these parameters.
> 
> 

Applied to fixes, thanks!

[1/1] smccc: kvm_guest: Align with DISCOVER_IMPL_CPUS ABI
      https://git.kernel.org/kvmarm/kvmarm/c/acfcaf90db1f

--
Best,
Oliver
