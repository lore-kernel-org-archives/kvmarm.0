Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0148F202C31
	for <kvmarm@lists.linux.dev>; Thu,  9 Jan 2025 20:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455800; cv=none; b=ILQUSs7elXvdWhIFh+Fmd0Pc2/SUJlaCwrZ90Ut9Dpiz2R3yW1V+xOJ+HLNJ7BI+lyUYdr2UIn7SYqbDe2HsdZkLFJmmm0a5XATQazDT8qHcnKnIbuFMcVcVnR9yBYNGwnCswOoDTSArELT2pKlygcrdghZ+rI7gzOhIaICD7AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455800; c=relaxed/simple;
	bh=HNfpPbc0B5+oiokqFlBEDy9D4Azs1/AaYZmxA0SH3Sc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ws3ZRyLqMHz1zWEpeanrsVUTq/OXN9QYbazuAxrHBrOpxa7G0Qmu/hHpkAzU/ZOKCBj2vyyDdibph5PqazWtBP1Ey0tYaWJHH+6VgPa+DE01wyZFPnvMk2QXrEZofsBNn/AEwtGeQN8iQjjhdefkOumD1v3VvuY9ElUAZztw11s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aJvLI3qB; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aJvLI3qB"
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4afeeffa85fso145056137.2
        for <kvmarm@lists.linux.dev>; Thu, 09 Jan 2025 12:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455798; x=1737060598; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sy46ZKdMOYPNfFozinwrK5U4YnAl6mgCHSprJv2I5EE=;
        b=aJvLI3qBmwiDkq2y5R+NtaxYYyBi3/buKGLKzu2O3c6SOwienqX/2+N9xtZMlRPT8X
         Bv8JxqO8giIUPAB+PLLeJyvIQP9zPLrtM7Lb7MqqRjFYqvs4a6MKxtrR+R6iC+zcveb+
         WjOt9zwVnqV0EGAe6QaP5LGLI4vqUwVTGvDUQ1EJAKDNvmrs9HMgMKdC+RyJqd/bINIs
         nFrk3GoA691aoPqDvzODbMPhydY1N7qpaqnELvTljW4XdBEQPwpraWz7Auykah9XvcZ8
         6hJnBOmpJVwlbDU/B0NeNPof0tV6id8b16OWCGH65nxMdZS+8/GOnX1yIAI5jlH+WPbb
         7x8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455798; x=1737060598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sy46ZKdMOYPNfFozinwrK5U4YnAl6mgCHSprJv2I5EE=;
        b=UevGuk+xF+DPTs7+AGyFlQANdacstvogLROn97XEu5auqCvIvsq2TsnD+8j6F0pWCw
         v5erb7yuj11Gbih9g5F4olCj1KihCNtp0br9NMS6fM04dpXz/U5Jtl7oohTFe5y4NHUF
         6s8wKJo1eqqbiub/W6cBwqym8BGRHx54LTnCBHS+pz6SwaNqi7t8qW6Tshnom3jWfjVv
         lUwTe0p6oFZ0uQqNnXGqQ5Z6g5ChldrEJlbips+fnpFD0RkUUz5bh1vzf2rVfJr5v37J
         NNEn5Io/F3v0n/JV5aThC/qavMi3wARheeQFxT3KsfHSHn9VSVwY8nCeWlso8A8y/4nN
         RoMw==
X-Forwarded-Encrypted: i=1; AJvYcCUofnL+iBaKXYVJk4g3WdPLEsX4CzYlpBngPTIvis+WXNinmalW7o44U24Pzpi+8YqJ4IZ8V+U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOaLUcaMbWdvsyQ56Ia1KNXpy2muOvobcQHzgFA2mF0fZ9t7sO
	RChtSlXdwmCL33K0ajjIMquzKQoZ0xrwor0n0tH7KoHStzqU6aFbhanuXxBiYr3/faPWojkfAx7
	iCxJIqd8lA53hyp3Kiw==
X-Google-Smtp-Source: AGHT+IGxjoRseI0ptp1PpNGkamYSZpMVzGlMOrPqkiBhNVZ0uPSquo0Jh6/07xFgWyNiCB/pmTP7I9swsH2tkGpZ
X-Received: from vsvj16.prod.google.com ([2002:a05:6102:3e10:b0:4b4:f067:c6f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:c12:b0:4b1:1a11:fe3 with SMTP id ada2fe7eead31-4b3d0f15e35mr7763898137.8.1736455797824;
 Thu, 09 Jan 2025 12:49:57 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:19 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-4-jthoughton@google.com>
Subject: [PATCH v2 03/13] KVM: Allow late setting of KVM_MEM_USERFAULT on
 guest_memfd memslot
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
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
index 4bceae6a6401..882c1f7b4aa8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2015,9 +2015,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		/* Private memslots are immutable, they can only be deleted. */
-		if (mem->flags & KVM_MEM_GUEST_MEMFD)
-			return -EINVAL;
 		if ((mem->userspace_addr != old->userspace_addr) ||
 		    (npages != old->npages) ||
 		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
@@ -2031,6 +2028,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
@@ -2046,7 +2053,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new->npages = npages;
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
-	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
+	if (mem->flags & KVM_MEM_GUEST_MEMFD && change == KVM_MR_CREATE) {
 		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
 		if (r)
 			goto out;
-- 
2.47.1.613.gc27f4b7a9f-goog

