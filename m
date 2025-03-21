Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B752A3C00;
	Fri, 21 Mar 2025 00:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742516008; cv=none; b=MAZ/f2aOiDQCUXjmlA0rYAXIroAv0B04vmmSAf3nYemq4Jn8JHdDuMqNLdUA7u4onJfjXbRcvLMUllqze3XAyV6FhbNOEpxYsOco7/IsuVEEJyoJp0IBgeT1i7rb6YIUBkf3Y6sRi31qS4kF7W/bl4qk9DGF6TpJiN0AFhNWAM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742516008; c=relaxed/simple;
	bh=tV+sdgaMPX/7lx0ROFcg5NICAmN7mHFJvSb6OJJsjZ0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=r50R07/rik0qbCYVq2XSMzcZf+JubObhtWOs9zhLbXobvxZuGj29BbGnoG9ft+JMdA/Dx/6asDQwEkw6/fLqI5ymBw37bTRrjJrZJJM/yNVkOLMseLyjSaFEmMbifVE5OrxVXYgGkVVSdpw1SCNNOcVjBpL3GaufRX2ryY8+e9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jdxfXPyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jdxfXPyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74927C4CEDD;
	Fri, 21 Mar 2025 00:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742516008;
	bh=tV+sdgaMPX/7lx0ROFcg5NICAmN7mHFJvSb6OJJsjZ0=;
	h=From:Subject:Date:To:Cc:From;
	b=jdxfXPyvvOxxbkIOaymgsBQRtMQTSDOajjU6tQGqOjGq4VZARAPN6A3e1aNR3CIXX
	 AZ7U+QOgL3mdXohm/Wz1ogRC82JYgrul4bTCyqyMRgXAji83ywiNBc4IXTPjFZJxQE
	 p4Kar6PgECP9c4iNAhy+fld6pFgaZWaGzywDzx0MoLDiS65rHm2aWIw6GKLbdXVGts
	 6kZqQBGgS2BkNyehC3UoO+UrjeRPTCdai+ckkbdDYAM72CYE+k0I7QxFvNZGGEfhne
	 QOL2+q2NIlV/iOsAF1sgog0u1yCekbuQmj3NT1UsDMRL+Bh9ZRyj4PIDUi4sPm70zz
	 jWaz/8ri09bNA==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 v2 0/8] KVM: arm64: Backport of SVE fixes to v6.12
Date: Fri, 21 Mar 2025 00:12:56 +0000
Message-Id: <20250321-stable-sve-6-12-v2-0-417ca2278d18@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAmv3GcC/2WNwQ6CMBBEf4Xs2SXtqgU8+R+GQ6ELNJLWtKTRE
 P7d2qtzm5nMmx0iB8sRbtUOgZON1rts6FTBuGg3M1qTPZCgqyBqMG56WBljYlQoCZufWm2onQb
 Iq1fgyb4L8QGqlgR9ThcbNx8+5SbJ0hXiWV7+iEmiQGNGqZToTDfo+5OD47X2YYb+OI4vpI1cD
 rUAAAA=
X-Change-ID: 20250227-stable-sve-6-12-777778ad28fb
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, Fuad Tabba <tabba@google.com>, 
 James Clark <james.clark@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
 Eric Auger <eauger@redhat.com>, Wilco Dijkstra <wilco.dijkstra@arm.com>, 
 Eric Auger <eric.auger@redhat.com>, Florian Weimer <fweimer@redhat.com>, 
 Jeremy Linton <jeremy.linton@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=1644; i=broonie@kernel.org;
 h=from:subject:message-id; bh=tV+sdgaMPX/7lx0ROFcg5NICAmN7mHFJvSb6OJJsjZ0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn3K8dNJpuqv6o7OlG+rGjw48VRLHiH4pGIBHiff8x
 g7F0MR6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ9yvHQAKCRAk1otyXVSH0Do6B/
 9/ladtKyBL+QpUwxq7R7nD6UUeObzvo8/FuI5ws9qzwNTQ3GjauCDmEk6Y61hapowpZASk2WH1a1SS
 y5GwIwFtC/P1BRXhcXuC0TxHZ5gL1ovR4XVxW4WwWDiISmbRwJiaz4viYt35jg4Iej4iZLRL8+lYSr
 X4liIqOgSFFU4sisFldZgcgXaTQ4vuNUeX+GckuFi/0JXDSj/FJnp+MPNkz2GveF7PYznOSl+64H2F
 SK2cLZtCT0G6i0j3GqIBf8MGLsJx7zvS+axKGGT4hbxj1holDjfXCfPL6JaA030VG+/RtLlY7teUu3
 vj4HHRhygVduk8rxPqkaben2FigS9Q
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

This series backports some recent fixes for SVE/KVM interactions from
Mark Rutland to v6.12.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v2:
- Remove an erronious kern_hyp_va().
- Link to v1: https://lore.kernel.org/r/20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org

---
Fuad Tabba (1):
      KVM: arm64: Calculate cptr_el2 traps on activating traps

Mark Rutland (7):
      KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state
      KVM: arm64: Remove host FPSIMD saving for non-protected KVM
      KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN
      KVM: arm64: Remove VHE host restore of CPACR_EL1.SMEN
      KVM: arm64: Refactor exit handlers
      KVM: arm64: Mark some header functions as inline
      KVM: arm64: Eagerly switch ZCR_EL{1,2}

 arch/arm64/include/asm/kvm_host.h       |  25 ++----
 arch/arm64/kernel/fpsimd.c              |  25 ------
 arch/arm64/kvm/arm.c                    |   9 ---
 arch/arm64/kvm/fpsimd.c                 | 100 ++----------------------
 arch/arm64/kvm/hyp/entry.S              |   5 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 133 ++++++++++++++++++++++---------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  11 +--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  29 -------
 arch/arm64/kvm/hyp/nvhe/switch.c        | 134 ++++++++++++++++++--------------
 arch/arm64/kvm/hyp/vhe/switch.c         |  21 ++---
 10 files changed, 201 insertions(+), 291 deletions(-)
---
base-commit: e9cc806c0152fa9993f817cebf42989a3e2530bb
change-id: 20250227-stable-sve-6-12-777778ad28fb

Best regards,
-- 
Mark Brown <broonie@kernel.org>

