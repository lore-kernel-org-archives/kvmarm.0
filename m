Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D8A78685
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154484; cv=none; b=VojaBAcx7bSXpCxjzcaeCiRDgqUNB3f3IDnEZWne+NgP7sHdZwAXRCgMqYFPvOIIsuA5Qdb80aGuHF+aw8ihVV2woyqc5iupvKmX2h2UAy6NYi4rQomV5gWQp1jPLeLlxMIkeQOuoDewBfzzsXT45zxOT56A8Dd6vmlH6eWGzaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154484; c=relaxed/simple;
	bh=88XT4CYPNYTPqbxPKc3mmDg1crzW70qfcz93YokeWHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AWUpPn406CCGJ4chdpqSix7so+86WQk1/SvZTHswYpuTnjd3MJWhWWG/2EXvektZwbSNmTp5wQ1K79vQ3M5hBnf9hFH44iQPoa6M3zh3OpLvmXTb1HJ52OYtzYzpE07k406KMpBDznXNHeEa3p8fDL6ecQTrMU1xvT7KNhnOf+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aoS+jDln; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aoS+jDln"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-434a104896cso36174325e9.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154482; x=1733759282; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AUZZOxNVC1lLwStyPm7LTR4giJNaFKBwnVTKDXsGwgs=;
        b=aoS+jDlnF4MwwrpwDigwKQVJvx7PSLqUk29asQV3Wy7/EsJh9uYSFQ/UQvM942ed5r
         hv/YEVvfcHAshBnn8U55yRfRT+YthfigUlQTP1kFT5P3pix487tNcW9FT+JjvrYeXKO0
         5o9K23wtkRfHmZWst/YZYU6oovQAdGKkyLpeCQlRBn8vWB36I1mkR7Mup6sgj/nmh+1j
         D0l/RoYpw6T+hKBG48zXWQErnr8UfIgVnejZIru/km1G+qXzdRFmZxF7Gb1hS7hMGlps
         EzHFSSsbswHmNF9W0nOVU/7JGmGDySomujGAjOYcMqs0y9hIY5oMqa2GkBjy+T598yBG
         ZMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154482; x=1733759282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AUZZOxNVC1lLwStyPm7LTR4giJNaFKBwnVTKDXsGwgs=;
        b=A9IsHesEL127B03fbk8FV0hK3tN7GH52iD1bOg1uNxDs/Ngux7TpBD/lkNVri3xq+6
         5zoh5w5XivZnHKkRttJjsRAElrHEoAlGcXVv6iUopPxwDMF33lx7PO/TRdjDAsyaLz83
         8St+/xxMXN9SCtjeD5y0O4FcrSUNK96KpOBiJy39KNVewIE1NtUWZyfvwuQklFu1fz3h
         BWMIQbaeKZHzAcdHg71Gf3uq9UevYXRUDoJOOmg3ASDzOiDTu6M2A6s6Zcw66g+gICRg
         mOU/DD0NHTfij8pbpHb1bOEK4bhrz6eMWEQsF1P5sRc2woxxIFmViqcBCXHMAaStQCwU
         I1+A==
X-Gm-Message-State: AOJu0YwFmrX+ESP5lVJBVtWAjbyVnapvn0tiSExsbXw6qSbdKz3J1uFb
	UfVdojxJGDoVDlX9LuoN3acAYN6N3XTKPmHhM6Hh40K99oIftEuANj0qcC7WUOmWGGqHvnZESF+
	ulZAqP0sfDj1MCeOm28qwN3MBIgu5F/pny0/yX7680sSw3Jj6cpGs/5dQRQwh6zaQkzZGTrbmA/
	9fiphYVQyPZxkKb64kk3v+GEgq3rQ=
X-Google-Smtp-Source: AGHT+IG8LYyQFRvZAn+1psKDX3FASYdfmcKZwHsSrb04cMVuPz9aKF9pw4V3JWI4Rapc9chI4XydfWhjUA==
X-Received: from wmsl21.prod.google.com ([2002:a05:600c:1d15:b0:434:9ff1:db95])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e24:b0:431:5f55:28ad
 with SMTP id 5b1f17b1804b1-434a9de5657mr193461355e9.22.1733154481889; Mon, 02
 Dec 2024 07:48:01 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:36 +0000
In-Reply-To: <20241202154742.3611749-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-10-tabba@google.com>
Subject: [PATCH v4 09/14] KVM: arm64: Remove redundant setting of HCR_EL2 trap bit
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

