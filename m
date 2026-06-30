Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEEF3E9C06
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 10:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814888; cv=none; b=il77VBPYQjwDDoDT/wCyn3SG+IKkdpp0vgGZHEOQ7InmeO2pCg6itQeufNPqCorNKob7aZBVtjoDW1cXYSBSr3qg1LF18+YotE0sB/GUVPABz52sharnSTKuy2TjL2sWun+CNxr1rYevRsVc16xAyMoOTcmjKKm0+A10ouIJwyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814888; c=relaxed/simple;
	bh=0NmZSBhEKcrvtOD/18rEBe2QfhTmQd4sewt8I6RtBBM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S5xE57uBBfJa5DAjYR5+VyjxpTlm3tzDsqWbX7hEryjdWtD51M4yaYGFd3MLDGqEenf/S02rRVl0gysTTlqKOTr9V7+UqUFVAR9NpR/BM0Us2O7kRD3V8TPUExT+1DAMqKaarOST8TqKYstLRWQ9PaaWgwBNz4EIrACXsYNuvRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fy8V+qpo; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fy8V+qpo"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493b786d550so9923255e9.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 03:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782814885; x=1783419685; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KsJ5Z8DyAJvdmrOoxOJ7TrWR7XLa3prh+sP2FotAqRo=;
        b=fy8V+qpo6leDP9xYcThi0vUGQnTtmCOV316Z/Y+j1+UNKia8jWb+IDb0PsBCsah7Hq
         H0sNVCkyCUrJ0ZhQvqf60W7iB+ky66mYY5w8WgRsnSX4+lhXDwPPSXVgXKW525nW1Vj8
         PVhWpSUyTr3kH0m7MsuO+gw6dv9Icz2jj0XnWghy6SifF0SUbUdSEm1p7FwCOmdwtXiE
         2vLNQTbbUmw122pGqKhL79GsEuzN/5xcN1uZyr8KAMCjZJa+i2wdwtL7YybWCLjgSQBC
         FyiyUZNdlQF8Iux7TyLHzxinErfh5aG6QOFCOqCEQ9NU6wXw/nv/GyNDm6fisHUFF33l
         V1aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782814885; x=1783419685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KsJ5Z8DyAJvdmrOoxOJ7TrWR7XLa3prh+sP2FotAqRo=;
        b=mXXtPjy6b/vlt9OiK7iimzk8Dyal9UuQ/GXBYQX1qBqfgNAthRX0hfNLiT5cZa5soB
         wxCCdAdw2U6Rs/z4i8pRSTcHgVY183nuXwu5akUecb9QD3hKG6mO5nQyX0J9nbB+ixul
         OMnJrN4qT7cKWLgUCrt65EA+S4v8AUih1AQRkpCNvpkOW2KX7+a6C9K7PrX4Yk7HhqjP
         sgr2MqthU6LwvvYbcB37oyY+EvHcwouqzYWgzMYBlJM5iShtZ0oFXOgscY7deqQWgTNd
         sMSz1Fhotoikj+C1y7EDnStP1o+BFpGO5LSFU9rzKRqL7YeGBi0+ksW1C7K5q3GnnKMG
         CNBg==
X-Forwarded-Encrypted: i=1; AFNElJ8E6MYWMNpT9BFm/9gUgAKyMHSoerQVLC/VRMZe7575DuTm014Ihj8mXxgCPtBtYDJ65Hx2xlE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0xsOJwzmI2Mx83SJq3YvU38mmmg5UR7ErBvkk6UluUDJETFGX
	Nvi6UbPT+6GFr3F/uAJ0oMbrtT+qK+kDedYgC9vsYuOpnxNBOPwj3DGlVBiITljMoUvRDHJ6wrh
	baiWNQNGAfaSIhz6yVHZF1JUEYS0fOw==
X-Received: from wmcn17-n1.prod.google.com ([2002:a05:600c:c0d1:10b0:493:b636:4efb])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6218:b0:493:a7fd:15d6 with SMTP id 5b1f17b1804b1-493b8289c5fmr47379145e9.9.1782814885168;
 Tue, 30 Jun 2026 03:21:25 -0700 (PDT)
Date: Tue, 30 Jun 2026 10:20:56 +0000
In-Reply-To: <20260630102058.3219867-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260630102058.3219867-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260630102058.3219867-5-sebastianene@google.com>
Subject: [PATCH v8 3/6] KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
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
2.55.0.rc0.799.gd6f94ed593-goog

