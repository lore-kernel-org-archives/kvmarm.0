Received: from out-125.mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE601426E
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 18:47:48 +0000 (UTC)
Date: Fri, 28 Jul 2023 18:47:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690570066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c8yvLUIK06RQnV+ryYtZxv7pPU7Be4Nu1kldUxWjnGs=;
	b=pSQ6PrxgtzAipZ6/F3I1GCMvO4QAEtJSttNGskJutWkHfocv7PXkdzqBmXO9vHFIix8WHH
	YAFgERbB4edHX9sU4STeYFJOoQqhymhRwaaY3jagO00wjR6MWTtzuLnMqpqBa5yU7/9Ppx
	f82YMEUCTg60lJBlVEbroTJwi7B+JTA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 19/26] KVM: arm64: nv: Add trap forwarding for
 HFGxTR_EL2
Message-ID: <ZMQNTKAlxQe61JUe@linux.dev>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-20-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728082952.959212-20-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Fri, Jul 28, 2023 at 09:29:45AM +0100, Marc Zyngier wrote:

[...]

> @@ -943,6 +1025,27 @@ void __init populate_nv_trap_config(void)
>  	kvm_info("nv: %ld coarse grained trap handlers\n",
>  		 ARRAY_SIZE(encoding_to_cgt));

It might make sense to skip insertion of the FGT trap controls if the
system doesn't have FGT in the first place.

> +	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
> +		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
> +		union trap_config tc;
> +
> +		tc = get_trap_config(fgt->encoding);
> +
> +		WARN(tc.fgt,
> +		     "Duplicate FGT for sys_reg(%d, %d, %d, %d, %d)\n",
> +		     sys_reg_Op0(fgt->encoding),
> +		     sys_reg_Op1(fgt->encoding),
> +		     sys_reg_CRn(fgt->encoding),
> +		     sys_reg_CRm(fgt->encoding),
> +		     sys_reg_Op2(fgt->encoding));

Same comment here, we should just bail.

> +		tc.val |= fgt->tc.val;
> +		xa_store(&sr_forward_xa, fgt->encoding,
> +			 xa_mk_value(tc.val), GFP_KERNEL);
> +	}
> +
> +	kvm_info("nv: %ld fine grained trap handlers\n",
> +		 ARRAY_SIZE(encoding_to_fgt));
>  }

-- 
Thanks,
Oliver
