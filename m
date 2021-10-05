Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AA7C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF7ED61401
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CF7ED61401
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83A084B299;
	Mon,  4 Oct 2021 21:19:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AyRCnxdC0Ldr; Mon,  4 Oct 2021 21:19:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC8694B2B9;
	Mon,  4 Oct 2021 21:19:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14FBC4B2BB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3LJTXduhDR+5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:31 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65AF14B1F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:30 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 x16-20020a25b910000000b005b6b7f2f91cso26243805ybj.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xl+JM51DQgbfallo08wfmsOs83iQ7ZmJKM3bqS9Rg80=;
 b=ACyxOvGJNJ/NV7aFVA2v8u3c9Hf+IHSFlCixQBLv4NGV5jGHsoIUVkvmuoZDIa6hwF
 ptuGSBXeCteSoDg8JLQ5z+Hm5rgxwYGdOjgOyyG6PxyWwrbSHSz/otcscd3V4akBVAeH
 zDa/YosAJcnG3ZoWIX5UH501yW5u4Jq0lVTDuExVgXcOrO1sgmJ8O79J7x/wi6FPLWkZ
 VJDqnsN8IpppfcrVeBCk8R04m0GWyYH5qC22UxYo/iQiSs0BmXMtrXmTymovuJ5yIHf8
 c70QcNdMAlNuVLLAf6zcmfOhd0nF+0YsjAsND+4WEmiqRu4FShbvseHuuAm8xa4HRqaE
 s2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xl+JM51DQgbfallo08wfmsOs83iQ7ZmJKM3bqS9Rg80=;
 b=w9Asc+4W/BU02yCBjEkoJnTRE/QgiOF2D1ZQ3x3fakHA/BLtEOHm7AeRS0rvrBsHqz
 PWzZZS+c3N+zR/hniM2IPv9eJfZsuX3tL8cNL67L4wcANW+gqF3iC4TvW9vq469i/FLt
 Qn1S23L8jy1u9jqpt3a7xQhmCb841ZppEbCyowsNM2XblrH99oMIhDcqEF2oPHTtd9K3
 dgd6CcBJ8MNIjIATe7XCDHJiVl1EUa9GFgo2XAn3gdCcd9ewswwk7dYkB8Z3JmFuY3nM
 GOytrXddLc5kR4gCe7T5EUPo/9rxpGo4ybYff4mzecZ3d/bCgbu4QZbZ/c2ZkGT40LVB
 ghWg==
X-Gm-Message-State: AOAM532wXEhSJBDRWcCwxxpR3LtnIQo8ZH9liJ0eD8RA81YOQVg6hVMu
 W4lqLEWtd9iu3u9UqqV4Q+VAPSeEAlIIrw==
X-Google-Smtp-Source: ABdhPJxq8mn6fuMbbdu1h5R7+zyV5d25xOeWf4zul6b0LU+hwH25JEt9XvBSD8OaMKnqhafSgAtnacns6f3GUQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:afcf:: with SMTP id
 d15mr18248796ybj.320.1633396769892; Mon, 04 Oct 2021 18:19:29 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:14 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 04/11] KVM: arm64: vgic-v3: Check ITS region is not above
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

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 61728c543eb9..ad55bb8cd30f 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2710,8 +2710,8 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 		if (copy_from_user(&addr, uaddr, sizeof(addr)))
 			return -EFAULT;
 
-		ret = vgic_check_ioaddr(dev->kvm, &its->vgic_its_base,
-					addr, SZ_64K);
+		ret = vgic_check_iorange(dev->kvm, its->vgic_its_base,
+					 addr, SZ_64K, KVM_VGIC_V3_ITS_SIZE);
 		if (ret)
 			return ret;
 
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
