Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F40C47088
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1889D4B1AD;
	Wed, 30 Nov 2022 18:10:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bpjGM6QCwyiO; Wed, 30 Nov 2022 18:10:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51BB54B62C;
	Wed, 30 Nov 2022 18:10:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16F2A40A93
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b2pp+eB0JMjB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:10 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56E614B5F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:07 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 u15-20020a170902e5cf00b001899d29276eso7517760plf.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=I7Tfj1mmzKu9MB+Ual4bJqD1s4VV/89vsBP4/EBeoPOTlLHT7MpttW25Vx1CGMeaX5
 /sUjaNYvh4i/27E3aGfkAayPTdhhP+ZL9WLpOvO6UH2MFRQqmS5qtIcnQsNI+DlBNtq1
 U/ZPxkk1uxXKSymFJrwMFOqF1OX3B1vO/d6oYSbd1l+ec6/2+sS2VeikykGp9Drdp1rr
 TQFCxAdrLh2P1WbK0KCHkwJ0qZDQ1gmWTh9572JEoP1cy7P/k48N/68hMsWq9+rRialz
 Ogdcx09puahyAv8h//TcI/JbhtNFhzvr1UeRDGJS6C6FtPXuXEoCXUbdBTEzAqoEdTPD
 +IRw==
X-Gm-Message-State: ANoB5pkZZDPmbEgeAYHJJD4KU417y+kmJBLDftvS4SFq+u7amJcuKuA3
 kNq5AvwOnioXbHdyrXNt0+MN/3whNJw=
X-Google-Smtp-Source: AA0mqf6KEmE4iPJ9U98BX162/oz5Lzb4cw+ziaGyrlJEvv/WGc/WSrrcrRcdtUijxIw8BMhf6X3VggubLl4=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ce05:b0:219:23ea:b314 with SMTP id
 f5-20020a17090ace0500b0021923eab314mr23130247pju.230.1669849806254; Wed, 30
 Nov 2022 15:10:06 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:01 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-18-seanjc@google.com>
Subject: [PATCH v2 17/50] KVM: arm64: Free hypervisor allocations if vector
 slot init fails
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
