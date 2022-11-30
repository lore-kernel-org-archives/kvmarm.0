Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0137D50F
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:10:06 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id e190-20020a6369c7000000b004777dc6a02aso57489pgc.19
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eiSwfPmu4ewAiGcYbvYY+86df6I0KPgxP3gGecAMxPE=;
        b=iL8L003XqB+GKgCwHArr5kcxs4MyewOQ/xo1XysK8lk71q/4iO5w3SKvia9KqD7amd
         nXu1/r0fblzdTNOJpq/EYl9gFk0lysyFVV/7oFccNNQgU1JhwDr1/0HsYHMNLSclslmA
         UAtezhSD+JCAni39XkYX4QGkvZksvWY0lR4tjm/jCfiuQLeieGvg5A3LN33ihkcJ66/D
         QbO+O4mX6xEZLgdpufHO4gE+50I1GNIH2gNitP+ZjnsiKLl2r5s0LRLVS15/Koi+mQZn
         TJODgWK9oIR1COz+tFiDAPrhXmMt5j7wHvbTN67IWmBvfAG9+GHxtj6LR7jSg7tvIMuj
         4E5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eiSwfPmu4ewAiGcYbvYY+86df6I0KPgxP3gGecAMxPE=;
        b=bfWJi/rD+iQ/Ve3UP9L7kRU1hY/hnGJWFglZa5Z6jFkwwUgWSwk9TgcUKWUjrFB2Ca
         LZzU2PvvU6THEpcJd/lulMFawI7tm9Z0kCXpOj1xHS9zMJJ0eqtWxvYNXlNviHP8iTyF
         +m7jpnH+Bx7yYHDrpKLhDWRUxBqn4+rn8bevxESgN5W1IrAFHv818qCpeEpPTYzylv9D
         zK8OJrPlOEN6ELrIt1952+Oiou2YYgRC46xG/fsEi8ZumVby8QIneULHsnhL1udFrRO6
         Y7GTMgl3H9LIUculonXL7Yk0UgVYio2NTy5yi6XJfEXqa8krj2nyKGD33vIQ5S6PpGRE
         y6IQ==
X-Gm-Message-State: ANoB5pnDo9wKCvBdbjgCB1Tp3o1sg8A+FaxbOCaCJXNFrKonglbP2U5M
	I5otQQeOW+ydQw8u+pGjM26RjwNqgEQ=
X-Google-Smtp-Source: AA0mqf6KEmE4iPJ9U98BX162/oz5Lzb4cw+ziaGyrlJEvv/WGc/WSrrcrRcdtUijxIw8BMhf6X3VggubLl4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ce05:b0:219:23ea:b314 with SMTP id
 f5-20020a17090ace0500b0021923eab314mr23130247pju.230.1669849806254; Wed, 30
 Nov 2022 15:10:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:09:01 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-18-seanjc@google.com>
Subject: [PATCH v2 17/50] KVM: arm64: Free hypervisor allocations if vector
 slot init fails
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
Message-ID: <20221130230901.QBJbnjPUEbreFM-Fuza3aSH21F36jJMe-P5nbHg2ROA@z>

Teardown hypervisor mode if vector slot setup fails in order to avoid
leaking any allocations done by init_hyp_mode().

Fixes: b881cdce77b4 ("KVM: arm64: Allocate hyp vectors statically")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 07f5cef5c33b..fa986ebb4793 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2237,18 +2237,18 @@ int kvm_arch_init(void *opaque)
 	err = kvm_init_vector_slots();
 	if (err) {
 		kvm_err("Cannot initialise vector slots\n");
-		goto out_err;
-	}
-
-	err = init_subsystems();
-	if (err)
 		goto out_hyp;
+	}
+
+	err = init_subsystems();
+	if (err)
+		goto out_subs;
 
 	if (!in_hyp_mode) {
 		err = finalize_hyp_mode();
 		if (err) {
 			kvm_err("Failed to finalize Hyp protection\n");
-			goto out_hyp;
+			goto out_subs;
 		}
 	}
 
@@ -2262,8 +2262,9 @@ int kvm_arch_init(void *opaque)
 
 	return 0;
 
-out_hyp:
+out_subs:
 	hyp_cpu_pm_exit();
+out_hyp:
 	if (!in_hyp_mode)
 		teardown_hyp_mode();
 out_err:
-- 
2.38.1.584.g0f3c55d4c2-goog

