Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B93D516
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:10:19 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id n4-20020a17090a2fc400b002132adb9485so232309pjm.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5yXQhNujyCn0BKG7v31c4OGaNv+fuibQffzvzfRXOMY=;
        b=h6rsUUCphQInF8YIuJSydp7y3K+kWTxAbyRCfeyJQKJ+Y6qbtiTSAEs1qGlDllqT/J
         MMyCWI1z6QQ9M7p7Zu6QpSl/9m1uIwFhUqPqC0VY2dNxBAtSmKEBK4CCdgkZqO6Ul8Kx
         fACOhEYDJb6v1xuMAezabk8g2ZSsJuhT+lDS/T3ozQuYyR/lRYpg7LUF046Tas5T+NY5
         CeL2ERbYxquxucrniWQA910RogetkvuImYcNKj0ET57pNLum/MqlKCc6KP+V5OUAEk8P
         PnX37vQ/dZrpTC3Oabzm833Uf9cuKd5yhE1OeJVb9W6pQwUrjh0B5ijm+gc3WgDVn+HL
         6XjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5yXQhNujyCn0BKG7v31c4OGaNv+fuibQffzvzfRXOMY=;
        b=hjSa8xcrwZgwWv60nJDpoAYxTY/YvbXFyz3TrlDofjiGCYQVsUK1YKvy2oBnSwHPrt
         FPLba1pMh2/3vWmxYbQyei661efeJPav050z/+OtPfNFXvdPrpojDdV7LBa6sAIj4D30
         mUd6afBuD8AyRTXjTf3ej7iGoZ+HSff5JunaKkwd6V/q+zFijXlK05QPIZHvyTv+JT0Q
         b9+/KAqGfAlS+YN7mzArU1foco3ZATKo7Ah6ZXXBiab9imthDvhYMe/memp5EsdVrR3j
         L2OT63FCKvAhJ5KqN8MlQyKrkpXvqc44b81M4n2gStfZ5KeZScFWlyiNFw9+XVWUOuM7
         KO0g==
X-Gm-Message-State: ANoB5pn6S1EHsgTtXzAiUhknnV1JpT2xSgjPGoLi85iFGEpNF/8COZHB
	02/1EqdfrmdU5uK8DeywIfwRI1UJnQQ=
X-Google-Smtp-Source: AA0mqf4uayK8uJVSnmaHjmcUzYqE9zwUJpBZYJxTpzlvsNbotM7JFJFGgIIUFhNbqetWZOK5ykPGKeuQP1w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec8a:b0:188:640f:f400 with SMTP id
 x10-20020a170902ec8a00b00188640ff400mr45576276plg.143.1669849818577; Wed, 30
 Nov 2022 15:10:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:09:08 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-25-seanjc@google.com>
Subject: [PATCH v2 24/50] KVM: RISC-V: Do arch init directly in riscv_kvm_init()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>, 
	Cornelia Huck <cohuck@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Fabiano Rosas <farosas@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <20221130230908.8h5kL1Sep_EQJzYxWQVeFGFu5lDzHejbVaXFGfnUck4@z>

Fold the guts of kvm_arch_init() into riscv_kvm_init() instead of
bouncing through kvm_init()=3D>kvm_arch_init().  Functionally, this is a
glorified nop as invoking kvm_arch_init() is the very first action
performed by kvm_init().

Moving setup to riscv_kvm_init(), which is tagged __init, will allow
tagging more functions and data with __init and __ro_after_init.  And
emptying kvm_arch_init() will allow dropping the hook entirely once all
architecture implementations are nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
Acked-by: Anup Patel <anup@brainfault.org>
---
 arch/riscv/kvm/main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index a146fa0ce4d2..cb063b8a9a0f 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -66,6 +66,15 @@ void kvm_arch_hardware_disable(void)
 }
=20
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
=20
@@ -110,15 +119,6 @@ int kvm_arch_init(void *opaque)
=20
 	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
=20
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
--=20
2.38.1.584.g0f3c55d4c2-goog

