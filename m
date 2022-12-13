Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D3B2C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2867C4B951;
	Mon, 12 Dec 2022 19:17:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d02DjtbhnBAT; Mon, 12 Dec 2022 19:17:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0B374B944;
	Mon, 12 Dec 2022 19:17:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 397B14B955
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kRCfpBZsHT-x for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:17 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 346F74B93C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:16 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 j18-20020a170902da9200b00189b3b16addso11773624plx.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=nM41DSVBAJr+S3W93Zis4JAYC8eUvXamzXgPZLD06L8=;
 b=nYe6ZWOHPMJgTGksZPiEisBf6HPHtTh7LwnzxBJxPqoYHxDIXfUXIa80Wv8FT5deaA
 UzHNYFP0DWaotAozDYEqkVOhGC3cJzSjZIrX35uJMvKk0qzEdjbF5qj55iPpjtEz3ipO
 bm8VP2buvMYoUm5bBSsgzK0AvSdBMq0gU3WwNjXiGhrTir7XSUZ3UlUPkv2SzjZJXHyV
 BW7oqPIg9/2WzHp2xjLzs82Y3ewdbcwG+wxaYmUKR44YKrwYEmcWRcUYbv914+1ep3vj
 XM381ihLSB7s6K13WjVWXGmod93EwbDCFi3RC00C/qqJJxPj4hbmeVdBA7F4fDCsvIiB
 q4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=nM41DSVBAJr+S3W93Zis4JAYC8eUvXamzXgPZLD06L8=;
 b=hQDLlZEG3qXV/7K+NhUwDXVCEjYOmnA37ZrqjsQljo4WqNAWI5e+EpW4QhLVd719+t
 cbXh30Xd4DzUl8a3Bhf3DaIqKlIhzkx5LCeQ3oB3DjeQyEky1U27Ag9s7EFnV5ZJ1IEc
 XcTwrIIcc6pSxjxUrPZe+7jxh86bLipbnSrewQQhYnzOA8WiGVJ5HTiYQQZcvQgjyMH7
 UDT2EPLSLU02ouB90KhhayUkCP545VVeu/cK6ZoyWibN4Cd/2kW1CyQ9eui9rdUspRg5
 rxid5FA99hD/swlD6QxOFKkeLRbxsRCst7rv/qQ8gVlZmSfABCC0TGZEcxAY1n9mI8FR
 ESiQ==
X-Gm-Message-State: ANoB5pmbylJlyb1MLmvn2I5MusCiEhY3vqCAD+OySM/BlTyh9Z6jJbiY
 cyZ3Q2hSlNKtVrMj8Yw9gTWOAGmGxI4=
X-Google-Smtp-Source: AA0mqf6ZbJmcYrZNpc/Z0ppwmhrlHhb+cLSNTmH678oSo0UQF9b8LuTc9fdveE6JT7fYmZu7x1S++6s+7UY=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c406:b0:189:6df9:4f85 with SMTP id
 k6-20020a170902c40600b001896df94f85mr62591897plk.27.1670890635443; Mon, 12
 Dec 2022 16:17:15 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:50 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-12-seanjc@google.com>
Subject: [PATCH 11/14] KVM: selftests: Disable
 "gnu-variable-sized-type-not-at-end" warning
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
 Tom Rix <trix@redhat.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Disable gnu-variable-sized-type-not-at-end so that tests and libraries
can create overlays of variable sized arrays at the end of structs when
using a fixed number of entries, e.g. to get/set a single MSR.

It's possible to fudge around the warning, e.g. by defining a custom
struct that hardcodes the number of entries, but that is a burden for
both developers and readers of the code.

lib/x86_64/processor.c:664:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                struct kvm_msrs header;
                                ^
lib/x86_64/processor.c:772:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                struct kvm_msrs header;
                                ^
lib/x86_64/processor.c:787:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                struct kvm_msrs header;
                                ^
3 warnings generated.

x86_64/hyperv_tlb_flush.c:54:18: warning: field 'hv_vp_set' with variable sized type 'struct hv_vpset'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
        struct hv_vpset hv_vp_set;
                        ^
1 warning generated.

x86_64/xen_shinfo_test.c:137:25: warning: field 'info' with variable sized type 'struct kvm_irq_routing'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
        struct kvm_irq_routing info;
                               ^
1 warning generated.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 2487db21b177..9cff99a1cb2e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -196,6 +196,7 @@ else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
+	-Wno-gnu-variable-sized-type-not-at-end \
 	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
