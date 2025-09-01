Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADD3BA4A
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 10:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756720915; cv=none; b=LlVqNX12U/CcYHQ0iPWATnXPdEmae9rQPxznRulHhz3B19V02Y9L1Q2EUHYgOFYdPdTafEa6JIDbu5LzeDFo+p5J1YVH0iStaBgee2vPjVZDYLAy5Ry0v5UPZ/6WS8RphwQjtuWxCSpDTLGTziEeavZ+BHGRoR8ItLQnwAGX0ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756720915; c=relaxed/simple;
	bh=X+Tp/RgBOAXJDPg8M+jMZCaUbGdx0ODDY68KszLl/ck=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=AY/JMEX0PgFYUYLgXuELgFVoKjdTpZQEGjMfmU+HMKFyXadnU/Gw4A6mTiTnvwg/jc1yxeyXYCt40vVB5FcMwdkKr7Q7fvQZq60BfBvp+eqHx7faezYr3aAqwHSmXzz0LHTkBBmfCDvFTbkrdNSsOsk4xn2wPFrFpvQZC9mGcQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RC9P9Oeh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RC9P9Oeh"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5819eOnb005030
	for <kvmarm@lists.linux.dev>; Mon, 1 Sep 2025 10:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=qQgwpgTjtkLJU+HAWiUzei
	zRHRiOnurR4p2VY8u2JAI=; b=RC9P9Oehzy3AdgflD/E3cj+jUtfRXA6kdEm7xA
	EVOdyhC5Xd6rO3HjZ8NQ/v6zK4wdMzm0EbZEI52abfM6j17bxzZZu+JNTOr3c0hh
	y2D+qAFLCtx1u1syOQ6m7dVo/1oubVehXW2EAUnJUa6aUstK+MmVJUTYsTZfjT6k
	ZHv2Wle/nMnLVl+kDXmG9hVDB2lEnKlqPsKjlD4FFc75p8InD0r85vhIBxpvqe6K
	XEzLSSpVqIgswceb3zNHQznZkpp+IH2j0X0T2ytHKIzrtKMYwpnR0PcukIGnyiXK
	7OVZ4TmxmMUZGs2eU2XC6CsjLO0x8iXIznZSYSxp6/FjaHmg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48uq0ecgqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 10:01:52 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-325ce108e45so4068822a91.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 03:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756720912; x=1757325712;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qQgwpgTjtkLJU+HAWiUzeizRHRiOnurR4p2VY8u2JAI=;
        b=nUNicqrTndPWf96yjWDY9G8iTcnGyt78lkzBFDeSR/StcXiWgtDI9uHSDpegxFlulO
         lp8Jfj5RaozvS3WK8ev8/E/uK088gs5kkMfXT2rcVIjw2N3G8LRIz1kHDzELZ/YaRTJO
         1dzL82q81KcRp94NyPWggRIAcQiDvBDxCFM1trpUjl4NdhfyepgY1ZyMWe/g+Fdp13Z4
         jT2mqoTb6X+SAhCNuMxq7pEUDJtiNo347cRdZ+jCHnI6uzqstlu8LXet9OXUHx10USl9
         KuZ0I2TmxIAZo3NJT+IaI7fYOcrgGKk4JJBFl0rkT3QT9GK/QCbUVQsELW63sroZi5jw
         iRCg==
X-Forwarded-Encrypted: i=1; AJvYcCVKgxfEhqTqqGdnDNwFEWqLxYM+Y8OLIeodnYpLfcUgbkpW6+pmsgoo3mK/VjFxhbNjYR8D7aY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbZMc/gNKKVF74uYMbgR8plliqNjDhJ6aq1PpbnWxPNkPzQNbi
	Uk7P4Nsp31t49lY64A8/MH5+E70KdAduxov5RH0RaBq9bOroXVPkeR0ERdfH3p3M4omXUF6P2mE
	/YjITWF7iwp2Jy2Lvkr57E2g/Vkp8al+Vs6Cad4MDsnKFGy/UcS0vCkrlnWA=
X-Gm-Gg: ASbGncuCJvNfHaax7hmrPu5zivXzIY/pVZPtqIH9gahPom+yoPBRhtWh9ssWKCn/d6l
	zAiiwS/BpPbqP5O51QPzyoqWFEe3zogbYQHXEmJoBKEkY91ekNYKcpLhxFknWL31jLoJ3HUoOXh
	ijuPmiEPL26b6fXny+3KSnYVm5vP1cofObdhTuyJpS2fNKdOLX0cChHPB6REo49yy5nXtv/9sgu
	kXER11beJlnTuXzfxkWlA++Hd3ineYjF6X9tS1q3ycmM4GlA0CU20DVWHeidCB22VD9Dzj74idc
	5hcMnmDW3Y8n4C23RJNFPmilySL3KRkd2yWdQlFjLHxaFpzuJp1k8XDYw8ZVsJ920EqtxY+UWkQ
	pWWB2Qb7tPmj6sY6ypAVGlcCTGaTGddo/hG3N
X-Received: by 2002:a17:90b:52cf:b0:325:15bf:4dc2 with SMTP id 98e67ed59e1d1-3281531d3femr10322017a91.0.1756720911590;
        Mon, 01 Sep 2025 03:01:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1Jx0Jsm3pv79yInlxMD+8W/VppGUVhsqwbSB34wrfl77W1ukxVuajcczW1H+8VH9LiCTvhA==
X-Received: by 2002:a17:90b:52cf:b0:325:15bf:4dc2 with SMTP id 98e67ed59e1d1-3281531d3femr10321969a91.0.1756720911094;
        Mon, 01 Sep 2025 03:01:51 -0700 (PDT)
Received: from jinlmao-gv.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4e673ad423sm6012525a12.50.2025.09.01.03.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 03:01:50 -0700 (PDT)
From: Yingchao Deng <yingchao.deng@oss.qualcomm.com>
Date: Mon, 01 Sep 2025 18:01:45 +0800
Subject: [PATCH] KVM: arm64: Fix NULL pointer access issue
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-etm_crash-v1-1-ce65e44c137c@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAhvtWgC/3WMQQrCMBBFr1KyNiWTNjZ15T2kSIhTG7CNZmpRS
 u/utFuVgQ/vM//NgjAFJHHIZpFwChTiwAC7TPjODVeU4cIstNJG1Qokjv3ZJ0edVIi1LpDTesH
 /94RteG2uU8PcBRpjem/qCdb2l2UCyef3BVRGgTH2GInyx9PdfOz7nGN1/xuWla8ttLZ0qv0eN
 suyfAAlzbqP4gAAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1756720907; l=2171;
 i=yingchao.deng@oss.qualcomm.com; s=20250901; h=from:subject:message-id;
 bh=X+Tp/RgBOAXJDPg8M+jMZCaUbGdx0ODDY68KszLl/ck=;
 b=0hURcY7VKduAxWJqet9HVBB0Tztm1vwxHVJRsJrYuafgrjeyxcryvuyzEQCF5cYxXr7GiT3cR
 Hpi+c1kAlhRAj1DhVjCRr2MJL11P7TKvmGA6lC/3cAGyL8mg1vvfLXK
X-Developer-Key: i=yingchao.deng@oss.qualcomm.com; a=ed25519;
 pk=xilq+l2r3MI2IvgF26j2OwmdNb/TQNeJMQ3VdJi8C4U=
X-Proofpoint-GUID: IRSrYtpoFSoT3ewgiMBoHv0an-6Edy1q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAwNCBTYWx0ZWRfX01KKa/SwCd85
 2nbHgJ8onHnGEi4j73JPozjiLFwVhGLZHgjztbOF0xk59kiUIc7ttGxorb+m74unpSOkbhdNQkr
 KW8zETK3b0ORq3+7Dsc1UIiXIHwYCr+mDRfIrORos9HKZ6aTZiBmAuwNAxdB1+Xgk0wkj8hWfwU
 Y9k3RG/7TpTRY9yxxwwesc9nEdrMxqy/yphKRZQuGNYTKiPR1qOSqHqa+R8083KHo5AcMSmhJp+
 phQBhiUF98MteKq3Zcjx1JfYbJMFCF0pxZRIDvFHpyDUFQdQ3xECvCRXZM1hMBQev9p3686iX1Z
 jD7GrhUOF/uAC77DKoXe3n8Jz7JvLjUjiL1NcHqwvftXArYLAMIYKo84CGntXTxfStBlzMBkRf4
 ZyoxyNPo
X-Proofpoint-ORIG-GUID: IRSrYtpoFSoT3ewgiMBoHv0an-6Edy1q
X-Authority-Analysis: v=2.4 cv=ea09f6EH c=1 sm=1 tr=0 ts=68b56f10 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=ZDfnslOjjdbEBvoarX8A:9
 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-01_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1011 malwarescore=0 phishscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508300004

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
---
Add a check to prevent accessing uninitialized per-CPU data.
---
 arch/arm64/kvm/debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 381382c19fe4741980c79b08bbdab6a1bcd825ad..add58056297293b4eb337028773b1b018ecc9d35 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -233,7 +233,7 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
 void kvm_enable_trbe(void)
 {
 	if (has_vhe() || is_protected_kvm_enabled() ||
-	    WARN_ON_ONCE(preemptible()))
+	    WARN_ON_ONCE(preemptible()) || !is_kvm_arm_initialised())
 		return;
 
 	host_data_set_flag(TRBE_ENABLED);
@@ -243,7 +243,7 @@ EXPORT_SYMBOL_GPL(kvm_enable_trbe);
 void kvm_disable_trbe(void)
 {
 	if (has_vhe() || is_protected_kvm_enabled() ||
-	    WARN_ON_ONCE(preemptible()))
+	    WARN_ON_ONCE(preemptible()) || !is_kvm_arm_initialised())
 		return;
 
 	host_data_clear_flag(TRBE_ENABLED);
@@ -252,7 +252,8 @@ EXPORT_SYMBOL_GPL(kvm_disable_trbe);
 
 void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest)
 {
-	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()))
+	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()) ||
+	    !is_kvm_arm_initialised())
 		return;
 
 	if (has_vhe()) {

---
base-commit: 8cd53fb40a304576fa86ba985f3045d5c55b0ae3
change-id: 20250901-etm_crash-0ee923eee98c

Best regards,
-- 
Yingchao Deng <yingchao.deng@oss.qualcomm.com>

