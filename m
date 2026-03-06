Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240983AE6F6
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805769; cv=none; b=dOKMYb5YAcXP6vT4VccHe5jOHRRLTwh0gMM6gQFi8R79kHA89SBwvAKm9HN8bW1WXqCCNY0WFCbzCud0OQgiXFuZ+To5JR/rFui1WbycR5pzcyNeicnaXLV9A46yvryToolwGrciP/Kbf3pqFevP7XFNOuG08DhpXuESWRme2Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805769; c=relaxed/simple;
	bh=S/H77lj1fZtAFs64c4lKzj+C7fMo4gZ7VAm/tqW8ncs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h4Jzgj/whGP4R6d2mkvrsb3QIUoBZKdGVwI8QQWh0YKb8DEZzytAtZE4QhsP9OApQT9a/iBbqgWypTyebhR3F/ouY/93uP5Te/W66Awnw5xY4ma+k8ALoEjOHVcextQZFKARjjeoJynDKVAmlJrQRGjud1qOsF6tOYpDcWCqTG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lW3wSoET; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lW3wSoET"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-66142e571c9so2088504a12.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805765; x=1773410565; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YPUDEvHAsE2et1uSdvC7qqWK/vawe6dJIioQ+SXcGgU=;
        b=lW3wSoETU/GBDISiJl4TUEc18mIl5qSsb/bGYsxVWiVBlzi8FdlkTu9NhuU2xqi1MZ
         LF6Ny4nAU2qj+kznGKAb7BZ1xzgJghXJIfrAGDtsDwMTBHpIMA76wnzdhVZaDHTnL2jr
         yHntEpeQT1Et0ODyAq1clXQi3jzb0HAMbWZSHSXQJul07hThaUUQzljdGkVVKoKMcuMs
         MgfbySOegmNyXdtFZ9c89a4ybhvA2sdPRUC7eBjWIXVOag7GKe/SQCxwie4hEdppmZV4
         95ZM8fDtBRHlS4nNk+/1hHeciKdrSmah5LH544YbRucb3nmbks4TvVJDROXR5xie9Qd8
         WKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805765; x=1773410565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YPUDEvHAsE2et1uSdvC7qqWK/vawe6dJIioQ+SXcGgU=;
        b=wCx44Rsd+ePG/pKquT5gDIw/skS5hAasIMkjQuLH9TSNZnvbsp74mONF+jtHHkJiS9
         ZzA2THBgaDlRWjTyrx7Z5PMVnETOwjOnE996sBSU+hkRzGA8+Esmf72ysDV3NooMKcQl
         kM2uAmZtLCOkH+3pDmJp9rnAR+uJF76AQgDmHazQBxqQQol9Ec3MpSigr4r3RA+ytkL5
         a9T82Ey0TZNhUEBCjP3IaliTTgNt+FcZp6JrKhTYru8pver6138Unb7/+b5y6X5mmbzQ
         TVfnTjDyTvLDMcEw8swdTmQHEm7vbF5wBLxdgdtr1zS4CGz/QqQvmjYvqGLmsX8E1YwX
         fBGA==
X-Forwarded-Encrypted: i=1; AJvYcCWC8oBk47HkLhCVDtHs8iCvfNyPppATD/5j28y17+rVtCmjckhk9CvrEq39PLcjU+Zuf2Ti7r0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIBN3FKwcevKVhdy1BsrKz/ryM9pxnDnURWfUZj8EMYXHQjJjs
	a/S+fMrXyAe9oXjOZ6aq1znJi1PKqUzYxDHAfP5mIlX4ee+9J8zC9zwMVoSecXL4PNCLBHFOZUY
	H7Q==
X-Received: from edqe20.prod.google.com ([2002:a50:fb94:0:b0:660:bf3b:b289])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1e8e:b0:65c:209e:32c4
 with SMTP id 4fb4d7f45d1cf-6619d51fd74mr1077641a12.20.1772805764944; Fri, 06
 Mar 2026 06:02:44 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:28 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-10-tabba@google.com>
Subject: [PATCH v1 09/13] KVM: arm64: Simplify return logic in user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

With the refactoring done, the final return block of user_mem_abort()
can be tidied up a bit more.

Clean up the trailing edge by dropping the unnecessary assignment,
collapsing the return evaluation for kvm_s2_fault_compute_prot(), and
tail calling kvm_s2_fault_map() directly.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 01f4f4bee155..35bcacba5800 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2005,22 +2005,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (ret != 1)
 		return ret;
 
-	ret = 0;
-
 	ret = kvm_s2_fault_compute_prot(fault);
-	if (ret == 1) {
-		ret = 1; /* fault injected */
-		goto out_put_page;
+	if (ret) {
+		kvm_release_page_unused(fault->page);
+		return ret;
 	}
-	if (ret)
-		goto out_put_page;
 
-	ret = kvm_s2_fault_map(fault, memcache);
-	return ret;
-
-out_put_page:
-	kvm_release_page_unused(fault->page);
-	return ret;
+	return kvm_s2_fault_map(fault, memcache);
 }
 
 /* Resolve the access fault by making the page young again. */
-- 
2.53.0.473.g4a7958ca14-goog

