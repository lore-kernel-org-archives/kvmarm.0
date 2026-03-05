Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB0D3A4520;
	Thu,  5 Mar 2026 13:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772717281; cv=none; b=IY5usXfTaQeGc0oxDs3JBVmL2Vhr8HJz5DTSaGvDsmLLjS4SgtTBJwS1Uz4m/2Si8n1iFGNfG3IBm0ojC1gUf0XB46b5iPiebqeN0UfZ/fvnxBeMbIL91797PEeEuF91wVE5H76wMJJPeHkMGnOJiG7Jrolifn2PRPJswc9e7B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772717281; c=relaxed/simple;
	bh=lnBSHxmNphnGNCi22PlaGFKdvnE9IXS9939YI+0IHf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gSKXPVlmR4ETq+P45jVWtSZ1Pisw7jyfu4wNvw1SbYINmGkcTycII2FBRAkTuP6uH0TEeflSQnw+rkvW36eMhOm8In0FeXnHdjijpk3cN5Os0V1mk8cFgkRcaOTdCalEUMMMUMR0X0WvEJx0PGBXxFEPzPMkz2IRxgFVL80bXV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LetMebQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LetMebQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A6CC116C6;
	Thu,  5 Mar 2026 13:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772717281;
	bh=lnBSHxmNphnGNCi22PlaGFKdvnE9IXS9939YI+0IHf0=;
	h=From:To:Cc:Subject:Date:From;
	b=LetMebQDnbnkvkpZ77o4DJegqdAtRxcSwn2e975//5D15F2wztxAf6ue0O1wcByQz
	 uJ+bbLHmbT0GAE6/l3QQlflrP9/sgfSRgoQbPZmTZTynD/FwJHR5RGSygFhtIn2SkM
	 a5n1U5V0UGJmuLYe6m4KE+u6MEetsu3ELvKiz3axzLeagbC+DOMKoqDS6J5DaPKAOT
	 QT8o0BGvLvl13qZYSPoDt4uq47vSpvg8qYu3VWDi39nrPlMYkPn7dwHqVbOLpMlWc7
	 9yps8TnTd2J0Xk82h14cyL9endiFGiz4W/MCnMWx7ELXvcVQMe1tDRgYGTzDi9zchQ
	 ydHvonROTXS7w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vy8kA-0000000GST7-3TSz;
	Thu, 05 Mar 2026 13:27:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Quentin Perret <qperret@google.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: pkvm: Fallback to level-3 mapping on host stage-2 fault
Date: Thu,  5 Mar 2026 13:27:51 +0000
Message-ID: <20260305132751.2928138-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, tabba@google.com, qperret@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If, for any odd reason, we cannot converge to mapping size that is
completely contained in a memblock region, we fail to install a S2
mapping and go back to the faulting instruction. Rince, repeat.

This happens when faulting in regions that are smaller than a page
or that do not have PAGE_SIZE-aligned boundaries (as witnessed on
an O6 board that refuses to boot in protected mode).

In this situation, fallback to using a PAGE_SIZE mapping anyway --
it isn't like we can go any lower.

Fixes: e728e705802fe ("KVM: arm64: Adjust range correctly during host stage-2 faults")
Link: https://lore.kernel.org/r/86wlzr77cn.wl-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Cc: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 38f66a56a7665..d815265bd374f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -518,7 +518,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 		granule = kvm_granule_size(level);
 		cur.start = ALIGN_DOWN(addr, granule);
 		cur.end = cur.start + granule;
-		if (!range_included(&cur, range))
+		if (!range_included(&cur, range) && level < KVM_PGTABLE_LAST_LEVEL)
 			continue;
 		*range = cur;
 		return 0;
-- 
2.47.3

