Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9129C22FF4E
	for <kvmarm@lists.linux.dev>; Fri,  2 May 2025 09:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746177681; cv=none; b=hiRHxBV8FuGWBRrKav08godE81mVDOSFGsMGLA7xrt7/W5cDpBJ8e77jycDJUfXatGNOSOWRYPIdLUuf8UMqE2APRMyOh6pFOirVFUx2XdN9uaUf5hm1yapjq28xRBLY+JhvoZixaUeAYh4ESbT46pWQBaYXLb+qjInEglfllps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746177681; c=relaxed/simple;
	bh=z41DDBbJl4TIvbOFCLPOvC2bUtA8XyTHiBwdchWGrpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeIOn+MJ4LqrlAftGvKDxLQHPbRzIKRSAHQhtNzLijlc6kNFrcHrpJhT2JMh/Gd4arcNi+F6X0fMlSt3TuPLTK9+a+pZwBsO3nLp7wEJh/dGU9qkrZ4l/McoGb/0jewwL+oeNVF8yiJ0OD+L3sSnkhnN6Nfynh3isPM0AryyhVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b=FKbwnot2; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b="FKbwnot2"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e732386e4b7so1719850276.1
        for <kvmarm@lists.linux.dev>; Fri, 02 May 2025 02:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20230601.gappssmtp.com; s=20230601; t=1746177678; x=1746782478; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyHCon4vU91wPH4dyinNdOyq5hW82Gz0ZN1lgTbU0wg=;
        b=FKbwnot2biayZ4oIUjFOPTalayoOnj8j3wRXb4J7jBRuSfPXNZHLY5kw6iR+Om7tiY
         evX3Ko609CVDdAT47kRfNmJgp32GQRPDWHXqwu8zHqBCpTdyem5eBfJc6Qbz5bYONawQ
         uR/HEMj5I+ThSq+W6odNyn7sglcfb2qTZNWfA+Uv9FXImeRkCbG1kqA1DsceFH7fXs2q
         o8TxWvWvT/ZHW0tM/yxsdm2IRRCY+5Je/IlF3Jb3PPAYBHLjHJo4Xc740Y1r83vFf6+6
         KeISzbyYu4D50oVNLKh6XOqGnsehlL7qkVp0fi0N0Lar3Kmiua4PB3iSNhqBJ+3fknlE
         G9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746177678; x=1746782478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jyHCon4vU91wPH4dyinNdOyq5hW82Gz0ZN1lgTbU0wg=;
        b=cvv/qNeDRxH7mznDD1EdZfVOnnsZJur49LcbKaUbbsiFSkDFNoAbhIcena3Ewbuzfp
         Dq78FDurEK1jurQCJRJaxce7teOdL/Gwu+zoCKSiA/lwqrH1H7cpAoPqtKyHRRw3WHkT
         q4o2bwi/rtmX+YaioMmAqbBBHQbOktEU+chCLOiggA5/IcH612aAkYtKjiLfH+XAKvD1
         CDAABEdcRCeA0hiDQ6uvbVucF27YMn2j16LXcQZaszYMbyNCRzswt3B7ZqQ1MYOv3+3K
         CPJvTIsBb/SarpOdnWvD1OBvaN7gPXZ4KPbd57hZw6xZ59pIFmceILRfqIDoIT3jfwVH
         8hbA==
X-Forwarded-Encrypted: i=1; AJvYcCUbDIMm2T+npKGIrs+ssvfQF2T+i2ndqA1FwQjUThubtSwmko2KcYA1hZt8Pgk0h03Sz5DOWV4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDzCohtddYta+5YAkPcZcHLjja8aFQrm9fJtYnBHRAGFF1XoKr
	RWMxwQ1Kv3Zu7jmcGEgCcbVylSYKIfRGwqfaAnvAzGvprj90b0VA/mx11Bqnd6Q=
X-Gm-Gg: ASbGncvxLAN2sngJjPlSptrEZ0x9O2sfoHxBy8X8vNGRk72xn9pJPvV1HITAnUW5jez
	fWW4bMlHqMPj/cn7RTusQMuBH/WciWJIGSUJZU7nufNPnKFTYPSLj/ZjtkOqqx1lF2m3e0OcRZJ
	8oen/dVDCaYytwTIgZWhhJIwWdVgFk705LUJHLuzwSqF5COpc2yJtp1wELuuFeZtX77KRnkLkKp
	L2c2b7sEDn5UFUtis/XOFFrGxyZ0fLjo2YmpINNZ1A955tyJxLthcAET2qk4hTimGx9Ah1CYPM+
	V+/NyjXN7gXYme0PoquMKYPfFRVVPxEmwhTRRB3eTg==
X-Google-Smtp-Source: AGHT+IGp+ETgvJSd9lvf2Hm0u8cGNqnSHJMy0WS2lG3WhWOOaG2gaDXYIeZ4OWRo041mgp+lOQesMg==
X-Received: by 2002:a05:6902:1885:b0:e72:a584:bea0 with SMTP id 3f1490d57ef6-e756556fef7mr2617975276.21.1746177678568;
        Fri, 02 May 2025 02:21:18 -0700 (PDT)
Received: from donna.immunant.com ([12.9.190.3])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e755e7d92d0sm556427276.55.2025.05.02.02.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 02:21:18 -0700 (PDT)
From: Per Larsen <perl@immunant.com>
To: linux-kernel@vger.kernel.org
Cc: sebastianene@google.com,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	jean-philippe@linaro.org,
	kernel-team@android.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	lpieralisi@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	qperret@google.com,
	qwandor@google.com,
	sudeep.holla@arm.com,
	suzuki.poulose@arm.com,
	tabba@google.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	armellel@google.com,
	arve@android.com,
	ahomescu@google.com,
	Per Larsen <perlarsen@google.com>,
	Per Larsen <perl@immunant.com>
Subject: [PATCH 3/3] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler
Date: Fri,  2 May 2025 02:21:08 -0700
Message-ID: <20250502092108.3224341-4-perl@immunant.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250502092108.3224341-1-perl@immunant.com>
References: <20250502092108.3224341-1-perl@immunant.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Per Larsen <perlarsen@google.com>

FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions except that it
uses the SMC calling convention v1.2 which allows calls to use x4-x17 as
argument and return registers. Add support for FFA_MSG_SEND_DIRECT_REQ2
in the host ffa handler.

Signed-off-by: Per Larsen <perlarsen@google.com>
Signed-off-by: Per Larsen <perl@immunant.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 111 +++++++++++++++++++++++++++++++++-
 include/linux/arm_ffa.h       |   2 +
 2 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 8102dd6a19f7..d8c066f3c5c9 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -79,6 +79,14 @@ static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 	};
 }
 
+static void ffa_to_smccc_1_2_error(struct arm_smccc_1_2_regs *regs, u64 ffa_errno)
+{
+	*regs = (struct arm_smccc_1_2_regs) {
+		.a0	= FFA_ERROR,
+		.a2	= ffa_errno,
+	};
+}
+
 static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
 {
 	if (ret == FFA_RET_SUCCESS) {
@@ -89,11 +97,26 @@ static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
 	}
 }
 
+static void ffa_to_smccc_1_2_regs_prop(struct arm_smccc_1_2_regs *regs, int ret, u64 prop)
+{
+	if (ret == FFA_RET_SUCCESS) {
+		*regs = (struct arm_smccc_1_2_regs) { .a0 = FFA_SUCCESS,
+						.a2 = prop };
+	} else {
+		ffa_to_smccc_1_2_error(regs, ret);
+	}
+}
+
 static void ffa_to_smccc_res(struct arm_smccc_res *res, int ret)
 {
 	ffa_to_smccc_res_prop(res, ret, 0);
 }
 
+static void ffa_to_smccc_1_2_regs(struct arm_smccc_1_2_regs *regs, int ret)
+{
+	ffa_to_smccc_1_2_regs_prop(regs, ret, 0);
+}
+
 static void ffa_set_retval(u64 func_id,
 			   struct kvm_cpu_context *ctxt,
 			   struct arm_smccc_res *res)
@@ -127,6 +150,29 @@ static void ffa_set_retval(u64 func_id,
 	}
 }
 
+static void ffa_set_retval_smccc_1_2(struct kvm_cpu_context *ctxt,
+			   struct arm_smccc_1_2_regs *regs)
+{
+	cpu_reg(ctxt, 0) = regs->a0;
+	cpu_reg(ctxt, 1) = regs->a1;
+	cpu_reg(ctxt, 2) = regs->a2;
+	cpu_reg(ctxt, 3) = regs->a3;
+	cpu_reg(ctxt, 4) = regs->a4;
+	cpu_reg(ctxt, 5) = regs->a5;
+	cpu_reg(ctxt, 6) = regs->a6;
+	cpu_reg(ctxt, 7) = regs->a7;
+	cpu_reg(ctxt, 8) = regs->a8;
+	cpu_reg(ctxt, 9) = regs->a9;
+	cpu_reg(ctxt, 10) = regs->a10;
+	cpu_reg(ctxt, 11) = regs->a11;
+	cpu_reg(ctxt, 12) = regs->a12;
+	cpu_reg(ctxt, 13) = regs->a13;
+	cpu_reg(ctxt, 14) = regs->a14;
+	cpu_reg(ctxt, 15) = regs->a15;
+	cpu_reg(ctxt, 16) = regs->a16;
+	cpu_reg(ctxt, 17) = regs->a17;
+}
+
 /* Call SMC64 using SMCCC 1.2 if hyp negotiated FF-A 1.2 falling back to 1.1 */
 static void arm_smccc_1_2_smc_fallback(u64 func_id, u64 a1, u64 a2, u64 a3,
 				       u64 a4, u64 a5, u64 a6, u64 a7,
@@ -681,7 +727,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Unimplemented interfaces added in FF-A 1.2 */
-	case FFA_MSG_SEND_DIRECT_REQ2:
 
 	/*
 	 * FFA_MSG_SEND_DIRECT_RESP2 is not meant to be invoked by the host or
@@ -709,6 +754,20 @@ static bool ffa_call_supported(u64 func_id)
 	return true;
 }
 
+/*
+ * Must a given FFA function use the SMC calling convention v1.2?
+ */
+static bool ffa_call_needs_smccc_1_2(u64 func_id)
+{
+	switch (func_id) {
+	case FFA_MSG_SEND_DIRECT_REQ2:
+	case FFA_MSG_SEND_DIRECT_RESP2:
+		return true;
+	}
+
+	return false;
+}
+
 static bool do_ffa_features(struct arm_smccc_res *res,
 			    struct kvm_cpu_context *ctxt)
 {
@@ -882,9 +941,47 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_direct_msg2(struct arm_smccc_1_2_regs *regs,
+			      struct kvm_cpu_context *ctxt,
+			      u64 vm_handle)
+{
+	DECLARE_REG(u32, func_id, ctxt, 0);
+	DECLARE_REG(u32, endp, ctxt, 1);
+	DECLARE_REG(u64, uuid_lo, ctxt, 2);
+	DECLARE_REG(u64, uuid_hi, ctxt, 3);
+	DECLARE_REG(u64, x4, ctxt, 4);
+	DECLARE_REG(u64, x5, ctxt, 5);
+	DECLARE_REG(u64, x6, ctxt, 6);
+	DECLARE_REG(u64, x7, ctxt, 7);
+	DECLARE_REG(u64, x8, ctxt, 8);
+	DECLARE_REG(u64, x9, ctxt, 9);
+	DECLARE_REG(u64, x10, ctxt, 10);
+	DECLARE_REG(u64, x11, ctxt, 11);
+	DECLARE_REG(u64, x12, ctxt, 12);
+	DECLARE_REG(u64, x13, ctxt, 13);
+	DECLARE_REG(u64, x14, ctxt, 14);
+	DECLARE_REG(u64, x15, ctxt, 15);
+	DECLARE_REG(u64, x16, ctxt, 16);
+	DECLARE_REG(u64, x17, ctxt, 17);
+
+	if (FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) != vm_handle) {
+		ffa_to_smccc_1_2_regs(regs, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	struct arm_smccc_1_2_regs args = {
+		func_id, endp, uuid_lo, uuid_hi,
+		 x4,  x5,  x6,  x7,  x8,  x9, x10,
+		x11, x12, x13, x14, x15, x16, x17
+	};
+
+	arm_smccc_1_2_smc(&args, regs);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_res res;
+	struct arm_smccc_1_2_regs regs;
 
 	/*
 	 * There's no way we can tell what a non-standard SMC call might
@@ -940,14 +1037,24 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MSG_SEND_DIRECT_REQ2:
+		if (hyp_ffa_version >= FFA_VERSION_1_2) {
+			do_ffa_direct_msg2(&regs, host_ctxt, HOST_FFA_ID);
+			goto out_handled;
+		}
+		goto out_not_supported;
 	}
 
 	if (ffa_call_supported(func_id))
 		return false; /* Pass through */
 
+out_not_supported:
 	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
 out_handled:
-	ffa_set_retval(func_id, host_ctxt, &res);
+	if (ffa_call_needs_smccc_1_2(func_id))
+		ffa_set_retval_smccc_1_2(host_ctxt, &regs);
+	else
+		ffa_set_retval(func_id, host_ctxt, &res);
 	return true;
 }
 
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 5bded24dc24f..4d541cf12ceb 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -268,6 +268,8 @@ bool ffa_partition_check_property(struct ffa_device *dev, u32 property)
 	(ffa_partition_check_property(dev, FFA_PARTITION_DIRECT_REQ2_RECV) && \
 	 !dev->mode_32bit)
 
+#define FFA_SRC_ENDPOINT_MASK	GENMASK(31, 16)
+
 /* For use with FFA_MSG_SEND_DIRECT_{REQ,RESP} which pass data via registers */
 struct ffa_send_direct_data {
 	unsigned long data0; /* w3/x3 */
-- 
2.49.0

