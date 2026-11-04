Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782141;
	b=xMcQV9eFpz6Dsf3ESoIDHU6Digs+YD9U9srEYoxmCUum4ijQVe4uafKxRmLk71leT0Jm
	 ODNlZupt4Zh/6FMKbDaS05nPgCEdooce35F3PdS57oPqw1YpCtaAcxa87qID4S1FasyCM
	 P/8sVh2+d19qr3W+TqzNHQ6Mtq0q4RkNoLgglVXbdsj8gc4G0oNsq7PwU+0fafOaaoa2Y
	 DMCrjmmH/LA61n2UASZPRYTWN1TqCF6hYimxDd5/7ZVaJW+m0Z9bdNxbzu+uQ/8joPPpl
	 is53OIMVi9X/VjlqmhUyG+r1r0OgccYjnxf73UhtbjLJo/HKtjIyUdSTnkEjsdkG57Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782141;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Wgtb9kfhJDQT6OIlDEFANW5PARd8orgbcoPjl6TcZEI=;
	b=Y55gC0MabKZ7lXJY3ye2qAZfEy4TB2sS0vMCcHA97icBbaQ1OWnfsRBQNmjRS57lnPfq
	 Ynbb5i3UPOs/nbqvdnD2GCJgbQ0P9LJDxOp8g8GrablGd2stfDLIhWYnq7iC2/Zb1LgFI
	 qS2rTq/zbJaw2zKDyx3BW97KeFXB8qTFWaG32wRLqUd2MSdK8U2bATt/tTZWTyYbSHsQz
	 eZd6WB0h4TOxWJZqWX//AUETNsvbfRDjpkh/GukpXRRcY1OgcnA+fkg5N7G3vtKyJV4nr
	 MKtXU89+mocvqwTfIWwoRX0IVIuI0cfBrPGnuC6PqWofM9pCVh9MMbCxhHigtqjwoBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q0lFkMvJ;
	arc=none smtp.remote-ip=91.218.175.227
Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FC9606A332
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 08:49:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5FC9606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q0lFkMvJ
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=zy9OoZoEVLZKrHt/PA6PNvYObGqJuDPk1PHvlEStbBI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793782139; v=1; x=1794386939;
 b=q0lFkMvJ6aldS90vGPX8Tae1McejmsXzlrjf3IcLe1lPgX422iXCunXCI26VYMDPQOUR5Gh4
 rtcfT+rB+0SYffDNWlwahAWRYclzDTmXBA3zmFch3OLEhvvydC9wnrXaHsReMK6v68tqB6f8s4A
 Jlz53TVC+NpFkWmEieQcwVl8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id adf1661c24975b7e;
	Wed, 04 Nov 2026 08:48:59 +0000
X-Mizu-Trace-ID: adf1661c24975b7e
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] tools: arm-smccc: Add the pKVM memory sharing function IDs
Date: Wed,  4 Nov 2026 08:48:29 +0000
Message-ID: <20261104084842.132944-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104084842.132944-1-fuad.tabba@linux.dev>
References: <20261104084842.132944-1-fuad.tabba@linux.dev>
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

The tools copy of arm-smccc.h lacks the pKVM guest hypercalls that the
protected-VM selftests make.

The kernel's arm-smccc.h defines the vendor-hyp UID with UUID_INIT(),
which requires linux/uuid.h, and tools doesn't have one. So rather than
sync the whole header, copy the function numbers and IDs of HYP_MEMINFO,
MEM_SHARE and MEM_UNSHARE from include/linux/arm-smccc.h.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/include/linux/arm-smccc.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/include/linux/arm-smccc.h b/tools/include/linux/arm-smccc.h
index 63ce9bebccd32..8c8f4ad639018 100644
--- a/tools/include/linux/arm-smccc.h
+++ b/tools/include/linux/arm-smccc.h
@@ -111,6 +111,10 @@
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
+/* Start of pKVM hypercall range */
+#define ARM_SMCCC_KVM_FUNC_HYP_MEMINFO		2
+#define ARM_SMCCC_KVM_FUNC_MEM_SHARE		3
+#define ARM_SMCCC_KVM_FUNC_MEM_UNSHARE		4
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -133,6 +137,24 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_PTP)
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_HYP_MEMINFO)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MEM_SHARE)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MEM_UNSHARE)
+
 /* ptp_kvm counter type ID */
 #define KVM_PTP_VIRT_COUNTER			0
 #define KVM_PTP_PHYS_COUNTER			1
-- 
2.47.3

