Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62831C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0459D619F5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0459D619F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99CEE4B1E9;
	Mon,  8 Nov 2021 21:39:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CB+WI+tE4Q7Z; Mon,  8 Nov 2021 21:39:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E855E4B1C0;
	Mon,  8 Nov 2021 21:39:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02A7E4B1A9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AcRKPbSERsBi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:15 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A76F4B125
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:15 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 a127-20020a627f85000000b0047feae4a8d9so11943718pfd.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0y7vLMxPPl6BScQAMjV8Fjo9DYu63xojaNRWz6NZJZ4=;
 b=DyUrPyS0UzVyIdnSnkJ03UWv3pnOgXolI/cmm/sQiHRzDs6JZCp41VErdDW2z1ZMNn
 Zevovaq4V3Qz6AeSv61OzBja4qAYo979y5f8PFcgtB4oexNXCco4EdEdSgxVSYd6/2af
 lyXWIe/+g2OJ/MPnnRGYliEsWaIuOfP8kznXzW531r3dmZJNs/DGTKMCOi8mQggNpxXC
 xT1CiEqv4VnXyM0AxjdK+kQE+/mBVP1Ocu4ifyfMVvoxFLstR0TGA91fB98+m+g8jxHy
 2YfNaK2gFdNd75nKtNYMcr5o/iuzZ659mIly27tgxWuT7Rs/KEa7/CmPEq45pOdqSiV7
 gXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0y7vLMxPPl6BScQAMjV8Fjo9DYu63xojaNRWz6NZJZ4=;
 b=xrT/sPiqQsqhzQYpOpDcBuO4QT8+SX02z5EbZq5y7tsJwey8wTlNJb9SDLuAlUdH6y
 g49rwcHJ/giCwQPgdgJH7YC/EZbUnYjLZ1zXTjMIgR6d5XKQV5b+FK2qfQQ0WXhCFD3W
 LkU2QgS3qbgvQMjQmPRgFC1PPURtT4mhWW2Mpf3UXX6fLNxgmSsR3eTIkBinlB8TQQwV
 nI8uEGY5s8S+f1leqDW1f8TZhmyhiCpfNj/vEsoLrTdZlKq3SbxfuGptp1hg5YybhDBh
 4Ga/cWkekP6OUVlxcyov/vRpAGlNf/OREZW+dn2UrboKyIEtzrWGkfx3h3+rI2wQHr/a
 i7fw==
X-Gm-Message-State: AOAM531zzJbcN3Yh28ruHgzeaW2G0JQ77LV6Vvo7l95I4wMUEhFxdVJm
 3xBdNrFJF1m442kVYZElCLF34mFRtA8MmA==
X-Google-Smtp-Source: ABdhPJxA15p+zaxKKjY4+9kinUUQXs0xiR2NDdQyVjcdaW+yoPUj15VMTcoiMYFRVxMo0xcpqR82q2PaCEXchg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:b7cb:b0:141:b33a:9589 with SMTP
 id v11-20020a170902b7cb00b00141b33a9589mr3618554plz.9.1636425554628; Mon, 08
 Nov 2021 18:39:14 -0800 (PST)
Date: Mon,  8 Nov 2021 18:38:50 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 01/17] KVM: selftests: aarch64: move gic_v3.h to shared headers
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

Move gic_v3.h to the shared headers location. There are some definitions
that will be used in the vgic-irq test.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/{lib => include}/aarch64/gic_v3.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename tools/testing/selftests/kvm/{lib => include}/aarch64/gic_v3.h (100%)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.h b/tools/testing/selftests/kvm/include/aarch64/gic_v3.h
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
rename to tools/testing/selftests/kvm/include/aarch64/gic_v3.h
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
