Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92203C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E33E6152B
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0E33E6152B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8162D4B2A4;
	Mon,  4 Oct 2021 21:19:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FneA91+XVnMr; Mon,  4 Oct 2021 21:19:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5F94B2A7;
	Mon,  4 Oct 2021 21:19:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C9D4B277
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sv0LOhqXktjD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:24 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D6B64B1F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:24 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 x28-20020ac8701c000000b0029f4b940566so21834340qtm.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=+Xq4ieF79Hu5t0nEenR0yeDcfTGhycSUF4gpxiOxUYo=;
 b=nnDSuIoHAfanSEj2WNy7oPNPLqfy+1x7rjHR+af7cQksG884Qn7u7QWI53zxXmRL4w
 pWDS+E539GppvAkqZ0pdcq5mx6hyrjp+aTkPu8ZltgwC1chkZR/Xthe4oKbQu3B2WyhF
 aM3OE8K0jJ6QLugCKjQ7HzneM+VR/btro557en1Q/eqjXHMl4guwWmuOYFmxvyevQqdD
 AplBjVSPbTT9u95eoUhke1P0D4mxxOaQ1jTAU5YAXYLsvRlIJHrXRaZ/5Q/WHzutOaQa
 /ApyixCzjH9Z/AIL26kuLVvz+LuEZk2XgPwCTQbJAN6LgYrym6KsGKXVSZ8tktcKEepe
 yEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=+Xq4ieF79Hu5t0nEenR0yeDcfTGhycSUF4gpxiOxUYo=;
 b=GOhagGhdDak25F2Sv/lKgrvksXYIRtdI66QMyMW1xnyvVcldauV1jqIH5FJUAZeUhs
 C9mUFwAsd2Mv0+2/F9oxTmHtsMywcUc72JaBvZ8EPy3VXbe+cU6RVSdRvj/edScyQILR
 HQiYuXLNK01W52Hvq65JwGDqJwQQYE2UP/O1k0GAO39o51fTmWL0VGe2aieMy7HYp4S4
 83RCPwcRhUhAE/tBxjbbK1fKq4bVS09jRJLw0OIo4at668LJGJiSANE9gz9CU72HpmVp
 fI0QciC5/MDLCTS/SDjQxCjvQv7qsJWTcPBQDWDpIWNS6gjiRXdC8Chd5Qb/ifIomYAG
 iSxA==
X-Gm-Message-State: AOAM5338KrwjX6gwp9M6FJbQCd3UITgunmHElcUyyfWIZp0H3c69Xtpd
 2qxsxgLWz6CnyTyXTFH5MkFSwsl+I7CQFA==
X-Google-Smtp-Source: ABdhPJzFw/sz3sZ2EUwtotAzAzKfu65MaG03b8HZKr9el2QVmz+8eBTzv5wSBtqXxzSDzMzDZRsguBh0KNE9ng==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a0c:9d4d:: with SMTP id
 n13mr25322131qvf.40.1633396763877; Mon, 04 Oct 2021 18:19:23 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:10 -0700
Message-Id: <20211005011921.437353-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 00/11] KVM: arm64: vgic: Missing checks for REDIST/CPU and
 ITS regions above the VM IPA size
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

KVM doesn't check for redist, CPU interface, and ITS regions that extend
partially above the guest addressable IPA range (phys_size).  This can happen
when using the V[2|3]_ADDR_TYPE_CPU, ADDR_TYPE_REDIST[_REGION], or
ITS_ADDR_TYPE attributes to set a new region that extends partially above
phys_size (with the base below phys_size).  The issue is that vcpus can
potentially run into a situation where some redistributors are addressable and
others are not, or just the first half of the ITS is addressable.

Patches 1-5 fixes the issue for GICv2 and GICv3 (and the ITS). Patches 6-11 add
some selftests for all these fixes. While adding these tests, these add support
for some extra GICv2 and ITS device tests.

Changes:
v4: better vgic_check_iorange, drop vgic_check_ioaddr, minor changes on the
    selftests patches (better comments, title).
v3: add missing checks for GICv2 and the ITS, plus tests for the fixes.
v2: adding a test for KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, and returning E2BIG
    instead of EINVAL (thanks Alexandru and Eric).

Ricardo Koller (11):
  kvm: arm64: vgic: Introduce vgic_check_iorange
  KVM: arm64: vgic-v3: Check redist region is not above the VM IPA size
  KVM: arm64: vgic-v2: Check cpu interface region is not above the VM
    IPA size
  KVM: arm64: vgic-v3: Check ITS region is not above the VM IPA size
  KVM: arm64: vgic: Drop vgic_check_ioaddr()
  KVM: arm64: selftests: Make vgic_init gic version agnostic
  KVM: arm64: selftests: Make vgic_init/vm_gic_create version agnostic
  KVM: arm64: selftests: Add some tests for GICv2 in vgic_init
  KVM: arm64: selftests: Add tests for GIC redist/cpuif partially above
    IPA range
  KVM: arm64: selftests: Add test for legacy GICv3 REDIST base partially
    above IPA range
  KVM: arm64: selftests: Add init ITS device test

 arch/arm64/kvm/vgic/vgic-its.c                |   4 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  25 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |   6 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |   6 +-
 arch/arm64/kvm/vgic/vgic.h                    |   5 +-
 .../testing/selftests/kvm/aarch64/vgic_init.c | 366 +++++++++++++-----
 6 files changed, 298 insertions(+), 114 deletions(-)

-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
