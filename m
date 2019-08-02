Return-Path: <SRS0=eGRX=V6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C88C433FF
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 15:15:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C90B204EC
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 15:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="ClkjwnuA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C90B204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lca.pw
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 174DC4A532;
	Fri,  2 Aug 2019 11:15:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@lca.pw
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eY7LyQzbYK2D; Fri,  2 Aug 2019 11:14:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E250F4A541;
	Fri,  2 Aug 2019 11:14:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E71FA4A4FD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 10:23:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BplcBb3kXfv3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Aug 2019 10:23:38 -0400 (EDT)
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com
 [209.85.222.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C46A94A4DF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 10:23:38 -0400 (EDT)
Received: by mail-qk1-f193.google.com with SMTP id r4so54812767qkm.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Aug 2019 07:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lca.pw; s=google;
 h=from:to:cc:subject:date:message-id;
 bh=CWdgiiN/Z+VeLUxPy5NDLjA/glfsWptWvE0Hk0bA4Qc=;
 b=ClkjwnuAjyQX4RFGsqAZhTjqGMDy7ocP/0TCroEDlhL07SsQmlRYVGn8aIHaHRwUCf
 utzbV9Rw0J2YHV76T0ve3706m4aR1IZDfRam5C9funveugiRgC8FUpWqlxtq2tFKy7Hd
 VfsToKr4T96EcEkZOa1EYCPGLYzko/sCPdVXxdcyEjThSesEn1Yukp4qAFEBL8pv9AD7
 cQ+rtCtxrN7cT7v5yWDPwKLFyjF7Rnrrjf2zLhORo1f2RRy4znki0byJia/elQpyLyRH
 W9Kr1qkd/1ceoeZGcwQI6LhEwYkuiNtZoZc8nOVzH9lX4xcZnaGp0ETvzemP5soQs71N
 fvgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=CWdgiiN/Z+VeLUxPy5NDLjA/glfsWptWvE0Hk0bA4Qc=;
 b=LsLVB4ib8W0MIQDwfz8NzeSZp7BDLrr+Dv+ecTLOlR5tlbmnVrFuifma5AZ1QjFhu9
 FcL4cRa4cCQaaEARWwQm4dnrarMDBsuijmsZSQ14ob6SF7jJsogyDyhAwVD9R3kp+XQr
 fZ+ta/Z87zw+RRdk6rvVwZdarRtIp7Xx7NrrW/omtrR92+bzMHnJ/xiycrLkUL56TGwK
 LYZoNaF2U/HoXnHu2YNoPA3jrU5zp/SQmmPE+syS76QNebLvrY3G5J1sQBhw6sGhbBZG
 6qYsa7YWdGqa4nGX+L/3f2gZF/n8ZEnnZADNxI+fNT20KGxAIPPZwFMtJfb+4qip6YsB
 fnPA==
X-Gm-Message-State: APjAAAUID0MD+/C3udTHmLsp0VvuuLnqZ7PuqsIrgtjgjLom6Qa1m53k
 Gh8G1lFzLJtslm5jGaQedBwGqA==
X-Google-Smtp-Source: APXvYqz+KxEnFgHjSy1G4Be0JgFETmApxP1tkP5flW/+UvCcQ+n9HdUVJ9MvLVxmfppI//mnB3tdag==
X-Received: by 2002:a37:2c46:: with SMTP id s67mr92776362qkh.396.1564755818363; 
 Fri, 02 Aug 2019 07:23:38 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
 by smtp.gmail.com with ESMTPSA id v84sm33042439qkb.0.2019.08.02.07.23.36
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 02 Aug 2019 07:23:37 -0700 (PDT)
From: Qian Cai <cai@lca.pw>
To: maz@kernel.org
Subject: [PATCH] arm64/kvm: fix -Wimplicit-fallthrough warnings
Date: Fri,  2 Aug 2019 10:23:08 -0400
Message-Id: <1564755788-28485-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
X-Mailman-Approved-At: Fri, 02 Aug 2019 11:14:58 -0400
Cc: linux-kernel@vger.kernel.org, christoffer.dall@linaro.org,
 Qian Cai <cai@lca.pw>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The commit a892819560c4 ("KVM: arm64: Prepare to handle deferred
save/restore of 32-bit registers") introduced vcpu_write_spsr32() but
seems forgot to add "break" between the switch statements and generates
compilation warnings below. Also, adding a default statement as in
vcpu_read_spsr32().

In file included from ./arch/arm64/include/asm/kvm_emulate.h:19,
                 from arch/arm64/kvm/regmap.c:13:
arch/arm64/kvm/regmap.c: In function 'vcpu_write_spsr32':
./arch/arm64/include/asm/kvm_hyp.h:31:3: warning: this statement may
fall through [-Wimplicit-fallthrough=]
   asm volatile(ALTERNATIVE(__msr_s(r##nvh, "%x0"), \
   ^~~
./arch/arm64/include/asm/kvm_hyp.h:46:31: note: in expansion of macro
'write_sysreg_elx'
 #define write_sysreg_el1(v,r) write_sysreg_elx(v, r, _EL1, _EL12)
                               ^~~~~~~~~~~~~~~~
arch/arm64/kvm/regmap.c:180:3: note: in expansion of macro
'write_sysreg_el1'
   write_sysreg_el1(v, SYS_SPSR);
   ^~~~~~~~~~~~~~~~
arch/arm64/kvm/regmap.c:181:2: note: here
  case KVM_SPSR_ABT:
  ^~~~
In file included from ./arch/arm64/include/asm/cputype.h:132,
                 from ./arch/arm64/include/asm/cache.h:8,
                 from ./include/linux/cache.h:6,
                 from ./include/linux/printk.h:9,
                 from ./include/linux/kernel.h:15,
                 from ./include/asm-generic/bug.h:18,
                 from ./arch/arm64/include/asm/bug.h:26,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/mmdebug.h:5,
                 from ./include/linux/mm.h:9,
                 from arch/arm64/kvm/regmap.c:11:
./arch/arm64/include/asm/sysreg.h:837:2: warning: this statement may
fall through [-Wimplicit-fallthrough=]
  asm volatile("msr " __stringify(r) ", %x0"  \
  ^~~
arch/arm64/kvm/regmap.c:182:3: note: in expansion of macro
'write_sysreg'
   write_sysreg(v, spsr_abt);
   ^~~~~~~~~~~~
arch/arm64/kvm/regmap.c:183:2: note: here
  case KVM_SPSR_UND:
  ^~~~
In file included from ./arch/arm64/include/asm/cputype.h:132,
                 from ./arch/arm64/include/asm/cache.h:8,
                 from ./include/linux/cache.h:6,
                 from ./include/linux/printk.h:9,
                 from ./include/linux/kernel.h:15,
                 from ./include/asm-generic/bug.h:18,
                 from ./arch/arm64/include/asm/bug.h:26,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/mmdebug.h:5,
                 from ./include/linux/mm.h:9,
                 from arch/arm64/kvm/regmap.c:11:
./arch/arm64/include/asm/sysreg.h:837:2: warning: this statement may
fall through [-Wimplicit-fallthrough=]
  asm volatile("msr " __stringify(r) ", %x0"  \
  ^~~
arch/arm64/kvm/regmap.c:184:3: note: in expansion of macro
'write_sysreg'
   write_sysreg(v, spsr_und);
   ^~~~~~~~~~~~
arch/arm64/kvm/regmap.c:185:2: note: here
  case KVM_SPSR_IRQ:
  ^~~~
In file included from ./arch/arm64/include/asm/cputype.h:132,
                 from ./arch/arm64/include/asm/cache.h:8,
                 from ./include/linux/cache.h:6,
                 from ./include/linux/printk.h:9,
                 from ./include/linux/kernel.h:15,
                 from ./include/asm-generic/bug.h:18,
                 from ./arch/arm64/include/asm/bug.h:26,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/mmdebug.h:5,
                 from ./include/linux/mm.h:9,
                 from arch/arm64/kvm/regmap.c:11:
./arch/arm64/include/asm/sysreg.h:837:2: warning: this statement may
fall through [-Wimplicit-fallthrough=]
  asm volatile("msr " __stringify(r) ", %x0"  \
  ^~~
arch/arm64/kvm/regmap.c:186:3: note: in expansion of macro
'write_sysreg'
   write_sysreg(v, spsr_irq);
   ^~~~~~~~~~~~
arch/arm64/kvm/regmap.c:187:2: note: here
  case KVM_SPSR_FIQ:
  ^~~~

Fixes: a892819560c4 ("KVM: arm64: Prepare to handle deferred save/restore of 32-bit registers")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 arch/arm64/kvm/regmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index 0d60e4f0af66..c94e9bc3e8eb 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -178,13 +178,20 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
 	switch (spsr_idx) {
 	case KVM_SPSR_SVC:
 		write_sysreg_el1(v, SYS_SPSR);
+		break;
 	case KVM_SPSR_ABT:
 		write_sysreg(v, spsr_abt);
+		break;
 	case KVM_SPSR_UND:
 		write_sysreg(v, spsr_und);
+		break;
 	case KVM_SPSR_IRQ:
 		write_sysreg(v, spsr_irq);
+		break;
 	case KVM_SPSR_FIQ:
 		write_sysreg(v, spsr_fiq);
+		break;
+	default:
+		BUG();
 	}
 }
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
