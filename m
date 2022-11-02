Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162D51EA01
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 23:19:24 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 186-20020a6301c3000000b0046fa202f720so78316pgb.20
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 16:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Pp3PbLfGlbPMUpUfY94YYIKSvd3QEyEjimXY5GHh7Do=;
        b=UkZGnXGmq2elzgV9DLUz74QXF30iTWbFGDiWfdaXhQTrFX8aiqCFVBpq5xcu6/5CJ0
         6CAeS4zBndyLbi6uL4aOTOJPom/GUXPjp+wnaiLNi/IOKHaUUiAdDM0lQqJcKi8lJ3vx
         vnARJXxit3idHJ3CVkd3Epv6mh/Uh5po1QC+vmSMzcdxDA+trq8VPV/HTVpleuhXsuBJ
         gB5evBsfkJOotXoUamKJrE8Yp7t9k0CZooSYyZMUGEw+wssTud1LYZ35nFOFQX6SsKf7
         8kThfTBVhIqoMM2+KcJViQg4ABdkLDTwvbAbS0YvwKJ8JO2nHVa2hjZQKtmcKqW09CRW
         6M/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pp3PbLfGlbPMUpUfY94YYIKSvd3QEyEjimXY5GHh7Do=;
        b=vHC52Fv7wFI0W+E4Vd+EtcxEJ6lD+x8Tzi/s+El9cm7JC+AwmLs6UnZIjazY571qBh
         +fWYdcWGN0mlD5qwyj0tRycRBopcHOhjadzZ+m4OXTTK1Bjn0MTScfvSFnnY5M07/daJ
         w4EH8P8Zr6TMYzHSNmt2ZZlspuyBbcW8vQav3efQnZdwKyTNHqMYZK6K/0bWmWsgm5yD
         s0qhLN1VjUBUWqMi61CDtNv5Qa5PyqVYcOiD6GGha+qlYkrpbR/9QcU8N41+7XgMKC/M
         fsmUHvO5LMrVhVRCzmqhMfsW6e6W1761qhYAmQKZuUk7yAThNAn9p6iZ6dTI21v7NWrN
         YLlw==
X-Gm-Message-State: ACrzQf3FAD7l4rZFsoEkAE714GWxD0oNS59h9eCxtXIlpH993tSfQs5N
	MoDphWwnLvVrBYDq9LFbikmO/dsuYxs=
X-Google-Smtp-Source: AMsMyM5BN48AgcZOI4nVxc2uFg8TXUQwjAkA5TEHVSI5KiQDtZoUe78o5/c87/pf9J/oxQANcuw7e+pFPCs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1206:0:b0:470:18c:1489 with SMTP id
 h6-20020a631206000000b00470018c1489mr6904894pgl.357.1667431164538; Wed, 02
 Nov 2022 16:19:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Nov 2022 23:18:33 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-7-seanjc@google.com>
Subject: [PATCH 06/44] KVM: s390: Move hardware setup/unsetup to init/exit
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
Message-ID: <20221102231833.LGak4VWmJ20ZtZY4yTp78VUTvNCpyfyRZGLiq_XUMWY@z>

Now that kvm_arch_hardware_setup() is called immediately after
kvm_arch_init(), fold the guts of kvm_arch_hardware_(un)setup() into
kvm_arch_{init,exit}() as a step towards dropping one of the hooks.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8395433a79b2..1aaee15211f2 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -323,21 +323,12 @@ static struct notifier_block kvm_clock_notifier = {
 
 int kvm_arch_hardware_setup(void *opaque)
 {
-	gmap_notifier.notifier_call = kvm_gmap_notifier;
-	gmap_register_pte_notifier(&gmap_notifier);
-	vsie_gmap_notifier.notifier_call = kvm_s390_vsie_gmap_notifier;
-	gmap_register_pte_notifier(&vsie_gmap_notifier);
-	atomic_notifier_chain_register(&s390_epoch_delta_notifier,
-				       &kvm_clock_notifier);
 	return 0;
 }
 
 void kvm_arch_hardware_unsetup(void)
 {
-	gmap_unregister_pte_notifier(&gmap_notifier);
-	gmap_unregister_pte_notifier(&vsie_gmap_notifier);
-	atomic_notifier_chain_unregister(&s390_epoch_delta_notifier,
-					 &kvm_clock_notifier);
+
 }
 
 static void allow_cpu_feat(unsigned long nr)
@@ -517,6 +508,13 @@ int kvm_arch_init(void *opaque)
 	if (rc)
 		goto err_gib;
 
+	gmap_notifier.notifier_call = kvm_gmap_notifier;
+	gmap_register_pte_notifier(&gmap_notifier);
+	vsie_gmap_notifier.notifier_call = kvm_s390_vsie_gmap_notifier;
+	gmap_register_pte_notifier(&vsie_gmap_notifier);
+	atomic_notifier_chain_register(&s390_epoch_delta_notifier,
+				       &kvm_clock_notifier);
+
 	return 0;
 
 err_gib:
@@ -533,6 +531,11 @@ int kvm_arch_init(void *opaque)
 
 void kvm_arch_exit(void)
 {
+	gmap_unregister_pte_notifier(&gmap_notifier);
+	gmap_unregister_pte_notifier(&vsie_gmap_notifier);
+	atomic_notifier_chain_unregister(&s390_epoch_delta_notifier,
+					 &kvm_clock_notifier);
+
 	kvm_s390_gib_destroy();
 	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
 		kvm_s390_pci_exit();
-- 
2.38.1.431.g37b22c650d-goog

