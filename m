Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0BEC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:36:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8A7540FD6;
	Fri, 25 Feb 2022 12:36:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i7HxreeyYRVg; Fri, 25 Feb 2022 12:36:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18D3D4B9A7;
	Fri, 25 Feb 2022 12:36:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61DC040FD6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j1RlUYgB4+94 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:36:03 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34F8D4B9AB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:02 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 39F68B832E3;
 Fri, 25 Feb 2022 17:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646B0C340FE;
 Fri, 25 Feb 2022 17:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810559;
 bh=Ue/53vSkiTVkLohqxGMxCWUULOn48w5++Qe5XwKkkzw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ZhSocyVtnp/kCyMI0nrk6QjzNFpq8lBd90qZj5xjrTgibknC/YdvMpNAi1eN9czCd
 lmvIVgJziDHdu0MZ5oNsZXnJ+LB8FilTjBjrY4VKzexxfQKVxIViL5/TQBrE++n15G
 VCAmLmNp93Uir8BdxOVT7lS6bIGCEp0prOhV3YMz7oyIPSTkfkJX1+zbHBK5ioFyGr
 6ZrIk7Ce5BVbx4FlN88Ai7BEdvN25np6XBGg3EwNWu40wGWe5IGm91XZBRUINWoee1
 4easFigfLFb67v+z41WP5kWktI6qMXEjdhET2eg5mJGxsKlicY1AXZSdMuywp+Whpx
 ppbZvSCsd1lyQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 25/40] arm64/sme: Save and restore streaming mode over EFI
 runtime calls
Date: Fri, 25 Feb 2022 16:59:08 +0000
Message-Id: <20220225165923.1474372-26-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3679; h=from:subject;
 bh=Ue/53vSkiTVkLohqxGMxCWUULOn48w5++Qe5XwKkkzw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGQrd4kZB4/PfV9mTTXdMJsO4/A97byYYIgHa/uih
 ub7rHxqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkK3QAKCRAk1otyXVSH0BLbB/
 9/r1KR4sAkD2/X/J6CoXrc6Js3u7HgBsbxM/wXBVcaRfB5Mk3EUcoBpJ2SZ6BTHID+bZv982x6Zb4t
 61tUUN/n8px5kkohKLHBJXs5cfhNkozJQANdhYFjrcxXRydLlWe1Oq3plZrzWK2j1WhEVIWjCB0Jui
 DWS+JG92JuBKuC/LzRvOL09p1UgMjOcUklarnxini3kxJ2k4LCOMjFi8B+5PA7tQ7DavDYEjzSjzTd
 aCx93I4Ez+DuVlvYuX3NWkNH1REVywkhYNnRjFqB0tCIF+7rZORX+UB3OTOfxqidCj1p7Nhov2rNFh
 1JloUpiB9PvylYDhihJ57BamEztqG8
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

When saving and restoring the floating point state over an EFI runtime
call ensure that we handle streaming mode, only handling FFR if we are not
in streaming mode and ensuring that we are in normal mode over the call
into runtime services.

We currently assume that ZA will not be modified by runtime services, the
specification is not yet finalised so this may need updating if that
changes.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 47 +++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index d21d16bb03a8..77c686ded020 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1039,21 +1039,25 @@ int vec_verify_vq_map(enum vec_type type)
 
 static void __init sve_efi_setup(void)
 {
-	struct vl_info *info = &vl_info[ARM64_VEC_SVE];
+	int max_vl = 0;
+	int i;
 
 	if (!IS_ENABLED(CONFIG_EFI))
 		return;
 
+	for (i = 0; i < ARRAY_SIZE(vl_info); i++)
+		max_vl = max(vl_info[i].max_vl, max_vl);
+
 	/*
 	 * alloc_percpu() warns and prints a backtrace if this goes wrong.
 	 * This is evidence of a crippled system and we are returning void,
 	 * so no attempt is made to handle this situation here.
 	 */
-	if (!sve_vl_valid(info->max_vl))
+	if (!sve_vl_valid(max_vl))
 		goto fail;
 
 	efi_sve_state = __alloc_percpu(
-		SVE_SIG_REGS_SIZE(sve_vq_from_vl(info->max_vl)), SVE_VQ_BYTES);
+		SVE_SIG_REGS_SIZE(sve_vq_from_vl(max_vl)), SVE_VQ_BYTES);
 	if (!efi_sve_state)
 		goto fail;
 
@@ -1828,6 +1832,7 @@ EXPORT_SYMBOL(kernel_neon_end);
 static DEFINE_PER_CPU(struct user_fpsimd_state, efi_fpsimd_state);
 static DEFINE_PER_CPU(bool, efi_fpsimd_state_used);
 static DEFINE_PER_CPU(bool, efi_sve_state_used);
+static DEFINE_PER_CPU(bool, efi_sm_state);
 
 /*
  * EFI runtime services support functions
@@ -1862,12 +1867,28 @@ void __efi_fpsimd_begin(void)
 		 */
 		if (system_supports_sve() && likely(efi_sve_state)) {
 			char *sve_state = this_cpu_ptr(efi_sve_state);
+			bool ffr = true;
+			u64 svcr;
 
 			__this_cpu_write(efi_sve_state_used, true);
 
+			/* If we are in streaming mode don't touch FFR */
+			if (system_supports_sme()) {
+				svcr = read_sysreg_s(SYS_SVCR_EL0);
+
+				ffr = svcr & SYS_SVCR_EL0_SM_MASK;
+
+				__this_cpu_write(efi_sm_state, ffr);
+			}
+
 			sve_save_state(sve_state + sve_ffr_offset(sve_max_vl()),
 				       &this_cpu_ptr(&efi_fpsimd_state)->fpsr,
-				       true);
+				       ffr);
+
+			if (system_supports_sme())
+				sysreg_clear_set_s(SYS_SVCR_EL0,
+						   SYS_SVCR_EL0_SM_MASK, 0);
+
 		} else {
 			fpsimd_save_state(this_cpu_ptr(&efi_fpsimd_state));
 		}
@@ -1890,11 +1911,25 @@ void __efi_fpsimd_end(void)
 		if (system_supports_sve() &&
 		    likely(__this_cpu_read(efi_sve_state_used))) {
 			char const *sve_state = this_cpu_ptr(efi_sve_state);
+			bool ffr = true;
+
+			/*
+			 * Restore streaming mode; EFI calls are
+			 * normal function calls so should not return in
+			 * streaming mode.
+			 */
+			if (system_supports_sme()) {
+				if (__this_cpu_read(efi_sm_state)) {
+					sysreg_clear_set_s(SYS_SVCR_EL0,
+							   0,
+							   SYS_SVCR_EL0_SM_MASK);
+					ffr = false;
+				}
+			}
 
-			sve_set_vq(sve_vq_from_vl(sve_get_vl()) - 1);
 			sve_load_state(sve_state + sve_ffr_offset(sve_max_vl()),
 				       &this_cpu_ptr(&efi_fpsimd_state)->fpsr,
-				       true);
+				       ffr);
 
 			__this_cpu_write(efi_sve_state_used, false);
 		} else {
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
