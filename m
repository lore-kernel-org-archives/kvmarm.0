Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9529BC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 07:54:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05F7260ED4
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 07:54:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 05F7260ED4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72D4E4B0F7;
	Wed, 27 Oct 2021 03:54:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fFAqkUBvYSr3; Wed, 27 Oct 2021 03:54:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ADC84B120;
	Wed, 27 Oct 2021 03:54:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6237B4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 17:09:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9hOyVxGL7qms for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Oct 2021 17:09:39 -0400 (EDT)
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E1A54A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 17:09:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
 t=1635282579; x=1666818579;
 h=from:to:cc:subject:date:message-id:mime-version:
 content-transfer-encoding;
 bh=3ypMBrk+3j6FxYmtaFh1XZoPQs9JHaCVhfPDEWck3j4=;
 b=UYOWfUxaokMs5THo/5N2U9L5UDhQ9/kDp6frgCwDUkQBnFVZyPke1UN/
 uHtrIgX469S7bIlgwTcfGeVCGNbpaYv2D7DC510umiMws7lwVgvIfVIHQ
 1Dn2mIKksW/XLORlJ83ggULHlGUJlTfEcVA1vJoEeQP9TXSpNlC16tt0J 4=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
 by alexa-out.qualcomm.com with ESMTP; 26 Oct 2021 14:09:38 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
 by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 26 Oct 2021 14:09:37 -0700
Received: from qian-HP-Z2-SFF-G5-Workstation.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; 
 Tue, 26 Oct 2021 14:09:36 -0700
From: Qian Cai <quic_qiancai@quicinc.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: arm64: Remove unused TRNG_NO_ENTROPY
Date: Tue, 26 Oct 2021 17:09:13 -0400
Message-ID: <20211026210913.57006-1-quic_qiancai@quicinc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Mailman-Approved-At: Wed, 27 Oct 2021 03:54:34 -0400
Cc: Will Deacon <will@kernel.org>, Qian Cai <quic_qiancai@quicinc.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org
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

TRNG_NO_ENTROPY was unused when introduced and now. This is also caught by
GCC (W=2):

arch/arm64/kvm/trng.c:17: warning: macro "TRNG_NO_ENTROPY" is not used [-Wunused-macros]
   17 | #define TRNG_NO_ENTROPY   ((unsigned long)-3)

Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
---
 arch/arm64/kvm/trng.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
index 99bdd7103c9c..6a46b3ac3970 100644
--- a/arch/arm64/kvm/trng.c
+++ b/arch/arm64/kvm/trng.c
@@ -14,7 +14,6 @@
 #define TRNG_SUCCESS			0UL
 #define TRNG_NOT_SUPPORTED		((unsigned long)-1)
 #define TRNG_INVALID_PARAMETER		((unsigned long)-2)
-#define TRNG_NO_ENTROPY			((unsigned long)-3)
 
 #define TRNG_MAX_BITS64			192
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
