Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8618EC4724C
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:48:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3E8B22074A
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:48:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="DGkgyiQ0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E8B22074A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDC5E4B3A2;
	Thu, 30 Apr 2020 10:48:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fyicbcKsj1Pq; Thu, 30 Apr 2020 10:48:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFA354B511;
	Thu, 30 Apr 2020 10:48:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 256D74B500
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:48:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7qBYnw02QeWU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 10:48:51 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEDE54B412
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:48:50 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id f13so7223839wrm.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=W2dOZedYL4JDAAn5nSlmNV+ZjvfKthEjodtzNjqCunU=;
 b=DGkgyiQ0NginXnf8otO/F358XbxPMWkiqajyOjWp3qrwhI3IjJ5VxpWltUxTWpeYhi
 EzYTPLQUJPaT54+Gtq8bQ/kq/LVPXUUOLOkSY4quVOuInKuAhg+If+fiiQWZrk8sg4/2
 wucgIlbFqPSMeVyM7Tcx67kTqaT8iYVNoc7mQXwSN0bIG9PAdu2aOyVCUs1RYJDOp7G5
 J6bYFSMfSCNjHyHht0n7BO/pvp6s1HqaBb0j+1ewoIQxJMbwGe4MmXheqZK06lVBoxN9
 Ih1WCF5C/x/zOa0VU71rHZ7tBJxntN008fOtfonZDN0KIx0kOZdvJ4PzQkI7mNQBaWUq
 yiAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=W2dOZedYL4JDAAn5nSlmNV+ZjvfKthEjodtzNjqCunU=;
 b=ZjKX5DkX5i7mkNfDHmEy/BvqVXNNLBSX8m0vwhJRIZWqwQid1yivJ6V6eiC4THYUOj
 UMyntJiJKUQ9NNCarLp1R+af8fL0A+mzkdaHDU5W+Ke0KGdBdsJzCySG258ADrlhaWZT
 GKq9ZbzVIxg4gxKhAHIw4/RB5n/sXwskfEMYgkiuBNQbtQryD+GxsnHFgFtANr5ZWtMU
 gK8qEUSs1w5B8RSnMNhtVMoDXFaEWNG7PIZorScwk51dD0ATIkW2Zzoc47S6EcSAZTM3
 BDBbY0bpyom4OyYxhLLschSXesl79WGZsdewTmQnsvSWhqtbf5LOn1Dnl0mGqqNvskps
 HL7w==
X-Gm-Message-State: AGi0Pua0dBOXvq8JHp/xzyNLg4Kp5n+jMatb37O+IgHAB1IjFi+64eGF
 2vvZa+JzJwEcchHIS5QzUW1sww==
X-Google-Smtp-Source: APiQypI092ppnnKBWs4+7y2ui5zUBh7qAbqhxW88bEw98VWLvJPs/WkNEiKJyOlPkCmjk7ivxSWnJQ==
X-Received: by 2002:adf:e445:: with SMTP id t5mr4244456wrm.223.1588258129829; 
 Thu, 30 Apr 2020 07:48:49 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d4b6:9828:8bd2:ce6f])
 by smtp.gmail.com with ESMTPSA id b66sm12780787wmh.12.2020.04.30.07.48.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Apr 2020 07:48:48 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH 03/15] arm64: kvm: Fix symbol dependency in
 __hyp_call_panic_nvhe
Date: Thu, 30 Apr 2020 15:48:19 +0100
Message-Id: <20200430144831.59194-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200430144831.59194-1-dbrazdil@google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

__hyp_call_panic_nvhe contains inline assembly which did not declare
its dependency on the __hyp_panic_string symbol.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8a1e81a400e0..7a7c08029d81 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -836,7 +836,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 	 * making sure it is a kernel address and not a PC-relative
 	 * reference.
 	 */
-	asm volatile("ldr %0, =__hyp_panic_string" : "=r" (str_va));
+	asm volatile("ldr %0, =%1" : "=r" (str_va) : "S" (__hyp_panic_string));
 
 	__hyp_do_panic(str_va,
 		       spsr, elr,
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
