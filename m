Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8D9C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F9C160F9D
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8F9C160F9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D1EC4B13E;
	Tue, 28 Sep 2021 14:48:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9FWAnRTLtVRS; Tue, 28 Sep 2021 14:48:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F53E4B0E2;
	Tue, 28 Sep 2021 14:48:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 641A74B0DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HwLh-50aGHcI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 14:48:15 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D3BF4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:14 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 j4-20020a654d44000000b00287a16a3519so23003pgt.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8STNvO/W+/tH6mis7cVRJ3Dc57rX86y55WPHAXp51vA=;
 b=Lav0bpVUN4Oquga0REUXCMujWYzDDRnjAT62pSHmfoEUa2PIvfp5F1Kg5ACJCpAnD4
 FEZ/u0KXIJBayfxa6jngfiCpFXBZUcXykEXCfoh7PXPN41Qq7vRH2/ReasumUTEaWYdI
 mNoM+eXzdtyivAAja4vueOaveB5fw8w7VHhOM3Kf4cSAOpQakJydLynyPsdi9C6oZkXQ
 TZUeOKehykE2VXamGR/qCyEXKALLGpkm17079iaWStaKFhhMpRVJX8ObbSNn5QFlPeJ9
 /QQCSCi3J4lmBixTTGe30U5Geh+CA5mU4u1bEr4HzLZcvBgROIvE0+LDV/sXEEqQI7qF
 dNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8STNvO/W+/tH6mis7cVRJ3Dc57rX86y55WPHAXp51vA=;
 b=b9TKqZj36v4eXqVWXGrKP9JopIqol0b4isBHNwjihBy72H7kXgZaVkG7HckEnVBDT/
 qBuWgCoJ33bEM8lEp2+XjgGsAHrqkcF/g6yz4GDNKfkspOM/6xCJM6WJBg2rul4Rcc/h
 XAcEUzEYLe6QJQOiDtmBAV5UMUOJV42YxsF/A4j7/dH33L84RZqIPjdCSRB4DcF9zexv
 w+xsHJojlRknTlMGzekU9gwWgZ26OpfZjeKLqgUUpu33L8gprVfQvZ9V+ulJ8bASBRCP
 aVSWEoHRF1mmtTkfHMlKIMSLChkbxfVCCLiMw+M7mp4Et2BoDRA8RC8zJTOmZu0LsUcc
 3INg==
X-Gm-Message-State: AOAM532HRrI3A5UGkyseJ1YDT5LAHomjEsRhfrByF3Cl+4WKVELBBiFc
 5Dx5wbni9E/XmzDLtGP429PQV+jPy6RDxQ==
X-Google-Smtp-Source: ABdhPJxUvKbejiUbAT4D+8m44/T92Bf4fwoQkvcqyb2zCtR582bmgXPXtYeU7QXWaMMliTmrlAoIrINN/fDsIQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with
 SMTP id l6-20020a056a0016c6b029032de1909dd0mr7029829pfc.70.1632854893435;
 Tue, 28 Sep 2021 11:48:13 -0700 (PDT)
Date: Tue, 28 Sep 2021 11:47:58 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 04/10] KVM: arm64: vgic-v3: Check ITS region is not above
 the VM IPA size
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

Verify that the ITS region does not extend beyond the VM-specified IPA
range (phys_size).

  base + size > phys_size AND base < phys_size

Add the missing check into vgic_its_set_attr() which is called when
setting the region.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 61728c543eb9..321743b87002 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2710,8 +2710,8 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 		if (copy_from_user(&addr, uaddr, sizeof(addr)))
 			return -EFAULT;
 
-		ret = vgic_check_ioaddr(dev->kvm, &its->vgic_its_base,
-					addr, SZ_64K);
+		ret = vgic_check_iorange(dev->kvm, &its->vgic_its_base,
+					 addr, SZ_64K, KVM_VGIC_V3_ITS_SIZE);
 		if (ret)
 			return ret;
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
