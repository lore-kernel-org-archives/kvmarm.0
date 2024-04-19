Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C4C46453
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513612; cv=none; b=J3RwF9oLP50LFWE07UxPWyNKLNLY7pMmWGWG8jXZZxgabFoHxEd2xOc4U9lGUpZKKrRBiuVoyDsgk5EaE6hOgiXE3Jm4NlGAFk0djFoRlxLMW020G3hW4Yq2KFi/qMouzlhwi48I93eICWgOrW/RVhJaeSeC/SQb7jnkHSp6J1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513612; c=relaxed/simple;
	bh=yvMOELS1mZJEkU7Bq72vzdWwyjmcKUeWZmIXURTaZ4M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IY3xvP1XCbWv0HrOqjoLG5yAAgvEtbjL7sl/c9zhxwAlsyJVKRpyfl5qW1upSZOW+MT56mcnzc5Usxtmxln7QNj0RZWDZab+H3kVil6L5VWZAgDT7VWZOBGgKlVHQ1RMDAaqGaUopP4Z2Cb42Ybm+T56iJAm2gbslnHaPDEZxZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Kb7hfYV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Kb7hfYV"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de465062289so3626767276.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513610; x=1714118410; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t6erxIkBNPLG5XuZNesh8tT0OudDbIDHEfU5Xz+QPxo=;
        b=1Kb7hfYVHXuKCAgwSEJbqGelNyueomYoR0HdA+FsjVY8ZJ8IcQaiheU5riI3vu50fT
         xgKLXUeT00E+Lotx90K+4arUmRicLGpXTJYdaT8TadIJ7zwmQRCbfOUN1xNWS9ecgrgg
         3wJSA8sWq84ipFKVBsIVjDfN+F9yvbjB6h9mjL2It01CDZOKreA2l/F9Av53wKIv4CkL
         qomXNvsmKt/l4E6GXOtJwcR6UJCUDqilhabVDG3iThAORnZitrSQrNWgnkh/e5gU0JRg
         Pca9/KRl+sZW18bXXkw6Zb4gktFm0ji8TNvpTM0kkP1ZWEaL8QAZv8J74TaekRkiOOdi
         N2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513610; x=1714118410;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t6erxIkBNPLG5XuZNesh8tT0OudDbIDHEfU5Xz+QPxo=;
        b=fyF7sN42p164uX3iyKbtQBd6bM7mMFqQ2J2ft8VjmzJ18xObGMpg0938c7cny7qJi+
         pu9zb2coDOtuGLtthb8c/uLIpgLwuHx1JYlnl2wjlNu2pCaF3mTTsnuCel9V+VRyglF6
         WoM+rWF6LTfy+VuocrzWzvbVyHLSzcaZ6eSOkoDN/T2h+qzUcyldKoOx38ssao4exqpC
         RABF5Oy9t7N8lIF3BLXXFhvfrJKmcekAem+IgZUk2o/RC75Ng8y0sXz1FerFK3Y9E9/0
         rRY7ZFBtzLhF2ScNbJrQ1Br/7dpnvTMFmW1DXK1aLjTiLTHkqwyd1gY/E1utTxiL/aqV
         z/SQ==
X-Gm-Message-State: AOJu0YyavlQ2VoIi6H1/fOo7E3N1uFhoLQ2KcSEoIINHTERFK7gRjrZI
	bt88/1589oubkslwb3m/i9mpeursc71PvWWutR7ZZvT1THOhsdBLyOCIg2EzyMrIQTEAlv7Cia2
	ZX/92Gw4Du9AefmFdeETQxqClfPifeu4HkAN1/6zIZH4rbUmwj65DKdbwiJJ9sjlg3WgJLLrBdJ
	FdqNY/gST+CdSORzKD8we67v4uBiE=
X-Google-Smtp-Source: AGHT+IHqpXU+N8jVJracYDow+qrEzUoO5a+YLKjZzpEsNB4jdJhcjpMhEUmtvpA6//iwz4p0TWygEvsCug==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2b93:b0:dc6:dfc6:4207 with SMTP id
 fj19-20020a0569022b9300b00dc6dfc64207mr369090ybb.10.1713513610447; Fri, 19
 Apr 2024 01:00:10 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:22 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-13-tabba@google.com>
Subject: [PATCH v3 12/31] KVM: arm64: Prevent kmemleak from accessing .hyp.data
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

We've added a .data section for the hypervisor, which kmemleak is
eager to parse. This clearly doesn't go well, so add the section
to kmemleak's block list.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index e2c08443f284..85117ea8f351 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -258,6 +258,7 @@ static int __init finalize_pkvm(void)
 	 * at, which would end badly once inaccessible.
 	 */
 	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
+	kmemleak_free_part(__hyp_rodata_start, __hyp_rodata_end - __hyp_rodata_start);
 	kmemleak_free_part_phys(hyp_mem_base, hyp_mem_size);
 
 	ret = pkvm_drop_host_privileges();
-- 
2.44.0.769.g3c40516874-goog

