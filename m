Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B3438E5DC;
	Thu, 15 Oct 2026 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792085781; cv=none; b=G+lFtAfZzB6W/ZEmd6vAG/1R1dOnTPGsTXicZHGwTq004EB3o1Y7tMoLLoB9/Ss2uirKUA9HR7nAu2AA9VdEvTwQycONywwmfKrRT5EImGCeD57sxVOwd2toA6w1vZiXNNjfSyIQxaaI5+adPlsSUVPSmB98WCC4e1YPliAIIK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792085781; c=relaxed/simple;
	bh=FId31myukI9rkgPRxKwL3r5OWujL5NpvnFFnvItoW/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pknDdGSX9yszjHeTiBZrtVeEH3yLYFjbiQ0hd/ITIf/AasJemyey3QzvRp1ligI9/zRGhJFFu/BIxsmKxw/GUeafaX3XpNsZm3okZ60x2SzJp8H5oX1zfTSZdeknLucTRzJexZv9T4nHlfJdc4kiUudhpp83g5XgSUwePi97sJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pt32eBpp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pt32eBpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A511F000C7;
	Thu, 15 Oct 2026 17:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792085770;
	bh=NgkYS8W41TWW7Qh0J3Gb/1uoJw3SePkNINmDDJhIeDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pt32eBppSHO6O9Iy1mACmhSAlKzeXbofrCsUOXjNg/gh4ODe7GqKWzJja3HR7vsq+
	 7zynSzC23ux0/u8xH62WLLzyXMaBRlgrpOQ5wVdb36/E16s6Q0sU3dPa8k6/auKGIF
	 KLy3yUbuJLH1KJ63YW/v8oSShmfQDFmzfm5PcmSbiIlmjZ1swlPxjCAgukF6JGTwL8
	 Dh91H2Jw43IuY06Lp4lU/oJm0fmUXcq9XR5rePgr82iwY6Ax0wMc2Oxl6xeibh+i1l
	 suCQWseSg+/onCLEE15szp9FM4UV2MCh+7cd+5H7AQw2wKGRM9VgUV1juWgr/KpTlw
	 x6NlHVzY2lhlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xHPNA-00000003Q3a-2Q87;
	Thu, 15 Oct 2026 17:36:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: Get rid of compatibility HCR_EL2 aliases
Date: Thu, 15 Oct 2026 18:36:05 +0100
Message-ID: <20261015173605.1072963-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015173605.1072963-1-maz@kernel.org>
References: <20261015173605.1072963-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we dropped out reliance on the old HCR_EL2 aliases, do the
right thing and purge the kernel of the compatibility definitions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 65 --------------------------------
 1 file changed, 65 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b78e5ce08905b..ae2dafd21cb7c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -14,71 +14,6 @@
 #include <asm/esr.h>
 #include <asm/sysreg.h>
 
-/*
- * Because I'm terribly lazy and that repainting the whole of the KVM
- * code with the proper names is a pain, use a helper to map the names
- * inherited from AArch32 with the new fancy nomenclature. One day...
- */
-#define	__HCR(x)	HCR_EL2_##x
-
-#define HCR_TID5	__HCR(TID5)
-#define HCR_DCT		__HCR(DCT)
-#define HCR_ATA_SHIFT	__HCR(ATA_SHIFT)
-#define HCR_ATA		__HCR(ATA)
-#define HCR_TTLBOS	__HCR(TTLBOS)
-#define HCR_TTLBIS	__HCR(TTLBIS)
-#define HCR_ENSCXT	__HCR(EnSCXT)
-#define HCR_TOCU	__HCR(TOCU)
-#define HCR_AMVOFFEN	__HCR(AMVOFFEN)
-#define HCR_TICAB	__HCR(TICAB)
-#define HCR_TID4	__HCR(TID4)
-#define HCR_FIEN	__HCR(FIEN)
-#define HCR_FWB		__HCR(FWB)
-#define HCR_NV2		__HCR(NV2)
-#define HCR_AT		__HCR(AT)
-#define HCR_NV1		__HCR(NV1)
-#define HCR_NV		__HCR(NV)
-#define HCR_API		__HCR(API)
-#define HCR_APK		__HCR(APK)
-#define HCR_TEA		__HCR(TEA)
-#define HCR_TERR	__HCR(TERR)
-#define HCR_TLOR	__HCR(TLOR)
-#define HCR_E2H		__HCR(E2H)
-#define HCR_ID		__HCR(ID)
-#define HCR_CD		__HCR(CD)
-#define HCR_RW		__HCR(RW)
-#define HCR_TRVM	__HCR(TRVM)
-#define HCR_HCD		__HCR(HCD)
-#define HCR_TDZ		__HCR(TDZ)
-#define HCR_TGE		__HCR(TGE)
-#define HCR_TVM		__HCR(TVM)
-#define HCR_TTLB	__HCR(TTLB)
-#define HCR_TPU		__HCR(TPU)
-#define HCR_TPC		__HCR(TPCP)
-#define HCR_TSW		__HCR(TSW)
-#define HCR_TACR	__HCR(TACR)
-#define HCR_TIDCP	__HCR(TIDCP)
-#define HCR_TSC		__HCR(TSC)
-#define HCR_TID3	__HCR(TID3)
-#define HCR_TID2	__HCR(TID2)
-#define HCR_TID1	__HCR(TID1)
-#define HCR_TID0	__HCR(TID0)
-#define HCR_TWE		__HCR(TWE)
-#define HCR_TWI		__HCR(TWI)
-#define HCR_DC		__HCR(DC)
-#define HCR_BSU		__HCR(BSU)
-#define HCR_BSU_IS	__HCR(BSU_IS)
-#define HCR_FB		__HCR(FB)
-#define HCR_VSE		__HCR(VSE)
-#define HCR_VI		__HCR(VI)
-#define HCR_VF		__HCR(VF)
-#define HCR_AMO		__HCR(AMO)
-#define HCR_IMO		__HCR(IMO)
-#define HCR_FMO		__HCR(FMO)
-#define HCR_PTW		__HCR(PTW)
-#define HCR_SWIO	__HCR(SWIO)
-#define HCR_VM		__HCR(VM)
-
 /*
  * The bits we set in HCR:
  * TLOR:	Trap LORegion register accesses
-- 
2.47.3

