Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12841C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:57:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F33F49ECF;
	Fri, 11 Mar 2022 12:57:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5pQZxlyHf+ZI; Fri, 11 Mar 2022 12:57:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84E5049EBD;
	Fri, 11 Mar 2022 12:57:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7FCE49ECF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HeOHXcOV2Dgg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:57:26 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87FB449EB5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:26 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 190-20020a2505c7000000b00629283fec72so7944945ybf.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XCuvtprnSb0PQ/tTeAtCenAIJT2ThbfBVkwuYC3SZPg=;
 b=kt7/mh7D7/XK6jC/qxq5AKckTCsDG9s1vf0i5tSAGW3qW+PMa+EbHCv7HEUNbZqBhn
 yWZM0d5kwmCn3UPnOiteAwCNH/RHYa1o5c1R5jo8a2mbiVT1BlQdcX08fWiKdTf3inGd
 /wA2Nspc1mpYoqG3077m2DcigYRNrisUBQxjc+WR8l6t9YyToIDr1FoyvzRozet51MAp
 WDbs7eygrxtaCKkB07ogoj7KfiS02MArxQf8AGUZemcSUnL+eKAi/V2jj/IgENgEnisM
 1AWYtPsvAfBxtwunoa98mEFgtQK3j9S0fT466vXE3yggcKERk61aovGUFw/uZZyAQ3CX
 5DFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XCuvtprnSb0PQ/tTeAtCenAIJT2ThbfBVkwuYC3SZPg=;
 b=ZQ6HpYPd96+oU4e1f1yprKFu6k2KU62qbe+JFA8fFzGrkNBHAiA7xeNrezf+Li5wiN
 FiMTrUShdVw8lFAiQCFjTIeB6c2KticbD8GLcSXqi0ot1WNwuhK55yC+ut6cwcI65gHp
 AzzdaXj4PqEilrnI8T7e4MSueqpsR0xd3+g3z8cl/EqWaaCMg1gt+DIopmLRPURyEoxa
 /TgJIBbCJHXgFetVPVXlbC7fzZWjro+kFTbj2+ogLnG4yhJIdR4Rd+jx5RaXl+w/2/po
 fDwblmv71KyTkwD79yXX/uPKgvNvHOiOZuMq/lZykhOE+whVHMwjSbUIVJRMjbXL6AeH
 1qdQ==
X-Gm-Message-State: AOAM533msHrRH3s5BwdMF2thAf0qrPXMKc4n6cA7R1mG64LnNgQ4OEcB
 t9rauAdroRiuKRNwsRgraRIPqgmhOECHgRK/BKuDvVMFQUlW/DuGbClO7FFe3KuVYoKdnRBSSOt
 2daSoVLnwVAtLBG0jrVMOt+tXKGaz/p53jIqJ8/gsWd3ckaUh8dYohpNpzXrW/i5LT+oKJw==
X-Google-Smtp-Source: ABdhPJzyWAv8S/KHu/ZXZs/nZFoiMKCNOwLwIUWaIPx4cyu6tv+ii6X96+maMdMohSISaf+E5F1ZO7oskvs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:fb05:0:b0:628:8c88:acf5 with
 SMTP id
 j5-20020a25fb05000000b006288c88acf5mr8952224ybe.187.1647021445912; Fri, 11
 Mar 2022 09:57:25 -0800 (PST)
Date: Fri, 11 Mar 2022 17:57:12 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311175717.616958-1-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 0/5] ARM: Implement PSCI SYSTEM_SUSPEND
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
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

This is a prototype for supporting KVM_CAP_ARM_SYSTEM_SUSPEND on
kvmtool. The capability allows userspace to expose the SYSTEM_SUSPEND
PSCI call to its guests.

Implement SYSTEM_SUSPEND using KVM_MP_STATE_SUSPENDED, which emulates
the execution of a WFI instruction in the kernel. Resume the guest when
a wakeup event is recognized and reset it to the requested entry address
and context ID.

Patches 2-4 are small reworks to more easily shoehorn PSCI support into
kvmtool.

Patch 5 adds some SMCCC handlers and makes use of them to implement PSCI
SYSTEM_SUSPEND. For now, just check the bare-minimum, that all vCPUs
besides the caller have stopped. There are also checks that can be made
against the requested entry address, but they are at the discretion of
the implementation.

Tested with 'echo mem > /sys/power/state' to see that the vCPU is in
fact placed in a suspended state for the PSCI call. Hacked the switch
statement to fall through to WAKEUP immediately after to verify the vCPU
is set up correctly for resume.

It would be nice if kvmtool actually provided a device good for wakeups,
since the RTC implementation has omitted any interrupt support.

kernel changes: http://lore.kernel.org/r/20220311174001.605719-1-oupton@google.com

Oliver Upton (5):
  TESTONLY: Sync KVM headers with pending changes
  Allow architectures to hook KVM_EXIT_SYSTEM_EVENT
  ARM: Stash vcpu_init in the vCPU structure
  ARM: Add a helper to re-init a vCPU
  ARM: Implement PSCI SYSTEM_SUSPEND

 arm/aarch32/kvm-cpu.c                 | 72 ++++++++++++++++++++
 arm/aarch64/kvm-cpu.c                 | 66 +++++++++++++++++++
 arm/include/arm-common/kvm-cpu-arch.h | 23 ++++---
 arm/kvm-cpu.c                         | 95 ++++++++++++++++++++++++++-
 arm/kvm.c                             |  9 +++
 include/kvm/kvm-cpu.h                 |  1 +
 include/linux/kvm.h                   | 21 ++++++
 kvm-cpu.c                             |  8 +++
 8 files changed, 283 insertions(+), 12 deletions(-)

-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
