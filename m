Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDACC0044D
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 00:34:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 540B8206B1
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 00:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LZ24bt60"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 540B8206B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 772EB4A4A9;
	Wed, 11 Mar 2020 20:34:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DMBgF5dxTycH; Wed, 11 Mar 2020 20:34:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75A2F4A4C0;
	Wed, 11 Mar 2020 20:34:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7B84A4A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 20:34:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ixVdVnbSCwCo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 20:34:31 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68EB64A1B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 20:34:31 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id x11so392912wrv.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 17:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id;
 bh=o4wfwFzslWSogfShuzT1GXszAi31gOgslMZWdjvKfVo=;
 b=LZ24bt60gTmcfYWHhCsEWR4BHFJlkp3DexMhVT/j5ERjOXSeJ37pMmiuMRlvTyT7HK
 JqpQwkpYsoYVg3uGyXCiVNaquC3kh6E1EVRQ952U+YKVIwfRqXBsUz6VmM94LX0p0oBh
 nRI/aGFhUkoPn4hMALZanetw/RwDSngToHjwFpqPCujnSOAxmkiyj6G/8adAECNCDw8E
 q8w1NVeD/wH3ifi2WPvz6qL7utV0dSr2gvuV48lPi2cAL5ZY6jegHjElhMBSsNleheVB
 +gOjMLxEUqWPZ9ZNmQX7fffkC2dMnRioNxTEI2iZx3NP+9XvKBxojtF3/fKZ7IZYPh4g
 8v0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=o4wfwFzslWSogfShuzT1GXszAi31gOgslMZWdjvKfVo=;
 b=MV/AWS4v3udovZjjL3zn9LI2j+aPPpA68DX7xidDTnVEJJ4kAS2u1fXLnXFQWdLXxM
 rw4b6frQq9SSxQqByJM0Unga274gSu/WdlhVDLKyIzKNl3ouvUzqNkUE5JCNccxrOV8q
 i6JV0+ttYgp034FIf82uhSeS1TH+4T8hVF2ZdxZB/zWrBQXcNil5/h3gGwfVZsz68POT
 D2CdAwWm8bzgY21Ef2oOCs9eg6hW7u1FebQes0OxdZmbOXscTWM+jlduMEDkgm4ODeuF
 OieqzDcCzpdQzvtan61TdaLkDje7HQa8txPDfUIiNtQP8PHw9iT0XwTa5SD2ARrjw4t7
 40Iw==
X-Gm-Message-State: ANhLgQ3jB0VPKmbGFfm4d2F9nmRHheuth3ilu3mlg6oqOceIgJkID5Jl
 J9JsJaaz1pAaaWgVoHo2uK5zow==
X-Google-Smtp-Source: ADFU+vt+E4lrioPh1o0AmDdDMyHFD+dBDBxBKjY6ZhFem7kPpgR30rCCSCoB7F1MEwVLdmqsXmPQ8A==
X-Received: by 2002:adf:94c2:: with SMTP id 60mr7155516wrr.396.1583973270323; 
 Wed, 11 Mar 2020 17:34:30 -0700 (PDT)
Received: from moi-limbo-9350.home
 (host86-139-146-66.range86-139.btcentralplus.com. [86.139.146.66])
 by smtp.gmail.com with ESMTPSA id o5sm10909988wmb.8.2020.03.11.17.34.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 11 Mar 2020 17:34:29 -0700 (PDT)
From: Beata Michalska <beata.michalska@linaro.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v3 0/2] target/arm: kvm: Support for KVM DABT with no valid ISS
Date: Thu, 12 Mar 2020 00:33:59 +0000
Message-Id: <20200312003401.29017-1-beata.michalska@linaro.org>
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
  target/arm: kvm: Inject events at the last stage of sync
  target/arm: kvm: Handle DABT with no valid ISS

 target/arm/cpu.h     |  3 ++
 target/arm/kvm.c     | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 target/arm/kvm32.c   | 41 ++++++++++++++++++++++----
 target/arm/kvm64.c   | 51 +++++++++++++++++++++++++++++----
 target/arm/kvm_arm.h | 22 ++++++++++++++
 5 files changed, 188 insertions(+), 10 deletions(-)

-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
