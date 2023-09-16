Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFD9376
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:31:27 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d8185415dfbso3137161276.3
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824286; x=1695429086; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nWWn+h7amRZMBDw3vQNPHGAGWvxVaFdsCPW0ONMozkY=;
        b=r8+AtvHKvfp6Ykcj5CVMp/P7vSt6gLzvUcz3QpLa/sII2NZrmWVhKWJsDAZb+1H8C/
         ceFFSNX25up3qagxnkfSworyz0uEgrJbm3DsVJ22OsA8s5l5Xt2iepteuJi0VZ+43Tq8
         u4jrMJYpqtJogfDcTpdU1o3rZMZEc5wR75qS8sJrJcG0nJEArcDLSkOMmhdbHrcKDbGa
         W40wZrww+lvan5C089CF1kxhvmdYadlPH85xuQwZM1LxbOQ3WGBQDrv3g2ARGqJBGRGK
         tQHqurkWXRZVl6y39FwPSgliYQWavR8zbQMPAOvPB3+qhHV3vZ0DlhzKVmiUdshJfjTc
         DtkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824286; x=1695429086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nWWn+h7amRZMBDw3vQNPHGAGWvxVaFdsCPW0ONMozkY=;
        b=qPwDxvRpJWwguV8m0tnmIS9us3BR21vNxpZuEbHIHl4ZEhYLnbhgTT+V39+t4pTA7e
         NFP6l40CJQqlJVVie/F0UCEyeBe0CuLd0r+cDkuBh7p3fXsjMbEX5ljO4pnUVkuJiXzu
         w3LV/87MwK/JkTkNLOj6viA1hcUatuR1VvbpLVcNXY2/lHkIQo5WUlm4EG9Hed506s1K
         yC1GlGeGYlylQYr7asDkGZI9Or1g/apAFNqAf6PokHcwD7rOtsFbFMm2Ivt7rDy9V0gs
         uyrJlHAGjv40HJuyHAixrIsLRgCgrR4DZ/EQSO/dfqP+4eghjpCI66gEl7NHS+gS1gf4
         voMw==
X-Gm-Message-State: AOJu0YzPqB2kII7ZSfIiURi3i35u1gCVq2tTeeWBiQvf6lMxJkYdCoPA
	tpn9d/JsgFNCaZTsAEfO/lxW/+HWhAg=
X-Google-Smtp-Source: AGHT+IEq7PdKxRZn76T8dxJekIJKystQKt2vwlGFVVGJbIP+fTzk72beaUliTqaKSj/nh0feFGYdLVI2swc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:98b:b0:d81:5948:970 with SMTP id
 bv11-20020a056902098b00b00d8159480970mr72987ybb.13.1694824286666; Fri, 15 Sep
 2023 17:31:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:30:55 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-4-seanjc@google.com>
Subject: [PATCH 03/26] virt: Declare and define vfio_file_set_kvm() iff
 CONFIG_KVM is enabled
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

Hide vfio_file_set_kvm() and its unique helpers if KVM is not enabled,
nothing else in the kernel (or out of the kernel) should be using a
KVM specific helper.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/vfio/vfio_main.c | 2 +-
 include/linux/vfio.h     | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6368eed7b7b2..124cc88966a7 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1352,7 +1352,6 @@ void vfio_device_put_kvm(struct vfio_device *device)
 clear:
 	device->kvm = NULL;
 }
-#endif
 
 static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
 {
@@ -1388,6 +1387,7 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 		vfio_device_file_set_kvm(file, kvm);
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
+#endif
 
 /*
  * Sub-module support
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 454e9295970c..e80955de266c 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -311,7 +311,9 @@ static inline bool vfio_file_has_dev(struct file *file, struct vfio_device *devi
 #endif
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
+#if IS_ENABLED(CONFIG_KVM)
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
+#endif
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-- 
2.42.0.459.ge4e396fd5e-goog

