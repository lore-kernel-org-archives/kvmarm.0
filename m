Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A94C36728B;
	Wed, 12 Aug 2026 19:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786561999; cv=none; b=dPRhaMYE/73+GQNXWEqP17rAEYyoyNuDkvix+iEtHL01qPP0VQAKeXaJh+25twywQFnPkQthT8eKdTm6nD6E83R57fs97rR5+LlHeLMm/4NAIBD1dUFDDiWSOxxe5NT6gEMgF3waRtYShPMuJNtPrCexDXUQbx5Z1OxR+E/1fAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786561999; c=relaxed/simple;
	bh=DZmwxJP+W8fGWvn/wOKVMifNip3avlrIAIcelKvVs+o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kXccwU7ewIIobPe0o+EsWz5vZ0rSb1VVfP6/XMyNNXIexj7y0mtAAiwWvJUiBBJfR8ICTXV5CNJP5uhwey59Bpbpoy3IbDWsFKNjV7fNLTklvWutad3RtKRWj8vF3g4Jgppw4Ylq7Ne8KvO5ktAQF6HgUl+Nu4M+vA1nh00Rm/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ch10FdKC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ch10FdKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459D51F00A3A;
	Wed, 12 Aug 2026 19:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786561998;
	bh=MWKdz3JjvBdWuvOM6XAtmb0QINEsI1qn45G5e91+shs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ch10FdKCYrPAge4YrDIKurVwiVkcvI3avuxDVD/hpNb9oGd2q0ZKs/9Y8EYdE2Hh6
	 gHN2OIvPlLdUp+87f/j187KDkiHw3290k2QmmiWTFqQ4K2165XVwWeQU2Rp0fabGmZ
	 6qXO3/nhIKt3c38zW6eoVcIGZMFGsbtuTPrWcw9rvAkoS6nn0WkyC1BO0vVjE0o5P9
	 1MBHvmsLmPc6urMKU1Ey4n4gA1oHxHuWWrLDtqVStUfPNzH0f/iTVv7OWM5iX4aBno
	 ecqKsv0qp6yXjsWGrBBN/F9vn/bRhp3OODdZ0djeaoxZZZDYOFi8L+G5z6/iqfcbvX
	 MXHxW3iMj/bug==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Aug 2026 20:12:00 +0100
Subject: [PATCH v19 01/14] arm64/gcs: Ensure FGTs for EL1 GCS instructions
 are disabled
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-arm64-gcs-v19-1-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=906; i=broonie@kernel.org;
 h=from:subject:message-id; bh=DZmwxJP+W8fGWvn/wOKVMifNip3avlrIAIcelKvVs+o=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqfMW6RedFIHw3NdjVXn4+RQSWMjajzdkv9Vt/S
 +f/MmP6zhiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanzFugAKCRAk1otyXVSH
 0KhHB/9wfTWobWZqN3e8DvFY3Owj3Ai5t96DelDcqPkBKnT2iBecIiC+nl9PbHRyf4PDmbdjw5a
 hIZXrAb9UtOIQ4/MuZMK85oaTmuu+y0ptI0Ge0Mr75s6dNdTbD5LQk1PzRvnHPSGVfgMNMSPhyV
 rFXPEfEUuXF+K149gtkN4Nrt9R0okPxOUHjpLULia57/n9HWhJwbkeZgprtG8RZZkmRQH1vvErO
 4V+gRJzt7pUKzilNuA1CSV4M5FE4BQXAgunpUtobxh3g/jX9R6Dsm3HugxjDdl9zIeDoZVxlW+B
 kRQEmKCAJC7EmC7pK5vg6XhzxAsLtkghqzzzdSKQtJVHXbhB
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

