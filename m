Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B985A47
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:31:25 +0000 (UTC)
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-1b728bfb372so4416340fac.2
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824284; x=1695429084; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NdOAPx70WjWtTXOKtIxgwEtN+XJRELer/ruyZoFwPzQ=;
        b=4Vbq1QbOFcR0Nw9knDLPUTPVx33XV/UfwwpjoIoTPp/rqLK0am1iwuu0i6ZDoctVkH
         Y05txshcgkjgt8ZnVtjoC/h9/Z8kilLFp7SMt9KwqKSlMS/OR47N4nq/v5SiO1+LFtCb
         bRLIUDQ46JdClR4kgMksC/XSOhLj/WTWNRp+fWb6eb696dxJBDFV5KZDKUT4o4/Qdvsk
         gH+iXWreQpB4EvL0n5WpGLIKLFEweyppIGhY8ZBQXE5skBuhj7fG7ce1b9N9Sf01BPHi
         VhfvzJ5rkR2FZx7uyEijqPkK4snkiVhYO1ASp3ZukXbJ8O/9ZaB3T/EiSaWvPbfICJ9B
         AO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824284; x=1695429084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NdOAPx70WjWtTXOKtIxgwEtN+XJRELer/ruyZoFwPzQ=;
        b=oP0DjhpPRHdMQ+/9OGN19d7Rmc16spwHKqrxGVsy4TgBeKbD8uwIjBGmQjmiPpBZRH
         2BtN9wGf+hzI1ySE0Gvuqc7qBeiekx1TLY5AsoTX3QzVvvNPfPpSqdsezsVdtqNWJ5Cu
         v0XrovC+vTortyjxvL7sxjTsMJXJF5TVh+0P3IUPov/UwVrYDCVi0Iy6RdkdGObe5kuX
         DLsT1OwSo/hz84+LosYmKfTEwOy+a8UlbdskjhXuKugtFWxk8l1LZ2T9GP5wQDZD5Dv/
         OjlkWQ029039eBLjkVobYi4DoZP6dPq2dyTHuNBFWzt0McNoQBZIefz/fPWPZRZV0bqZ
         4Dzw==
X-Gm-Message-State: AOJu0Yxg7svCooZrVk8K4dWLyNoVD5NO+qQQ4TKKptoNAzbyvRQTrc2S
	GjeOb6fqNwkPYGDvp/02OwmrnvKr4c8=
X-Google-Smtp-Source: AGHT+IFjfayrLbVmI/uUcITF7riix4t2p7LQSznFwYgaB2xPw0hEc6MrZUjOPPPKeYuL02E3L+TxPOZWHW4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6870:b7ad:b0:1d6:4da3:ae2d with SMTP id
 ed45-20020a056870b7ad00b001d64da3ae2dmr1068876oab.7.1694824284654; Fri, 15
 Sep 2023 17:31:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:30:54 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-3-seanjc@google.com>
Subject: [PATCH 02/26] vfio: Move KVM get/put helpers to colocate it with
 other KVM related code
From: Sean Christopherson <seanjc@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tony Krowiak <akrowiak@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Jason Herne <jjherne@linux.ibm.com>, Harald Freudenberger <freude@linux.ibm.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Andy Lutomirski <luto@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>, 
	Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the definitions of vfio_device_get_kvm_safe() and vfio_device_put_kvm()
down in vfio_main.c to colocate them with other KVM-specific functions,
e.g. to allow wrapping them all with a single CONFIG_KVM check.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/vfio/vfio_main.c | 104 +++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 80e39f7a6d8f..6368eed7b7b2 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -381,58 +381,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
-#if IS_ENABLED(CONFIG_KVM)
-void vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
-{
-	void (*pfn)(struct kvm *kvm);
-	bool (*fn)(struct kvm *kvm);
-	bool ret;
-
-	lockdep_assert_held(&device->dev_set->lock);
-
-	if (!kvm)
-		return;
-
-	pfn = symbol_get(kvm_put_kvm);
-	if (WARN_ON(!pfn))
-		return;
-
-	fn = symbol_get(kvm_get_kvm_safe);
-	if (WARN_ON(!fn)) {
-		symbol_put(kvm_put_kvm);
-		return;
-	}
-
-	ret = fn(kvm);
-	symbol_put(kvm_get_kvm_safe);
-	if (!ret) {
-		symbol_put(kvm_put_kvm);
-		return;
-	}
-
-	device->put_kvm = pfn;
-	device->kvm = kvm;
-}
-
-void vfio_device_put_kvm(struct vfio_device *device)
-{
-	lockdep_assert_held(&device->dev_set->lock);
-
-	if (!device->kvm)
-		return;
-
-	if (WARN_ON(!device->put_kvm))
-		goto clear;
-
-	device->put_kvm(device->kvm);
-	device->put_kvm = NULL;
-	symbol_put(kvm_put_kvm);
-
-clear:
-	device->kvm = NULL;
-}
-#endif
-
 /* true if the vfio_device has open_device() called but not close_device() */
 static bool vfio_assert_device_open(struct vfio_device *device)
 {
@@ -1354,6 +1302,58 @@ bool vfio_file_enforced_coherent(struct file *file)
 }
 EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
 
+#if IS_ENABLED(CONFIG_KVM)
+void vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
+{
+	void (*pfn)(struct kvm *kvm);
+	bool (*fn)(struct kvm *kvm);
+	bool ret;
+
+	lockdep_assert_held(&device->dev_set->lock);
+
+	if (!kvm)
+		return;
+
+	pfn = symbol_get(kvm_put_kvm);
+	if (WARN_ON(!pfn))
+		return;
+
+	fn = symbol_get(kvm_get_kvm_safe);
+	if (WARN_ON(!fn)) {
+		symbol_put(kvm_put_kvm);
+		return;
+	}
+
+	ret = fn(kvm);
+	symbol_put(kvm_get_kvm_safe);
+	if (!ret) {
+		symbol_put(kvm_put_kvm);
+		return;
+	}
+
+	device->put_kvm = pfn;
+	device->kvm = kvm;
+}
+
+void vfio_device_put_kvm(struct vfio_device *device)
+{
+	lockdep_assert_held(&device->dev_set->lock);
+
+	if (!device->kvm)
+		return;
+
+	if (WARN_ON(!device->put_kvm))
+		goto clear;
+
+	device->put_kvm(device->kvm);
+	device->put_kvm = NULL;
+	symbol_put(kvm_put_kvm);
+
+clear:
+	device->kvm = NULL;
+}
+#endif
+
 static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
 {
 	struct vfio_device_file *df = file->private_data;
-- 
2.42.0.459.ge4e396fd5e-goog

