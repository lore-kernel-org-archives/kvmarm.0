Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F79C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C14D20720
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="aR3924TG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C14D20720
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3752E4B0FF;
	Thu, 25 Jun 2020 09:14:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RPuKGD1a38Ok; Thu, 25 Jun 2020 09:14:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6B14B543;
	Thu, 25 Jun 2020 09:14:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2574B512
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E0lL9n6L6OUt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:27 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21DAE4B520
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:27 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id q5so5785484wru.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=djiFW55yS1Rp4YNDz8isiFDt/Jj9YD2Q3nFMXytrXY8=;
 b=aR3924TG/GhiA+e7cSIyaJXA4Y+WubHOl2DXaNi1c0reM2jrYsW9uqw6yFadKgakVd
 XP/Ylg3kWsXPqPO0Ppu8rrrHbJPhaXOVHRa+esGXU6xwqh85CssuLdYju0YgANwUpFLQ
 es5wVqJK+4N3Ef7qF0XOda0fdxFiosUz/4tRhGvAA+oww2CasCmo0yBcKTETiOp1Ljiv
 YpNbGFi5F3sjN3M0z2JxhAflHCvzASzCC0A4VwKKideeVL33accPM86TTKg2K+mBsLtL
 /DZ3oFEbTF082pksDvRp/4Aukeo3/MT+qjhPr2+PRjoWyZyfJYoikkmbznirPdvyZ8hD
 0xFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=djiFW55yS1Rp4YNDz8isiFDt/Jj9YD2Q3nFMXytrXY8=;
 b=E80LZ38tcKdHVRajUcY1kSo36JM2RKklkT8by5Ag7PpA4stGk1dSlSkJ7N/lFAxWao
 Gty2aT32ZrKs8BqCx96sj44M+Sp71NQlKnNZdppnmCw0c7XbkpDCbDfRYbhARcnlnVDI
 fqdxxpelD011P3WOorrqmPwFNMWsW67nIAAB/J8ywgkkVfAdJeDTLWabZ3ZUE9QlDobZ
 DoWk1/+/dZiO4+MO9nz72o/JMMU3quor+QwSAakbIrlSFuUvpLuAELhRynJj0vQc5qOF
 8/mIRMGa1FyCdfw5Fg7lBK6dG8aRgeSEwJdva842MY86qlMYbcOD1zPFv13qwt0ekvnK
 sIHg==
X-Gm-Message-State: AOAM531UTXK0CN0u89bEBRJ+r9p1de+n01Pl+DU6usZQxqy4R5Fc5nMb
 uJY8//skLippM4AR9QDZhDLXcA==
X-Google-Smtp-Source: ABdhPJwznHV4hv6Fj3Er6LKY8SIiHuc2Snez1YpadUkoPjJ25Jk5PeHh1uhQrUEuukHkOvjncxyEfA==
X-Received: by 2002:adf:e647:: with SMTP id b7mr37709680wrn.170.1593090866123; 
 Thu, 25 Jun 2020 06:14:26 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id d13sm16942574wrn.61.2020.06.25.06.14.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:25 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 01/15] arm64: kvm: Fix symbol dependency in
 __hyp_call_panic_nvhe
Date: Thu, 25 Jun 2020 14:14:06 +0100
Message-Id: <20200625131420.71444-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625131420.71444-1-dbrazdil@google.com>
References: <20200625131420.71444-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

__hyp_call_panic_nvhe contains inline assembly which did not declare
its dependency on the __hyp_panic_string symbol.

The static-declared string has previously been kept alive because of a use in
__hyp_call_panic_vhe. Fix this in preparation for separating the source files
between VHE and nVHE when the two users land in two different compilation
units. The static variable otherwise gets dropped when compiling the nVHE
source file, causing an undefined symbol linker error later.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index db1c4487d95d..9270b14157b5 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -897,7 +897,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 	 * making sure it is a kernel address and not a PC-relative
 	 * reference.
 	 */
-	asm volatile("ldr %0, =__hyp_panic_string" : "=r" (str_va));
+	asm volatile("ldr %0, =%1" : "=r" (str_va) : "S" (__hyp_panic_string));
 
 	__hyp_do_panic(str_va,
 		       spsr, elr,
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
