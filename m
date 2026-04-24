Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFED35D615
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 08:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020560; cv=none; b=RHjZYC27Je2WEghnuav8iFqqOrfZNagL+/w6b0tTz/NpQLv2e+OGYDD2CatwOpO3aAiv9iJ6XiVu4UdoN4jahv6Tt/Z/6W0noy3UH2kNS8SeUI0DErcx6JARUtOwra1ZjPxKGXIP8gDA5h/tc8ecjXKQAs3J9WxMyJDOb/L8Oq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020560; c=relaxed/simple;
	bh=Z/tTC496ywitVhvJ/ad7HqkXUo6IunUgRhcenzo55AU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TKJx1AFWEEBlQhYX8Q+1uRMy/H1Odcwcpnk/f3dAt5pD5ka4EZfXByCvwlrlyNvEMtj9kcxt21PtbZR8rmrsLdM9lxfTVs2xbKykbLt6TBWMQddptgxFVu9OJMjagfX0I4pxVXlORsJeyKNTjSk0UCIAnjp6fDoVZSMB4/z4BRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JaD6xVn2; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JaD6xVn2"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43efc93e4f6so6130038f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 01:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777020556; x=1777625356; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tqPUzeIZ3aoS8p3NlrhVF5/x2KSp4t36eDNrPTZ/mqs=;
        b=JaD6xVn2KSJcMaK1MJfrY42KBKCnytaOw7LZwHm5Nx1v1ea3K4k3d2KuO/1p2Z7ICX
         XHW1ysrMExHpkcyrPxmhTop2okU+gxJBJfO0EbcGWHH73pGAH/4A36hFVHJGI+sN3TVt
         BvN+mTfIdnZJd41W+E5e8nKjtjiQxG1zxQJIgB1s3P6li1oJlvsYRlcsEJYhQSQ0Qjw9
         YcN62dPNJ/sGbY3IMvuJKO0OgjU5E3Ks5/lhoOHNq1t6QiYTUKFtUbRAJhYG0aJHcjaK
         CCcIjSIWkwzrkiy922AkKY1K36YHF/hhVB6nXUU9ZU41FO42ckqo1Y0ai/2eRJR3iYNd
         8Hrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777020556; x=1777625356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tqPUzeIZ3aoS8p3NlrhVF5/x2KSp4t36eDNrPTZ/mqs=;
        b=AN9Yni2RKoqaTOuLcXc65tvh4elz0/NQt8n+UOflr7x8w+a2oCjNhPWwYaANdxBxkd
         Ju+jhJVK5KXVMY0LMYDyl6No/ez57CWmL9nVIRBL+Opurx8sebWVQ3cIg4AV9XiD0w+S
         XJKGRVXRdZBOj7vdtMzGXN/JcddoMPigIU1kkRWnrSe/9x6WX7busfjbGTxz+0CX+u99
         00QceZ1rjy/BKXphUXCBq9bTzyViwj460CSbdHX1TQuZbqzWiiu3jzOY8K5+sj/8M91L
         DjRqbUfb7fFHJ21Hgc9+vWodBpDjJb/1Q3xCDM4lkMP4DD90EsiKz7FYlqNQkNKDXwix
         p7vg==
X-Gm-Message-State: AOJu0YyQoo2IVy2G6te+T+/nQzU/u0DkUq5B/qj1zdThBNJBd7J70Fh+
	J0x9qZfVNK/sEd+ItXATK0v4Fvfwkd2EXlS3d4DJaDcz0vrgKkl+T9av5FdXlZljXP+qTqUTato
	OX8hJyrdIaWjCdI+/3d/EQwHiVCu2CYPpMzKj127Rh8yF8SqIQTUUy6BgMwidyNwt7Kitleqq0z
	NJfwj3Op+GWPFNlgm02HVAHPlBVpvAbJA=
X-Received: from wma12.prod.google.com ([2002:a05:600c:890c:b0:485:40d2:1ebf])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c090:b0:488:c744:49b
 with SMTP id 5b1f17b1804b1-488fb74a53dmr326821365e9.7.1777020555512; Fri, 24
 Apr 2026 01:49:15 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:49:08 +0100
In-Reply-To: <20260424084908.370776-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260424084908.370776-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424084908.370776-7-tabba@google.com>
Subject: [PATCH 6/6] KVM: arm64: Fix initialisation order in __pkvm_init_finalise()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Cc: tabba@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oupton@kernel.org, qperret@google.com, suzuki.poulose@arm.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

fix_host_ownership() walks the hypervisor's stage-1 page-table to
adjust the host's stage-2 accordingly. Any such adjustment that
requires cache maintenance operations depends on the per-CPU hyp
fixmap being present. However, fix_host_ownership() is currently
called before fix_hyp_pgtable_refcnt() and hyp_create_fixmap(), so
the fixmap does not yet exist when it runs.

This is benign today because the host stage-2 starts empty and no
CMOs are needed, but it becomes a latent crash as soon as
fix_host_ownership() is extended to operate on a non-empty
page-table.

Reorder the calls so that fix_hyp_pgtable_refcnt() and
hyp_create_fixmap() complete before fix_host_ownership() is invoked.

Fixes: 0d16d12eb26e ("KVM: arm64: Fix-up hyp stage-1 refcounts for all pages mapped at EL2")
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index d8e5b563fd3d..d461981616d9 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -312,10 +312,6 @@ void __noreturn __pkvm_init_finalise(void)
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
-	ret = fix_host_ownership();
-	if (ret)
-		goto out;
-
 	ret = fix_hyp_pgtable_refcnt();
 	if (ret)
 		goto out;
@@ -324,6 +320,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = fix_host_ownership();
+	if (ret)
+		goto out;
+
 	ret = hyp_ffa_init(ffa_proxy_pages);
 	if (ret)
 		goto out;
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

