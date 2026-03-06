Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179A53115BD
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805775; cv=none; b=SwWae9P3+sQvEH9oGDotqKTMSLBpa7yJWICFYdpgbEvdsAhpHSIEe7876V8RjcGa9pGfN0fxvC0fd/9QDMKXMFcM0IQEnaoKtT0uWu4tGufhtWWR22KwuT+BOgL3JNAaH+4KPqty+tsd+E9V0ukUhXinCif5DOxMh0wY9RAixdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805775; c=relaxed/simple;
	bh=V6eWiKg9V+W/g+hdyI2Ge2Jz2TlMcvvQDPsYm+0vBKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PYvqP9/HQooF9JJMYxEdwWEdzgfZM1z6hxloGUUn/HL7tR8c6rmeuBW6QLzoyqwbGVGm6n6mGF3Sl7cGbxWBmJjjRAKrDH82JQi6QOehzAUj6LZLKmvOJ/12ZJ4gNkZOM7wA2QY0Eenad0FknaiZy+k4iwIKKIeeLDtlw9dWj8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kDbdUH7G; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kDbdUH7G"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6618bc12875so1259128a12.2
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805771; x=1773410571; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jrYglMPFnkSqWiX5InhsukY4+nR7R4qhDkeT1Y7YXwI=;
        b=kDbdUH7GDPlt4c+NJ2WDpstpkmZ4wIzRk7IL0fV1ngGZnO9NKqgK5RlKWW7y2Hdxw6
         5Qhf08sX0P2EA5Haue0kPRbfKDuKO+C34Ozu40JpFBFL8ngLXqV7J1YJ3i93fHvDJaPF
         zErZBbTsAzSGgANb8hobqX1Skp+LdXp8yUpkEsc1d5kbeHBVD8GIIQq1EzElAloqSyAn
         cbodgYxmshqeb5yMHXRUYdJnwlNHvaw60wb4iY1jUqHiOTYZhgOf0du+oHQ3YCPMFcNS
         KcLESEDvMKR3Gk4mQ7S+uVC5QWyIa3gNcVM4jaszt9oZZJDByYwk+hDmvLXst2+G6acS
         UJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805771; x=1773410571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jrYglMPFnkSqWiX5InhsukY4+nR7R4qhDkeT1Y7YXwI=;
        b=KRyrf0pOWSTLwsBNJshRDIzMmuN+9WumXZ81PsBQ4dj6cvR4Hxt2NdI1lVJ1nQw8G9
         u0RW/Tb8lZWyIrbof9ZjiblQot76nXQTnKEbCovECkVBanObWO+qZoU0i2g5YpKwPk9L
         WaWxF4Yv/Zm7YXIPPaD3uYfIpbu2KVTsNOr0Sf5q2JJSgsMEovvR7SUXtHUPCbdk9l2R
         Fcv79KX7nEnt9Dzg8yWqvpIn21sIajWs5lFs8JZuyUqZ9XGvDeI7judQmbUDgmU0+Wp/
         i4TchPF4nRKOKrUysVV5oRBfYGghjpO2kC9l4YPDq974FjI6KsWWwBrs9h6HJ5jmfZ5b
         s3WA==
X-Forwarded-Encrypted: i=1; AJvYcCVF7UOT5yl0C/9meNxjNYeEeEbCUN/UPUp3Y4r/iTWBzlcy/IDBYkHjq7mS4Xp5l+yZmrB8Qgc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhMo5sgWrDXeJtW+R3hx3cUVRucgcmnK/r3hmIXru438aBLf1q
	Z+K/scHuZFX9U6Bb15egwLcdjHHjK3I9GihMXXyLYuPMh77Fg2i9tMuTeBsR4AXHplf0nhQKu5k
	4wQ==
X-Received: from edrc1.prod.google.com ([2002:aa7:d601:0:b0:660:cb32:1c97])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:354f:b0:660:d9c1:1919
 with SMTP id 4fb4d7f45d1cf-6619d51ea6cmr1251752a12.18.1772805770063; Fri, 06
 Mar 2026 06:02:50 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:32 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-14-tabba@google.com>
Subject: [PATCH v1 13/13] KVM: arm64: Clean up control flow in kvm_s2_fault_map()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Clean up the KVM MMU lock retry loop by pre-assigning the error code.
Add clear braces to the THP adjustment integration for readability, and
safely unnest the transparent hugepage logic branches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cc6b35efcee5..5542a50dc8a6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1897,10 +1897,9 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 
 	kvm_fault_lock(kvm);
 	pgt = fault->vcpu->arch.hw_mmu->pgt;
-	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
-		ret = -EAGAIN;
+	ret = -EAGAIN;
+	if (mmu_invalidate_retry(kvm, fault->mmu_seq))
 		goto out_unlock;
-	}
 
 	/*
 	 * If we are not forced to use fault->page mapping, check if we are
@@ -1908,16 +1907,17 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 	 */
 	if (fault->vma_pagesize == PAGE_SIZE &&
 	    !(fault->force_pte || fault->s2_force_noncacheable)) {
-		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE)
+		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE) {
 			fault->vma_pagesize = fault->fault_granule;
-		else
+		} else {
 			fault->vma_pagesize = transparent_hugepage_adjust(kvm, fault->memslot,
 									  fault->hva, &fault->pfn,
 									  &fault->fault_ipa);
 
-		if (fault->vma_pagesize < 0) {
-			ret = fault->vma_pagesize;
-			goto out_unlock;
+			if (fault->vma_pagesize < 0) {
+				ret = fault->vma_pagesize;
+				goto out_unlock;
+			}
 		}
 	}
 
@@ -1951,7 +1951,9 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 	if (fault->writable && !ret)
 		mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
 
-	return ret != -EAGAIN ? ret : 0;
+	if (ret != -EAGAIN)
+		return ret;
+	return 0;
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-- 
2.53.0.473.g4a7958ca14-goog

