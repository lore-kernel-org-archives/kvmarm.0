Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E6AC28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:32:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 572074B0DE;
	Wed, 26 Jan 2022 10:32:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QWozcuFjsSph; Wed, 26 Jan 2022 10:32:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3675E4B08E;
	Wed, 26 Jan 2022 10:32:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB31D40DCB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:32:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bjUgmLAS+tB4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:32:32 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B152F49EBC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:32:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E6290B81EAA;
 Wed, 26 Jan 2022 15:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48240C340EB;
 Wed, 26 Jan 2022 15:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643211150;
 bh=HZPqgEGfMDOJRbR9O3affXiwGZAfPzgR37m4iq1abJY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=DM/sFMCm8BAxLC9hhxvRN9TMKnYPiIZ4rJCxZi5Y+n5luX5F+yj7o/lSw7CyQuCh1
 nk+by49KEDEJPnOLuQEpLHgbxVHK0BnjplMuSlGx2kaMjjwYhL3F4ybIU58dbEoVds
 VVxTKeRXWPq7ikAGuSbulwKWRELvRRgVl0wOGD9WtFyyeTuy2c9l/JlJtWPNuoGKXx
 hFYX0iozcI2TBLHYbKbf8E1ww1t38Wqx7jFe0hSW/k4c9fbKUQOR/kQljorHcS5lSl
 t/3Fc3unyMLeFszPTUhEHxDP9i6D4KrKEmoTNeWcL4WNPUE4ge1Ycl71CZacpMcIAG
 w6zPJ0lotoxEg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v10 33/39] kselftest/arm64: signal: Allow tests to be
 incompatible with features
Date: Wed, 26 Jan 2022 15:27:43 +0000
Message-Id: <20220126152749.233712-34-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126152749.233712-1-broonie@kernel.org>
References: <20220126152749.233712-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3936; h=from:subject;
 bh=HZPqgEGfMDOJRbR9O3affXiwGZAfPzgR37m4iq1abJY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh8WhvpfEXhZMiZZEUpvipJ+vhpvj7BzhhYgFzTZOk
 zo69Z22JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYfFobwAKCRAk1otyXVSH0DleB/
 49aNFJUP6cAReTRgcm9nmKjI03RrQ/u2deYgMMbukMZIuOw7p+QZPPeXTmII0OMTpKjl9KgX3Qozrg
 XrsK/CDQoY2/SNBnCEvSqnrDX+lGvB4FiH22sF0j9AZhEam/C/P8wwa6feQdgnx569KQ3TmrBoF/wE
 jnnYGEvf2Ax6mN8FCrUGpmXsYAHjy7yVgBAsTZ23VZFY7lsI0se38hGEX/SaFRd+eLPnnuCSpug5PG
 EBlwFKxJ1wVIbMnzFQSar6FHfN9PTBKES5Ro9O0Lb7zwMnb0RMx9uPMiVHNAyfaRWAEeXC1z8Y/x0i
 FedeOvpVeJxvF2mEz0hILb9tOdxkjv
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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

Some features may invalidate some tests, for example by supporting an
operation which would trap otherwise. Allow tests to list features that
they are incompatible with so we can cover the case where a signal will
be generated without disruption on systems where that won't happen.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 .../selftests/arm64/signal/test_signals.h     |  1 +
 .../arm64/signal/test_signals_utils.c         | 34 ++++++++++++++-----
 .../arm64/signal/test_signals_utils.h         |  2 ++
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/arm64/signal/test_signals.h b/tools/testing/selftests/arm64/signal/test_signals.h
index ebe8694dbef0..f909b70d9e98 100644
--- a/tools/testing/selftests/arm64/signal/test_signals.h
+++ b/tools/testing/selftests/arm64/signal/test_signals.h
@@ -53,6 +53,7 @@ struct tdescr {
 	char			*name;
 	char			*descr;
 	unsigned long		feats_required;
+	unsigned long		feats_incompatible;
 	/* bitmask of effectively supported feats: populated at run-time */
 	unsigned long		feats_supported;
 	bool			initialized;
diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.c b/tools/testing/selftests/arm64/signal/test_signals_utils.c
index 2f8c23af3b5e..5743897984b0 100644
--- a/tools/testing/selftests/arm64/signal/test_signals_utils.c
+++ b/tools/testing/selftests/arm64/signal/test_signals_utils.c
@@ -36,6 +36,8 @@ static inline char *feats_to_string(unsigned long feats)
 {
 	size_t flen = MAX_FEATS_SZ - 1;
 
+	feats_string[0] = '\0';
+
 	for (int i = 0; i < FMAX_END; i++) {
 		if (feats & (1UL << i)) {
 			size_t tlen = strlen(feats_names[i]);
@@ -256,7 +258,7 @@ int test_init(struct tdescr *td)
 		td->minsigstksz = MINSIGSTKSZ;
 	fprintf(stderr, "Detected MINSTKSIGSZ:%d\n", td->minsigstksz);
 
-	if (td->feats_required) {
+	if (td->feats_required || td->feats_incompatible) {
 		td->feats_supported = 0;
 		/*
 		 * Checking for CPU required features using both the
@@ -267,15 +269,29 @@ int test_init(struct tdescr *td)
 		if (getauxval(AT_HWCAP) & HWCAP_SVE)
 			td->feats_supported |= FEAT_SVE;
 		if (feats_ok(td)) {
-			fprintf(stderr,
-				"Required Features: [%s] supported\n",
-				feats_to_string(td->feats_required &
-						td->feats_supported));
+			if (td->feats_required & td->feats_supported)
+				fprintf(stderr,
+					"Required Features: [%s] supported\n",
+					feats_to_string(td->feats_required &
+							td->feats_supported));
+			if (!(td->feats_incompatible & td->feats_supported))
+				fprintf(stderr,
+					"Incompatible Features: [%s] absent\n",
+					feats_to_string(td->feats_incompatible));
 		} else {
-			fprintf(stderr,
-				"Required Features: [%s] NOT supported\n",
-				feats_to_string(td->feats_required &
-						~td->feats_supported));
+			if ((td->feats_required & td->feats_supported) !=
+			    td->feats_supported)
+				fprintf(stderr,
+					"Required Features: [%s] NOT supported\n",
+					feats_to_string(td->feats_required &
+							~td->feats_supported));
+			if (td->feats_incompatible & td->feats_supported)
+				fprintf(stderr,
+					"Incompatible Features: [%s] supported\n",
+					feats_to_string(td->feats_incompatible &
+							~td->feats_supported));
+
+
 			td->result = KSFT_SKIP;
 			return 0;
 		}
diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.h b/tools/testing/selftests/arm64/signal/test_signals_utils.h
index 6772b5c8d274..f3aa99ba67bb 100644
--- a/tools/testing/selftests/arm64/signal/test_signals_utils.h
+++ b/tools/testing/selftests/arm64/signal/test_signals_utils.h
@@ -18,6 +18,8 @@ void test_result(struct tdescr *td);
 
 static inline bool feats_ok(struct tdescr *td)
 {
+	if (td->feats_incompatible & td->feats_supported)
+		return false;
 	return (td->feats_required & td->feats_supported) == td->feats_required;
 }
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
