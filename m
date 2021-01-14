Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9947BC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C0D223B44
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C0D223B44
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5957B4B2A4;
	Thu, 14 Jan 2021 12:44:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id edF2DM0kI63S; Thu, 14 Jan 2021 12:44:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F1AC4B22B;
	Thu, 14 Jan 2021 12:44:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B68144B1F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 50e2UAlc4yJ7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 12:24:02 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 870244B187
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:02 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id q2so2897823wrp.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 09:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=b+Ye3TYRisrKqQrXNJpmpiFshzIGIpWbzHYw15/uGQ0=;
 b=Gf94X+SdoJcvLp9TAYUoAktCYhMbtuWD+Noeo7wo8zUCS57TWxk/68vv4/Twa7dtNP
 cP86ca8Q3ypiY8eiigVLyS6SV2aoE0Jg+S1WA5EijwTqjiiVirPmbuBBeAkBZvKr424l
 +4nXcDQV56K+L7oVwhL5BNXOkc6r3AO6wCl6bRvloxv03YQX57uVmKPZ9j+UZeR1xS4E
 WrOCSxRCTquWZgZ03DOyYKI3v5fCFHOnWod2Rog0lRRzKlrFSk/sEcSDWZ5IzuV6KMar
 LkPWSf5uGWwRCzDsEtAZyxUgqZDAYcoXfpzaVxntLiEbSbLTeE/WvaPnGTTzlkNU+9Je
 Pcfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=b+Ye3TYRisrKqQrXNJpmpiFshzIGIpWbzHYw15/uGQ0=;
 b=QJac7U1mziqvRnYok4fA058naqd+vOMb5gVxCuaNMb3f94caDuf/Yl4+fDNvegQNad
 c3ik335li3UXwYMSq0euHxusBCT8eERTD/GoKo41Hdv54SXv0Vz+pwJ0mC5aM0SRvIlm
 7DJevl2m1FSAXegTEwECRlH8jaiKuao4JVgI1XFVTIbY2P70qB0On1Ryh9R7tW06IW+S
 V6/y8X12Q8Q56KLkSZQjcDwxSVEJw2NtmpqVis6BrN9QznhT8Vc5+IMDKOAmThmPl1+q
 VGGxDpNLMLzp3qC3p0MThWJIqSAOYHPKptXrQqtBeOQdcA0gy/6HiF2q43DM2osnNnN/
 zTIg==
X-Gm-Message-State: AOAM533AKpGMwvjHDQKyDhbiw+2bwHEQSn3F83KBjdMHxzAOYDh3kBwy
 TJQnwgyj49i2/KoArrP9MTIGw8ofsEFOm+n/U/xW02C2/vZQYD29CIwYbW+88E1ccGvo8PEF1Oe
 uNJUNhskGJGrxlS4NuHr2KLZLToB8F3Ow4jdKBrRsG51DKEGfqDeSEhr2nlp2lVY2ER3yLuWu
X-Google-Smtp-Source: ABdhPJwTYAAkzYk59FnB1hjoYlusOxFpD4H7R29LpkykSS5VUOh4jh+cTktTHTd6BMVLyxsk7TTG5Gkp+fhD
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:adf:fd41:: with SMTP id
 h1mr9149005wrs.284.1610645041229; Thu, 14 Jan 2021 09:24:01 -0800 (PST)
Date: Thu, 14 Jan 2021 17:23:29 +0000
Message-Id: <20210114172338.2798389-1-lenaptr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 0/9] UBSan Enablement for hyp/nVHE code
From: Elena Petrova <lenaptr@google.com>
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Thu, 14 Jan 2021 12:44:06 -0500
Cc: Elena Petrova <lenaptr@google.com>, Marc Zyngier <maz@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
 George Popescu <george.apopescu97@gmail.com>
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

Respin of George's patch series enabling UBSAN for hyp/nVHE code.

Modification in v2:
  * CONFIG_KVM_ARM_DEBUG_BUFFER removed; __kvm_check_ubsan_buffer is
    called directly instead of via __kvm_arm_check_debug_buffer.
  * Bugfixing commits removed as these are already upstream.
  * Some code brought up to date, i.e. moved from entry.S to host.S.
  * Merged "Add support for creating and checking a buffer" and
    "Add a buffer that can pass UBSan data from hyp/nVHE" into
    one commit as these changes don't work without each other.

George Popescu (9):
  KVM: arm64: Enable UBSan instrumentation in nVHE hyp code
  KVM: arm64: Add a buffer that can pass UBSan data from hyp/nVHE to
    kernel
  KVM: arm64: Enable UBSAN_BOUNDS for the both the kernel and hyp/nVHE
  KVM: arm64: Enable UBsan check for unreachable code inside hyp/nVHE
    code
  KVM: arm64: Enable shift out of bounds undefined behaviour check for
    hyp/nVHE
  KVM: arm64: __ubsan_handle_load_invalid_value EL2 implementation.
  KVM: arm64: Detect type mismatch undefined behaviour from hyp/nVHE
    code
  KVM: arm64: Detect arithmetic overflow is inside hyp/nVHE.
  KVM: arm64: Add UBSan tests for PKVM.

 arch/arm64/include/asm/assembler.h          |  10 ++
 arch/arm64/include/asm/kvm_debug_buffer.h   |  34 ++++
 arch/arm64/include/asm/kvm_host.h           |   8 +-
 arch/arm64/include/asm/kvm_ubsan.h          |  50 ++++++
 arch/arm64/kvm/Makefile                     |   2 +
 arch/arm64/kvm/arm.c                        |   9 ++
 arch/arm64/kvm/hyp/include/hyp/test_ubsan.h | 112 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile            |   3 +-
 arch/arm64/kvm/hyp/nvhe/host.S              |   4 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c          |   3 +
 arch/arm64/kvm/hyp/nvhe/ubsan.c             | 164 ++++++++++++++++++++
 arch/arm64/kvm/kvm_ubsan_buffer.c           |  81 ++++++++++
 12 files changed, 478 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_debug_buffer.h
 create mode 100644 arch/arm64/include/asm/kvm_ubsan.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/test_ubsan.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/ubsan.c
 create mode 100644 arch/arm64/kvm/kvm_ubsan_buffer.c

-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
