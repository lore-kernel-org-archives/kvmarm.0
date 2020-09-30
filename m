Return-Path: <SRS0=046z=DI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2235DC4727C
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 14:38:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6313D207FB
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 14:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zVGbNSyl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6313D207FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2E174B373;
	Thu,  1 Oct 2020 10:38:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@oracle.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qXM++zMuEpLJ; Thu,  1 Oct 2020 10:38:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BBCF4B369;
	Thu,  1 Oct 2020 10:38:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 531384B1E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 18:12:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H7K93FeTFK1a for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2020 18:12:48 -0400 (EDT)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E02F4B159
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 18:12:48 -0400 (EDT)
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
 by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UMA59o133073;
 Wed, 30 Sep 2020 22:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=djWsOShf+02bZz82qBkoZE9ucpn4vqY+77IN/a6iH2s=;
 b=zVGbNSylMfdh1LJtRsrVbQtDe3b7mteOGVhcQdlskWa1IEBXKU3+wpUewsZwOC9cTZNE
 rkaTPFzaN3SmnlEWVx9H9Ev5sDhqf7oTFFEfet/JJM3i5Jttf1LrrWq7GRvkMkH2WCi8
 p82RffYi6JtZ7afnSzHkQdk646J6hU5/B6Sgb6uA1ONrP5BbdIQpBlmpwhMIHAD8gAbm
 kLLbJ+jJWrY5jRmwWAKMpy3amxNqopdyJHfjhfPGm/J6lId7pQsojdWYYWz7U2lPWVfL
 0eNUDU4yKShWJt14MMFxSorV4lPauIjr7ELbFGlIfeZRLcwFhX7+FhAEHZoyRi8F9oJA bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
 by aserp2130.oracle.com with ESMTP id 33su5b34j3-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
 Wed, 30 Sep 2020 22:12:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
 by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UMAnr9067284;
 Wed, 30 Sep 2020 22:12:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by userp3020.oracle.com with ESMTP id 33tfdupwhe-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
 Wed, 30 Sep 2020 22:12:40 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
 by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08UMCdMH071129;
 Wed, 30 Sep 2020 22:12:39 GMT
Received: from brm-x62-20.us.oracle.com (brm-x62-20.us.oracle.com
 [10.80.150.35]) by userp3020.oracle.com with ESMTP id 33tfdupwh3-1;
 Wed, 30 Sep 2020 22:12:39 +0000
From: Thomas Tai <thomas.tai@oracle.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Fixes ARM VM hangs at boot
Date: Wed, 30 Sep 2020 16:12:39 -0600
Message-Id: <20200930221239.488744-1-thomas.tai@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760
 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1011 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300177
X-Mailman-Approved-At: Thu, 01 Oct 2020 10:38:19 -0400
Cc: thomas.tai@oracle.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

When using the latest kernel v5.9-rc7 on an ARM server, VMs could
hang at boot with no output. The commit a0e50aa3f4a8 removed
asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT)),
it looks like isb is still needed for non
ARM64_WORKAROUND_SPECULATIVE_AT host when switching to guest.

The code fragment for the original patch:
-       /* __load_guest_stage2() includes an ISB for the workaround. */
-       __load_guest_stage2(kvm);
-       asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
+       __load_guest_stage2(mmu);

The code should have been:
-       /* __load_guest_stage2() includes an ISB for the workaround. */
-       __load_guest_stage2(kvm);
-       asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
+       __load_guest_stage2(mmu);
+       asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
ie, the workaround is still needed.

Fixes: a0e50aa3f4a8 ("KVM: arm64: Factor out stage 2 page table data from
struct kvm")

Signed-off-by: Thomas Tai <thomas.tai@oracle.com>
---
 arch/arm64/kvm/hyp/nvhe/tlb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 69eae60..536496e 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -32,6 +32,7 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 	}
 
 	__load_guest_stage2(mmu);
+	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
 static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
