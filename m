Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04711B4F23
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 19:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735845320; cv=none; b=PusemHPxmOVqUenFdt0qUioXnLLCb6LO8hyAsB3+jdZJcmfkLR5tdmfkJ5AdVv5kk041vBblIxS2CBtxdK61AAV2Z+8tm9JBGPVMqMQjblc91KuV40LIkFW+HaiheTH7njwwYRBNnhK/U3P989ZHOn42ef7kS7DLFfRgZauPkhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735845320; c=relaxed/simple;
	bh=K0Bq/LpjtP4wPfZSKsasYBHe+rHjQB7D3W09Uj9kqsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCGFC0JqojtfLoG2YTTfZ40A9I/9VqJOVCI4i5uzjsiBCf8yoiASxrh35u0V2rQLuh+IaphEO+mkdTWLahYoDXxDqZ/xhnugJmT9EBNeTuTdwdOUgY1ROUeNd4MlLBTbXGMosrWGVpWv8Iw21UlMcID4BfcBqVUw0UY/bogOz6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PRLFCIVZ; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PRLFCIVZ"
Date: Thu, 2 Jan 2025 11:15:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735845314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MUdOeCCuXTYBJa2Y14aYbmR7lqycVvovev0PA0FkkeM=;
	b=PRLFCIVZNJ2TOKznSd93zqgxpqnVt9wA3U7ums0392W1LkplKZ4eJ2vjkNvPK2mrhcQ0Zo
	dsqhqrcpHM36uCRoKEZmwO7hwRb4MGvbdBqU9E/Ho6HvqOL/Eh+3T2FBrvVS9YK6Xaq3Cp
	8BvA1LJ6AZiCVmuvDB2/g5/8Y/9r7Io=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v2 00/12] KVM: arm64: Add NV timer support
Message-ID: <Z3blvPxzCxVeCA40@linux.dev>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 17, 2024 at 02:23:08PM +0000, Marc Zyngier wrote:
> Here's another version of the series initially posted at [1], which
> implements support for timers in NV context.
> 
> From v1:
> 
> - Repainted EL0->EL1 when rambling about the timers
> 
> - Simplified access to EL1 counters from HYP context
> 
> - Update the status register when handled as an early trap
> 
> - Added some documentation about the default PPI numbers
> 
> The whole thing has been tested with 6.13-rc3 as part of the my NV
> integration branch [2], and is functional enough to run an L3 guest
> with kvmtool as the VMM and EDK2 as the firmware. YMMV.
> 
> [1] https://lore.kernel.org/r/20241202172134.384923-1-maz@kernel.org
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-next

Time to let it rip!

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
