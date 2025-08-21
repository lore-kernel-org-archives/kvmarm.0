Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E06A393DD5
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810055; cv=none; b=DdOkxaLwI0EBhOQZGnBX9O2rbp2Jkaq4RVtQ939/5j773u0+HpqngNLjfDjsZadSVWFu9I951NfobgIxX6d4Is4EbmyJxWmQqQjLhZRMwYYpQr6urA3a1jGRKXIrRX5kFga9KtAJUWtmMJPLmyHoSA1wgfNhHMHPXWB1yFQ7tCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810055; c=relaxed/simple;
	bh=H8VFs2vZlQmG1JGjKINVH+XiNDz8nXmxoTY7lDJ7m5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ccLjNJkex32sTfFoPLWMTvLxvXNUYnsKPjtOg2vKBDEg9KjdAdFso1tKQ1Pt+nTuSTVamJxzVYFLs3l8MlUUubKr/7OBWaB1l6LRm/Z3R0ZEMyxMGEI1C4WXdqVq+iB20tKqU0UBQg60RHrz0796zHje5bJ9KtFcd053Js6DUMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cJW4gh4Q; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cJW4gh4Q"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2461907278dso8702625ad.3
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810052; x=1756414852; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X5D34uO9hhnDzIV0eQsNJj+iG1O4AZl7/xnqUAlhc2A=;
        b=cJW4gh4QSedD5/dFnv0e0xtthebrPLSb62iyPi70FMTO8qip0Tf3KKkPX8CiDJEi9j
         e/SJFGG9ROD+XVAWCjHCQxZeE978Jc3mzlNB+kkGzOXIHyx35u1Xq/rMoxI6IURBf8Qq
         iFxtVLbpckx6i+Dznp5RuQitPvpLhffitgGPwNpf6lFIuZfGTltr3E07cFfIZLZseXiF
         oEpxv+DFyq76ICH51J9+MpoVkgXJj3d2lpo2/4HKZ7K0Q15QHEfl5y5NOyIWyOUYnDo2
         dOm6UnMfAIa6hrDYj7QYmb5Y5jM7IGR119XjfLhgzdhSbdeHyxZjXW42auuEtzPukb+2
         vzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810052; x=1756414852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X5D34uO9hhnDzIV0eQsNJj+iG1O4AZl7/xnqUAlhc2A=;
        b=YEPvqiUG9qusLa4q1cNb/8wO9KEj1XbaTWPptFE0SPNJLGcYmwOMkmQ6NlT7LPMIPU
         h5W5K3SK2QokrEc4rYtA5BGTz2h0tRuFbhPC3YJBP7TdROwwo3pFtlCnlfDj8yxYX8di
         AoQ2Fuhvt2mNwzusjKbHTxGZvP2fstWqhyn2VVZPX83y5soFLxxCZlBh/F05wpFxUI4b
         Di1xJHKRnBh4XccAp4gwZ7iVUpskewO9BIXKy/8AlkBzPj+9nur9enGRbuWzUU/qAc9U
         Nrx81IT1Xn1ZR8HhL6JXWRDYmqH6LnlQMlKrNRZwnDq9r6OgCiCIWTL4nqRUL5Gr9izS
         1HOg==
X-Forwarded-Encrypted: i=1; AJvYcCU7ydS98VfEBGjvm0+1exzjeXtY+l2A1a57tOpkC5Vu99zxgRucbMQ5+4axOQF8T1lC6fgZn+8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzN2A2Ovl2gvzywWWGxaSg0ZqQnl/SuJeG+ZyHa7KJSe4PRe3p+
	+gTUQNwKcgEoOGJRMN50+baQ+wTnaVbzHm5FiSq/FoNvK6sOGTZIbNbgAG7j81cO0p5v8fHhNAK
	ClVjc/g==
X-Google-Smtp-Source: AGHT+IGd2anZ06gtV+U6bVFsbbPnzA1ZdvlYu/bGmJdbd8hlQ/26jHjvFuQxiH/8Yk00e7KNqc/bTBAWfHw=
X-Received: from pjbsd14.prod.google.com ([2002:a17:90b:514e:b0:321:78e7:57fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da92:b0:246:2e9c:3400
 with SMTP id d9443c01a7336-2462ee5917fmr11005625ad.16.1755810052479; Thu, 21
 Aug 2025 14:00:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:30 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-5-seanjc@google.com>
Subject: [RFC PATCH 04/16] KVM: arm64: Use guard(srcu) in kvm_handle_guest_abort()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Use a guard() to acquire/release SRCU when handling guest aborts to
simplify the code a bit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index de028471b9eb..49ce6bf623f7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1930,7 +1930,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 {
 	unsigned long esr;
 	phys_addr_t fault_ipa; /* The address we faulted on */
-	int ret, idx;
 
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_abt_issea(vcpu)) {
@@ -1984,12 +1983,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		return -EFAULT;
 	}
 
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	guard(srcu)(&vcpu->kvm->srcu);
 
-	ret = __kvm_handle_guest_abort(vcpu, fault_ipa, esr);
-
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	return ret;
+	return __kvm_handle_guest_abort(vcpu, fault_ipa, esr);
 }
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
-- 
2.51.0.261.g7ce5a0a67e-goog

