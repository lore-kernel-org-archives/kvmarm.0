Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFE4C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:36:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3070A4B910;
	Fri, 25 Feb 2022 12:36:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oCqjAjJwdkZP; Fri, 25 Feb 2022 12:36:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E88064B9BD;
	Fri, 25 Feb 2022 12:36:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A17C4B940
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BfFvjgiC7PRh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:36:26 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 002084B910
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:25 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7037261DBD;
 Fri, 25 Feb 2022 17:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD8FC340F4;
 Fri, 25 Feb 2022 17:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810584;
 bh=cjWtOVTxWeUhc8tEXrG+oxZLQRfcD6x2BU4M+8l+kZw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=o8nj4P+qf4aKzzLlItPq3t4z7LaMTHrSAJOqPF9/4eEJgx2fCOodMO7fdh1eShRi9
 VgWgqy/YVZzuEacZjrUxJI6qArNSpK8cE9DypWaO7oATFcuoFQPj1DNcs3yCFVszWf
 neBxwibEnbANsI2LoXKMl5SdYdlMrb1aSB1NC5EbmYaqLnrxWFmxCWW0w8dq/Gzd3c
 UwJJAMPxY9FPQ9uDwrInDhDsl7wmMepFyM4U4k2hmIf76Rt1hoNdLoZ+DLAzaKgL2i
 q5lcHhSn669f2MIxEb/y6B8ekznhwdPUi0CkAm5KKMUF4PipvvVovdlnaNYBvOFNDB
 0cxnXGGvRPEiQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 31/40] kselftest/arm64: sme: Add SME support to vlset
Date: Fri, 25 Feb 2022 16:59:14 +0000
Message-Id: <20220225165923.1474372-32-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2030; h=from:subject;
 bh=cjWtOVTxWeUhc8tEXrG+oxZLQRfcD6x2BU4M+8l+kZw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGQriqSqngTRPNR7b870myCkuGHBQcIi35Nqt0awJ
 vjGk/iaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkK4gAKCRAk1otyXVSH0B8XB/
 9MvXvfOpV3LWdAzOU8nerQK46Z2R7bEc6mqWEyExefq7fCEyVQFRJXeoH9xo7l4geqoqVynw4ctC/T
 32yYJX6zArBJSgjiUZhew7jFhf/x60YAOTFdFXuqq3jbJwnPzjF4OO+IlrzfktiyjbS9F7Z7xwNEPW
 ph923E7NC+qUd4wEmcen/pC5shWJbXg+U8gMh/K2jfMAiLFG1sJ/OuGZDle3p/3+CJddsno5yyEJ3T
 Bprerc36k3qbTNCrHfDECVGKvhgquTJRo88TRTGmnIWzPdIpEEslzHwFdApHw6aRlccMlRct6iD0Wa
 JBWsoiCoJ0W5PLGBd2WATW+X5a58c4
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

The Scalable Matrix Extenions (SME) introduces additional register state
with configurable vector lengths, similar to SVE but configured separately.
Extend vlset to support configuring this state with a --sme or -s command
line option.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 tools/testing/selftests/arm64/fp/vlset.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/fp/vlset.c b/tools/testing/selftests/arm64/fp/vlset.c
index 308d27a68226..76912a581a95 100644
--- a/tools/testing/selftests/arm64/fp/vlset.c
+++ b/tools/testing/selftests/arm64/fp/vlset.c
@@ -22,12 +22,15 @@ static int inherit = 0;
 static int no_inherit = 0;
 static int force = 0;
 static unsigned long vl;
+static int set_ctl = PR_SVE_SET_VL;
+static int get_ctl = PR_SVE_GET_VL;
 
 static const struct option options[] = {
 	{ "force",	no_argument, NULL, 'f' },
 	{ "inherit",	no_argument, NULL, 'i' },
 	{ "max",	no_argument, NULL, 'M' },
 	{ "no-inherit",	no_argument, &no_inherit, 1 },
+	{ "sme",	no_argument, NULL, 's' },
 	{ "help",	no_argument, NULL, '?' },
 	{}
 };
@@ -50,6 +53,9 @@ static int parse_options(int argc, char **argv)
 		case 'M':	vl = SVE_VL_MAX; break;
 		case 'f':	force = 1; break;
 		case 'i':	inherit = 1; break;
+		case 's':	set_ctl = PR_SME_SET_VL;
+				get_ctl = PR_SME_GET_VL;
+				break;
 		case 0:		break;
 		default:	goto error;
 		}
@@ -125,14 +131,14 @@ int main(int argc, char **argv)
 	if (inherit)
 		flags |= PR_SVE_VL_INHERIT;
 
-	t = prctl(PR_SVE_SET_VL, vl | flags);
+	t = prctl(set_ctl, vl | flags);
 	if (t < 0) {
 		fprintf(stderr, "%s: PR_SVE_SET_VL: %s\n",
 			program_name, strerror(errno));
 		goto error;
 	}
 
-	t = prctl(PR_SVE_GET_VL);
+	t = prctl(get_ctl);
 	if (t == -1) {
 		fprintf(stderr, "%s: PR_SVE_GET_VL: %s\n",
 			program_name, strerror(errno));
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
