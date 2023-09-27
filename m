Received: from out-201.mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA702C80
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 06:38:49 +0000 (UTC)
Date: Wed, 27 Sep 2023 06:38:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695796728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ANzSUeT13BcRikCCyItwl6K1na2mnc5Bfg6YABeioAE=;
	b=IgC7EixxEj/SBVKdii29qQDtWu6vEhtxjFFXja4fPRIMHRqtffx8C94iuWKAWq/qz1iHjW
	ewCFJBH55eGEvMJAUYEofWEt5zWNd7Cb9pFEw5+4QN5hjG+aoe3BuANLRZf0Ldgn3nfOmB
	6iNv9tvn6GGhMk75/QgJu7Zqg859qWI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 04/13] KVM: arm64: Add ARM64_HAS_LPA2 CPU capability
Message-ID: <ZRPN8yOkfwiasLDl@linux.dev>
References: <20230918065740.3670662-1-ryan.roberts@arm.com>
 <20230918065740.3670662-5-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918065740.3670662-5-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Ryan,

On Mon, Sep 18, 2023 at 07:57:31AM +0100, Ryan Roberts wrote:

[...]

> +static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
> +{
> +	u64 mmfr0;
> +
> +	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> +	return has_lpa2_at_stage1(mmfr0) && has_lpa2_at_stage2(mmfr0);

Should we only require consistency between stage-1 and stage-2 if KVM
kvm_get_mode() != KVM_MODE_NONE? In case there are systems that have
mismatched LPA2 support users can just disable KVM to use the feature.

-- 
Thanks,
Oliver
