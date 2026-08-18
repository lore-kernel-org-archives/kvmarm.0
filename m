Received: from mta0.migadu.com (out-207.mta0.migadu.com [91.218.175.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6349E4028D9
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045483; cv=none; b=Jjcfx9vT1Cp6fXHVdqJrEm60xyIXARvZob4NRUXzcruFxRKTb8lRCFY7BlyCXRUFtWhewcbIQ1gBqxZebcFXLwugiTBtsbNoYPHK7qPsU5CtKgL/NvNsWizrXrdCLp6smrPj5IdmG8hoTlQ6xf3dg7jQSkLFCwgf43MBLXtT8Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045483; c=relaxed/simple;
	bh=Vb6Fl0I1rby4ElE/J1DJa9gFntSqX1VemiiID5vWGjk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h7WgqyIMQiUpFtF9iY9xdnNRIkcZwVUrYtJYVkJL5Hn+AfHEU5QuKlMN30c5A1OqMDz0EftBPNhktFhXjekXMyZqK4CZ5dWgembO83WV4yeOQ6cpLRAgL7o9amLV7h81a1CKCbZ+AtsRPqipcNv9trz8Ci18DVmL85MEyOxEaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nFMVC0x0; arc=none smtp.client-ip=91.218.175.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nFMVC0x0"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Vb6Fl0I1rby4ElE/J1DJa9gFntSqX1VemiiID5vWGjk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787045478; v=1; x=1787650278;
 b=nFMVC0x0C9dc8+Fvcmn1vchyjUSpOrowBVDmgFh306WyVxlDvKtH7zC2eWvSUWXwiRiEAEFM
 lUPM8TQoxOk3xNCqiF2K37IixbUFu8pA1mWw++dAzHZxP1kGik4M8XubYQcWf895mi5QlDeakr2
 idewcl0lEmtdW6l3Q+bgMlLk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 30fd6cd8b041122a;
	Tue, 18 Aug 2026 09:31:18 +0000
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Stefan Teodorescu <fane@google.com>,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()
Date: Tue, 18 Aug 2026 10:31:17 +0100
Message-Id: <20260818093117.2379344-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pkvm_vcpu_init_sve() clamps only the upper bound of the host-provided
sve_max_vl, so an invalid vector length reaches sve_state_size_from_vl()
and the WARN_ON() there, which is fatal at EL2. The existing
!sve_state_size test rejects such a length, but only after the macro has
run.

Check sve_vl_valid() before deriving the state size. A valid length
cannot yield a zero size, so the !sve_state_size test goes with it.

Fixes: 5db1bef93342 ("KVM: arm64: Track SVE state in the hypervisor vcpu structure")
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Based on v7.2. Applies cleanly to kvmarm/next as well:
    pkvm_vcpu_init_sve() is identical on both.

 arch/arm64/kvm/hyp/nvhe/pkvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 24d6f164129ac..095ebfce91b08 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -460,14 +460,15 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 
 	/* Limit guest vector length to the maximum supported by the host. */
 	sve_max_vl = min(READ_ONCE(host_vcpu->arch.sve_max_vl), kvm_host_sve_max_vl);
-	sve_state_size = sve_state_size_from_vl(sve_max_vl);
 	sve_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
 
-	if (!sve_state || !sve_state_size) {
+	if (!sve_vl_valid(sve_max_vl) || !sve_state) {
 		ret = -EINVAL;
 		goto err;
 	}
 
+	sve_state_size = sve_state_size_from_vl(sve_max_vl);
+
 	ret = hyp_pin_shared_mem(sve_state, sve_state + sve_state_size);
 	if (ret)
 		goto err;
-- 
2.39.5

