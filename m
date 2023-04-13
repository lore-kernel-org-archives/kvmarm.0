Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F3E7E
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 00:15:37 +0000 (UTC)
Date: Thu, 13 Apr 2023 00:15:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681344935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oxKqdN2d9o1rjgNqs0FzqHDIOpuH0PBhahAh2+r4yw4=;
	b=mo00ZAK6PrrPng6pfwi13RNopdcsOdIQYpWIg7UhZfUS+CmcM4ej/RoJevZVAE9sIjd22R
	lDs9e8VgSWq9lIPg+iGXN1Kgn2JEPnhldHQeU9viU33XhZfqAhcvDCIFsP6cVbCQ2EKEXD
	e4QmadRWlZvSCeNPMG/WwWkAfoafDIE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: arm64: vhe: Drop extra isb() on guest exit
Message-ID: <ZDdJpDaQYJGiWflS@linux.dev>
References: <20230408160427.10672-1-maz@kernel.org>
 <20230408160427.10672-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408160427.10672-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 08, 2023 at 05:04:27PM +0100, Marc Zyngier wrote:
> __kvm_vcpu_run_vhe() end on VHE with an isb(). However, this
> function is only reachable via kvm_call_hyp_ret(), which already
> contains an isb() in order to mimick the behaviour of nVHE and
> provide a context synchronisation event.
> 
> We thus have two isb()s back to back, which is one too many.
> Drop the first one and solely rely on the one in the helper.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
