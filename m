Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4D813B58D
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884762; cv=none; b=j/c04o19CVqBjMBiC60E0lFjlyMJFUg1Mdmxz74MM/158cM3N38J73NwXQ6JI7sTKjoUIK5V2GX/WVtiJLuAA6g+MWnYqQ/QGSOOkf4sMp8LArDB5+rT9P/PMYOHdeOrb1x74LxFCL3IzH2KgQ8VKVhLv81SqW4eU7eCq7xRkWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884762; c=relaxed/simple;
	bh=hlFc7Pn3Sp8TMbsrXBoU2YQ0loq8e4pMpYKIy+EJERM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UX+ymSj/sw3yb4rsFFQSVtDkzkZU/QpWP1hgH7qbKqeHmlG6m+Pw5RK37tjD2/jHc1p30X/+7etvO3X0mNlJBpCyaeYpjpwTT5wa5zz7TTnO178zipVWxEjIfxz9alxw3qFzKVSbsmMsoSWhdtXDjOtVYH35GQPewzUs5+Sn2Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r/XY4wQH; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r/XY4wQH"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a5741ee352bso100814666b.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884759; x=1714489559; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c9m/tjqud7d0EC8EggXLj3IXPN8uw3FwjULc+34dzpA=;
        b=r/XY4wQH4o79Q9F+ntvAXhq1TfLOhp6NWloM84IM+/MsnEfv/JXYdkg6AP3ax41IH/
         r0TjhEe2H40R6VEgo86kie7E5mLJoqrV75aG3ul0ZiFv1rrUzUXWiqUw0520BBlnMDIw
         vS6sC9xmlcJOO3GBH2xuSJBtj1ZGlA4VItGxN2S3pqDqWcogze2WTfjM23i3Kldd9Gmm
         ZWnXf8Lm94FFEoSCfw5A6AfxX4EYlEjlr+J7tBNgdaJ7EWyX9OFoh1MAhBla1+uzs5fg
         A7chwDNj5Yg448MY3Oi2BXfVwbO5GIbY7KV7Y2+kNWG9Z2ss/Hir/skokIIadp4DdRnL
         i81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884759; x=1714489559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c9m/tjqud7d0EC8EggXLj3IXPN8uw3FwjULc+34dzpA=;
        b=lNTDKxBP92nf9+KJZoqLZCTahOK25apZHtL3Rc1lsdR87uAgTahPHg+zAgGtpMbflI
         7YNDSa4+C1UOktZccodRMChiTVPMtexp5Qh8GTWv3iSFhig55p1fXzDYGUSJTeuq1N1b
         GKUpQVw3qmZJzO3oVHA2qg20qhpWJ6uU0NjU685yk4PPmp9+C1DmbLmfUOnjT3kwELwu
         ifFZu6YCbrCPcSup3AV+QQtEG876ZBkz0zwSJXgrCtmWQdjbruInB9GEGi65/Nn99aXO
         NJPo3BszkdCOjHiR0nYBnH0N3I/DnXaNyNqEYN3wbz9vfwevgbxslWY/+Id4XRxgwLjn
         xDdQ==
X-Gm-Message-State: AOJu0YyzpHIBOGCqCsJ38ajoP0oDab2c3rTXD8AYV5+3AcgGp/C6GgoX
	2ddwtNt/iqnsFejTYz65Fjfox8Ksa4O3pO5X8JvjXBOQElzO+OFhbsO2R2cG8jn1FgGVMuC4wyy
	fws//xGHNTed6PzCC8M+7xp5jWYrf4qB+cbXO0cBK8o02VWIpo2Dsp02LfOvp8zWPLrj7N6zkDf
	Bo9eQEartkzo9Ghbgcr2cCl8fuRY0=
X-Google-Smtp-Source: AGHT+IGebG+8O/+kea8suHV4oaapcMEbF6BWBSQnDkiDppHU9uExrkuK1Eu4xBCUXREEs59QgUIoo+NnyQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a17:907:7604:b0:a55:689a:4b40 with SMTP id
 jx4-20020a170907760400b00a55689a4b40mr10058ejc.8.1713884759139; Tue, 23 Apr
 2024 08:05:59 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:16 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-9-tabba@google.com>
Subject: [PATCH v4 08/30] KVM: arm64: Avoid BBM when changing only s/w bits in
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

