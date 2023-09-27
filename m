Received: from out-205.mta0.migadu.com (out-205.mta0.migadu.com [91.218.175.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF646134BD
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 07:20:11 +0000 (UTC)
Date: Wed, 27 Sep 2023 07:20:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695799209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nGDgK4VkvdFAx70kBHbL2YmWBTskOTw97TfFkrlXPyk=;
	b=neLjQ4JI688mTQAjht0Ctbp0QlIehUE7T2xwuoGERCmpFiBgb0BIwfA5D+sjKMohlgziAE
	me806sT1qbnX64i8d4r2FrzfhPC1sb82VLvyuCFk5vZhrfHXv44z2Pk1KhZ+rx3UGY6Tb9
	RGL3ByQ7EzVs7hwTsJuT9bxUSMVvVoc=
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
Subject: Re: [PATCH v3 08/13] KVM: arm64: Insert PS field at TCR_EL2 assembly
 time
Message-ID: <ZRPXpa1USIzbDHqR@linux.dev>
References: <20230918065740.3670662-1-ryan.roberts@arm.com>
 <20230918065740.3670662-9-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918065740.3670662-9-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT

'Assembly' is overloaded in this context, I had to reread the shortlog
to make sense of it. Maybe:

  KVM: arm64: Prepare TCR_EL2.PS in cpu_prepare_hyp_mode()

On Mon, Sep 18, 2023 at 07:57:35AM +0100, Ryan Roberts wrote:

[...]

>  	tcr &= ~TCR_T0SZ_MASK;
>  	tcr |= TCR_T0SZ(hyp_va_bits);
> +	tcr |= kvm_get_parange(mmfr0) << TCR_EL2_PS_SHIFT;

nit: FIELD_PREP() is slightly more defensive than shifting an unmasked
value.

-- 
Thanks,
Oliver
