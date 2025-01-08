Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE4204097
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 20:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736367276; cv=none; b=JfQZeEDGqLxk6fK4lF/PKYF4pi4sCgS9+CwELgJ6q8wf4YCqOpYVUjTcLcBBBYpRfGK+k13ew/Ti5rwbTJV1/DZbvfIj/ZEXagjdcqnfONiwA3RYq9wKI1iq7cB7UqIP8NmK0zsHQikwvKZjmNAfdaVIQzMCg/eGKn2IVRwW4oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736367276; c=relaxed/simple;
	bh=6F2pbz/Wu24QOXFP4/iEFKMOEDe0YTjsJCJjNPvrp2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPsqhrBv8Xr2tRI4bqJyW5lGEemqLtV+W/tq7hFr1yb6pzayLRmmqrsVMMO09Y3aCL5VyW4HFW6a8HQv5/je+5JZ7rvbprbKkpG/ZztAP6jBl912eejtKHfjfQw2t15WnFFhPKZAJts6Cq3vYSCix9PA1oBkYVIwVv3rMPSYvKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h5VZv3N7; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h5VZv3N7"
Date: Wed, 8 Jan 2025 12:14:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736367260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3dUcoQ+aJnvEfN1li7ugchm2pXhqwyBsL7eSPz6fVuQ=;
	b=h5VZv3N739dsIe4sOr6/azdQLG5BRbbL8SnCVksw3MIVjGefRV0Jb3Pfn2Z1MF/5cT26tU
	Yl+Cc4kSm/JJCVH8649DQj5nvX556dqpLYwPqN28NG7J2IQQiD0T2CVo41j/huapyaxURx
	sAMxBL8Y42QHcAgAU4Ukfjfi6tQZEQk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] KVM: arm64: Support FEAT_PMUv3 on Apple hardware
Message-ID: <Z37cjxFu2CPi_xNr@linux.dev>
References: <20241217212048.3709204-1-oliver.upton@linux.dev>
 <20250108123840.GA9197@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108123840.GA9197@willie-the-truck>
X-Migadu-Flow: FLOW_OUT

Hey Will,

On Wed, Jan 08, 2025 at 12:38:41PM +0000, Will Deacon wrote:
> What's your plan for this series? I started looking at it and I can take
> the first four apple_m1 patches if you like?

I plan on posting a respin of it by next week, which should look pretty
much the same besides cleaning up the build error I introduced :)

Besides that, I think we need to decide on the KVM side of things
whether or not we want to support an event counter in addition to the
PMU cycle counter. Janne's FEX use case would certainly benefit from it.

Do you think you could grab patch #3? It is entirely unrelated to the
series at this point with the PMUv3 event remapping helper.

-- 
Thanks,
Oliver
