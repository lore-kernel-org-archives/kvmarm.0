Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A65B1F0E4B;
	Wed, 12 Mar 2025 23:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741823368; cv=none; b=GZ5n5ggjK3/Ki3gInxXHKwH651O/4nDYi+0QvCp28K/uh4O1gux7V6trS8IrGUyB9FBAU4CiVDMd2n2v9xYnzjfKWa7u7VfKS6EvDOQ/Yg8tvsL8adoSTNfw2QWt0QEqvooxVPaoGMX0RWgNCLCEOJQ5NeGxTEmxpWJKfIrRgqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741823368; c=relaxed/simple;
	bh=HbHXJf6SGTZ5u093xJt01x3/Z7InN/X2lZLhzmLppWk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Ww8BoGrXRfNfO1FtaLPsGL4cZ41jXJdHdTMtAfp9Pj6qRkNcdkVZSyuvSIXYkJhkSC7dXCPXHMobmoyaJlF2onph0AFRETyA1K5947QUKBIdYVE8mSzY84F0T7ukrpXf6xlfiqYGnlo+qzD5yVMjyGR/6rbA17TmiNdsylE0/uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wrpcc18m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wrpcc18m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB96C4CEE3;
	Wed, 12 Mar 2025 23:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741823367;
	bh=HbHXJf6SGTZ5u093xJt01x3/Z7InN/X2lZLhzmLppWk=;
	h=From:Subject:Date:To:Cc:From;
	b=Wrpcc18mInGhIMAvU301Kt0+WOZCKCK4muRr95lCvUVzgAMSvkeBVVGzw3B4WHJQK
	 Vr5s5bxY03lor/5TSfQeONaZgM+S5kzGKeAGurPkMw4cPhC4L/xcqiBeq5babGJUf8
	 fTH1bYfhM24w6CSTD8XQqawA4uK6h5fjLYR/pCRyi3nYitzD9ztVOAGg1R9FpSNQFp
	 zuVuYLEDtD6MO9AqAbyfcBUeHsZaCW1P8ZZgsxEcd3wolOtj1fwle4PUuT+Tz+mmBz
	 toi4KNmho1+TI6/X5tV4O0URSciZ8i4jGH6J3i0thTegr9W1IQ4rNOaFB3yFFrXgM9
	 WIq/zbetZ+gTA==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 0/8] KVM: arm64: Backport of SVE fixes to v6.13
Date: Wed, 12 Mar 2025 23:49:08 +0000
Message-Id: <20250312-stable-sve-6-13-v1-0-c7ba07a6f4f7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHUd0mcC/x3MQQ5AMBBA0avIrI20pYiriEUxZRJBOtJIxN01l
 m/x/wNCgUmgyx4IFFn42BN0nsG0un0h5DkZjDJWGdOgXG7cCCUS1qhLtBM5X6l2tL6BVJ2BPN/
 /sYe60CUM7/sBRZcyo2cAAAA=
X-Change-ID: 20250227-stable-sve-6-13-5ceaf408b5f7
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1489; i=broonie@kernel.org;
 h=from:subject:message-id; bh=HbHXJf6SGTZ5u093xJt01x3/Z7InN/X2lZLhzmLppWk=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhvRLsjWeCflZ6+zmKLSzTfzP8knovP+qxI+5qy9tv69X2Kuz
 8JdCJ6MxCwMjF4OsmCLL2mcZq9LDJbbOfzT/FcwgViaQKQxcnAIwkboe9v9Oc6dUejUK7ezc8M1ae0
 fevmzNd06+hj8khB5Lrg82yf38l6njveHjghnnojf9mR4XvO/Y6vqK2Us0i31lni5n4P9bNy2CdyPL
 JZ5iTlZjvUA7TmGLlT4X/YqmpqxxuPE0pdtU8IvMJUvn6KW6gW8FZn3bEvM2L/CdvBpb7/L2Jx7CTY
 Etk+7E98zmz/Nj6/zCdzCO/UNPYG3+GtetM1T7VJud4yw6E36yJ2v4vrtht8aVa0Gy2vULoarHZpW9
 uCL3pOGMTYDdjCBGX77rpc07Hm4q/yywNPr1G6s+D9mCD1+cWxVPhHdXVbp5r339UnR14rH4QrfXTN
 /LRcxztfV+MAYnf1FslW3Y5v8NAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

This series backports some recent fixes for SVE/KVM interactions from
Mark Rutland to v6.13.

Signed-off-by: Mark Brown <broonie@kernel.org>
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
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  15 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  30 -------
 arch/arm64/kvm/hyp/nvhe/switch.c        | 134 ++++++++++++++++++--------------
 arch/arm64/kvm/hyp/vhe/switch.c         |  21 ++---
 10 files changed, 204 insertions(+), 293 deletions(-)
---
base-commit: 251aeb0f2f570db5290d0dc2f8ebf87247b00b85
change-id: 20250227-stable-sve-6-13-5ceaf408b5f7

Best regards,
-- 
Mark Brown <broonie@kernel.org>

