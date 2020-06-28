Return-Path: <SRS0=lsm8=AJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31897C433DF
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jun 2020 15:05:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89FA2206F1
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jun 2020 15:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YvSTJVRa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89FA2206F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAA6D4B1AD;
	Sun, 28 Jun 2020 11:05:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I6rlgpNNLlxL; Sun, 28 Jun 2020 11:05:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF29F4B1B6;
	Sun, 28 Jun 2020 11:05:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45F304B1AD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jun 2020 11:05:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZCrVkjgvV9+8 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Jun 2020 11:05:19 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 292824B1B4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jun 2020 11:05:19 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id f139so13727546wmf.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jun 2020 08:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id;
 bh=M6lp14IRbaOYrvmLjY8eliseHrIjO9Towkcno1Q8BrA=;
 b=YvSTJVRalRDDGXlsYOHyPxnWwxcQFXkN5DHNaL2qGMoIPd4zz+zmeVnYxeUn7erObx
 gXKVbVqaIYCqc3FsERWsRFah4su85ekRkxN3/WyrJAB50ZXR8GeVcLzUMIJ8wVBSXAMz
 r5izzj5euItsTra4QqYq8Q2nL1mEX/jei7xTvmj1B21rs3m0Z39upmwWf42zMJbQk7Iu
 hNqMJrbVsfcGCtSXvP8atdbT4psq99RrTBHpl1M2ChrViJu8ZQ28gqY30ttaGRq3q5+n
 UBeJIkMPTJ8U7tdcdw6Rgv2QgnWKhnf18p1sL6r8AhEWjAnan41HHYav8uKAnGgyj+q8
 SBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=M6lp14IRbaOYrvmLjY8eliseHrIjO9Towkcno1Q8BrA=;
 b=a+gHYsz5VgD/y8uYSBepEN2XfPGXNpfbcVA5bfbie5vjkQ0xiJw36SXvwefn76BtFI
 yKrOW20WDgs5s6lJz2dugnOvpAozmymHdG9tbHSi1S98wRvPusRhQYHhA9V42rUykzvH
 LTVtj5FX+HuvJDQ29wUF56l6t1OT0tD5P4S74javGaqYjNJ5x0l4tRu8Z7sW+FLT/vQ7
 EcCY9muDydzNBfUI/qfXkOSgQcpkDkgEwrBtXRvd9PG5A6xuOcb05hXmCw8mmJ8g5AtE
 ILbFKUjbqwW6eNyVV2BaDyqLIRyIewSQcYiXYz/m8hBI3BSLB+qhBPSHSRwBa1E03wNb
 GB0w==
X-Gm-Message-State: AOAM532V0UvpsKHrH17p2Y4rE7NNENxIgRL0jm2xRooPFiOf1asoIEqu
 gXrErbn8VOWFFvVkADOlpUhmag==
X-Google-Smtp-Source: ABdhPJxaWYbSi1l7fVnH60Fr5S6YQYEdHQz5qYiFGvxnBHrKkgWEfBPcTnBlkvZU6f9lRaMHtXli8A==
X-Received: by 2002:a7b:c403:: with SMTP id k3mr8973715wmi.35.1593356718070;
 Sun, 28 Jun 2020 08:05:18 -0700 (PDT)
Received: from moi-limbo-9350.home
 (host86-139-146-71.range86-139.btcentralplus.com. [86.139.146.71])
 by smtp.gmail.com with ESMTPSA id n5sm21309350wmi.34.2020.06.28.08.05.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 28 Jun 2020 08:05:17 -0700 (PDT)
From: Beata Michalska <beata.michalska@linaro.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v8 0/2] target/arm: kvm: Support for KVM DABT with no valid ISS
Date: Sun, 28 Jun 2020 16:04:57 +0100
Message-Id: <20200628150459.18566-1-beata.michalska@linaro.org>
Cc: qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Some of the ARMv7 & ARMv8 load/store instructions might trigger a data abort
exception with no valid ISS info to be decoded. The lack of decode info
makes it at least tricky to emulate the instruction which is one of the
(many) reasons why KVM will not even try to do so.

So far, if a guest made an attempt to access memory outside the memory slot,
KVM reported vague ENOSYS. As a result QEMU exited with no useful information
being provided or even a clue on what has just happened.

ARM KVM introduced support for notifying of an attempt to execute
an instruction that resulted in dabt with no valid ISS decoding info.
This still leaves QEMU to handle the case, but at least now it gives more
control and a start point for more meaningful handling of such cases.

This patchset relies on KVM to insert the external data abort into the guest.


----------------------
v8:
 - moving the comment re support for VCPU events - missed in previous patchset

v7:
 - Rephrasing the comment regarding abort injection and vcpu synchronization
 - switching to struct initialization instead of memset

v6:
 - replacing calling kvm_put_vcpu_events with an actual ioctl call
 - making the handler function static

v5:
 - Drop syncing vcpu regs in favour of calling kvm_put_vcpu_events directly
 - Fix decoding DFSC for LPAE case
 - Add/clarify comments
 - Switch to reporting error case failure when enabling the cap

v4:
 - Removing one of the patches as it is being picked-up separately
     target/arm: kvm: Inject events at the last stage of sync
 - Moving handling KVM issue to a separate patch
 - Minor changes wrt the review comments

v3:
 - Fix setting KVM cap per vm not per vcpu
 - Simplifying the handler to bare minimum with no default logging to address
   the potential risk of overflooding the host (adding support for rate
   limiting the logs turned out to be bit too invasive to justify the little
   add-on value from logs in this particular case)
 - Adding handling KVM bug (for small range of affected kernels):
   little bit of trade-off between what's reasonable and what's effective:
   aborting qemu when running on buggy host kernel

v2:
- Improving/re-phrasing messaging
- Dropping messing around with forced sync (@see [PATCH v2 1/2])
  and PC alignment

Beata Michalska (2):
  target/arm: kvm: Handle DABT with no valid ISS
  target/arm: kvm: Handle misconfigured dabt injection

 target/arm/cpu.h     |  2 ++
 target/arm/kvm.c     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 target/arm/kvm32.c   | 34 +++++++++++++++++++++
 target/arm/kvm64.c   | 49 ++++++++++++++++++++++++++++++
 target/arm/kvm_arm.h | 10 +++++++
 5 files changed, 179 insertions(+), 1 deletion(-)

-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
