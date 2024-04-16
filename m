Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69F12907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261425; cv=none; b=KREzS8Vr+3nLiunmEoHR7P+YGw+m0KJtWc2kOCbn7HBSEybaaPIU+B4EQt1ZPQ1bujosMnrIJn+xIYtPkWfsLbqgOffWRNSopFwnWfwVNKzOY71e1/WOvJSifBt/S9k6h3sTpULRXVMEtQ8a2nE+75jTfkguB9djP6SuJuzmS1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261425; c=relaxed/simple;
	bh=oW7imfzxJuaBdvvGnVaj3q1qGm/bjjnDGMIrgPf1FVY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M3Osrv2Ecmr9vINBIPMxbkM6cpDupQ5imLkRyzYOcvlLU48q3p/D3wqTyrYxYLWKn4D4cpZ9AUSSgzF69T/w6pEoqWqjp8cp9bK82LZ7Nuwas5xuV3zuof+ht1e/KRWyzqZKn/HmgQGAACNbaankuCSN6yMHGG6KQ9Mnk3C4CM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jhYgw8l+; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jhYgw8l+"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-343e00c8979so2917004f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261422; x=1713866222; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AwqkILyFpnte4zsZPUelswsQJ8SuDEghj3HuDfsEZHw=;
        b=jhYgw8l+l3ym1Ika4VobCLS8XyGiCcitkGnXZorDY13ulZBoeRLarPkVACpEvVweJn
         yvrjyNqQwWq4F5egFqEYE9HZuU5T6H6z7usTWQknL3oxvXW1eW+x7DD45pPJDK8hG8cy
         uQ2FP1wJDeSWd4Lx95vlSl1+kw32Brvvjn+Iaxm0eXX0RJ80A9NJ4HsjaPRJwFFy15HA
         PyHQCKrfrfb5BJ9iCebvXwhj5dal9ZqnjzcwgKHDjCisqXwZC2Igm5sCAuJ0lHAESHo0
         macro4aQ2Zf+Uaym2KZN2ELut1kEOTc7AGedAbHSaGAivO63cevQfqCrzz54//SWHl1s
         +uLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261422; x=1713866222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AwqkILyFpnte4zsZPUelswsQJ8SuDEghj3HuDfsEZHw=;
        b=wvGeWYkQMxc23EE2eyAscZPEwExCQFOJpkbG7nDRt9c265C6OgMfxcTYgPDbZca1tR
         2ICYrF2BdcFUyPmmCfIxV8FK/uu2f1EU70EAzBhzcICa+Sahyu553tvyh/HWEwAHK8/l
         CUCx18woKAa+GV75JoqDOtJorEpp0A+gfluwi4wY/DUJzsuQojfZ3B6vDU6CIta2LylL
         bufUPomlZ4BWeqZIr2P02714FN85eHFNkW5nPO/Lf5PNIYGeGEHnUbAzL9hgeITVi+0L
         6HVdVZzN3WzngrlnKaLVDpPl9NEammxouWaFWwM9SmCz2IuHn2CnYI9r6aVvhl/w/dBu
         kFRw==
X-Gm-Message-State: AOJu0YzmK8/y4Jj5xzkjwMdJm8Kun38aoq8ApTshV8o7bNkGzoQgeUFf
	m3Hi2SQLCqxohRZS/nRNFbjqltCp83TdY88oBI8G9RHS4X8MUvqxkgAXTQnQAZpN09OK2foY3Fd
	J8DXead/FxEm25vowGNlwrsaiy6khcvqK+r5aFGPJuSyzKlrQTfk/e7yz4aH/9CV0iRfcMJ0fkP
	UUR0EdjvBKe9dnN7NkKOwk48XuXVw=
X-Google-Smtp-Source: AGHT+IGY+JGJaYBI1SqfjGYiNclehTx8dZdT2VdbLadbjYbaUJYmq1RZxZYzp4dMempsNWUmjJj65d6Tvw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:54c3:0:b0:343:f9c7:d4ce with SMTP id
 x3-20020a5d54c3000000b00343f9c7d4cemr20476wrv.7.1713261421540; Tue, 16 Apr
 2024 02:57:01 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:00 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-10-tabba@google.com>
Subject: [PATCH v2 09/47] KVM: arm64: Avoid BBM when changing only s/w bits in
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
index 67647b853c9b..30a9a503c477 100644
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
+		WRITE_ONCE(*ctx->ptep, new);
+		return 0;
+	}
+
 	if (!stage2_try_break_pte(ctx, data->mmu))
 		return -EAGAIN;
 
-- 
2.44.0.683.g7961c838ac-goog

