Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D42A936
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 21:35:26 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-54f810e01f5so49502017b3.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 14:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335326; x=1683927326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j57tzoPl16sC9ByxrSzcSJpXXHgYa+UwHfuGAFzOM3I=;
        b=hPL8324f0dvuI9qEQzWCYrweNFqgGmr995W+iPkc+3GRVTRuBih5b/Tk+omn/cNuoJ
         QJdd85nlJ+8gvBlpPMGC2W5MkTQLs/SUWLfnjqPap4MmVSGebtW35hwDOjZMMG8REtua
         /lSLjpb4oFMt1H05FLzLPNItsS8aB/fITd6xVpVMffErvEaAjrQWdlIKMqUdcPA/heHg
         VoN+2vk5kF95IclXeJ7opZl6vuf12QAxytef0yL5vmQDLvQICDV+IE0uA8hk6P6YyXbR
         8T1OpFbeK2s2/ufzJ+ZIT92Ohgl6rhkbVKN2MsQE2rgAtc+yORcHLQWC9t+kfbYn1oae
         i8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335326; x=1683927326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j57tzoPl16sC9ByxrSzcSJpXXHgYa+UwHfuGAFzOM3I=;
        b=eCsQrvP+XVo1JbwJMyfl/Qybtca0f8etRGzeD9mhsGQ8xYU1nUWGYCXZF3jPthrIVz
         N9kyiQI0BG4b+oLZwH6ma4bK3kyqWnZdI56q7yKSugN0H9BpdhtuIq9KkK4o/5kuFhKT
         cJvXOXUsHH4CzIuit3CtczykJ6qcweFSDbOpo+eDhcNXNrXVZQtqphGWLEXGFXASyuWV
         FEHkaWzqjBqUyXr63gSfIYNWEfX9LPIataap78iqvn3f69Z4FPcMYNvijWqEhlyuiSvd
         nIDEl+dECCogac4Rv5B012ZcOnU3eCsRDxaETEaac+rbm8HoS2PCzhxJoUOwhPROVv0A
         hvUw==
X-Gm-Message-State: AAQBX9eRfPDDKcZeUt5+G2J5ecRkzdEdtOyr90AYa0VZU+uY0IxbB6dP
	xMvVbfRGbx6tA2Fdv/3CBXf/NdHcOZ6tRw==
X-Google-Smtp-Source: AKy350YnELcVqu3F38lVRb+xr7cHeJqZPpveoy9dsreWoQEbFvuQJOfQLeL37xkM4q0cAPIFSLawdQnrHh266A==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:4319:0:b0:545:62cb:3bcf with SMTP id
 q25-20020a814319000000b0054562cb3bcfmr12058ywa.2.1681335326021; Wed, 12 Apr
 2023 14:35:26 -0700 (PDT)
Date: Wed, 12 Apr 2023 21:35:00 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-13-amoorthy@google.com>
Subject: [PATCH v3 12/22] KVM: x86: Annotate -EFAULTs from kvm_handle_page_fault()
From: Anish Moorthy <amoorthy@google.com>
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	amoorthy@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Implement KVM_CAP_MEMORY_FAULT_INFO for -EFAULTs caused by
kvm_handle_page_fault().

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7391d1f75149d..937329bee654e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4371,8 +4371,11 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 
 #ifndef CONFIG_X86_64
 	/* A 64-bit CR2 should be impossible on 32-bit KVM. */
-	if (WARN_ON_ONCE(fault_address >> 32))
+	if (WARN_ON_ONCE(fault_address >> 32)) {
+		kvm_populate_efault_info(vcpu, round_down(fault_address, PAGE_SIZE),
+								 PAGE_SIZE);
 		return -EFAULT;
+	}
 #endif
 
 	vcpu->arch.l1tf_flush_l1d = true;
-- 
2.40.0.577.gac1e443424-goog

