Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792914726;
	b=Is4IPpFdylJKcFn/VnWRx2/Cupws/nBZCc6BZjqiF+gVEgt2AhFrpCAl/s3CaZKpYkDS
	 xdK/1+tQ7PZV6p3/MkFMQT1vgsE4IFK539UfGyBozdFnn0PhrpaKnWbzp6b6vH98FjoSY
	 6YtsaEbMZoyM4+Fk/s4NJrFeYwYS9i1g7PyGQmibX1NwM3vGNuCg5iVykFuOK/KzRwWcA
	 0p9z+4zEARg/h9D69dl5TS7CVMPRBMIAUq8UpG5ZmPm+5Ld8bQBcTsKY+jHlsYce+vLot
	 Uu3i2gwbXBvWpOifWOI2VIVrkdSEmOdm1UupwLog1MvVtbcnRfKBB0OU1T1TyVpACAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792914726;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mhsArRboNOG7MEYGvuVxZAVzLd8DQVPPiwRvsOHZhfo=;
	b=4bl8G5d0+is88PUsMjowbJhCuARwgMQc8B91pLO7XXICbOLffXo5Hgt1/ZOApwOTAn/q
	 R6os9M5qGG6hyagbL8aRIMJ8qzmWesZeeKDWUO2YMwIGBFDoWeINKtNtvT2rd43dL81Li
	 iEq3EWUKdElfvnCy2X6HOhoriD3H9lNbUEFRbZie3XQuTAmsDjdAc1GLe7DZ3J4wTj0/f
	 EC/9dNYoHkNhV1MdOpYlmaDq6ofS79NS2fk78K3J+gSob0MLjmSbOjxNeaLhKrKJYeNTK
	 rRvds+CQgPXz4E9fKW/Kgw2ymTtTq7kFUb0qEumFlxIby8PH+HZGoHFDXyVyZbunvYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="b5c/+U/o";
	arc=none smtp.remote-ip=95.215.58.113
Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0EC606A31A
	for <kvmarm@lists.linux.dev>; Sun, 25 Oct 2026 07:52:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC0EC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=b5c/+U/o
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=LcQIPG/aqOFsoIK9+iuAeL5MlGsV4fSp77IzdGl2HiA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792914723; v=1; x=1793519523;
 b=b5c/+U/oukInby2nkiUQoMYepyq4030cqKpS9GEafPT+pwQ6eoNmi40N0/capxxiBri4BsMB
 q9bTxQDb0tGspFSpCCIBDh59QJ2rw2VVzVsoGhVSH33kqYCI71pI1XfVZGqPNf8xQCQHDuD6bk8
 6Eo+gD1bW7db4QBjSseU2L4A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 176e5694bb0be5f6;
	Sun, 25 Oct 2026 07:52:03 +0000
X-Mizu-Trace-ID: 176e5694bb0be5f6
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] KVM: arm64: Enable ST64BV0 for guests with FEAT_LS64_ACCDATA
Date: Sun, 25 Oct 2026 07:51:37 +0000
Message-ID: <20261025075138.2919734-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025075138.2919734-1-fuad.tabba@linux.dev>
References: <20261025075138.2919734-1-fuad.tabba@linux.dev>
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

Since commit 58ce78667a641 ("arm64: Add support for FEAT_{LS64,
LS64_V}"), a guest sees the host's ID_AA64ISAR1_EL1.LS64, but KVM only
enables the FEAT_LS64 and FEAT_LS64_V instructions in HCRX_EL2. On a
host with FEAT_LS64_ACCDATA, a guest's ST64BV0 therefore traps and hits
the WARN_ON_ONCE() in handle_other().

Set HCRX_EL2.EnAS0 when the guest has FEAT_LS64_ACCDATA, now that
ACCDATA_EL1 is context-switched.

Fixes: 58ce78667a641 ("arm64: Add support for FEAT_{LS64, LS64_V}")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a3c1928bdf743..d07f72082531c 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -712,6 +712,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
 
+		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnAS0;
+
 		/*
 		 * NV3 is a host-specific extension, and we always use
 		 * it when present and that the guest uses NV. It may
-- 
2.47.3

