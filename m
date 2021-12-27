Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52DAC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 27 Dec 2021 12:49:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4145640FAA;
	Mon, 27 Dec 2021 07:49:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bMrSOGNjIdlb; Mon, 27 Dec 2021 07:49:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7D6E49E20;
	Mon, 27 Dec 2021 07:49:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 381024052C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Dec 2021 07:49:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mkx1aXD6yJuh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Dec 2021 07:48:59 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C89D40C10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Dec 2021 07:48:59 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 88C1A60F3C;
 Mon, 27 Dec 2021 12:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3380C36AE7;
 Mon, 27 Dec 2021 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1640609338;
 bh=Xlmzd6uUTWdOSWaStHp5yLqb3jDTsl7a86GMPfk49ns=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=lewsgRhXWiM5UUf0n6VtXuv+3u5kfPbr3WV9z4NI3Rde+pJaAl/7FUymwHjzdkXKC
 p2CYGNGKLi/Nrczv+viJScw+QyXe87MWmMP6h1mRVZkrlDLE4+oGY6leNceTk8/NFQ
 UB+lSa0S9kmAXxksrZxWOffp2CsAq55fW5kpyxosWsLFI4dzt6g2ty3HR4B4laDZrC
 sS3NAAmOFurSwYyyyBBkeUhTwTGM/B/5rNLOhaJeL3+GkIkh+995phSsl5nQ4yEwDI
 rtqeAV2M32P6a1phEp6J/Mt7EEQUjJTw63p2ZkEA7VJUIqvswJFkOLUL8N1GaRrCPf
 V9JKYqkc9+Mvg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n1pQu-00EYBY-4Z; Mon, 27 Dec 2021 12:48:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [PATCH v2 1/6] KVM: selftests: arm64: Initialise default guest mode
 at test startup time
Date: Mon, 27 Dec 2021 12:48:04 +0000
Message-Id: <20211227124809.1335409-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211227124809.1335409-1-maz@kernel.org>
References: <20211227124809.1335409-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

As we are going to add support for a variable default mode on arm64,
let's make sure it is setup first by using a constructor that gets
called before the actual test runs.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index b4eeeafd2a70..b509341b8411 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -432,3 +432,12 @@ uint32_t guest_get_vcpuid(void)
 {
 	return read_sysreg(tpidr_el1);
 }
+
+/*
+ * arm64 doesn't have a true default mode, so start by computing the
+ * available IPA space and page sizes early.
+ */
+void __attribute__((constructor)) init_guest_modes(void)
+{
+       guest_modes_append_default();
+}
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
