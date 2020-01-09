Return-Path: <SRS0=UWlR=26=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD014C33CA2
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 16:23:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 950872067D
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 16:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c5Eljg8Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 950872067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AF084B249;
	Thu,  9 Jan 2020 11:23:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GAPVfn1z69Ag; Thu,  9 Jan 2020 11:23:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 046BD4B24E;
	Thu,  9 Jan 2020 11:23:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2F1C4ACFA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 11:09:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xSZJhupkhZxQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jan 2020 11:09:37 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE2EA4A982
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 11:09:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1578586177;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mua/qHbvjxBZzAa9DGgUWjthaiVLr4wGp81bwymTxFo=;
 b=c5Eljg8ZOZJt2KVzzWYiZiw3aAQddX008DirZRopY94TzxdWlSAdeD+1yhGNpTh8hZaE6W
 JSy0+27pVuUYTvRUhnrOTD6mKMb+GVGdusg7CbW+euTg1wt8ju8/DYfu7tihrlx+djVE6N
 Ot+EXxd/x57x+GWpO3+Wkag9fuPNfO4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-EwnQ1etbOvC8t0wUxZWydQ-1; Thu, 09 Jan 2020 11:09:36 -0500
Received: by mail-wm1-f72.google.com with SMTP id l11so891461wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jan 2020 08:09:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=NXlvrJt6z83MLX+WxwdFOCINB+GcX+Yj981D0b2qPGQ=;
 b=gZh0IIGIlpcI7WoRbwiNZc+B/L0hwZG3G6L01dPwHwqVHeRgPpA9Rr21WhBty20BM8
 IiiNQ+02dUjMWhybjh99CBPYED8QWkSX/o1A4UMr37c0qDevbHbICS4xu05W5/Q4XfL1
 6a2aInDAbUtFr9rj5oKzdFamX5opkxkae1Rj1QieUTVu066P5qGwUsQ+JwJLoSEMdKgu
 ZDuk98U+QlJQoXzTvE+y33fX+aW7j0ozZzvluSaF7segpTfIc1Uzh+brzVEt4gSUn7L/
 1udtYZ4hcFj1JbjX2K7ArK8vhCLyDTXJ7ktMaG2yKONBG/NL4WlCA2vy1kF+ZKBNGywk
 QTtw==
X-Gm-Message-State: APjAAAUFxDUHGpvFCVFphDnoECkCUmKTKkYgHSJAkSBetls8pHqLjBhP
 F9XRuc3cBRa608iIZFuqtIsdZaaRcpwiN4TlCFg0JbXko5tHs6jb1mG5tZb10gc4Z1EvBUIt9Ih
 z/2nPWRE4jEKa/PVBh9JrZIKs
X-Received: by 2002:a7b:cbc9:: with SMTP id n9mr5807757wmi.89.1578586175351;
 Thu, 09 Jan 2020 08:09:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqzmBZZfDXBq6RqR3Rkcb9sOH+t9Q3MfPwQWoV78KSevOPVEW0amjALm+VNPMHJy5/8IKwjOOA==
X-Received: by 2002:a7b:cbc9:: with SMTP id n9mr5807724wmi.89.1578586175172;
 Thu, 09 Jan 2020 08:09:35 -0800 (PST)
Received: from redfedo.redhat.com
 (host81-140-166-164.range81-140.btcentralplus.com. [81.140.166.164])
 by smtp.gmail.com with ESMTPSA id e8sm8517707wrt.7.2020.01.09.08.09.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Jan 2020 08:09:34 -0800 (PST)
From: Julien Thierry <jthierry@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [RFC v5 52/57] arm64: kernel: Annotate non-standard stack frame
 functions
Date: Thu,  9 Jan 2020 16:02:55 +0000
Message-Id: <20200109160300.26150-53-jthierry@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200109160300.26150-1-jthierry@redhat.com>
References: <20200109160300.26150-1-jthierry@redhat.com>
MIME-Version: 1.0
X-MC-Unique: EwnQ1etbOvC8t0wUxZWydQ-1
X-Mimecast-Spam-Score: 0
X-Mailman-Approved-At: Thu, 09 Jan 2020 11:23:21 -0500
Cc: Marc Zyngier <maz@kernel.org>, Julien Thierry <jthierry@redhat.com>,
 peterz@infradead.org, catalin.marinas@arm.com, raphael.gault@arm.com,
 jpoimboe@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Raphael Gault <raphael.gault@arm.com>

Annotate assembler functions which are callable but do not
setup a correct stack frame.

Signed-off-by: Raphael Gault <raphael.gault@arm.com>
Signed-off-by: Julien Thierry <jthierry@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kernel/hyp-stub.S | 3 +++
 arch/arm64/kvm/hyp-init.S    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 73d46070b315..8917d42f38c7 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -6,6 +6,7 @@
  * Author:	Marc Zyngier <marc.zyngier@arm.com>
  */

+#include <linux/frame.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/irqchip/arm-gic-v3.h>
@@ -42,6 +43,7 @@ ENTRY(__hyp_stub_vectors)
 	ventry	el1_fiq_invalid			// FIQ 32-bit EL1
 	ventry	el1_error_invalid		// Error 32-bit EL1
 ENDPROC(__hyp_stub_vectors)
+asm_stack_frame_non_standard __hyp_stub_vectors

 	.align 11

@@ -69,6 +71,7 @@ el1_sync:
 9:	mov	x0, xzr
 	eret
 ENDPROC(el1_sync)
+asm_stack_frame_non_standard el1_sync

 .macro invalid_vector	label
 \label:
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 160be2b4696d..63deea39313d 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -12,6 +12,7 @@
 #include <asm/pgtable-hwdef.h>
 #include <asm/sysreg.h>
 #include <asm/virt.h>
+#include <linux/frame.h>

 	.text
 	.pushsection	.hyp.idmap.text, "ax"
@@ -118,6 +119,7 @@ CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
 	/* Hello, World! */
 	eret
 ENDPROC(__kvm_hyp_init)
+asm_stack_frame_non_standard __kvm_hyp_init

 ENTRY(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
@@ -159,6 +161,7 @@ reset:
 	eret

 ENDPROC(__kvm_handle_stub_hvc)
+asm_stack_frame_non_standard __kvm_handle_stub_hvc

 	.ltorg

--
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
