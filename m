Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC8815B147
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654965; cv=none; b=Ax31BoozGYx8Zw4dIyfnC9BelVunc+yZCtw8/7EcnxpFmcyPihR9Uj+sDgJDaZ3M6Y9+kbUxEZ2rW/9ho0Oa4rQ/QqjvRdRhZxOJzgxzvBPn1JYr5gSZVURN/ETrvRwCmD/WGUXV+qGnPn8QhyxfS/cLIBmvQvfjyeUXA4oz/Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654965; c=relaxed/simple;
	bh=9qd4I5Nt4ZpEq1/DgTQG1WlNzpdV6maR7Ymqr0dBes4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qx7+S6qPTbeVPOUpsX0I5lfNuAoaEwyKoZYiG7hcB1LRLTxa4l4heSrLikXJYSXk6BzMsSyKmk6hsKCA+8V3zC72cZ4XJPelY/UPiBH+wnymB4YbEckCOn7LRoblcwbM8VY+e3nom5TMhaG0iI4vUWl56ruyWLqkrzlSRGppUEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A4w/y0qw; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A4w/y0qw"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e036440617fso506249276.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654963; x=1721259763; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d8Rmzp/FnvTnt3i+tgLuvGyYDZdc9771iECvmROSKp8=;
        b=A4w/y0qwDaZv5unqXOKwFJuJHGLyo7IK9ct+bJRazFGVqseGa9R2GP7GaVEzLPs4UA
         BoQWa1/Jqycb9ZRFmDob9Bs0XY0f2fKejZHymbZe52qEudi8OsUpC949JeKdNEafCE9m
         p5hunS9TYDQk+Ij2z3npZYtwKnxk3qPzzDBJMCFEOE3bV8slLLD7EXD2yGwuciRdEI0n
         +DpdF0kC06Gq1OHORm2KB0pB1AXJuK4SIuRLpeQMe/SrXDDm6Ul1pbgmq8qGp2uOM2QS
         NPW9qlFCDOTkNkqu3+MMcgc69ScJK/xWRaWUmsjpb2rwnc2bC0amkmT9nEfHBk5K9k/0
         bJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654963; x=1721259763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d8Rmzp/FnvTnt3i+tgLuvGyYDZdc9771iECvmROSKp8=;
        b=Oic9msbTbrnRZX/WfF5DERudvsSdSDzOsYO/vRQuo/jSuGSkTmjqZkMrf7XYNMe8Jg
         eCqAidIrXotzzF1Qvkg1QNTqIVYM9/VDllcDxuwQFAe9MojGmfk1XVwNL2xDWNeKgwHv
         MHAmDBAUPGonu6Pnj5nzevUp1Rg2ejQSSzxOOoCqDXblxFAgJ2ODWVhNCc59xE/kQEvr
         NB1465hvttg/h8HPeCaxT0gxk8rgRcux6eroXEd+wR/beBLBgNyxTm6nt3aLBYXTVPKn
         e9Jei5JCzA9a6t7W3wiThavGZhBx3zI3wR0YczPiLUUINIj+b8KxmyDzKc2+VYP46Yy3
         TUBw==
X-Forwarded-Encrypted: i=1; AJvYcCWrsjnFvdtOuCRZtpG+ZUvN74HxYeGI3ayGyUQNrpkq+12N7CVLGx//gx+g2zv65oR5zEG2KMZC1ilORJKc6QRRCBY3YS2K
X-Gm-Message-State: AOJu0YyjQC1hk4YUiFJRKxguE102vW4Hn4Eyxtslx7wumnqyMrdwO9k4
	uaJv4936DbPQ7MWX4H6LXs0Mxyd5/hQ1ib4VfMIy3u6shsackhMp8+lZYdUoYgRLWUOnTeY2q2a
	HbvcSrHngnA3on1yC0A==
X-Google-Smtp-Source: AGHT+IGzfu/is15/zbZN55ThZYoCmQ5oYPE0p+29NB0c/bvGkmqxURl5E0ogcz1hwkdaxZ/C24+OiRdX8VZRICmx
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2101:b0:e03:31ec:8a24 with
 SMTP id 3f1490d57ef6-e041b17dfb5mr382792276.8.1720654962919; Wed, 10 Jul 2024
 16:42:42 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:09 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-6-jthoughton@google.com>
Subject: [RFC PATCH 05/18] KVM: Add KVM_PFN_ERR_USERFAULT
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

When a GFN -> HVA translation (__gfn_to_hva_many()) fails with
KVM_HVA_ERR_USERFAULT as part of a GFN -> PFN conversion
(__gfn_to_pfn_memslot()), we need to return some kind of KVM_PFN_ERR.

Introduce a new KVM_PFN_ERR_USERFAULT so that callers know that it is a
userfault.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4cca896fb44a..2005906c78c8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -97,6 +97,7 @@
 #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
 #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
 #define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
+#define KVM_PFN_ERR_USERFAULT	(KVM_PFN_ERR_MASK + 4)
 
 /*
  * error pfns indicate that the gfn is in slot but faild to
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 758deb90a050..840e02c75fe3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3009,9 +3009,11 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable = false;
-
-		return addr == KVM_HVA_ERR_RO_BAD ? KVM_PFN_ERR_RO_FAULT :
-						    KVM_PFN_NOSLOT;
+		if (addr == KVM_HVA_ERR_RO_BAD)
+			return KVM_PFN_ERR_RO_FAULT;
+		if (addr == KVM_HVA_ERR_USERFAULT)
+			return KVM_PFN_ERR_USERFAULT;
+		return KVM_PFN_NOSLOT;
 	}
 
 	/* Do not map writable pfn in the readonly memslot. */
-- 
2.45.2.993.g49e7a77208-goog

