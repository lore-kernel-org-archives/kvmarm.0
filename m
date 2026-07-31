Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130793EA96A;
	Fri, 31 Jul 2026 12:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501458; cv=none; b=oxcGx2oCEn0tNiT3TquBgR20187pqn9uv8VFjRJ2FDwX5h2zu5c8yguEeHBZXqwD1U0h8dTQVLB2KhMya6bJaI4Zgmi7eDcv+5vibNjf2GA7I+pCGt+tPWsrlZ/rj33ONoAkJc5M4vZYaeU8bKCIWZjaNE5aTpIPctGHaCtORFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501458; c=relaxed/simple;
	bh=DZmwxJP+W8fGWvn/wOKVMifNip3avlrIAIcelKvVs+o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GKag4m9oY3oWApyUGxjnUTQUasAvYg2xNHbGAOLiTDdntgLYtKIMRdGXwyDizIbwsI4MLN5BIYrQi36kbAchUFQuEk4e52AYxejCiPATTvkVzk+ZYOqRYEL9gbrhg3L6ARq3xzigvMrPeww2+bh/ollYnY/xJi4+IBFSfjD41Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cvBFESrR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cvBFESrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4CB1F000E9;
	Fri, 31 Jul 2026 12:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785501454;
	bh=MWKdz3JjvBdWuvOM6XAtmb0QINEsI1qn45G5e91+shs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cvBFESrR3CxGZ5Kh/nyxaisfo4jRQYOdA/20/1uEg87uBXNVkMYl/rYaUXQI5ECM0
	 B532Pf8reI7UHl84wG2LfgA7pfHtWHanPxsbIcVbEAsrEsf++gWDfmU40CahrRM3wH
	 KUws2WPo+oKWuywDcomLveF4YTKWVJQdMgL5LFRdEy/Z/fYKlayZoRThecm23rMEF6
	 NtndSMMw+bhunG1Qkj0FgX7wlpJKIANEBGWiAMJ597nxQqFmnsKczcEFSt+jX1fK+g
	 Zvlb9ZIXLvnmgFwvx6q85SsK4h4e7Fzuv0z1nINKdMm4MkCo1rthbpgGD5fYr6uHDt
	 xBbqCtghHK5Ag==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 31 Jul 2026 13:25:39 +0100
Subject: [PATCH v17 01/14] arm64/gcs: Ensure FGTs for EL1 GCS instructions
 are disabled
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-arm64-gcs-v17-1-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
In-Reply-To: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=906; i=broonie@kernel.org;
 h=from:subject:message-id; bh=DZmwxJP+W8fGWvn/wOKVMifNip3avlrIAIcelKvVs+o=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqbJb8k/ukZxuQUhgXKjtP01NML2pUPOlCvoh0f
 s999fxmh+CJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCamyW/AAKCRAk1otyXVSH
 0HuOB/9c6Gqp+d+HfjQFdWj85CzYmskkQFl4+SlKZ56UE4JBhcE6ZpJZVtY62TkhCLITGP0Bb4B
 zFex3fzrOQhrp9lYXACagYESr+Pnvc/n2RCNtRSy0Fo0o8vSvMkTLbf3iWvOI9aUYhylBJf4HE2
 ZOgSltv517kPrNH7DHTHiqIdQPSr37+6vGQiPzF8oJTjAXhY9OTuz0J5ydLBpzpczNHVLvaxGE3
 K0o51os+0ddpmO9+iLCAnTF5WgnHIjdEf6ZMqFhPrxkSJPC14I0cYd3KPH4wxBWKtcKcZrDnRR+
 r34hxZVFjl0YpzhwQE0XCk0mNMf/9c8GJdTnas5kTC0cMgj5
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The initial EL2 setup for GCS did not include disabling of EL1 usage of
GCS instructions, also disable these traps.

Fixes: ff5181d8a2a8 ("arm64/gcs: Provide basic EL2 setup to allow GCS usage at EL0 and EL1")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index aa8ec9df8024..d308c6e6757d 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -393,6 +393,11 @@
 	orr	x0, x0, #HFGRTR_EL2_nGCS_EL1_MASK
 	orr	x0, x0, #HFGRTR_EL2_nGCS_EL0_MASK
 
+	/* Disable traps of GCS instructions at EL1 */
+	orr	x2, x2, #HFGITR_EL2_nGCSEPP_MASK
+	orr	x2, x2, #HFGITR_EL2_nGCSSTR_EL1_MASK
+	orr	x2, x2, #HFGITR_EL2_nGCSPUSHM_EL1_MASK
+
 .Lskip_gce_fgt_\@:
 
 .Lset_fgt_\@:

-- 
2.47.3

