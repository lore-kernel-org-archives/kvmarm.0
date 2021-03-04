Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65156C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B728C64F35
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B728C64F35
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 303AA4B39E;
	Thu,  4 Mar 2021 06:55:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wrd4YM5r5-02; Thu,  4 Mar 2021 06:55:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E81094B3B3;
	Thu,  4 Mar 2021 06:55:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC4FC4B2EC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g31Lp7zX9j5w for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:13 -0500 (EST)
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com
 [209.85.218.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4C9A4B2BB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:13 -0500 (EST)
Received: by mail-ej1-f73.google.com with SMTP id v10so12003729ejh.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=Hfz/wP17GW//DdQHHpJ3y23DvHBN61353wBiQ+oY30Q=;
 b=EkWT3nItTf1VPr+IOgUa03NVgBqlJASEmi7YHgB7MIeHcBqVMDMQfLwKzHLbMHGZ8C
 eWZZF/+BpVE2XfpBOpoacp52/I2sCNJn4t0c+aXKuwGSoVDZgw2geSQ/vCeR7UTi54iA
 Tb50hMhsT50dNNzlFz1L5aW1kS89Pr0ycDFVUexjOezhW4anaOXKJOWlTl49e9tDVq2i
 ZQhp9Dh80yJbUVyBd7W7vcNB9TTdN509A5gUuLvuwk8hh3wbpaV023SvSyTFs+8BZHrm
 1bp/BZmNRpLz/se+1ANgduLDryJDWlEfZCYVkrlAOF0wyufotLmPVUjT1d69t+/gW4g1
 lwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=Hfz/wP17GW//DdQHHpJ3y23DvHBN61353wBiQ+oY30Q=;
 b=f5N6B9zEBWGLXozN9MzuK/cPrIUUrk638lFyRJhv/2a8WXUvstMXSe9le4NIx9wD6T
 46b+ELJB8nYoYDb1om9PCVUvnohvrNuV9hV+tCeVgOYjSxo3gubtY/ab3xLCzPCaQMGm
 /28y2MunFE/1eXYD94tUHMn0pJ/Di0SYhZ33YJDyuq/O/zGKzax0T8pgPY73Y9P6C2jq
 y3pflnH5GI10vS7z6UbQJi/Pda2dTV5rVRfQEil6cnAhdfM0dK/Ep2RNxmHusQ9d//t+
 f1t/B3WnmhAtpgMJQJKqpHgPv6iswNCYDeuyfVUqJGBRPmrk5olQkdH/rGC5OHhPcx7O
 Ro5w==
X-Gm-Message-State: AOAM5338k5fpr6qrtc5PctkPErR0w7ucEBFUJIh0C7Pei3fsZej6OEKq
 nAozOc9lhEeRL3JIJrLfCi2qWB/oJet8tx2pnGSBSiXQs7fXC32Su0CJrQg3xaxotxH/xEAofFN
 M2Wa/wB3ltmGysAkkNMtEsqMvRjo4TUQ7FF4lNxUPb7GKXm6Aj6m/ozdbpUIiu7K7kRnc6w==
X-Google-Smtp-Source: ABdhPJyr/dmkwWpyrd9O3u1hYhf6Ehhl7VcNvVS0RsDtMB5galzAQdgfT4qvuI5D7D4eZDdmNlVhVdykODU=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:aa7:da48:: with SMTP id
 w8mr3744158eds.81.1614858912225; 
 Thu, 04 Mar 2021 03:55:12 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:43 +0000
Message-Id: <20210304115454.3597879-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 00/10] FPSIMD restore bypass and protecting
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Dave.Martin@arm.com
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

This series build towards protecting of FPSIMD state in protected KVM.
Most of the series is refactoring to create separation between host and
hyp for when that is needed.

There was the need to track where a vcpu last loaded its FPSIMD state so
I've also made use of this to avoid needless reloading of vcpu FPSIMD
state when that's possible. I don't know if this makes any performance
difference and don't know what a meaningful benchmark would be to
measure against so help and advice on this front would be appreciated.

The last patch in the series is concerned with the protecting of a
protected VM's FPSIMD state. It will depend on knowing which vcpus are
protected and having a stage 2 over the host but demonstrates the
trapping and lazy switching that I had in mind.

The series has, so far, only been lightly tested on qemu with paranoia
running on the host and in the vcpu.

It applies atop 5.12-rc.

This is similar, but much evolved, version of a series sent out last
year:
https://lore.kernel.org/r/20200713210505.2959828-1-ascull@google.com/

Andrew Scull (10):
  KVM: arm64: Leave KVM_ARM64_DEBUG_DIRTY updates to the host
  KVM: arm64: Synchronize vcpu FPSIMD in the host
  KVM: arm64: Unmap host task thread flags from hyp
  KVM: arm64: Support smp_processor_id() in nVHE hyp
  KVM: arm64: Track where vcpu FP state was last loaded
  KVM: arm64: Avoid needlessly reloading guest FP state
  KVM: arm64: Separate host and hyp vcpu FP flags
  KVM: arm64: Pass the arch run struct explicitly
  KVM: arm64: Use hyp-private run struct in protected mode
  RFC: KVM: arm64: Manage FPSIMD state at EL2 for protected vCPUs

 arch/arm64/include/asm/fpsimd.h           |   1 +
 arch/arm64/include/asm/kvm_host.h         |  46 +++++++---
 arch/arm64/include/asm/kvm_hyp.h          |   1 +
 arch/arm64/kernel/fpsimd.c                |  11 ++-
 arch/arm64/kvm/arm.c                      |   8 +-
 arch/arm64/kvm/debug.c                    |   2 +
 arch/arm64/kvm/fpsimd.c                   |  69 +++++++++++----
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |   2 -
 arch/arm64/kvm/hyp/include/hyp/switch.h   |  57 ++++++------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c        |  24 ++++++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c         |   2 +
 arch/arm64/kvm/hyp/nvhe/switch.c          | 100 ++++++++++++++++++----
 arch/arm64/kvm/hyp/vhe/switch.c           |   8 +-
 13 files changed, 249 insertions(+), 82 deletions(-)

-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
