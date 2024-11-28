Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBEE198A11
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797338; cv=none; b=OlBjqS7GC4FuKVrA5BA1FX5syItwyOa4Yflp5ymZis0Xy5iz+LwY+50b1+2Pz7qtHZmYRXGOic1XeJ9B7awoDIknhS5PH4yCbvKAOXPHaZ0kpCQnnBDoLf10VG2u+YZBFboSRm30/A/g9qhZ7y2HkaWJhLkPsg6xlyxjd87l/28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797338; c=relaxed/simple;
	bh=88XT4CYPNYTPqbxPKc3mmDg1crzW70qfcz93YokeWHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KiSmk2mTRI6GCRXby/+QbWpnNi+pR8XaGj49iUWswyWq2PtgVg5oa0pzLDOOIptX2Pkf4R8Gj0fJUa2ZaYK6yFez/gsqlop+wbfaFglx3DlmPeG7PPpFindGSxvH+66i7FrJkGC3YMHvXbEFvzF5AooZCs3BmMjTG2c0ff8HE0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FLra/rew; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FLra/rew"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3823fe49055so426554f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797336; x=1733402136; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AUZZOxNVC1lLwStyPm7LTR4giJNaFKBwnVTKDXsGwgs=;
        b=FLra/rew1vOxe5lmkkbQroBNYKSSkKcolue1z7hlQyHvFTjZPGzpYR970FxyJ5YcT8
         nIfZJzOCABQSd7w+jFz+r+xLxmlpvGVvM4GYidb9SxJV78jeZ6fTQobsPuYzeiGv81kS
         hqLAxPIiIZxFEqvgjHQ/2LU7J1USmLjHu1U67H6DUSRFj39QCyJFMJ3jTEyercTTJFMQ
         favEWHdOdg4E2RsIxzzlVE2svAqvvnGnjlE8K3wCIuK/6rwbTm5queoQL+87iJoxzw85
         9a19j8EdEQMshvSx/4PEI+iFRrk1qaBEM02xt5PXsrHf15PMMzAyf9TANjj9/u4dZKeU
         H6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797336; x=1733402136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AUZZOxNVC1lLwStyPm7LTR4giJNaFKBwnVTKDXsGwgs=;
        b=E1Wc9SFi81cobxOm7sf4R6JXr0UQ5YrsrvrrkUpeZG0C0SNnKBruNoRzK8LRKOcm6K
         HOQacKbSw04Z6x6peuGVgntyOwtO6LI1aiXSlxVle+1vVmnYs3fEArN09d3IgsRqjeHM
         YctrJAo86pZ3rgLA29pKOFyP90FAi4FzfNYqe778XdtHy9wJkXMRWG4tTiwOIjxtc7S1
         HofhHmu6NajZFE23d06RBD195TAu9CEwjTGigOUxHx92iEktXJywV1iBrv+VhByceYHc
         ITQm80dqCdIr3GAt2Xv1Xqav1HlRSSEhN4qK4gu6xi4Nzkx8G0xJNoGTsZMWA9vZBhx1
         Kq3w==
X-Gm-Message-State: AOJu0Yxx+bCzMcLWF40sFH0gUWJpvKcMa89CZMDg7QOxXr+lrTZfkSrd
	WvBk6ZkKaqHf00zKb5pLcTCqk8fG8sQUJkG0f+nhLSHjg/tgJmjuaNKfmaCjSCN4I1aVFpg+yrE
	Oy1Ocd1+1e8GoMnN6dabSlM9wo/8gcBawXFBbeXqmigOou4Dbt9Pw25j80/KbEESpOSM3rWhtw8
	hhgLfJYdWeIf8SiJdVmqm3SkqT9E8=
X-Google-Smtp-Source: AGHT+IE/V3C/P7DNzcXS3lGwl583S3x3wQlwRkkO36vZH/VHuISUNxEAOit77rO5Ibvk9Y+foXKgNZfkuQ==
X-Received: from wrbfr9.prod.google.com ([2002:a05:6000:2a89:b0:385:cfa6:7962])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:6c69:0:b0:382:59c1:ccdf
 with SMTP id ffacd0b85a97d-385c6edd378mr6228766f8f.46.1732797335666; Thu, 28
 Nov 2024 04:35:35 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:09 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-10-tabba@google.com>
Subject: [PATCH v3 09/15] KVM: arm64: Remove redundant setting of HCR_EL2 trap bit
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

In hVHE mode, HCR_E2H should be set for both protected and
non-protected VMs. Since commit 23c9d58cb458 ("KVM: arm64: Fix
initializing traps in protected mode"), this has been fixed, and
the setting of the flag here is redundant.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index ffa500b500f2..cede527a59d4 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -57,9 +57,6 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	/* No support for AArch32. */
 	val |= HCR_RW;
 
-	if (has_hvhe())
-		val |= HCR_E2H;
-
 	/*
 	 * Always trap:
 	 * - Feature id registers: to control features exposed to guests
-- 
2.47.0.338.g60cca15819-goog

