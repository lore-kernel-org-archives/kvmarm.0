Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25742201278
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760118449; cv=none; b=I7GvjJEQ2uwl1tE/8PipgwTq0x2LHTnQ6HTWmbUS/ME0D+K3ubWIJblVn17epj8OzPfzrT/He5JkMjF0YyseA7ruz898gCiU9FVKzKO9fNFs8SVZ5wclALTRnE0kmdCXtSf1AtWxZZO4Kes+g86+vWV+56Qila3SP0O2lviWG4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760118449; c=relaxed/simple;
	bh=WT9PyBwFI3VQ0ncli3+MFYSVbkzPanNbmACAPQ+bRUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S+5vyciV4oeQM4psAqjJJeQo35iIeXDwOWYKvYnT+vP/3tsnTvzKM4dGQvPu0fxGWhJGVfFf074yEPXoFO9UM3zt4OTxy5cIqpS4iFBUnlRDuTFrltVCRX+s5zwNa2EzQ+i4bdSs5BZKCD9+72HDRtZSALBk+0segk99PL9etkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XfEYudEX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XfEYudEX"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59AFZqrk011259
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 17:47:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=FwPo3e7OvqTd1NWuZ8apR3AKltDtOQ12L7y
	93Bhadpo=; b=XfEYudEX0tV5K0sqZ6/EVFZfh3UQ07D1IgzeJ5ZDxqEvBTst/EX
	ywP00rfGYi/dfemfB75Pnlrj0QI+hbDy8jGfNXuwsiwKJNXddDze9qhGr2GfR68O
	+DX12cITSMPKRAQa3KBFu6ppaZFphRD4u1/JLDxAfjXFt8J4qX+rXHTP9nZ6cw26
	SBH6eWhnQFGfiGggjCEUEFsq9emlqkntU+J7bEyqJXH9SXyc53VrD7YVBxv8Oevw
	NG4zvShXumdzEeYTys24rqW2pNwO8Nt4wi6H4BW3cdt2ANbaIVgIjF74igEsMwT6
	QY5GHd+Rffgv9TaTqR3javpREgtTOq7W0+g==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49q4x1gc2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 17:47:25 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-269880a7bd9so57765055ad.3
        for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 10:47:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760118444; x=1760723244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FwPo3e7OvqTd1NWuZ8apR3AKltDtOQ12L7y93Bhadpo=;
        b=gEqj4LEQ1B7FmQnfxf2m1q+4/2iiL9jBo4O+oazNrq7YNXAZIqlXNe/HlWeeM8DJue
         Xvl3ib3M7yOxwUbAeC7lVjhiNmgtCDQXdO5/26qywG8Ckg9U3kMJo6PBIoDElbeEtmg+
         hVNPeD/M8227YgCjeDAO/m9HT4x62kNhygaeLj8ML15rWI1nXawWJIsptbyCHwGAQSoS
         t973IStFwMix10ZOQqW+i/zaiEq2ao3vUzwNPT0Wi6HPshHj/NOqTzELu0zNwryaWvGP
         wfPSY+NIXDdK1Q2Pj0s1ZzZg8ArGdPZQLi2ODO6jgtvRPoWB6xjbpT3bImccw6iFxjZL
         mO2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMbSdW9a7PJLsDA7HDZZkWTnmgtxM+8fwxcND4nShgvFP792t3wAVWjQD7ntNvy88lBdzpshk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbjaWELjah39k0u0xoOtX2E7C5WyN0gWj3+HRlR2amgtXrJDh4
	bqvpX4nou6YelbaNxdsWPBASmjv7uieK5vL+tHd22KIQur+6AxiAFxBpAjSuZkZuaqaJzMfO73Z
	QdYF0g3u4zBqd7re2hS6ovAP2GtHDWLaaZmerVqQg1B0LmUeznlJd48JhO+g=
X-Gm-Gg: ASbGncv+BVnTs4ipZvJW6XnqNbzgiO0kWHZK1m5cU/d9mtg/ceSTjuJioqshw3RnJ1U
	jJ/G1EyG9Em1GJL2nCL4YIij4qjB/MIBiAy8vowtcX9ig2VkbZ2+oBPfEzywW9lwKqedAzgnuAf
	RdgeV0rGF0pf8d36+cQcdovJIOfB4nXw24/a+T99ObJGh33Hdk3mbuJE3y1uriiSt5JC+CXWPHK
	MZCkoC3xRQYv37xjwT9le+dCK+Y94yeVLhLk3HhebKQzXy/Xw0NP2gcESdOdvc+cDdjvnBG84NA
	TvOz1mJ93iIQdR1IuxDGNwfgllbknGEU8OE8lBVjbo2MwuCqL2OG63904iJV0jvyxPs=
X-Received: by 2002:a17:902:e952:b0:27e:f018:d2fb with SMTP id d9443c01a7336-2902735667emr159110245ad.6.1760118444042;
        Fri, 10 Oct 2025 10:47:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyhIYzu2yvfjQTBTknIgm2OkThLL5tjUy3aIAha8LlsyWFfhUgj4W2Jq7D4Xj5QA9Zpu/bog==
X-Received: by 2002:a17:902:e952:b0:27e:f018:d2fb with SMTP id d9443c01a7336-2902735667emr159109855ad.6.1760118443498;
        Fri, 10 Oct 2025 10:47:23 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f4ad6esm62469435ad.109.2025.10.10.10.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 10:47:23 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Subject: [PATCH v2] KVM: arm64: Guard PMSCR_EL1 initialization with SPE presence check
Date: Fri, 10 Oct 2025 23:17:07 +0530
Message-ID: <20251010174707.1684200-1-mukesh.ojha@oss.qualcomm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: KzUlYIauEOC4nrWycd_49cP3FLavb_ea
X-Authority-Analysis: v=2.4 cv=N4gk1m9B c=1 sm=1 tr=0 ts=68e946ad cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=sZYUSTO7CAmMIKym-AcA:9
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEwMDA5MCBTYWx0ZWRfX8T1OOKJahlK2
 3S+coFYuADGvupGiZeWblQTACjI//rcAgzmRpDg82QVaaxBag1HrcRI2EmJa7HhrD1wJ+P3RkeV
 rvJNObzmRmWNmQb5GqcLvNKVlkbYerdeb6VRFAnxwELjyAMTBmd821gdTLwKtB7bg9fFab8Im2j
 diqN3H9TAKZLGxhEJYpwRRkONJPmx2cticBOWjzQKRM/3uX5UZMKe9/lR47UNzZhgubOmsYc1Me
 64zbHqf7BnAsQ8uriLPbqQPOPZWsancxzzmHMytqO93eEaYnihNfHpQ09jscXddAfv5TLDIAsBW
 emvNxn/Z2Kj6kaW/ph2HDTXqm2JHSp7o3JAKzHUxnSp22o5a7UFEJkHQoEPDnhihmRsBHOEXW+I
 4zOpFDBwEvf5lac8/s4tPTeL2oXHFA==
X-Proofpoint-ORIG-GUID: KzUlYIauEOC4nrWycd_49cP3FLavb_ea
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510100090

Commit efad60e46057 ("KVM: arm64: Initialize PMSCR_EL1 when in VHE")
does not perform sufficient check before initializing PMSCR_EL1 to 0
when running in VHE mode. On some platforms, this causes the system to
hang during boot, as EL3 has not delegated access to the Profiling
Buffer to the Non-secure world, nor does it reinject an UNDEF on sysreg
trap.

To avoid this issue, restrict the PMSCR_EL1 initialization to CPUs that
support Statistical Profiling Extension (FEAT_SPE) and have the
Profiling Buffer accessible in Non-secure EL1. This is determined via a
new helper `cpu_has_spe()` which checks both PMSVer and PMBIDR_EL1.P.

This ensures the initialization only affects CPUs where SPE is
implemented and usable, preventing boot failures on platforms where SPE
is not properly configured.

Fixes: efad60e46057 ("KVM: arm64: Initialize PMSCR_EL1 when in VHE")
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
Changes in v2:
- Reworded commit log
- Reused host_data_set_flag() and host_data_test_flag().

 arch/arm64/kvm/debug.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 3515a273eaa2..4406ab962ebd 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -15,6 +15,12 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
 
+static int cpu_has_spe(u64 dfr0)
+{
+	return cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
+	       !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P);
+}
+
 /**
  * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
  *
@@ -77,13 +83,12 @@ void kvm_init_host_debug_data(void)
 	*host_data_ptr(debug_brps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
 	*host_data_ptr(debug_wrps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);
 
+	if (cpu_has_spe(dfr0))
+		host_data_set_flag(HAS_SPE);
+
 	if (has_vhe())
 		return;
 
-	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
-	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
-		host_data_set_flag(HAS_SPE);
-
 	/* Check if we have BRBE implemented and available at the host */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_BRBE_SHIFT))
 		host_data_set_flag(HAS_BRBE);
@@ -101,8 +106,8 @@ void kvm_init_host_debug_data(void)
 
 void kvm_debug_init_vhe(void)
 {
-	/* Clear PMSCR_EL1.E{0,1}SPE which reset to UNKNOWN values. */
-	if (SYS_FIELD_GET(ID_AA64DFR0_EL1, PMSVer, read_sysreg(id_aa64dfr0_el1)))
+	if (host_data_test_flag(HAS_SPE))
+		/* Clear PMSCR_EL1.E{0,1}SPE which reset to UNKNOWN values. */
 		write_sysreg_el1(0, SYS_PMSCR);
 }
 
-- 
2.50.1

