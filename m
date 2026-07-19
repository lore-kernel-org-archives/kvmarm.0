Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404E520125F;
	Sun, 19 Jul 2026 19:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784489264; cv=none; b=mPWzH2EvhLUA/JOfuCj+qGgmDRre1NuG1AunK1Aa9KULzrGuG+3x1iYoQCWskq/9qnlLVmJx+cjY9M2/dvyksZouY8KfMe5vBuhh5f834Mpo5gC98+zNqWhKUD6c9Yh0r7kWRgpdHiAllu8GE+POhPqUX7maChc2TQZ5aF6tXB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784489264; c=relaxed/simple;
	bh=VxQtlVb6Tq4ygQJd99j9vq7cB5fe5K6fary/e2Ocz3g=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=a+rXtI4db2izP3SdSnFneWiRWRH7/ykPusF0fyxcy8O9XvqfMy9jF4McM16hA7qGWWhYJHrfiw7MBlLOp5XZmj2Ilcsl3jikSTezO0xSRe0l1/3purVY57NgOKGeki4DdY8j4u17PaIiZadGIq54D7+NovuRFhBH0o3ccO5oo5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEGHCda8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEGHCda8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCE01F000E9;
	Sun, 19 Jul 2026 19:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784489262;
	bh=x3Z/BCAWfDXXRpooXj+PnUZCnjnIe39m8lpD8Kpu1SI=;
	h=From:Subject:Date:To:Cc;
	b=CEGHCda8YSBOybWJeDHZhCahc3ZneW2555nYacPa9bj4BLYuFWxMrIK2VuXykgI2q
	 7WPQFWXG0qOxV9rHRG2hFsvnn6sQPZJ9833KP7J+crnv4UTCO0XonmJVUT5H9K269k
	 DziC+eDNw/FE9tyZWQ2dpjr/+s55clwRROvbwH/e4Hyud3nZjRddikOvrfB32ToGb8
	 uTldNYCEnqXDEa5fpnI03+9k/OxTxLdZFWzCRlT24Zgne0pxTJSCJYpfx7rBqi+dO/
	 ASK45l8NktTIMY8EdNOvfA2bWZwQapp56PQ9ElJm1+XJ/tW4v/1e4now7VO7QpUwke
	 PD8CPLVzDzsbQ==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v6 0/3] KVM: selftests: arm64: Improve diagnostics from
 set_id_regs
Date: Sun, 19 Jul 2026 20:24:39 +0100
Message-Id: <20260719-kvm-arm64-set-id-regs-aarch64-v6-0-724287f5f108@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHckXWoC/4XNTWrDMBCG4asErauiGf1ZXfUeJQvJGdkijV2kY
 FKC714ltJjihZbvN/DMnRXKiQp7O9xZpiWVNE81zMuB9aOfBuLpVJuhQA0CO35eLtzni1G80LU
 eeaahcO9zP9aNQrDWGacE9KwaX5liuj39j2PtMZXrnL+f7xZ4rL+yFA15AS64M5HECQPYjt7Pl
 Cf6fJ3zwB70ghsHoFocVs5YjAgqKghxx8mNQ3AtTlYuRK+sol4idDtO/XFGgDAtTlWutxSV1uB
 jkDtOb5wE2+J05bwREYPThhD/ceu6/gCZnbRUBwIAAA==
X-Change-ID: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2260; i=broonie@kernel.org;
 h=from:subject:message-id; bh=VxQtlVb6Tq4ygQJd99j9vq7cB5fe5K6fary/e2Ocz3g=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXSUp3QR8U5oPJqHthXK2AJQyw4qD207VJphdi
 2y4lFZjbw6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal0lKQAKCRAk1otyXVSH
 0JexCACCzxKRi/czCI3ufKz9ePmZcjzOaffJelu3Pl2IKACdmRPXtNsMz7R1IWz+XeevbZYsdLV
 bCHnH8HT61UZnuk4FZte7sJjLgSi88WTvbH3bBjsJ4niepHZYCUQe9VmAzWowEpvUe+XxEDpmEP
 Qw3xLxI0dq5aRN6aGKEeswn/dfMgsL0VPUIiYYVYa1+N6dqTM2pssTqhD5K/VbS+vQA79+WzmuQ
 5/AGq5kCEFTzROz/WTgzEgSxjoQNrYq0CrWitoQzEWqeZseNZvrDRk7qyNcIT6ebjaCZcFVDUoe
 yNdqxLK/pDiUlHxAP3t534Y4aVQOxHy/RmdWOkuRzdzC3Buq
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

While debugging issues related to aarch64 only systems I ran into
speedbumps due to the lack of detail in the results reported when the
guest register read and reset value preservation tests were run, they
generated an immediately fatal assert without indicating which register
was being tested. Update these tests to non-fatally report a standard
kselftest result per register, making it much easier to see what the
problem being reported is.

A similar issue exists with the validation of the individual bitfields
in registers due to the use of immediately fatal asserts. Update those
asserts to be standard kselftest reports.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v6:
- Rebase onto v7.2-rc3.
- Drop changes to handling of aarch32 related registers on 64 bit only
  systems, an in kernel solution is preferred for those.
- Use a define to count the non-test_regs registers.
- Link to v5: https://patch.msgid.link/20260317-kvm-arm64-set-id-regs-aarch64-v5-0-a60f2b956e22@kernel.org

Changes in v5:
- Rebase onto v7.0-rc1.
- Link to v4: https://patch.msgid.link/20260106-kvm-arm64-set-id-regs-aarch64-v4-0-c7ef4551afb3@kernel.org

Changes in v4:
- Correct check for 32 bit ID registers.
- Link to v3: https://patch.msgid.link/20251219-kvm-arm64-set-id-regs-aarch64-v3-0-bfa474ec3218@kernel.org

Changes in v3:
- Rebase onto v6.19-rc1.
- Link to v2: https://patch.msgid.link/20251114-kvm-arm64-set-id-regs-aarch64-v2-0-672f214f41bf@kernel.org

Changes in v2:
- Add a fix for spurious failures with 64 bit only guests.
- Link to v1: https://patch.msgid.link/20251030-kvm-arm64-set-id-regs-aarch64-v1-0-96fe0d2b178e@kernel.org

---
Mark Brown (3):
      KVM: selftests: arm64: Report set_id_reg reads of test registers as tests
      KVM: selftests: arm64: Report register reset tests individually
      KVM: selftests: arm64: Make set_id_regs bitfield validatity checks non-fatal

 tools/testing/selftests/kvm/arm64/set_id_regs.c | 121 ++++++++++++++++++------
 1 file changed, 91 insertions(+), 30 deletions(-)
---
base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
change-id: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c

Best regards,
--  
Mark Brown <broonie@kernel.org>

