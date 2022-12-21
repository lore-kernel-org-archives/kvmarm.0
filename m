Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717ECC10F1B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Dec 2022 18:15:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5624B891;
	Wed, 21 Dec 2022 13:15:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xFvZp5Pbqn7B; Wed, 21 Dec 2022 13:15:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3C604B8BF;
	Wed, 21 Dec 2022 13:15:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B384B891
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 13:15:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gx340w3ih6JU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Dec 2022 13:15:12 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B40DF40B8D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 13:15:12 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id BC30861882;
 Wed, 21 Dec 2022 18:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C547AC433EF;
 Wed, 21 Dec 2022 18:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671646511;
 bh=Ww76TZ9BB78DAjVJwHWXLM5nY8FNaNmlN8xgMqvWvaQ=;
 h=From:Subject:Date:To:Cc:From;
 b=BpY3at+PT/i9VuoeoAnkgkmwm3fNP/dCX8tfanHE9IASlJTaZcCnGXnuDhFG8KoGe
 IZCgUd33/gAEw1g7hHQlV8JgspSZv0mAeLBBdvFOO1linHXmAgMFr3+ssPRTzfauPq
 tXe9BBrnpQKMzW6sOYoZmx+m0g4VGBAqpRpKiHclHja10ut1+egD2v9R4MfOl9t0fv
 JO7LmeZy6HaU0wCyOly7mi1tQlSZ0dUjKOE7cnTIdl4dSEih2mWRk31RJmXxeu5Mw6
 kGmfleB8aP4wOC++n0o98RDHNh8cVpYDcoRnlPmm3BW1mi4/uUTpchlzBJ2hELNPlU
 YIa51g+NhNHwA==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: syreg cleanups/fixes
Date: Wed, 21 Dec 2022 18:06:09 +0000
Message-Id: <20221221-kvm-sysreg-cleanup-v1-0-112ddb14fb4e@kernel.org>
MIME-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABJLo2MC/x2NQQqDQAxFryJZN+DMohSvIl0kM6kG7SgJtS3i3
 TsW/uZ9eLwdXEzFoWt2MNnUdSkVwqWBNFIZBDVXhtjGGOpw2p7oXzcZMM1C5bViztdwYyIWZqgi
 kwuyUUnjqb4Xm857NXno59/q78fxA/VpiZh7AAAA
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
X-Mailer: b4 0.12-dev-05166
X-Developer-Signature: v=1; a=openpgp-sha256; l=3041; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Ww76TZ9BB78DAjVJwHWXLM5nY8FNaNmlN8xgMqvWvaQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjo00qOJn+vsVdjXUd4aUtW7nLJb8naJAWxNldxof7
 JM4FIZeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY6NNKgAKCRAk1otyXVSH0C4LB/
 49Il8DrpXAtmXTRhrcC519PB9z+Z+NDJjj22jAWMrkPaDYAxhkdWfQG6IYVNTzeu4o11JBSNsJg87J
 0F1ADTm7xSnhKJro4Q27HCwaHHMn1dNh83RcF7BdNsQUUbQEXdJPM+vtOjuFwojnDUbdKa0bSaxARY
 v8oeW8E5OfMExkaDwIYBrxJUSgayNSNR6jTKJ/x+ZO13h+uF1mJKuUMkz0vNi19n7xbK0KggUp6rjz
 68yNdgzw89bXhzutJ8n0bzu7qwEiPCteja/S+WYf99qWDwDEfqQJeaIdjUx+FOOuePAxc2pl0x/j9A
 xraPYYtRdGniISD2nS6fPoxUZ1Jyc8
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

While looking at the KVM ID register handling I realised that the
ARM64_FEATURE_MASK() macro which is extensively used there assumes that
all ID register fields are 4 bits wide which is sadly no longer true.
Fixing this just in the macro results in something that asked for
further cleanup so I went and did that.  The end result is this series
which replaces code like:

	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);

with:

	val &= ~ID_AA64PFR0_EL1_GIC_MASK;
	val |= SYS_FIELD_PREP(ID_AA64PFR0_EL1, GIC, 1);

which is if nothing else shorter with less boilerplate, and as a side
effect removes the assumption that all feature fields are 4 bits wide
that was what got me started.

At least one other assumption that fields are 4 bits wide exists in the
pKVM code in get_restricture_features_unsigned().  I have left this for
now since it is a much less mechanical change so probably belongs in a
separate series, I will work on that separately.  The one register I am
aware of with fields that are impacted is ID_AA64SMFR0_EL1 so should
only become relevant in the event that we expose SME to pKVM guests.

There are some similar changes to use SYS_FIELD_ that could be done in
the GIC code but this is already far larger than would be expected for
the original fix and updating the GIC code will need the GIC registers
converting to generation which would really increase the size of the
series.  The GIC also doesn't use ARM64_FEATURE_MASK() which was the
original issue.  I will also send updates for the GIC separately.

Since this is highly likely to generate conflicts I'm posting during the
merge window to try to get a head start on review, I'll rebase against
-rc1 once that appears.

To: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>

---
Mark Brown (2):
      KVM: arm64: Convert non-GIC code to SYS_FIELD_{GET,PREP}
      KVM: arm64: Remove use of ARM64_FEATURE_MASK()

 arch/arm64/include/asm/sysreg.h                |   3 -
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 120 ++++++++++++-------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                 |  40 ++++-----
 arch/arm64/kvm/hyp/nvhe/sys_regs.c             |  26 +++---
 arch/arm64/kvm/pmu-emul.c                      |   2 +-
 arch/arm64/kvm/sys_regs.c                      |  66 +++++++-------
 6 files changed, 128 insertions(+), 129 deletions(-)
---
base-commit: e45fb347b630ee76482fe938ba76cf8eab811290
change-id: 20221221-kvm-sysreg-cleanup-dd618baabebb

Best regards,
-- 
Mark Brown <broonie@kernel.org>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
