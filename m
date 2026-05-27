Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E108428462
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779894170; cv=none; b=uFqOagvYyNxWiiPnLVez2vvSPDMYuD9D8NTCZopWLfiIiA6OwgLjjpvhncBWDEeybB2Rp6n/g4YsVnWUWgySgo1EfKGSQc0tWxrbGO4wIoRQ7LaGoSAWwN9HoECpj1+kjlu6Ix6RIzzcLmkGs7Stu+NYhxuwkXmrYC4XnJQqLsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779894170; c=relaxed/simple;
	bh=15nq+W4QtQnuAmCVcxh2XcM8fl+7JmCCyFIX1NGjd4w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T4Zl6L0eIHgc/YG02kr03i0lfJfHRiaikJa6QiPIWQeCrAbp6H2rpf9upvXdUQ6kDiZC7DoXsMeF3fs+IX5juHAIphPNnxink0VOyv0gA93d14vBDLxUNubZ3A/xnjwxkcgIbVz/du6jklAoFqWb5vraSOjIaVWLoryE0xZtbK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HUhBVxdo; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HUhBVxdo"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fdad6cce4so59317435e9.1
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779894165; x=1780498965; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKy2nPJ+cV4SO6crenI0U9khbA/AjfYfGtFJYOFvACc=;
        b=HUhBVxdo9Vmc5yYFRJu9mIjNSS+ENcYx7BAn/sCNuidW6ZGMnGKypqcXHq/WpG7dTM
         y8+gtz4v5DDw2auA1gfFx2fgTHAp/ib2UPTqE71IW2dtZodOgTkefVviO1Niv6+1OtMO
         6WzewMyHOnH7hrZkbb08fP8e1yC9ufjIDcZgfgR88DZhW73Ceh4kA3pBSEwsPU2FzeKW
         rBgnm+cHwatRgrHzm2OG9tEcD2Q+lNYvffTaaQB58qS5jA8AZngRFcjagGUYawoED23U
         QyoBd9PGDFITa3MdP+Uc1SEClDuiy55nJHxLleOIXaL781d80u8w0DJIt1H6G/3Q5Lox
         4H8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779894165; x=1780498965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKy2nPJ+cV4SO6crenI0U9khbA/AjfYfGtFJYOFvACc=;
        b=EBFZkdJXSkMz2jJzxl4jQHgm6M8Y/hU/uBzQ9a2BKeX+tUj4w/yzjn4TN8DxGSUxRw
         yQREbg5k+Bvv4Ep7CI/2UCsNQKy272CIy348H57GgiZbPmNzEbuKckK683aIpWv9p1ls
         rMUsscRmowhvGmgT5ZH2GBw4tziSxa66a43ftFudtIDX6bclwc0XVVj4GbxNqGVd8NiR
         2xgisB7rc9R8/0DTVpHu/0yZaj3GGnVx+wyZFc4k04ov/hfOqTRPu0jOAOthZvenBwHQ
         YrriAnbPqWZLTwghEbvAzMgaoudCANu7dsPnHpTd8//1gJDr3NHHF4QYm7GfkqUtuNo7
         D12g==
X-Forwarded-Encrypted: i=1; AFNElJ/UceVnNFqIsSilpYSCHBIyQOKF63SO8ubzv9dGtPrETSMcCtKO8M/JNg43Y2sqJ/MAMHqTttg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyfw43NIShIi1UUYcV6g3myn4+CLLo7LcbDjhq8bqz/wc/rDTtm
	fbd3C22u02tY240Zy9zP9r9H2UHBwjmwqs+SZkAuMvpjgvER9+aL5baMpeyzEFE0FE/dkRTuR5c
	TgfOKYBv+486COQ==
X-Received: from wmon5.prod.google.com ([2002:a05:600c:4645:b0:489:1b1b:132])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:2a8b:b0:489:1abb:5559 with SMTP id 5b1f17b1804b1-4904226d9camr214273595e9.5.1779894165174;
 Wed, 27 May 2026 08:02:45 -0700 (PDT)
Date: Wed, 27 May 2026 15:02:34 +0000
In-Reply-To: <20260527150236.1978655-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260527150236.1978655-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260527150236.1978655-5-smostafa@google.com>
Subject: [PATCH v6 4/6] KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
From: Mostafa Saleh <smostafa@google.com>
To: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, jens.wiklander@linaro.org, 
	sumit.garg@kernel.org, sebastianene@google.com, vdonnefort@google.com, 
	sudeep.holla@kernel.org, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

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
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..b6cf9ad82e12 100644
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
@@ -641,6 +641,11 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 		goto out_unlock;
 
 	reg = (void *)buf + offset;
+	if (offset + CONSTITUENTS_OFFSET(reg->addr_range_cnt) > len) {
+		ret = FFA_RET_ABORTED;
+		goto out_unlock;
+	}
+
 	/* If the SPMD was happy, then we should be too. */
 	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
 					reg->addr_range_cnt));
-- 
2.54.0.746.g67dd491aae-goog

