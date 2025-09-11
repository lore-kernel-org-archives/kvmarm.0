Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9A93314BC
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598588; cv=none; b=hnTdhyw0mdZTPtU3Z1gBu8KNqavipkTsPZnsqgj6r2LHZqC6TKm9Vke29E3PKlZOTysrZrat/EHsYsozJ/K6ChhgTz9RkCBWCv+zwI7I+bvWiXQf8B41z2OcpRaGXAaNBY5m/mj2mfJpqnwu1eeS03ts86+jnDJpG5p2IkyBn3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598588; c=relaxed/simple;
	bh=coVlvw6nAsqruPp9BB3WURmrEJc6EQqZ8wGP1yqmBOA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W6iNWF6SwSvci2NNTV5IZCnLrVv59emXoayZ2ttaFJxQtXyzzyMHjqThDJQSBRFy+bo3VionAITOMKRu/HhRA2421Y9Rh05rADt8EOBx49KuVY7P3s7mVIXHh79u35pH8ihI4F6dcKV8bBLoFXLHFGt5Xkv2598MNwSxOnXPCKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OIxcd1BT; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OIxcd1BT"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45cb659e858so5860485e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 06:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757598585; x=1758203385; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QS0X9ggn6fxbGpDUqeyaduaSpB6sZdnskQczeYDZPM=;
        b=OIxcd1BT4YAIjlv8uJst/8E21PGCkG7k4Zxyv1kFYGjG633HiRguSmhPTuMHTq1iVL
         oDih88XN/iHqwj9O798L20BiRajaQ7iu7n4b9A7ZTq+UUOwyWe7BNRcK1qtHjX/GTogF
         GqexijWrITTuMh05GumTRCeisTkb+Z/Y4LdZbe3e+5fbD1Pt0sCMRAZr9DL9l2RzDPO5
         u59g9Oa4z+7YmZYT0caDSYN2w2JMmCWCxi4bTkXYKRf74/QlcAnOsxpuQpZi6RAS941/
         YNhotcNQOkkqVu6FWsUbxr+7u2S1tLlQ1sNCIMRAJPhNd9wwk2ZdpzQnIY4r+uq0NQAn
         Kkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757598585; x=1758203385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0QS0X9ggn6fxbGpDUqeyaduaSpB6sZdnskQczeYDZPM=;
        b=IBGRYIes4pmD2afz5wdKFeqCAXvCoyhFmqiI3osIgCcJqiIwuiH+u1bUbmsGk8YLHY
         dBh1YRocGXaOLfLJRr4ENefN3DXEyi0XbYY20vVSsyUthk0Ky1AsF4v7DwONgyopea6q
         SQoGPaZtLbA80lCT1bcPleafqDgmM8J1YsRbOq/lnm+NHCH8E0g6sZRE4g41GYnRcgJH
         vFSfpl6WtCoRN5zvS/TuRX4SFuEOO3tajIzmHnQW65B9qV4JEiHBE64uxEGvh7m69/t4
         hiuHBhvenUhIZ0F8HsOFtL71P2GKQum2L7nRA6qJ2oX5ESCWFIV7yMYuNZrnpoYoQfoe
         /VCA==
X-Forwarded-Encrypted: i=1; AJvYcCVlGXvH1VO+rEusRk0EzvRmxncPT0EkGIYPgautvqdVd2FqZpCVfylfXwcxYbP1aGlsbnkT5wQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1UUCV/4ROREBxAWxTSJkDgxnHdtOxW3WV41lbrFVkagRqz5Wd
	tc9PSzT5QNT0hKsuG6CCt4lpQ+xx6P+YCVYHrOQVi0h5AYv1er1LmUwU
X-Gm-Gg: ASbGncvR0B0O5VYQJ/qHkBonmYYWzkxtW+gntl2EefHzVD0f4Igl86haosCWdRMf12a
	7BuEPrk9saY7oj/NBt8+JU1X1e7aL7yxLuw1ru8a0VzJi7IKjqDH4f306lMc1lpU82kMfMH6wRM
	zF5jwAOEOE+u9TuMk79zUICEdb+jlkY/km3nPUU3Js2VDBhP3X5oLJGKttbWqfOhvzhupfgOpZo
	crxeQ0OJQLVEb1i7aHfrIs27jFH5XN2qx65nLijsGHMr8nPN4bCBidfc4QY6j6QFZH6wbnbOrfB
	VSPFFZD8SVo0VVDkTnLorEAIj5uZr4/Q+VtrZiYOfuXDpItx7mGGAy55zhGE+hgRjcWomxa5ezS
	zY9IxEfzZ+s4+wyEN46OQwuUEYA7AR6QN/Coy+fdccd/YQn1R/CpkZ7cEM1H44ZScquQViykE
X-Google-Smtp-Source: AGHT+IFNNNmoDMaiLwtDUu3F/l93u30ohFmaZcpwi8LsB2GCj8jLScee70K+1o9ZTJ5T9w+mmGeR0g==
X-Received: by 2002:a05:600c:4709:b0:45b:8477:de1a with SMTP id 5b1f17b1804b1-45dddea648emr170375255e9.7.1757598584916;
        Thu, 11 Sep 2025 06:49:44 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760778915sm2608361f8f.12.2025.09.11.06.49.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Sep 2025 06:49:44 -0700 (PDT)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	isaku.yamahata@intel.com,
	roypat@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.com
Subject: [PATCH 2/6] KVM: arm64: Add KVM_PGTABLE_WALK_PRE_FAULT walk flag
Date: Thu, 11 Sep 2025 14:46:44 +0100
Message-Id: <20250911134648.58945-3-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250911134648.58945-1-jackabt.amazon@gmail.com>
References: <20250911134648.58945-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Don't return -EAGAIN from stage2_map_walker_try_leaf during
KVM_PRE_FAULT_MEMORY.

During pre-faults, user_abort() is retried upon returning -EAGAIN,
meaning the ioctl would get stuck in an infinite loop if userspace
tries to pre-fault already existing mappings

Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 3 +++
 arch/arm64/kvm/hyp/pgtable.c         | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2888b5d03757..0789671d1c4f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -296,6 +296,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
  *					without Cache maintenance
  *					operations required.
+ * @KVM_PGTABLE_WALK_PRE_FAULT		Indicates the page-table walk was
+ *					invoked from a pre-fault request.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
@@ -305,6 +307,7 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
 	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
 	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
+	KVM_PGTABLE_WALK_PRE_FAULT		= BIT(7),
 };
 
 struct kvm_pgtable_visit_ctx {
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c351b4abd5db..140dccec2c5b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -914,9 +914,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	 * same mapping or only change the access permissions. Instead,
 	 * the vCPU will exit one more time from guest if still needed
 	 * and then go through the path of relaxing permissions.
+	 *
+	 * When walking in the context of a pre-fault request, if the
+	 * mapping already exists we can return 0, as there's nothing
+	 * to do.
 	 */
 	if (!stage2_pte_needs_update(ctx->old, new))
-		return -EAGAIN;
+		return (ctx->flags & KVM_PGTABLE_WALK_PRE_FAULT) ? 0 : -EAGAIN;
 
 	/* If we're only changing software bits, then store them and go! */
 	if (!kvm_pgtable_walk_shared(ctx) &&
-- 
2.43.0

