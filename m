Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAE13A6F0B
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 10:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988751; cv=none; b=dhbpGiUhaZaF1hVKvbyPd7m82/QTVVQY11WsuBAQzI96SbI0MNSb6kmkUF1xrCHJ7l5DFcdjc9oW3dBIYZfJyeROv+TlSgHX8QkvmYAQwve0uE7uLVHMi54WQzQItYuoxn4RdjryrnwVQelhL4Te22H1pD98l8JYEZ3pVcvcG5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988751; c=relaxed/simple;
	bh=idCz1yZ2loil4GmAl0CYJHHspFZFLVjff200Ae6fHNk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fJk1hNN8fHawAA4VVMhfLftE/csPdM8JhrReXJ6PJgkq+/zST0kTQL/3u0GiNrWSMh/GaSZoVu2SRhEu8iD8J6LQaSY7qAdR2Aoo8WxptW8w+QuOjulH6y68YcuWZUTS13W1flCKUgvd3w62dxWrM7iSMgI8qKCH4tmwozfRFoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=REjXrhCt; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="REjXrhCt"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-698ac7678f1so717641a12.3
        for <kvmarm@lists.linux.dev>; Thu, 02 Jul 2026 03:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782988749; x=1783593549; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b5pW2X8dLODkLCHijpyvtLxcjR3119nmpK6U2x+j3Ok=;
        b=REjXrhCt8JWKw3yVC0SNZ4NUndlP6118NNJ8j+PQeevsohQsT1WL1hZmFQuxVENYIz
         wb+NQBLtPBWwk1gVtqIRW/18yxo3j+lCmsMQf0CafdK/3NFV/zhK19vVWsT6NHpGP54n
         ynuEswO2CKata7Bu2LlCRkgXMaSVZi6trC385GVLKj0UjI+54yHNh1xdy9bp7CvI0qhB
         pPgnTzFqX/nzE6wcx6uHKVB1j4BpUwtRBTWLqQRPHgqvgt+TLNGty4r8Y1fBUa+ms+gv
         d4+3PrtiV3wnkjXZFHp53MWfUfcGef/oNg/DpRzn2VWrXgPlmwN5Xd2o0JEQi7z6pyfh
         kJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782988749; x=1783593549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b5pW2X8dLODkLCHijpyvtLxcjR3119nmpK6U2x+j3Ok=;
        b=dg1uM7aSEM7vzH2OTPRNavU4+eoCpbDLI8GYjd1ZsiS4f00UciD392EGfuWDW/l7lq
         Z8IKVvKmVAfLsdx5XlzWDT/4YUKKrsDxUxYLyKbJ3PlY6+BGlgNlzZ4Ob7K2zmai7Ddw
         LkPCJprXF0Pd6OoL3Ia2aI5x3+U0AUtihYivBcVSondEdIfAqgU0YawVmCwx0PVfuOQt
         azah99NBqkCwcrjbF7voMNQYW073nSabc1POWZAlA/z4eorRzy3DD8ihX8vYBoiOhsdO
         kze2qJu7W8WQOCi24zQ0MxJ0B/NZxEZaFc3BvDSJH5eKfEMxLytWEcPHYGDc14bKX/br
         ytrA==
X-Forwarded-Encrypted: i=1; AHgh+Rpg6skh6F7thbcXfQpieiDQxJtGBT5WCLvDYentBs70JhbEvAWF2aFwrz/5IJHs5g2o1eY4GGE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFBlCkss1n3jd8LFlS0Ldsgf2l+5XqzQsOu+SA1itcmU+p/pOy
	prZ3BxheT7sohxXwwmK1iEEG37xASgpXGf0wcLduuSXXlsQ64Mc9gm4eywnPzPPd36PLzTp8ZsA
	1m1ztfWhptkTB+7qj/I+Ab+lsN+YgYg==
X-Received: from ejbec17.prod.google.com ([2002:a17:906:b6d1:b0:c06:bd7:70c6])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:f112:b0:c12:951b:7f1c with SMTP id a640c23a62f3a-c12a9d7a733mr196967366b.21.1782988748201;
 Thu, 02 Jul 2026 03:39:08 -0700 (PDT)
Date: Thu,  2 Jul 2026 10:38:40 +0000
In-Reply-To: <20260702103848.1647249-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702103848.1647249-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260702103848.1647249-4-sebastianene@google.com>
Subject: [PATCH v9 3/6] KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org, 
	will@kernel.org
Cc: jens.wiklander@linaro.org, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, maz@kernel.org, mrigendra.chaubey@gmail.com, 
	op-tee@lists.trustedfirmware.org, perlarsen@google.com, 
	sebastianene@google.com, seiden@linux.ibm.com, smostafa@google.com, 
	sumit.garg@kernel.org, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

From: Mostafa Saleh <smostafa@google.com>

Sashiko (locally) reports out of bound write possiblity if SPMD
returns an invalid data.

While SPMD is considered trusted, pKVM does some basic checks,
for offset to be less than or equal len.

However, that is incorrect as even if the offset is smaller than
len pKVM can still access out of bound memory in the next
ffa_host_unshare_ranges().

Split this check into 2:
1- Check that the fixed portion of the descriptor fits.
2- After getting reg, check the variable array size addr_range_cnt
   fits.

Also, drop the WARN_ONs as that will panic the kernel and in the
next checks there are no WARNs, so that makes it consistent.

Fixes: 0a9f15fd5674 ("KVM: arm64: pkvm: Add support for fragmented FF-A descriptors")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..41cc4c1bafeb 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -607,8 +607,8 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	 * check that we end up with something that doesn't look _completely_
 	 * bogus.
 	 */
-	if (WARN_ON(offset > len ||
-		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
+	if (offset + CONSTITUENTS_OFFSET(0) > len ||
+	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_ABORTED;
 		ffa_rx_release(res);
 		goto out_unlock;
@@ -636,11 +636,16 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 		ffa_rx_release(res);
 	}
 
+	reg = (void *)buf + offset;
+	if (offset + CONSTITUENTS_OFFSET(reg->addr_range_cnt) > len) {
+		ret = FFA_RET_ABORTED;
+		goto out_unlock;
+	}
+
 	ffa_mem_reclaim(res, handle_lo, handle_hi, flags);
 	if (res->a0 != FFA_SUCCESS)
 		goto out_unlock;
 
-	reg = (void *)buf + offset;
 	/* If the SPMD was happy, then we should be too. */
 	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
 					reg->addr_range_cnt));
-- 
2.55.0.rc0.799.gd6f94ed593-goog

