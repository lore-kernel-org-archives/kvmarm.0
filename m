Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5559D516
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:09:56 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id l7-20020a170902f68700b001890d921b36so19021850plg.2
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uhI8yDhdR7lIAaqvku/gdFE7HWy6VU8JNAGQp8QsO6I=;
        b=JGKTwFHTr3zFyFeRyDhx800NTwE8fbKBoChRZ4rCsQDcOc/eGjPbGsVDNkCwWmSHdn
         4zWsAcy02h7DG9I7KIrR/3G3ynUAl5zHFprvqWawNYq0ujuz0rj9xQPN87hRttEvJWya
         MaZkpYk6hJDhRKiSggxmfSLSCGk6wAycOhmze7v3vnTNsBJM82DsGnT9K7gXXth5q453
         GXnW0gnhFQMQ7rKcFFJUmj9xHXOE1CyUnZYbsfJ9eekI1f6DwJJHgA0YwjDavFZGHgxi
         PIdF3Xw7u6ZSs+rqvW6sJFzKLF1Mn/CCKFnzXLHVYU5aHYTg5a9RqdAAC/8bhq/W34bo
         HRWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uhI8yDhdR7lIAaqvku/gdFE7HWy6VU8JNAGQp8QsO6I=;
        b=NhEyvzrZBEJ344DyIt/CPP8u/2wEXvvHLRas0vU/SsGY3PdEAt8agBohLrjIjzIVYq
         MAUQf/KMQxn530gX16Ty446GA1YoiaYjtu0Kfv8OoxQZP3Nus8QSAEIRW7A8ckY4cu9A
         JbY9DE7zbmT+PrM7GRKJJYkmgMKplYayDjmz2UZOo22fbhJuWeq1pY9ClPMY7zi9UOdP
         FIXUX2kG+kKVi0SUoRof5pHAc45Y2T+qmskpQYTGpW+0dCUrftb0DYQtKbnKHq6AFby3
         zyhri+5uPDB3cf3ZmmkGG0c+H5I2/7+tndim9sq1YQ4GMmxgOKRlCffDPOo64eDOU+vq
         WA7A==
X-Gm-Message-State: ANoB5pljRmZQD478zQPM3nqFE29/wWDqE0Ya5aRUi9T2cwdYr48RzE6L
	eSfMxq9BOl7Y1u3uqNrU+hSL1rabqK8=
X-Google-Smtp-Source: AA0mqf4UbHeO/7xp9TeaJC3lcd9wjoTeVcRzR2/roKzeL1N7msdBGBxph7L3Wcu7JbcPwh3sZzXNOI19OJg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:3084:0:b0:56d:dd2a:c494 with SMTP id
 w126-20020a623084000000b0056ddd2ac494mr44472082pfw.76.1669849796263; Wed, 30
 Nov 2022 15:09:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:08:55 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-12-seanjc@google.com>
Subject: [PATCH v2 11/50] KVM: VMX: Don't bother disabling eVMCS static key on
 module exit
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
Message-ID: <20221130230855.6XFD_DYlrDy_IZSCCXSdrV5IWkRuWD3faEzC4Q4Hxos@z>

Don't disable the eVMCS static key on module exit, kvm_intel.ko owns the
key so there can't possibly be users after the kvm_intel.ko is unloaded,
at least not without much bigger issues.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d85d175dca70..c0de7160700b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8490,10 +8490,6 @@ static void vmx_exit(void)
 
 	kvm_exit();
 
-#if IS_ENABLED(CONFIG_HYPERV)
-	if (static_branch_unlikely(&enable_evmcs))
-		static_branch_disable(&enable_evmcs);
-#endif
 	vmx_cleanup_l1d_flush();
 
 	allow_smaller_maxphyaddr = false;
-- 
2.38.1.584.g0f3c55d4c2-goog

