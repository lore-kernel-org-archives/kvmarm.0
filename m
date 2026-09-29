Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2E151C055
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 14:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790693661; cv=none; b=N1fZlXpB1yDMFpwdUyjVlQ5yzzSzesAkePfkh3ke3R3Vyusq3oW+LAh3WuRQrvQdLs49R/NcRhP304TbEV3X627f+KOHqLr9BcrgrFdzuaA7RCeWbWlLzYYDzR++nLz45wDNiny1O+NXhmCNF7XTNVOZHodaiK3i1Cq5VAQ/VPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790693661; c=relaxed/simple;
	bh=esoyENbZ44GNKmeZsIgGCCMJABdw5rCYrI7Eyyadykg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UlM+6qW7ecUlhosXSbpp92gCYWbzd7aYP1KsSiPzy2RA56d43cyMammIiNdeFb8g1LPL5wp7eRXMLgHs/rGrvCSlh+XhsOF30518F/7hnAuIwBtyCH2o3F1XMiTm9TTOsXIU9V3dQTDQFsSlQCQvFvawxpUVrMnD+cKVIOJlL8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=usQQfmYl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="usQQfmYl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AFA61516;
	Tue, 29 Sep 2026 07:54:16 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E16CE3F86F;
	Tue, 29 Sep 2026 07:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790693659; bh=esoyENbZ44GNKmeZsIgGCCMJABdw5rCYrI7Eyyadykg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=usQQfmYlajLnTt3wS3Cpwl1JJlsmTCBvkV00hc0gHLiKtTq9D21EFhHZpHrol63Sw
	 ezI/oqCtiJZ8fufONKeFniRYVyI4Ec4TQisPUmWTJIa8uZ0Wo5croexuMueCHlBgA8
	 inet1daapOv/NeaB2yMOTurFhSXlLm+d5NL/+PXE=
Date: Tue, 29 Sep 2026 15:54:05 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>, Fuad Tabba <tabba@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: arm64: Apply the fine-grained UNDEFs without
 FEAT_FGT
Message-ID: <lfkiqqw72uqjih442pozc3gsydxwmdj3kacgl7c2572kxzx3sf@vivqilohtwqn>
References: <20260929090031.3829185-1-fuad.tabba@linux.dev>
 <20260929090031.3829185-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929090031.3829185-2-fuad.tabba@linux.dev>

On Tue, Sep 29, 2026 at 10:00:28AM +0100, Fuad Tabba wrote:
> triage_sysreg_trap() applies the FGU bits through the encoding's FGT
> entry in the trap xarray, and populate_nv_trap_config() only adds those
> entries on a CPU with FEAT_FGT. Without it, a hidden feature that still
> traps reaches its handler instead: a TLBI OS trapped through
> HCR_EL2.TTLBOS lands in handle_tlbi_el1(), which expects an EL1 TLBI
> only from vEL2 and WARNs before the guest gets its UNDEF. A VMM can
> trigger the WARN by hiding TLBI OS and having the guest execute one.
> 
> kvm_calculate_traps() computes the FGU bits with or without FEAT_FGT,
> and the entries map an encoding to its FGT bit whatever the CPU
> implements. Add them unconditionally, so that a hidden feature that
> traps is UNDEFINED on any CPU.

This reads a bit mechanical to me, can I suggest:

```
FGUs don't actually require hardware support, so don't gate fgt trap
config insertion on FGT. This is the only action required to allow FGUs
always, as kvm_calculate_traps() already computes the FGU bits with or
without FEAT_FGT.

This also fixes a spurious WARN when a TLBI OS is run on a guest in vEL1
without FEAT_TLBIOS on non FEAT_FGT hardware. In this configuration the
course-grained HCR_EL2.TTLBOS trap reaches the handler handle_tlbi_el1(),
which expects an EL1 TLBI only from vEL2. With FGUs enabled the UNDEF
will be injected without needing the specific handler.
```

Other than that, this is very nice! Sorry for missing this. It's way
better to have FGU regardless of FGT and handle unexposed TLBIOS with
FGU always. Thanks Oliver for suggesting this instead, and thanks Fuad
for digging in.

Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>

Thanks,
Wei-Lin Chang

> 
> Fixes: f5a5a406b4b8b ("KVM: arm64: Propagate and handle Fine-Grained UNDEF bits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

> ---
> 
> Notes:
>     For a nested guest on a CPU without FGT, check_fgt_bit() now runs too,
>     but it forwards nothing: a guest without FEAT_FGT has its FGT registers
>     RES0.
>     
>     f5a5a406b4b8b added the FGU check to triage_sysreg_trap() behind an
>     ARM64_HAS_FGT gate that populate_nv_trap_config() already had, so the
>     check never fired without FGT.
> 
>  arch/arm64/kvm/emulate-nested.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 625604019fb32..b8529532b6e78 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2386,9 +2386,6 @@ int __init populate_nv_trap_config(void)
>  				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
>  			}
>  
> -			if (!cpus_have_final_cap(ARM64_HAS_FGT))
> -				continue;
> -
>  			prev = xa_store(&sr_forward_xa, enc,
>  					xa_mk_value(tc.val), GFP_KERNEL);
>  
> -- 
> 2.39.5
> 
