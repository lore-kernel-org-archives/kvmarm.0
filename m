Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3786C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 15:25:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB6A449F16;
	Mon,  7 Feb 2022 10:25:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pPUSyukdRBnA; Mon,  7 Feb 2022 10:25:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0472540AEB;
	Mon,  7 Feb 2022 10:25:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF9549ED2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:25:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lEkdaGb5p0rb for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 10:25:15 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8207740307
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:25:14 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0FBC561035;
 Mon,  7 Feb 2022 15:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7F4C36AE5;
 Mon,  7 Feb 2022 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644247513;
 bh=P2l5Y5PDPDJcPc6k74icHUD6sRurj6ctKkCgiE7n3uE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GwDZ+wBUFJUMKkD02uctycJ9tckUk66WaU4CCFPzqDZpvqtuR9GUR1+fvJW2xNxA8
 QzBzTx9pAr8PJEag7w6O+X+4RpHUxLYFjUDEwZQBlteCg9vrm1xK/JmGfOK+msmQYY
 yx/YwOF5IngplcxGcsZ7mNLRrI/iOz38gCZXCFVHSN+EFdt2+fOSUqXGvropDGxkxO
 KzTY68gU+wMEo+XDnMUqu9ydV0wMzAmOciNPlhYLIiCidqXnk/FIgsuV+IoPOyRegv
 IqFhOE3uCkzNNyf0WjhDsDRWwrhczzaJ0m6zCvhFkgAz9mNZVrm/OP020sTLWq6Gq0
 Dxe+X/V7F4w+Q==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v11 31/40] kselftest/arm64: sme: Add SME support to vlset
Date: Mon,  7 Feb 2022 15:21:00 +0000
Message-Id: <20220207152109.197566-32-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1924; h=from:subject;
 bh=P2l5Y5PDPDJcPc6k74icHUD6sRurj6ctKkCgiE7n3uE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiATjd0NLZUlSrS0ljIljKX74U6FT3bMa5qmpqk6ae
 Fh5vWGeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYgE43QAKCRAk1otyXVSH0FHjB/
 9lJbOqBI3wCopmc7onTSKA0GBFHJOoQjZpz+qIvpkeGvCRWfs71TTs6qNs2DYmV2VMR8QGyzJdK4C7
 87bltiBzapBDlH+7ZJzOjWH7z4+xiaZKqJyNqblcLk9qW/AROXf3iHnlSQCkjCRU+5IgLQxxEqovf6
 YOV7fnzI2dyHAi3mFOmTnZuNnkiF8fcRHO5w5LVF3e8aZop6iGk85mN0pgyzk1V4pK1VI+xA+/73WY
 30smG16GpYbeJaZYWvy0Cy9s6Ui10ILg9bGeQFP9yh+kL+ZpC7CI+BFCQFmaRxBEm9ZloZqzyS+VGe
 17XSYaFojdKLWTqijjTem4w+bvAzmL
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
