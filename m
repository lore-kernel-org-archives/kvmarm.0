Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B078320C035
	for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 12:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736511584; cv=none; b=pvLLJ+dz5KXY2hFOHt4RPXoGdTwNBh0S/Xjz/2XCZNZGapU+c8l6YGqKDNVlrYITnlTYCtuPniK9B66DUHJKFG+qLPbpa3TVnDjnGDLSkkG+j4gE4pcePkUcr55BpDWr3/f0MMIJC22HWXic6J1ersPivYh3YOha4oMetw0Y8Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736511584; c=relaxed/simple;
	bh=drNPEvW5qAM1UX6XnyY8Q3MTIX+lxaRal9iOAiuO8F0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JIlUt+RTexbGci+/hbXwzZKn9oqxzlyFnvWxWWO95ZS0XOAwVc7yJjyut0e/sRwUBfDuTeBOdp7Z/mJJyN3KV5GttGMyvKaTPAfYaWEy/YIhZLhVyupwXA/Kc3aQWAq1I2wU/rSTxWn9cVJL+i1eMCadAwwmnHxNYmuIdoDkrPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TmQV1kdM; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TmQV1kdM"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-38639b4f19cso1173983f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 04:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736511581; x=1737116381; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KOsYvpEfuP6cXx/Oyn2XcEqgX5/aUorsAa5EPXiB2Ss=;
        b=TmQV1kdMTdyCVNLEHD6GL4Yln7G/f1BIp1p7+Z52JWSSizPB5Tv8EdCk8Km6y86Y1o
         vg3TyOxt4pchjJ9iwrEPSjNvUTeTiqzeA3t9GLWlCDVGpFwynFXmwabSZWCJNnYHzr0i
         BufSGvKCzljOVVsQSv8N/t65ppbpzA058xaAypYfra4OuitWbUwHpHjZZ5SEnlPhGOl/
         KtLk6X26riu0QocXtYE5gQhGHIXmlH5QYA45aFNtDv5TPHa8yvOIQ5IBiGoI3W4DyX+8
         gm3KHunTw2T+h3NXik2UqGi3qK95W/aGok/gacSJcAZsVQizWPBFxVrMV3A3T9KHCZe2
         Zilg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736511581; x=1737116381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KOsYvpEfuP6cXx/Oyn2XcEqgX5/aUorsAa5EPXiB2Ss=;
        b=aqiRs69kCU359hUGaxAYoNbVEkvOOGMB/fBSg+ah1URk+djHCaimJ7no5Qi+BGyZNM
         V76NQc8nDEddHSYdeh64q38ic2QdncVJolUdeuHQiP7eVsKz2kV+TFe0ZRhWxRVTusMa
         U1IJk490EbBcX0P/QuzEwA3x132UuxzXrI/u1ieWl6vjEOPxm3rI/tPiPZsMYDIJXP1N
         YJIOdv6izdAIPhOQDImR+r3lRZmrLpFcdlRZeO3pocl/fHpErlZZk7yM+0WUJKVBBht1
         9ALnl3VRJ2wTxnT5BjJD5KNELwIuLg50VwK7qdKL8VH9zBj+4G5ZKg1Pze/HYyHCQH4T
         egAA==
X-Forwarded-Encrypted: i=1; AJvYcCXTZjBEsbmF3MdYqHZs2PISME/9emmxEkoP+QqyfOYJJ7NA2QH12BoeaFUp9+oHJH1QSVF1yqI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyolxUpzgFC4VNd3XwwK1nX0dBrZQSJvnd/PCkdATTy9HR/Dfx+
	jc8vsmmjXu9At8oUudaCQcA3MCmGHpfExPI2gQjSnQepqanMqoxkls6MQYo2Ir/t5dqUYSPQNeG
	8+sDbBw==
X-Google-Smtp-Source: AGHT+IFAYtJzivhsUU52iKzNWQxnVnmG7hlKc9RgE/6e86BSJtlmWTwTC7B+OByUUTQWv/FFwWaTNzzh0SbE
X-Received: from ejav24.prod.google.com ([2002:a17:906:3398:b0:aa6:ac44:bff3])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2a9:b0:386:43c9:3ac2
 with SMTP id ffacd0b85a97d-38a87305310mr9731875f8f.15.1736511581199; Fri, 10
 Jan 2025 04:19:41 -0800 (PST)
Date: Fri, 10 Jan 2025 12:19:34 +0000
In-Reply-To: <20250110121936.1559655-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250110121936.1559655-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250110121936.1559655-2-qperret@google.com>
Subject: [PATCH 1/3] KVM: arm64: Drop pkvm_mem_transition for FF-A
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Simplify the __pkvm_host_{un}share_ffa() paths by using
{check,set}_page_state_range().

No functional changes intended.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 36 ++++++++-------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 392f036bc69e..3a3d9fcbc508 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1324,22 +1324,14 @@ void hyp_unpin_shared_mem(void *from, void *to)
 
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
 {
+	u64 phys = hyp_pfn_to_phys(pfn);
+	u64 size = PAGE_SIZE * nr_pages;
 	int ret;
-	struct pkvm_mem_share share = {
-		.tx	= {
-			.nr_pages	= nr_pages,
-			.initiator	= {
-				.id	= PKVM_ID_HOST,
-				.addr	= hyp_pfn_to_phys(pfn),
-			},
-			.completer	= {
-				.id	= PKVM_ID_FFA,
-			},
-		},
-	};
 
 	host_lock_component();
-	ret = do_share(&share);
+	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
+	if (!ret)
+		ret = __host_set_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED);
 	host_unlock_component();
 
 	return ret;
@@ -1347,22 +1339,14 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
 
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
 {
+	u64 phys = hyp_pfn_to_phys(pfn);
+	u64 size = PAGE_SIZE * nr_pages;
 	int ret;
-	struct pkvm_mem_share share = {
-		.tx	= {
-			.nr_pages	= nr_pages,
-			.initiator	= {
-				.id	= PKVM_ID_HOST,
-				.addr	= hyp_pfn_to_phys(pfn),
-			},
-			.completer	= {
-				.id	= PKVM_ID_FFA,
-			},
-		},
-	};
 
 	host_lock_component();
-	ret = do_unshare(&share);
+	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED);
+	if (!ret)
+		ret = __host_set_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	host_unlock_component();
 
 	return ret;
-- 
2.47.1.688.g23fc6f90ad-goog

