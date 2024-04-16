Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DAB8595B
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261481; cv=none; b=W8VrTvWgyPeiHCR6S9TOJ2KNo8LidYsq6P4ghl7Fts7RevaNEOl+wZJOJ8DA4iBWv7Q8cxH1jeX0BCFmEvtlj4Cs7IcYuwtBq2QH4SAM/Cacy35xeGWTKFoY1CmQ4ThtdjI45dzMvclZhPyUxZ6UA2/IcvhucAi3mlhedm3ZXHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261481; c=relaxed/simple;
	bh=2s9Jk3AOnAAwgdNaydVxPKvR3Jx4qLgUADc3V01wc7k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FzD1ysTEdOZ2Sed/QmGGpfJIJv8zpcRCcYLvZaX8HI/feEtoxIBB3jOCadriy40/G8D6RN0OQXpR5MYJAQcX42UKQ7YON+Kwf/MzhJJRLwmPUdN+4L5q08sTo1KVsLv0oE9MPCv4xNXnBPTnwTgMmtyscKUG8+0WE9GzICUKH2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YHnlQKUH; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YHnlQKUH"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-417c5cc7c96so16432405e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261479; x=1713866279; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yAeMoJx+SnbOeyw5PsxwJvr7dL542fJysadJ22iuuqM=;
        b=YHnlQKUHPFFE7SKxQKn3gsd8lGKRCK1WO3WRgBf8eldU0ag4VDcF+jlcAFsrCiAyOA
         MTZdS6L6J8xgHpTMHiHc+5UwChUF4s5VNz3NHe2IySulaiLEjRTB9V7SDSFOc5b3+nfN
         3jSKKigIQjRIBx4aorawbntArIWyFxePwyLUW4lqux+R8LsPlpkST36ClUBOR6eVLi5H
         nZFfdeI314srTGQIfnOdEGiyomojfhllbVbNGZf4mV/KCoxiju/6uk5So1uO3G/kC5qh
         mTWZnAz68QhX3j6YV81fESqk0Wb5GgvroPWtPB0zjf24bAwa/bOsWsihEgl9yDXSyo8u
         OlxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261479; x=1713866279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yAeMoJx+SnbOeyw5PsxwJvr7dL542fJysadJ22iuuqM=;
        b=Fy65pS0piucakG8X+5trzM77NaSCDTJljaWLlscaGFlRfYaCpMYRedNIyyvIMpoeJV
         qH+u4rODaZcOKpvxPCeuL7q5Iw0PugXqWpcu8uA+GIzrnXK3Hil6R6WqN3TBGXjEZbPn
         68HBY6Ex1LKcQHWbRxKR/wjn/FjQxORBGbSnmHK2RnvxWnwM5WVn60ClOyRnY+TVSYOZ
         TWSrOVo8hMH4yiKbF6vZuOwccImpaDYe6cIH9xhbNJdfIgmHFo1I6mpZmpKTJkXYIjDJ
         zGUErsxb4gRLBOTSCsg27L0wQDHHMGX1CdIJBwk2fdG+59yqSQn290vU9lcAeem5bM4T
         WOUg==
X-Gm-Message-State: AOJu0YzHk/n1E66J0Rtp1KzFQT+Fug43ZvxCjjbJ3tzy3xqAaabVgbD1
	sPBKR3plX+o8fNhaSooc2PjrT/kGX/CPA99N602ICB3ZD0duAJil9b7ROBjWhlY4TTRt+bEBMLm
	GdTYMFZcP37hyt3xaaWn3yJ/fgKkA/rdaC+eVO7zO/XGpmHY1iKeDD65Ez9SyHM2D8DYOp9KcVh
	qcFMt8RuFgLtAVF0P/OAno7kCERLA=
X-Google-Smtp-Source: AGHT+IEhe/BDG2laEivndXKhOgSuHUOV9O6Jp3D+khaVDnxsE216QZr+C4ILYQbcslSxrEfWNaI5LmSvfg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c29:b0:416:bd66:af66 with SMTP id
 j41-20020a05600c1c2900b00416bd66af66mr64669wms.8.1713261478676; Tue, 16 Apr
 2024 02:57:58 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:25 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-35-tabba@google.com>
Subject: [PATCH v2 34/47] KVM: arm64: Prevent kmemleak from accessing .hyp.data
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
2.44.0.683.g7961c838ac-goog

