Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BC638F86
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AWy6a2YV"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5a7af53bde4so19549477b3.0
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563831; x=1700168631; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l82gPfac/SXOymVisAyaLDDJ1X21QbMxRoT2bJNvsrA=;
        b=AWy6a2YV3E+t9uSZPqBU0d36khEqQSG4jbUt/U39WLmAl7Tj0dthWMUzpjka2SHW4e
         EQ3q2NKyMNNmsR7N+cP/Zt3JwaaoIV+90Pm+xxwukzSwxEoL2eAizQ0u6Uhe7pVjRaJE
         G34q2Eus3Eysy5VEtE+3HNUJ+szbmthivQB00L/8GZjBPHgVlmnXkxdxtZ2raFmBNu6g
         X1yJcB7Qpw+P5qQqH7LSii/uHL737m4DPzU61ymApzbGHTU7Jo173/lEm2PV3NqwJwbT
         INKXVcsKEfzvLZNfFAJUrJ/SSaRiKbaUCDCOpl0htrl4zmddp5qxFy7FQb15mwEL0uyr
         1IHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563831; x=1700168631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l82gPfac/SXOymVisAyaLDDJ1X21QbMxRoT2bJNvsrA=;
        b=nZPw+YyE5wKA5yVxO6oXRarg16mtRRvt6M58bkPBYu5j474MqyDNjXqpLKWXdQJLDa
         EFRDY0bd6MrNM0ECWAY2YN0t8NfilA4jVqhiTILTJDjam3v2y+oy6Eui3oxQkjdRNYdO
         0BlJYndAh2H1RyEH75ZjCRgf7vGXwsgVWjmCm/GTCXORSDDVCsvbKL6ykTlh8YlKrm+U
         DDXhvrnJqHsFUpIxEkrq7egFU9rJFslezPP8IKveIEejedCZdX4nk5Q81x+RFhijlK5l
         utIZLsxGxzHxVj5sUkW/MCwoV30ivOq/gOWJBnPA9dhqUpQzFSbGeWjukDnMyCPrY3et
         XpKw==
X-Gm-Message-State: AOJu0YyOiZs4PYMopMX4v+0JgLNOPOZMCyz1ynqZvUTxiB4VeOHpJvr3
	hqin1ZlCJQZoGsgy+6notAIca4fxMw2tgw==
X-Google-Smtp-Source: AGHT+IFvJ5ZeOdaPhXfzZmDQUxm7sOA9rGuldoFyaa/+DAtdsI/IW/Gd/xhQNzlGrBgekGARQHuJRJYSnz/Stg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:690c:2d05:b0:5be:a164:566e with SMTP
 id eq5-20020a05690c2d0500b005bea164566emr143138ywb.4.1699563831020; Thu, 09
 Nov 2023 13:03:51 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:18 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-8-amoorthy@google.com>
Subject: [PATCH v6 07/14] KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and
 annotate EFAULTs from stage-2 fault handler
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Prevent the stage-2 fault handler from faulting in pages when
KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
calls to check the memslot flag.

To actually make that behavior useful, prepare a KVM_EXIT_MEMORY_FAULT
when the stage-2 handler returns EFAULT, e.g. when it cannot resolve the
pfn. With KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of
stage-2 faults as vCPU exits, which userspace can attempt to resolve
without terminating the guest.

Delivering stage-2 faults to userspace in this way sidesteps the
significant scalabiliy issues associated with using userfaultfd for the
same purpose.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/x86/kvm/Kconfig           | 1 +
 arch/x86/kvm/mmu/mmu.c         | 8 ++++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1457865f6e98..fd87bbfbfdf2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8068,7 +8068,7 @@ See KVM_EXIT_MEMORY_FAULT for more information.
 7.35 KVM_CAP_EXIT_ON_MISSING
 ----------------------------
 
-:Architectures: None
+:Architectures: x86
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index c1716e83d176..97b16be349a2 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -49,6 +49,7 @@ config KVM
 	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
+        select HAVE_KVM_EXIT_ON_MISSING
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b1e5e42bdeb4..bc978260d2be 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3309,6 +3309,10 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return RET_PF_RETRY;
 	}
 
+	WARN_ON_ONCE(fault->goal_level != PG_LEVEL_4K);
+
+	kvm_prepare_memory_fault_exit(vcpu, gfn_to_gpa(fault->gfn), PAGE_SIZE,
+				      fault->write, fault->exec, fault->is_private);
 	return -EFAULT;
 }
 
@@ -4375,7 +4379,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	async = false;
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
 					  fault->write, &fault->map_writable,
-					  false, &fault->hva);
+					  true, &fault->hva);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4397,7 +4401,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
 					  fault->write, &fault->map_writable,
-					  false, &fault->hva);
+					  true, &fault->hva);
 	return RET_PF_CONTINUE;
 }
 
-- 
2.42.0.869.gea05f2083d-goog

