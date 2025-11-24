Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0349A2D481F
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010921; cv=none; b=gnNdv1qdo383zbkfF7Lk8WxYXBJ3+DUOJUiLGoP0l+jG/nXU1yTQL8Q5OSn/F5v+6O9TS3nk2Kc9SyBC3auIVduFZ9HRPZWVcqrVsE6DEgWe40mcqH0Y349Xts0+t3cz+MvhYHPeKJnR8T6VWbbpL+Mi+CLAlROw9JQe2rxPupg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010921; c=relaxed/simple;
	bh=+gAD+IaTwpG1gRteVAgWRs/7VtXVdKOClN/MoBBXTFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtCPILzm7Ojgwccpder0ogbDyy03rXYxeUhZ53wT//5BbxQS5oiG8Yb6ZdwQRRhcgtNOhwf/g1uknO26mcFHUG2JTHR6WBzS6MjWw5YRJR9lDCNbjphAPOWZX+E30vMQOhUxY9fgIa1EV0hSDWM5NJj31P36LU31mY2Qfo8i1Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Am2XH0W4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Am2XH0W4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6173C2BC87;
	Mon, 24 Nov 2025 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010920;
	bh=+gAD+IaTwpG1gRteVAgWRs/7VtXVdKOClN/MoBBXTFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Am2XH0W4xksStCkGEf1y/gdMimx+zFKxUikzQBZnAWQwE996FlCo72z9hElkeX1Oa
	 wtPyez0i2t2ZI6V22p/18CYD7soNA13c/P1oCF1I9+ZoPVT+63b6jbFO2ppkLleKjU
	 nwCBkB1nXqwfuCRdBWyMUbChbLvsidq5dent9yTwr+i8w+394QeehKsOlaNmieqj5C
	 +1BGNL9fgbpuqmZIeik0/w5ZR6vE8596nnip/HIIdKXtiSfhmP2eEWX0zQCAu//qsO
	 0e8Ki7Y8CIAQExrolfRF3RVDOpMf1g2SiBxbL4Wd1pj3/fCXAs+M1vvxU1J12JRflF
	 /e7406F7IpoYA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 06/15] KVM: arm64: Call helper for reading descriptors directly
Date: Mon, 24 Nov 2025 11:01:48 -0800
Message-ID: <20251124190158.177318-7-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124190158.177318-1-oupton@kernel.org>
References: <20251124190158.177318-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Going through a function pointer doesn't serve much purpose when there's
only one implementation.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 08839a320a45..e4928a6a3672 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -124,7 +124,6 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 }
 
 struct s2_walk_info {
-	int	     (*read_desc)(phys_addr_t pa, u64 *desc, void *data);
 	void	     *data;
 	u64	     baddr;
 	unsigned int max_oa_bits;
@@ -199,6 +198,13 @@ static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
 	return 0;
 }
 
+static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, void *data)
+{
+	struct kvm_vcpu *vcpu = data;
+
+	return kvm_read_guest(vcpu->kvm, pa, desc, sizeof(*desc));
+}
+
 /*
  * This is essentially a C-version of the pseudo code from the ARM ARM
  * AArch64.TranslationTableWalk  function.  I strongly recommend looking at
@@ -257,7 +263,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 			>> (addr_bottom - 3);
 
 		paddr = base_addr | index;
-		ret = wi->read_desc(paddr, &desc, wi->data);
+		ret = read_guest_s2_desc(paddr, &desc, wi->data);
 		if (ret < 0)
 			return ret;
 
@@ -325,13 +331,6 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 	return 0;
 }
 
-static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, void *data)
-{
-	struct kvm_vcpu *vcpu = data;
-
-	return kvm_read_guest(vcpu->kvm, pa, desc, sizeof(*desc));
-}
-
 static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
 {
 	wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
@@ -364,7 +363,6 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	if (!vcpu_has_nv(vcpu))
 		return 0;
 
-	wi.read_desc = read_guest_s2_desc;
 	wi.data = vcpu;
 	wi.baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 
-- 
2.47.3

