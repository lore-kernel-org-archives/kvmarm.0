Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9DCF4E2
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560950; cv=none; b=XfKgxR2hUdjbj+JPOV89Aua5u4L6IndD+Gg4ONoFJXfKAzI+V42PTAoXpBryqBi2fni8GE9fQqoxUcPjRj/hwb1kkxcaECX72hQ/igYAqt1STl4Q/v4BfMlSpymCUNQzifpo3sqrnqA8AQw7jOmv1clodSvPggYJscDGnO7V3ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560950; c=relaxed/simple;
	bh=22ixlUH0WiV41fIYaY+GBoghtD1kta6MvT7mR/103rI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ozlYP4YEdP481p63Lwav1AErSGjoQp86N2sPa4RJYHsnLTAzq2rf+Uce+Fn9xa2heZ9OdZRpYW2tApAkCYUsCRaxoU6OPZSS3YICSo3mQ21pwsd7nmu6+L6AV8k+mxMJZ5Q4KIFoWULj9boTYxtFEuWpGcZS+fz3SbotYMiCmck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=05Fwr3sY; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="05Fwr3sY"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-414ae9b8c04so313685e9.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560947; x=1712165747; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cFc4i+vZYuY5Be1cP5t1NTStSrhN5Ql8XQwEFbmVlbI=;
        b=05Fwr3sYSzd+vpUS99SRAR/Hp/eKEfmNMO0WQ+SYjyorBZ8d7M25irhCSb9gmfhUIB
         IEAzh/tCeajTXLSahErQRfS97+1c95IQbY9qIyEYHtbqHCSTNajjN6DoqInk0OpGXej+
         VRnexoKFgdY45exQhg5i3/IvpjbxWkrx2WZ7IFGsL0/e43RyVtkmDJYHABYBhSEo7IxN
         +z9TETCJYH6+WbroXlshNghLtX2cU4kqkviqCNtgXKd+UI109NMd14EXhv9KO0fdLdUL
         LuAdDxdivUI2R2YFvM0dG3+mrrkliGvX5wtrXlDCEZ42VtjcL10S9f6xxvGuRGGSjCbo
         GpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560947; x=1712165747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cFc4i+vZYuY5Be1cP5t1NTStSrhN5Ql8XQwEFbmVlbI=;
        b=JCtMhXvXzcvCGeQ+SEwPlj0Ik12yUg75w4A2k5u756AR3NBY05SWcKECjkYR0p5mni
         8maSEb5+k/MIX48O6RG14JkQpokTvOx3RcyNbIp/Nzav13KyLhzhnt3IlSmTsX7jjAHR
         fUuCofiwYIiCwB+EL9Ts83JXyaFnbVLMypTVMMlaTOvEH+yX5eB3+Og8NsH/3heQ/Flp
         LGU9WbydlPKwALVjMxaO7JZJAzjVZXbW7kTPU68qcNgr5SMK5mxSjf0nEbOGnwDpHBQr
         eWP/vl0oxFKWv2y+FLTrzgE+9kucQhOg8c+0GdaRUoi6u3zxe8U5Y1WvyNjDnD6Kv34S
         YqsQ==
X-Gm-Message-State: AOJu0YzZ+ouNiAPPTdn8af3Ptj9MAnZddw5CLaMRstD42B29FDA9qUoM
	b79w0dPcQ1wQ4lqxT5/KL1g2GoT15lzXWWDOTgLSfmUoU2Q+fcqw7YIKvRW/qwPbDfCx+Xj1z2o
	KAaAz3Av08WdaQZKxJtJxHh8HjPiKboObbILZEh146XPwCWi60U5zTCFeJzDeGNvIQI8Pl0jt4+
	GLWSsdFIvFScqdMuN7Dl+gfZFZk9s=
X-Google-Smtp-Source: AGHT+IErPEas+qpxsjJN83UfoZkgTPLG0ijcSOJgTSTFrqvdyEn/3OLJJsBacKQzRbPM3y5glW992OmOiA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3ba4:b0:414:22e:4304 with SMTP id
 n36-20020a05600c3ba400b00414022e4304mr3471wms.0.1711560947541; Wed, 27 Mar
 2024 10:35:47 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:53 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-7-tabba@google.com>
Subject: [PATCH v1 06/44] KVM: arm64: Avoid BBM when changing only s/w bits in
 Stage-2 PTE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index da54bb312910..7f3efb442d36 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -972,6 +972,21 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
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
+		WRITE_ONCE(*ctx->ptep, new);
+		return 0;
+	}
+
 	if (!stage2_try_break_pte(ctx, data->mmu))
 		return -EAGAIN;
 
-- 
2.44.0.478.gd926399ef9-goog

