Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55989C6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 19:07:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3D224B64A;
	Tue, 20 Sep 2022 15:07:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0UdYCpl4J0tj; Tue, 20 Sep 2022 15:07:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA5B4B64F;
	Tue, 20 Sep 2022 15:07:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08D334B645
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 15:07:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D1twcI+Nv48F for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 15:07:38 -0400 (EDT)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com
 [205.220.168.131])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3C8A4B2B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 15:07:37 -0400 (EDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
 by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KETMT3004438;
 Tue, 20 Sep 2022 19:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com;
 h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=OZ8w2A3fX97aIFB0xniFuDBYe0bAxjjXLZnsgXRtZEo=;
 b=WQ9QxT/S/5Wz2qEknNEJuriz7BGcUpDtzzaTim/X9C0A7YstGK3UB5aJ48Q7acyR8kYV
 0pRyeMIeb7kJxK/ZYTv46fauZDOI6D33QouEblyiXFzmfDyBDhgPQTnlWs4DNy2vjvjB
 KGZDGOiKSPjwqSnh/B89miRB/ODpaYzNM/4RcUPnreIQCZ781k2r7o/4sXWCE2GISb5O
 Xe2K9egns69vscKeYUaY8uGh8Y9+wPLaThXM4nX6wypUP14QX1I1JTSGjok2+SuIneBd
 Mb2VqMYCGc/L6GWlYqKKU1185Ouvc62TDPLhgXGGd0w7dcZs+iXUNrThr9Ifix2Ehdp5 aw== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com
 [199.106.103.254])
 by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jq7323019-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Tue, 20 Sep 2022 19:07:25 +0000
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com
 [10.46.141.250])
 by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28KJ7PVN010539
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Tue, 20 Sep 2022 19:07:25 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 20 Sep 2022 12:07:24 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5] KVM: arm64: Ignore kvm-arm.mode if !is_hyp_mode_available()
Date: Tue, 20 Sep 2022 12:06:58 -0700
Message-ID: <20220920190658.2880184-1-quic_eberman@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800
 signatures=585085
X-Proofpoint-ORIG-GUID: -l0z1Tpdj0znX-YJ3X8mvVcc-gtTMtL7
X-Proofpoint-GUID: -l0z1Tpdj0znX-YJ3X8mvVcc-gtTMtL7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_09,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0
 adultscore=0 mlxlogscore=831 spamscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200114
Cc: Elliot Berman <quic_eberman@quicinc.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Ignore kvm-arm.mode if !is_hyp_mode_available(). Specifically, we want
to avoid switching kvm_mode to KVM_MODE_PROTECTED if hypervisor mode is
not available. This prevents "Protected KVM" cpu capability being
reported when Linux is booting in EL1 and would not have KVM enabled.
Reasonably though, we should warn if the command line is requesting a
KVM mode at all if KVM isn't actually available. Allow
"kvm-arm.mode=none" to skip the warning since this would disable KVM
anyway.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 arch/arm64/kvm/arm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8fe73ee5fa84..34cd0570e433 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2271,6 +2271,16 @@ static int __init early_kvm_mode_cfg(char *arg)
 	if (!arg)
 		return -EINVAL;
 
+	if (strcmp(arg, "none") == 0) {
+		kvm_mode = KVM_MODE_NONE;
+		return 0;
+	}
+
+	if (!is_hyp_mode_available()) {
+		pr_warn_once("KVM is not available. Ignoring kvm-arm.mode\n");
+		return 0;
+	}
+
 	if (strcmp(arg, "protected") == 0) {
 		if (!is_kernel_in_hyp_mode())
 			kvm_mode = KVM_MODE_PROTECTED;
@@ -2285,11 +2295,6 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return 0;
 	}
 
-	if (strcmp(arg, "none") == 0) {
-		kvm_mode = KVM_MODE_NONE;
-		return 0;
-	}
-
 	return -EINVAL;
 }
 early_param("kvm-arm.mode", early_kvm_mode_cfg);

base-commit: 0982c8d859f8f7022b9fd44d421c7ec721bb41f9
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
