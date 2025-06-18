Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DD020409A
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 04:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220680; cv=none; b=qpiwoNM6FzD9T0/8e28PwcyAE9FlsSLBhYWYu4jSk5QXE2OY5iKBokQqX9v4kZjz9BkLngJ4GO1OzQzv0J2+kEUZgJOVVtxjSW3xaS/xBnldrO+7QTPRPWnI6KP2EhcaN+0nik2VHY5QZIfb0KQg8dsXjvSinBvZyGg8uMcjtnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220680; c=relaxed/simple;
	bh=RjOGGjzo1gz+MJ4XHnzV65K+mX6uQwTz9v2uyBR8F74=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DuHRKTmtYrUm9KdwGuOdDykIQL0W4+K391JrkNcGZKTsvacOq+gRLsCZ3xnQs1zNBpdAx9O67f16PEgAtdnpXtuVacY91SLdZxsNYnyaxxmB5MzsG0AazXv8oxnPRCbZbL4ajCt4ezTGkcK9bzsyf2cc2K/csMfUuq7WFNQttUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uoNJz5fL; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uoNJz5fL"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138c50d2a0so8960688a91.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 21:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220678; x=1750825478; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u7uDKQXpUwdrzKwoUkA90P4kaViu0b/lAOUYW7NM+2o=;
        b=uoNJz5fLbIKSu3OiPdAGBpLo48elwu/GCeBVwZbQznt2UiKt4VYFWZsk6T1dkLIdzI
         fuJLwm2bqWDrarhW7vEn6dI4NBsR4v/WvZP+OtnRXCtt5z+7CptOVsy9enNNtjGKyP2H
         FkuhCMt5w8JlqiQ5JidZucavilXjyMxvaxp7QfK/9ibe24Zpn8hA5HenwMBcuC1mipw8
         wdtvpogDVvkq4epIdZhjsqSrm8IuKEIcurK1rxMk95K3wvGZo3keWf+dDb0pNPJe7f+B
         u4h/jtOV9vLDiBNgJk39YzpPQ+VqXQ0wj3wz+HPD9CfMXEfdwuwc9bck4MwcvOmT9x8r
         jDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220678; x=1750825478;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7uDKQXpUwdrzKwoUkA90P4kaViu0b/lAOUYW7NM+2o=;
        b=xBY1gapxESWfdsDhAzx60pUsOgMFxXrLOTdJAPKSCVSA+lyynq5Hqq6fGLXeuG6cub
         K+oWj1vi4k2tpS4NGranz/X3Ptm8moG5ImEAQQUk+ZfvriYuoNM3xIlYzU8pU09xDvPs
         URWMfo56x44E3FCI4CnWPV3htRbaMjWQ/84EbGpia5cvkUb8FJJgadm7QTXLIdPL1qWQ
         PnS+4el1Yj7+eP98O+qykeYDwYOKnLs/T3fk05jkqFxVHEF21ci7YEITvGI3X0IZxnVN
         odr1GGfEpWH5+DYc63T30xnedwNaSxIIIZEux08CsBYeHp1VSzHldknOHgtIukD6oz7L
         0r1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVWjqjqfLSDL7JvTZRWLa9jbWqirZs5Mbn+7FenvuegwDEur5h2CcKwlm9MTfKraFj+BUSRgUM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdPFOZYWaJzsm6bgoEmDdv7yWOz23nfq4mtViCadqVnC7tV+dF
	eISuRzUz2pavbLUbrend+UC+1pCRB63qaYNz5RgWpeJYNt3cMxBCPM5EVUWOoaww9PvRIOjI6zx
	e9sV5jmTL/HsTaCyZcZgk4Q==
X-Google-Smtp-Source: AGHT+IEsvRhaA+pgvEn2VcIt6EZL6lLvB8OQlgHyuSOj5NMOQERsIQvH6ATMkLPJIOGQBvW8tdGSJDJWdEvdsdMB
X-Received: from pjbsm7.prod.google.com ([2002:a17:90b:2e47:b0:312:f650:c7aa])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d47:b0:312:db8f:9a09 with SMTP id 98e67ed59e1d1-313f1c380f7mr29459716a91.14.1750220677882;
 Tue, 17 Jun 2025 21:24:37 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:16 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-8-jthoughton@google.com>
Subject: [PATCH v3 07/15] KVM: Enable and advertise support for KVM userfault exits
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Now that all architectures (arm64 and x86) that utilize "generic" page
faults also support userfault exits, advertise support for
KVM_CAP_USERFAULT and let userspace set KVM_MEM_USERFAULT in memslots.

Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 virt/kvm/kvm_main.c      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e3b871506ec85..0ba265f99f033 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -937,6 +937,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_USERFAULT 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bef6760cd1c0e..2962be09d5ebf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1604,6 +1604,9 @@ static int check_memory_region_flags(struct kvm *kvm,
 	    !(mem->flags & KVM_MEM_GUEST_MEMFD))
 		valid_flags |= KVM_MEM_READONLY;
 
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PAGE_FAULT))
+		valid_flags |= KVM_MEM_USERFAULT;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -4881,6 +4884,9 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_CHECK_EXTENSION_VM:
 	case KVM_CAP_ENABLE_CAP_VM:
 	case KVM_CAP_HALT_POLL:
+#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
+	case KVM_CAP_USERFAULT:
+#endif
 		return 1;
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
-- 
2.50.0.rc2.692.g299adb8693-goog

