Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0C946453
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 07:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513597; cv=none; b=DM6TQWJxNCQgsXFBIws3uTvZCTW0tZHkwt5gi1G7ugBS8kCiXIAWCW/4TkJiIrCSPKUrqmev8K+7dk02KznPLS4z0DEJgINNJPe56oLxbrLmDEB0ezwWft0EVVWS7VHYGIwAKdzctErUOHF2QNCpLhWA/Q49oxtGNrCjJOF9wq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513597; c=relaxed/simple;
	bh=W+5yRtzoy7EUvDb4KK31Lnj5j51ojL+O+NPBsRD8we4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sLn4nJObJq1DpvNR7PtTsxASyxTTOSN65yM3nILhCCeiCCR55RCKjaoOvgiOVsXaiM1fWsqjeVGXLFcaPQE7S1sc9p2IsSt2mJ7vNIBrDwfcB6/NzqaRwyhDaTgqQv1q8uDh+c9bb7oTUJtQnY+eUJ+W7dqoa7wD1lMpB1/fSjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fDRffPo6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fDRffPo6"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41485831b2dso14455645e9.3
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 00:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513595; x=1714118395; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w5vwxGHvKc7IvdW16eJM/90clVgPk4hg4QdQd0laEsM=;
        b=fDRffPo6rCYaxTVq5HInQ1FWWs4TobDgq/y7dlt3oeGAvkdusWRinyBQih8x8Bp5BA
         kp9JckYfANt4vUGDY5vmvgiODZuAfHmH5diqhOSRpl6iOmSlt/ZC4rXXFPzrChcyVsdG
         Y8zcuRhRK9iRKPHP+4SO+1P+n1R5USEiJTeyltS4zIbirPCa5vuQJ08yqdu5UAhCL44q
         LEh5w60b1ADvevMFgsBR0DTZraZUNCAOv/JtZ1ZAbcytTfPkGBMp7wcpAyIcC7tdHNnf
         Y9+KfkNotaUq58JOCGwIHMQw7iDQ4OR+f8laTmnzyQOOhbQdeNF4H6wl5npsHMLvuWCM
         gTWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513595; x=1714118395;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5vwxGHvKc7IvdW16eJM/90clVgPk4hg4QdQd0laEsM=;
        b=QhebSRO0BxcKC2eYIW3TXEvuxEyos02v/ukUxAuEZLbFADkTq19BsINT+/z3l03/TD
         9xjHLi1796nOkuOr5NvgSlX8Dl+gwWSXxYRgfG0/7U91bgKHOcI+NO/I51qCs8VRhDW5
         4IrTVciQ711OYbd5IsMCDkqzbCaEPBKohY1zSMe9kGGEu7qHwIgkHn5uU4rO2hcWauWK
         kUk3yNrI3TRPdHdTBzxGbSuDHahjEjIFmntcP2cWH3bshJ4N92QLLuuw1qRvZp386Q71
         5nkRProRm0M+fPx1/Mz0d+GO3VllYO7Y0gkBPGosFLrQ2Y10BW5rWfuuuN8qiP8Qrm3a
         NgoQ==
X-Gm-Message-State: AOJu0YwWU7PUnhIHg52QGvyj0WWr/m4PIileGO1C/mm5a4qbUw/SlgEj
	JwfGYKnBdAgYDgaQtD2ZlfBaWh+Oj+QkWLTXmcCDy4+kzTlMFBvww6ZGm1vG+HE04mHMV5sTxWA
	o1yKZaMAe1a9ieo6I2nvGXUci0EB80gVenDEfNj0y7NWAeIlWrHqjpwE+PxD/3uqQR81B0QiACz
	bGhbrRvfBrAspMIL0Q46gONU9l1VQ=
X-Google-Smtp-Source: AGHT+IELHE6fVgvbe2hBAE+TtYPAQVHTJl7g4YumfdbWuq353qvFNWw5QCAt6n2R2lTSCD5ZEodNiExoUA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3b09:b0:418:7f33:7a35 with SMTP id
 m9-20020a05600c3b0900b004187f337a35mr7902wms.4.1713513594740; Fri, 19 Apr
 2024 00:59:54 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:15 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-6-tabba@google.com>
Subject: [PATCH v3 05/31] KVM: arm64: Issue CMOs when tearing down guest s2 pages
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

On the guest teardown path, pKVM will zero the pages used to back
the guest data structures before returning them to the host as
they may contain secrets (e.g. in the vCPU registers). However,
the zeroing is done using a cacheable alias, and CMOs are
missing, hence giving the host a potential opportunity to read
the original content of the guest structs from memory.

Fix this by issuing CMOs after zeroing the pages.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 492b7fc2c0c7..315d4ebe1d6a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -441,6 +441,7 @@ static void *map_donated_memory(unsigned long host_va, size_t size)
 
 static void __unmap_donated_memory(void *va, size_t size)
 {
+	kvm_flush_dcache_to_poc(va, size);
 	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
 				       PAGE_ALIGN(size) >> PAGE_SHIFT));
 }
-- 
2.44.0.769.g3c40516874-goog

