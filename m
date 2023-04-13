Received: from out-29.mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6534C7E
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 00:10:52 +0000 (UTC)
Date: Thu, 13 Apr 2023 00:10:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681344650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HCnXOj3LEZN88jyRNUFFg8GsQnQc0xXS8kokzqYep/c=;
	b=UpfE94B7TEW3IFsEyeibHj+V01F9ZaA3Vszow+MunLiFWuLApwY/7uwYcpi0WPcctwKCp2
	zo2MztaA2oCv0QBufKIMOV3ioHt500hShr2DVaQUS0WK9+h+BjH0NXaqg+xGehcu/bnUbp
	egFbBsranYjg2oXQuDxLgNXRy1jVA+k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 3/5] KVM: arm64: pkvm: Document the side effects of
 kvm_flush_dcache_to_poc()
Message-ID: <ZDdIh9xn8F/4S6Zm@linux.dev>
References: <20230408160427.10672-1-maz@kernel.org>
 <20230408160427.10672-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408160427.10672-4-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 08, 2023 at 05:04:25PM +0100, Marc Zyngier wrote:
> We rely on the presence of a DSB at the end of kvm_flush_dcache_to_poc()
> that, on top of ensuring completion of the cache clean, also covers
> the speculative page table walk started from EL1.
> 
> Document this dependency.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
