Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71AB129B796
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 10:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763548362; cv=none; b=XSw31lNI2+jaQDFvOBOXVLdIdeASzLL3EAy1G2S2X0YSmKdkJD20rbDkLVPmdl0DSnHTt/OtzDwAJ4PseKxtwcvkpyS+JqaH7nRzu8XsN87b6ojtgzzq31OPZtcC7PrwewiW2tXwit3PfLS0FWQjIKIGUiRBUW7Y+fQ2WykZu7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763548362; c=relaxed/simple;
	bh=F7/fiSvIJBbaULfVsASenmsL6anZJEEKyHEQng8osBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LagIx+Srornvn4pknTfsPCuPhhoxsqaQV1aDsJ6a/cCeqtguYJxe3DthjqeLSmS/rGxuqgLz3WiVgsOzpPvHFRNoWPQVEQAoMMyqz0XWgnXBvomxOZOXr4xxSeUlS3iPZvZarkmpN7oRQw9/kNbqKjgVpzC2EnEVEHqW/KZ+u3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A99AFEC;
	Wed, 19 Nov 2025 02:32:26 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D304D3F740;
	Wed, 19 Nov 2025 02:32:32 -0800 (PST)
Date: Wed, 19 Nov 2025 10:32:18 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fixes to KVM struct allocation
Message-ID: <20251119103218.GA2193219@e124191.cambridge.arm.com>
References: <20251119093822.2513142-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119093822.2513142-1-oupton@kernel.org>

On Wed, Nov 19, 2025 at 01:38:20AM -0800, Oliver Upton wrote:
> Small fix to drop __GFP_HIGHMEM from KVM struct allocation GFP flags,
> which was always completely pointless and now trips a WARN for passing
> such an unsupported flag to vmalloc().
> 
> Oliver Upton (2):
>   KVM: arm64: Drop useless __GFP_HIGHMEM from kvm struct allocation
>   KVM: arm64: Use kvzalloc() for kvm struct allocation
> 
>  arch/arm64/kvm/arm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa

Also nice to drop a usage of a __-prefixed function.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> -- 
> 2.47.3
> 
