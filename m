Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF8BC6FA83
	for <kvmarm@archiver.kernel.org>; Sun, 11 Sep 2022 21:41:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C07414C354;
	Sun, 11 Sep 2022 17:41:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lLq1tSkbWf8E; Sun, 11 Sep 2022 17:41:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EDD14C328;
	Sun, 11 Sep 2022 17:41:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 935134C328
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Sep 2022 17:41:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eLd83eK6Vn1E for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Sep 2022 17:41:21 -0400 (EDT)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com
 [205.220.168.131])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 638D24C306
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Sep 2022 17:41:21 -0400 (EDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
 by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28BLfACZ012463;
 Sun, 11 Sep 2022 21:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com;
 h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=172gqBHdWTQsPiaT/19OqMVWgqe3jX8FYL5YY4LecWU=;
 b=iO7OZl1YeSX35Wr6OiLm5BQ6Msub0d37eTaouQSKMx2M96EWXBbR3kvuHmCf9evzR6+t
 kGWqKBv850ASNqix5c2qSieY08VeXI0kJGZBs18+SZ4x+0b0HwIgeEdojL2AggZcHEhS
 MzAtrC6ArV8hihSxSPpSr3NGLCJOqF9qWEwPNbw0m3jJEbLQZhqtB5DmFUm1DWEGaLsP
 U8fMXwbn4D0tmjVpAbtwPcSv0RR9iX/9aWyND/kL1dCIuu4gGChK7jibpXb3bciNglH9
 amYkzgZ8UuILaMBReIdg5P/TVJ00GhhyFVUuOwe20D1djOLRy7o6QGMa6PN4myJ4a9ME pA== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com
 [199.106.103.254])
 by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jgk43jp9t-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Sun, 11 Sep 2022 21:41:10 +0000
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com
 [10.46.141.250])
 by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28BLf9DA028608
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Sun, 11 Sep 2022 21:41:09 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 11 Sep 2022 14:41:09 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3] KVM: arm64: Ignore kvm-arm.mode if !is_hyp_mode_available()
Date: Sun, 11 Sep 2022 14:40:59 -0700
Message-ID: <20220911214059.2767620-1-quic_eberman@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800
 signatures=585085
X-Proofpoint-GUID: O96vbLzBZ1LFAsrLFd_xeOhMc_hcdqfA
X-Proofpoint-ORIG-GUID: O96vbLzBZ1LFAsrLFd_xeOhMc_hcdqfA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-11_12,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=861 clxscore=1015
 mlxscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209110084
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
KVM mode at all if KVM isn't actually available. Don't emit warning for
"kvm-arm.mode=none" since this would disable KVM anyway.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 arch/arm64/kvm/arm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8fe73ee5fa84..8e5d1c8502f5 100644
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
+		pr_warn_once("KVM is not available. Ignoring kvm-arm.mode\n")
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
