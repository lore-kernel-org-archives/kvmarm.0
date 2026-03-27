Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC548248B
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620054; cv=none; b=I8QJ8enzNmCkH8DMOVe8eVQQCFG3JTj1F11O/ettD6H6ooqNLdhZEaqxPVILBYxNwCcxX8OXGbN1yiRE8jYxvgDIpbA+Ime2Y+peKRvcunIDNTf2p/jxCATl9XBXg8foy8zyXDt7Y3baaXfgt2kSuoDxnVUb6h3uAg4QfuwFql4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620054; c=relaxed/simple;
	bh=zaq6YWBuf/G29uBrxElDsX0t4jQ0Z/DxDtNSaiYqz6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDqSNsu4S91PAQqysVrQe6gG7THHHY+atwRBtVPmYDuzhdLH6lK/JdUPIA5Rt2sxJ/hh7LkPkEasT7+rGZyAI9jL3myYG7QRN9TyZpLLtPXjRpciAPf+fHNeuHP5/g7sGDtCAd2cpAFaL0XCnW6GabklCxHzXLqcpR1H0pi2JV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HdYADp1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HdYADp1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC75C19423;
	Fri, 27 Mar 2026 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620054;
	bh=zaq6YWBuf/G29uBrxElDsX0t4jQ0Z/DxDtNSaiYqz6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdYADp1C2s9y8ZX+6HCIb/Sa2pehpf4QRKaShe7CvFGt9e7fMWavkCL2hUSIboPsQ
	 wUYYQ8p2/gbPUj5UssdIzaXRtTAg10hwx5bVgfCD1A2IlLz5KsJmXkAaGMvhWghlC9
	 FLmuvBDTJMwmxUpmDWS4CzWIQp8Pl1jCwwU7Ee8nyE79dfEkxghtGylSeCitD22Sbn
	 eMsLfz2bAz1XQUdApAnqinLSop4LfCSLJFRXGnyUkQFd9LunFJAS1wdDvQ5FP20qHU
	 zMH82D93eINCq66vwozlL0LVXFCoZNoQGr01t+gRJQdOgAGHQMCI5s453IIXPY8Kmt
	 6Bq3s6Eu2xoBw==
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
Subject: [PATCH v4 01/38] KVM: arm64: Remove unused PKVM_ID_FFA definition
Date: Fri, 27 Mar 2026 14:00:00 +0000
Message-ID: <20260327140039.21228-2-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
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

