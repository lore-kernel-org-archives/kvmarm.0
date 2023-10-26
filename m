Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0411528E31;
	Thu, 26 Oct 2023 12:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCbUeVMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAB4C433C7;
	Thu, 26 Oct 2023 12:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698324461;
	bh=uwufjRPZpufB4WAKz4BvxO1YI+sO9dPrjMMi385iZbk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BCbUeVMSLhmUhFPwkQmPbkSxvD6sZ+0tGomwpFVcTUkvM4DiC6sKCLfmhdX6jP4E/
	 rE+1Y45LmR+Upf/C2sptY3bG3skk/ISDZ7gu5NJHRHRf7g2xra3piivHUYFVbhfbjU
	 2v4HDpnpKnSG8SrZRsWPJ8EP7FHASxpCUPHiew+XeqMxCffvaaZqKyvtGq0JEBDFgU
	 +GrRN3mvDRafwD55DvgQhXgKFTGn02jmUarpYR61HBJJsU3ConX42XWkcLGdZs6HlS
	 5dG3y9diDUDK7potFmEHtJ3f130cKxlGbroXBoxT1mvljL9PhmSAuid6zN4gzgUZkG
	 9RNyLCXH2YyKw==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 26 Oct 2023 13:44:35 +0100
Subject: [PATCH 21/21] KVM: arm64: selftests: Teach get-reg-list about FPMR
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231026-arm64-2023-dpisa-v1-21-8470dd989bb2@kernel.org>
References: <20231026-arm64-2023-dpisa-v1-0-8470dd989bb2@kernel.org>
In-Reply-To: <20231026-arm64-2023-dpisa-v1-0-8470dd989bb2@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-0438c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1321; i=broonie@kernel.org;
 h=from:subject:message-id; bh=uwufjRPZpufB4WAKz4BvxO1YI+sO9dPrjMMi385iZbk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBlOl+kwgjY6EVwPCWQAVwgyV3h0FLsAbgfLrWaEGga
 OKJk0qKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZTpfpAAKCRAk1otyXVSH0D2fB/
 494ePdNnodIbyo2n2nTy3SIDha1NJ+Yk/N/0U2hqFK8LTDjl9leOHfSnS0lYLPhmLkc3P66i2gSxIp
 DJwCrOWCjxu4pBWqxCZqSHKbUA6bqMTe/2KdxAOOC0k7o6aqIHQnNNpFfi6K7hDd7Ln6Z+6mvvXaTD
 rgCk1adl3U3KkYLqfLHrypTVRQOOvg8vGWgklqQCDar8031EFJ+bhM6fw1DSLYurB/TMlNj+Xb1o/0
 bODwv093DYlcKRSTC43nHEDHKbHp3aSPs0C/7TRWgUmeOuYoNKwYEFp8vf1GE5w0Uw49sO9pDRVupE
 7wZB3IlsnyvCjrAr5HMl1su5FB66kq
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

FEAT_FPMR defines a new register FMPR which is available at all ELs and is
discovered via ID_AA64PFR2_EL1.FPMR, add this to the set of registers that
get-reg-list knows to check for with the required identification register
depdendency.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 71ea6ecec7ce..1e43511d1440 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -40,6 +40,12 @@ static struct feature_id_reg feat_id_regs[] = {
 		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
 		4,
 		1
+	},
+	{
+		ARM64_SYS_REG(3, 3, 4, 4, 2),	/* FPMR */
+		ARM64_SYS_REG(3, 0, 0, 4, 2),	/* ID_AA64PFR2_EL1 */
+		32,
+		1
 	}
 };
 
@@ -481,6 +487,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 3, 14, 2, 1),	/* CNTP_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 2, 2),	/* CNTP_CVAL_EL0 */
 	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
+	ARM64_SYS_REG(3, 3, 4, 4, 2),	/* FPMR */
 	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
 	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
 };

-- 
2.30.2

