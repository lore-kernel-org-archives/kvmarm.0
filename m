Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5784391
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 03:46:10 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id g5-20020a25a485000000b009419f64f6afso12787776ybi.2
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 19:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JBDy+pBnHpjEjOCFqtKXk+f++U9hV1b2BXNfwFPUaag=;
        b=H7twHRZ0Fi9DJ14Zy8DaC/l7qXIcrc7PT56MNE+bCMUTxeLv8I65uGeWLj8QpdNvJ+
         zemUHTJ78+a3AzjBsLhyfqnnBx76e88kG1KI22k5JrTGuTd11HiyHM/DvRR3Nn8sAGky
         Qt2vuEg8ydatRajyCAdtzbeAkC0sxkHdqPeUdUhL/127nV6LIMjzDsqPPDKH4kk0Pk4x
         mDIy8miFlHg0JMsyW5O95OfLarVmBLAKEAr3oyWrScx/Jw6z0WDIdVWOAnRBmxjDAfl8
         mACzfVldnROI2cE2YPdRTbc5TQuSyzOSxLeyQo7KeoI0fFt7zTFIktknzUoVeE32JQ9d
         K6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBDy+pBnHpjEjOCFqtKXk+f++U9hV1b2BXNfwFPUaag=;
        b=trupJqPxCY5q95sludnc/DqdgsGBHkEfeNRPB3NukRbhjafQVRrL4s5zdWJdY5iZhP
         J0unGa3YmdBmM2Mz/A41i2uBWQLqx/l2jv7Q0JnH9WN7Zil6OpJydwjRfRGd7C1u8WgP
         HlyAhNHJJw3iyUkNvEHK72Mr9oxbILX10cL+mBmP1oBG3D27lFN8CGHurl15CwO2IsQq
         btrtm91tOonvlAU3lr+CaPQU0Z2fWsbLSAm6qlMmb2Dh807S09AXxbpPz50X+PB9lg4p
         E+S6dF1fhoOJ4/jtk0Jrlufu1FSqbpi3YC438qFkm949S/LTK6bKRfAh/N13YZfzAUyh
         dITQ==
X-Gm-Message-State: AO0yUKU8fRG4+mFcZPRdD02n5Oz7ovZtnUEIoUB/HT09rsydItC/EFmG
	/50WPt2ax8lpe83JxnNpA8BhreC6DCE30Q==
X-Google-Smtp-Source: AK7set8nUDspX8xTjKFw9UYAbj4P+7S+kz0/D8p5Y20QEe03+fM7j9/RdaMzpeW987uC+6YHWSiaUyuxg3HoCA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:40e:0:b0:ac2:ffe:9cc9 with SMTP id
 m14-20020a5b040e000000b00ac20ffe9cc9mr7832529ybp.3.1678160769764; Mon, 06 Mar
 2023 19:46:09 -0800 (PST)
Date: Tue,  7 Mar 2023 03:45:50 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-8-ricarkol@google.com>
Subject: [PATCH v6 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Export kvm_are_all_memslots_empty(). This will be used by a future
commit when checking before setting a capability.

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8ada23756b0e..c6fa634f236d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -990,6 +990,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
 	return RB_EMPTY_ROOT(&slots->gfn_tree);
 }
 
+bool kvm_are_all_memslots_empty(struct kvm *kvm);
+
 #define kvm_for_each_memslot(memslot, bkt, slots)			      \
 	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
 		if (WARN_ON_ONCE(!memslot->npages)) {			      \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..897b000787be 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4596,7 +4596,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return -EINVAL;
 }
 
-static bool kvm_are_all_memslots_empty(struct kvm *kvm)
+bool kvm_are_all_memslots_empty(struct kvm *kvm)
 {
 	int i;
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

