Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB07717E6
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 07:51:50 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1b0719dd966so5235000fac.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Jul 2023 00:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688457109; x=1691049109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uw1cYx5mpX+mMIRwwTz/eOOOsab4miY9iNG5/ESy4Mk=;
        b=hM2/lEtQfedjJNo6vksX1IzO4Wc7lA479rqm5EXmbgKzDwV1/aXimAiQpHo3XK8phH
         qL7Ga8Ly5/N9covlLsX8Q4ZpGICRncTKBb3TCq+F1unF0JVVYMtC5Yss6lU6mL9eAMDO
         HLrAMgF+i9FZ7IPDuh+PU/uN+tQR37ttUWdQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688457109; x=1691049109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uw1cYx5mpX+mMIRwwTz/eOOOsab4miY9iNG5/ESy4Mk=;
        b=lXIQ4iaxSCAV0+iC8gljCv+ce3yMGtSMOHTSnKyUIC+9F1AhXu5fzdW3FwhOdGCZA+
         NqrFOVPb7X/8X+7Unfmn3Go2UfUFbxPppFo3PTu8heTqSlt/yub3w08uoANAcQEUaNCJ
         W0yXnnxlgupsigAwMpD61zxeL17qEBQy1QDVJfliNmXX2bDQByU36jHTKtVLnRA2RuA7
         ltrLZo/zLBXgM0dkiE/kJM8WhT5Oz/0R2T7wd2SE+h+Pb6C7Ld3T7RikSojeB1l48xju
         tXZZkRvfo0S1rBQmzeisQ0b79y8TynUQrYGYlDmttDx3w8ZkQ2XFH3rJd2Zk0Tq+VScy
         W8ig==
X-Gm-Message-State: ABy/qLb1axqncg1ZZtP/KvhVQBPZRmxhDQFDVqK68i8g5lfiM0NPeOdi
	wtIEPZrTHIMrQOqOr/6FWd3qKQ==
X-Google-Smtp-Source: APBJJlE1s3SlpgurTIEl8nvf4AdSMp7i/6+oVrU7uwn9VXv/KuuRcBhlcTP1OyovYu4UgYP03T8sfg==
X-Received: by 2002:a05:6870:7885:b0:1b0:805:8678 with SMTP id hc5-20020a056870788500b001b008058678mr13821055oab.24.1688457109645;
        Tue, 04 Jul 2023 00:51:49 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:a11b:bff7:d8ae:bb0])
        by smtp.gmail.com with UTF8SMTPSA id w22-20020a17090a15d600b00263b28e49fcsm4324087pjd.47.2023.07.04.00.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 00:51:49 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v7 4/8] KVM: x86/mmu: Migrate to __kvm_follow_pfn
Date: Tue,  4 Jul 2023 16:50:49 +0900
Message-ID: <20230704075054.3344915-5-stevensd@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
In-Reply-To: <20230704075054.3344915-1-stevensd@google.com>
References: <20230704075054.3344915-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..e44ab512c3a1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4296,7 +4296,12 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
-	bool async;
+	struct kvm_follow_pfn foll = {
+		.slot = slot,
+		.gfn = fault->gfn,
+		.flags = FOLL_GET | (fault->write ? FOLL_WRITE : 0),
+		.allow_write_mapping = true,
+	};
 
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
@@ -4325,12 +4330,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
-	if (!async)
-		return RET_PF_CONTINUE; /* *pfn has correct page already */
+	foll.flags |= FOLL_NOWAIT;
+	fault->pfn = __kvm_follow_pfn(&foll);
+
+	if (!is_error_noslot_pfn(fault->pfn))
+		goto success;
+
+	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
+		return RET_PF_CONTINUE;
 
 	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
@@ -4348,9 +4355,17 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * to wait for IO.  Note, gup always bails if it is unable to quickly
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+	foll.flags |= FOLL_INTERRUPTIBLE;
+	foll.flags &= ~FOLL_NOWAIT;
+	fault->pfn = __kvm_follow_pfn(&foll);
+
+	if (!is_error_noslot_pfn(fault->pfn))
+		goto success;
+
+	return RET_PF_CONTINUE;
+success:
+	fault->hva = foll.hva;
+	fault->map_writable = foll.writable;
 	return RET_PF_CONTINUE;
 }
 
-- 
2.41.0.255.g8b1d071c50-goog

