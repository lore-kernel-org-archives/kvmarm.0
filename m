Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB812907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261472; cv=none; b=GFUNxgzSMPQwbUGGotuFQILZJnDhoucH/miA2TntUOnnjuZNAXmOeTAIOX8pW9WaQP3X19dVZSexbnbyWIs40H1vpB+ejHeaeEu4t4NEEVGs9iqLrgvrXgtv3BztGz6kA6osqvTMyP009txtLanlgj8tTlV759xRaEN/looPfX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261472; c=relaxed/simple;
	bh=cdjgW+GiqyHdNeJ8b8pHxvauMvc7qcxRnuB92w5depc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RYgCss491uk/miunV98BcetMEpclC3wbGUeJh+hQVYa+1MRRtA61+viKrA6QEP7QFSFLG//72v2E4dcC2XPMj7UABS8G0Bl8GYg2S90q1WHGWMFpcUw5w1YmYQZlleBVhppQuG1ARJv1+ATK+mr+AQVvTdgfcbAvs0CiAhyHhVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rGJZ23cf; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rGJZ23cf"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-343f5059c5fso2736838f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261470; x=1713866270; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yug1vZVIJuTRKg+k68Jq4wiAYy/BqqwLMJy/EhAVBi4=;
        b=rGJZ23cf5j4ctN+47j/FGCQkirUQriCQbfu2fBAvkMKSV5k3h5Ts6qMMdqiTK1a1L/
         ECy4hvfInhZDF7CFtugqHPwvxhATtBAiW/aewHDhXGmCdMGV+Y6cRtSE8JI66j4o1LcF
         U2CDxhUljerA6ug1U/YS7Kj6UWYw79yXOvLDj9Ae7GXD4msyyvslsuLP+/8zkp3t+YMg
         zWT0xX1AZqr5LScltZ3WLiDbUIvj8Y32VTnFBPOcB9z1JQoy4KRLaoJqip9UL9DUSPrQ
         IZG274jRblFuQtJ/Ga3Ykxtx/2wYg9+IQNHA/3rkAg6jHy/AYbk8b+MUfWiPxLFmNVwy
         1Ifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261470; x=1713866270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yug1vZVIJuTRKg+k68Jq4wiAYy/BqqwLMJy/EhAVBi4=;
        b=GylwViGUPbplvFMPId7ns9GR2a/m/2UAt584TsC/2qZCUCUpbdj0xGbQ9Et+k9BxdY
         k3XgueUpBMDXF6tXqNn1fU4oVlqfGquPZ9fR1YS26fYUpuAle7+uwTiUTCKRInit5Cam
         2DQN2M+grqjMBfRbLVYE9Eu16rUEWIq40AITAJpOir9/EJQFKrtB2olcE5cr546tvZjJ
         Kil42sjtj5LkBTyGQ87ddhgM47CmN7zzyj4PiDphXLOleDDrg1v0hRYNVrLrmsNAgw1j
         cOqFI6LMue73fAwlUfF1MuvPT4E4kScEWQvKjn0XRv7TFmqwzNbdgpWOzOdVt8f2IYdl
         oBCw==
X-Gm-Message-State: AOJu0Yz5qjjnmTS3T3M/CBaeK624Qf8aG3emJlHyt+WZ8JVnBWUlxX+2
	T+OSiEWyQ9+p3fEOfMBnFRvwFU1d6rO3F3vkEpTwCt9zuVf21N+VzLWt+z6BcFWYvwwlbzfuYYO
	j8VSqQuMDTQUC0cu/wenUGh6LsnarGiNKsJLlYnfHD+nR4Rbnj6ET6PgO8J7KqPEWsSIyUuz/ci
	thVqvfEJY+WYddtP1EnMAXxVh7Dt8=
X-Google-Smtp-Source: AGHT+IEMuMXxh6qx8oVmG2NuO0P454or6mlnebx8ixV8K0k0XlzgS3PwtZRqXjaNF/py1GBj/BUoHOjGyg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:5644:0:b0:348:b456:e1c7 with SMTP id
 j4-20020a5d5644000000b00348b456e1c7mr3194wrw.4.1713261469670; Tue, 16 Apr
 2024 02:57:49 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:21 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-31-tabba@google.com>
Subject: [PATCH v2 30/47] KVM: arm64: Remove locking from EL2 allocation fast-paths
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

hyp_{get,put}_page() are called extensively from the page-table code
to adjust reference counts on page-table pages. As a small step towards
removing reader serialisation on these paths, drop the 'hyp_pool' lock
in the case where the refcount remains positive, only taking the lock
if the page is to be freed back to the allocator.

Remove a misleading comment at the same time, which implies that a page
with a refcount of zero and which is not attached to a freelist is
unsafe whereas in practice it's the other way around which can lead to
problems.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h |  6 +-----
 arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 16 ++++------------
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index 97c527ef53c2..24eb7840d98e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -10,11 +10,7 @@
 #define HYP_NO_ORDER	USHRT_MAX
 
 struct hyp_pool {
-	/*
-	 * Spinlock protecting concurrent changes to the memory pool as well as
-	 * the struct hyp_page of the pool's pages until we have a proper atomic
-	 * API at EL2.
-	 */
+	/* lock protecting concurrent changes to the memory pool. */
 	hyp_spinlock_t lock;
 	struct list_head free_area[NR_PAGE_ORDERS];
 	phys_addr_t range_start;
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 169cdb43b4b8..96b52f545af0 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -155,33 +155,25 @@ static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 
 static void __hyp_put_page(struct hyp_pool *pool, struct hyp_page *p)
 {
-	if (hyp_page_ref_dec_and_test(p))
+	if (hyp_page_ref_dec_and_test(p)) {
+		hyp_spin_lock(&pool->lock);
 		__hyp_attach_page(pool, p);
+		hyp_spin_unlock(&pool->lock);
+	}
 }
 
-/*
- * Changes to the buddy tree and page refcounts must be done with the hyp_pool
- * lock held. If a refcount change requires an update to the buddy tree (e.g.
- * hyp_put_page()), both operations must be done within the same critical
- * section to guarantee transient states (e.g. a page with null refcount but
- * not yet attached to a free list) can't be observed by well-behaved readers.
- */
 void hyp_put_page(struct hyp_pool *pool, void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
 
-	hyp_spin_lock(&pool->lock);
 	__hyp_put_page(pool, p);
-	hyp_spin_unlock(&pool->lock);
 }
 
 void hyp_get_page(struct hyp_pool *pool, void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
 
-	hyp_spin_lock(&pool->lock);
 	hyp_page_ref_inc(p);
-	hyp_spin_unlock(&pool->lock);
 }
 
 void hyp_split_page(struct hyp_page *p)
-- 
2.44.0.683.g7961c838ac-goog

