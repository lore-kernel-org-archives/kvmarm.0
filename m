Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812A2C43334
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 01:51:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 409B74C6CD;
	Thu, 21 Jul 2022 21:51:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xKZeAp9ZXwB5; Thu, 21 Jul 2022 21:51:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C727E4C8A8;
	Thu, 21 Jul 2022 21:51:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E00F4C6EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4oaS+Q8-M6az for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 21:51:13 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 336814C8A8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:13 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b129-20020a25e487000000b0066e1c52ac55so2611721ybh.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 18:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=h8uEQ9pObe4PCZBHvRMWu04/OqsxiUE5izQACc/t1qA=;
 b=Ukex56V06NQTMwxsfTfflZTIhlPAb6x0ltdKx1zBysm7RfXqd7wFZZQRKyH0VzOFQr
 Y+L4jMyhTpQ+5w62O8ljEcGyetRTzpXeuJgVDGx43FYmUqMCaazs1z2HBznVt+e4xRTq
 8BTFjP0UISkfuw1zjrGHTk4NeN9Gui7Aq8k3JLm7lnIxA8ow7cBGdHuEknVOeG4Zq2jJ
 J9377HHBqBU/OmUz2MYbyVym3D1J4ix3ONzdHWHv+cgfaKXYyjSk51Fxzzm8xDa3ZIuJ
 bPVIvVXhJSKu35qiAyGNuqhVJ+94oMqsxGmrvFTR76HbL2jMIv5z7gCGfkLNOmC1jMDe
 iMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=h8uEQ9pObe4PCZBHvRMWu04/OqsxiUE5izQACc/t1qA=;
 b=K2W6ITg0b9WJ4jduKmoIa65Rncwvpe8djPNFxCZsNnVSUiRSQ5w0HwsDk64kZjLyYg
 CP4AvwTszQBnl4THLURFSULRu4hB/QYnujBiGmGOzi+7oGcxrQc3WKcXZ0MeLo3+osCN
 5EYUMVix5bJlB+31FPbCLoLT2A84eeszw4LrEXvgoctELHuRIV3HI4wSa8xWhTPbfQr5
 NZ3Wu6NS5qO0zhNW2s25LidQ6UfClH5WOc2YQOHnA4Gq1/pxokq1InfqWTwlU2LATNZe
 1RYJAs9vfyv6DQxqGMuw2Kg55wK9pVazMCIYHCq2Ox5qzXFIz7KevZnEC1OIDaSgV90C
 Hu4Q==
X-Gm-Message-State: AJIora9YtcILVHEl9wQ8RbD8VctQ2NoD9h69BIswh9DRg3xj/CTDkzdt
 5oPW62oJh71w+RpGNm8Mmdqc3O4=
X-Google-Smtp-Source: AGRyM1vtD7rOxtriQj5Ecvofp6SqMq07c0PbfEhxrYPq2ZOkp7UkUbp02IAcwvO8QMo59HdQ9f5IQn4=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a25:5ec5:0:b0:66f:b76a:c5e9 with SMTP id
 s188-20020a255ec5000000b0066fb76ac5e9mr1185482ybb.334.1658454672828; Thu, 21
 Jul 2022 18:51:12 -0700 (PDT)
Date: Thu, 21 Jul 2022 18:50:33 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-8-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 7/7] Documentation: document the ABI changes for
 KVM_CAP_ARM_MTE
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

Document both the restriction on VM_MTE_ALLOWED mappings and
the relaxation for shared mappings.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 Documentation/virt/kvm/api.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ebc5a519574f..5bb74b73bff3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7486,8 +7486,9 @@ hibernation of the host; however the VMM needs to manually save/restore the
 tags as appropriate if the VM is migrated.
 
 When this capability is enabled all memory in memslots must be mapped as
-not-shareable (no MAP_SHARED), attempts to create a memslot with a
-MAP_SHARED mmap will result in an -EINVAL return.
+``MAP_ANONYMOUS`` or with a RAM-based file mapping (``tmpfs``, ``memfd``),
+attempts to create a memslot with an invalid mmap will result in an
+-EINVAL return.
 
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
-- 
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
