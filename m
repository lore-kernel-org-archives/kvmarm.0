Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D81C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:55:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 444DD4B190;
	Fri,  8 Apr 2022 07:55:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xw7oB2FaWuwF; Fri,  8 Apr 2022 07:55:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFD824B139;
	Fri,  8 Apr 2022 07:55:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3970D4B15E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:55:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HGmwl-uxfDTp for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:55:28 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCA3749F17
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:55:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 08F8561FDF;
 Fri,  8 Apr 2022 11:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BA7C385AC;
 Fri,  8 Apr 2022 11:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649418927;
 bh=qBlSolilDWYlfAkTo1a3RNLjE+BcaB81y8n9OeQaWuQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=LLdQ+nIgmK9u9Zo0r0Bi0FRbMglxagljKmcMxRz0WYU8oxg7qdsWHEeClq5hvj0dF
 ak56LDaUX3f7RdsFRe/S1XeKKP4aY8NZYVE9hP2cKMuLNdXndvzyXn1OK1C+0PA+nn
 NNcX1OdHxQgmV3xGOCa3PlqkAT+Dk1PKTj6jVL2xWSq+F3gdf1A1GrVCiaLRKOWJzl
 I0GI/wYwnfFvHP2jGbxa72l1KQefslDv9QvE4mM1pACDAk9JTjp2BMwxmcu/1wyqNK
 5RwmuTnyK474kEd17gMdQCiFPM/nWud6m8YtXEwIgF8/AushyxJTS8rwnteZ8hVXzP
 2l07jgD/YmmbA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 03/39] kselftest/arm64: Validate setting via FPSIMD and
 read via SVE regsets
Date: Fri,  8 Apr 2022 12:42:52 +0100
Message-Id: <20220408114328.1401034-4-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5391; h=from:subject;
 bh=qBlSolilDWYlfAkTo1a3RNLjE+BcaB81y8n9OeQaWuQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/BwM63FOdiVwPlxe2c4PckHlohGWjE3cFFjGje
 /ZzTDeOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAfwQAKCRAk1otyXVSH0M0hB/
 0XYP8oBRAT7T6O/mZwOJaCyHC3jtIPNhA1iHnXfeWKe+Kqi09T01vzi6Zz9Y3H9DJKBlVb6+gAb9Zd
 TF1BKLMB4xcpN1iXk1GcGej1gXYwd/3LXOq1cizCiAGOdt8mO17uuCvs+mVh/LZYVjDSvFwPglLkdE
 2CjW966RXizAE7JeBeZl0OrRd4cTuGsU7Nc2dSeOllAMipSprbN4RpxKmecD5fb+mKlM/4cSeJjJY6
 ikDCx2sRcTMwxmOE/mNJQ0aU/rLGLTY39NP/QRWlVmOQlO+ARd9W1ajseDceKjc6zG3nyEO5MsYh+/
 D2JQOauKqBdPPamV0r0X2eIQTeec32
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
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

Currently we validate that we can set the floating point state via the SVE
regset and read the data via the FPSIMD regset but we do not valiate that
the opposite case works as expected. Add a test that covers this case,
noting that when reading via SVE regset the kernel has the option of
returning either SVE or FPSIMD data so we need to accept both formats.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/arm64/fp/sve-ptrace.c | 123 +++++++++++++++++-
 1 file changed, 122 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
index 8f6146d89ca4..c2564480b750 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -44,7 +44,7 @@ static const struct vec_type vec_types[] = {
 	},
 };
 
-#define VL_TESTS (((SVE_VQ_MAX - SVE_VQ_MIN) + 1) * 3)
+#define VL_TESTS (((SVE_VQ_MAX - SVE_VQ_MIN) + 1) * 4)
 #define FLAG_TESTS 2
 #define FPSIMD_TESTS 2
 
@@ -78,6 +78,15 @@ static int get_fpsimd(pid_t pid, struct user_fpsimd_state *fpsimd)
 	return ptrace(PTRACE_GETREGSET, pid, NT_PRFPREG, &iov);
 }
 
+static int set_fpsimd(pid_t pid, struct user_fpsimd_state *fpsimd)
+{
+	struct iovec iov;
+
+	iov.iov_base = fpsimd;
+	iov.iov_len = sizeof(*fpsimd);
+	return ptrace(PTRACE_SETREGSET, pid, NT_PRFPREG, &iov);
+}
+
 static struct user_sve_header *get_sve(pid_t pid, const struct vec_type *type,
 				       void **buf, size_t *size)
 {
@@ -473,6 +482,115 @@ static void ptrace_set_sve_get_fpsimd_data(pid_t child,
 	free(write_buf);
 }
 
+/* Validate attempting to set FPSIMD data and read it via the SVE regset */
+static void ptrace_set_fpsimd_get_sve_data(pid_t child,
+					   const struct vec_type *type,
+					   unsigned int vl)
+{
+	void *read_buf = NULL;
+	unsigned char *p;
+	struct user_sve_header *read_sve;
+	unsigned int vq = sve_vq_from_vl(vl);
+	struct user_fpsimd_state write_fpsimd;
+	int ret, i, j;
+	size_t read_sve_size = 0;
+	size_t expected_size;
+	int errors = 0;
+
+	if (__BYTE_ORDER == __BIG_ENDIAN) {
+		ksft_test_result_skip("Big endian not supported\n");
+		return;
+	}
+
+	for (i = 0; i < 32; ++i) {
+		p = (unsigned char *)&write_fpsimd.vregs[i];
+
+		for (j = 0; j < sizeof(write_fpsimd.vregs[i]); ++j)
+			p[j] = j;
+	}
+
+	ret = set_fpsimd(child, &write_fpsimd);
+	if (ret != 0) {
+		ksft_test_result_fail("Failed to set FPSIMD state: %d\n)",
+				      ret);
+		return;
+	}
+
+	if (!get_sve(child, type, (void **)&read_buf, &read_sve_size)) {
+		ksft_test_result_fail("Failed to read %s VL %u data\n",
+				      type->name, vl);
+		return;
+	}
+	read_sve = read_buf;
+
+	if (read_sve->vl != vl) {
+		ksft_test_result_fail("Child VL != expected VL %d\n",
+				      read_sve->vl, vl);
+		goto out;
+	}
+
+	/* The kernel may return either SVE or FPSIMD format */
+	switch (read_sve->flags & SVE_PT_REGS_MASK) {
+	case SVE_PT_REGS_FPSIMD:
+		expected_size = SVE_PT_FPSIMD_SIZE(vq, SVE_PT_REGS_FPSIMD);
+		if (read_sve_size < expected_size) {
+			ksft_test_result_fail("Read %d bytes, expected %d\n",
+					      read_sve_size, expected_size);
+			goto out;
+		}
+
+		ret = memcmp(&write_fpsimd, read_buf + SVE_PT_FPSIMD_OFFSET,
+			     sizeof(write_fpsimd));
+		if (ret != 0) {
+			ksft_print_msg("Read FPSIMD data mismatch\n");
+			errors++;
+		}
+		break;
+
+	case SVE_PT_REGS_SVE:
+		expected_size = SVE_PT_SVE_SIZE(vq, SVE_PT_REGS_SVE);
+		if (read_sve_size < expected_size) {
+			ksft_test_result_fail("Read %d bytes, expected %d\n",
+					      read_sve_size, expected_size);
+			goto out;
+		}
+
+		for (i = 0; i < __SVE_NUM_ZREGS; i++) {
+			__uint128_t tmp = 0;
+
+			/*
+			 * Z regs are stored endianness invariant, this won't
+			 * work for big endian
+			 */
+			memcpy(&tmp, read_buf + SVE_PT_SVE_ZREG_OFFSET(vq, i),
+			       sizeof(tmp));
+
+			if (tmp != write_fpsimd.vregs[i]) {
+				printf("# Mismatch in FPSIMD for %s VL %u Z%d/V%d\n",
+				       type->name, vl, i, i);
+				errors++;
+			}
+		}
+
+		check_u32(vl, "FPSR", &write_fpsimd.fpsr,
+			  read_buf + SVE_PT_SVE_FPSR_OFFSET(vq), &errors);
+		check_u32(vl, "FPCR", &write_fpsimd.fpcr,
+			  read_buf + SVE_PT_SVE_FPCR_OFFSET(vq), &errors);
+		break;
+	default:
+		ksft_print_msg("Unexpected regs type %d\n",
+			       read_sve->flags & SVE_PT_REGS_MASK);
+		errors++;
+		break;
+	}
+
+	ksft_test_result(errors == 0, "Set FPSIMD, read via SVE for %s VL %u\n",
+			 type->name, vl);
+
+out:
+	free(read_buf);
+}
+
 static int do_parent(pid_t child)
 {
 	int ret = EXIT_FAILURE;
@@ -578,11 +696,14 @@ static int do_parent(pid_t child)
 			if (vl_supported) {
 				ptrace_set_sve_get_sve_data(child, &vec_types[i], vl);
 				ptrace_set_sve_get_fpsimd_data(child, &vec_types[i], vl);
+				ptrace_set_fpsimd_get_sve_data(child, &vec_types[i], vl);
 			} else {
 				ksft_test_result_skip("%s set SVE get SVE for VL %d\n",
 						      vec_types[i].name, vl);
 				ksft_test_result_skip("%s set SVE get FPSIMD for VL %d\n",
 						      vec_types[i].name, vl);
+				ksft_test_result_skip("%s set FPSIMD get SVE for VL %d\n",
+						      vec_types[i].name, vl);
 			}
 		}
 	}
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
