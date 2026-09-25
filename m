Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574C749B1FA;
	Fri, 25 Sep 2026 10:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790332952; cv=none; b=NWmC/mVhw8W/HwaVqSzjkMdl8mXE6+TlZZQGa+WF6yU1gjRYhtcAto3ARzisWKGMKAUCLpysBJzX/kDCg7brkuRvOtI37D31nLysAjSqP+OgcSipVWUPdBQu7oP/gsVBHk6xKmrwrrtN6h5AlFfHht+VNIzFV1fahxB6Ua24QDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790332952; c=relaxed/simple;
	bh=UUyhn4ypefH8nO4Rrn4P6xc3nFeWoLuAA1eQpSu4Akc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OY8XXArMjumTs4z/82QrQ/Gd1HGEwE6u1WSTDtiRmQ0MpyAuXvPr7GlGfWbhC2jRKDa1HEmekKsTjaEuG3yw+uAp3yMy0ImS9Cl4AvJ1L18FpXbcgM8vcf22AA7tcXChBdTBN3Ae14CrMgNmyF1mHUX6+bAeUYyHWbpnajN7jMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YDM+yiyK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YDM+yiyK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5592A169C;
	Fri, 25 Sep 2026 03:42:20 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 768373F86F;
	Fri, 25 Sep 2026 03:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790332943; bh=UUyhn4ypefH8nO4Rrn4P6xc3nFeWoLuAA1eQpSu4Akc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YDM+yiyKthxFhTKEmv9i+I4SBvhmEM/1ix0t1Zi4BCJYjZJ4kcAmvy299BLpzlw3y
	 cT6K+p2MVhx1f4Q9XiRhkD/OVCLxnl59uvS2/1JEPvzvgn9q/QBtQqw3QYM9pQeWcg
	 VoHtTvnvMrACrhnlvDU4LlnhgXJ3vauae0k3g6DE=
Date: Fri, 25 Sep 2026 11:42:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v19 2/7] firmware: arm_rmm: Check for RMI support at init
Message-ID: <arZQCiF3iqp9eCsy@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-3-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924135201.850038-3-suzuki.poulose@arm.com>

On Thu, Sep 24, 2026 at 02:51:56PM +0100, Suzuki K Poulose wrote:
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 32102c3912fa7..e8b29983b0021 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -293,6 +293,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
>  static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV3_SHIFT, 4, 0),
>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV2_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RME_SHIFT, 4, 0),

I think we end up exposing this to (any) guest unless we mask it out in
sanitise_id_aa64dfr0_el1(). Do the guests care about the RME version? I
don't think they should, especially the non-realm ones. For nested it's
masked away already (limit_nv_id_reg()).

-- 
Catalin
