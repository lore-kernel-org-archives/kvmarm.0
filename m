Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7571C433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 14:19:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3648264F7C
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 14:19:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3648264F7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CD2D4B26D;
	Wed,  3 Feb 2021 09:19:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mq9QB0V8AntG; Wed,  3 Feb 2021 09:19:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 870F34B275;
	Wed,  3 Feb 2021 09:19:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF0DE4B270
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 09:19:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XgOSIQXOnHmR for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 09:19:36 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F0074B26D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 09:19:36 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id u15so1667852wmj.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Feb 2021 06:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=2YqmStJHtmDLb9ca8pHnXTtS9p5W2yatBMAuEkk2twc=;
 b=swt8i8oh/CahxjCm1i2LWz1PAhEJPYcgCpXP0sqxpm2LUsKOEQR/Tv0qTZc/ayZXro
 fM/xy/OMrvadN/XfZfFqE9II1fKG4oA2GlksIBodsSYBYT2mQdY2QmCpAWh+A33rzzL5
 GBiuyPnm5s8VHkJgbxLVNkw+yIUI3Zicnnyitub/KQvWRFCUrkmL+zNaLx2zGrWCUXaC
 VxvambATQYjvSZI9oXIdrBvrKIuvZMvY2pdDM60IB/BE1kKNHUXBK29B6uGPOMVY+nc5
 fvb5tienhYATycUO0iLqHIzDap95urS27UIbmZIvUgzX0u7Xs21ZzMPJLuQDzcL3a4Gs
 0Hwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=2YqmStJHtmDLb9ca8pHnXTtS9p5W2yatBMAuEkk2twc=;
 b=Dgh90UUbb1mcb/TOcSzo8ejFU/9gLXFWLFRgzF6403uRgfFE5O+SuUOi4WtqahjKd5
 oT9axtuUaSkPnxA5HioAwWtK3E03wF+YpIgt3+UH/SBluNcYVG9ugD2FuH8txhh8RZLv
 j6h+G93wdH8MSg1sFgKG+Fyph0AgrDTJtdJxUd8zMQES6wzXe19G1DXb4eETfh87oW9l
 QCRpaT/sPAJWCugsrMQnktVF1OOfHKyKDi5XcczihWh9r+A8JiWbRol9zJJe/Ef95C45
 CJHF2injZ/RF5FP0Q9ugNs0f/jS8kCZx1oKD/JH0qdfMZz0L2EO02BHyA5a3E/El+dZt
 WcfA==
X-Gm-Message-State: AOAM531Jmq7b0+rw+SWt+WNuWvjbRxAfPKkMMuDYkPKHCoRaRhRP3XuF
 LAAKPqUq/6PH3u5/yVPNcQQMFc7GYKww
X-Google-Smtp-Source: ABdhPJzQ47fLWpATF9oviOBeGLZ6a+5wZlOoYomkHouoJDdnNHFlCRVtBHfc0HOJyC8UgG5y/ze+CK1Gxa5x
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:4303:: with SMTP id
 q3mr3048441wma.3.1612361974461; Wed, 03 Feb 2021 06:19:34 -0800 (PST)
Date: Wed,  3 Feb 2021 14:19:29 +0000
Message-Id: <20210203141931.615898-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 0/2] KVM: arm64: Stub exports in nvhe code
From: Quentin Perret <qperret@google.com>
To: arnd@arndb.de, maz@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, ardb@kernel.org
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

Hi all,

In the context of the currently ongoing work to remove the host kernel
from the TCB under KVM/arm64, I have been trying to wrap the host kernel
with a stage 2 page-table -- see [1].

Using this infrastructure, I attempted to unmap the .hyp. sections from
the host stage 2 as it really shouldn't need to access them. But by
doing so, I realized quickly the module loader was getting very confused
by the usage of EXPORT_SYMBOL() macros in library functions that have
been pulled into the EL2 object, and that we end up linking modules
against the EL2 copy of e.g. memset. And so, this series essentially
tries to fix this.

 - Patch 01 changes asm-generic/export.h to ensure we respect
   __DISABLE_EXPORTS even for asm exports;

 - and patch 02 makes use of it for all of the nVHE EL2 code.

This was tested on aml-s905x-cc, which now successfully loads kernel
modules with .hyp.text unmapped from the host.

Thanks,
Quentin

[1] https://lore.kernel.org/kvmarm/20210108121524.656872-1-qperret@google.com/

Quentin Perret (2):
  asm-generic: export: Stub EXPORT_SYMBOL with __DISABLE_EXPORTS
  KVM: arm64: Stub EXPORT_SYMBOL for nVHE EL2 code

 arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++--
 include/asm-generic/export.h     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.30.0.365.g02bc693789-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
