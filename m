Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A1F2DF132
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 17:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772040948; cv=none; b=Bu3t7RcS7GSAPSU1gqIsHrjrir6sfYdRL+geKi260wsvw/LBpOQcF0XSkTIVjC+C+5HHsAmZxxuLBP4kSanOZRWHZ93DJlhm2aTZWFJzcRGCX8JzWju+5XFQCnjmON45FVB2JvO9uJGCqaLipgd4tVyCHUXzqUIMujjDslvkNv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772040948; c=relaxed/simple;
	bh=bvcx7E8g3neaP3jTlAyhyOC6kC2U2jff1FTyBF31eF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgPprwMR93/RsIFYlfiuIj6TMCqJ5ut9aSz1TgKEYorvVkK+f7mWaZYZRaFmgWOJNoOVahxOJfSbjlzINJFZcc+CXTXNXqYtSbS52IIgYw38vN4huHB6xRjAHRANF5MthdPx6jJWQtMDuwxBLndcoWulDbQiWsVssfm4klQHlGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oEn1oSkM; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oEn1oSkM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772040945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DSffF/O9t9ktg+4g54ewwNPuwJZR6q/1l+pHWLBR93I=;
	b=oEn1oSkMK4RuJXHdFGMgfiPadC17TY8nw8bE2aLK1aTMjfCy8LXMVOEFiXhgu3YFPBODHn
	AjosEFX0U/g5K+uBquSHHYXhSQRt3VbCQDkWFif3tkvyt6KwdcEz95go+T1j+eVCQQSfTz
	8Oca5udxCKctBBbCp1RI/7QuodCQTuk=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH 2/3] KVM: arm64: nv: Report addrsz fault at level 0 with a bad VTTBR.BADDR
Date: Thu, 26 Feb 2026 01:35:14 +0800
Message-ID: <20260225173515.20490-3-zenghui.yu@linux.dev>
In-Reply-To: <20260225173515.20490-1-zenghui.yu@linux.dev>
References: <20260225173515.20490-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

As per R_BFHQH,

" When an Address size fault is generated, the reported fault code
  indicates one of the following:

  If the fault was generated due to the TTBR_ELx used in the translation
  having nonzero address bits above the OA size, then a fault at level 0. "

Fix the reported Address size fault level as being 0 if the base address is
wrongly programmed by L1.

Fixes: 61e30b9eef7f ("KVM: arm64: nv: Implement nested Stage-2 page table walk logic")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 arch/arm64/kvm/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 44ed3915b961..a957542ae3c2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -280,7 +280,8 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	base_addr = wi->baddr & GENMASK_ULL(47, base_lower_bound);
 
 	if (check_output_size(wi, base_addr)) {
-		out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
+		/* R_BFHQH */
+		out->esr = compute_fsc(0, ESR_ELx_FSC_ADDRSZ);
 		return 1;
 	}
 
-- 
2.53.0

