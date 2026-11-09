Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213166;
	b=b4xII9oHJJTd/v4uFuq9nnKL6YbXIiFzAmGJscITgKQcHgho7YRwuE8noWUVTO0O4mmO
	 L/MpyrGAvgj23bGiQRABTyHnJkXcweD3QqzbaYc4URjETzTJgo591ixBFRmTPmsDRtn78
	 zMI9yt/+vwzarJOguZ2DRhTolzBaY57wrwJEHgGYW7mXPDoNPaXNRjmgDFrzKwnxYvK9b
	 HhfOIENmfmU5DFOoIUfcfAnyHPhOjhRCX5Kt8ry3jLKaUU7ztJM4iz4zIjxBs29wLv8bR
	 vcRTrs4uZXeBs04SDnRJpmvGPKKBpaluIzh7dG9rqU1loW3vzEzrgr/DS+G53yd6gkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213166;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LF0Ejm61SZQjc0f58igDHYvnGorLWUKIVR39Ms9bxQo=;
	b=4ADInTRyzB6rC8dZotaB0RPzwhjrs85ySLIA9sUULIvAjqYeWNKUlN8ZwRngGfw8NwhS
	 mR1NZoPR4uDRGL6/IOlaFtn8pWoii5nGQv61MOy8+5VbFuY+WViqqvssfwPVEhowrhycG
	 Y++T5LFYy6BU9hpUwIr/dgqA2t9Hreg9anA3nOQsu0Jc6x+RlJUwx26YZCfNX23ohK1X7
	 nhl1qYsBS9m1KP+/UXWG4kmMjf73/rz7y+QGOZDKZgtbMaj29xutaxdpSu/6mP4m5ATHI
	 IcY/PXU4BJv4S97HpL+HpiADxe0zZYws0VWV0LbVwCHEbBbOlcvNt7lFUyU8rZVheqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c7ZQEn84;
	arc=none smtp.remote-ip=95.215.58.226
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BF3606D82E
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:32:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29BF3606D82E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c7ZQEn84
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=R5BdSBLcdM34a45EFlY1mo16mKvKHeF1lP9Vx+en0yQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213164; v=1; x=1794817964;
 b=c7ZQEn846anLKcyzh+/HxcKvLUA6xYOP24jyL/eJjTjeZX7KrKAQHH3uN5gvzE7g2Rbu8A05
 kbwFisq0r7ytJTZ8ZJQKGWc3hdmv9srq5En4kZkbHjNiqKzHtsE+ZdmZp1L9+LEOh3z0YJq6OA1
 l7bVRdnP14Pk9TeWciO+Ny28=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 889bac94e9d75174;
	Mon, 09 Nov 2026 08:32:44 +0000
X-Mizu-Trace-ID: 889bac94e9d75174
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
Subject: [PATCH 10/16] KVM: arm64: Advertise FPMR to protected VMs
Date: Mon,  9 Nov 2026 08:31:59 +0000
Message-ID: <20261109083205.806619-11-fuad.tabba@linux.dev>
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

Advertise FEAT_FPMR to protected VMs, and reset FPMR to 0 as KVM does
for a non-protected vCPU. With the field set, vcpu_set_hcrx() sets
HCRX_EL2.EnFPM for them, and FPMR is switched with the rest of the FP
state.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index bcc35d6990e67..a937aad009348 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -128,6 +128,7 @@ static const struct pvm_ftr_bits pvmid_aa64pfr1[] = {
 
 static const struct pvm_ftr_bits pvmid_aa64pfr2[] = {
 	MAX_FEAT(ID_AA64PFR2_EL1, GCIE, NI),
+	MAX_FEAT(ID_AA64PFR2_EL1, FPMR, IMP),
 	FEAT_END
 };
 
@@ -829,6 +830,7 @@ static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
 	RESET_UNKNOWN(TTBR1_EL1),
 	RESET_UNKNOWN(FAR_EL1),
 	RESET_VAL(VBAR_EL1, 0x1de7ec7edbadc000ULL),
+	RESET_ZERO(FPMR),
 };
 
 void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu)
-- 
2.47.3

