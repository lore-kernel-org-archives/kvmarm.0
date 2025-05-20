Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BEA2505C5
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 14:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747752304; cv=none; b=Goi8D7pPlnCiIFrqCoYnHbQ14WDrxpZ2WrqjWVrN13WPm34yMR6qQ3kq5fZQZw82mgR9Yn+IrBnxUpguupSrwT+qXmvUdYT6z2RI/twKpxfjvOAr5xoShpIbjmIHESUYsvEx4nDgqO3qyUlf9NRMLlgj/xKakltlGeEnDCNd2LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747752304; c=relaxed/simple;
	bh=lsrQBUsh/NcofW8AcC2wNbNyYAAEYCVwe8uRjNdU0u0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmN9OU1BQyORz5Lga+7smY4sVjH8l10xcBbWiORdnN3AAGWCQiSM0iMMKbLYBFgsP/WPKn9W3DeZJkM35KsTOUNt9QHWhqdqtfuqCRUSOwgIKul+6WFFb2E+1WUu0b7HJUBsm+2cvjyHbi+9a3Ky3jG0arCsMFY7TbbbXAzS6+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UyGvEBG5; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UyGvEBG5"
Date: Tue, 20 May 2025 07:44:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747752299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4QiPzegzwWMimeKLYXw7eRUkiMa9v65hnQUzfy1wEmg=;
	b=UyGvEBG5/UE2BLq8svc7VF0cWdc8owLvSYOMEKwtxckD+IlNgvzc/UdCmRikClyfNSsr8u
	yQPtiDc2eTYnh3NDzw1PcyHoju/RZIb0K0L5SxqCVw4aJa+D6ykge+kly34aJyHQ15AFj7
	QO2/16e1e5CEBFiWcXsSEVjY6hyMBw4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Hold mmu_lock when invalidating VNCR
 SW-TLB before translating
Message-ID: <aCyVYfg3Fy3Nzluh@linux.dev>
References: <20250520144116.3667978-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520144116.3667978-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, May 20, 2025 at 03:41:16PM +0100, Marc Zyngier wrote:
> When translating a VNCR translation fault, we start by marking the
> current SW-managed TLB as invalid, so that we can populate it
> in place. This is, however, done without the mmu_lock held.
> 
> A consequence of this is that another CPU dealing with TLBI
> emulation can observe a translation still flagged as valid, but
> with invalid walk results (such as pgshift being 0). Bad things
> can result from this, such as a BUG() in pgshift_level_to_ttl().
> 
> Fix it by taking the mmu_lock for write to perform this local
> invalidation, and use invalidate_vncr() instead of open-coding
> the write to the 'valid' flag.
> 
> Fixes: 069a05e535496 ("KVM: arm64: nv: Handle VNCR_EL2-triggered faults")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
