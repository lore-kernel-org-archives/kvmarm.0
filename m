Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F093A1A8
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513604; cv=none; b=NpLHs/aNfL8W+VAHoHfDljZwsT/Tmqda3vyuAlm1vdwSW9mBe48Yjp2iBslLqlkq1hFyBHmyR1f76dDZBbwBS40Ns1tsAl07s9RCDBwTv9jri4ztT+rLuWdRRii6KT8zbulEDC41Y0dQVI39eGCDHYPLQe+zcOpCO8mZGTENgSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513604; c=relaxed/simple;
	bh=hlFc7Pn3Sp8TMbsrXBoU2YQ0loq8e4pMpYKIy+EJERM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QcD6usKjlCDr1wQSKLWKDfEZ4LKgR/2YzR2Q+D6odJA0n5GakJ6QeL3eZKxNeciEnhMVEECxZf+FFj7E/Dl9SApzd9vwuWFy1ySK/te4FURpMEHBvXgGkKlm3wrv50b8pb6baAV1fdazpc4P/0z/tOnQ+dSjWugjYf1/Db7gbeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wyPxsK8O; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wyPxsK8O"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-416ac21981dso8589365e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513602; x=1714118402; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c9m/tjqud7d0EC8EggXLj3IXPN8uw3FwjULc+34dzpA=;
        b=wyPxsK8OBOSmuC+TwnergOuStKAk2jhw+Cjjsj0osakS0MxXD6PXCSmMYiUvK+9b/y
         3qh19uPj+JE8hDw+bwUwe08UpSZDngC4MdRxjhL73j6zGFNqSHJgzL9UYGXC4rwqZpCc
         vwxV08dDkYXnEFastNPha1I+gPCZWXL3BqM9IGiaFsK9JAh12m7fRKEGlB1EA1G+jvVe
         iTNplcpa0NetPdg8ccKOduGJI4rjDMiRpuuqge1vuod5lfagYH8uYxLFvDFOiH3/IC2F
         73YjRv+PoKRdk8YT5bHgbIuncM0RmIa88Rfx9UedGxxeJh/Qx0bZHTTu9cKW3y899Q0T
         fCcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513602; x=1714118402;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c9m/tjqud7d0EC8EggXLj3IXPN8uw3FwjULc+34dzpA=;
        b=qZJJM0cgdNomPonpMoAyqwRx0OTFx38y8QBb5zoBTw8OhebWw+pcN36Q5uQwkii+ay
         pw554yzCwkpXtSJrcIXkzhXcxlPpOzdR1aHeffBv25dCVN2GWdLkuRpixcnS8P5VhxN5
         FrJXlnjiObtGkoznsNCiGwWuDVxF0vge0KUHNXzVRjZ5aoauy3vMTiBnK/BK23ISdtqG
         j7xm8oiOxRbeA4joHx7JaQkqKYEXchoWrRPyOQ9jaCCMpIn1uicJfj3jH4azlJPXP6Nb
         QEJgU87as4QoCfPI50Sgfh2aBXA8W83fbeHntjoT4e2UZT1f5f8V0qmqCxYGp6x+vAmo
         2Xxw==
X-Gm-Message-State: AOJu0YwQcKbr93RY8bx3XwGW21V7QnMHmTNSRiPn7lPATqhBpOL1ylV7
	15J604xvmuzNf3Ke3UFaMwX3mFDCFLu3E0guq+twiQumBKKNHt9CwMDmxlgi4ogIcTQg4vNJ4RI
	h5us/6rekcoBMFVssTxZrBxyFunJOp++AT9XoEi0MnXx4uqFHtVnxKooDjp9bYK8JhftUB5HfJ4
	cg9bVm5oFA+1R2+nl8eZwXTkWygMM=
X-Google-Smtp-Source: AGHT+IER6DkTRe1iEH/2l4IZxOrF5sLSA+KgYPEZ3zdF5fU8+TChyqqFBK0//4uNaCKVu/8Jv9RFNeud/w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c8d8:0:b0:418:f308:2074 with SMTP id
 f24-20020a7bc8d8000000b00418f3082074mr9887wml.0.1713513601460; Fri, 19 Apr
 2024 01:00:01 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:18 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-9-tabba@google.com>
Subject: [PATCH v3 08/31] KVM: arm64: Avoid BBM when changing only s/w bits in
 Stage-2 PTE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

Break-before-make (BBM) can be expensive, as transitioning via an
invalid mapping (i.e. the "break" step) requires the completion of TLB
invalidation and can also cause other agents to fault concurrently on
the invalid mapping.

Since BBM is not required when changing only the software bits of a PTE,
avoid the sequence in this case and just update the PTE directly.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 67647b853c9b..9e2bbee77491 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -979,6 +979,21 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!stage2_pte_needs_update(ctx->old, new))
 		return -EAGAIN;
 
+	/* If we're only changing software bits, then store them and go! */
+	if (!kvm_pgtable_walk_shared(ctx) &&
+	    !((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW)) {
+		bool old_is_counted = stage2_pte_is_counted(ctx->old);
+
+		if (old_is_counted != stage2_pte_is_counted(new)) {
+			if (old_is_counted)
+				mm_ops->put_page(ctx->ptep);
+			else
+				mm_ops->get_page(ctx->ptep);
+		}
+		WARN_ON_ONCE(!stage2_try_set_pte(ctx, new));
+		return 0;
+	}
+
 	if (!stage2_try_break_pte(ctx, data->mmu))
 		return -EAGAIN;
 
-- 
2.44.0.769.g3c40516874-goog

