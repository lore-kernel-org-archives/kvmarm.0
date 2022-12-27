Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4768624
	for <kvmarm@lists.linux.dev>; Tue, 27 Dec 2022 17:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48789C433D2;
	Tue, 27 Dec 2022 17:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672160731;
	bh=R8PGFlBhkO7fov6cg9zZpX6dJoVGqFgIiH7GqN9RukA=;
	h=From:Subject:Date:To:Cc:From;
	b=AQFBHcFXWPbhs+z8AHa+HiDRKg2H/jMgGNfmysTX+TYnk9lghscAszB8NZabD3ueZ
	 Wu2ksn8+qYyzyMvuPmKVgAgRHagF+ets6E0xL+fJeoUmoJ38D1dzReT7+VbDUp9CXW
	 ej4LbEUKzvN/asxrF5YRYLd2i+vPtDLAEgG9OMPN/wgGcmBJ7VuB8H9Mu0BX0kY2L9
	 6+OtMHqEtzROBsk50Rmu84qlR4iePK8fECNfvc8Dx5N1M3sKFmRajKEONbTKBQscRI
	 erInOT5PNsd2wq1rBLlW9GFRwEIjfh1MP9AyXHBzYupwETDP6jPLnKJakVTlvwxv5A
	 XLuVXwfg/Ly/g==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/3] arm64/sysreg: ISR register conversions
Date: Tue, 27 Dec 2022 17:05:03 +0000
Message-Id: <20221208-arm64-isr-el1-v2-0-89f7073a1ca9@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAL8lq2MC/x2NSw6DIBQAr2JY9yniJ7Sr3qPpAvGhRITmYayp8
 e5Fl5PMZHYWkSxG9sh2RrjaaINPIG4Z06PyA4LtEzPBhSgFl6BobmuwkQBdCfe6KatKiqpvOEtN
 pyJCR8rr8awuuTCBwOO2FDoQntaH0Njtur7eiQ2FGZaRUF0v2XZTMI7LNf86mNXvOSF5dHmggR3
 HH4EGvJq0AAAA
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.12-dev-7ab1d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1161; i=broonie@kernel.org;
 h=from:subject:message-id; bh=R8PGFlBhkO7fov6cg9zZpX6dJoVGqFgIiH7GqN9RukA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjqyXWrfh7uYyZ9gItKvh+T5TxWR+BYNH+A0MuYzOJ
 rikUvIuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY6sl1gAKCRAk1otyXVSH0PyXB/
 wOagA+TWYZyHmKr7VPxfJsi1xE400iHe2Ol81MBsTXFIOoUAS8voOBBKoBlxOTx9W9yV6X2fxCvnbk
 B/moEqUxBvIg3284Do7BDgLU7DQFg/tXSVFBGQWUul3aM8qr8MSovjJYtIEq6vJOQj4ka8U3Wg0cUx
 UVc/jHXt6fg5Hk3fKWi2/jz37Hw+mGVmCLUqBGPKg5irj2/CHilvNtKU2ATXuLZk3dHdHvJO+GEhJS
 Fn/+1xQHqgCVJcR4tx00Bbd98kn98rd2LUQJVNqbS0RLcmTJpxUw8mt22PaB+VH/yYYWrnbzu4W6xR
 tCWcDgFsrbL3Cb6dvO8TQdBtUcClSM
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

This series pulls the generated sysreg updates out of the previously
posted series for NMI support then adds an incremental patch on top of
that using the generated constant for ISR_EL1.A in the KVM entry code
suggested by Marc Zyngier.  This should hopefully help these progress
without getting tied up by the more involved NMI rework (and cut down
the size of that series if they do get merged).

v2:
 - Rebased onto v6.2-rc1.

To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Mark Brown <broonie@kernel.org>

---
Mark Brown (3):
      arm64/sysreg: Add definition for ICC_NMIAR1_EL1
      arm64/sysreg: Add definition of ISR_EL1
      KVM: arm64: Use symbolic definition for ISR_EL1.A

 arch/arm64/kvm/hyp/entry.S |  2 +-
 arch/arm64/tools/sysreg    | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)
---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20221208-arm64-isr-el1-945133823d50

Best regards,
-- 
Mark Brown <broonie@kernel.org>
