Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F88D2D47E8
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010921; cv=none; b=umsBqbOcADxxgC42X8s7ssCJ+uZdKL/bSO6+eqma7td2GX5uHoaNDezvhFDNCfFouAuufLo7IqQctZwy+4L7xMl4Al2HIQOZexT4ZgCrXhzhJpSEACRmovV29XLJeEjitlqk2wlck28oYkTY88f+UwzoodvKetuAsV3s0n354i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010921; c=relaxed/simple;
	bh=+qPsO4bgGQzYvJXWOcCeqn9nu6ZNp6hByCg2pofBoTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJ7206iMN/R24fkbU7Df7db1+n62Dnbrlia96doylJBhiZsS+U3Nh6bygZj8f6fHKJT6fq2iHVyYYpp4zQcDtccyZ6dP3LrSfaRWFsLBJbK8RhkL7ptdNIM3+iRDEeHzJMI4U3ZbmnzZr48isIMAQkN93sr55k3VhtaP50aQ4Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCwO/XtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCwO/XtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322BEC19421;
	Mon, 24 Nov 2025 19:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010921;
	bh=+qPsO4bgGQzYvJXWOcCeqn9nu6ZNp6hByCg2pofBoTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCwO/XtVD36g9VgO+x/ZsqYDrgOes4jGeJuqh6XDCU1aAQM3Dau6Fo/xs3QHut/qC
	 n5UbNEB/HXdifO19kvoZ39slnJEdxRgI37jjs3JRC576hsaJW6XumTwbn9xOJgHb1V
	 jRlYjGHpWFtPFNCRZpCXNPzF1jJfXYUOOp3CsM/JFs3ycPUbz7kHdPSvXrVWhHAk+u
	 uyLQcDSY1hKmRiD0di5BbEmtBz6Cy0E8SV/ysYQlR7YVzKKd8GRt/UjMu7J0KbbyI+
	 m4LQSMnVjgCNF0/7ic5VBXF0hfJjGlF8qZoY+0xII3h1c1M4adL8rOuO/rXgidPg3u
	 6QFK0sx7FQdkA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 08/15] KVM: arm64: Handle endianness in read helper for emulated PTW
Date: Mon, 24 Nov 2025 11:01:50 -0800
Message-ID: <20251124190158.177318-9-oupton@kernel.org>
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

Implementing FEAT_HAFDBS means adding another descriptor accessor that
needs to deal with the guest-configured endianness. Prepare by moving
the endianness handling into the read accessor and out of the main body
of the S1/S2 PTWs.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c     | 25 +++++++++++++++++++------
 arch/arm64/kvm/nested.c | 32 ++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index be26d5aa668c..a295a37dd3b1 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -362,6 +362,24 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	return -EFAULT;
 }
 
+static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
+			    struct s1_walk_info *wi)
+{
+	u64 val;
+	int r;
+
+	r = kvm_read_guest(vcpu->kvm, pa, &val, sizeof(val));
+	if (r)
+		return r;
+
+	if (wi->be)
+		*desc = be64_to_cpu((__force __be64)val);
+	else
+		*desc = le64_to_cpu((__force __le64)val);
+
+	return 0;
+}
+
 static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		   struct s1_walk_result *wr, u64 va)
 {
@@ -414,17 +432,12 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 				return ret;
 		}
 
-		ret = kvm_read_guest(vcpu->kvm, ipa, &desc, sizeof(desc));
+		ret = kvm_read_s1_desc(vcpu, ipa, &desc, wi);
 		if (ret) {
 			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(level), false);
 			return ret;
 		}
 
-		if (wi->be)
-			desc = be64_to_cpu((__force __be64)desc);
-		else
-			desc = le64_to_cpu((__force __le64)desc);
-
 		/* Invalid descriptor */
 		if (!(desc & BIT(0)))
 			goto transfault;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 94eff8307aad..75d26c0ba3e0 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -197,9 +197,26 @@ static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
 	return 0;
 }
 
-static int read_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 *desc)
+static int read_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 *desc,
+			      struct s2_walk_info *wi)
 {
-	return kvm_read_guest(vcpu->kvm, pa, desc, sizeof(*desc));
+	u64 val;
+	int r;
+
+	r = kvm_read_guest(vcpu->kvm, pa, &val, sizeof(val));
+	if (r)
+		return r;
+
+	/*
+	 * Handle reversedescriptors if endianness differs between the
+	 * host and the guest hypervisor.
+	 */
+	if (wi->be)
+		*desc = be64_to_cpu((__force __be64)val);
+	else
+		*desc = le64_to_cpu((__force __le64)val);
+
+	return 0;
 }
 
 /*
@@ -260,19 +277,10 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 			>> (addr_bottom - 3);
 
 		paddr = base_addr | index;
-		ret = read_guest_s2_desc(vcpu, paddr, &desc);
+		ret = read_guest_s2_desc(vcpu, paddr, &desc, wi);
 		if (ret < 0)
 			return ret;
 
-		/*
-		 * Handle reversedescriptors if endianness differs between the
-		 * host and the guest hypervisor.
-		 */
-		if (wi->be)
-			desc = be64_to_cpu((__force __be64)desc);
-		else
-			desc = le64_to_cpu((__force __le64)desc);
-
 		/* Check for valid descriptor at this point */
 		if (!(desc & 1) || ((desc & 3) == 1 && level == 3)) {
 			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
-- 
2.47.3

