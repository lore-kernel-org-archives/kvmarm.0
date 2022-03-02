Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA16C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 19:42:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAA0F49EBB;
	Wed,  2 Mar 2022 14:42:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wPUXNVV64I9q; Wed,  2 Mar 2022 14:42:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B018249E21;
	Wed,  2 Mar 2022 14:42:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E277E49B0A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 14:42:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NtOJvvW2gUWO for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 14:42:25 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C126F40B03
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 14:42:25 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 m24-20020a6bf318000000b00645106b7dd5so1945536ioh.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 11:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=cX9WA5df082MaL6YQlObveNXhOQwwbEGGIC69Id9Gd8=;
 b=DeCwmX4IQwXit+I4vJycRK3mJTydJiAMZ5u/Epji9xY36tHN77sj0TZMuqTcgHp3gr
 QQArSuCtgV4Wmewc5HUQ5EmfrpPi3aFvtKtJ8oV53190c98VQKRRZUP6BwuNaLhuHyGB
 SPDBTvicndkXq6Hrfcj97oBaEfV/R2jFCURX2GujZc6+KuSSMl0UWz4h4Z6GobKaO3Dn
 24XBkZx9pPlLPBLCsKrOT1wZytLdqAaxKeyYKcDY3A8x7rznte9sM8NSWJAnl6khoyN+
 A3jEzjOTmtyov1x4JUBaO+2eQWfpO17V+1wYAoWPtJcRlQviT7iSuuZeTETXINMjK69e
 /cqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=cX9WA5df082MaL6YQlObveNXhOQwwbEGGIC69Id9Gd8=;
 b=gt2LwGsXrWJkbA09f9/ulCW86Co/m6BEhGnms0eXsoqBnzgL6Zh71fCTFoQu7YJ74L
 TRQVUhAm+uUhwfsS8N1dQV7AaHyR2MCsTpiBYwn1V3HHS7QO8E5wD9sAcu4rYUgUhBUc
 NyHVzj8/Z0bDPO90KGIUldQCxVwqe2Hv/8FGFO7UTyGMpd5qek+bxEIaXqrNTGi9P+n8
 Cul0PMvXgZhejSXxIcfieI/K+UrPhaj4q4CAPzR8v8zRORh64QR3bY/ni5YFgIiQnHub
 mRxV3puAdjGxiw4p6b0KAEF3JKIVKAhoOlIzrl64q1eNWR6DhrzkqT+HQq7Gf6sHjitb
 BDlg==
X-Gm-Message-State: AOAM5329WLpZtIclfMcP00h1lTo9MbHmqv0yYpGgQQvOdZTIxp/8WFGz
 IerPsUGalGXbhc3pfGwu+XGm1rvDFDfijhGsnIBfHR5A5a92J7rMb1ueViu0cIlZLNERz7Xy07/
 KV0JMoYLcHMeV6G4evDtSn73DqojC4JWcA4LkzTUSNyzJJJtCH0Gt4bUFJLIe2T8P45E6oA==
X-Google-Smtp-Source: ABdhPJwvAURYuPUp4x9tRcIbgIK9XdrrzeX9a3e6SVZt4KQcoiT01lrx/qVGcIwMY+2QKiijsg/EXb087kA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1e0a:b0:2c3:fb26:e6c3
 with SMTP id
 g10-20020a056e021e0a00b002c3fb26e6c3mr7257384ila.100.1646250144967; Wed, 02
 Mar 2022 11:42:24 -0800 (PST)
Date: Wed,  2 Mar 2022 19:42:19 +0000
Message-Id: <20220302194221.1774513-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 0/2] KVM: arm: Drop documentation of 32-bit KVM
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

KVM/ARM is no more. However, there are several places in the
documentation that reference 32-bit host support. Align the
documentation with the present state of KVM by removing all references
to the old KVM/ARM.

Note that AArch32 guests are still supported.

Applies cleanly to v5.17-rc6.

Oliver Upton (2):
  Documentation: KVM: Update documentation to indicate KVM is arm64-only
  Documentation: KVM: Move KVM/arm64 docs into aptly named directory

 Documentation/virt/kvm/api.rst                | 83 +++++++++----------
 Documentation/virt/kvm/arm/hyp-abi.rst        | 77 -----------------
 Documentation/virt/kvm/arm64/el2-abi.rst      | 75 +++++++++++++++++
 .../virt/kvm/{arm => arm64}/index.rst         |  8 +-
 .../virt/kvm/{arm => arm64}/psci.rst          |  0
 .../virt/kvm/{arm => arm64}/ptp_kvm.rst       |  4 +-
 .../virt/kvm/{arm => arm64}/pvtime.rst        |  0
 Documentation/virt/kvm/devices/vcpu.rst       |  4 +-
 Documentation/virt/kvm/index.rst              |  2 +-
 9 files changed, 125 insertions(+), 128 deletions(-)
 delete mode 100644 Documentation/virt/kvm/arm/hyp-abi.rst
 create mode 100644 Documentation/virt/kvm/arm64/el2-abi.rst
 rename Documentation/virt/kvm/{arm => arm64}/index.rst (76%)
 rename Documentation/virt/kvm/{arm => arm64}/psci.rst (100%)
 rename Documentation/virt/kvm/{arm => arm64}/ptp_kvm.rst (94%)
 rename Documentation/virt/kvm/{arm => arm64}/pvtime.rst (100%)

-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
