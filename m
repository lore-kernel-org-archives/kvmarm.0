Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD824657C2
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707909; cv=none; b=njtXS1Rz1BPt05o64RnpvOod4EJtIOGApcFktRUq0xURF1d8cxJtnJjhB1+xwUWS0tarT0MIb4K0LEyCV1pQepgE5cva47Jpqj1Kh+trMj2y7Wc4NeX+xHZx3R2SZ7qqAvvVhexbH7RCTX2FaCyPRHMZcOzowPbMyB8dXjDH9yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707909; c=relaxed/simple;
	bh=RYLphXY3qZrHLwVyATq2rz6ULfSNbmNMCCt4D1nRClw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MoblsB1LdmG2L6kCOTrrPgzmJ4UdHmOGprXM3C+WRhuOzEIzDWEFqYhSnJDAHeHWLZKFmfis+XM5VPXJX/rkaqd1q4BoARdFuFgTuFSX5foPx2LkWqSmYYLqajhvtoVQGG5irTShTaH/6abjOFVLWpCz2jHCGSrmvIDTxwca8Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uhHGmdzJ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uhHGmdzJ"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490ae3bcf4cso29672585e9.3
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 07:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707907; x=1782312707; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CQFj/8TPJyuneEGc/c18D84EbHbY3hzTyS99LAP/4do=;
        b=uhHGmdzJa0yhHCVV8FdukVKX1MFL4oo2UXrUuGWdcXOAB8JE4uormcGkAaYnFHH4f0
         cyKRApqjWVS3LH0CC09PF10QtSHhxR7q2tEV3BN3lsPGaecdNSirF5Tf0sXkCswwmkry
         sgwPqC9RH9iVLl4+UCrIkyQzn0BS4bRr89N0G5ppoZkXmWuLaYN0O9+Tu7MdFzwX8rsr
         dsGaysqML7ILZHsQeC5SINydtFOgu/H7QU49SYcRqimrng9L1SPyFVJx0KTSelf64Lxa
         blpuf4dfrxlRlbpOywODPYHdVZFm89BnVTIRA8YF0O/Bhz2mOD0hgxwquIHc4DMRFirE
         lYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707907; x=1782312707;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CQFj/8TPJyuneEGc/c18D84EbHbY3hzTyS99LAP/4do=;
        b=JghkhxfBs7uoHN99rd/s2vLyN8k9z+aas+f4A5gwEsKkxV6pr+MPX7p82NbboctwCb
         iEwQ5TPCsmjEZyxvWUoMF62P28kUqG7ok3cOZeiNgA0n0sgF+aYtmwdmljd4ZhUgwqLd
         I+sXQTwY4z2U6A/adp/5CappDu+cKtWpHpb2yIYUN+AOGQFF7ezfi/qxsvwsxvQTltGK
         x8hyKNCLDuNJsDXsJwdjws8GtpH+ai0gd29ixPXt/xIqJgAA7XVJDZKkaJ0AmnLE5lMy
         BSymNNP1Iki69i9equAx5frVs/+a8N/0+sglYy0DAfQj88CGzuSAEtFqJGMhPuEoRl0k
         ioGA==
X-Forwarded-Encrypted: i=1; AFNElJ8KO7AYiR1pa+KvQHxrjJJmZG1HTFtfZLVzgfuc+2bzJ/M9C1u/pnFFR7nfET2yZsVsgUjL1aw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQY+sQsk3qSgHnwdX4IaGeuy8T/OaQ/ldSk0agqzLx9oYRL8Rg
	9xyb3QWsGDxcznetHABZQYaD1LJBMlc/sM4g3wFp9Esduut0eLF9cTLY6Wpj64RafN8LuYCd3go
	L5uyxZDdjIsTnRTkhbrKYV8wyEO4hbw==
X-Received: from wmbju24.prod.google.com ([2002:a05:600c:56d8:b0:490:b18a:b4e2])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:828e:b0:492:2e7a:9ba7 with SMTP id 5b1f17b1804b1-4923339fca0mr74090555e9.3.1781707906450;
 Wed, 17 Jun 2026 07:51:46 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:51:27 +0000
In-Reply-To: <20260617145130.3729015-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260617145130.3729015-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617145130.3729015-5-sebastianene@google.com>
Subject: [PATCH v7 4/7] KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
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
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..2d211661952e 100644
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
@@ -636,11 +636,17 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 		ffa_rx_release(res);
 	}
 
+	reg = (void *)buf + offset;
+	if (offset + CONSTITUENTS_OFFSET(reg->addr_range_cnt) > len) {
+		ret = FFA_RET_ABORTED;
+		ffa_rx_release(res);
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
2.54.0.1136.gdb2ca164c4-goog

