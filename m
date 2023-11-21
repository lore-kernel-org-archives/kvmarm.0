Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418D554BF5
	for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 23:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mUX18MZs"
Date: Tue, 21 Nov 2023 23:34:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700609654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzscU8pJPPz0uDJjVqfNPK2Gcd3qG5qj1ohUbs88dug=;
	b=mUX18MZsx4GWBicTmYodmgOBsxXopbMo8V7mw/+htiIYlFh6TdXZU8XuoX1X2haPu8L9R1
	IzREyHvw6uZTon71usn2/amofleWoEm5LNK8HzEpdbXq2JiQbFnT6qYDHawRHa0FdcMpKo
	CJZy/xSEv8IEwTjWqi/Ynmd8d2fcujk=
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
Subject: Re: [PATCH v5 11/12] KVM: selftests: arm64: Determine max ipa size
 per-page size
Message-ID: <ZV0-bmqsCM8o_gli@linux.dev>
References: <20231116142931.1675485-1-ryan.roberts@arm.com>
 <20231116142931.1675485-12-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116142931.1675485-12-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 16, 2023 at 02:29:30PM +0000, Ryan Roberts wrote:

[...]

> @@ -518,9 +530,14 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
>  	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
>  	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
>  
> -	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN4), val) != 0xf;
> -	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN64), val) == 0;
> -	*ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN16), val) != 0;
> +	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN4), val);
> +	*ipa4k = max_ipa_for_page_size(ipa, gran, 0xf, 1);
> +
> +	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN64), val);
> +	*ipa64k = max_ipa_for_page_size(ipa, gran, 0xf, 0);
> +
> +	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN16), val);
> +	*ipa16k = max_ipa_for_page_size(ipa, gran, 0, 2);

Oh, also: we have the generated system register definitions available in
KVM selftests at this point. It'd be a good idea to move away from
'magic' values and use the enumerations instead.

-- 
Thanks,
Oliver
