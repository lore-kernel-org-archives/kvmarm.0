Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA45C4321E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:09:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B728F4B0B9;
	Wed, 30 Nov 2022 18:09:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZvGbZFWuaAsj; Wed, 30 Nov 2022 18:09:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBD404B3E3;
	Wed, 30 Nov 2022 18:09:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4BC44A0DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:09:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5mInj7jXhFaX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:09:50 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0270E4B2FF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:09:50 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 ep17-20020a17090ae65100b00219702c495cso178948pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=g1stMgF+unVz+1wniuTG4sBb8H6V2BLTtzNNraJ+L2g=;
 b=Qu2Gj2AQMSdn5ynZ5uRxUGFqbeHyl2Ed5IXeJ2cS9b8RyxUmxP+UPpwD4AXe0Ud2wQ
 GLE5fpqUn5yzNfMmkf1QqZp6YlOWxyIHZvzY2PTHyliCph5U92Ri7VRil5QNW2hbhlro
 eqLV3fzPciK364AgPpAWure/pils1YFI032lNHB5vYzqLYNGO/HTaCFu4SnHfGbx0IJL
 YzVxc9OdZl6JuUto8jah8ZZUeY5Nlgmu8NeURLW2FfXGR4hkpIETaC3DDgh3Y+VWw9aT
 wnj+XTBDiyARsefNZ1R+h94oYnfXDMDFEaIxFxgvi52xPOyDG50iBdiNI6MjV0enlZkj
 ltag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=g1stMgF+unVz+1wniuTG4sBb8H6V2BLTtzNNraJ+L2g=;
 b=y7dwViV7Qt44nJ5U/CVx7DsjEnS+8wCFTcsNQhI4FIhpzjZoO9esjh2MPo3od8FqkZ
 UYWYREZz0l+n2GKvsZYcKZ0x4NV6/iyPX5bTwf0CZevxqPsWbtLFjwdeYcGyrht7ALDN
 IrqCxQk1PYS52JcYThwXhGhWOzk+xpyWuEqTJSW34f2deL12fI+isIf1WzCw+Z9N4XAs
 BXu9BIxTrUGcxX/RxkgGKw5zpL07zO0W5vvyM8bh3kzD6tfFVGwg1r3d0oOIwymFdO+U
 X/++KCjbtRJOUdi5ozXUGqn3u/tzjwf2h8A9JWVdL5tLi27E0heHiblemgyfOix0yANA
 swow==
X-Gm-Message-State: ANoB5pm5L4zWYxomS2BIW05YYOjHRyTedTlUfn5aHRlALvkB+1S5W6sg
 RVblQec6n6L9Ni9UBvb/DuVRGRl1LHA=
X-Google-Smtp-Source: AA0mqf66P6cZGe+dew2XFgeia1skilH4V8u9knhT3C8CLrninF2nDNQmOIJQuI+E9fZev+1MNEWaGc+MIJs=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:9a47:b0:189:acf9:87af with SMTP id
 x7-20020a1709029a4700b00189acf987afmr3514511plv.160.1669849789646; Wed, 30
 Nov 2022 15:09:49 -0800 (PST)
Date: Wed, 30 Nov 2022 23:08:51 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-8-seanjc@google.com>
Subject: [PATCH v2 07/50] KVM: x86: Do timer initialization after XCR0
 configuration
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

Move kvm_arch_init()'s call to kvm_timer_init() down a few lines below
the XCR0 configuration code.  A future patch will move hardware setup
into kvm_arch_init() and slot in vendor hardware setup before the call
to kvm_timer_init() so that timer initialization (among other stuff)
doesn't need to be unwound if vendor setup fails.  XCR0 setup on the
other hand needs to happen before vendor hardware setup.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f18f579ebde8..a873618564cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9326,13 +9326,13 @@ int kvm_arch_init(void *opaque)
 	if (r)
 		goto out_free_percpu;
 
-	kvm_timer_init();
-
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
 	}
 
+	kvm_timer_init();
+
 	if (pi_inject_timer == -1)
 		pi_inject_timer = housekeeping_enabled(HK_TYPE_TIMER);
 #ifdef CONFIG_X86_64
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
