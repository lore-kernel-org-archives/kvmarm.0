Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CC332ED4D
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 13:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598584; cv=none; b=mNa6sw6DyCWZnR+rk8IqmVWjP898Ij5bxgPRJl2oB134UXmnmaCV7OwqI4+tNcYSchruK9bMp5vPHLjdH7ndsx7Jvf8zxQSvw/CLC1NnF4GE13eLX3gpjkOnNTNLDggLUuoMG6OgmB+POidu9lsAKzAvwixeplReeIJUCUYK8OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598584; c=relaxed/simple;
	bh=MgG36VJmw214zv4sHqDEvyy0doXE0b66hEX+1oPfR84=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GauzH2Z+fytNU5t4W9n1jju7cZ92Cq7/Zesswcth7Tsp0F7YYYXv0PzWDxmg6Db55KuOTBG7r3YSEUskAq5I7D4Fps64Umgl2qDEpd2qKuuOQbIyYysktGb5+nHwetyqO4+aZcCeKemB/gTjawPUgyLYMYkUK+bACxGYZDIWWac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lrqccS+w; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lrqccS+w"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45dd7b15a64so6742035e9.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 06:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757598581; x=1758203381; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJBOYBviiAkHEGuAebJYs1rSMwBP/rg8f5sw3Y1zhrU=;
        b=lrqccS+wYE7AG05McX2NtSttYIQ7rn2yRvx+kD+1BEl7NzziX0TnsAbzr/1b4flDMk
         ySeUT0CTCwMfCUqZjM/Jvn/GJnltmTgN4Q1gKVNMFcwCSYMNyOj0DN0qPuARh3QTvLIS
         WCYtLfwSnSxJV9AYGOsvH9pi4iM14Zx28DQlAjQvBGDep7K01dU8umgLQw2EJi7dJlh3
         WS37sXqN/SnoH7lKYeo4w9NmL51k9cPt8lova9xlhHPFnY75YuBMzq0AUwTkPTKkDjv9
         oRUiPLWaj6dTql11KeU1MA4JV5GSM+yXrIKVpz+fwFiauJaomPLf6bZXAcC5x7HOJr7J
         bggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757598581; x=1758203381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJBOYBviiAkHEGuAebJYs1rSMwBP/rg8f5sw3Y1zhrU=;
        b=UvMS4NCUHOfu5TqN8GxyYQPLAPXxmIB1i/q19HgzkdiCqsZXTsnV6NBJVG4EB1NIB5
         sU4DrAIC0r0nzKZ9OgQGcn4QGpzT+DZ6Pod8NWYrHJ5tasQKelwXorVu7CICeHqhIJem
         /+hSdT5sIrdRMsXXZuY1LrqRowpSPVm8upNazmdgyGSD4zQvxQZCeTx/PbtQApgaKsYH
         dqb0KIZxm+SysKDJ2lx6LnTkLh+X5PfPp33zoHmzXgS7igkeBFuYD2HKdKvYO1Tgo+Rz
         7MqEAnYfmWYxrH53R0qVELSYq2lwjJMjPcIiJD8W33e9plidt6EK7bMYpHPrygtu6q/L
         Lm4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWAX1fEnzvVE2HjLMEUfwTGuWW9ePwCjX23q58lS8Df4dOGS1w0BgvCu9WNpz62EwjqJw1mceo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbSh/pZUM/MVvVrJDqou3sFEPMXwvEkATJ30tlYJKlYdLx6kk6
	52kp5JdR35botlDqpmupGJiq0xW0NlJfc2Hne45C8PoockHwLXct4OGn
X-Gm-Gg: ASbGncsCRvheq+hbj1+karAdpVATAyEmJAQ40meTPq4GRu0LO3aSEk6GiuFr/CIFqso
	MVBAeGRCpv/pZSdW+8X2DGhHtM04vEDpsn/QF4LnrvDBWtwch/oF19wTPNXCVyzB7/mv//xFtE/
	d4IzieD+AipNf2CwXTIvuOo3UztOLquD86d9M/Xs6aWy0YAWvS5a0rasT2TpVM8ynVBpivDwm8y
	ZNOUV0lmw4PCrQ2TR7N+PDTobox2qG3msUhmi4m66sQ2oquPqf1p2p9W8Zl1f8llcxyp1AxcyHa
	qqkWNFP7UesuPUBC/0Ka3bn8uuAEPxbjzkx9gQIje3nCxUhhBSnL23NWWa7XmViny5s4YlY1AJY
	saOfvAOlbk8s6jPTPTe/xrYpn/maRAhJPn2n3XWwfdla69BzxxvwVriviXDAXBQ==
X-Google-Smtp-Source: AGHT+IF9gYWYpXj1cgrspFLvRu0yrW6lKAr/MmACXhsm2WBvm6knLxYnlrbbjGF1EG0D4ZDyCrnxvA==
X-Received: by 2002:a05:600c:a103:b0:45b:910c:adf with SMTP id 5b1f17b1804b1-45dfd5e3d68mr29948455e9.12.1757598580729;
        Thu, 11 Sep 2025 06:49:40 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760778915sm2608361f8f.12.2025.09.11.06.49.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Sep 2025 06:49:40 -0700 (PDT)
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
Subject: [PATCH 1/6] KVM: arm64: Add __gmem_abort and __user_mem_abort
Date: Thu, 11 Sep 2025 14:46:43 +0100
Message-Id: <20250911134648.58945-2-jackabt.amazon@gmail.com>
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

Adding __gmem_abort and __user_mem_abort that preserve -EAGAIN results.
These will be used by the pre-fault implementation which needs to retry
on -EAGAIN.

Also add an optional page_size output parameter to __user_mem_abort to
return the VMA page size, which will be needed for pre-faulting.

No functional changes are intended

Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 arch/arm64/kvm/mmu.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a36426ccd9b5..082e7d8ae655 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1521,9 +1521,9 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 
 #define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
 
-static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-		      struct kvm_s2_trans *nested,
-		      struct kvm_memory_slot *memslot, bool is_perm)
+static int __gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			struct kvm_s2_trans *nested,
+			struct kvm_memory_slot *memslot, bool is_perm)
 {
 	bool write_fault, exec_fault, writable;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
@@ -1592,13 +1592,22 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (writable && !ret)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
+	return ret;
+}
+
+static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+		      struct kvm_s2_trans *nested,
+		      struct kvm_memory_slot *memslot, bool is_perm)
+{
+	int ret = __gmem_abort(vcpu, fault_ipa, nested, memslot, is_perm);
 	return ret != -EAGAIN ? ret : 0;
 }
 
-static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-			  struct kvm_s2_trans *nested,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  bool fault_is_perm)
+static int __user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			    struct kvm_s2_trans *nested,
+			    struct kvm_memory_slot *memslot,
+			    long *page_size, unsigned long hva,
+			    bool fault_is_perm)
 {
 	int ret = 0;
 	bool topup_memcache;
@@ -1871,10 +1880,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	kvm_release_faultin_page(kvm, page, !!ret, writable);
 	kvm_fault_unlock(kvm);
 
+	if (page_size)
+		*page_size = vma_pagesize;
+
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
+	return ret;
+}
+
+static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			  struct kvm_s2_trans *nested,
+			  struct kvm_memory_slot *memslot, unsigned long hva,
+			  bool fault_is_perm)
+{
+	int ret = __user_mem_abort(vcpu, fault_ipa, nested, memslot, NULL,
+			    hva, fault_is_perm);
 	return ret != -EAGAIN ? ret : 0;
 }
 
-- 
2.43.0

