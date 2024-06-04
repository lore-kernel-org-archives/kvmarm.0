Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BD318028
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 18:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717526976; cv=none; b=bzo8kKtkuErmJayt1FWs9jGmZC1zVqVdzfGSIZ+UFXaNX6vOvk48Uj4wj0JmjxlUiCRglPs+FWKBzCqCHeQasxnDu1zUlhTwRrpuNuJdILuj/aThZ6qNEpirlVXddwFYrQwKExWT/aGU5nDStYJFZiL5+HWqafhFNjLOokU7TiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717526976; c=relaxed/simple;
	bh=ATJWEG+1bxat0pnXmMVZslPvDWRRtqe23y2AyQpUcrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r+DFbOqWwhNGlqZi4rECMh8yO4wXerBXed8Yt0cs0Aeq/PuelITwhLeEUEUBJnCv7HoXcnE/6+Je26cPB9JmsIBgE7Oc2qjTO6CglfskB+sI2p8oGc6qsnMSoeTA0uuyK/lkRA3z1yRHFrr4Tksz1uOpoL+r9aiJ5ycA4zOBozw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xh6Vpswd; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xh6Vpswd"
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717526972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U7lKUQvdh3JnvQnC5tJiwKlWv/mRnqA/ehXRG/1b3Ec=;
	b=Xh6VpswdhlRRUAIYGXwI+gY0MhcIke9swIn8iSvassAWd8no1fcIbsDSFc1uipuiut6IWB
	7Fy/qq3/Tbgeq1f8XaOeDcaIcFLGu0ytvotWTTCT4JxSDnp0MPB6ms1MbpBr+F8N0t+faV
	K4k9QlZJSu0poHuoOmDMhVaIvVZaESg=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: joey.gouly@arm.com
Date: Tue, 4 Jun 2024 11:49:27 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 0/4] KVM: arm64: nv: Add CPTR_EL2 handling
Message-ID: <Zl9htwfHBwSixROH@linux.dev>
References: <20240604130553.199981-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604130553.199981-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 04, 2024 at 02:05:49PM +0100, Marc Zyngier wrote:
> Building on top of Oliver's NV+SVE series[1], I've put together a
> small set of patches handling CPTR_EL2, as the two are pretty closely
> related.

Thanks for posting this, overall looks good. I'll probably pick this up
and repost a combined series that eliminates some of the incidental
churn that I've forced upon your patches.

-- 
Best,
Oliver
