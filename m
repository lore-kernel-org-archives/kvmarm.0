Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793730051;
	b=olmEiqIhFY0eS6nEaPDACnwnrexdWHM1fsLUFVT+wglAIZ+UfwaECAJzndUY5KzByGDX
	 OhkKfd00mff2x4MSP3dexAViyEc9++6Ns1jZbaqQ0gcfj2Xi6gviT0uw7zX+ggathzigo
	 H/x8DPEWQHBlVcSW5mCfwOgqRd+QJKe2qqdNibSIG2TFb7VhMRChDR97T7u5CaMNbt/ZB
	 hovW7lJlZJ2co4OQgVgC86NKMQ3rHanq8HKTpDevP2jlctlzI9Ntm7I9hyAJRSYhB22th
	 1JyUZOucbyX7ouVG6Fn04zsGRln3iCc2BzsYDClooyuJZpDf+OK8ZXFzmDDfzVv3+Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793730051;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=FPwk+Obv3JX7khvwqPN/UuLuPSKvZ6g9lKWJcYLlWQk=;
	b=bSb7T+ExCb8g+WraSfr9M2GVa2W03OhZ4cNtqtRRtb9CQA98QDzXOgzxo2tG4YT80FTW
	 ks2Rs0KDSl1gv/hHoW1mvL8QrQXA2gsa8c0ZRVfRV3na0reTwgT6XNRGwgvgmc9SnMgQL
	 VJz0D3tVZGN7c+6t3sUDsTXBLTUxhUi8lJhypUL7FJvH3zwZvm40nRiCk+egPxNWLwGPM
	 YCbjqdQAT3dK9aFhE2HAiRzJW+ahl79fvwHLlPgFN/2vzN2/imTi3v6cIfTST5iVjPXco
	 BbkFHBLJ6e74xAt7PHrRgnc6DWeEWMSKrxd14muUrbY9XKE2l2KJP4YaPM/vMJV0+cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H5g8y4HA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B72C606A326;
	Tue,  3 Nov 2026 18:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H5g8y4HA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EF71F000C1;
	Tue,  3 Nov 2026 18:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730050;
	bh=FPwk+Obv3JX7khvwqPN/UuLuPSKvZ6g9lKWJcYLlWQk=;
	h=From:Subject:Date:To:Cc;
	b=H5g8y4HAdMcsyMgO7MOqQ7BuM7LXnzIK+xJ3SWXbf7IAmivibRHPYgmSiUZ243K3o
	 xuWunLgtOHqbrBnOvLZbfi128Hd2EqEGcsBWaZKMUaop6dKuKjVS2YZmtRELp7IXYl
	 h1DGNIlHCuXUtyihEW3rpzB7JWXvLE8xMbchZD2EiWSPEZZcceQ5rXTV/7IkNSvNmF
	 od7d8WVYID0QNkeqoC0ubXbh6Ide9beDyteguOycx9bUBjjIcANmN65D9INpW/sTft
	 eX9PPc26rBBh/MPvac7EftUKHdd/s6M7sPg5bQg6N7ikd14uDW+Ie3Yis9JU2NE26u
	 Eno1+FFFIK8kA==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v9 0/3] KVM: selftests: arm64: Improve diagnostics from
 set_id_regs
Date: Tue, 03 Nov 2026 18:19:20 +0000
Message-Id: <20261103-kvm-arm64-set-id-regs-aarch64-v9-0-ab32bc79fa9c@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKkl6moC/4XPz07DMAwG8FeZcibIdvN3J94DcUhSZ6vGOpROF
 Wjau5NOoIJ6yPH7LP1s38TEZeBJ7Hc3UXgepuEy1uCfdiIdw3hgOfQ1CwLSCOTkaT7LUM5GyYm
 vdSgLHyYZQknH2nGM1nrjFWAS1fgonIfPh//6VvNxmK6X8vVYN+PS/sgdNOQZJUhvMkNPEa3jl
 xOXkd+fL+UgFnqmlUNULY4qZyxlQpUVxrzhupUj9C2uq1zMQVnFqSN0G079cgYQTItTlUuWs9I
 aQ47dhtMr16FtcbpywUCm6LVhog1nVs62nzWVs6TI2awzwvZZu3IesMXZhYtgdITYBx82nPvDU
 fM6VzntQohMiXJI/7j7/f4Nq5c/dvQCAAA=
X-Change-ID: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2800; i=broonie@kernel.org;
 h=from:subject:message-id; bh=4ky2ZC0HdjDT4ejqM8lZ1oDOfp+5HqQ3XaDMShmtQSc=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLJeqf5b/ddyypdmNuNDU6bLP3ELdL7t9ux9kmWocKLp+
 r2sX3Yd6ShlYRDjYpAVU2SJy+J+WV/yeg3fwYVtMHNYmUCGMHBxCsBEGB4x/M+65vjVp6jt04RJ
 c97bTN424Ye/xP+gp2nCaaq/NPWTfscw/E+s+lVn97I7KWzdNcdVxz/aaMp/fZ64xPZX/w6Hc93
 ijMwA
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
Changes in v9:
- Rebase onto v7.4-rc1.
- Link to v8: https://patch.msgid.link/20260929-kvm-arm64-set-id-regs-aarch64-v8-0-58aabe2c2fac@kernel.org

Changes in v8:
- Convert another assert.
- Link to v7: https://patch.msgid.link/20260901-kvm-arm64-set-id-regs-aarch64-v7-0-7b065b0bda9a@kernel.org

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
      KVM: selftests: arm64: Make set_id_regs bitfield validity checks non-fatal

 tools/testing/selftests/kvm/arm64/set_id_regs.c | 130 ++++++++++++++++++------
 1 file changed, 98 insertions(+), 32 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
change-id: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c

Best regards,
--  
Mark Brown <broonie@kernel.org>

