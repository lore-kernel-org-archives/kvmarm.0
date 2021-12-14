Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D68C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 17:28:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C52AD4B214;
	Tue, 14 Dec 2021 12:28:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gPEvqOLRvRtb; Tue, 14 Dec 2021 12:28:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41FC14B201;
	Tue, 14 Dec 2021 12:28:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB01A4B1F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E9AObv0STs+s for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 12:28:17 -0500 (EST)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E1194B1B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:17 -0500 (EST)
Received: by mail-io1-f73.google.com with SMTP id
 k6-20020a0566022d8600b005e6ff1b6bbaso18380132iow.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=zk8b273QnCh6EBKHsBLZCwm7phsH1qXNNxAFMztBRMQ=;
 b=Z1p6iB38u4qCLN3DR6XCPMSeigD1Z90OlOv79x1GPPrkP/Zle4CFrX7F1AkqkyLyv7
 pTfAm2sxx5KBGsVYl56DkuvF8sus9B08ph5GevUidg2bCb2erwD34UEBUPgQOLv2mcgR
 ttlLQ+aDL8Y+RBNggNyu2CUQAdU88fB6nPfi8d7KDMjMMZQ8uVCn5U/6ZJr8yehKvQq0
 YK4s3ktTyMmfdGY1232w6DsMQ2PcXxxJkoJxHs+J6kv9Z3xtxkjSTBPdaELbVMwVRRj6
 Vpp1uDVLDs+pDeM0HqOS9PL1A9Jajy0DfNyDpiCp0whq9oBBQx135HKMKyhmTo12gaXb
 NmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=zk8b273QnCh6EBKHsBLZCwm7phsH1qXNNxAFMztBRMQ=;
 b=4COzWuuvzK6hBtFB/DEG5xV87UyoOMs9FlBz9CyIcO+Im0i+GWxk74zckyF8MW9ftO
 HHcwmuA37GrqCLQ4cmHsaECfjXEzb6wdnputsaVGbbAHiiESCS3Gj0eAiAwjH0YTMlxC
 JdZ4c8Sod2E5oxLCmc4POm/+bs2y79KhZ0GfuSZVv8Y0G1M+enFRgW56C3IgyrgbISmf
 tMjes5ZhwaqE18mFBhDhMe/e7PQt7zzRwWXyr0KPqYltyPmtrOCpi6m3CpG8iZu11j5X
 ETQNm12//NeYiyjMwAIA53T/wdiTLd3Ce+Lzr+wmGenHgSw1T5jQJ1KL2ZDw2TOPVlZm
 8xwA==
X-Gm-Message-State: AOAM532MM/g+xxPFyV+72unHCdMkxbnK4LCma3tYUMqO1DuwQ+3paFRU
 omRCGBWITDJrIzDo8EgRyedCpbno1QPgwyA8lu6mzRNnssOuwQOeCn2RweQhLuUt5pHLGaqpiFq
 c7dFCNo+w49XGDlOAJtNm44aM20BO73aOFL9Wpo3rhZuRWpwwLMo+a5TiY3zBgn0697EpnA==
X-Google-Smtp-Source: ABdhPJwm2kW1tWIdTafhk7By1Qz8hjfZFCojXCQPPWKGX9iyHrDuiA02tnU4jkY+2HaL5PjwP1IH8HpANww=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:8747:: with SMTP id
 d7mr4479540ilm.203.1639502896974; 
 Tue, 14 Dec 2021 09:28:16 -0800 (PST)
Date: Tue, 14 Dec 2021 17:28:06 +0000
Message-Id: <20211214172812.2894560-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 0/6] KVM: arm64: Emulate the OS Lock
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

KVM does not implement the debug architecture to the letter of the
specification. One such issue is the fact that KVM treats the OS Lock as
RAZ/WI, rather than emulating its behavior on hardware. This series adds
emulation support for the OS Lock to KVM. Emulation is warranted as the
OS Lock affects debug exceptions taken from all ELs, and is not limited
to only the context of the guest.

The 1st patch is a correctness fix for the OSLSR register, ensuring
the trap handler actually is written to suggest WO behavior. Note that
the changed code should never be reached on a correct implementation, as
hardware should generate the undef, not KVM.

The 2nd patch adds the necessary context to track guest values of the
OS Lock bit and exposes the value to userspace for the sake of
migration.

The 3rd patch makes the OSLK bit writable in OSLAR_EL1 (from the guest)
and OSLSR_EL1 (from userspace), but does nothing with its value.

The 4th patch actually implements the OS Lock behavior, disabling all
debug exceptions (except breakpoint instructions) from the perspective
of the guest. This is done by disabling MDE and SS in MDSCR_EL1.

The 5th patch asserts that OSLSR_EL1 is exposed by KVM to userspace
through the KVM_GET_REG_LIST ioctl. Lastly, the 6th patch asserts that
no debug exceptions are routed to the guest when the OSLK bit is set.

This series applies cleanly to 5.16-rc4. Tested on an Ampere Altra
machine with the included selftests patches.

Oliver Upton (6):
  KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
  KVM: arm64: Stash OSLSR_EL1 in the cpu context
  KVM: arm64: Allow guest to set the OSLK bit
  KVM: arm64: Emulate the OS Lock
  selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
  selftests: KVM: Test OS lock behavior

 arch/arm64/include/asm/kvm_host.h             |  6 ++
 arch/arm64/include/asm/sysreg.h               |  9 +++
 arch/arm64/kvm/debug.c                        | 26 ++++++-
 arch/arm64/kvm/sys_regs.c                     | 74 ++++++++++++++-----
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++-
 .../selftests/kvm/aarch64/get-reg-list.c      |  1 +
 6 files changed, 151 insertions(+), 23 deletions(-)

-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
