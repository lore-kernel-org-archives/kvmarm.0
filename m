Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFA81C750
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:19:56 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-565d6824f2dso31904897b3.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722796; x=1688314796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BbIws3TVOQ+ga2kyHnOYUuU4ZoW+MEWkftwOYAYwIko=;
        b=LlVUGKyVTKSnyZBMTtGtTVFNYmhWxoozKLYiiqpPhrsXi6R1dgUdwUHOW51uXiGxxq
         IPPODOiBarv7foL2YIn1iTk9NOhUa/Vmksxw2KwTyXhffKGPpqbupXrzJlwn4GjFO5+5
         zKlpSEyY16Xg7ZBK7tFUvqSBrc71g6jFEqUf4x9XcPUGoh699nQiZLDPeAup6qIqL2Xk
         Pj6A/PIBXtrU15rmncPbIFqAzVGWXGvAwqtXQO/4F03a7fB4bHzrLQuEMfcVNcNVy/G7
         sF2VSxniYN7UnvLWnoKZMAsXhwXfnmkTCSym3IDXGLYw/qrcgx88OHqM2MffWgNqB5Wr
         esDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722796; x=1688314796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BbIws3TVOQ+ga2kyHnOYUuU4ZoW+MEWkftwOYAYwIko=;
        b=Kyw7yz34aXzP/JcL8XoLNV48by8eV8e8hnDTEYmArjzVMYPk+gkx+UzdOeKI5V4WPW
         mEUwQwWXpoGJHitcmD48JbT8TAGThZwYBhfXWWAMZ7tjOR2udXbCtK2r1GNx8FpJ4cSR
         EO8C0ALUbHPu7dpkx5ZbTGseO3M+lccwk4rutKYjdybknYL4OpBfEQ9zr2DFdwIb7BLl
         ptbSsoLqJrXSCZJhNKm2x71shRQK3tK4cmtn13m1+4ALTJ5nc3DVAomd56Ckmx/RIUIR
         tYAd3fFGd6l+zpupYyAGz/qcNeTx6pNA/Stp0v/KOs88JBSRcpYCaCo8l1ofEjRhB6Ms
         zqWQ==
X-Gm-Message-State: AC+VfDzlgNbgtgGNRQIy3gNwPF9P3waSguezQgeZtrXya7/zCdaAsS+e
	NUZyQINXtPBG/Dc4fivOuC9yAyAEIaTf/w==
X-Google-Smtp-Source: ACHHUZ7YQ7d8v8jTjhqkGsOOSbttWu/vTfPGkpdYjmI5de7T/VwKGMoMRbh3XrT/5dCI1cf4Fr89Z6/LlBLL0w==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:af4c:0:b0:564:c5fd:6d98 with SMTP id
 x12-20020a81af4c000000b00564c5fd6d98mr174023ywj.10.1685722795889; Fri, 02 Jun
 2023 09:19:55 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:19:11 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-7-amoorthy@google.com>
Subject: [PATCH v4 06/16] KVM: Annotate -EFAULTs from kvm_vcpu_read_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures within
kvm_vcpu_read_guest_page().

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ea27a8178f1a..b9d2606f9251 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2986,9 +2986,12 @@ static int next_segment(unsigned long len, int offset)
 
 /*
  * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'
+ * If 'vcpu' is non-null, then may fill its run struct for a
+ * KVM_EXIT_MEMORY_FAULT on uaccess failure.
  */
-static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+static int __kvm_read_guest_page(struct kvm_memory_slot *slot,
+				 struct kvm_vcpu *vcpu,
+				 gfn_t gfn, void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
@@ -2997,8 +3000,12 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	r = __copy_from_user(data, (void __user *)addr + offset, len);
-	if (r)
+	if (r) {
+		if (vcpu)
+			kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset,
+						 len, 0);
 		return -EFAULT;
+	}
 	return 0;
 }
 
@@ -3007,7 +3014,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(slot, NULL, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -3016,7 +3023,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(slot, vcpu, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

