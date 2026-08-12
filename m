Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B307136920F;
	Wed, 12 Aug 2026 19:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786562032; cv=none; b=r98xKXjZdzEdnsiYTKMMH51zB5sHHr0hXRyKGHwO9c/Ka00qcakcKghbCCufRZQr8V3eiXUzJQ424gqc+JxA1KZD39rVilM+aSH6yj1sXg3Rvnrw1qJ6hIOOSj7F2Jy5waTBgPE1tjC5MmP/GNZMksPYl/QTQ/eVWEDC2URxIh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786562032; c=relaxed/simple;
	bh=d3SxEv6RjSY+xiyxMK7Zi+tIruIS+RbgPdYjX8k0TSU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jKG0gEdHa6DGOSF//d3X/f+tnw2ZjL5SOJG0y9ovnVawwD+Ogf5Kg1Ip7NlJWX0kM1hzp6qnVM6PsKZ+jqrirWPbTlW9Im3rOmBYpp8LEkjfq9uYPT2zh2sx8DWCUGn/NLDH4vxutw1Oss6g3fvloUh3S9cYrdAFXKBt3wvQ4gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nNGtpPOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nNGtpPOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A501F000E9;
	Wed, 12 Aug 2026 19:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786562031;
	bh=kyh12vLSEfb1JF7lQC/qy5BquW9r8pj96hLZDvx4BW8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nNGtpPOFlt80OXAyXiDfI1J1rpdzsZt/ZwrncQD14mJYbe4icC1UH9JivHZ6QH0Xt
	 VhoMRbBmDGN/Q4uWr13cOYCvMNooGteorpgtWPTi0sK1kiETgTmaBajEPUJkyFOv6x
	 8zjXrKBa0BxFUe0ioheym43jTQPqrHLcDcBLIeZDWWlgidR8Dz9/Tsv9IUBN0W2t5b
	 2GN3GMxUAUqNdRrHy4hHMR6d3CwH9PhoxmL7N4x+mHtSBzdsyUag/XCFDixtyTWzKL
	 6RJQrIfpYhLPfrkbpgwQZzyyjGOvtrFwMBRPhTQWF16dYkJXqtfH8UPqZqBWjtBUx6
	 XOwF+PMqjIF4A==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Aug 2026 20:12:10 +0100
Subject: [PATCH v19 11/14] KVM: selftests: arm64: Add GCS to set_id_regs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-arm64-gcs-v19-11-9105afd828ac@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=987; i=broonie@kernel.org;
 h=from:subject:message-id; bh=d3SxEv6RjSY+xiyxMK7Zi+tIruIS+RbgPdYjX8k0TSU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqfMXC47UOI9ar0MXkHzkBpHSHaLiKXY5jAO8Cz
 ImAYUA66syJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanzFwgAKCRAk1otyXVSH
 0GOmB/4homdto1G8lhIyqwfXdQ7RUuV7SeRnDdLsTGZzQQnVvPukoFdWwIqEY21RwVtv+39T126
 M3J+5Wa1Nl3K82bsxkxYNMKC+xloL9kkCshypwQx96WvlvZcGoouIsKUHOUdsOnhvwofBlxmV/X
 /TmSqtO1WP2FQxTCGl7twnUSWnSnS8bnhHmHjbvQ/ymNHayvk22yM4cfDgWPWmLhOSlOfRa34Ey
 XT+dCmbm50kio5yBKrAcGzHQcT0mZVQuWw5Hqb7kG9bHrvOCwoveL44yYHoEHVe4leCngsoLhkK
 8BJ7IpLrxiWACXZ9zxWFiZtvxYFh8ESux33EPe5PaCRvKUk+
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Now that GCS is configurable via the ID registers update set_id_regs to
cover ID_AA64PFR1_EL1.GCS.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 7429a1055df5..34e59fbbbe89 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -154,6 +154,7 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
 
 static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, DF2, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, GCS, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, CSV2_frac, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SSBS, ID_AA64PFR1_EL1_SSBS_NI),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, BT, 0),

-- 
2.47.3

