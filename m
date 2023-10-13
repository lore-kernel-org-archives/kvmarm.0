Received: from out-210.mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A046568E
	for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 05:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q0wsX4Ce"
Date: Thu, 12 Oct 2023 22:56:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697176616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z9xYZluOWeINrDNYpCpjbMOAnY8xg0EvJ0cdWH95J9s=;
	b=Q0wsX4CebIiakLc6bFOP519WBkDO+Bo42cAVFI6AS97tqBM5SzpLOfh1lOKyO9m1GEfw3t
	cQZd7zcFTUF4jTOzBl1YNa9OZerqmqio9924KeMcfo+sVUaN30HtXIpv8Qtpsmim+FJZAZ
	v/x/bt9iLJTrJTAlmiZ3j5uJDXPka9c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Virtualise PMEVTYPER<n>_EL1.{NSU,NSK}
Message-ID: <ZSjcIpdOGpSEjpu8@linux.dev>
References: <20231013052901.170138-1-oliver.upton@linux.dev>
 <20231013052901.170138-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013052901.170138-3-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 13, 2023 at 05:29:01AM +0000, Oliver Upton wrote:
> Suzuki noticed that KVM's PMU emulation is oblivious to the NSU and NSK
> event filter bits. On systems that have EL3 these bits modify the
> filter behavior in non-secure EL0 and EL1, respectively. Even though the
> kernel doesn't use these bits, it is entirely possible some other guest
> OS does.
> 
> Implement the behavior of NSU and NSK as it appears in the pseudocode.
> 
> Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

This is obviously EL0, not EL1. Assuing there's no respin, I intend to
fix up the shortlog after applying the series.

-- 
Thanks,
Oliver
