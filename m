Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C195D24F21
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 23:19:52 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-37360a6236fso794307b3.12
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 16:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/lqn4M/Too7/hLjEdNjj07wzHVUwU9le6KZacsTk8SY=;
        b=jpZ4+tq6rgM4hZWXweQJqfxuirRlrRpN+o4JwlpzpCNTf2A1sJCTA6DFTlQxCFhgbt
         sLPS4JguQacCAQKGId9cUa8Po003/wEsvkFZ2dOMw9iNk7lA7jWRoh5OFZzRfWNs6e3X
         DneEijHQrn4rLICnTKWJFk513kvZJ3K123XsKZ8FoBZdWOMtOvWDKENXD0/AJPQsCKjG
         rrWvKtMA58cnJHMchHTeytkk5Oc3RF3YtWKf69zqcXqxFh7WlsD0FI+Jf5mEVKngU/vv
         wyh2CqSaqQR9rkwiquK7nfr1sE2Ot7UFYqlBaM19WPnwV+Bbr0Tz+aWWsDk+unGGDNDW
         oUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/lqn4M/Too7/hLjEdNjj07wzHVUwU9le6KZacsTk8SY=;
        b=0sIZXIswSt1WqLEdBRqPKKmiMSdq92/xURYXrLm6MvbWihCuMM5rDuZzHX9AmKu4O1
         b+5yoFlxRhToTQgz6Z50EvSFRYtrZ4j5p5pY7qCESOjy7777Kox+fPXjB114wu0G8kUC
         2WDJucHeXriFZqAGJXK7QykwkEANKy9dBKKZlFj41B5PUssApohw7zmVbGtpr097xcey
         lnGyQFMiDF/6YnY0/B+bqni6ufh8rtzsJl/VoymKJGLUjDkjbMHa9HBQO/L6vIFd3Nku
         Kvb82DgLjxuPkutuM8pqINk7UsIIxSgvhE6cyUlR7kL68wXAopizDreMur6eQoutjY2+
         g3EA==
X-Gm-Message-State: ACrzQf2hQw1cpehzgfTHkXmWnf34pR21gdkv6MPI+w0XgUf3CxJcn1Cd
	vv6jB2hqrTMyz1Vo3CocF7BzaaJEIKc=
X-Google-Smtp-Source: AMsMyM7jpwGuIU1urFbOZ+g44WVeQ15lWGU4IrnR1FfXK34lSVgumwGfDAw7vRfyWzKVx0s/7WxU/xcerg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e694:0:b0:6ca:2610:76fd with SMTP id
 d142-20020a25e694000000b006ca261076fdmr171916ybh.607.1667431191239; Wed, 02
 Nov 2022 16:19:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Nov 2022 23:18:49 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-23-seanjc@google.com>
Subject: [PATCH 22/44] KVM: RISC-V: Do arch init directly in riscv_kvm_init()
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
Message-ID: <20221102231849.ALQKqcXbwpFhQCmAuWU5H-YnZWnDJtActXl5Y5VBRTA@z>

Fold the guts of kvm_arch_init() into riscv_kvm_init() instead of
bouncing through kvm_init()=>kvm_arch_init().  Functionally, this is a
glorified nop as invoking kvm_arch_init() is the very first action
performed by kvm_init().

Moving setup to riscv_kvm_init(), which is tagged __init, will allow
tagging more functions and data with __init and __ro_after_init.  And
emptying kvm_arch_init() will allow dropping the hook entirely once all
architecture implementations are nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index a146fa0ce4d2..cb063b8a9a0f 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -66,6 +66,15 @@ void kvm_arch_hardware_disable(void)
 }
 
 int kvm_arch_init(void *opaque)
+{
+	return 0;
+}
+
+void kvm_arch_exit(void)
+{
+}
+
+static int __init riscv_kvm_init(void)
 {
 	const char *str;
 
@@ -110,15 +119,6 @@ int kvm_arch_init(void *opaque)
 
 	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
 
-	return 0;
-}
-
-void kvm_arch_exit(void)
-{
-}
-
-static int __init riscv_kvm_init(void)
-{
 	return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
 }
 module_init(riscv_kvm_init);
-- 
2.38.1.431.g37b22c650d-goog

