Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF45C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 00:03:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 931B04B103;
	Fri, 22 Apr 2022 20:03:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HOelFIbspa2m; Fri, 22 Apr 2022 20:03:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E29E4A11C;
	Fri, 22 Apr 2022 20:03:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 052304B125
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 20:03:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7VvvGKgXTHAB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 20:03:47 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F03564B0F4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 20:03:44 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 w18-20020aa79552000000b0050ce4b883a1so3263278pfq.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=sdFwv4QOKQ0jeXWPyN4VUYX/H7RbUcJ0vbpn1yYPEyc=;
 b=RrpFGYvp7DB0zpi/p9fPXe2bKVeiBYp0jhtzVd/kzok9FjMImSds+yJMsy1mPB2jBM
 Pc/25pFrZY9wn6UXYYewXgpC0sErsU3mNJ5kdcRVHUMk4iPjqEatKHdWsfGRe7mx0mwc
 I03Dlvr9fVukqTXpJqC/a0EyG5Sw36fifc9b+eztAm5ig5aY8e5YU+BFiVIES7oK2OmU
 54Sf3N3DoNZeU/lnYZEmXG3WA4g38D6muhtaj+82hlf7g0ygDIRNUdvE1gzxyJ2zhLJA
 I9rhSV5jR6jlLNd6Jl5NmZXTbB3nyH1YbSnsbfq0nBpel/TSYmQysjt1gX4K8nUt1kpe
 MW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=sdFwv4QOKQ0jeXWPyN4VUYX/H7RbUcJ0vbpn1yYPEyc=;
 b=6nx3gU+31S2Oyg+MijTq7+Q+cAcIfEHZM9TpzVLbXzyT6GVmlQrAF5/uewGilUkavf
 atXI2nmSVt50RenIQoD5ZqtkR0smu8nyByTh+JM/+J9zY7cxm5bo9ga/A/ynoQGIBqg/
 oz65S3Hq9QemB2bdRk00sleURbl6xGaDW18k1yfDwNxrhB1Pr4iEJlJoWm36HGhlhNZJ
 qZu2yZB5E4DQRou7Wwb1KGBC8zjRjBtqZZpeSleghn32ujlQtbraSlVSlior1PU/ezz2
 CBlUVGpMUFvaCmsUTzfPpNrQyurUq9E02Ct7o/Ru6ssApwknzENFK1d4qzuCNDuSRiv4
 BfbA==
X-Gm-Message-State: AOAM5300FKzM0VOAr0mF0C2Ki/mKdb76D9p3KQhYT+m2bXl+7xU+1d/U
 tVn2Xx+eWxhCddg8lgtvxWqijaZJb6UN
X-Google-Smtp-Source: ABdhPJwyiCQV5aOz4d8q5vkO769ik1uoEnJKBmVI1VlNyGlAUSokwnIIXmeToHFef7GFvLqhbdf9fkhk7QLi
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:4b89:b0:1c7:d452:4bc1 with SMTP id
 lr9-20020a17090b4b8900b001c7d4524bc1mr8190635pjb.134.1650672224061; Fri, 22
 Apr 2022 17:03:44 -0700 (PDT)
Date: Sat, 23 Apr 2022 00:03:24 +0000
In-Reply-To: <20220423000328.2103733-1-rananta@google.com>
Message-Id: <20220423000328.2103733-6-rananta@google.com>
Mime-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v6 5/9] Docs: KVM: Rename psci.rst to hypercalls.rst
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Since the doc also covers general hypercalls' details,
rather than just PSCI, and the fact that the bitmap firmware
registers' details will be added to this doc, rename the file
to a more appropriate name- hypercalls.rst.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm/hypercalls.rst
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
