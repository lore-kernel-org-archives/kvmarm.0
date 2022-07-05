Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05037C43334
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jul 2022 14:23:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B7CF4BEEB;
	Tue,  5 Jul 2022 10:23:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gMDImLTFcJj2; Tue,  5 Jul 2022 10:23:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4884BEE2;
	Tue,  5 Jul 2022 10:23:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 634E64BEE1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2022 10:23:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FdyIXnJiCdxB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jul 2022 10:23:25 -0400 (EDT)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F34954BEAA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2022 10:23:24 -0400 (EDT)
Received: by mail-ed1-f73.google.com with SMTP id
 n8-20020a05640205c800b00434fb0c150cso9330666edx.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jul 2022 07:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=2zQlYc9U3hxiIn86A5QE2kEqLA+X+YH+JZD8cteagW8=;
 b=fqCtfyiWnz/sDbhBL26vUNigBrQZ7zc1r3SbimUnoBkTZIKAL796jt+N0l7Ug0wnn+
 75Cal62Cu7Fahm0ZR6w8DSiM6GATiDJdvNIUqzFzHnrMR78YCmguqNM6frxwfTRTggqK
 sOFFIN06fK9vVqaLxRvQB9VGFNhHVu7o5octaE1JxZu4S2GtzqeaFhfSyul1iRTL5MG8
 MCbDUtMAqnfI9JBgZFh2FWoQ1tnV/HCzi1nrsw/5xcM4Hyq9wsjtUBZVYlXWrzHhos98
 FHC99aEQ8ZprYBhSGhJGV6WuD9HIzFbbIx+2xsPs8lgThNEgd35vSvR0UwfkaTd0+bxq
 9sYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=2zQlYc9U3hxiIn86A5QE2kEqLA+X+YH+JZD8cteagW8=;
 b=rN9N8oc/nLzb6JO1aUXSkLFmWbT69osNVWXBF6tHSfdyqR9UOfxcjmLA0V6fLchTaT
 7a2aCbWlg4s3kVFXMJXa90IoM2Xl4iiE4b8de4aDxiln3/Ex3cUqjoIDWuxXkM1FSTRO
 8Vwzfyy8yPMMks8ZtlBqb2KL8y+Nnu/RL3g8vWGccvoByhzcA3iGtLltlNIoXs3Npl7M
 4x20ERSAnhQbIP/HItHXaKfxo2oIoWiC8M+OGO2SS3hTEfdRKTaDniCp9dpFdTsQFFQ5
 c5yIS9fl7VSq9EIGf4Rukttmuy1mkQXcUaxW5ZOP7a164dz6SS5w802nYWxh2OKnObH8
 5UWA==
X-Gm-Message-State: AJIora+lrvpEWHQESr6/gah4ETiz9dMwX8TAzD+eeOuGzcon5G2AqvRa
 zIaClluHdEBOJfFVXzQ3CTnBdMw3XFyc
X-Google-Smtp-Source: AGRyM1tNS+g/vNh5/iHJY0oJdpY+ypTBmtMZDDMx1nXevSQ85XuXevbZFlKhTyDeX1hSIW57PP5R15KNfRy1
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:906:7790:b0:722:e6cf:126 with SMTP id
 s16-20020a170906779000b00722e6cf0126mr33544579ejm.244.1657031003645; Tue, 05
 Jul 2022 07:23:23 -0700 (PDT)
Date: Tue,  5 Jul 2022 14:23:10 +0000
Message-Id: <20220705142310.3847918-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] KVM: arm64: Don't return from void function
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
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

Although harmless, the return statement in kvm_unexpected_el2_exception
is rather confusing as the function itself has a void return type. The
C standard is also pretty clear that "A return statement with an
expression shall not appear in a function whose return type is void".
Given that this return statement does not seem to add any actual value,
let's not pointlessly violate the standard.

Build-tested with GCC 10 and CLANG 13 for good measure, the disassembled
code is identical with or without the return statement.

Fixes: e9ee186bb735 ("KVM: arm64: Add kvm_extable for vaxorcism code")
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6db801db8f27..925b34b7708d 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -386,5 +386,5 @@ asmlinkage void __noreturn hyp_panic_bad_stack(void)
 
 asmlinkage void kvm_unexpected_el2_exception(void)
 {
-	return __kvm_unexpected_el2_exception();
+	__kvm_unexpected_el2_exception();
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 969f20daf97a..390af1a6a9b4 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -249,5 +249,5 @@ void __noreturn hyp_panic(void)
 
 asmlinkage void kvm_unexpected_el2_exception(void)
 {
-	return __kvm_unexpected_el2_exception();
+	__kvm_unexpected_el2_exception();
 }
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
