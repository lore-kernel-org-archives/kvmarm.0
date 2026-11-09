Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.230
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213186;
	b=ez62w9ta3Ede1so2xz6IHxadT8fKQ8RZ2k6rZV2jDWbdHthqtCxNFqb93Z8vMOK/MCb+
	 FUJdnEZyKXv5BdFCo3qXYS0OH0ZnD2Hw+ziEGtjqlxjNhl8Uaa/ti+6hL0wJco1WIlkAe
	 SoiUyrKcLQ6aKosqz26BK3vY24iHenuZ3LgTjG10MmrSWS+t1P+a0+8W2U3w0jC009bzV
	 SFGNuuuB1ap9shtlPRp1Kvm8Z0YEMsnUZubVmVBfJQ8LCVIfH4H2BRXk4nExwAJq0eNSu
	 bxJNTPVGWRSvc/uer+mC9vuRmU7apE8d7ZIhL6b81D7YcJZhRT2yp6YuKu1U1qlYdGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213186;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tscIvS/2uNNzd7geDNK8rFMHpCV6KI9seOh0hyrqpj4=;
	b=0dQYjCg6m1El3VSohXrGqh5d2rqJ40SVZlo7r2bv4F8XhUrf6KCNYbR6TBKqmk8a57UT
	 0yJa4y94QQjwHWrqHNevlAeOwUscuh7J1ThRqR4B354OBG+DdxPlXUHCMyWj87tdLoaIx
	 pdFAsIUzTTeMK4s27W6mVfvRS1J5euvo1YFWVG/bwJAovWf3zlVHg1/aoBnnDAxT5Ap8g
	 vLG69x4krW/Wp+WqP/igtXoTaGlQUUPx75byZMoLuHwR9H0Fer0kWcjHAIVHyytmMJaIR
	 etj4du7JJuav0kdmJ0HeJpnnuwEJw4rRTVlYt+qFe3g4/d8h19Sd9fgjbh1xdBPKv5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lCVV2COP;
	arc=none smtp.remote-ip=91.218.175.230
Received: from mta0.migadu.com (out-230.mta0.migadu.com [91.218.175.230])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6ED7606D82C
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:33:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6ED7606D82C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lCVV2COP
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=eF62gDKoO96Jep9ah+yCAh5pGqTeJMWdIW2pxz+Y0j0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213184; v=1; x=1794817984;
 b=lCVV2COPcREcfPIqIy+ml7BL5xVtiP5cYTiQnEyk294NekzyHaPPiytxLaSElUyfIQQ3hD2q
 QnfhdOZ5/Tik3ujuYGUcu9Vefi2Ra2MSWI2ltgguozLFXhce/Oz80UI3KQWXUM9E0gYMTi8Q20l
 rFYnaqsGVHpV5Vz6gUjdc9zY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 41f2f89c3729ba68;
	Mon, 09 Nov 2026 08:33:03 +0000
X-Mizu-Trace-ID: 41f2f89c3729ba68
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
Subject: [PATCH 16/16] KVM: arm64: Advertise ECV, HAFT and ETS3 to protected VMs
Date: Mon,  9 Nov 2026 08:32:05 +0000
Message-ID: <20261109083205.806619-17-fuad.tabba@linux.dev>
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

Advertise FEAT_ECV, FEAT_HAFT and FEAT_ETS3 to protected VMs, with ECV
capped at IMP and HAFDBS at HAFT, since CNTPOFF and HDBSS only add EL2
and EL3 controls. ECV's self-synchronised counter views trap under the
same controls as CNTPCT_EL0 and CNTVCT_EL0, which kvm_handle_cntxct()
emulates.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index a0f6737ff8f16..4ab0ee50eea20 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -173,16 +173,17 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr0[] = {
 	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN4, IMP),
 	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN16, IMP),
 	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN64, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, ECV, IMP),
 	FEAT_END
 };
 
 static const struct pvm_ftr_bits pvmid_aa64mmfr1[] = {
-	MAX_FEAT(ID_AA64MMFR1_EL1, HAFDBS, DBM),
+	MAX_FEAT(ID_AA64MMFR1_EL1, HAFDBS, HAFT),
 	MAX_FEAT_ENUM(ID_AA64MMFR1_EL1, VMIDBits, 16),
 	MAX_FEAT(ID_AA64MMFR1_EL1, HPDS, HPDS2),
 	MAX_FEAT(ID_AA64MMFR1_EL1, PAN, PAN3),
 	MAX_FEAT(ID_AA64MMFR1_EL1, SpecSEI, IMP),
-	MAX_FEAT(ID_AA64MMFR1_EL1, ETS, IMP),
+	MAX_FEAT(ID_AA64MMFR1_EL1, ETS, ETS3),
 	MAX_FEAT(ID_AA64MMFR1_EL1, AFP, IMP),
 	MAX_FEAT(ID_AA64MMFR1_EL1, TIDCP1, IMP),
 	MAX_FEAT(ID_AA64MMFR1_EL1, CMOW, IMP),
-- 
2.47.3

