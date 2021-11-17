Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80346C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 168586321B
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 168586321B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C047B4A5A0;
	Wed, 17 Nov 2021 01:53:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VDIPr-kUBsvr; Wed, 17 Nov 2021 01:53:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40ABF4B0B6;
	Wed, 17 Nov 2021 01:53:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C099E4A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fSWVZAlx+8Ec for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:01 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79EBF4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:01 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 r23-20020a17090a941700b001a74be6cf80so772345pjo.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=EWy90w7C8DEQ1vuhiOPoGiKAV2Py3BtH8vbgtJOob/M=;
 b=farwWaGHDp+BJPkIl9cjFCayMUEmwN32tMCgYlXLKI11ppCFUHe2zJGtjZbWjUwkRr
 yPM9N8gd7kYnReGOSL1Za3CcPR79kRzCUVmBh9dHLbUPbJIcE7b1HaqIoka5NOGOMUD9
 KjuFnNcXm4Y0gjLrBTYa4TPv7PV19P+647eUqA1GmjiA5J9+NxB5Ju9jfzOyadu6PCF4
 HwH660ONcWXcuuecLlZycXkSp3eaaEtZmZ8v9Cm1VreF4Mkr9lOEOWzuDQCqyg/szpTS
 dXe+J145D096FZQIdLj37NnlGYV0cirsUNPWclerfciCDssRW3GgCD70vV3vp3KEetIL
 P4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EWy90w7C8DEQ1vuhiOPoGiKAV2Py3BtH8vbgtJOob/M=;
 b=vqRPijbDVLkWRGlalHKTFKKrmFPaS3xp/CZsMq49Xw1aEzNL0eIfwC0b1bXHldTV75
 ot8vuJwQgRX8dNHqF+m1D5ez9a7x5KrKegc0ZQsIxVfB6w5Z1hAUJufUEFzJLxkScrGh
 iP+nXWpyZIiMeK/U45y8AOQUm/6z6YVzGYwCPEYalG8vr3Ej0S03FI9ca5Ldw5ynzNiT
 jxKinpTRSwmB3XNKay97Iox8GwPDs+0d/H1u+igul6qzEAC3l0bRklejdMQYvSmTQKoV
 sYPXvrhXARPIKLDUEQZS1YN8ZWeFHwpDr6z0E5bnsrUFEyXupV+Hm5ZfYr2sxjj6TDDK
 f5gA==
X-Gm-Message-State: AOAM533B3FOrMgHQ0LUkMz0Jzoxbj2/QBz4ZIEvyHwcIi1wD1ztJuNj5
 Ku11eiwm/JZL03A5HCHq9y950B2Twls=
X-Google-Smtp-Source: ABdhPJxTX5Ui25fj7I1/W09kifmBD7hv5qJ71Mwl9g4XyAIXdzKDt8IM28bi7JUXoF+/FHXLa6ILu2RhNVw=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:390c:: with SMTP id
 y12mr314550pjb.0.1637131980501; Tue, 16 Nov 2021 22:53:00 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:39 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-10-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
expose the value for the guest as it is.  Since KVM doesn't support
IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
exopse 0x0 (PMU is not implemented) instead.

Change cpuid_feature_cap_perfmon_field() to update the field value
to 0x0 when it is 0xf.

Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..fd7ad8193827 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
 
 	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
 	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
-		val = 0;
+		return (features & ~mask);
 
 	if (val > cap) {
 		features &= ~mask;
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
