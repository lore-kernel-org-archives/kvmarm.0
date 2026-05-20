Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7C1376A12
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 20:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310200; cv=none; b=P5ROdED9Sxf7tNglv8SgapM8XWn92lxMUTV6M98OkbNYDsGE3/yL03K/eC1fD8qxoavrSnh0ao5Ki3UDMIai1adpPUnAYbLsv/3Q7cXs0GMh74GAMOsTWpctnlwTxePwuQQEqtm2dp5b7FTfmY7IGanhqXqASKZS+9dfyn0od1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310200; c=relaxed/simple;
	bh=yDqwfpq2LumKo+eR1zTPgnIkRGiNvFK7fJiI/Swmg4c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gcnjGYZIV61+45fgDANnCM2f1tmVNVNBPt+e5mVvmSqY//iDNPDjHBSEGKfxw593QWi1bm3aKQdoHMbeqJitfewBiVM/9/sgBi6hNd/QpBgOZZDi/QH1xAYiAx0G6Cy8FbOWcThl8ZUneqJF3fIIP6q8Rj2PXerzvFhSu3vnfQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CQuDzpxR; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CQuDzpxR"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fd3dbd16aso44279015e9.0
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 13:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779310198; x=1779914998; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J5sFw8Sj0s1wSBlDG0qQA5R+qSlafViNaiQqa98n5zM=;
        b=CQuDzpxRxbwlKD2xWbkuOHTUul9tKtWCQqDi2YD2hN6oDwdDYDoDjAff8QFZSAn9k/
         020ivyML5ve5dlXm1eetuUmsbUBQ5LaON8NXZDyh6M14nlLueri9akmvPqTlDH6NbHzi
         NBkj0CrvXVCbQgGAeB/vHdYXBw8ij4HKeWsKXq/Nl3xlX25/Te8hIaLF6gRhWjkj08Mi
         fCU1NMkv9RTopXVQ6r/aduUe82l3yhqIHgz98rH4IzappLCJUBpzIATU9sSqDPe+z7TZ
         6Q/zMdyVYcKFiwvrL3AXro0S2/EsZOUvoIK4ga05zHWgMZwFJlWOiyK3DqPnwjIOysWi
         g6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310198; x=1779914998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J5sFw8Sj0s1wSBlDG0qQA5R+qSlafViNaiQqa98n5zM=;
        b=oEiDWWkKx+Y54GypCouEG5mPLhyCqsKTbEA15qpr6t7xrocIMDT/TncRcb89PRwh0P
         VHXJfEvPg2YOILRHFHYuMmbtpBV7Owc3J2rx6C6kb3EQVdcA8pHwoEgYUc58+oDuVn7P
         aHT0LF9yu6gSwtPrBz33FTJHq+gjqD+dkoYLGSZD9mjU5ET58EeBlryaNn3iWsRR4Oon
         fLkSh4UAJwgGgX94AT+fbISEyoViqHZtkcTHsBmApNX7sip5G2wHbfsUDuEnxcSCJdfU
         p7B30UJ16kBQf4MQeomvE71MyMfq6tEfAv4X2u3K7VKYrBJBOibCNeGLDnbmO08UNieM
         7tqA==
X-Forwarded-Encrypted: i=1; AFNElJ+CA42uzXzhp/ujBn9czhQK2wPYHPLVIlOwTzLopLtfeoxjw6c0ktrVKA63y7GkKEzM+qw7Z9k=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPt9FEGEnNkC7QUFCs4qTVnX71Xi5e/3VsTglKyBJXRcXI2lvs
	sMO5p38tyrh5PabHzIx8RD5blO052itTJs9tXNKr00vkkVNinbgJ7Zn2Ae8NHO311p2fw3Jm0d2
	T04oFQwTzMh5OhA==
X-Received: from wmlf11.prod.google.com ([2002:a7b:c8cb:0:b0:488:c011:ff58])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8189:b0:48e:89f9:9408 with SMTP id 5b1f17b1804b1-48fe632374fmr370978765e9.20.1779310197436;
 Wed, 20 May 2026 13:49:57 -0700 (PDT)
Date: Wed, 20 May 2026 20:49:47 +0000
In-Reply-To: <20260520204948.2440882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520204948.2440882-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.669.g59709faab0-goog
Message-ID: <20260520204948.2440882-5-smostafa@google.com>
Subject: [PATCH v4 4/5] KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
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

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..e6aa2bfa63b1 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -607,7 +607,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	 * check that we end up with something that doesn't look _completely_
 	 * bogus.
 	 */
-	if (WARN_ON(offset > len ||
+	if (WARN_ON(offset + CONSTITUENTS_OFFSET(0) > len ||
 		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
 		ret = FFA_RET_ABORTED;
 		ffa_rx_release(res);
@@ -641,6 +641,11 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 		goto out_unlock;
 
 	reg = (void *)buf + offset;
+	if (WARN_ON(offset + CONSTITUENTS_OFFSET(reg->addr_range_cnt) > len)) {
+		ret = FFA_RET_ABORTED;
+		goto out_unlock;
+	}
+
 	/* If the SPMD was happy, then we should be too. */
 	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
 					reg->addr_range_cnt));
-- 
2.54.0.669.g59709faab0-goog

