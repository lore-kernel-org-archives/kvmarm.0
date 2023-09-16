Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C786374
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:31:23 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5925fb6087bso33959537b3.2
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824283; x=1695429083; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CcWcgzjI/Sjr3SKdjnMS4CWAtaq/GpOs1NzqJV8HV48=;
        b=S/hnlIv4BFMWVF/CGOFgTFuwhcBJDqRkwvztfkP1GeUr8VvoDQZdOMik6O9kE1sEUS
         R9UTD15GZFwy6jF7GOxNyLXOJBqV3vZsWVfE4aMmcDMDA+9zMUJh0EdaDEjfp8u7nFgm
         OhxNh9JUdye2t8s1pI++xRNdOX1QNPf4qlnTUugYWvMJ6EnN9x+ARPszHoaxe4SPSeC+
         m5xOwKSaDk5p3iLXAyXwsVhNgANLmf4rcruW7E81EFsGyvTCrQFTUvJfI0HJrVFj6gJ5
         IQZCxnpgtKbNWmlUNfV8UKKxohVjAtyyoCThgEvHAv2i1x6UszscK00eZUoxe3Uwd9QL
         zH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824283; x=1695429083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CcWcgzjI/Sjr3SKdjnMS4CWAtaq/GpOs1NzqJV8HV48=;
        b=ZvN63mnUQ1gpU8FcbCov71eG5OAcSGctyDch2ODxErdWa/etedPhQpe4ta+5w17i3A
         ct1Ew0EoE7GINLE4CiqgG8OqEspQauMsgP2D86X6bZ1WyoyXpoEMVqXUcgvtw4JUO2XU
         Byfyr1PxC6Uc4O11iu8uDXjC/hKQCfr6PuLyGpLCkvMvDupxbltNAF2V7nta9f+WalE2
         javwMYvjbaZEVLfcAq6H8Mfi9idTdXt5GCHtUYcJDHdIbSr7xA5N0ZmQ84KneESokiU7
         8F4pLwzzdpEyQuO0VSOJIH3/geL8jz4yk59f1G03wXMjvvxbROKZo7T9HUZY4YDmUV7c
         pEeg==
X-Gm-Message-State: AOJu0YxB+PKSihEwMqm3EyxDQOp993C9DZxJVvswqRrUOyuj2F8iNVey
	SsSSWGH5astsa4vljVBm6Br2DLJblB0=
X-Google-Smtp-Source: AGHT+IEjplB8N3p+oR/7zKlMcxL9iCUBmO4vshw551ibG3RHlQehJcUKg5dHZyrgSIjo7xUVmV5xBYFOkj8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b612:0:b0:565:9bee:22e0 with SMTP id
 u18-20020a81b612000000b005659bee22e0mr85362ywh.0.1694824282871; Fri, 15 Sep
 2023 17:31:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:30:53 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-2-seanjc@google.com>
Subject: [PATCH 01/26] vfio: Wrap KVM helpers with CONFIG_KVM instead of CONFIG_HAVE_KVM
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

Wrap the helpers for getting references to KVM instances with a check on
CONFIG_KVM being enabled, not on CONFIG_HAVE_KVM being defined.  PPC does
NOT select HAVE_KVM, despite obviously supporting KVM, and guarding code
to get references to KVM based on whether or not the architecture supports
KVM is nonsensical.

Drop the guard around linux/kvm_host.h entirely, conditionally including a
generic headers is completely unnecessary.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/vfio/vfio.h      | 2 +-
 drivers/vfio/vfio_main.c | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 307e3f29b527..c26d1ad68105 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -434,7 +434,7 @@ static inline void vfio_virqfd_exit(void)
 }
 #endif
 
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 void vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm);
 void vfio_device_put_kvm(struct vfio_device *device);
 #else
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..80e39f7a6d8f 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -16,9 +16,7 @@
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
-#ifdef CONFIG_HAVE_KVM
 #include <linux/kvm_host.h>
-#endif
 #include <linux/list.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -383,7 +381,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 void vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
 {
 	void (*pfn)(struct kvm *kvm);
-- 
2.42.0.459.ge4e396fd5e-goog

