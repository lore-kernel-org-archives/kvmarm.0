Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F097016B388
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654973; cv=none; b=XYY5lKJV/1DJpKwp8jSvUR+EIHSq6imLVHFT0Q1RqmEVlaGpR0/WCrtjtxc1lKQAZHzHK3+eDXb7QARvhaaPu8TrVeT/mtQcatEcJ+3pNAAJSeVbTO/oVoh/ulMIrWryghVddRvHBQiOo30NS0a/OvbRG/RijBLzbtOPYJ9T08Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654973; c=relaxed/simple;
	bh=u+awbVx9aoPKS0xGDQreI8aQ8m7YRSIdZYPdiuLJprA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=twkceT7Zsz5mp5W9q7QyF59f/5U5J2/gdSwe8UkCNULmJF+ULtokkqSP7caR5QrIZQU/2hZGZNBw1jMRycz0A0XyRVmjb6/X1zXofOpwZvuGt/rHyhz0tUOg9QyxanxjPnPGRR31yrDPUWXpe915/ybteilQUu9qRgElNCOvmRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zRANtDau; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zRANtDau"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-65bbd01d146so4416927b3.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654971; x=1721259771; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QcajhSgtnKDY4bKjbf4ZVWmvqiJNI58ACmEJvGd9BEA=;
        b=zRANtDausoijMOkDWlc5i5Cc49HHKttKnKOfW74z5illEc8fP4UxcMzwl0ezpgewb5
         GQK0H/0b7pCEArwb/4rQBw5ItlFQpN7x6C2x6sbEa64q7mWH5k8QAf3QzzhYqgVd4ZXZ
         MiQKtzMTxMumrY62+Usmqnj+NKhiIZSSlGHOe5ikjzuDA5+ms+EgzgAjaEo8ukJK2LzV
         FPmqdl9lMYekiZs3ZgrKahn1c+AyE7zwg0W2t1qZYbOoNI+n/uAt8QOgtY1BAoWtA6qv
         4YsSnMtr9kiTPmQWfgYjRluVMlVhJgLhm86n8q2FPeeHnfv7lJTVqp7izrI1eBRswXsb
         m3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654971; x=1721259771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QcajhSgtnKDY4bKjbf4ZVWmvqiJNI58ACmEJvGd9BEA=;
        b=ATUkAdKANv1psJuJjiKW0SelV4nHwqWWGSjbkK36EKPaHFsDfgrPXOcwqLySOI6A+D
         uCmfXaJx4PQGNySDbV0J2zvwsgmMBL73aTc/6mAh/1KnrGdTB8Tc1GY3otPLOxfBqUl+
         k2ixCHCL4/J4hTM1pdr/GxwRlor99lVmfGNCmnQroZzrC1duKM5btuxoibQgSRf17eIB
         VHFYVvnpHWBTLCbIO0fuJZAP47TsCsZP58WSRt470j5bLTltChPV4yrMpZhwjb/2A3zE
         u1otRE9HnDOj/ArbbL3+UNsLfz0ruDHOfPTeOeWA1J9FjWTRZES5e0XYGDgt/rhZvJNp
         P4fg==
X-Forwarded-Encrypted: i=1; AJvYcCXUvDPNpiZu/tc+RbWQa5RAPWdtDurdDkrJbSHKg4bvPhkruLbCT1PGc582eb9Mkq0+cwU3uDwPDfLy4To62rYuDcBjL0Ja
X-Gm-Message-State: AOJu0YyL6SD07Gkrqx0/cdPS6w54ynTYY7MS6nQecmX60Eb97Dcady5t
	0Mauu+/6yo5Cq5P7MzOGqDNC5MK+zHjvSygX7oXEyTeSIn6esfgJTzWyvo/XC89Kv1M+he1iCIc
	yShVslH5ek9RUet/mQA==
X-Google-Smtp-Source: AGHT+IEC/EQtrNezpt+9blgHEpHxd1YhFnUWh0/2vBf3Usnz5Irc0nFTjIjjYgCU/UmvBPArza1QUIUaWp5gpwOj
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:6d0d:b0:61c:89a4:dd5f with
 SMTP id 00721157ae682-658ebabc90amr1126767b3.0.1720654970940; Wed, 10 Jul
 2024 16:42:50 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:17 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-14-jthoughton@google.com>
Subject: [RFC PATCH 13/18] KVM: Add atomic parameter to __gfn_to_hva_many
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Atomic translations cannot wait for userspace to resolve a userfault.
Add an atomic parameter for later use with KVM Userfault.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/kvm_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 77eb9f0de02d..4ac018cac704 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2679,7 +2679,7 @@ static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
 }
 
 static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
-				       gfn_t *nr_pages, bool write)
+				       gfn_t *nr_pages, bool write, bool atomic)
 {
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return KVM_HVA_ERR_BAD;
@@ -2699,7 +2699,7 @@ static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t
 static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 				     gfn_t *nr_pages)
 {
-	return __gfn_to_hva_many(slot, gfn, nr_pages, true);
+	return __gfn_to_hva_many(slot, gfn, nr_pages, true, false);
 }
 
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
@@ -2732,7 +2732,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_hva);
 unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot,
 				      gfn_t gfn, bool *writable)
 {
-	unsigned long hva = __gfn_to_hva_many(slot, gfn, NULL, false);
+	unsigned long hva = __gfn_to_hva_many(slot, gfn, NULL, false, false);
 
 	if (!kvm_is_error_hva(hva) && writable)
 		*writable = !memslot_is_readonly(slot);
@@ -3002,7 +3002,8 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool interruptible, bool *async,
 			       bool write_fault, bool *writable, hva_t *hva)
 {
-	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
+	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault,
+					       atomic);
 
 	if (hva)
 		*hva = addr;
@@ -3074,7 +3075,7 @@ int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 	unsigned long addr;
 	gfn_t entry = 0;
 
-	addr = gfn_to_hva_many(slot, gfn, &entry);
+	addr = __gfn_to_hva_many(slot, gfn, &entry, true, true);
 	if (kvm_is_error_hva(addr))
 		return -1;
 
-- 
2.45.2.993.g49e7a77208-goog

