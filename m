Received: from out-26.mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F3719539
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 15:44:56 +0000 (UTC)
Date: Fri, 9 Jun 2023 08:44:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686325494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vPnlIRVGxj8AeQiaq3bAFwvGduBuAp2E7TLGSfDQuEY=;
	b=kCvdF6x5Ui7p2uYuAw8e0+ZOCZ9jdiuTfejEV/+f9FynBFrrivqpYS+WgpldF4ADxknz7n
	EnUpapJPqGOr4cWrWST9aM/SroIqLJ7rNerE/Kv1NsLUi4P0U9F92hSfAzcjdykt0K8vtP
	MSOED852Q/+yMxfDpf0O/bS5SQ8UZ34=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/3] KVM: arm64: Clear possible conflict aborts
Message-ID: <ZINI8KpQsrSOW0I5@linux.dev>
References: <20230602170147.1541355-1-coltonlewis@google.com>
 <20230602170147.1541355-3-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602170147.1541355-3-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 02, 2023 at 05:01:46PM +0000, Colton Lewis wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7a68398517c95..96b950f20c8d0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1591,6 +1591,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		return 1;
>  	}
> 
> +	if (fault_status == ESR_ELx_FSC_CONFLICT) {
> +		/* We could be at any level. 0 covers all levels. */
> +		__kvm_tlb_flush_vmid_ipa(vcpu->arch.hw_mmu, fault_ipa, 0);
> +		return 1;
> +	}
> +

This does not match the architecture. Please read DDI0487J D8.14.3
"TLB maintenance due to TLB conflict", which tells you exactly how to
resolve the conflict. TL; DR: TLBI by address is _not_ guaranteed to
invalidate duplicate TLB entries. vmalls12e1 is your friend.

The conflicting TLB entries are local to the CPU that took the abort, so
you don't need to do any broadcast.

--
Thanks,
Oliver
