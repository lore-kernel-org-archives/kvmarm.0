Received: from out-197.mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB323B7B0
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 20:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aXsjxWP8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697144073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j8joI2FU7W3rzo87zRemNZDf7BE+155GgP5KVsnPNxg=;
	b=aXsjxWP8U/V6ZvSQscjtcnXuR5RseopbAzmt1mWVVQduuvKUoigWENFKarAtkCHAJzqVAt
	Wn8txwL2N8cTvEyFOFAtCVAkFiC+uOLbgq/uWI/82H+/77/u1wvnOJVr+qtm5U2yyr82Oq
	cHJUg/swJcbsPAxT96M3TWtBlBKvFJg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 1/5] KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
Date: Thu, 12 Oct 2023 20:54:18 +0000
Message-ID: <20231012205422.3924618-2-oliver.upton@linux.dev>
In-Reply-To: <20231012205422.3924618-1-oliver.upton@linux.dev>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

HCR_EL2.TGE=0 is sufficient to disable stage-2 translation, so there's
no need to explicitly zero VTTBR_EL2.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/tlb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 46bd43f61d76..f3f2e142e4f4 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -66,7 +66,6 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 	 * We're done with the TLB operation, let's restore the host's
 	 * view of HCR_EL2.
 	 */
-	write_sysreg(0, vttbr_el2);
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 	isb();
 
-- 
2.42.0.655.g421f12c284-goog

