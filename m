Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410133B9614
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807777; cv=none; b=ibs2v9obh/qL1NGcHAdiOEr0bDLDn8+1jwszcNxiLYnYtKU1BM9qisyyGd7ixGQ8Va/wvgxdsquCp92B6B3XXFAul3Nx63oMc4Qx81j+yyQaYy7k7rlOvn7TsG65OZQ+EXzzjud7o8T6UQzUFHd/++ilcCg8q4t5X83lgdcezvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807777; c=relaxed/simple;
	bh=cWmCVGc8Z9dVFyLjcgMh+d+QoVHI1pxbCmuYrrytJC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jQ0CUtDCaHUV3qvl/2NYX85U4aPwjPK+omK+2fSavx1ywB65XX+oXjUpM/gigiLpDF1ga1L1nsl7fLun67JmEgFlLzW5H0WktaQTKvVE6QQE2CkFCvQLL/dmdcalpzBCgCTP0z8vUNRjjnGEVbNwZl9dsjgoBAJmxbA2aEcNYM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wkv34rBu; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wkv34rBu"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836cf00787so96817085e9.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807775; x=1773412575; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+KUjQbuHQJ21p2RQALWJdLghrvcyrBZVXJ9cfGciG9M=;
        b=Wkv34rBuBztjCDWFDWcCzXF3/CBN31GltmjemEeoyFt/LJkxQE1fdiCZldbD3uUwT7
         61OXct6wtCtDmgDN6iGC7qlNoQHP2yiwcWkgFuR9ICe2LlAef77/73pWRm+g9BIKl1a6
         jKKRHKqswvo4kS5MBGNGAz6RZQpYGnTzKd5AoY4222ntRqZLbqq2ChB+DAoiav89nFUj
         KrDuTx4TspNNenTZEFos00h1HPyapfChOaa0bGPIHxQeFfOQM1I24bGaMXbaChHFIdvz
         Lo35vP1THZtOdRGdRbb/Vs8h+DMWDfESJTptuuHa/AKkQo4fmwDXt1ZnMUP71qJr70kB
         k+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807775; x=1773412575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+KUjQbuHQJ21p2RQALWJdLghrvcyrBZVXJ9cfGciG9M=;
        b=egTytDJy34dtut7PRn72BIPRzIGGmtR+zku+JCkDGJvkHfgN8eCSxDHySVNrEDpOaF
         IAWYNy3u4El2hAzREBXdKO070qDbS8a4WWVRS0IVuN5vzvfmSNL5Pyvo2wNGmEYTcZP8
         /3FHh8qC4AGyqug7LK0DchId7JfM+wXipf81Enxgnu2UekSPfMIVtAZDTff93SFEsPgs
         K8GUxrAjC+Kimjsredk4pWIb2eNM2dJZUhE5uYabIc+r7bMZdZUaMOGvuTQycb95T1Ed
         3szadAb9pv28Ll9NrpAbR+8BZOyVovjfxU3UUfEQm8EEtFyN+A0R9K1SGGDwO21HvokI
         kR9g==
X-Gm-Message-State: AOJu0YyJdW4ewAtZoeoiBsOO3WNSsKNXpBgCH62WpfyA3NU8cZY+UZLd
	U2FGO5ORFO/UIBaGFNvoKDCQHm2ywNjkn8FUV6emjwd90fXcdzjMV2PVmtFxhbZiuaVZtS7XNHE
	4QQQ2P3CJMDn4phYpgD7JRw==
X-Received: from wmcn3-n1.prod.google.com ([2002:a05:600c:c0c3:10b0:479:2d82:5535])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4446:b0:483:29f4:26b3 with SMTP id 5b1f17b1804b1-48526715248mr36686515e9.1.1772807774527;
 Fri, 06 Mar 2026 06:36:14 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:26 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-23-vdonnefort@google.com>
Subject: [PATCH v13 22/32] KVM: arm64: Support unaligned fixmap in the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Return the fixmap VA with the page offset, instead of the page base
address. This allows to use hyp_fixmap_map() seamlessly regardless of
the address alignment. While at it, do the same for hyp_fixblock_map().

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 218976287d3f..c98cec0c150f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -244,7 +244,7 @@ static void *fixmap_map_slot(struct hyp_fixmap_slot *slot, phys_addr_t phys)
 
 void *hyp_fixmap_map(phys_addr_t phys)
 {
-	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys);
+	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys) + offset_in_page(phys);
 }
 
 static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
@@ -366,7 +366,7 @@ void *hyp_fixblock_map(phys_addr_t phys, size_t *size)
 #ifdef HAS_FIXBLOCK
 	*size = PMD_SIZE;
 	hyp_spin_lock(&hyp_fixblock_lock);
-	return fixmap_map_slot(&hyp_fixblock_slot, phys);
+	return fixmap_map_slot(&hyp_fixblock_slot, phys) + offset_in_page(phys);
 #else
 	*size = PAGE_SIZE;
 	return hyp_fixmap_map(phys);
-- 
2.53.0.473.g4a7958ca14-goog

