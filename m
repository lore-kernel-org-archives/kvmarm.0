Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48322B64D
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 22:29:56 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d7e8e12df78so2293644276.3
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 15:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212195; x=1694816995; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tw1V6jjZtxQPmQpxo2OqWdUijyBXviuVC0rwevTlCmY=;
        b=B9UD2PXQHs3SEt5mA8FxTdH2iDNOnszJPciUJGLEqUYow/4kXHD89yxG1JpAr+ng1P
         1AWzCKMSY2osFiqHDq9E+JDyqWTJolzAlJiQvpyKMaq7ecFJjudbQMxjf6p64kOXJxTP
         3iHrcPOorH4mgkoop19/M8LPapbmhPIy695KoLFsqi4Zs0SeNyW/eZ4MyEDd9WNWx77k
         d89+jMQgRIPBCSL5PpE3f3wFjuEyv0IuG+bV0vo6mzZLaeaIfasS0DbdgLI92ToYIAUq
         tLjHZLgWikbbxj/LGCuQru28oN0GycKC2emkkwcKVwmYOR9uZ68N099JZoSKr1pdKbn6
         8AMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212195; x=1694816995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tw1V6jjZtxQPmQpxo2OqWdUijyBXviuVC0rwevTlCmY=;
        b=pyMnXQb0Jq98NYWrjUTWoBxQ5GJTQwXBdz/JwXDXb3ms3Ptcv0TJwFp93K1Q+IZHX0
         3ME1Ze/ZrHprA1NKZVM3fUYB5cxEkQMdr9/W1vhVzDpdOjlMQs575N+flUWgm5UMjeGt
         8A7AI9o4lsOh0rfPqgihouV+21AgKuxA44vs/1msD7KPfQfc+9EYdFd+GP7wuZFHXO/L
         1JHDuOLuPWo7DvQrYOSPhFI17AixAO7UHTYdfH5yBiAxTueI8jvKnoGOK5YbmTUh8SDx
         BRKeP6GK1aMqWFPd9CYPiS4xNmBFpY8qdcVR3vFCEbO6Uc0FF4+43Jmo8tAwx0IYPlL3
         n2vQ==
X-Gm-Message-State: AOJu0YzFUCQIu5L1QK39VLma3tY2LdzJA41Etx3gKZ/0YKbGpkYPgMO6
	fVh3EGgwoCmyvDueig0KGlEDhyJDN6VnRA==
X-Google-Smtp-Source: AGHT+IFidILo8DbI1LLUBkpdLdDWa4EPEgOq/ggpLsuiBitayiGeHEqMSH561wdBMd5QP0I3V80StiKjXtme2Q==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:ac02:0:b0:d7f:f3e:74ab with SMTP id
 w2-20020a25ac02000000b00d7f0f3e74abmr86043ybi.1.1694212195382; Fri, 08 Sep
 2023 15:29:55 -0700 (PDT)
Date: Fri,  8 Sep 2023 22:28:54 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-8-amoorthy@google.com>
Subject: [PATCH v5 07/17] KVM: arm64: Annotate -EFAULT from user_mem_abort()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Implement KVM_CAP_MEMORY_FAULT_INFO for guest access failure in
user_mem_abort().

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/arm64/kvm/mmu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 587a104f66c3..8ede6c5edc5f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1408,6 +1408,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	uint64_t memory_fault_flags;
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1507,8 +1508,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		memory_fault_flags = 0;
+		if (write_fault)
+			memory_fault_flags = KVM_MEMORY_FAULT_FLAG_EXEC;
+		else if (exec_fault)
+			memory_fault_flags = KVM_MEMORY_FAULT_FLAG_EXEC;
+		else
+			memory_fault_flags = KVM_MEMORY_FAULT_FLAG_READ;
+		kvm_handle_guest_uaccess_fault(vcpu, round_down(gfn * PAGE_SIZE, vma_pagesize),
+					       vma_pagesize, memory_fault_flags);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
-- 
2.42.0.283.g2d96d420d3-goog

