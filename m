Received: from out-20.mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFF84420
	for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 18:38:22 +0000 (UTC)
Date: Wed, 17 May 2023 18:38:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684348700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VADbWaPZL/zhG2c6e1p0Yiznf8RS4MLXiOGMohKfvKA=;
	b=GWmFapC3pwKy3Ow+nUV3D64O7mk+VdhbZc858Oi8uuSE0uzaH2+gjVww3a7aY5Mw3iJubu
	wB5AO/sqcmBiX/UcCRAZhKal9bEET8CI6G99QT6xQcLruQBHF2xwU2XmmDY9tekozCrLMt
	TDt3uQjvT1SpM8xNmJI7kMt3xOQyqHo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Salil Mehta <salil.mehta@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	yuzenghui <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Message-ID: <ZGUfFn0jai9n4eSF@linux.dev>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
 <20230404154050.2270077-9-oliver.upton@linux.dev>
 <87o7o26aty.wl-maz@kernel.org>
 <86pm8iv8tj.wl-maz@kernel.org>
 <fd9aee7022ea47e29cbff3120764c2c6@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd9aee7022ea47e29cbff3120764c2c6@huawei.com>
X-Migadu-Flow: FLOW_OUT

Hi Salil,

On Wed, May 17, 2023 at 06:00:18PM +0000, Salil Mehta wrote:

[...]

> > > Should we expose the ESR, or at least ESR_EL2.IL as an additional
> > > flag?
> 
> 
> I think we would need "Immediate value" of the ESR_EL2 register in the
> user-space/VMM to be able to construct the syndrome value. I cannot see
> where it is being sent? 

The immediate value is not exposed to userspace, although by definition
the immediate value must be zero. The SMCCC spec requires all compliant
calls to use an immediate of zero (DEN0028E 2.9).

Is there a legitimate use case for hypercalls with a nonzero immediate?
They would no longer be considered SMCCC calls at that point, so they
wouldn't work with the new UAPI.

-- 
Thanks,
Oliver
