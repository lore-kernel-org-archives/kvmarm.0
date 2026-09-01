Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2309148C41F;
	Tue,  1 Sep 2026 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788288630; cv=none; b=aQ4cuuUS7ezkSv14AL2qIbbm1ke6+bdHtvHSIS2Hyqt1+2ESrEFHs8k7qZrz9euROnrgfrQTjan6XVQ+u6TgOnNd+MJhWynXcw2pUrGtRyMLTRY7H9KOXAnlMQrvLpsPqyJSwAPh8ThRgaGyKT7NwLEvqUQBJz4nGMWsLd8XMfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788288630; c=relaxed/simple;
	bh=4OkU9WgvaTBr4fJA+BqdrjhjALCzfWtqREvgXEsfess=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=I2TJyQXn/oOpYG1eK1AWPp+Z3+XKPKZFbS3X2iUKDhgYlW3qluh7d0rMQwi2EByklMw3enCmYV0WnOGY63t/kVIP3zkegx5QSyemPtT1W1iRHgwf7BAXRGtzRml7fKFUeZE4m8pj7z5olAEQuzDuyTF1KyilKqLCgZ2fOu/w708=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZx6z3KB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZx6z3KB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697711F000E9;
	Tue,  1 Sep 2026 18:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788288628;
	bh=+EdOCYHdoxuRmz6Krna/WF/yq1BxGZQXedylPxEwU/M=;
	h=From:Subject:Date:To:Cc;
	b=MZx6z3KBd0SIH9k4Qs2ZSYsraNF6DTxsHzcDUZkyk1oiwDe9dx3P9ss0DN7CCeSTd
	 jwS/KxMPkdLYojMKGy9WjO0vECDYeOndYSGTulci4Ms4QJ04K3Y4Hrame6EjIXARRR
	 I92DzTshe/GDGqF6swsD7/9/FFiyPEn21zo8i8Sjd/eymQfxk3vyVk77ZPnMzBNnPN
	 NI2wWJ2B2LrA7AKE0SQg6tGVb51S/PI+zOAK4fZwiYvn2TyuOQH46rT1PkfOY4EO5n
	 nVSrhtLVjSRXJpMsjqufn7QSKkIoRiv9JAFnxGu2ndO3CKkQ8ZP4uDBVsFgZRNnVOk
	 aE1I4UxI5Vlfg==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v7 0/3] KVM: selftests: arm64: Improve diagnostics from
 set_id_regs
Date: Tue, 01 Sep 2026 19:50:00 +0100
Message-Id: <20260901-kvm-arm64-set-id-regs-aarch64-v7-0-7b065b0bda9a@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFgel2oC/4XPTWrDMBAF4KsErauiGf3ZXfUepQvJmXFEGrtIw
 bQE371KaDHFCy3fG/iGdxOFcqIiXg43kWlJJc1TDf7pIIZTmEaS6VizQIUWFHbyvFxkyBdnZKF
 rPcpMY5Eh5OFUO4rR+971RsEgqvGZidPXw397r/mUynXO3493C9zbX1mrhryAVLJ3TOqIEXxHr
 2fKE308z3kUd3rBjQMwLQ4r5zwygmEDkXec3jiEvsXpykUOxhsaNEK348wf5xQo1+JM5QZPbKy
 FwFHvOLtxGnyLs5ULTjHG3jpC3HFu43x7rKucR4OdZ8ug/o9d1/UHB7ANllYCAAA=
X-Change-ID: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2411; i=broonie@kernel.org;
 h=from:subject:message-id; bh=4OkU9WgvaTBr4fJA+BqdrjhjALCzfWtqREvgXEsfess=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhqzpcrmHRNqMLwefaRC9ed7e1FZmbfI5y+i8fb2Vr/0nV
 D5fWL+wk9GYhYGRi0FWTJFl7bOMVenhElvnP5r/CmYQKxPIFAYuTgGYSP939j+cTl4dZ+ZKFOcl
 NX7RYY7tSXmfNuVYlJ/BOzNNMX7GpBspd4UXd+o3Xek4I6UWdCxuifXZCXaTdJjeLG8QVFtwdVO
 DssbrXQb3aw0VNy55klraM9ErYePcY+/e/NzGo3HWYMbxH68NkoI4+rxnPnacybjl20G2Ki7+BN
 +I47xVvKrZn7/Fl9drVHxz4JQIcO9fpnf6kJ75W8FKSX379LabmlVbTE6w1m4X26f3qfr51FsXg
 3hktr1KulYdfHyJthJ/4SLVMKb+UydPJjbXFb/f0BEacXFn8kG5gJ0rzycdOyJ3JPW/btNzPUF2
 LqWc5DO3G3c2+GWH3Il09Wnoq0g/XG1wxqr7+Dm/h1rlAA==
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
Changes in v7:
- Rebase onto v7.3-rc1.
- Link to v6: https://patch.msgid.link/20260719-kvm-arm64-set-id-regs-aarch64-v6-0-724287f5f108@kernel.org

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
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c

Best regards,
--  
Mark Brown <broonie@kernel.org>

