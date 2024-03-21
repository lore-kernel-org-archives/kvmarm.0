Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011E385280
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711042635; cv=none; b=rjVNp26v6gRqYZbJ4LCYD8UkC2OfL9/SuWZvOyE9Yb8asASdwyh1mJbBO+wSaA/I3FlzFpo17KIhe4z4bv1T88cTSWOwpPHA/roVVagv47pogfIc1v8sf6pn6GN2q1ppdFuijRwt715PP3MCKcbEKLFyvIwsYc0GMRRivIvyBc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711042635; c=relaxed/simple;
	bh=kpeNxrpEe9N03bUIBR0YMybK9tOs+I6f/SHhJcjaGcA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FUi68RBeLHDArUPBjYyk2zxOpooT7NM+ma1Q/jCOU9JZiIzAaT4hHy7XzS6N/XtfhkdsM70djfIggJhQPctrevm/oqChYJgguPRhTXIN64q0WSWM6zVCFpl/9gw4i4OKgmoM2uxt/hvzW2I487aWllaEzbw04zQm1FFhU/A7neA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tNnEJGqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tNnEJGqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF93C433F1;
	Thu, 21 Mar 2024 17:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711042634;
	bh=kpeNxrpEe9N03bUIBR0YMybK9tOs+I6f/SHhJcjaGcA=;
	h=From:To:Cc:Subject:Date:From;
	b=tNnEJGqZ1S6AKxKFyIj1S+S3hCs6/Feskrhcj6xwQo6WVE+xd5Ek6Az088xJuoDB5
	 CniiVSd1Mdp6diD6ZW72/pVqgdLbz7JpBl/Jr9+JuqbFfo2umpWZHCf/Ycev1jMy2J
	 846vib8+0O1mj0ieiAtNaTUFFC02xCxxAPL60LUv4pnizcT9PjmPlhfMKK3IbbsycS
	 ZNdmKrLx4DhCIH/mLTqQg7bEF00aANWehAD9fE9a5ASF+OWNRYBMi9TjdopUYRQ136
	 g/Vf+94utaxhBqwoous8vUkzKvBuzNvSPQerLwTr83wIldPRlD1SzWsskxhFjUjxH6
	 Ir9f1vbihTa4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnMLo-00EHDk-Hx;
	Thu, 21 Mar 2024 17:37:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Rationalise KVM banner output
Date: Thu, 21 Mar 2024 17:37:06 +0000
Message-Id: <20240321173706.3280796-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We are not very consistent when it comes to displaying which mode
we're in (VHE, {n,h}VHE, protected or not). For example, booting
in protected mode with hVHE results in:

[    0.969545] kvm [1]: Protected nVHE mode initialized successfully

which is mildly amusing considering that the machine is VHE only.

We already cleaned this up a bit with commit 1f3ca7023fe6 ("KVM:
arm64: print Hyp mode"), but that's still unsatisfactory.

Unify the three strings into one and use a mess of conditional
statements to sort it out (yes, it's a slow day).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index eff66ff0c7d8..cc18caaa1c64 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2702,14 +2702,11 @@ static __init int kvm_arm_init(void)
 	if (err)
 		goto out_hyp;
 
-	if (is_protected_kvm_enabled()) {
-		kvm_info("Protected nVHE mode initialized successfully\n");
-	} else if (in_hyp_mode) {
-		kvm_info("VHE mode initialized successfully\n");
-	} else {
-		char mode = cpus_have_final_cap(ARM64_KVM_HVHE) ? 'h' : 'n';
-		kvm_info("Hyp mode (%cVHE) initialized successfully\n", mode);
-	}
+	kvm_info("%s%sVHE mode initialized successfully\n",
+		 in_hyp_mode ? "" : (is_protected_kvm_enabled() ?
+				     "Protected " : "Hyp "),
+		 in_hyp_mode ? "" : (cpus_have_final_cap(ARM64_KVM_HVHE) ?
+				     "h" : "n"));
 
 	/*
 	 * FIXME: Do something reasonable if kvm_init() fails after pKVM
-- 
2.39.2

