Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F59FC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 17:28:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE0364B1BF;
	Tue, 14 Dec 2021 12:28:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ad6JUmZNPbPA; Tue, 14 Dec 2021 12:28:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC0D84B23C;
	Tue, 14 Dec 2021 12:28:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 403D24B1F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uhvqPwjnDY7e for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 12:28:23 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9310C4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:22 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 r1-20020a92cd81000000b002a3ae5f6ad9so18362784ilb.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=1Jwvt2jUDR/UART7D/evy6xX8nTOg9MzOLHWtI9aqPs=;
 b=SzpEesm+Mh2jg4QGy8qBWU5SuQUrhFLEHQSQshWM9fM4hoZ9A7wBdjrOY5vU7OIJ2h
 G3Ye+hM9b1QwZJvy9WGZyTpicP54IeYAVoMLcvcY2NYRkOVUvIILLL7dsfh0DbRNj/Wk
 LNfobwMekfHZuTNXHlaMmu+WlD2KONk+nM3s8drKYTagGFa/Mnpx1MhsVA9gyz2DxpsB
 A10VPKejwxiLgNvOm0pvoxY+xDNSPbwsxeDlIQYKhTl52zX5PoJsoIUx+od9VJELicAp
 IZYShzHylChaqzxJhRTArPhpSQxSRA6cbYBn7l+GjtDdkfZtQKph6JvnXFjoDiScnQpx
 2csg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1Jwvt2jUDR/UART7D/evy6xX8nTOg9MzOLHWtI9aqPs=;
 b=Q4Mb1fEuZksiJiIs6S/ZKRxfV7eCc8s3DVMjzrViIq/sAlqM+uH0n+bQA8xTELzOLr
 Th2xIwkw07gS8lE4n+4Vat2WHOU+k18rukhSrz8lbS8o9pVzON0iMxfL0A0FSwgD9NYt
 rgTBANSbA+B+O3XPKKYcqapUncRnnQT74ty7l2N+wzGDkCCOJSHWXMxzvo/YDLvqTXfh
 +buvsdsunLYfRI6NjK4W0hGfwY6mCcUSVw11tNQrnsqzVF6lHeksQ0MZzSJm/Azbvhpb
 N/RLYqR/S9IzWXj9fQtvzTTJaQEAjyKFKkHDag+zu5nB7fZhk6WWtGT+S12d6gGIDB1c
 Yi9g==
X-Gm-Message-State: AOAM531TkGeDW5an+4gzXCvJUmzckgaLov/EPeobmMvC3+uoeH3GIYR1
 ZvKsTxfQDJSvjpRhuOVyQXX3DRShb2h7WRnpYBTglXK8gGZ4iiT1J1chmx3AtoIQdjkXunxQTEM
 YazxG54MxFBD8erQfp9raaZ029Tf+Ei2Fa/S1g/9h12EfW7gyuYxAe2GnWzhDL/PYlQw2jQ==
X-Google-Smtp-Source: ABdhPJy18yNyWrBFa7EmeTStINtjn7maODxM/UjDHu9TWrMLPrCpYH3fBbsImp3Jixp6csA+szHEYxhmlG0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:1604:: with SMTP id
 x4mr4626833iow.84.1639502901988; Tue, 14 Dec 2021 09:28:21 -0800 (PST)
Date: Tue, 14 Dec 2021 17:28:11 +0000
In-Reply-To: <20211214172812.2894560-1-oupton@google.com>
Message-Id: <20211214172812.2894560-6-oupton@google.com>
Mime-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 5/6] selftests: KVM: Add OSLSR_EL1 to the list of blessed
 regs
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

OSLSR_EL1 is now part of the visible system register state. Add it to
the get-reg-list selftest to ensure we keep it that way.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..0c7c39a16b3f 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -761,6 +761,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(2, 0, 0, 15, 6),
 	ARM64_SYS_REG(2, 0, 0, 15, 7),
 	ARM64_SYS_REG(2, 4, 0, 7, 0),	/* DBGVCR32_EL2 */
+	ARM64_SYS_REG(2, 0, 1, 1, 4),	/* OSLSR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 0, 5),	/* MPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 1, 0),	/* ID_PFR0_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 1, 1),	/* ID_PFR1_EL1 */
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
