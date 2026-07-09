Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAFF3BB9E3;
	Thu,  9 Jul 2026 00:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558472; cv=none; b=e7Q5Si6Te0DSWopAiD4exWaINypoQnJsU8Zt+CPzHEv+41YGOPZbv/J7wCefGbKUyQXABWd+EFr5DiwFJ5M5BVlOGcucfETgfA0NUwGbMv209qL23xGAcqTL3cqWykLpKpdZbUTrE7UjACZ5cOBlF8LsIooSdKMmQTgXFoOqGWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558472; c=relaxed/simple;
	bh=3zzAFIxW4QntGIfc+v0S58ciMfKRPipxII9rhMorBnU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WG/4at/6o6K48PITTyiUslfqtcZEnvECIoM6VMBbnOxhd79t3tygQ8T8el+0SiYb+EQe+JyejYnWssb3Odvf6gABvH0aH72ouorTPsD7GssGgLemFi/2x66ehfYtFUcwKRmZcsZfK493NopW7k0jpK6MpnEFoScsGg687cZbF78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JHhSdyHr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JHhSdyHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82C01F00A3A;
	Thu,  9 Jul 2026 00:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558470;
	bh=V9/QBsgUl+YAHSU3KRVgzfp7o3z60FnCLy+stiPlLsM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JHhSdyHrMv3HYWgzywYRpT7QlQXiZc7MOOUajFWvyWfSn//S91ntd/aiQVpkXl3gZ
	 dXAV8b3b3t1MLfq7g1PBQCviLnyMLUGQFpbFOyvxkS9YdvqosFRCrHJE+kEV8pI/iV
	 n3veUxbASo5fqzBuLX531xhxkVLd+tPlpSZxzJ0yUVOHakdc4LbPq57dktbzl48jEz
	 h/cANciH0eBoW0OFO0p3XGuHFDlChbxyKGUjc3fdKQao2P3000I0rzL4KMPOjelgxL
	 XxwNbVGh7nzpI7n0JTkISh/VA6rL2HHbGvWJxdlpPX5IVBDz7verl131f1nGVBCPA2
	 UOzHL0f+IX4iA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:52:03 +0100
Subject: [PATCH v11 26/29] KVM: arm64: selftests: Remove spurious check for
 single bit safe values
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-26-32799f66db9d@kernel.org>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1200; i=broonie@kernel.org;
 h=from:subject:message-id; bh=3zzAFIxW4QntGIfc+v0S58ciMfKRPipxII9rhMorBnU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvDOgySLljelyliKuU68aJ+WXhNqdDXOfQ0X4
 bcC9XPp6huJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wzgAKCRAk1otyXVSH
 0GWSCACGxmWrQ//D7mkxehILTyoZqXgMWn4QUvdAzZvcEQUfnApZz2Fx+P0B/pacM1M/ANcFOXb
 4rIK3YeCiQ9T+e4aP0ed5eIIWgGii4tUqB8W3WbaRBVDy5acbaPcC86EQprEW3SqPH1zASj9g4e
 W14/9v9xDstwShBLuGS2ko3BPgV6zVXWglpZgs4w1vSd27xd+N9/FHq2tbSdGkkO4fMEEDEbkhm
 Lqjb579vseeZ19GR2ZlmeGwh3mbE4rukGBN3bBzVhlXJY5r2TEJqfHiV8Xch4G2LhRMg6OeNqZ1
 0nhUdWvXMFnrtZS5hisxWpteAQJxNdcxe7fcjzWIo2Ryaudi
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

get_safe_value() currently asserts that bitfields it is generating a safe
value for must be more than one bit wide but in actual fact it should
always be possible to generate a safe value to write to a bitfield even if
it is just the current value and the function correctly handles that.
Remove the assert.

Fixes: bf09ee918053e ("KVM: arm64: selftests: Remove ARM64_FEATURE_FIELD_BITS and its last user")
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 7429a1055df5..9eceac84e297 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -279,8 +279,6 @@ u64 get_safe_value(const struct reg_ftr_bits *ftr_bits, u64 ftr)
 {
 	u64 ftr_max = ftr_bits->mask >> ftr_bits->shift;
 
-	TEST_ASSERT(ftr_max > 1, "This test doesn't support single bit features");
-
 	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:

-- 
2.47.3

