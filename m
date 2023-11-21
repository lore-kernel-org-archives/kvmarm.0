Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524C254BF6
	for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 23:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xZyA4pfN"
Date: Tue, 21 Nov 2023 23:38:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700609893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Icb20eLrJ/nzL20PpPHl5GV+ZheV6wphliX3+cd+S/Y=;
	b=xZyA4pfN3Gwr8l6pBaTEnmQGNGYZBHwHH1pwOaz4jft+qQjyF8+d4XOum+WBoGwOra8STO
	3WOej63Adrh7p/E3i4Xk/XGEgv5nQXBql2IIsmWXbPBxpI5DLix1TbRdSATC4yuRgwn0dQ
	EWWyKBG/csmomWD38X3TTJFPm+j1JrQ=
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
Subject: Re: [PATCH v5 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm
 s2
Message-ID: <ZV0_YSm07-5SXdcz@linux.dev>
References: <20231116142931.1675485-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116142931.1675485-1-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Ryan,

On Thu, Nov 16, 2023 at 02:29:19PM +0000, Ryan Roberts wrote:
> Additionally, when running page_fault_test, when run on FVP against v6.7-rc1 and
> newer, I'm seeing RCU stalls. I'm confident that this is not an issue introduced
> by this series because it reproduces without my patches.

Oh, that's interesting. Can you gather any additional details, like what
test case in page_fault_test trips the RCU stalls?

> Anshuman Khandual (1):
>   arm64/mm: Add FEAT_LPA2 specific ID_AA64MMFR0.TGRAN[2]
> 
> Ryan Roberts (11):
>   arm64/mm: Modify range-based tlbi to decrement scale
>   arm64/mm: Add lpa2_is_enabled() kvm_lpa2_is_enabled() stubs
>   arm64/mm: Update tlb invalidation routines for FEAT_LPA2
>   arm64: Add ARM64_HAS_LPA2 CPU capability
>   KVM: arm64: Add new (V)TCR_EL2 field definitions for FEAT_LPA2
>   KVM: arm64: Use LPA2 page-tables for stage2 and hyp stage1
>   KVM: arm64: Convert translation level parameter to s8
>   KVM: arm64: Support up to 5 levels of translation in kvm_pgtable
>   KVM: arm64: Allow guests with >48-bit IPA size on FEAT_LPA2 systems
>   KVM: selftests: arm64: Determine max ipa size per-page size
>   KVM: selftests: arm64: Support P52V48 4K and 16K guest_modes

Besides the nitpicks I left on the series, LGTM.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
