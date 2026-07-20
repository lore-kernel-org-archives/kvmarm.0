Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D47F3D25CC
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567748; cv=none; b=mpb6wFYa4OpsBrvN6lKTazVcwYoUURBwNTOwHN6djCEMymxd3ww2wGQac5B5fAYkdhEPVgN5YckbwuhGrcX/a9lyG7N3boaELO+u68ShSP47wcc95AO6DqtYP69Pgvhw0PImQcOPF98bA3+ZkvPVIB7I8suDh4N1LVvcR8Fjs0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567748; c=relaxed/simple;
	bh=I9tzdj/TRzkz/BbJoW7Ne6RTZd4fM3QvvwQjeYucyhg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZMdXiJTwg/RC0JuVLyZCqyD7moVRncTfIngPHJVJEfSDEFO/TvQ0NuPWyXGHoheL3eAGuJhTxKwglZU4jRcjFjI/75AZekeYKpT9ACG2GZZlLShnRdIx/iNP2JIfCKlGGgfdmB6tLxFJ6UEnG1JV/1XJRi1EDdsOf5fIwjmUCJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qwQNdYo4; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qwQNdYo4"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-69843ac68d0so10934300a12.3
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567739; x=1785172539; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R+jjhaJjXcsYRBacKhSmXAhe30xPnh0ihtxUkuvM67s=;
        b=qwQNdYo4Y9L8pC/AMb1CQNY+7FZs/vrvNPqa2Kp51ZHeI8dy2Zx4XLQTeVD+G5HzpJ
         fJ7ke4wQVi8n/zlZpGeHUDD2+TWbmHzeTOhYRVLqcl/KyU5Svp53Lz1BIcotOUgWCTJ1
         C/JvhF7BgzuJ0IVTcebPxKnXVcwg1yT1CF5yvfk0PecblGICcFP0q3f1L2fqb31nl/oI
         RJqYjXfnloZsQhWoEFt7FqymH/AqQnYJu0KY1cmSbPgTwo+B3fFKduYybjoWeTjhZc4O
         I8I9w5PaHAytPR2SBaDfrN9/vX1vtcdSJ7A6QImbYNozE+MTq60EIqdNOeSuCBmyyYQh
         vInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567739; x=1785172539;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R+jjhaJjXcsYRBacKhSmXAhe30xPnh0ihtxUkuvM67s=;
        b=gHAiCCWIdWWDmhqsHHqi4uZSJCS+9gRtsj+RFA18AGScasHGk41frK4AKE2rzDUbH5
         ylor3uCnojm/NNfZERY1kj1Yn7ZrxPw4w3GSuzqP7IoAc/yKRl5Jaj0mqxwMoXKFxfPR
         errmquocDRtcx2jD5kAU89DaFHLcz0StogH17eTtAI+oCaep6DcTwFGLBR8rOvQeJ++J
         fs1M7io6kQRwDwO6MP+8ic8K9bIieUca89dSY/t1P+tTJDQgW9IrIk3OFLo8HymhPSZw
         tYBZxBUyZ8lTBNPUO/fEi0e1Q8zn2jyZQx0AaA117r2qqUjzVS9aVRF7kX6x+s9JSGGd
         tJjQ==
X-Forwarded-Encrypted: i=1; AHgh+RrvNHfAO+t/r+JSgp3MP1dySs3xg7byJjtpea0N5kH1rdfMZeHHdROunbZ6C1SQvi/Zgwfitkk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyb6XYC02Yb5fKzUp5l4ps0q+urMAqCABDX0W7eYJ17+xS3X2ek
	EsOCz+l3mukqVG+n6K/N38AY7VHgklAXfgfDMdx599dTaQl0lRSwgi7sVRaVwTkdbPB40cDm7S6
	WLA/B5N5NHvXYrUFO8JB8Ow==
X-Received: from edev5-n2.prod.google.com ([2002:a05:6402:a2c5:20b0:695:d237:207c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:44da:b0:69c:72e2:5b5 with SMTP id 4fb4d7f45d1cf-69e652dd617mr4750868a12.19.1784567738554;
 Mon, 20 Jul 2026 10:15:38 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:15:12 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-17-vdonnefort@google.com>
Subject: [PATCH v3 16/17] KVM: arm64: Reject hyp trace descriptors with fewer
 than 3 pages
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A trace descriptor with 0 nr_page_va allocates a 0-size bpages
backing region, which makes the ring buffer appear unloaded. Reject
descriptors with nr_page_va < 3 in hyp_trace_desc_is_valid() as this is
in any case the lower-limit for simple_ring_buffer.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 6e716295247a..96afa3d6de2f 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -189,6 +189,10 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, 0) > desc_end)
 			return false;
 
+		/* simple_ring_buffer_init_mm() expects at least 3 pages */
+		if (rb_desc->nr_page_va < 3)
+			return false;
+
 		/* Overflow desc? */
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
 			return false;
-- 
2.55.0.229.g6434b31f56-goog

