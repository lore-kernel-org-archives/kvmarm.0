Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBF3C47088
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:11:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 188634B3E8;
	Wed, 30 Nov 2022 18:11:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VQ5Ep4isPR9v; Wed, 30 Nov 2022 18:11:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A44774B754;
	Wed, 30 Nov 2022 18:11:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 742F64B199
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:11:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I6k20Zd7yx3A for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:59 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29D964B69D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:53 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 u10-20020a17090341ca00b001897a151311so14114570ple.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=X0tmq9TjsMbdzf016NYPEZWLDrtJgEerkZwlPByjvHs=;
 b=ffiAil8tYfi3nQXQblraVPD6jbdbOOCVG7uQkkKJrYkDL25R/TkQAeFRDogqa/QMMv
 6wZOWt9R/eeSPWTlpWV3IYmrtl04WJOPJAhS7DhGuKTgLTJnehBcyBsLWlgRsCVFi/Ix
 ksxZjkBOqqqo9hOr9qKhrYgS8WLlfTE4UM6Vkkhhf880kZVvVEdvLhl4X0FaFYBb/6vC
 1lACz1AHExA2AbJQILx7vCyuTDoL44EAFEV/X6CifJwvfMkGg0ai47n8Yg94c4IO+cHQ
 jlRTeSXfVKpq0j3GPFNIBJZpOCvznvIZyM5DfqXmXJnRlhyCma48IFWCHmjS0A3NCAbs
 hdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=X0tmq9TjsMbdzf016NYPEZWLDrtJgEerkZwlPByjvHs=;
 b=h7SKppmI3AZq1JnoYUCOQnMZ0xUIYeByHH879a8sDsy/0N6oW53t0o9gRyrpqn9CV9
 ateiDTuRjuGFBFeONL2ZjDXkdifwtqytPC5qEhzrFFwUwwyY5QBZYVtDF0B9os6n08pV
 acu0xCZa8kelEwrYZjnxFhoIw7FaXQ5W82iAxk1O/sQiA8PkHPojAMGLV0rtLupP2jux
 KhK7Ya/fDdLUOfo+5rOMNFaQLkHcJsWO3UM1AMbfy2FiHtvkMUJmWIUbrjMv9hkcib1d
 kIKSGKU5lc21OGkxd675TxcXmUC6BS+Ow/iIAsZEsEfcKaSoQchHcRhv9Sy3BWC+pINh
 6Nvg==
X-Gm-Message-State: ANoB5pmt8OHqTjAtcWP6XcXllq4qyMsEYDn3cPTY3fFEJH37nD1GCY5t
 pISJ4JyXC3tWcJLyO145i1UXV+XKmAQ=
X-Google-Smtp-Source: AA0mqf4tYdOmumtBwzOsj2b757evhXiqjnmJBxVweHABwP7YhX6XXp+28OecLtWsiEbLYyMEiAceUWRYidE=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8487:0:b0:56c:3bb4:28a8 with SMTP id
 u7-20020aa78487000000b0056c3bb428a8mr44633084pfn.83.1669849852226; Wed, 30
 Nov 2022 15:10:52 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:27 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-44-seanjc@google.com>
Subject: [PATCH v2 43/50] KVM: Ensure CPU is stable during low level hardware
 enable/disable
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

Use the non-raw smp_processor_id() in the low hardware enable/disable
helpers as KVM absolutely relies on the CPU being stable, e.g. KVM would
end up with incorrect state if the task were migrated between accessing
cpus_hardware_enabled and actually enabling/disabling hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d985b24c423b..a46d61e9c053 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5028,7 +5028,7 @@ static struct miscdevice kvm_dev = {
 
 static void hardware_enable_nolock(void *junk)
 {
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
 	int r;
 
 	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
@@ -5070,7 +5070,7 @@ static int kvm_online_cpu(unsigned int cpu)
 
 static void hardware_disable_nolock(void *junk)
 {
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
