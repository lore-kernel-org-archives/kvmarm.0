Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3703C3112BB
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 18:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757615261; cv=none; b=RoFYpKfEvYuqh3hryIHX56JJUr8vR3cX32c6k5Nd2CHOKBcSgW6fEv//IpzR172AEcW39xO1Z5vz6Vva5UbrY3VV80UBXdathDofD+tQmuhVZ3WngTczB9KNHCugSx/+BQX7QQjcLFxhlvGFIEaen6y7W6H0WfqrAPmnx49x9s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757615261; c=relaxed/simple;
	bh=dMozuue/sJaEdI+2v0oGtDcTdVocJ4ZzaVwH4WcwWac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDXZNWNGsiboCz8rSLV26k67HvmloINiVSSoYl8BmLO/Hr5GDPlUIXEYGp8Yp6SMDh6P3huracYFw7tOesRXM9lfhwCfqlXzZc3URDzbCV5tef8lF9J45ru9YXd7l6B0dbGQBkmhgqwKO0bIEHkZ0wS7UNyRPbhFDSCaOH/EPkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m66MoVbH; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m66MoVbH"
Date: Thu, 11 Sep 2025 11:27:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757615256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1PEqqMkQCCsIIK80US5++EkJbtoh1psej63veCBFsh0=;
	b=m66MoVbHAakOQHxhknbRV0aEtrzLIl0zCY5MZnXw/n2GB/8mMD2z8KI6sr7j6Zg2VMz5fZ
	LrEYbqoS2fE1sJyLz+JwXmPOOsVm1xe52j/yNKp+vJUnkU92KRcLd/H0qB2d1zMQk7NV3/
	0LIJakGffNrD7vjzin8Tacb4DAiuocM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jack Thomson <jackabt.amazon@gmail.com>
Cc: maz@kernel.org, pbonzini@redhat.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	isaku.yamahata@intel.com, roypat@amazon.co.uk,
	kalyazin@amazon.co.uk, jackabt@amazon.com
Subject: Re: [PATCH 1/6] KVM: arm64: Add __gmem_abort and __user_mem_abort
Message-ID: <aMMUiyPLd1-_-V5p@linux.dev>
References: <20250911134648.58945-1-jackabt.amazon@gmail.com>
 <20250911134648.58945-2-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911134648.58945-2-jackabt.amazon@gmail.com>
X-Migadu-Flow: FLOW_OUT

Hi Jack,

On Thu, Sep 11, 2025 at 02:46:43PM +0100, Jack Thomson wrote:
> From: Jack Thomson <jackabt@amazon.com>
> 
> Adding __gmem_abort and __user_mem_abort that preserve -EAGAIN results.
> These will be used by the pre-fault implementation which needs to retry
> on -EAGAIN.

-EAGAIN is a pretty clear signal that another vCPU has faulted on this
memory and is in the middle of installing a mapping. Why bother with
retrying?

If we conceptually treat this thing as a synthetic stage-2 abort then it
should use the same EAGAIN handling as a literal stage-2 abort.

Thanks,
Oliver
