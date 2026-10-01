Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D05219F121;
	Thu,  1 Oct 2026 16:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790873270; cv=none; b=XiAmrLkrd697ya2K7eZYWVR/tu6U5fHuXlZhosbTH2piUwAk5f3eMs8eF99zzXyLSnM89GDUiA5R14yO6iXAyhxd/0d+LOqmicXTz8bg54Z2D8KD7K/mnFW2sO9wIOedT8sGFARV78fOToYBu8VLmBRWk6oFSoRxaSWJskawkcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790873270; c=relaxed/simple;
	bh=RS3ym9NUZs4LBrdTIp9JEbZ0YFQ05k3OWWdnIjIsjCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1rPrbxt3P9ORvB76aTsFlvSoXI6/mPVw3dOVHTJX5h3fK+iG20Bq74Tg+lqHB3eNyGwUTjY4zoXGPMoa6toHb+ibGepVV3+8jTZA6MHXTUeevdxzKQ6COiVC8zgw1W66xpgsLxy6uFtmVqayLb5roBz8HaXANa3BYn2e6iiR3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSGfvBUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSGfvBUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41241F000FF;
	Thu,  1 Oct 2026 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790873269;
	bh=xTsRBC1y30K49/WiHZ0twj0lmBMnb1uUeNXQH4IyQ18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lSGfvBUpgdrGNChtVsUti2z/cJcWjmoIJaYKfDBTqEFGR1ecsC3FK8Kst+5KikLqe
	 YVs765eRpJpOX6eg0K69hwYIwCfDgBOotsgdGvqj5f6Uwm5N2YSKyae0638FTAjRaS
	 iEtZi6KQwOBjB0iYeMQ+feYhzggZ4LiSqmSO+Ql3LUx/gszCP0R4EV5yam3F6CtAKF
	 /dOXxDXpu5O9twUlx2dnna7zohQnus22P+7PjWjoWzgoGFii3jIPBcJTFs6Y7SEv8v
	 1XAzr6CMURZwgk0ITWStl0WIeU6EoVF3Xi2GnovBbwj0QcuPT6oqwtiOFRUeBKI9o3
	 OyTthtDyjF5pA==
Date: Thu, 1 Oct 2026 17:47:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 14/15] tools: Synchronise the kernel esr.h
Message-ID: <ar6NXWzQ1rMb1aId@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-14-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-14-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:24PM +0100, Mark Brown wrote:
> To pick up definitions for GCS.
>
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

This seems to be out of date, with your series applied to next:

$ diff -u arch/arm64/include/asm/esr.h tools/arch/arm64/include/asm/esr.h
--- arch/arm64/include/asm/esr.h	2026-10-01 17:43:56.186852562 +0100
+++ tools/arch/arm64/include/asm/esr.h	2026-10-01 17:43:56.194056154 +0100
@@ -7,7 +7,6 @@
 #ifndef __ASM_ESR_H
 #define __ASM_ESR_H

-#include <asm/memory.h>
 #include <asm/sysreg.h>

 #define ESR_ELx_EC_UNKNOWN	UL(0x00)
@@ -131,7 +130,7 @@
  * Annoyingly, the negative levels for Address size faults aren't laid out
  * contiguously (or in the desired order)
  */
-#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) == -1 ? 0x29 : 0x2C)
+#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) == -1 ? 0x25 : 0x2C)
 #define ESR_ELx_FSC_ADDRSZ_L(n)		((n) < 0 ? ESR_ELx_FSC_ADDRSZ_nL(n) : \
 						   (ESR_ELx_FSC_ADDRSZ + (n)))

@@ -437,35 +436,6 @@
 #ifndef __ASSEMBLER__
 #include <asm/types.h>

-static __always_inline bool esr_trap_is_iabt(unsigned long esr)
-{
-	return ESR_ELx_EC(esr) == ESR_ELx_EC_IABT_LOW;
-}
-
-/* Always check for S1PTW *before* using this. */
-static __always_inline bool esr_dabt_is_write(unsigned long esr)
-{
-	return esr & ESR_ELx_WNR;
-}
-
-static __always_inline bool esr_dabt_is_cm(unsigned long esr)
-{
-	return esr & ESR_ELx_CM;
-}
-
-static __always_inline bool esr_abt_is_sea(unsigned long esr)
-{
-	switch (esr & ESR_ELx_FSC) {
-	case ESR_ELx_FSC_EXTABT:
-	case ESR_ELx_FSC_SEA_TTW(-1) ... ESR_ELx_FSC_SEA_TTW(3):
-	case ESR_ELx_FSC_SECC:
-	case ESR_ELx_FSC_SECC_TTW(-1) ... ESR_ELx_FSC_SECC_TTW(3):
-		return true;
-	default:
-		return false;
-	}
-}
-
 static inline unsigned long esr_brk_comment(unsigned long esr)
 {
 	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;

--
Cheers, Lorenzo
