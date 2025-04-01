Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 255671EBA18
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 12:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743512153; cv=none; b=R33PdLDTi7NGgkYd+Fq+9L0NFwLEWZaLIfU+9KvqqWO9gw7YoioiW2Lo5NY/nJsOHw0FCj5GvtNHPnlBD9AgxVSGcyWv9V2/wm9ObM4FOs2RLKfk2AKVbmZQP5X9NHuLjbng7BRBdgv1V0hpK2YfMwdpnBxlC/4gbpjGYz50H4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743512153; c=relaxed/simple;
	bh=uqyToMqi0crBXol5MsKWo/VFUHfdKEBnUBxBzM5yeYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmyb5c8n2LNFTbpmfLDCmEEKAh4pPCgkMcH4bHZq3ePKltV4RkCO4zLhLHQKdRtcJ7bzSRHlVKU3K/P/qro4ST46cHmpv5elqEIyTL3wTc5IJYHqUGsx12cpibVddPlyOJHhj9iHjSzBgcd6hiND3ryzsAbjbgOJeuYT0H7lAVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B52AD150C;
	Tue,  1 Apr 2025 05:55:54 -0700 (PDT)
Received: from bogus (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 409373F694;
	Tue,  1 Apr 2025 05:55:48 -0700 (PDT)
Date: Tue, 1 Apr 2025 13:55:45 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Quentin Perret <qperret@google.com>
Cc: Sebastian Ene <sebastianene@google.com>, catalin.marinas@arm.com,
	joey.gouly@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>, snehalreddy@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, will@kernel.org,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com, Andrei Homescu <ahomescu@google.com>
Subject: Re: [PATCH v4 3/3] KVM: arm64: Release the ownership of the hyp rx
 buffer to Trustzone
Message-ID: <20250401-innocent-outrageous-deer-0946c5@sudeepholla>
References: <20250326113901.3308804-1-sebastianene@google.com>
 <20250326113901.3308804-4-sebastianene@google.com>
 <Z-Qv4b0vgVql2yOb@google.com>
 <Z-UcW32Hk6f_cuxc@google.com>
 <Z-aKgXVjp4nNJcLd@google.com>
 <Z-avzxyyOiaIk3-C@google.com>
 <Z-vVZt6RTNX90uEw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-vVZt6RTNX90uEw@google.com>

On Tue, Apr 01, 2025 at 12:00:38PM +0000, Quentin Perret wrote:
> On Friday 28 Mar 2025 at 14:18:55 (+0000), Sebastian Ene wrote:
> > 
> > If we apply what I suggested earlier we won't have an issue with the
> > semantic for this call but it would make the code a mess. I don't think
> > for this particular call keeping semantics really makes a difference.
> 
> Right, if we implemented the release call properly in pKVM I'd be happy
> with this patch, but I just don't think we should only do one half. We
> either do it properly in pKVM or leave it with to the host -- the latter
> feels simpler to me, but no strong opinions.
> 

FYI:

As part of the earlier discussion with respect to clarification on this
from the FF-A spec, I found even the driver was not handling this correctly.
I have posted the fix since and plan to get it merged as fix for v6.15

-- 
Regards,
Sudeep

[1] https://lore.kernel.org/r/20250321115700.3525197-1-sudeep.holla@arm.com
