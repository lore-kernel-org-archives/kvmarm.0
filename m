Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583BCC4321E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2A0A4B643;
	Wed, 30 Nov 2022 18:10:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VJGxmiMeCkdm; Wed, 30 Nov 2022 18:10:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE7184B64A;
	Wed, 30 Nov 2022 18:10:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90BB54B28D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OYHmYk9CuCIy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:32 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2B594B39B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:29 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 m62-20020a252641000000b006f16683bb4eso17875653ybm.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=syK6eF0z1YIhw5KnDfEJ/sqHR3QdYzGhfq3h/5i5Sas=;
 b=GVS6tfQs69HM9iPg5RyanavfgqTtstL/hP2NZwyz6ZiOn7sQ0OggFONinN3Xpq5A5O
 ROAGkLrScqRoWmoumJCapQkQLkR93EZiZmJgM/igbQR0yiEQhTM5NlbokX/zSqXnB7+r
 NTk4xoTIRJmdEYgV5XTVp3WbKa8QFND0VjYsfazhzfL9lIlQKqNHJYrNBIvwG1lwEaBo
 U+Ok61fL2GtL8yDcgFKd5TgqnT7w/4A4Fxq0CZ9SiNKAiH0owEiGaxOBRpIJfpm0capw
 Q57SZ4+/8uPzzEqCtGgs63hTCqUtPFogvCulI6jofLJAraG2Zyu8sPd3r85eKSZc1cYA
 LlTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=syK6eF0z1YIhw5KnDfEJ/sqHR3QdYzGhfq3h/5i5Sas=;
 b=TsLcEDAGeLyq4OeNX4+O4CBtNvorJoLSQjS5HeFL+Dv54ENdurJj4XU6ktAfDkOwuV
 +PSzlm0hOYGETvcIq9596W3eHjwwfR1JUnIf1cddedP+PEpYF0o/eczG/r7BVexjbaGu
 Z6Aibx9iTjTymjumXDviD8bM0eOzDHZFZ7Nv1mz95oE+gUwSKXP4aULNoiYManCidp2n
 4jIgYrGgGiaUhxRx3CbYxozSC0VUJNR1xFk+C8ddFZ4oC1sEohRbNl5qfvsoT9cWRAha
 nIvAYNzYbhbjVQ+JUNqenX44CnBZ2QCLfN6sGq2kN3BziCfnX7izJIajHyhFylge09vl
 3Fow==
X-Gm-Message-State: ANoB5pnB6bL/3Cfda58jqOeKPv3Ke9krnuE5NaKtbfa04PKc7k60bL3p
 QNDCuN/JbyCy66/OCI1PQD6YG5xQAYU=
X-Google-Smtp-Source: AA0mqf6GlYmz6ao1Ocazy6XnieuesyYU9e/N0B6T5bGw3DwYIfX3lPKm+B7r5ybTp9p3YaVUKLjnuY7j4Vk=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:e8b:b0:3c9:bdbf:444d with SMTP id
 cq11-20020a05690c0e8b00b003c9bdbf444dmr15670072ywb.56.1669849829390; Wed, 30
 Nov 2022 15:10:29 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:14 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-31-seanjc@google.com>
Subject: [PATCH v2 30/50] KVM: VMX: Make VMCS configuration/capabilities
 structs read-only after init
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

Tag vmcs_config and vmx_capability structs as __init, the canonical
configuration is generated during hardware_setup() and must never be
modified after that point.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cd2ac9536c99..45162c1bcd8f 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -66,13 +66,13 @@ struct vmcs_config {
 	u64 misc;
 	struct nested_vmx_msrs nested;
 };
-extern struct vmcs_config vmcs_config;
+extern struct vmcs_config vmcs_config __ro_after_init;
 
 struct vmx_capability {
 	u32 ept;
 	u32 vpid;
 };
-extern struct vmx_capability vmx_capability;
+extern struct vmx_capability vmx_capability __ro_after_init;
 
 static inline bool cpu_has_vmx_basic_inout(void)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 76185a7a7ded..654d81f781da 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -488,8 +488,8 @@ static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
 
-struct vmcs_config vmcs_config;
-struct vmx_capability vmx_capability;
+struct vmcs_config vmcs_config __ro_after_init;
+struct vmx_capability vmx_capability __ro_after_init;
 
 #define VMX_SEGMENT_FIELD(seg)					\
 	[VCPU_SREG_##seg] = {                                   \
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
