Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF53C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 21:01:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6912F4B125;
	Tue, 23 Nov 2021 16:01:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q5KM3OQbyuD7; Tue, 23 Nov 2021 16:01:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B55554B16C;
	Tue, 23 Nov 2021 16:01:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96BF84B129
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 16:01:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X+P+-VAR5Yy2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 16:01:21 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0CA04B11B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 16:01:21 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 i8-20020a056e021d0800b0029e81787af1so192890ila.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 13:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BwedrBbB5HTyTT2p4mXfIz5QYgjh9yNsR4b4hzDoNcc=;
 b=Qaaf+qNAHsw9kOiocwlPyQ0uu8vL8UJhBqb8PdL3yfi+rhltZxP2GUdFo8KKxXIF2y
 6IZ/uxBz0Ahn+4GR5yWfCfWrL5FHSvGty4CvmlOR4qAkUXmWWSnW2VS4HHgxJF3nAYup
 8230IweKBYk0p9mch3LGMraTTxEIO/uKA/L4wA8eXpXuoz23U2AkmV39GFksQQCQ8DhE
 WnE0rEBRBf4zorX53WPARK1svet5e8XOn3nqGqDjANt/uI7PgRy/KuUil9dGh1ZiLL9D
 IZnfjhI6ieihzJ92jh8EwquSdmAAvY8mdCwlu/6dhLJundiUSd5Dy3HfdQnBwv7ny618
 ZOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BwedrBbB5HTyTT2p4mXfIz5QYgjh9yNsR4b4hzDoNcc=;
 b=tb6/i8BBKKwvnsi/e41i94jdMGPz2CyB1hpRj3FQ2QuDNNRy9NwxmEocy+2eGSZFl4
 9szCOZu+tJDxtfPGr6z7av6rcQVeL1njiZe8QYCTMrKOXwxF+ibFYMyrN03ixDOcHRxV
 cl/fGzru+IN6K4jqP37EEs5yAN4Yiiqu+5AcjEj28Kbu7bRVhEfVZQ+rrzpTIfre5xaW
 pebdMhvBr4KiJ/oGQbIvqXKmKac3hpN/cWux4FP/2MhnxcTvnlaNBIFAhGsENhoFwdVG
 w7yiGAnYTEGJk4MhfEAg8Em7SQudae0ZP0TN42DTTOJMu8CWTGgU82XGh10453y2KKgt
 O3Iw==
X-Gm-Message-State: AOAM53070j0ZNcB7Qv4GSWO4/j8xBTYzYc9ZeCIeEw4PlCdcZl9Gao//
 CmM8Ka+55zMOQLGlCE0wni6TSpNlTvtdmIgHfS368dQQ0aeWx8fSp8v/xuTA5fr8+LCYbK9lHCn
 Oi/yobFuXwYKNUz2wB0/EEXHUCIAxkUs+ibpQc8JXswOKr0yZHSuJFwwF4jJjuS2SYsZLrQ==
X-Google-Smtp-Source: ABdhPJzaYhRodYov80jU9UDbdbd9k79+gVGKWsjAcZxXmdtDiHN7YN7VKm1c4GS5SZfFz37xFHlrrmZumXw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:8bc2:: with SMTP id
 n185mr8931449iod.174.1637701281216; 
 Tue, 23 Nov 2021 13:01:21 -0800 (PST)
Date: Tue, 23 Nov 2021 21:01:08 +0000
In-Reply-To: <20211123210109.1605642-1-oupton@google.com>
Message-Id: <20211123210109.1605642-6-oupton@google.com>
Mime-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 5/6] selftests: KVM: Add OSLSR_EL1 to the list of blessed
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
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
