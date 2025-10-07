Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F3745C0B
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 18:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759861452; cv=none; b=eBCOk9QlwprfeHUM4zHgIHtokQ40+sTQkNjSFq7E/HbBmbjFBgM+r7OXm6v3bYr0ylkpU3u9Cx/5z0XqqTNqfsps8+E9hEvemEqjGjnVyYr3JtHTV6RAe8Zynv5zVbKbHWf5vxJFlcPt0fHeUz9FR+N6y1r7gi1INYnGBXjvEhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759861452; c=relaxed/simple;
	bh=PhbegbaMd1qZ+6ZHuLSkaTFKK0U2ZhDS1zI+8IlM3Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rorjwQvxnN5Dn+Xc5s+AmvKmD1IY+Lvkjgnh5PvFh+uTRKDq9AbJgMIf5qxjXHekqFX36pUP3QstJuw4X48D/FXOQjMn23fT0QBc1UTjw0P8N8vgk4cG5bTNY6vSUn6DZzTr/zHw9hemcgOMm3pWArJ4ntzFV2vn34n8fp6LkJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ppVZ6P77; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ppVZ6P77"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 597ETAnh029443
	for <kvmarm@lists.linux.dev>; Tue, 7 Oct 2025 18:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=v7gi3ANU7eGwAeHBm/VtX/N+PelGRzkkDBF
	dO15qWFo=; b=ppVZ6P77exkgaA75jAnjZYSEF5MqFITHrr/PWEI9ACIezmyMyj2
	zzjWpb+VMMlCzE61/Ivf19Se0guYAjqfSXdHQUqHExV4ARrYGTTycIOUb/mTXOn5
	Le9STcQ4pBVMOswJHRWT+/lsXFFFaUawGwvVtMjK9V53Ts3auymk/8uhPTJJgceJ
	dLY1cGAxxFi3tPeY4T42WLt5Sxb8aTVwSjzmzum1QbvBDc/LDGLRoqOzKifA39gq
	1UBpT7jTzM7qnqf85J3yhXKpslYElC0KMqWKykH75AFE8PT556xP77pyCCWXdQ3Y
	QMEhu3mZ27ahxtEA0OACVb6GDZc9N12eAgQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49mnkpu2nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 18:24:09 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2681623f927so59541915ad.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 11:24:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759861448; x=1760466248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v7gi3ANU7eGwAeHBm/VtX/N+PelGRzkkDBFdO15qWFo=;
        b=XlybZtzVdXAoObaruFCUB1yVYKSmI85ZCMI0ts/Pg6FyllGmo1cJGN8ebsuyNv+kn/
         ECtBtEtAEcEbWe0blALdKJXozHKrWFT5fxHluxeBE+sT6gdU/dlzHCvjcBLi7jRSJsLY
         6G9cZH+YGfwnHru8q78Wpss3sFSwd6PdzrpFDknPah56gWsDjKE7O9wvEQNqnAbE19+P
         ogSxfyju9OvbhHEew8EtbYlrofUJTYQJW8VZN+rf3lAxBxlITrDiD4mBM3AqkY9vIgM5
         pnAGWG+dEIkU6YLR4Qm6vHQ5SZYiHdctt7e8qyBUuS8yH6QMj2DwUxji5ii6LB19Dd+U
         3CqA==
X-Forwarded-Encrypted: i=1; AJvYcCX0jxilRCANaVQI2oFpmy7QCLVCMDuWYHQthx1j/xy7w6wZSf5V/vRfutP94BKoA5NhSQcHluE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxfns9ExU5cRDTimUOCmMlm5qUnsqy4eS4dYNzKXM/XSUYLICl4
	VeilqS1h9yqnzy/x+1ZJniz/CYdLuIAOLfl21eY4Vjwd4HcHU81GB8YlkVUZhtrVR+Rn/5J/b8E
	IGDX5WKovdpxLai+5yPg6SW+01mSqsuAJ9ikdU7oXHr2qvMub1J+xCsQD1C4=
X-Gm-Gg: ASbGncvQxGPEaPIx8NEqZ0BxgAlbWj80BdT1OsuGk38KgY7IOiOMhslEh5EUhEV4ksG
	OC4L6RVE2JfMfaNr9lpm2DG0IE2hkRDBUK2aQQYN70MFY08V6VyDjLCWhd5wLrhQgEGhizVhTYB
	JpjDupr84apek4+6zTgxRKWe9780EtNXFTITYBD00jUijGfWc0IOjPEEXmra5Ga/7U0SJgGH9+I
	XbzTV+PDI+gIJFTfn5cD/entQyxD3MyZQS3MaRRQn+LgAgLUHCtKp7kDDCuQPVmFDJLJPyziawB
	SFZPVMCPPxpKy+aW/90s5NJiwmYMS8dXQ++E9ZrPcs389yKLmnl/vvBReN5QcpN28oJW5DKC
X-Received: by 2002:a17:903:90d:b0:27e:d7a4:cd32 with SMTP id d9443c01a7336-290272ff5a5mr8818985ad.57.1759861448173;
        Tue, 07 Oct 2025 11:24:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHk+kGnyBGf3KfhdZk/5b6XJ+HDJE6ygty3ucqB0kfKr1z7QKyevL86q3VUXkPE7iIuJxra0Q==
X-Received: by 2002:a17:903:90d:b0:27e:d7a4:cd32 with SMTP id d9443c01a7336-290272ff5a5mr8818625ad.57.1759861447505;
        Tue, 07 Oct 2025 11:24:07 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1ba25asm172984505ad.87.2025.10.07.11.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 11:24:07 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
        will@kernel.org
Cc: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Subject: [PATCH] KVM: arm64: Check cpu_has_spe() before initializing PMSCR_EL1 in VHE
Date: Tue,  7 Oct 2025 23:53:56 +0530
Message-ID: <20251007182356.2813920-1-mukesh.ojha@oss.qualcomm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: DdiL7lspjl86jwvAdTo2EM3Qhol6tu31
X-Proofpoint-ORIG-GUID: DdiL7lspjl86jwvAdTo2EM3Qhol6tu31
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDE2OCBTYWx0ZWRfXzVJBidGibu9y
 FLCy62CaBrE41D7SnA83yaNYtqP47YCRHmzDyyk+69WnOOb5bxCHjWMBO7TxWMF0cxyFDMitS/a
 M0aVo6UCQCNsgtrDCTmgphrCxl4BmPKgzeNk4TaLeudKcinMz8+ML9A8GAnkiR6WCan0JnP/9HE
 q38pbVsjeMA/mebTkqCuocjzfZZeTVecsgpzb2YjXdW7HZP1KYL+68upMhuGucgd3cnBQ86sCCL
 uYg6mmYxVh3pMbLa4wdEA3qhzKsabRM6FfLbCV5XXgHAGpqJNcPBl0BEsrig4C76kv07eGtyMeX
 v8Uj5HwspvySAW13Agyt01LY4CUBkMx2AeGlgSRN+5tcWSlR6JK8pLZ5ftQHC6gYeeL93zbubyR
 TRQgJZcfv1XyhPqgwCNcoNgux6iiBA==
X-Authority-Analysis: v=2.4 cv=BuCQAIX5 c=1 sm=1 tr=0 ts=68e55ac9 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=YElTaCpYnbo2m2hzBnMA:9
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510060168

commit efad60e46057 ("KVM: arm64: Initialize PMSCR_EL1 when in VHE")
initializes PMSCR_EL1 to 0 which is making the boot up stuck when KVM
runs in VHE mode and reverting the change is fixing the issue.

[    2.967447] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.974061] PCI: CLS 0 bytes, default 64
[    2.978171] Unpacking initramfs...
[    2.982889] kvm [1]: nv: 568 coarse grained trap handlers
[    2.988573] kvm [1]: IPA Size Limit: 40 bits

Lets guard the change with cpu_has_spe() check so that it only affects
the cpu which has SPE feature supported.

Fixes: efad60e46057 ("KVM: arm64: Initialize PMSCR_EL1 when in VHE")
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 arch/arm64/kvm/debug.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 3515a273eaa2..d9fd45f0db9a 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -15,6 +15,14 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
 
+static int cpu_has_spe(void)
+{
+	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
+
+	return cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
+	       !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P);
+}
+
 /**
  * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
  *
@@ -80,8 +88,7 @@ void kvm_init_host_debug_data(void)
 	if (has_vhe())
 		return;
 
-	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
-	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
+	if (cpu_has_spe())
 		host_data_set_flag(HAS_SPE);
 
 	/* Check if we have BRBE implemented and available at the host */
@@ -101,8 +108,8 @@ void kvm_init_host_debug_data(void)
 
 void kvm_debug_init_vhe(void)
 {
-	/* Clear PMSCR_EL1.E{0,1}SPE which reset to UNKNOWN values. */
-	if (SYS_FIELD_GET(ID_AA64DFR0_EL1, PMSVer, read_sysreg(id_aa64dfr0_el1)))
+	if (cpu_has_spe())
+		/* Clear PMSCR_EL1.E{0,1}SPE which reset to UNKNOWN values. */
 		write_sysreg_el1(0, SYS_PMSCR);
 }
 
-- 
2.50.1

