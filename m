Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5A44766B9
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 13:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787147731; cv=none; b=X38RKGfO0l+MIFVj6g51r0adRzjD4EXjtM3eym52cng7+2Y/qY8AZ7ftLuf2Rr29N4ngQleRBhtsyfyQalezdFomM6dItPSm7tkM8wf4ZJVGZoonBJ/yMKFeP9Vc12QeFAC+LGTcX6jd7Nke7ee9evhbcgPrYyDUkVLVD+87kqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787147731; c=relaxed/simple;
	bh=UuEKHUn7xr7WabqbuM3/XgJTz2Viqf/N0nxnnC3djV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=jf9JHUcWLTAXRbU5gBAcSNNJYtgAVvHZEiup5v2u2Duggybhg3XSHRLzQJFAkoKCe+KgVeIdHv8c2IDdHCL9/9uQiQ18lr4qjY9qDNeRq9dXj+UDsiHAjofe5yFh6vHev/JG2s4ic4AkrHr6zQTY28Bw+xiDthyjLWzvUJWo0BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WEii9Sm6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WEii9Sm6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19A4F14BF;
	Wed, 19 Aug 2026 06:55:24 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFD673F763;
	Wed, 19 Aug 2026 06:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787147727; bh=UuEKHUn7xr7WabqbuM3/XgJTz2Viqf/N0nxnnC3djV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEii9Sm6ptsXldQBo3H7icR9c5y/Ww/U0WGgnltI09o1uRCn/3MaKwh+KBr83JDBe
	 4xl5gYp+vubiL6q55Aaaajcsk/pGksWdp5Ca73IFFbI8/akhxPDnD8EbX9g+JhHfPu
	 u+/pVIcUI2guZhZCGmbS1oDlEgMHk9q09jsSuMR4=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 02/14] KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP
Date: Wed, 19 Aug 2026 14:55:23 +0100
Message-ID: <aoW1ywZGCvJaYQqN@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812-arm64-gcs-v19-2-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org> <20260812-arm64-gcs-v19-2-9105afd828ac@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Aug 12, 2026 at 08:12:01PM +0100, Mark Brown wrote:
> The encoding to trap mapping currently maps a FGT on OP_GCSPOPX to
> HFGITR_EL2.nGCSEPP but as per DDI0601 2026-06 this FGT controls trapping
> of GCSPUSHX and GCSPOPCX, and not the separate GCSPOPX instruction.
> Update the mapping to reflect the architecture.

That information seems to match the one in Arm ARM version M.c.
nGCSEPP, bit [59]
	When FEAT_GCS is implemented:
	Trap execution of any of the following AArch64 instructions at EL1 to EL2:
		• GCSPUSHX.
		• GCSPOPCX.

It looks like GCSPOPX can fault if the record is not a valid entry, but 
there seems to be no trap register bit for that.

Thanks!
Leo, 


> 
> Fixes: 863ac38984a82 ("KVM: arm64: Add missing HFGITR_EL2 FGT entries to nested virt")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 3c82f392845d..b32742d9dd73 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -1432,7 +1432,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
>  	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
>  	SR_FGT(OP_COSP_RCTX, 		HFGITR, COSPRCTX, 1),
>  	SR_FGT(OP_GCSPUSHX, 		HFGITR, nGCSEPP, 0),
> -	SR_FGT(OP_GCSPOPX, 		HFGITR, nGCSEPP, 0),
> +	SR_FGT(OP_GCSPOPCX, 		HFGITR, nGCSEPP, 0),
>  	SR_FGT(OP_GCSPUSHM, 		HFGITR, nGCSPUSHM_EL1, 0),
>  	SR_FGT(OP_BRB_IALL, 		HFGITR, nBRBIALL, 0),
>  	SR_FGT(OP_BRB_INJ, 		HFGITR, nBRBINJ, 0),
> 
> -- 
> 2.47.3
> 
