Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A559F101C7
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 11:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A476C433C7;
	Tue,  8 Aug 2023 11:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691495285;
	bh=wPhod5Peg0BcU9eGJCAQdNgMOfMqpCFVOnHFnmu3guw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qt/4tmIzBPy0tPh29h8gQ6/umtxHfxo1i99WPzQJrl1oAeCALla7dj51jvm9L12A9
	 xowndrPa1lQyux+zJhKN9FAnM+aLWqWRQVPWYej4MMPxSGy1mtoQQfnAbljwT105d9
	 hm2zx9YcEvhSunzkH48RcmjCEbRJARHgjW89IImeDH9ZLFb9nRh//l3/M5Ikiu61Z2
	 6ALgIChbSEDflQVm01SZcP0aP8eM4ExrnXm/KUkGWDDoxTf+2t7wmrE7eCQW0C1OzX
	 mSvUuBxjACr3kb6uMmeZff6CWY64A7YuEEYJWEDisEGGLKDic2UbOxfJ7S83edbS9f
	 +aTyDz850LQng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qTLBG-0037Ph-Aw;
	Tue, 08 Aug 2023 12:47:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 11/27] KVM: arm64: Add missing HCR_EL2 trap bits
Date: Tue,  8 Aug 2023 12:46:55 +0100
Message-Id: <20230808114711.2013842-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808114711.2013842-1-maz@kernel.org>
References: <20230808114711.2013842-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We're still missing a handfull of HCR_EL2 trap bits. Add them.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
---
 arch/arm64/include/asm/kvm_arm.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 58e5eb27da68..028049b147df 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -18,10 +18,19 @@
 #define HCR_DCT		(UL(1) << 57)
 #define HCR_ATA_SHIFT	56
 #define HCR_ATA		(UL(1) << HCR_ATA_SHIFT)
+#define HCR_TTLBOS	(UL(1) << 55)
+#define HCR_TTLBIS	(UL(1) << 54)
+#define HCR_ENSCXT	(UL(1) << 53)
+#define HCR_TOCU	(UL(1) << 52)
 #define HCR_AMVOFFEN	(UL(1) << 51)
+#define HCR_TICAB	(UL(1) << 50)
 #define HCR_TID4	(UL(1) << 49)
 #define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
+#define HCR_NV2		(UL(1) << 45)
+#define HCR_AT		(UL(1) << 44)
+#define HCR_NV1		(UL(1) << 43)
+#define HCR_NV		(UL(1) << 42)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
 #define HCR_TEA		(UL(1) << 37)
-- 
2.34.1

