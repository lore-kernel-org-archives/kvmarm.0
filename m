Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A0E26A1CC
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 12:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740744843; cv=none; b=AAGS9otj8icNgeer4pe4ch/FM1SquPWqSHMnEKXlBFX55v21SCg/QtMamsUbjKZXLRVHeYSOcriXHGQ0fFJpff9IOTxPRSgFzXnUAQqgVQjG/2vpSsMwjTjeZfizV0XfYz9y/o54nFcNQ+9cfLjsOgDtaiy3inKd2Lp3ol75CUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740744843; c=relaxed/simple;
	bh=0ZkqQIQxKscqn0KefL+cIWMenlE6zl5KTQEb5CgqYWU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bZrYisfDdfAmpMdcmOL5gLnko3guAn7PJDkt1eEGDtjQO5/xqj09NvDApEw+ExgfJbwVvzDor6rW4tGlOSRMaY60evFvG2EJKk/PEoA06oj+AuzGN8v/Kootm5vfBhj2vF57Bm/hR4u83eb81KW4fVa26ld1a7/hZwrQJDvpYwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R2VeDhPa; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R2VeDhPa"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4399d2a1331so10682545e9.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 04:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740744840; x=1741349640; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TNd3VmeY+7xSqSUKAYqv/5mTt/52Q+ubddKUOdAsyfE=;
        b=R2VeDhPavgROVekP9qR2vDNnBAehIm38la2rGlb5n3B33LvkL8QrvdFP1q7+VQ9ZU1
         y55RqE65fjkStRsO1ULJGxCwQs3fX5Tldnb6oIRSJ6+8jb4EAmi8OLp+4KS8V+aPUwCj
         DqYk6kbQKL/gXwN0z6rv+kw699bqx9IjotRsSU0XNgJ5rYzk4avtQ14y4fiEL+pWWxWL
         CsAdXPx7hVWRjLfIV5wpWFaM5siYxArWTKtqIwraOzfKFHg66SU6oxbuDqxZxbQ1/Lcn
         1GoDUP9GCmn6Hp6wr0GxpwDzp5OqMMXNP2IpmNlk6ZmM1xP+kImLpL7JabUQYGpzpRd4
         /Waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740744840; x=1741349640;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TNd3VmeY+7xSqSUKAYqv/5mTt/52Q+ubddKUOdAsyfE=;
        b=KcYGjftQ3vvUVoDkHuRosUlBieAx+kMrlokQipPYYh6lPe4OBildyK3xtPxHnPx75S
         ubyxCU50ezIUx4/BpXyNuyD7gfJgCpI1V2bM7pqbsRAddO6ORQc/CpR+gUjVpq+2NLfG
         Obif0bvtlO66qUenRAmW1FUSp2uOUl4UqY5BRvxlSZXD00IMheBKNYKpoH2fxPZJn+d1
         Bm8vdHrlh76zCQ5ReAb5mEBGxzb4YUUD9QqHqNmbpetGZ5QuUFDeYgXHnxhpz9FK14fW
         Prf++AGRq9ULfro93+35RZMtIHiYoaxqQUr6CkSYNmiTtT1YHDEVVQqytDzdFzpcBzoU
         HSjw==
X-Forwarded-Encrypted: i=1; AJvYcCXTx0giU6j6wqAwn3nlXTcNU7JidUVL/YWaQJVZRAUjkaWskiB8QqrsSp66UXUux1PhKK/C3MY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmLYrHKgiE1E3RtesAm6xJ8ki/3+C5i5zzq2S33bkKdwrmWnld
	yT+8KQQt4C/ZyQzxJkuxdknWuUZXF16DD/FpjYGJJ0G2c3KGio7EH9egbzmdSlTWQhOXfbLTsyD
	TGVZfOehFglGdxiGgTQ==
X-Google-Smtp-Source: AGHT+IG4L89EaIN2eXPjkLGcoxrC+ORfJM4P6Y4KMuCicg/cPi8Y4oD53yPu3O03f+S5mbgyiQt9/c+vvm0KdwsX
X-Received: from wmbep25.prod.google.com ([2002:a05:600c:8419:b0:439:54cd:da63])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e12:b0:439:9536:fa6b with SMTP id 5b1f17b1804b1-43b04dc34d4mr64976615e9.13.1740744840263;
 Fri, 28 Feb 2025 04:14:00 -0800 (PST)
Date: Fri, 28 Feb 2025 12:13:55 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228121355.1377891-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Count pKVM stage-2 usage in secondary pagetable stats
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Count the pages used by pKVM for the guest stage-2 in memory stats under
secondary pagetable stats, similarly to what the VHE mode does.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..c2e022c41313 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1088,12 +1088,18 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 
 static void hyp_mc_free_fn(void *addr, void *unused)
 {
+	kvm_account_pgtable_pages(addr, -1);
 	free_page((unsigned long)addr);
 }
 
 static void *hyp_mc_alloc_fn(void *unused)
 {
-	return (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	void *addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+
+	if (addr)
+		kvm_account_pgtable_pages(addr, 1);
+
+	return addr;
 }
 
 void free_hyp_memcache(struct kvm_hyp_memcache *mc)

base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
-- 
2.48.1.711.g2feabab25a-goog

