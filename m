Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3DA243952
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 19:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740598914; cv=none; b=o8qM54zD6I1y0ZKXZeDxLe5Ak0eTIn1l9LM9UTfyp5glGCaCVP7hpykR24Z5fAqMqTHKExkD/pRIi0VE44q6meJ1a4Q7sRfDyxG2ZxFhrbmxNNZkOyunQCQw2T46r7aRiBAEBq+O0kgva5T+/PXsL2ytU2PzQC0v5dbD2aKUQ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740598914; c=relaxed/simple;
	bh=7pZh90N8TfW4nNCG9ZnFUXoQJcYSf9KBD94LTDVR4Vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVguDtVJQyfrkTcnmBh53Tcd8KKjBsUz9FE1TxUs5xLtyVmxG1Cwn2EGUeKkYMjP4snq66RS6Pv9qZROMmC1+mCWZJlRyNRGz2NQOWXaGF+iy5ShZJSvR4MqW4bjsJRlX2mYgoMjv2BOChcw+ISrDxpMjcll3v6UuRE2RMOaNjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F09C4CED6;
	Wed, 26 Feb 2025 19:41:51 +0000 (UTC)
Date: Wed, 26 Feb 2025 19:41:49 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v8 5/6] smccc/kvm_guest: Enable errata based on
 implementation CPUs
Message-ID: <Z79ufaZULK15EUk2@arm.com>
References: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
 <20250221140229.12588-6-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221140229.12588-6-shameerali.kolothum.thodi@huawei.com>

On Fri, Feb 21, 2025 at 02:02:28PM +0000, Shameer Kolothum wrote:
> Retrieve any migration target implementation CPUs using the hypercall
> and enable associated errata.
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

I can see ways in which this can go wrong but, in the absence of a
better idea:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
