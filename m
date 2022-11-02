Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52BFC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:19:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 817654B6CF;
	Wed,  2 Nov 2022 19:19:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QQDkSNzE0u8X; Wed,  2 Nov 2022 19:19:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 764584B75D;
	Wed,  2 Nov 2022 19:19:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E3F04B7B5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IIMsnAjz7z2S for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:19:42 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E5BB4B81F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:39 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 t6-20020a25b706000000b006b38040b6f7so380336ybj.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=jjwuYM33wa0dwVWFlLHKwYhVaHzm2FgiCKOfn+QDNQ4=;
 b=Fhq9PEIX8LJQUbJ64jTN1JvSF4aDYgMhxvOWYGX1iAWoV/lvAdG5LOXuNivkfQWmaN
 XoYRELj0iLXTcGUgDHg9R/bhGsJRvY0Qx7IEF0y4w7dFOPQtmSUB+O6PUVY8/MhozQfF
 AX6SYnVZgv9nJGu4JJBc65UftCLAjC1MJHk1aUCf2yILUXt8A+rMwOgyzW8jvMWXgkl0
 LgkleUhB3pCNMAS+BVFzOjuYh6vlw9PADZ2etUZ8fiuYZCiK9hkRPf6dczcVLTjo6nqb
 SNGwaGeIsaxofOZxTFjiZYanOv3dUMmT9VRhi3xCUQ51Z2IYrlwrIcc2Hbem0XHCdIi2
 UM4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=jjwuYM33wa0dwVWFlLHKwYhVaHzm2FgiCKOfn+QDNQ4=;
 b=lcth9d5B3om9aEedDcvp38lb9K5vJ5gepWCAuSvswIScsF1vTkwnVuWSiFx4MX2zUi
 Bx+PKEZoz4NiAS2+S8A3f9QslPdY68+jDxOsrGwAU7I3r9witbqOiqUL2O1UQ7xiPAu8
 gt8o3fZGd12Eo3qAdBKVfCdg7VjAHxx0zbAG9l9kNrrFxroZ9IRshIbq0RdbbNQoqUyG
 PfC6LpnN7/xQxZ5TG9GoXGPPvmY6Y0IBk8+QTyWEgtSNevVUuIeJ6IMsJ75fQSmVfq3a
 cyaQYok0KtwgIBTFWR+WwFrrJc3KqRNgJVWecp8RQIcjVpLbz6lsiao4jJoVDFJqJDTl
 x2eA==
X-Gm-Message-State: ACrzQf0kQn50zEVNiQ2Bf3v5rpNTwxgg7txn9wm9/8JFhQvtKzo4Fq4O
 E535Fc775evTY/S8JBa7AubxW0qkye0=
X-Google-Smtp-Source: AMsMyM6G8+cpsdlQ24WmBjSm0uN0SQ0FUjj6LFQ9PdnISN+9XlJSF9tKC3IM7fcpwDmLrOspg5L0a2rB188=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e695:0:b0:6cb:895b:5a35 with SMTP id
 d143-20020a25e695000000b006cb895b5a35mr25441755ybh.573.1667431179587; Wed, 02
 Nov 2022 16:19:39 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:18:42 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-16-seanjc@google.com>
Subject: [PATCH 15/44] KVM: arm64: Free hypervisor allocations if vector slot
 init fails
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
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
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
index 0c328af064dd..73644def7780 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2232,18 +2232,18 @@ int kvm_arch_init(void *opaque)
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
 
@@ -2257,8 +2257,9 @@ int kvm_arch_init(void *opaque)
 
 	return 0;
 
-out_hyp:
+out_subs:
 	hyp_cpu_pm_exit();
+out_hyp:
 	if (!in_hyp_mode)
 		teardown_hyp_mode();
 out_err:
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
