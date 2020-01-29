Return-Path: <SRS0=koWH=3S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38AAC2D0DB
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jan 2020 20:25:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40F0920702
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jan 2020 20:25:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iPBw6Phm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40F0920702
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DFD84A4A0;
	Wed, 29 Jan 2020 15:25:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yj9pmbB8XGlE; Wed, 29 Jan 2020 15:25:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 541364A800;
	Wed, 29 Jan 2020 15:25:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A5314A800
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jan 2020 15:25:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A3imO7SSI9ca for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jan 2020 15:25:11 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 271204A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jan 2020 15:25:11 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id w15so1081442wru.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jan 2020 12:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id;
 bh=5PiI2JpLPXOD+rhRs9PjT8IxzU7v7C1XqbI6jKm2tH8=;
 b=iPBw6PhmDE72adZ8akd4XeUE8dJvenckql6hJ+U+FpzRpIw0sYb0RBMJe3Ea/dUkoX
 oV2abATZvmbcgmr8k/CJf+d3bn+9UvQik1a4oUu/QxQlZUrpmswocbQrt1yGdgQSwhQ3
 GMdxhiP66sQ2/uHRYyDYcilnRYlUBHdHZtVOCPwsO66wXE+ofbThdUG2ycH61acP87WJ
 AHEZPHL6ZJKi485xpU+YLrJz+T1xMS14TCBntcMs67ZQ9ySsWDb4TRc5FYlGoatscVrG
 VR4uik1p8XcWMQr9h9SLQepvSVOfKi90BsLJIgZNKKBwvygaLKE9CS6HotvVL7YXa9Ry
 Y7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=5PiI2JpLPXOD+rhRs9PjT8IxzU7v7C1XqbI6jKm2tH8=;
 b=hH+Ex43kmLshkijAdbdNP51NGrditgFmtw79Zl95fjyI2H2bH6T8Azg+fDt1p19ayE
 4cLj+ZKz0CZtV0j+t+mdCoeGV/NvFbvBpWQKJEWAQICvnQvX36dP3nBEslKNFvFAABXm
 VNFlJAyRglC0iZUuM+EYvAjsN3BZPo4wFxusSdLmsM80AcOmUcY7TiAzE8QC3yzbrUbU
 RouBSMbTUeGu7ZcdnzQP1gcIe/TBalXWA/ZsHYyzCjX+SJs1cxDJ6IftjFnogYiIrI26
 eSd08mANEWmtoK8RDfFHvy4DXAIuZiauCt0WsEW9VO/brqS/U3zHQO7KOVQUNad9D6sT
 Q/Dw==
X-Gm-Message-State: APjAAAUtbMmRaLGv4PBodVQnNW/WmuabJGgS6GrEkS46zvEzJRvMnQ14
 4Qx+UN3M7K25bXD5fPawwoOFQg==
X-Google-Smtp-Source: APXvYqzHPzyBe0Bphrsvbb0c0NUyVZ5k7zDuDZ3BqSnCCZVfmTQUu16+tksblF9fEaldbHZwvLhNOQ==
X-Received: by 2002:adf:ed83:: with SMTP id c3mr604190wro.51.1580329510061;
 Wed, 29 Jan 2020 12:25:10 -0800 (PST)
Received: from moi-limbo-9350.home
 (host86-131-78-194.range86-131.btcentralplus.com. [86.131.78.194])
 by smtp.gmail.com with ESMTPSA id h2sm4377518wrt.45.2020.01.29.12.25.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jan 2020 12:25:09 -0800 (PST)
From: Beata Michalska <beata.michalska@linaro.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v2 0/2] target/arm: kvm: Support for KVM DABT without valid ISS
Date: Wed, 29 Jan 2020 20:24:39 +0000
Message-Id: <20200129202441.12745-1-beata.michalska@linaro.org>
Cc: qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
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

ARM KVM introduced support for notifying guest of an attempt to execute
an instruction that resulted in dabt with no valid ISS decoding info.
This still leaves QEMU to handle the case, but at least now, it can enable
further debugging of the encountered issue by being more verbose
in a (hopefully) useful way.

v2:
- Improving/re-phrasing messaging
- Dropping messing around with forced sync (@see [PATCH v2 1/2])
  and PC alignment


Beata Michalska (2):
  target/arm: kvm: Inject events at the last stage of sync
  target/arm: kvm: Handle DABT with no valid ISS

 target/arm/cpu.h     |  2 ++
 target/arm/kvm.c     | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 target/arm/kvm32.c   | 23 +++++++------
 target/arm/kvm64.c   | 23 +++++++------
 target/arm/kvm_arm.h | 19 +++++++++++
 5 files changed, 143 insertions(+), 20 deletions(-)

-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
