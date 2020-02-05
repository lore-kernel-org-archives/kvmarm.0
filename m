Return-Path: <SRS0=/ADY=3Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54214C35247
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 15:21:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC2CF217BA
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 15:21:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P2FVDi8o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC2CF217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F9E24A944;
	Wed,  5 Feb 2020 10:21:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FxN11PZZF1rt; Wed,  5 Feb 2020 10:21:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BE2F4A578;
	Wed,  5 Feb 2020 10:21:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 856CC4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 08:42:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x6HEhFqDZr4F for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Feb 2020 08:42:10 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BAB14A483
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 08:42:10 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580910130;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=2fNNJhELYa0usfT/vmjSSmqCwrduDZp8i5id/kXZ0c4=;
 b=P2FVDi8oxvJ4mL+uDqwlrYm2OlFtnXrCUTXESvNGAMbhPvRppRzaTPTym5TYbgCRlYnuQ8
 4FK08cHK8jxjwf84bJUyPe/HLUcbo57uyeorDOm510aA70/SZE3JITHL9+/7kmKQ8SN1je
 60sttja/FoOlCirOpjuRWnxlP/WoUp4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-CPKoeHXbNLG8SxUmm6x9bQ-1; Wed, 05 Feb 2020 08:42:05 -0500
Received: by mail-qk1-f198.google.com with SMTP id k10so1294082qki.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Feb 2020 05:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=63RqOoE/SUxs1bxyPTKTBeyS1B1iUtNQLL9J9vLKYh8=;
 b=hyCZ7UsJ/1zYx1kQ3aJuoP/SIkK9apiO9QKuzTor19VCakgOX5Qyid/6LhqGZXKmFk
 R4tkf8fc926WACpjVlcJcFw/11IQkuj74uMt54ZcFLunorwFioOZPvkvLoFBzqpEtVKh
 4R4Kvfjg5NWslRKkgvpJDalNPrRFD0zBPuf/cdmZdbg8uZMHhCOgM/GmcMgWrGGWQtsE
 /Uz4xqBJc8lfyZyTpBzKBQPfLoXblcz0VN5dAcX1MbQdZezsG1nvX5jOl0DQLKX1+tub
 vUPzZ4aGHu3ApC7ENMOBbgYxcRoDchYdxuKSVLFs49W0a/pGolEG1j5yy+yv4We62nFi
 vbAg==
X-Gm-Message-State: APjAAAUNbnbSnfQ7vQC3Dw9rkB3UEsU/DxayYh0ju7WteYhbh68RfrDO
 WVTVUH4IX5RGp7fvawcEKgXwGM9ZoW+QlFVWCULIOcRyoxSBGR0lMLahRwOH3m4jOD50oW1EC5w
 WN8Iea30YrNtn1G7xsfr3Z3df
X-Received: by 2002:a37:d0c:: with SMTP id 12mr33423424qkn.464.1580910124622; 
 Wed, 05 Feb 2020 05:42:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqwZ/1/Sty6fHl96Q69KjRb0mE9NhGj48HPjM78jNDpEMNN3g2vmML86vdJ+YqD/niUHe9OAuw==
X-Received: by 2002:a37:d0c:: with SMTP id 12mr33423403qkn.464.1580910124353; 
 Wed, 05 Feb 2020 05:42:04 -0800 (PST)
Received: from dev.jcline.org ([136.56.87.133])
 by smtp.gmail.com with ESMTPSA id g62sm12797091qkd.25.2020.02.05.05.42.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Feb 2020 05:42:03 -0800 (PST)
From: Jeremy Cline <jcline@redhat.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH] KVM: arm/arm64: Fix up includes for trace.h
Date: Wed,  5 Feb 2020 08:41:46 -0500
Message-Id: <20200205134146.82678-1-jcline@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-MC-Unique: CPKoeHXbNLG8SxUmm6x9bQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Wed, 05 Feb 2020 10:21:19 -0500
Cc: Jeremy Cline <jcline@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

Fedora kernel builds on armv7hl began failing recently because
kvm_arm_exception_type and kvm_arm_exception_class were undeclared in
trace.h. Add the missing include.

Signed-off-by: Jeremy Cline <jcline@redhat.com>
---

I've not dug very deeply into what exactly changed between commit
b3a608222336 (the last build that succeeded) and commit 14cd0bd04907,
but my guess was commit 0e20f5e25556 ("KVM: arm/arm64: Cleanup MMIO
handling").

Fedora's build config is available at
https://src.fedoraproject.org/rpms/kernel/blob/master/f/kernel-armv7hl-fedora.config

 virt/kvm/arm/trace.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index 204d210d01c2..cc94ccc68821 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -4,6 +4,7 @@
 
 #include <kvm/arm_arch_timer.h>
 #include <linux/tracepoint.h>
+#include <asm/kvm_arm.h>
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
