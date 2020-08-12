Return-Path: <SRS0=ktB0=BW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A11C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 12 Aug 2020 15:15:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7DBE20781
	for <kvmarm@archiver.kernel.org>; Wed, 12 Aug 2020 15:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F9c86y9V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7DBE20781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11B944B946;
	Wed, 12 Aug 2020 11:15:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YEZxO21tJopv; Wed, 12 Aug 2020 11:15:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F284F4B938;
	Wed, 12 Aug 2020 11:15:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 972EC4B82B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2020 10:05:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GAe88euZam-N for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2020 10:05:54 -0400 (EDT)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
 [209.85.215.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CA6B4B826
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2020 10:05:54 -0400 (EDT)
Received: by mail-pg1-f194.google.com with SMTP id p37so1109003pgl.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2020 07:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=Xd1JlhTQ+LLGkrxsiKUO3U1+DIxkbudA+7Iwr86BTU8=;
 b=F9c86y9VswsM0NUf74FtnnPIbwPvAQ9av1nET9wLixxZPMGcbjwrXQwXFtMX/zXngK
 SmteOy/Xapx4/roJdflzP4wkNi00uU+YCs5Fs17iom5qqsxoXJ3xszwJWsw4WZ5BTOtV
 vy3ecI9Xaep4Lctmf9PAETCTd5OGNtr2uXBjLD3m1Qf8dl4CO6h8ZaH30apV0dAYDE3G
 yj2BopxwB8J2ijJ5U1Iloe4L0UBBeadKBVq4avns03hDMvpeRdM0+jVZVFrhKhTkCnrZ
 v6OykPd4DwMDrN9nASoykO+ynV4Tyh87qnchtdZxqSmHOpMRFVvSXNyCZpbraJAzoi4H
 OnfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=Xd1JlhTQ+LLGkrxsiKUO3U1+DIxkbudA+7Iwr86BTU8=;
 b=huoloHFHZZZgwYXhlmhL+4wlJbyJnMdYqQu6VLmlQYNOSJ7TpmwineD6EAYludx8mn
 Al7v6VHB3YRiLMuTIX/pFtkLm5LaP33RFDn6vDWlEI+fwOZow5ggG4HP84AiOkVSfADf
 965eisz0PMx2NKRazgASzX97FvWWZAb8qI8SGyJ4nBrBm+ia5IeDqJ/Mum+KKB0NX6sP
 dj2+ZZQneTSeQWHbJM4BAOZN3w6kNhL6YIS9JncF4HPSjGJso7yddSH1J+yiN6YJMUhW
 YM75Bm6w8M592ZWkIJsp4KoH4fiT7j5iF1wCJnKpb5bto5Sq8bRZhHju+X8XjZ8rk8rH
 lNsg==
X-Gm-Message-State: AOAM531mywPFtriKnTiU1KiQ9AjCseOPIMCwjW1jX3QLFCUqAfsQlLQW
 O2eFNEJZ1NZCj0m+l4c7o3BHlxg=
X-Google-Smtp-Source: ABdhPJxqZMYDPp3Rjza7Lj0jActSfJ6DzFH8hI5Qkgg6uv/KnZxmirsVuHYk65hKLNQ8yYsyIzjrTA==
X-Received: by 2002:a62:8081:: with SMTP id j123mr11569824pfd.80.1597241152533; 
 Wed, 12 Aug 2020 07:05:52 -0700 (PDT)
Received: from mylaptop.redhat.com ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id s22sm2711033pfh.16.2020.08.12.07.05.48
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 12 Aug 2020 07:05:51 -0700 (PDT)
From: Pingfan Liu <kernelfans@gmail.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] arm(64)/kvm: improve the documentation about HVC calls
Date: Wed, 12 Aug 2020 22:05:33 +0800
Message-Id: <1597241133-3630-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 2.7.5
X-Mailman-Approved-At: Wed, 12 Aug 2020 11:15:16 -0400
Cc: Marc Zyngier <maz@kernel.org>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Pingfan Liu <kernelfans@gmail.com>,
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

Both arm and arm64 kernel entry point have the following prerequisite:
  MMU = off, D-cache = off, I-cache = dont care.

HVC_SOFT_RESTART call should meet this prerequisite before jumping to the
new kernel.

Furthermore, on arm64, el2_setup doesn't set I+C bits and keeps EL2 MMU
off, and KVM resets them when its unload. These are achieved by
HVC_RESET_VECTORS call.

Improve the document.

Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Cc: James Morse <james.morse@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
---
 Documentation/virt/kvm/arm/hyp-abi.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/arm/hyp-abi.rst b/Documentation/virt/kvm/arm/hyp-abi.rst
index d9eba93..a95bc30 100644
--- a/Documentation/virt/kvm/arm/hyp-abi.rst
+++ b/Documentation/virt/kvm/arm/hyp-abi.rst
@@ -40,9 +40,9 @@ these functions (see arch/arm{,64}/include/asm/virt.h):
 
 * ::
 
-    r0/x0 = HVC_RESET_VECTORS
+    x0 = HVC_RESET_VECTORS (arm64 only)
 
-  Turn HYP/EL2 MMU off, and reset HVBAR/VBAR_EL2 to the initials
+  Disable HYP/EL2 MMU and D-cache, and reset HVBAR/VBAR_EL2 to the initials
   stubs' exception vector value. This effectively disables an existing
   hypervisor.
 
@@ -54,7 +54,7 @@ these functions (see arch/arm{,64}/include/asm/virt.h):
     x3 = x1's value when entering the next payload (arm64)
     x4 = x2's value when entering the next payload (arm64)
 
-  Mask all exceptions, disable the MMU, move the arguments into place
+  Mask all exceptions, disable the MMU and D-cache, move the arguments into place
   (arm64 only), and jump to the restart address while at HYP/EL2. This
   hypercall is not expected to return to its caller.
 
-- 
2.7.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
