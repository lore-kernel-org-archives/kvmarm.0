Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66546352035
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 09:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779354584; cv=none; b=KOMwKvhvBI5rSwN31gL1UNlphLdqteKCocX5zsNqEvBhIBnmd2CfbCkbuZg5836mEACKkXjTVes4Y8nSxxj925K511BDuGrj2yZJwBHBJ2U5cZTmqila9cq2+VROSjJkhjmhZhaiVjD7pQK9rnXCNaAQqLovFpIhTD05iLDqWKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779354584; c=relaxed/simple;
	bh=8z4bCNPRtyjVog2tl88kuyPu1CLJQJzdKKWtsWekqzk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ch8gT891GkyL0ap7le2/X5G0acb2W2Qg4CcqihzFLNvs0YTifOD9lClad1qsdGhS3WwUs9Yiexdt7Lu+uvDk82ABxHXvv2oNg25UU9UUsOAUVc0eIivcWZKdr3itC60ugz++7kGKtsrzbfP5g1w3wrpR0YxyPuPoCa9dG61lJZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o69H16yA; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o69H16yA"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fd233d1e2so54413955e9.1
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 02:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779354582; x=1779959382; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0w0paPj0j6eJsDuENg7ZDSDMt1WZief0AlIPdrZFR/A=;
        b=o69H16yAsjMau5IR6DYU6NtwPoYqen1dsKultPQpvtYLIhfY/D282JJruX5fw/Ujuw
         Vwlrt7+AVh23UrD9l7A4tO0I99Pup2AHnC8NMwZPubdANVwcPBD3mZbK2d8sHNqN+ASk
         Vbx1xC1XAaM19w70LE13FivYbE9gxMXchkSLoZffqynG5JyBMblfutHxe2N9aiommA8+
         +0g06kt6hPf5vwN4lLTpTg0om1yAEUJeVecD+5X2E/vC/lxTWBOfQwJcR7vX4GRttfPH
         Z3hR0iSZ55MxwNqv5mAYsQexZ6Qt9YZCHvGXgi0iAtTimSIYDmDow4JZl2X9zBKTQP2a
         dHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779354582; x=1779959382;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0w0paPj0j6eJsDuENg7ZDSDMt1WZief0AlIPdrZFR/A=;
        b=sHLMo+IdejzVJcGbRyYjEIFedpe39fyMw/J3ZF7yakFU+I1G59CvFaViwyXOxCTB3q
         GxBI88hsSYc8dIzZgN5oYOVzgR0QNKnSW3henGvReaNTBnSwMnYTApQIBugemLVKWt+c
         wQBnRKJhTmHF8uPNN5j3N3yS+zjCg+zrnnqVFQ1yHPz4V1o5Ms+UYwEEz8F348owEI25
         Z3h4H+w5fZbDdmDpwp4pwQohMLxeGWg3mKuiKuQKoX4+CP2KxYTSr9kcb86z2vgFSmUc
         8V98b3ml4Zdig6ifZN/CbvsvNENj8LIzP8lKFKG2Czyo9wNaHDT0RRPBsJNQcfwDee1V
         ya7w==
X-Forwarded-Encrypted: i=1; AFNElJ9cLdsjcyQZyxMIfPgZRbCNOwa6dO4cqPjafVjvJH7hZzGVyiEqSlukYsU2x8bQxeieivDfLe0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyb5BiGi+O86y3P6t8eR1xBTeDw99ed13soC8Nz2TKtakv9s4I7
	uLfTAmUE7PR3YmKnSqvz7YQUDEBq+4rpHnyVSVeI7NlncyU5NrU64xaNkwdB4GCdXjoFEbON52I
	l7fCvAM8YyYoD3Tmey3T9XQ==
X-Received: from wmbhu22.prod.google.com ([2002:a05:600c:a296:b0:488:c686:2b56])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c107:b0:489:1c1f:35f1 with SMTP id 5b1f17b1804b1-49036035305mr20728065e9.4.1779354581586;
 Thu, 21 May 2026 02:09:41 -0700 (PDT)
Date: Thu, 21 May 2026 10:09:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521090939.735108-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Fix meta-page unsharing in pKVM hyp tracing
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

As the hyp_trace_buffer_unshare_hyp() function name suggests we should
unshare all the previously shared pages, otherwise we leak hyp-shared
pages which won't be reusable for hyp memory.

Fix the typo by calling __unshare_page() on the meta-page, ensuring all
previously shared pages are correctly unshared.

Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 8b7f2bf2fba8..06805b426101 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -189,7 +189,7 @@ static void hyp_trace_buffer_unshare_hyp(struct hyp_trace_buffer *trace_buffer,
 		if (cpu > last_cpu)
 			break;
 
-		__share_page(rb_desc->meta_va);
+		__unshare_page(rb_desc->meta_va);
 		for (p = 0; p < rb_desc->nr_page_va; p++)
 			__unshare_page(rb_desc->page_va[p]);
 	}

base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.54.0.746.g67dd491aae-goog

