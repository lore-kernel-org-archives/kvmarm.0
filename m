Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5E12EB874
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882134; cv=none; b=fx9KnT2vNLyk3HaOQOJZUS6IXg+wrzRHX2taXn9gm3pzczAmSYz+t8Tf9uOqzV7zpQGhUd9foTeDoIa2EoW57sb300lsNtXzeQ1hqKte/E4x4yU8E8vqEB7BsOXKaTf9CuVn/6GlKQIArVfovD8prVfxnTmuH6ZddFdCIOlksbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882134; c=relaxed/simple;
	bh=zaq6YWBuf/G29uBrxElDsX0t4jQ0Z/DxDtNSaiYqz6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DozQEuDCeamp8GmWYV4f4j/4U7FgZjMuIYK7L1jcCjl8+SiRN2hqj9WQ50A7tWEGG9wlX3OlVR08cjqoIIyYCOCPvlQbqfkS5bqOC58lVDRnENZHhWfyxU6hJm82I7KFpxgJnrzd1nmoeJqvWo93PpIkE8Jc3SBkIoopQt4jsQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jNMfl0DH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jNMfl0DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79D6C4CEF7;
	Mon, 30 Mar 2026 14:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882134;
	bh=zaq6YWBuf/G29uBrxElDsX0t4jQ0Z/DxDtNSaiYqz6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNMfl0DHdiwlQ6kj/P1bPaq0ytCwdnMpGQ+Kp1D4Lfq6X6TVpIsr3kthiV9x8hvqL
	 RNXd1A+wUAHosSxf9iS+zqApBBAsPeLA4sFcNx+TfXKP1+m36Is9w4pWBOZzNUnFE4
	 iSRqL0epuhfJaDecikynI3ywsMMqmuDs3xx8Ejgn3KH8D1R6tOQheBFLpYmIrSFekT
	 JR8Ze4bp1/dQEv8no039rsIA8jdHicsBA7/JyUgHhlyRYySOieMrwbx6BLClo3i37h
	 7Y1hEHNS0Ji+sG05bpwQx6p3R7zAAd6vH2gre3H+Gf01b3/1oQ3RKU5ifz8FiIcR73
	 Ub/eBcuHI1Z9g==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v5 01/38] KVM: arm64: Remove unused PKVM_ID_FFA definition
Date: Mon, 30 Mar 2026 15:48:02 +0100
Message-ID: <20260330144841.26181-2-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 7cbf7c37718e ("KVM: arm64: Drop pkvm_mem_transition for host/hyp
sharing") removed the last users of PKVM_ID_FFA, so drop the definition
altogether.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 5f9d56754e39..7f25f2bca90c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -27,7 +27,6 @@ extern struct host_mmu host_mmu;
 enum pkvm_component_id {
 	PKVM_ID_HOST,
 	PKVM_ID_HYP,
-	PKVM_ID_FFA,
 };
 
 extern unsigned long hyp_nr_cpus;
-- 
2.53.0.1018.g2bb0e51243-goog

