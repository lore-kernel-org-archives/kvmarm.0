Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C25BC32771
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 03:53:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18C074B77A;
	Tue, 20 Sep 2022 23:53:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DEP49Gtcluju; Tue, 20 Sep 2022 23:53:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D0914B7A7;
	Tue, 20 Sep 2022 23:53:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CA7A4B809
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JEmeogmsSqBY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 23:53:11 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7581F4B7FB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:10 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-34558a60c39so41260537b3.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date;
 bh=4XpPYlBUoO+WRk0V0AWUxRzw3Rg/SavqF4W61Vi+Vh0=;
 b=YI9YTrZeD2JX0QYLMS9rcEsnQKi2nn+tGC4bgSYbMP88F+TWT+sfC+ABpLRV9kABWZ
 7IgDYo1oeJdskEllVO50FzDiU7l7NtZW1ZjvRXgSBWwB/twXdM9CImyLjjepysc2aCFF
 FWhGgsOWXR8PXvJ5fSv5UJ+XWR3aq8m1fg37xeWmB5zdYkFPeDIHXAFb5eSxTKhotk9m
 SfDuXaI4J1IeLrvxsbOHF/LjFdfqyDNhi/bZh+cl4Y90aJQb1S845E1VB7M3fjogATDm
 1Iz7A82xrGtHr6v7V+JxrTSyfqLLEVxoCFAz+Ju1mqkNGkX9SSPkaQJgWyaHt7R1fdhA
 7Ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=4XpPYlBUoO+WRk0V0AWUxRzw3Rg/SavqF4W61Vi+Vh0=;
 b=qm7sochWR0dGxhVxQbeZxEs5WCkgDzcxOZD9hzTmxuub+zfURxh/zFYqgnYqNB/mzq
 7j2hz+2y42I0i55PyaC8VDB1UkKMBnqchk6pBAIGyShfDfJMIdO8HGObjWkE+1/DPnPp
 K1hw8ercyWRpO5zQUq91bgv+MGogs5qAqU5aRRwxihlxQxfpCcYYCFtEUiSH2FWYTCN0
 GsiaaljUakzfVkypAopnXHcDmoJ34sjwfjbce3up2X9ONI5fAAM2uXvYOdry6Pzw3fV2
 rZzjCVRXh0gxHmgDOxBloRemvrIgAYR+gEhPUaRTZQMBLmzOp/ycpkIfaXgm61bxy7As
 szhA==
X-Gm-Message-State: ACrzQf1gXUT5LiIpgi8b4EpVK8bpgB7A4xs3o1lvA40x1Y0U90d8Td+l
 qzCnbTVFK9M1ZQ4IoaTyK2LAhb8=
X-Google-Smtp-Source: AMsMyM4h7TI5G+sFMd7rTrrgzthVtJC4/9i0nc1N+1MngQu+uhxfzMb9nU4Ew6v+tvv2pLYsS0wjV3c=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a5b:a0c:0:b0:6b4:446d:2f9 with SMTP id
 k12-20020a5b0a0c000000b006b4446d02f9mr9242835ybq.138.1663732390317; Tue, 20
 Sep 2022 20:53:10 -0700 (PDT)
Date: Tue, 20 Sep 2022 20:51:40 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-9-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 8/8] Documentation: document the ABI changes for
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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/virt/kvm/api.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd7c32126ce..7afe603567fd 100644
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
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
