Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CE21B2186
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727150; cv=none; b=iyeK+boPA7rIMNAeFTpA7ozpRYFSxf8E8f/RgxYUP/yF+NpIBhovI3PifZYsMhHFWEMMfrPEXOI7Ad4Usgk/KMZjkvTEtI/SubUm9LhCR0SCLaoisNoUSQc+QU7Z2WJuo5f9vqh+9CEejabjJBOwZZF0iKrGuV7W06sBucoCW80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727150; c=relaxed/simple;
	bh=Y+NcSPecdDDpRmAMDV3kFDluNG6PwbZtKm26naCPO60=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k44WbAs73pd9xXDHZ+/uchJLrsDDMdLZKl/busPxekRw/06ystOctpzIx1BQXtgKCWoeLBKmIkaqIufbzaul4/0KAQPFxkrIkkPhzvYyi5WrP7RrOfxwLnBYzLxN+n5iZpuvDHPShrr2Rdglamz7WT9s1+yUjLaluxkfwUhLR/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LXQt3NLE; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LXQt3NLE"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e291ac8dcf3so6805611276.3
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727145; x=1731331945; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NRaBXKWmHCm6FdE1Chl6Fbm7Oz0LIxurr/17hTAqXWI=;
        b=LXQt3NLE+8GDq8KrXQ9gDvSKjawIsH5TG9wb41k3j1JuH4yHLaHfSNb7IWspJLZdUV
         GLjQbJHq+FT3tXcQkdV90JdPcnd8mvS6TtTM+YBhhijWTQih+Y/BUaUd1LQP7bPzUkmW
         LDFymrzWT8HIGWUkQLu3ploOebCbAqlY1IlvuPC1OO1uVj7mETyZ4Z1tH/tZlt5cFuUY
         UOgpyES6QdmZWdVzsb2ytDQARWpk4c31Ypxz9ciXChBsHONHjyMwl7hi3JpySPJ4Orsy
         migUUzKFx7z+tTsrjQKCO5NlgLxkeoiJcuYQASDzh5d/vf/CR8cVQGrJDK7ZkfZyOOx+
         hekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727145; x=1731331945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NRaBXKWmHCm6FdE1Chl6Fbm7Oz0LIxurr/17hTAqXWI=;
        b=tQXFHAa5dIcfefHuo+cjeo1EnI4JCUXHn70wsa5ubekqCLz8b4mUykuQV4iR4zClVj
         TmaD8Nk2ywvwGQXXj9bXFyo+UkvzgVgkWfD4PxIZfG4zxDfKIiVehP51k0/WYcErR1yc
         fH4nP/dKh8DoaOwVdGjy0QQ3093omwswBzZIMGQQxJ03KyscV4+vPnDvyhirS8zLyvwV
         /ZDbwTKaqwKVprRsDm3mHnlhElPuWVl3Nn+66UP5SO4tEwS8lpTT8Ta4kC8xTC2RB1Fo
         4NJBh5w3+OyAkRDbK9cIqdMFZS6PXC7Wy/oow/okprp7cqu3owpeieD5NOFnqCFGeGTQ
         vQdg==
X-Forwarded-Encrypted: i=1; AJvYcCVqIzF+VcKpetusSYju2L7b5nMCHYfOnkdrU6g/m6VGTtOardR7QKSARyTsMmBIcNH3P+ngHRQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzNMzcoRiwuHXd9qADFtbi4l+xhvV7qTeWtOaATKRPetskJUtR
	BGnIt4G/gFthyxZqmA16dQUV8SvYILwsqN8uwcL8MIYJQGzOVYRIXvHfijMJxRiQe2W9XxpOCZj
	fZAILgw==
X-Google-Smtp-Source: AGHT+IEIRmWbJCJ91gChrscm24F1xHepSdW9Ht8okQQnwSOPBLJd4Dm+SGDL7D1GGWqTGSqt9NEIHueAq4mp
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a25:aa05:0:b0:e25:d46a:a6b6 with SMTP id
 3f1490d57ef6-e330266859dmr11233276.8.1730727145034; Mon, 04 Nov 2024 05:32:25
 -0800 (PST)
Date: Mon,  4 Nov 2024 13:31:53 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-8-qperret@google.com>
Subject: [PATCH 07/18] KVM: arm64: Make kvm_pgtable_stage2_init() a static
 inline function
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Turn kvm_pgtable_stage2_init() into a static inline function instead of
a macro. This will allow the usage of typeof() on it later on.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index f52fa8158ce6..047e1c06ae4c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -526,8 +526,11 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      enum kvm_pgtable_stage2_flags flags,
 			      kvm_pgtable_force_pte_cb_t force_pte_cb);
 
-#define kvm_pgtable_stage2_init(pgt, mmu, mm_ops) \
-	__kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL)
+static inline int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
+					  struct kvm_pgtable_mm_ops *mm_ops)
+{
+	return __kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL);
+}
 
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
-- 
2.47.0.163.g1226f6d8fa-goog

