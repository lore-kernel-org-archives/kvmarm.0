Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E7553B8
	for <kvmarm@lists.linux.dev>; Mon,  6 Mar 2023 16:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE7BC433EF;
	Mon,  6 Mar 2023 16:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678119253;
	bh=zl80OGxRqJtAQ1gF5I9FrcC87gG/BtqC9Nkj4+q+wig=;
	h=From:Subject:Date:To:Cc:From;
	b=V67xf/GzS4FQ7RzWrYj7MomZomg4mmn/qvwxFcKVXIeYQCTvFOnVOtzmDQL1nAoIq
	 D3wC6dxFic8H7p4r/cg9a2ab9SKRChj4n7raGceUn00fohdDi81B1JVHcqCMHhlvyu
	 IV43ZKsqEE8LUw288MooG8Hlmy69H+vJwTA0IF7Ve1ylRAXTSxwKm4U6qUC0hs5thU
	 usKA4rz/MTiz1B67dlKkA5CD/ee1bOChWCMhusHm3Qmbomuxr+3pf53qza3JOBpC1E
	 Y+KaBCFubZWKTgaD5wAsAW8pF4Rl6s8SCLiJ3We8yI1PrJIJ2sGdlEvyqA5xt890Tm
	 sdlEcKEmXeZlg==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: Support for per-guest fine grained traps
 configuration
Date: Mon, 06 Mar 2023 16:08:50 +0000
Message-Id: <20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABMQBmQC/x2NQQqEMAwAvyI5b6CtWsGvyB6qTTVIq6QiC+Lft
 3qcgWEuyCRMGfrqAqGTM2+pgP5UMC0uzYTsC4NRpla10rieEZ1E22CYD6TWe226xgbbQWlGlwl
 HcWlanuqI+2N3ocC/9zJ87/sPGY/UMXUAAAA=
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=1608; i=broonie@kernel.org;
 h=from:subject:message-id; bh=zl80OGxRqJtAQ1gF5I9FrcC87gG/BtqC9Nkj4+q+wig=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkBhFQcM68fPi2mI7+5AEZM8Pl5mjSNjSub/Vryzbc
 Rw7UGuKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZAYRUAAKCRAk1otyXVSH0NIYB/
 9/7LphRXXBYsdg8n33kkqmbzb2N8OiTkrIsxip2/wPcywL98ABfv+ynRLNoLK63TtST2iAaxusE5Ff
 UVPHG5lcYzmHAyVCHmUma7JS8c/MR3No53DTmzHEKbQmzEOQucC/rEH50Z+nThYNICCr1XMrYIaNXY
 LteFTD0szQU9UlyCzQPCgZbRsPYXpbiQ8CdVS+uzfeC2E5NyGdpmnYVkZcW7xSzLSb7I4HvlJyDmh2
 HgjRnlV/5CDoCbWDlndA2a8XDD8C/d4MmEFV9xjlKEhNmcwpyzPmuWf2pZ8oAPDECz19aubU0ftilT
 LcQe9lbHEgBRm6uA/8Ybmd3WNhGA3d
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

A number of upcoming features will require per guest configuration of
the fine grained traps enabled in the guest.  At present the only
management we do is for SME where we don't yet have guest support so we
unconditionally enable the traps while guests are running but this will
change going forward and at present the code isn't particularly
scalable.  This series aims to make it easier to configure which traps
are enabled for the guest by making the value set for the guest into
configuration in the vCPU data which we can set up based on the chosen
features rather than requiring conditional code in the trap enable and
disable paths.

This will have no benefit until one of the features that requires
configuration of these traps is merged but since there's a number of
such features it seems useful to decide on an approach to handling traps
for them which can be shared.

---
Mark Brown (2):
      arm64: Add feature detection for fine grained traps
      KVM: arm64: Move FGT value configuration to vCPU state

 arch/arm64/include/asm/kvm_emulate.h    | 12 ++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  6 ++++++
 arch/arm64/kernel/cpufeature.c          | 11 +++++++++++
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h | 31 +++++++++++++++----------------
 arch/arm64/tools/cpucaps                |  1 +
 6 files changed, 46 insertions(+), 16 deletions(-)
---
base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
change-id: 20230301-kvm-arm64-fgt-e5dd12746f67

Best regards,
-- 
Mark Brown <broonie@kernel.org>

