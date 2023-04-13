Received: from out-24.mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2DE7E
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 00:10:06 +0000 (UTC)
Date: Thu, 13 Apr 2023 00:10:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681344604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wt4vsusNSg8/0nu8Bm5XWvB2zO4ZKlMCIL7i+a135ko=;
	b=pqPkcZy6S9lNv60O6xjf9Of4MIiZzeQEzH3uEimM/yQehZTSUpmjAfEuAWm9VwCuEYU+zo
	OQJ9QQy5cp+bVYgMYE5YiJJHsUoBk2QV4ZhIQTXaYAju0DZ6sT9Qx00gnIP9eRD5YQjX67
	hDdVZvUJs9W7WDOgfCWGns3HyzqBHA8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 1/5] KVM: arm64: nvhe: Synchronise with page table
 walker on vcpu run
Message-ID: <ZDdIWIIogROyg1zD@linux.dev>
References: <20230408160427.10672-1-maz@kernel.org>
 <20230408160427.10672-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408160427.10672-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 08, 2023 at 05:04:23PM +0100, Marc Zyngier wrote:
> When taking an exception between the EL1&0 translation regime and
> the EL2 translation regime, the page table walker is allowed to
> complete the walks started from EL0 or EL1 while running at EL2.
> 
> It means that altering the system registers that define the EL1&0
> translation regime is fraught with danger *unless* we wait for
> the completion of such walk with a DSB (R_LFHQG and subsequent
> statements in the ARM ARM). We already did the right thing for
> other external agents (SPE, TRBE), but not the PTW.
> 
> Rework the existing SPE/TRBE synchronisation to include the PTW,
> and add the missing DSB on guest exit.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
