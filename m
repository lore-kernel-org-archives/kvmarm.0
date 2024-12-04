Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com [209.85.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FACE1C3C0F
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339660; cv=none; b=SrlHg0+ML3WFCLXtgOe9epuESkvfj01O7NQY4f8xLjsvGrut8oKFm6WPIraxs/xZcoQuU5adKUVQuI6ae9mDM5lHtEAIYBV1WYw37NNMcbvMTUvBANiU742dofZNMnVwmzYfkM6kWiQvuONYOq6Wt3JoLJkyr9SkgTkLvtnx7RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339660; c=relaxed/simple;
	bh=gwG4wHoxIC9ohviESrC4i1SBquoILkHgmJR3YvyQL40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=agOquxNGbS6aMDwq7yCj9lwdyMR7RqCh116k0D8/ex3p4AnMWk9vKFq7kXl8rZnIRRUvaSDwgEiehv6a/JokKGt6sUDrxspJXOLmEcDZCzXCGAZR+duIExZjsezetRmCjZdvXFcPfEfOYj4Fx7cuLYWIf0Lf17CRZfc2pOvFuFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dvgLItVj; arc=none smtp.client-ip=209.85.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dvgLItVj"
Received: by mail-vk1-f201.google.com with SMTP id 71dfb90a1353d-515d74fff8cso18099e0c.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339658; x=1733944458; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rnZJyT6N3r8vTjoa4UcLa/XGdQ+PqihxUkrotorxiRo=;
        b=dvgLItVjEkCZLQ6q1ZKVJpVat9FleN8JfngZNLET9dAkutmeEuhqCqXi3CMIaCNXCo
         6teMV+LjQcfyeYAF1ch4gNF0ZW9rzHMQ7jQEg8RS608xZRqg6zJ1d4ZKfJPasS8ydIfj
         HSg7jf0aakXWgj8B5m6f2XU/U9qk/dAa9vGy9bCBsfBB8JNU/Ph7jj/LK50h76AamTSp
         4N/ULvOEElt0xbHVRRU71HIpb9e9qnkZYAf93+v7wPEjf8tFFkdusLZbQIKIj+fvWXsH
         2AnzIcKdnwJ4EGUM4HAHqJJav9zxNgIVhg2qaoD7uQdtyxUZcS3Qm5LkHJGxXr1rvwIl
         5Ydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339658; x=1733944458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rnZJyT6N3r8vTjoa4UcLa/XGdQ+PqihxUkrotorxiRo=;
        b=Zg+Mjx3OkgBi8Otq1R6sHsR4w2QornZAwDy9JcqIGqTUqRcu9qfRwVlWBUdnmR22P2
         9v7lFDKbWSjpJGVuJyScgG5onfSmg5zZsvy3izgptCqEybDegMqTMhAVs9mTxso4ICQ4
         TCjeohyNXEZLOtcU3Hd/yvz7GtTrl1ej4SeR9ptBq35f1b3M3vATYtw2b0wWoa9IWGJ5
         Dsf6AIcOak6ql8c5/V2pWZWqK3BjeO9k7ElSKPWBtFgnY4CskJuXCDmrrvgevo5LJROu
         wXcGcbiASDQMnLL+DFNqubyArAQQYKxvfbpP9CeVVx4ccxfjb8OxzG21PFcJVW5ZujYR
         4ZCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVe/hMfL5/jPhmdAjEg8XAREQH7pbnh4PdioDzSNQA6RqraEk5ruQ/d1QIHErT3P8Nwr3hZe4I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwyHvx1+3pgG8lBAjYO//1ZnMA/NDseMPVFe5wAWXYdwNRDsy3B
	jPZtPrDekFETbmFhDaRxHz/8qRe5gXN+92jQvMWys1/A7QstsTk+AEoYY/n7ldcv/UL7uB9p/SR
	3eL5AnpPmVwncB6B2fg==
X-Google-Smtp-Source: AGHT+IHeflh53wCdtG/eOTj3NVvzDZ1TR16bpwDBvuZyMyTF5KFF0ZrmPFZ5n9dphqqxj6PK08wZjYTOW77Q8bPv
X-Received: from vkbfc18.prod.google.com ([2002:a05:6122:4b12:b0:50d:6d20:c212])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:8d0:b0:50d:4cb8:5aef with SMTP id 71dfb90a1353d-515bf2ff82amr10640137e0c.6.1733339657905;
 Wed, 04 Dec 2024 11:14:17 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:38 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-4-jthoughton@google.com>
Subject: [PATCH v1 03/13] KVM: Allow late setting of KVM_MEM_USERFAULT on
 guest_memfd memslot
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Currently guest_memfd memslots can only be deleted. Slightly change the
logic to allow KVM_MR_FLAGS_ONLY changes when the only flag being
changed is KVM_MEM_USERFAULT.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/kvm_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 23fa3e911c4e..fa851704db94 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2009,9 +2009,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		/* Private memslots are immutable, they can only be deleted. */
-		if (mem->flags & KVM_MEM_GUEST_MEMFD)
-			return -EINVAL;
 		if ((mem->userspace_addr != old->userspace_addr) ||
 		    (npages != old->npages) ||
 		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
@@ -2025,6 +2022,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			return 0;
 	}
 
+	/*
+	 * Except for being able to set KVM_MEM_USERFAULT, private memslots are
+	 * immutable, they can only be deleted.
+	 */
+	if (mem->flags & KVM_MEM_GUEST_MEMFD &&
+	    !(change == KVM_MR_CREATE ||
+	      (change == KVM_MR_FLAGS_ONLY &&
+	       (mem->flags ^ old->flags) == KVM_MEM_USERFAULT)))
+		return -EINVAL;
+
 	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
 	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
 		return -EEXIST;
@@ -2040,7 +2047,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new->npages = npages;
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
-	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
+	if (mem->flags & KVM_MEM_GUEST_MEMFD && change == KVM_MR_CREATE) {
 		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
 		if (r)
 			goto out;
-- 
2.47.0.338.g60cca15819-goog

