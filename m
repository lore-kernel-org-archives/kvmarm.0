Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BD124F28
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 23:20:14 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id r9-20020a17090a2e8900b0021409b8020cso2514045pjd.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 16:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5gvBLFzYAyi/HCXZ+GVBUHE668bhbiWmi3vwDs9Tl6k=;
        b=I5bOS6bfxLXiEBfjSJmP2kPQXW/SHnwLLTr4Pv1YGOJfWIPhzpIEkiKigvzufOLE8z
         PySBQSx0d0+tzNvKQjZSy72HymKoAuRoscdVD3mz0rt/jB8Y6EZI0Hs4WYS/QcUkjCkQ
         w8JCNgcxA3AK/X9od3l54Dm9fYHBQunkNi2G+VlGLZfuFSeGcLjMIp0YguN3Du588HWY
         UWsywY+dlyhYN95M8oqWM+ViHOjI8pWnpvPSFJCTuFlV7XnGnW9UVxSozj4IBjaVYRja
         c+tkLJnZPA8seMLOKTKBakZMCiOE4R5iDaDnVWvTgDI/JcgRlH/AKu7MnFyysyA6h5nx
         w+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5gvBLFzYAyi/HCXZ+GVBUHE668bhbiWmi3vwDs9Tl6k=;
        b=VBY3E2b+M5Ur6C0/NaoVLnntKzjZD4bZx5qiz2jas05EhvmAXpqYVlxUS2M3g/WmHL
         zTD8bpaUNrwsa3bPTZeHG9pkNMn8ObD+vLrN4wAxoMi5uNldSd5Gxnfhftpt4f0TFm8F
         KQ1MjjzkPd+/i5Mm+JHly9vKDT/4NiQ9aIOmK2fxmaPXl2rteeZXnS+nbGnXyJaKoGcK
         NWijyVhBcSzbnXGwsbuOnuAnl3QFPXZxEa5pl8R7z1/2O3qjeGDnOQQHYwdM+rekNeMI
         jhtdTr1qsNqw4zAchm88MaPqGVUTkzQQvP4Ik9WAU1SMZLbYN/9hn52bu+J6lN0HZ71G
         01Vw==
X-Gm-Message-State: ACrzQf20tslkL0vOv9RYCbJh7vG1vKz7hRNYpekIiHU13ey43mZWYUec
	gV+0Y+Yt3x7s61CIGhnpu+40gdzC2Sk=
X-Google-Smtp-Source: AMsMyM6XQ/aBNhxY5VjT+v6espe0fFHwkGjh05tLgVXfHik64KiilbScLDe/Y3M46ipvBiC6zA50qPgHreE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2294:b0:56d:7387:8a06 with SMTP id
 f20-20020a056a00229400b0056d73878a06mr18916476pfe.17.1667431214429; Wed, 02
 Nov 2022 16:20:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Nov 2022 23:19:02 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-36-seanjc@google.com>
Subject: [PATCH 35/44] KVM: SVM: Check for SVM support in CPU compatibility checks
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Fabiano Rosas <farosas@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221102231902.Q6GnLzrKkGhyUCJgM4qY1Te6FT3mHCKf5-lrDPCiazI@z>

Check that SVM is supported and enabled in the processor compatibility
checks.  SVM already checks for support during hardware enabling,
i.e. this doesn't really add new functionality.  The net effect is that
KVM will refuse to load if a CPU doesn't have SVM fully enabled, as
opposed to failing KVM_CREATE_VM.

Opportunistically move svm_check_processor_compat() up in svm.c so that
it can be invoked during hardware enabling in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3523d24d004b..efda384d29d4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -549,6 +549,14 @@ static bool kvm_is_svm_supported(void)
 	return true;
 }
 
+static int __init svm_check_processor_compat(void)
+{
+	if (!kvm_is_svm_supported())
+		return -EIO;
+
+	return 0;
+}
+
 void __svm_write_tsc_multiplier(u64 multiplier)
 {
 	preempt_disable();
@@ -4129,11 +4137,6 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[2] = 0xd9;
 }
 
-static int __init svm_check_processor_compat(void)
-{
-	return 0;
-}
-
 /*
  * The kvm parameter can be NULL (module initialization, or invocation before
  * VM creation). Be sure to check the kvm parameter before using it.
-- 
2.38.1.431.g37b22c650d-goog

