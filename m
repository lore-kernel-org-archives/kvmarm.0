Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CDE1C75F
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:19:55 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bb24045f986so458586276.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722794; x=1688314794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T0ZSDe8DD8qgI+hQ5GGVvv9DPX/fmVUfBiQgPPJDyag=;
        b=bWCKDugGQrvfFvWncEMGbb6XO8VyRnzKypAqvn3c89Hc+P1Qkmnjha4vmUptSBGKYw
         80OFIEX6qdA8V9hflEcFQiy321yNlrAoXj6n9qtxSSLl1EM+68f5uI4E4fdwVtpV1J2C
         ENoQ010wMd2n5mQvmlIIhBL/XlzL2YkKaqjQ9FkZxEterH8lCzijhUY8WXPg7XKmFHk7
         HWnoa5VQIiKFQ2wHbBmVAcLmck4IF4pe6i1CfaZ/raFeVZLLZwRWU4a9K4gWoW873JXf
         ZnSHm7I77xMzShA+hIQ4IgtihLVsH8wmh7o+s3TSk50SgiFYZn5Tm60FAlWndIZXcBXt
         oAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722795; x=1688314795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T0ZSDe8DD8qgI+hQ5GGVvv9DPX/fmVUfBiQgPPJDyag=;
        b=SL/cXBk+Er2gDv6VJBwdHcoFhuwORch1cuWVKmCb8Nt27Ohh2ZJhI957AslNDAUVco
         kFCcij09sAayOksinOMaAIQYBd4NQrxJur0ACTU4l6iD5PT9X9OzrXTp9j5+1EaRgAJW
         bxCtQLvxK98Pnt6AHPg2rDx291kIyrWtnlVsN3ihasjadF+oBa9f0QT2hOc3uKrJq5Pa
         VSNU4vmfzFdq6T76k+fXcBwD/CS5pSwjbKCHP2FdoTWiEnOd2uJWeWoiXQrmw6SCV96L
         DWNqI2Lg3rgfMXIAkc2c9kbc18fn8tTimc3Old2wsbDSXFUn8vNLgCtnW/ebu9oyp5d9
         NYFg==
X-Gm-Message-State: AC+VfDwqW4XfPXg1iZ56ajmEHBdqcfKDkRLN2+ITQWO0eRPlYCfOoL9y
	xWVTe6OPj0sYZEGsCZVEuySME9EeEh9mww==
X-Google-Smtp-Source: ACHHUZ5Sfp52rrqZwc5OSKpraZQwO+GGnki/y+5vdhdc6/KeATsrubLSu85itYYdA99ZGshYC27a5L0PInmD1w==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:4049:0:b0:bac:faf4:78fd with SMTP id
 n70-20020a254049000000b00bacfaf478fdmr1207331yba.7.1685722794830; Fri, 02 Jun
 2023 09:19:54 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:19:10 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-6-amoorthy@google.com>
Subject: [PATCH v4 05/16] KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures in
kvm_vcpu_write_guest_page()

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9c0fa7c907f..ea27a8178f1a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3090,8 +3090,10 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 /*
  * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
+ * If 'vcpu' is non-null, then may fill its run struct for a
+ * KVM_EXIT_MEMORY_FAULT on uaccess failure.
  */
-static int __kvm_write_guest_page(struct kvm *kvm,
+static int __kvm_write_guest_page(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
 {
@@ -3102,8 +3104,13 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	r = __copy_to_user((void __user *)addr + offset, data, len);
-	if (r)
+	if (r) {
+		if (vcpu)
+			kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset,
+						 len,
+						 KVM_MEMORY_FAULT_FLAG_WRITE);
 		return -EFAULT;
+	}
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 	return 0;
 }
@@ -3113,7 +3120,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(kvm, NULL, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
 
@@ -3121,8 +3128,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      const void *data, int offset, int len)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-
-	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(vcpu->kvm, vcpu, slot, gfn, data,
+				      offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

