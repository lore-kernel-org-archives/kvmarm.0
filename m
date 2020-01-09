Return-Path: <SRS0=UWlR=26=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356FAC282DD
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 16:23:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA99B2067D
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 16:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NeWvznwh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA99B2067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E78594B2A5;
	Thu,  9 Jan 2020 11:23:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZUV12IKIjexi; Thu,  9 Jan 2020 11:23:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E27284B249;
	Thu,  9 Jan 2020 11:23:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E09C4B258
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 11:09:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S9-4SMmK0RpY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jan 2020 11:09:03 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FAF84B25B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 11:09:03 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1578586142;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mAHGJTw6emz4uceIu6DFrravfZx1rImSewv+paxvKpM=;
 b=NeWvznwhu6IOg2T+okfQtm9Spc39vdv0C5pOl3q15FBKISSxowYZRYUpQrqwlcXORg5mHD
 CzQ2miJ11o36Jqp6y8a4+dglKVjbni3CC4yAILoxRpz37yZCDUjBVwG4g/3f3bNZss3Mba
 GfnmR2S+92OS/K/yEfnht0cyzxVAjvE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-D9T_c8RDP1uRQ4igGnCRtw-1; Thu, 09 Jan 2020 11:09:01 -0500
Received: by mail-wm1-f71.google.com with SMTP id c4so1096418wmb.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jan 2020 08:09:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=4dPDKFSZi3e3u+46jDRIhE74sgAn3tXL+nGRZRHhzxI=;
 b=Zbdh8gzOLN15Sc1eQL21BRyr02ayVrq1fufeX2R0tdmI+tf5F+sfcA1xZ1ADNoVtwa
 5zZrp7hh7Y7IbHTilVaa4X/MOdSPbUnHriiYQpRCe4TynwO6KAGM2AI5Q1GZeKQZF/t6
 chAsRZ1uf2CnkQubzIC10V6DE0kWNNuwv99ntGIhCFlvflhaEwUagJobv3gNc0JfcOc4
 UU2kd28z1s80imV45L0Ec0wb67OOyGyJHyD6rPmSTnfjVL9yj5HhTLYZ1GsQz8bWrvzV
 iCqv07T91gMiVdyEnE9FcktiUE21z7ZkUof5K7d2S8XqTPJx8Iyeik0XCYbi47ay6Dip
 D9gw==
X-Gm-Message-State: APjAAAW+hjTDkOM12TWwdiJxHRxasyHEkEo2SnvAeRTr3OhUCMo1zTJc
 9zvbh5fYDsMrdvYlyCp0/vT8RIPd4g1vGgPCtfHhwOR34ZK9JBiy8oObU1LnfIWvbN69OT5J4TS
 nbUKfW5V+PZPzhQKZB7x8oFM2
X-Received: by 2002:adf:a746:: with SMTP id e6mr12285687wrd.329.1578586140101; 
 Thu, 09 Jan 2020 08:09:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqxidILoaEYUa5ievTi0I/NuFQayb9Diwg52FSlLGCUYTke4Wmfm1U43xAy4el85wmxpFXckwg==
X-Received: by 2002:adf:a746:: with SMTP id e6mr12285661wrd.329.1578586139895; 
 Thu, 09 Jan 2020 08:08:59 -0800 (PST)
Received: from redfedo.redhat.com
 (host81-140-166-164.range81-140.btcentralplus.com. [81.140.166.164])
 by smtp.gmail.com with ESMTPSA id v8sm8403505wrw.2.2020.01.09.08.08.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Jan 2020 08:08:59 -0800 (PST)
From: Julien Thierry <jthierry@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [RFC v5 49/57] arm64: kvm: Annotate non-standard stack frame functions
Date: Thu,  9 Jan 2020 16:02:52 +0000
Message-Id: <20200109160300.26150-50-jthierry@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200109160300.26150-1-jthierry@redhat.com>
References: <20200109160300.26150-1-jthierry@redhat.com>
MIME-Version: 1.0
X-MC-Unique: D9T_c8RDP1uRQ4igGnCRtw-1
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

Both __guest_entry and __guest_exit functions do not setup
a correct stack frame. Because they can be considered as callable
functions, even if they are particular cases, we chose to silence
the warnings given by objtool by annotating them as non-standard.

Signed-off-by: Raphael Gault <raphael.gault@arm.com>
Signed-off-by: Julien Thierry <jthierry@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/hyp/entry.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index e5cc8d66bf53..c3443bfd0944 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -15,6 +15,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_ptrauth.h>
+#include <linux/frame.h>

 #define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
 #define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
@@ -97,6 +98,7 @@ alternative_else_nop_endif
 	eret
 	sb
 ENDPROC(__guest_enter)
+asm_stack_frame_non_standard __guest_enter

 ENTRY(__guest_exit)
 	// x0: return code
@@ -193,3 +195,4 @@ abort_guest_exit_end:
 	orr	x0, x0, x5
 1:	ret
 ENDPROC(__guest_exit)
+asm_stack_frame_non_standard __guest_exit
--
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
