Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE2B24F28
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 23:19:43 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id nl16-20020a17090b385000b002138288fd51so2482458pjb.6
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 16:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KSp9zIzHXrxcJceHX59wYlpimn2+3DBl6/EkdM22YDo=;
        b=GazJIJPM/pHmiFZ05wEIEUmIWAlYuh2ZlyTopcNekluhV4UHGi1yTDkMNANFS1jscV
         sHaoW06GH/7QoV/u1MZ9MSnC1FGAiLQO/y23W8/5eah4jm88WvvNxPaF2O5WlqNX6AA2
         8Gs4UT7UUi7/ZwHf5DCZWbM2vulQhHbwn2WtGD6rJzl/FOBfxZ8G3NM+geD74+eDAUum
         o1o3demNZa7SFz5SsAwJ7XKog0NdlraaEfYhRzZpffEE3gOpiTfLkShIIvuV3L13yEjN
         xam914sm21iReYi10+r23ej5bJnTbIKx2d2irwZwjp5ibbzs0gCmvLJoawOipg8dYos5
         2Zgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KSp9zIzHXrxcJceHX59wYlpimn2+3DBl6/EkdM22YDo=;
        b=zC1hyfWtkPBMKPJU9JTUtmzIMacas3TEkCI7mhOs0C47pL5ALvYSOBsGzhHoxMbOfF
         ZULSEiBhf9dAVDhmnYxz//I45cFEYvsWA/e9GfIPE94MXvf65iLWp6UBcs3iPprM9hnd
         YWf8ScsfQQx+2l2VTQV/RaH96pm1m24jblLOQWJjvxLrD/mPJeM15ePPf/aAldGEb8gv
         r52uGOVG1Y115GfRHqlSgKz7sdrRw/Rj5+RVBFIvr/Cwrr+ruFiVWoGivk2NsLgSJ2Ey
         NbFy01tse1c4y11j7d0Ha9qMbYymxo3lGIZeTvhGrUVXFiWx41Qu72s12SlMoWNYWVLk
         46+w==
X-Gm-Message-State: ACrzQf0Q+EkoqPNaFBff4uzjKvIgWsLhvyBEHQtAyxXy40byZ2iDj035
	Vzr2e1boeAoFGcj1kjLGrfzNzLF3nY0=
X-Google-Smtp-Source: AMsMyM5Lv2JMFeAlRDTbvWUtcHml4s/PYrbj2uJcHSHWkZsi31gUm2Ed915QDdWGieIzAX5rFOQTrQSszmI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:e0b:b0:56c:8c13:2a54 with SMTP id
 bq11-20020a056a000e0b00b0056c8c132a54mr27442020pfb.17.1667431182821; Wed, 02
 Nov 2022 16:19:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Nov 2022 23:18:44 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-18-seanjc@google.com>
Subject: [PATCH 17/44] KVM: arm64: Do arm/arch initialiation without bouncing
 through kvm_init()
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
Message-ID: <20221102231844.l9pC2vD0b_Ln3PSKrqqFTlflP3wXHRDVdaB0HWfNkqs@z>

Move arm/arch specific initialization directly in arm's module_init(),
now called kvm_arm_init(), instead of bouncing through kvm_init() to
reach kvm_arch_init().  Invoking kvm_arch_init() is the very first action
performed by kvm_init(), i.e. this is a glorified nop.

Making kvm_arch_init() a nop will allow dropping it entirely once all
other architectures follow suit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f400a8c029dd..bfa2dcd3db11 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2190,7 +2190,7 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
 /**
  * Initialize Hyp-mode and memory mappings on all CPUs.
  */
-int kvm_arch_init(void *opaque)
+int kvm_arm_init(void)
 {
 	int err;
 	bool in_hyp_mode;
@@ -2264,6 +2264,14 @@ int kvm_arch_init(void *opaque)
 		kvm_info("Hyp mode initialized successfully\n");
 	}
 
+	/*
+	 * FIXME: Do something reasonable if kvm_init() fails after pKVM
+	 * hypervisor protection is finalized.
+	 */
+	err = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	if (err)
+		goto out_subs;
+
 	return 0;
 
 out_subs:
@@ -2276,10 +2284,15 @@ int kvm_arch_init(void *opaque)
 	return err;
 }
 
+int kvm_arch_init(void *opaque)
+{
+	return 0;
+}
+
 /* NOP: Compiling as a module not supported */
 void kvm_arch_exit(void)
 {
-	kvm_unregister_perf_callbacks();
+
 }
 
 static int __init early_kvm_mode_cfg(char *arg)
@@ -2320,10 +2333,4 @@ enum kvm_mode kvm_get_mode(void)
 	return kvm_mode;
 }
 
-static int arm_init(void)
-{
-	int rc = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-	return rc;
-}
-
-module_init(arm_init);
+module_init(kvm_arm_init);
-- 
2.38.1.431.g37b22c650d-goog

