Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCECC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 07:54:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4DA14610E6
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 07:54:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4DA14610E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFFC44B102;
	Wed, 27 Oct 2021 03:54:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pwvwts2iPMcc; Wed, 27 Oct 2021 03:54:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C3574B131;
	Wed, 27 Oct 2021 03:54:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78A0A4A193
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 22:42:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pw6xFm1TAFmh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Oct 2021 22:42:43 -0400 (EDT)
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 059E340068
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 22:42:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
 t=1635302563; x=1666838563;
 h=from:to:cc:subject:date:message-id:mime-version:
 content-transfer-encoding;
 bh=L/uG5CU2gMtP7B26JcOoa7vhnzcIoGWSJZKXSNZS4YA=;
 b=Z5via2TlWI2HKk1xp0dP9jwBxF21BzS/BCpofwe5nsOCZNX1D4X2vGxs
 ayGeUdi7wTZ8UmGmJMXDKlEaEsqq7nNffvPofRKlRYZ8KS5fforwyzcoo
 E5qVyUE/RWujZTQBbIUHuqHcFBF9xKh2wXflVZt2kgl2lrrVC4Rw51mn9 8=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
 by alexa-out.qualcomm.com with ESMTP; 26 Oct 2021 19:42:41 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
 by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 26 Oct 2021 19:42:41 -0700
Received: from qian-HP-Z2-SFF-G5-Workstation.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; 
 Tue, 26 Oct 2021 19:42:39 -0700
From: Qian Cai <quic_qiancai@quicinc.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: arm64: Avoid shadowing a previous local
Date: Tue, 26 Oct 2021 22:42:12 -0400
Message-ID: <20211027024212.64842-1-quic_qiancai@quicinc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Mailman-Approved-At: Wed, 27 Oct 2021 03:54:34 -0400
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Qian Cai <quic_qiancai@quicinc.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

It is less-prone to have a different variable name from the one in a wider
scope. This is also flagged by GCC (W=2):

In file included from ./include/linux/kvm_host.h:39,
                 from arch/arm64/kvm/arm.c:12:
arch/arm64/kvm/arm.c: In function 'kvm_arch_vcpu_ioctl_run':
./arch/arm64/include/asm/kvm_host.h:638:26: warning: declaration of 'ret' shadows a previous local [-Wshadow]
  638 |   typeof(f(__VA_ARGS__)) ret;    \
      |                          ^~~
arch/arm64/kvm/arm.c:852:9: note: in expansion of macro 'kvm_call_hyp_ret'
  852 |   ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
      |         ^~~~~~~~~~~~~~~~
arch/arm64/kvm/arm.c:773:6: note: shadowed declaration is here
  773 |  int ret;
      |      ^~~

Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
---
 arch/arm64/include/asm/kvm_host.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4be8486042a7..4693d84ccd95 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -635,16 +635,16 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 
 #define kvm_call_hyp_ret(f, ...)					\
 	({								\
-		typeof(f(__VA_ARGS__)) ret;				\
+		typeof(f(__VA_ARGS__)) __ret;				\
 									\
 		if (has_vhe()) {					\
-			ret = f(__VA_ARGS__);				\
+			__ret = f(__VA_ARGS__);				\
 			isb();						\
 		} else {						\
-			ret = kvm_call_hyp_nvhe(f, ##__VA_ARGS__);	\
+			__ret = kvm_call_hyp_nvhe(f, ##__VA_ARGS__);	\
 		}							\
 									\
-		ret;							\
+		__ret;							\
 	})
 #else /* __KVM_NVHE_HYPERVISOR__ */
 #define kvm_call_hyp(f, ...) f(__VA_ARGS__)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
