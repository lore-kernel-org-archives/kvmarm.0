Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CC0C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D6ED64F3E
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D6ED64F3E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C42554B63A;
	Tue,  2 Mar 2021 10:00:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MFA0pMLCjV3p; Tue,  2 Mar 2021 10:00:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C126A4B66A;
	Tue,  2 Mar 2021 10:00:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04C544B65C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f8VJ-nrc3945 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:27 -0500 (EST)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EF364B66A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:27 -0500 (EST)
Received: by mail-qt1-f202.google.com with SMTP id k4so5494838qtd.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=T621CrLzDVvHMT7g1JI2svAdR9qKxB9zRXJEq9CxOEU=;
 b=JhVB1bpGiYn1jRzMxn5C86Cv84iFwqhC6iR5apn3eWaYAhiRMUSeUiA/loGNHC6UEZ
 WXJ7G+oIo0kRVVksB+BCF8QFW7BhegDukCh8s7n3swxcqA2kN9JLclL0IFaqfGiqGYZw
 wMwnC0Nm6lKe/+9njbqaVCvnF2gW6ls0LuTrHRUJwjGtQbiS/ziLG8McYhBEndabj5u4
 lXqBAEzmTjgHHDB+UnlVBrk5jiudORfTBxu2CTEnE8ITDIwRVAd2UVMEl4YPH6u1i4cw
 18SIyImxlr2wYX1yNBmi2YQPDuGfAGwYpUaQcVzbN2FuvEq9+DGEN/acYO9wm5gY3URn
 WgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=T621CrLzDVvHMT7g1JI2svAdR9qKxB9zRXJEq9CxOEU=;
 b=RKl3FOfRThGSsRRk7xK2tDad+HYWpii9Ogydl7KmTAkdI8vkvAaTpEdG15vEZ8dQ8l
 QID0lPLZxh/WVFipndfOOLASEpX7JcxceDtOClNjAQ7nwS71ZmvtzL8wzw5S717VGa0v
 H754YXy+04lfUIsAnaYjPgHmOmgdS8O/qWt2V1DxhYTwjyOJVjK56SHvGFecXMVbRFHb
 OWbRKw30UFBPB6e68/2QalYU5UQqiQVKmAxNG9SFiLQbOuyVdQvfV+jpUPwBUsWUkY1/
 94jIf5YXVf7qXozdQN6cj6WVx2Zt8JQVK/l/9vvadP65Q4HIdMaDwwJ+KWOEWXmHvPrt
 k+3w==
X-Gm-Message-State: AOAM533wKUq0WWmv6zY43YYYsm7OyYcFWNYOAIgxyS17g7TE+nMB7OPV
 kRNRAMspHfCD0HGBWKxFWyYavshwaWAl
X-Google-Smtp-Source: ABdhPJz1Cnzac8s5SYaMmUMvh8VTsVMc6vRSeZjJ+2CAkCroHCAupXgtoMWTtWwTuJftkM7mvaKD3quAWmDb
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:b7a7:: with SMTP id
 l39mr3898578qve.56.1614697226584; Tue, 02 Mar 2021 07:00:26 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:39 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-10-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 09/32] KVM: arm64: Allow using kvm_nvhe_sym() in hyp code
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

In order to allow the usage of code shared by the host and the hyp in
static inline library functions, allow the usage of kvm_nvhe_sym() at
EL2 by defaulting to the raw symbol name.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/hyp_image.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
index 78cd77990c9c..b4b3076a76fb 100644
--- a/arch/arm64/include/asm/hyp_image.h
+++ b/arch/arm64/include/asm/hyp_image.h
@@ -10,11 +10,15 @@
 #define __HYP_CONCAT(a, b)	a ## b
 #define HYP_CONCAT(a, b)	__HYP_CONCAT(a, b)
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 /*
  * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_,
  * to separate it from the kernel proper.
  */
 #define kvm_nvhe_sym(sym)	__kvm_nvhe_##sym
+#else
+#define kvm_nvhe_sym(sym)	sym
+#endif
 
 #ifdef LINKER_SCRIPT
 
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
