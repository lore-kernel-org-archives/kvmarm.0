Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEA3323E
	for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 18:35:59 +0000 (UTC)
Date: Fri, 17 Feb 2023 18:35:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676658957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6qPUIlrAqdWw119xSuvPcIRUnxHbEoSXWSdwW7asdJY=;
	b=Rc03kNSpdg1lE63r+qqNHFhINxu6bF2u6pnsnCnfhniG2DDkj2jE5ryJK6w08ent3I+nY0
	S+lTE0VzuE1pkutIFKidfTQi6zrLVysP76lpSphN/qsn05H3ZChaFqoF4IAU/B4fs4EGmd
	+x4X0RLUxWnnKKSfrfSEInVpibhM7lw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [RFC PATCH v2 6/6] KVM: arm64: Indroduce support for userspace
 SMCCC filtering
Message-ID: <Y+/JCS30AD0sr0Q0@linux.dev>
References: <20230211013759.3556016-1-oliver.upton@linux.dev>
 <20230211013759.3556016-7-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211013759.3556016-7-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 11, 2023 at 01:37:59AM +0000, Oliver Upton wrote:

[...]

> +    struct kvm_smccc_filter_range {
> +            __u32 base;
> +            __u32 nr_functions;
> +            __u8 action;
> +            __u8 pad[7];
> +    };
> +
> +    struct kvm_smccc_filter {
> +            __u32 nr_entries;
> +            __u32 pad;
> +
> +            struct kvm_smccc_filter_range entries[];
> +    };

After dealing with this when writing the selftest, I feel like this is a
bit over complicated for both userspace and kernel.

Next revision will take a similar approach to the PMU event filter,
allowing userspace to insert new ranges into the filter with successive
calls to the interface.

-- 
Thanks,
Oliver
