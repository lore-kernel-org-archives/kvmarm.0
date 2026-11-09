Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213151;
	b=HXbx+mnmWflW6kbXmp4aCGkxWmDhtU+hK4Sw9XKA+YVgg2/EOifrI5ksgMBtzqU4dE8E
	 DkbplwGswPT767m5yQiiFRcSqmlfxgnricBR8CJVejn8vHqoD5efe0Iy07B0z9SJd3Jjg
	 KOyYPisvp2fgCEenvj8GAjcv8CG4jvrycxJlnCfzlF9/6/6GXQj4Ho+AYyW1q+yw5/CC7
	 nUTVy3S+cV3UxAYiN6BUmRvBXpLjxa2+dXk9Zh1MJVJJsi5YrJjLzWMAcCcHYaOu6fgm+
	 dnYT9bNNxBnYBI/TGfEZWB5bBsp8bCXCGSxi7p5QMKaDvhvqgTujAx568kMPTNTdgdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213151;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=42Orm40wyRzB+1dz5ASuI1+iqJtxIK4njD90kiRR/14=;
	b=aYJ5APWS30NhWgkO9cO2TNEQsa2Uwi9x35H8P6YqzDOv9zXjr1QHhVOuO6wzMi82NZbI
	 0N18NFi1Z7gNzzqUOd+PX0bgTruYepzDzsCAHDH7Cms4ahSgSfi7TxU/Zt4zEDmjcE2LP
	 +JdCQ4HhTqWWWrTmcWWvtMHZjeW0QQGN3PCqT386u84Yo/CIywaEA6xzWeKMNibmkhMlc
	 Wm40+bzHx0ynKizg3ZZZLudhoNaecTOz/46LrFp2B8CObvJ62uiXM9WXz5odhxkXZYUv6
	 IdPFenp86JlMb+Lg8pOl69AnlDHIeh0IudQigCXPaDZ57UjA9y7ZwiQeg6PKv7IUvjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IgM2gl7o;
	arc=none smtp.remote-ip=95.215.58.210
Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA10606A32A
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:32:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DA10606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IgM2gl7o
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=h9tWamJLklnLk65EksHqbtyH+466JFRTiXTrnW1mmmE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213148; v=1; x=1794817948;
 b=IgM2gl7ote6LZ27McnrsVE5cWqEZ+K/R9X0A3qD7bHy8IUAXWivb5SOXr76tDa7+iJZf3B4Y
 4kcpFuoWAHzzvVs6OrtiSKZSae41aOygC6kTpOGV2GBbw8FPU0+Snb3OfK7AicLFyQdrItOWVaW
 LfxSEcVXQaedx5ZqmMohkGv8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3df3eedc180a0556;
	Mon, 09 Nov 2026 08:32:28 +0000
X-Mizu-Trace-ID: 3df3eedc180a0556
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
Subject: [PATCH 09/16] KVM: arm64: Advertise MOPS to protected VMs
Date: Mon,  9 Nov 2026 08:31:58 +0000
Message-ID: <20261109083205.806619-10-fuad.tabba@linux.dev>
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

Advertise FEAT_MOPS to protected VMs. With the field set,
vcpu_set_hcrx() sets HCRX_EL2.{MSCEn,MCE2} for them, and
kvm_hyp_handle_mops() already handles their MOPS exceptions.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index d186aba6aa09c..bcc35d6990e67 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -212,6 +212,7 @@ static const struct pvm_ftr_bits pvmid_aa64isar1[] = {
 static const struct pvm_ftr_bits pvmid_aa64isar2[] = {
 	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, GPA3, IMP, vm_has_ptrauth),
 	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, APA3, PAuth, vm_has_ptrauth),
+	MAX_FEAT(ID_AA64ISAR2_EL1, MOPS, IMP),
 	MAX_FEAT(ID_AA64ISAR2_EL1, ATS1A, IMP),
 	FEAT_END
 };
-- 
2.47.3

