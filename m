Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C1854918
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 21:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748984809; cv=none; b=dco49kVN//DvQl5NTchFU6z9SkB9Hft0bh07GUcbrfDNMZ59wpKq8CWAlcqCTAMn+HTn9mCJVCwN9m3MVIXvRn2Y5CYdJSgV4glvmAKsBBvcnheybw4wQmraCwxtApwKpBBA7LGRtMB5GFu9+gRs1yY4hoK7lZz6SzyeUDl1J+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748984809; c=relaxed/simple;
	bh=SjNREXLxa6SKGboBJ09Hg57v16PAhSdSMdGaed/2AZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3P6C3eE1EHnvouW/fyNmX0MxEl7fOENFixfDTQUl6XrrBRZFcpdzk/e+zyB8q5wUZek9KsHBbAeDnNez4hEz7ENP9faCdJYBz0F86BUTDij12wlds+x2Hwe0MOqQNT5JcR3XpxZYK297fu2wWId+7INzGRJ4L/YokjInLuXGtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tHxpb7PF; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tHxpb7PF"
Date: Tue, 3 Jun 2025 14:06:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748984804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkVH/Hsg9hB9Y2BLlDZT0e74j6PashM/qtkt3KqxLxI=;
	b=tHxpb7PFMY8sMvhN2hJvEZit1pYw5EZZyXgVPMplJr63WNjOf8QUP+s6trYMwAhxnz7gL/
	gXx7D52UlqUGvZiX0GFXMWSbDBr4gh2GSRgAjrmIQWZMie+wGZkfYPAglUR9GaCJJboPDI
	n8htmCWVqG2hxEq/SMSBbGQpCwkymD8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: vcpu sysreg accessor rework
Message-ID: <aD9isAgEuvPL02ER@linux.dev>
References: <20250603070824.1192795-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603070824.1192795-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 03, 2025 at 08:08:20AM +0100, Marc Zyngier wrote:
> This series tries to bring some sanity to the way the RESx masks
> are applied when accessing the in-memory view of the guest's
> system registers.
> 
> Currently, we have *one* accessor (__vcpu_sys_reg()) that can either
> be used as a rvalue or lvalue while that applies the RESx masks behind
> the scenes. This works fine when used as a rvalue.
> 
> However, when used as a lvalue, it does the wrong thing, as it only
> sanitises the value we're about to overwrite. This is pointless work
> and potentially hides bugs.
> 
> I propose that we move to a set of store-specific accessors (for
> assignments and RMW) instead of the lvalue hack, ensuring that the
> assigned value is the one that gets sanitised. This then allows the 
> legacy accessor to be converted to rvalue-only.

Very happy with how this is shaping up.

> Given the level of churn this introduces, I'd like this to land very
> early in the cycle. Either before 6.16-rc2, or early in 6.17.

What's your mood on sneaking this in as a fix for 6.16? It'd fix the
unmasked write bug you mention and hopefully give a semi-stable / early
base for building the 6.17 content on top off.

Otherwise this will be the very first thing I take for 6.17.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
