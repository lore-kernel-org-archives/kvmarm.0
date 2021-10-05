Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57574C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03D0C6154B
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 03D0C6154B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE4564B2DD;
	Mon,  4 Oct 2021 21:19:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i74tAQEYr6Ku; Mon,  4 Oct 2021 21:19:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18D1D4B2A7;
	Mon,  4 Oct 2021 21:19:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DD5F4B2B9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gz5Endu6taRJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:32 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 473364B1F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:32 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 b5-20020a6541c5000000b002661347cfbcso11582641pgq.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Lp8fppr199NgsT/j3g+xAZeLiIny0nlTRqLnRB6Lf9o=;
 b=r8cy36ekkCRU7CK9x39r2ehmczVM4WYvdrpVCxCMQAGmXL8lkvN+gv5F/Exoy/06Jp
 JeiEZCbkC4yHKPpHZuSMjruHBOEd07wX7IDbnFhQR5LJn03nXb34CcbZYsKjscKUtC+i
 0/Q0JF1cimpivptb5ERCkMpjEgebxrP2Jsp3kMFn7iXl9wTn7i2MdsU5zQrZp8d8pCMH
 8kK9jnMmsQKQ250QGfK4a4X5fPLWM54G7FLRxs9KamWRjBkNx2OmUdO5h63bDHBZmKcx
 2YnypWDrfiIB+dDb96K3QMvLJ0/pykxn7g0tDqzvhtcRfBc7hZD1lQhWbBgAIOuTnY5P
 mkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Lp8fppr199NgsT/j3g+xAZeLiIny0nlTRqLnRB6Lf9o=;
 b=6Wr/F11FIKiQuM7hXc9cBmr260j0A+h5/0R6CL/bDkr5hdh2Ux/9KCW06Kd7OmKRXE
 4OPTqQZh72R9EsImgxhjaCSyveNfGS6DWhx2EMBxDat5isi8cE4TEwG8DTtyzoF7JhLM
 s+i3epHy+YVLr0/kxQN5P4Pvh9Vway0d8PHQ+FrFa+ZLmxe3uaqg8we7+g+xJ0HzjLiT
 V7TwJuwI/0x2yfFeE9v5DbSbHEKR0v3gIx3+7ya34J7Ux26aq29SpQFibNreNT3Dh55k
 SXe+XhPrnHaT3WVKzOiEko8Jc2GF8KCfxv9ZAe4124ni4b7hhvZ1TCRbxNAXvt2QmeSn
 Jr6Q==
X-Gm-Message-State: AOAM532nIKNRX0c4UkrVkiG6+nlhaAgblAj61hccZ+N2m05lOnWGR9Dr
 Sx1SvVex/Yu0SHIV1Y7CudOkT2rlPUTFaA==
X-Google-Smtp-Source: ABdhPJxwdP9If/0J3kUi563HWaeI3qySO00OZJr5uPRW0Ggk3kGihGSs8tskW+HQKj1LI4MQKFwZS9DN0Mb7Mg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:9242:0:b0:446:5771:7901 with SMTP id
 o63-20020a629242000000b0044657717901mr27569603pfd.81.1633396771443; Mon, 04
 Oct 2021 18:19:31 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:15 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 05/11] KVM: arm64: vgic: Drop vgic_check_ioaddr()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

There are no more users of vgic_check_ioaddr(). Move its checks to
vgic_check_iorange() and then remove it.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 26 ++++----------------------
 arch/arm64/kvm/vgic/vgic.h            |  3 ---
 2 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 08ae34b1a986..0d000d2fe8d2 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -14,38 +14,20 @@
 
 /* common helpers */
 
-int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
-		      phys_addr_t addr, phys_addr_t alignment)
-{
-	if (addr & ~kvm_phys_mask(kvm))
-		return -E2BIG;
-
-	if (!IS_ALIGNED(addr, alignment))
-		return -EINVAL;
-
-	if (!IS_VGIC_ADDR_UNDEF(*ioaddr))
-		return -EEXIST;
-
-	return 0;
-}
-
 int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
 		       phys_addr_t addr, phys_addr_t alignment,
 		       phys_addr_t size)
 {
-	int ret;
-
-	ret = vgic_check_ioaddr(kvm, &ioaddr, addr, alignment);
-	if (ret)
-		return ret;
+	if (!IS_VGIC_ADDR_UNDEF(ioaddr))
+		return -EEXIST;
 
-	if (!IS_ALIGNED(size, alignment))
+	if (!IS_ALIGNED(addr, alignment) || !IS_ALIGNED(size, alignment))
 		return -EINVAL;
 
 	if (addr + size < addr)
 		return -EINVAL;
 
-	if (addr + size > kvm_phys_size(kvm))
+	if (addr & ~kvm_phys_mask(kvm) || addr + size > kvm_phys_size(kvm))
 		return -E2BIG;
 
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4be01c38e8f1..3fd6c86a7ef3 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -172,9 +172,6 @@ void vgic_kick_vcpus(struct kvm *kvm);
 void vgic_irq_handle_resampling(struct vgic_irq *irq,
 				bool lr_deactivated, bool lr_pending);
 
-int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
-		      phys_addr_t addr, phys_addr_t alignment);
-
 int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
 		       phys_addr_t addr, phys_addr_t alignment,
 		       phys_addr_t size);
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
