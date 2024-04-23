Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D05213BAF7
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884771; cv=none; b=uhaanYY2jTycsEoIGjd4zQ+jwiOAzZqgurJHR+feKOQ91rgRR6GO2pClnVzhJehA73S5HI4loR5ieZxf8uquCLABhKFubpYKI+nOahNBt4iilQSEke56VQxh76oCFNy0nAikAbVm4XoY4J+D5vXeS49t+Yqc2YDqEjOv3uIWCkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884771; c=relaxed/simple;
	bh=yvMOELS1mZJEkU7Bq72vzdWwyjmcKUeWZmIXURTaZ4M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N7XL/4PbFyUU3AgFLxxVQYvGfcu8DlViea3Zb1T31h3N+4lBa9lI9ws0LKcO34SuACDNb313dGMF+V4wQFNQmaiIrziCiP/s1+lb1LR+oz6iWqTQ3BCmISFeytri31QLBhZ6ZxEd++6PCg16W3yVl+ATeDyeIZixACETqiXhmMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zsh58dHs; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zsh58dHs"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so9137164276.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884769; x=1714489569; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t6erxIkBNPLG5XuZNesh8tT0OudDbIDHEfU5Xz+QPxo=;
        b=Zsh58dHs5H7RY+JecW8MHMmH4LFhOge78XKrFGMcjPWmyVuwOgP9hUYCkEsyZRQNgM
         j9XHwdjKlxanlhTT6yypwnMgfrWDqMnaNHwyV3SIDcfWA9Oq+eLrb4mzVxoOe4xgfMT/
         f6oVkVVGSiE2EmmyifBNCwmJqFe+VQxE7vc+jmZyQi0XI2S0EWVsyZIGrjjf8PTkGXBd
         +ZzgC+Pf4BxFAq1Oyx7KhRnAkXww7zQTQ3q71eZalbDE3EG8mXCEjNqi3uMBp32lycLF
         o0w5xY624tJUZyODA/52ssGVXLTH5Pt4uOsmr/ZAr20+RmIVZBDy57FuaQAnDj5WAYSM
         Hrig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884769; x=1714489569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t6erxIkBNPLG5XuZNesh8tT0OudDbIDHEfU5Xz+QPxo=;
        b=uvvJ2ldInDnZKo0kYvXU7uwfKZjfl70ivWuLeklvotNmGih67IqKy9g0qSCcnczNeR
         fkYa6dEH0LIOEld928IFUtXEPQ5SkCB9/FnyB/KSdSi76NBcpI1Oey0waGCLyobjR0on
         1fOgEqROqFJxNlzXIUMr6B/W0kCdJtaugUUEGqvpNJQ3YoRkvk2WptEDFxnGwmAObkmE
         GSS3slcFnZFAxQnxEYGJ9Ir7yl3PyOFP8ZoC/z+sOVaWjwxORQm/GwHS+fpTWDgLDNzo
         4/KpWonxtOHVNpKi5bHaFKFDt1pl9T5Qh0ursBIsa+1UaOaeUecUXHOgU6tmM3iQAzG7
         +kbw==
X-Gm-Message-State: AOJu0YwYj/pAyAVZBisd9PPiiGfLlojZCJZSToFOtSqHLDrmBzJfYS43
	dvR5GIMeFXyoIOKoY7WsZ2Gqw/G12fU1zdW+tXDpcJdLdzqdBvZtIffaDmwA258kbL1MeZ62DfU
	8K6Y2Kum03XqcFIH/POW+uoKlOPd21yARHc2rFMaq+hK/MVlSGCkem57O1fg778y+xumhSVWaQI
	nXJiBxzH4nOf7qF2iDkrtZ23zyxog=
X-Google-Smtp-Source: AGHT+IFsszh3FWGAMeFSm/Yj1JaXIUpoEXFPE5+IAz9DUqTdNBFiFhpOpT5nJHYNMh/FYoOY/VV6rq+p8Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2b0d:b0:de5:319b:a211 with SMTP id
 fi13-20020a0569022b0d00b00de5319ba211mr412926ybb.3.1713884768411; Tue, 23 Apr
 2024 08:06:08 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:20 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-13-tabba@google.com>
Subject: [PATCH v4 12/30] KVM: arm64: Prevent kmemleak from accessing .hyp.data
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

