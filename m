Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F1726E6F6
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419412; cv=none; b=mHMMKCN6dly/XSuEqsitORpTiVAiukp9DwcYHtuQ4hanJLojwGjzpdbasgdsvVP6liKxjM2ZFc0oGbwIlTHjaoVpCAKu4rYVffLK6gWj4p6clQX6Mrln2Z/UJtxg9a6ikkI1NL7smIvabn/sYsMcdbiATorhvDcEMWC3ITPSTBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419412; c=relaxed/simple;
	bh=dXH0rE8LtXeKC3B2KtZnw+0uoOKdfvD26xvEnLSUIco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0hGkWu9YQQHRrT2GRG2iF6yIzIyJr+AagFcXMbFFWYbxiF9Zmc8tXXDn+mVbu/0O5A1DhvJYPvxDHlc6NbnE7ZPpQbwF+c5MRcggcPLG2NYWLqyLlmUfQY/ngZhKEk6Od2zzq51cKc85P3Yo0qpADOqZ2tANP60C5520YoYIMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8vKdiFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8vKdiFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31ACC19423;
	Mon, 17 Nov 2025 22:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419411;
	bh=dXH0rE8LtXeKC3B2KtZnw+0uoOKdfvD26xvEnLSUIco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8vKdiFUroRdCjkksj77DFlIo6lvMoJatrbCSxbaZErLvYmWm82/hRbFMp6L9A4YN
	 dqsi8QFM1JKtyFA6Ypx89Q95LSaiMZDlNfYmFUW9+IlGGO74MuleDBuY/1KHJBRQQy
	 6gt+mtxKGc8RLK/IEgsnwbCTK4jwmGKxOUriiE9j/4S2Un/4CWuKuqgsDoT8eS4F3j
	 eXYEItEz7QaQX7MVDAQhFuzUErWncJ5SIiSTsvGfwOkPdYTTwXglb/1Jz106KIdfWm
	 EK5SldxhXkAi1kzZyU2nkV+x0LDpZ69hDVfNdpene3AIFuXo34Iy9ha+wGTGbPBIMe
	 VMRBwmvbA0XQw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 07/14] KVM: arm64: Handle endianness in read helper for emulated PTW
Date: Mon, 17 Nov 2025 14:43:18 -0800
Message-ID: <20251117224325.2431848-8-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
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
 arch/arm64/kvm/nested.c | 30 +++++++++++++++++-------------
 2 files changed, 36 insertions(+), 19 deletions(-)

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
index cf4b24e04a1a..10e68aab3d2a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -198,13 +198,26 @@ static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
 	return 0;
 }
 
-static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, void *data)
+static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, struct s2_walk_info *wi)
 {
-	struct kvm_vcpu *vcpu = data;
+	struct kvm_vcpu *vcpu = wi->data;
 	u64 val;
 	int r;
 
-	return kvm_read_guest(vcpu->kvm, pa, desc, sizeof(*desc));
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
@@ -265,19 +278,10 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 			>> (addr_bottom - 3);
 
 		paddr = base_addr | index;
-		ret = read_guest_s2_desc(paddr, &desc, wi->data);
+		ret = read_guest_s2_desc(paddr, &desc, wi);
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

