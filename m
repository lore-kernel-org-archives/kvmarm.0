Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839DF156FB
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHJ2D/6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D539DC433C8;
	Mon, 27 Nov 2023 15:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701098338;
	bh=IUTbtjCqAwlfPUCZ69Cwygwt0LrChKSd88AoCWNYbYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHJ2D/6/hlAXQlkJNVelRvDZ7Rly5/mUG9PoX4BASz/nmzlS/oUyc1b69olD0k2AN
	 Y15UibJMc96qjFMwWH7K5GU/YjErMuq3+n9w3+sfg64/AiKn6PlKk3sarGr6EFZTug
	 G9bw4M7Co+8BseiHx5Z7JbhphSdpEirfl7g2L9sB1a8k+KiHTeqFBUWhLxYVFTvd1X
	 wC+6HQN1yJsW1mgpRB/u02kFOzU+GVOgF5nZk8J9v75Jg+Kyb1UAu3uXaAHGqVpCu3
	 Q3EPNVvwrlPABkHmjNrh7aiXAcqiQzbOYu81X3q6Ny8JDfFOED7K0l4AyMG+9DOeou
	 69HVVuU/JaecA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7dNw-00GpQV-Gr;
	Mon, 27 Nov 2023 15:18:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm s2
Date: Mon, 27 Nov 2023 15:18:49 +0000
Message-Id: <170109831524.1259920.1722802295484487306.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231127111737.1897081-1-ryan.roberts@arm.com>
References: <20231127111737.1897081-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: anshuman.khandual@arm.com, oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org, suzuki.poulose@arm.com, james.morse@arm.com, yuzenghui@huawei.com, ryan.roberts@arm.com, ardb@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 27 Nov 2023 11:17:25 +0000, Ryan Roberts wrote:
> This adds support for FEAT_LPA2 to KVM for both hypervisor stage 1 (for the
> nvhe/protected modes) and the vm stage 2 translation tables (for all modes).
> FEAT_LPA2 enables 52 bit PAs and VAs for 4KB and 16KB granules (note this is
> already supported for 64KB granules via the FEAT_LPA and FEAT_LVA extensions).
> The series does not include support for FEAT_LPA2 in the kernel stage 1. This
> support is provided separately by Ard Biesheuvel's series at [6]. The two series
> are independent.
> 
> [...]

Applied to next, thanks!

[01/12] arm64/mm: Modify range-based tlbi to decrement scale
        commit: e2768b798a197318736f00c506633cb78ff77012
[02/12] arm64/mm: Add lpa2_is_enabled() kvm_lpa2_is_enabled() stubs
        commit: 936a4ec28141fa9369b6af4d6401f0be9f7e304c
[03/12] arm64/mm: Update tlb invalidation routines for FEAT_LPA2
        commit: c910f2b65518538b5072cb51760c8ef749e455d0
[04/12] arm64/mm: Add FEAT_LPA2 specific ID_AA64MMFR0.TGRAN[2]
        commit: e477c8c483913de92c9cc00b34459dc4d695529b
[05/12] arm64: Add ARM64_HAS_LPA2 CPU capability
        commit: b1366d21daaebb8e474e4169c5e557fbb37bfdc0
[06/12] KVM: arm64: Add new (V)TCR_EL2 field definitions for FEAT_LPA2
        commit: d4fbbb26da520e00d87c8187dc3de9eacee66c1c
[07/12] KVM: arm64: Use LPA2 page-tables for stage2 and hyp stage1
        commit: bd412e2a310cbc43b424198b0065086b0f462625
[08/12] KVM: arm64: Convert translation level parameter to s8
        commit: 419edf48d79f6fb2cc3fa090131864e95b321d41
[09/12] KVM: arm64: Support up to 5 levels of translation in kvm_pgtable
        commit: 0abc1b11a032199bb134fd25cd7ee0cdb26b7b03
[10/12] KVM: arm64: Allow guests with >48-bit IPA size on FEAT_LPA2 systems
        commit: d782ac5b2ceebee5d374e13e990655d1a140d3a6
[11/12] KVM: selftests: arm64: Determine max ipa size per-page size
        commit: 72324ac52ddddb168d8008e36d6a617b9b74f6c1
[12/12] KVM: selftests: arm64: Support P52V48 4K and 16K guest_modes
        commit: 10a0cc3b688fcf753ff3f6518bb15e7a6809e908

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


