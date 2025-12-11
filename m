Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C300E2FE066
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 11:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765453114; cv=none; b=VwlEn95IuNH2cngWHPys6atUyBnNcpK/teJQfIlUEOjn/Ue73i57tpkSzFIp1mIIGnzRI809z0k6WzwJ2i22DOhGbWFkHnxTTvVvI2NxJU7bZ0WYy5AkPuSV+qNDT4gk8XBSFZmjGakGrgsH0iT/dKSXq0UDR/+rcKj6QMg8s6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765453114; c=relaxed/simple;
	bh=Lnm5Vi3C3dcLhr+UvyCp031pHSxS5eIrNxA8ZJSvqts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bZCjk3wL5NO3j3GXd+0slfMfk+9KtHinnmqYfuaPZYiOBkFPCfjYSdCQoWFZ+q8cN40GgGFI3DRCb46Rtz70rGl1eKzr/xvwaxeA13/9LSyTq2eLVijusYmONoccIFp1SBThUlLp088C40jtOA6K/Sx6viRP0KkdR3dsT4DmYGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kQYr7Hhl; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kQYr7Hhl"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477b8a667bcso10578695e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 03:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765453110; x=1766057910; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hcRdDF/JGouVFt3/hu1n8HoEXy2nZFfL1yfhHE+a+Gw=;
        b=kQYr7HhlPgcKtRNb3zC9Sq3LFBIxYUjgV5V+bw3uHhyO7tNs1QHJ3BHpwwxkFshB5L
         OzB2urGTMZuJVOnJxn/lPx/f4IPnZ/Pa1+HEDmKFb/1xZe233hQy8kH5dGd3MoKP6gPx
         9INm8pJ5vnp1+IxVOxP73fzo3xaRnaSS9jdMqG8o5Vm2s32JF879utC3ATppZOmkgsE3
         wyToCbwib4w4V+cEQVlfugmkGUAlSDq4WHV3YVy2pw7QtTu+RJXKUe8lkBx3VP3Wm+Oe
         2dn3gPX2wufeg48oDvA3DzqDoUZHods4Qid3GKVmlivAVhgI8+PjAgwe93NyJtxYZHEt
         MHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765453110; x=1766057910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hcRdDF/JGouVFt3/hu1n8HoEXy2nZFfL1yfhHE+a+Gw=;
        b=ZXutCcqfUCGjr7JS/nl9Gw9MuG6U23XePiiPP5Z9Xbi0fBRxX90/oFttigjghF3Ykl
         RIe8b9a+oxqldl3VsjD+BVz0ZFxZyk6I52esX5WoiB4PlnOtJyALKsU5HY4lGn/0pLFW
         F3zeRGfs4/huMMpS9d6Op05Yk35Q8glFtM07oTituo8I3+ykYGbHljPG3Vwikz4KXiAC
         BU0Qz8jiIjXKQxK14TK1/AxqW/lAIb4IHJr/qDbCzVo6rEkQn9NtxNWg4AOJs1ThkgL1
         yOT8z4+o/0Dmz4v7ufUuI+Zm0h755xgChdB7YtGprZsU2+hKh5ktvhg0nziczJHZIKlI
         CuJg==
X-Gm-Message-State: AOJu0YxonFUMKPwWZl3PE7gDIICh7B0xc5tt2iokiOpGyFsVCZmWrMah
	PqwRsw1YwI+OvlJYwo7/xK33LffJJ8KxFvbuhlTvrQc6Qx8XlS4BPcf2qYxFB3xCd2+/jY5RpZP
	g3LAVT3UXwzcbMcQYJmA+APXxn9AZvhR+RMr34VXSxh7ex9z/bXzo+E3TCfypC6zU+5cVKAL1PX
	pUzNCVvx9i6GEji4P+iBiGr+at+tNZ8fk=
X-Google-Smtp-Source: AGHT+IEXP199c0OfjJCPkUfufV8iONK1QKNXqhB6nNKq41PANPaUQSofuGGpisFKi1nFzFQZ/XuatPAPIw==
X-Received: from wmbhi3.prod.google.com ([2002:a05:600c:5343:b0:477:c551:bdb9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:548f:b0:477:b0b9:3131
 with SMTP id 5b1f17b1804b1-47a83745633mr60726405e9.8.1765453110322; Thu, 11
 Dec 2025 03:38:30 -0800 (PST)
Date: Thu, 11 Dec 2025 11:38:24 +0000
In-Reply-To: <20251211113828.370370-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211113828.370370-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211113828.370370-2-tabba@google.com>
Subject: [PATCH v2 1/5] arm64: Remove dead code resetting HCR_EL2 for pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The pKVM lifecycle does not support tearing down the hypervisor and
returning to the hyp stub once initialized. The transition to protected
mode is one-way.

Consequently, the code path in hyp-init.S responsible for resetting
EL2 registers (triggered by kexec or hibernation) is unreachable in
protected mode.

Remove the dead code handling HCR_EL2 reset for
ARM64_KVM_PROTECTED_MODE.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index aada42522e7b..0d42eedc7167 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -260,11 +260,6 @@ reset:
 	msr	sctlr_el2, x5
 	isb
 
-alternative_if ARM64_KVM_PROTECTED_MODE
-	mov_q	x5, HCR_HOST_NVHE_FLAGS
-	msr_hcr_el2 x5
-alternative_else_nop_endif
-
 	/* Install stub vectors */
 	adr_l	x5, __hyp_stub_vectors
 	msr	vbar_el2, x5
-- 
2.52.0.223.gf5cc29aaa4-goog

