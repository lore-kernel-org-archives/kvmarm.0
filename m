Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1542A1C1F0D
	for <kvmarm@lists.linux.dev>; Tue,  2 Sep 2025 03:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756784915; cv=none; b=p1hk1+LLY9TeuxYRpKmXTfe0qC+oDriT76XF2Gk/H/Z0eUCy3/SDv3q1EXx4j3LhSXXOvyF84K6/5Ka1gC1LCikdWNEFRYGee7x2VpqVl3YSo8CJmiCLLsml1SPSutf84lWFRzTXocsOu4iUcoauxAdvBuPeDfgxvZYNwti9bLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756784915; c=relaxed/simple;
	bh=pomve51ySnfeym3a5NacsGQMLiUMbbW2nqwOtU9Q3SM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=MhU5JvvRr/fpwiw61+7bpYv+kjmcZvn8tjRkTZXhI/k331L9zSJNNpBUQJJvk6NnCgt0uGqZM3G5gV3l30L8/YTRByGo7Z0mPOMoq6JFMkTfG3hkEYqJ5VSTcXjeBIYEvVbY45TKXtV0qT7DH66JeXxJpqKfhf/IZ5/+nhL4zz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V9WQ0yxk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V9WQ0yxk"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5822S9Xv030159
	for <kvmarm@lists.linux.dev>; Tue, 2 Sep 2025 03:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=yKa72tAMaYiEp5QU2uzmYr
	LEiYq8WJdxdN4mi1XQFe4=; b=V9WQ0yxkytlWbP/SkTsiQKHrLJW0XQxHQeGOc3
	AHm1VbemjWBjeBCgQWX2+CiwMilJ1VHzH2tSAViGZ+WbxC6oCDb5A9euLdw1JXoZ
	oaB+yImSicqjw2TtuW5hMe1YJSt/chIT8nUTF0O9tN2mp1+kp7XsASDU4AwZqvVE
	MNxpLsebgy68Hi3rGTz46dZ176jhFMDl8nMSrsn2xCMP5WvZtYRg5aew6Ap9B4Hc
	yUwIY5ho9Z+7SGGGKo9X9s38NYcrOBpUgELZ4372vYpmAlEbdrD6FoW01fcRgIpv
	U8z60PVIzZIbz6sGKi33NuykUnPtEkVYK9UaYQRHWPT9shcw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48w8wy26qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 02 Sep 2025 03:48:32 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2445803f0cfso63089195ad.1
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 20:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756784912; x=1757389712;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yKa72tAMaYiEp5QU2uzmYrLEiYq8WJdxdN4mi1XQFe4=;
        b=NArYcncMC/jvUWU/2hoP6/gY5MOPMaLo6U/2el6p8K9ywcTbO30iN3FwDshjhIjAOj
         N8/HE48ptC7UCoC9updyvqhwIplN/KJQPjgSW4RlGyWFQHZPTRPy4DR3QVCKzC+YcwWB
         CbLgHhd1GQc68Z/UXa7yxZjLiySgNPGK4Nfh3fbryb+if2LIbXwbUcZykdOgTaOsq23V
         eMayoYg6jqEBPO8wj1GyRa1EFRhE9/8ynyjVX7Fc2Tv77LHs8sVIOh35M+ORWViR6Ew7
         L9s44YAFKl58brVCyeAc8eSmSPcDe36Z7KgApIn1oq4JuJqex1GNQ9d31eqbLf3FPc9u
         M8vw==
X-Forwarded-Encrypted: i=1; AJvYcCVTcgotRFJh9c8bO3Z2UQipDanYJz9tZMhIJIaD+WPCb0Z+7zH2ZSc9sLdm6T7J1HGtZ8e1HzY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzF1Bl2K5N1IMLrQ6au1XhrEzaXKCT3UwEMAD7CaCt36mHOQj3c
	BYYwzj0YmFCBQsKiui+6xpkeCqjyozpCbZhFY0An7Pky4IEGWXYvh0GuPgLUYGWvyZH82VQMr3/
	VVYTBc3GPMw9om+/wH39v8CNGgfGMJXijw7iEcsStOHqpmzDy7JqEwKGcTQw=
X-Gm-Gg: ASbGnctsRtEc+W96n3RiCvU4c2ZKhEJmuxqCK9QfXy+DPLmxJ3c/z+lLWxUuRW7Tp1o
	y5UyAKmDfkAt+Fr5u785VWpG8sJMT2n/p3w7tVeDrxmDuw32Ywz+00izciySKFEP58CYvjmcLus
	LsO4rJta2oXrSud8yu//E5tty+InjEwScqsFlxzgwl7d8x5SQYWFEo7kvtrz6HP/m0x0MY36+sO
	khxKLUn55AvonbeCXi/jiHN+FbcvqDAe6i0oeTx6C3A9+6nO6xEyBxIA2RC0aYcsM0xImY4dh8y
	5Q4CRQBWQkE1yjG3X6JVzmniC19ptaI+Yijzg/5UNiroJUtn6QNPQDdcCau7GX9B7I28K+cfmZM
	kwzuJOegTFzuDuaDhukP17lbPmUNSH2zIe/UJ
X-Received: by 2002:a17:902:e80f:b0:240:968f:4d64 with SMTP id d9443c01a7336-249448f9c33mr135634115ad.11.1756784911727;
        Mon, 01 Sep 2025 20:48:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExAbd7KtHY902tMepR979+mkTIDMW7M9jw2QHkr4Ls1PNDX5hM4GxNt4OPOJy08c/0mSNzYg==
X-Received: by 2002:a17:902:e80f:b0:240:968f:4d64 with SMTP id d9443c01a7336-249448f9c33mr135633765ad.11.1756784911264;
        Mon, 01 Sep 2025 20:48:31 -0700 (PDT)
Received: from jinlmao-gv.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b168157b6sm3467515ad.13.2025.09.01.20.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 20:48:30 -0700 (PDT)
From: Yingchao Deng <yingchao.deng@oss.qualcomm.com>
Date: Tue, 02 Sep 2025 11:48:25 +0800
Subject: [PATCH v2] KVM: arm64: Fix NULL pointer access issue
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-etm_crash-v2-1-aa9713a7306b@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAhptmgC/5WMQQrCMBBFr1KyNiVJkzZ15T2kSBinNmAbzdSil
 N7dtFt1IQMf/mfemxlh9Ehsn80s4uTJhyEVtcsYdG64IPfn1JkSyohaSI5jf4LoqOMCsVYFprT
 A0v8tYuufm+vYpN55GkN8bepJrus3yyR5OigLWRkhjbGHQJTfH+4Koe/zFKv7F6grqK1srXai/
 QsELA1qDbKo4BNslmV5A95872wbAQAA
X-Change-ID: 20250901-etm_crash-0ee923eee98c
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, James Clark <james.clark@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, quic_yingdeng@quicinc.com,
        jinlong.mao@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        Yingchao Deng <yingchao.deng@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1756784908; l=2434;
 i=yingchao.deng@oss.qualcomm.com; s=20250901; h=from:subject:message-id;
 bh=pomve51ySnfeym3a5NacsGQMLiUMbbW2nqwOtU9Q3SM=;
 b=bb5AIneQZyVNy1w/19DaiOY0pRfZROqaFONWQ94N/D2KTzx4Qwhkqa6plCGU5jzJpmtAP/dLg
 2aAiLb7LhkMDRSfnmZt1hgR8nWzcT8mVlW5YJt4j6mL+o+/77IbjXhq
X-Developer-Key: i=yingchao.deng@oss.qualcomm.com; a=ed25519;
 pk=xilq+l2r3MI2IvgF26j2OwmdNb/TQNeJMQ3VdJi8C4U=
X-Authority-Analysis: v=2.4 cv=Ycq95xRf c=1 sm=1 tr=0 ts=68b66911 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=KKAkSRfTAAAA:8 a=ZDfnslOjjdbEBvoarX8A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: uywhvUyxuPua0a9fZB7cjl2eZySx9QIg
X-Proofpoint-ORIG-GUID: uywhvUyxuPua0a9fZB7cjl2eZySx9QIg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAxMDEwMSBTYWx0ZWRfXybaL+YInOp7O
 8Y543eTpuwHUV05wSmIFGcJ3s5eOt+bQEvoZnuXjNgWVp2JtlRqQrVrp85wcnBt3Z/qdA0wn3s2
 4uMG1NTCJScKEMnJinUbsbflB1Sl+2PI0/8CeD8P8hkyWyQsllOJs+1JKMxBZruBAy6UIA7cRYp
 JJH/Y8f7TTTDF8nNbwcGnY5TsHQPF85pLboN5citMTSjcH0ao2ccUFrmB+r5A6tXbIGGn02Ps2N
 P+9uhs8MnFvvv1LbvjKf/jFsiu0SfnYxBZwA1hMZfcilAezeVt8Z+CGcJnOn8sNm9b7ax8KMA5E
 GL0HgUqPcFmVOpH/NOd95VLdntwHBMOaoZFiOgEhoT3fqsayZ4hAZLBkHjzXc5yPFmQoxlxe1HC
 rOU2XtfY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509010101

When linux is booted in EL1, macro "host_data_ptr()" is a wrapper that
resolves to "&per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)",
is_hyp_mode_available() return false during kvm_arm_init, the per-CPU base
pointer __kvm_nvhe_kvm_arm_hyp_percpu_base[cpu] remains uninitialized.
Consequently, any access via per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)
will result in a NULL pointer.

Add is_kvm_arm_initialised() condition check to ensure that kvm_arm_init
completes all necessary initialization steps, including init_hyp_mode.

Fixes: 054b88391bbe2 ("KVM: arm64: Support trace filtering for guests")
Signed-off-by: Yingchao Deng <yingchao.deng@oss.qualcomm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
---
Add a check to prevent accessing uninitialized per-CPU data.
---
Changes in v2:
1. Move the warning to the end in order to improve readability. No
functional change intended
- Link to v1: https://lore.kernel.org/r/20250901-etm_crash-v1-1-ce65e44c137c@oss.qualcomm.com
---
 arch/arm64/kvm/debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 381382c19fe4741980c79b08bbdab6a1bcd825ad..593fcbbc7c014335c5999b774f9bfa367e709cb5 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -233,7 +233,7 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
 void kvm_enable_trbe(void)
 {
 	if (has_vhe() || is_protected_kvm_enabled() ||
-	    WARN_ON_ONCE(preemptible()))
+	    !is_kvm_arm_initialised() || WARN_ON_ONCE(preemptible()))
 		return;
 
 	host_data_set_flag(TRBE_ENABLED);
@@ -243,7 +243,7 @@ EXPORT_SYMBOL_GPL(kvm_enable_trbe);
 void kvm_disable_trbe(void)
 {
 	if (has_vhe() || is_protected_kvm_enabled() ||
-	    WARN_ON_ONCE(preemptible()))
+	    !is_kvm_arm_initialised() || WARN_ON_ONCE(preemptible()))
 		return;
 
 	host_data_clear_flag(TRBE_ENABLED);
@@ -252,7 +252,8 @@ EXPORT_SYMBOL_GPL(kvm_disable_trbe);
 
 void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest)
 {
-	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()))
+	if (is_protected_kvm_enabled() || !is_kvm_arm_initialised() ||
+	    WARN_ON_ONCE(preemptible()))
 		return;
 
 	if (has_vhe()) {

---
base-commit: 8cd53fb40a304576fa86ba985f3045d5c55b0ae3
change-id: 20250901-etm_crash-0ee923eee98c

Best regards,
-- 
Yingchao Deng <yingchao.deng@oss.qualcomm.com>

