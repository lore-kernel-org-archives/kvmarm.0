Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213167;
	b=eqo8wVP67cigNtbc23yiPpnd5T44AZ48KfUNlPevVFxmXh2h3xDdas6kgxGTULUXSY/a
	 L541l7q1QgDNPpFBHCeI/wo7jRCs4FkLCAhrWfGkN9AwiiVWtoV/byFlt9swmNtmfSsZ8
	 QAe9bBn6kPzAiaMfjuUnTl8F59d4KWCNmJKeK/FV+nVgwwAGEuANxQfbOAJFOqtC4HTI4
	 dPyFr0rlo2qqLN9GGSOjp98U7dD5XCkHiVl8H3yryPgR3RLq3zTJTkTYUTmAQabZZBEfM
	 SLzwdXW11zZP62NaeW2MbaXOZr9RVcppbPAdaYfxJQudUK1yREYOfk8bvTesRTcEiXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213167;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nuZwdcEqSf0GREbYY2JQO9BxTM9vkxgcBZSixac3fTw=;
	b=kjI1ZBxzjNdmBbE2IHSnR9gDh+SCUcFwjoVpl+kc5pFeH+VcTXqIUWTvOpijp1ItqJ+b
	 ExUsaepd1E9FqlFTvUObE8iHxmgU2b6puwUBopeiODSLVzBviuNVg2Vhuc1Y2Y/TtT7xI
	 BlVtkAqcylNIKDwnplcMD7QO8cUDi/gkpD0gRhgReYiKpgthxPpeXvslK6hubg8hAiZ0j
	 KOkyxSPljWncf5oHsBAaZoeyInCbsnwKZa2Wntd/XcSKHzMrlpB5jbUYjEZz1SJVb9kpb
	 PxLJGw2j0uxjGqurf7qFAJ7N8YnlxnoqCk9HpuSzgby6Xh3p0hHy6WgBi0SmYcuRTaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EGmuC7q1;
	arc=none smtp.remote-ip=95.215.58.233
Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F627606D832
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:32:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F627606D832
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EGmuC7q1
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=mVkQGuj8ljyCa0NJBq4S9PryK2Zi+xV6c3MV6FVKjRw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213164; v=1; x=1794817964;
 b=EGmuC7q1BSxPS9ZbOUKSNLQbhatxJbmCVx7/M22yWiKih7st/8SpciqpG66fFyFkQ9pAUhp0
 /qpMTh5p4oP17p1RUZVbjeej7eADCPj/EXsktuPHzE3+qw7Dm4dP4XGu5GLY7eon2Nk2OZ9tC9X
 sZEcixwamq4qw96PNtM7xcxM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d9e35c043b16f706;
	Mon, 09 Nov 2026 08:32:44 +0000
X-Mizu-Trace-ID: d9e35c043b16f706
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/16] KVM: arm64: Advertise HBC, CLRBHB, RPRFM, CSSC and LUT to protected VMs
Date: Mon,  9 Nov 2026 08:32:00 +0000
Message-ID: <20261109083205.806619-12-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109083205.806619-1-fuad.tabba@linux.dev>
References: <20261109083205.806619-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Advertise FEAT_HBC, FEAT_CLRBHB, FEAT_RPRFM, FEAT_CSSC and FEAT_LUT to
protected VMs, with CSSC up to CMPBR and LUT up to LUT6, as for a
non-protected VM.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index a937aad009348..b325bab5431a8 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -214,6 +214,11 @@ static const struct pvm_ftr_bits pvmid_aa64isar2[] = {
 	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, GPA3, IMP, vm_has_ptrauth),
 	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, APA3, PAuth, vm_has_ptrauth),
 	MAX_FEAT(ID_AA64ISAR2_EL1, MOPS, IMP),
+	MAX_FEAT(ID_AA64ISAR2_EL1, BC, IMP),
+	MAX_FEAT(ID_AA64ISAR2_EL1, CLRBHB, IMP),
+	MAX_FEAT(ID_AA64ISAR2_EL1, RPRFM, IMP),
+	MAX_FEAT(ID_AA64ISAR2_EL1, CSSC, CMPBR),
+	MAX_FEAT(ID_AA64ISAR2_EL1, LUT, LUT6),
 	MAX_FEAT(ID_AA64ISAR2_EL1, ATS1A, IMP),
 	FEAT_END
 };
-- 
2.47.3

