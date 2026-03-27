Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9271D382295;
	Fri, 27 Mar 2026 11:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611386; cv=none; b=lC+Lc0LkSBUGJCpvgAxYDiS8AydkPkoHD+aASf7kYaDtbHcHb6UmW3F6urlyqzCT+IzWRWVSxZ0nyOpgHrzKIuy8mfPSUBdheFArMwHwCVpeVy2mnbOV2yi0ZsiWm8P7O7DBr+wBX4iX9F3up128XKcXpwAW2l2RvUJN96/KltI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611386; c=relaxed/simple;
	bh=JLJno+3X94Z+dwP3LduacgmLynCJjyUa2fPX69f8UCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLhpeBkzJYZ49XePvPhmbqL3PmL0sSbW8doSZt6VlypxSsKtQhNGJrdOiwdicF103PeCYEFLYfMR3pq+M0gdZEinrCtAJU3tZTLG+kTE7FRtVDbdZw4TalFL/3+B54wD9OIQ9zJCFpEXZKaLjME/huLsANQ5VoQokzN87X6Bc0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bA3b8wpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bA3b8wpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A64C2BCB0;
	Fri, 27 Mar 2026 11:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611386;
	bh=JLJno+3X94Z+dwP3LduacgmLynCJjyUa2fPX69f8UCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bA3b8wpnsdKA3TZhMahzbVrOBC175eV4tVhJ2HnIfK2791PpXKKj+w5uC1vtUrTtC
	 p37/9Lo5OW7HI3IMPJv1N3u0WsUczLAVaDZhlE3XDx+6uDa3iB4UOzN16hkOBYefp4
	 f86f7QQq/ZAEiSpwebRH7H0TaqcBSZekLb+DjlYHX9Y4TY+J37RwRPK8RqXsnCTawC
	 Y+vwuwJ73bnDMX2BnJkohR1mRWPOyVscOHTVvhhpMPTNy/ohcxlXevo5GN9glGM/iP
	 6TsZm75hxLCHTz8yrHdv+sK+tVeMUE6/R1Fc0Z8/4hFMhpni1UvEo+5+vfZf/Q/oI8
	 5Z/4L5m2GKFug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UG-00000006K4a-17aW;
	Fri, 27 Mar 2026 11:36:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 09/30] KVM: arm64: Simplify return logic in user_mem_abort()
Date: Fri, 27 Mar 2026 11:35:57 +0000
Message-ID: <20260327113618.4051534-10-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Fuad Tabba <tabba@google.com>

With the refactoring done, the final return block of user_mem_abort()
can be tidied up a bit more.

Clean up the trailing edge by dropping the unnecessary assignment,
collapsing the return evaluation for kvm_s2_fault_compute_prot(), and
tail calling kvm_s2_fault_map() directly.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1b991300735be..e77b0b60697f6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2005,22 +2005,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (ret != 1)
 		return ret;
 
-	ret = 0;
-
 	ret = kvm_s2_fault_compute_prot(fault);
-	if (ret == 1) {
-		ret = 1; /* fault injected */
-		goto out_put_page;
+	if (ret) {
+		kvm_release_page_unused(fault->page);
+		return ret;
 	}
-	if (ret)
-		goto out_put_page;
 
-	ret = kvm_s2_fault_map(fault, memcache);
-	return ret;
-
-out_put_page:
-	kvm_release_page_unused(fault->page);
-	return ret;
+	return kvm_s2_fault_map(fault, memcache);
 }
 
 /* Resolve the access fault by making the page young again. */
-- 
2.47.3

