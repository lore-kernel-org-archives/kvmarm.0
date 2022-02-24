Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B828C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 17:26:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 120C94BE4F;
	Thu, 24 Feb 2022 12:26:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v4hcLYmVbR5h; Thu, 24 Feb 2022 12:26:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C18F94BE2D;
	Thu, 24 Feb 2022 12:26:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E87FE4BD9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q52X3lA4IRrx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:26:29 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B8184BD36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:29 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 z28-20020aa79f9c000000b004e10449d919so1633338pfr.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/yI+1iHLFKapqIM71Fi477KtJQIbrAd1wE7m0DoVTrg=;
 b=BX44DBoUoT7DxSh0J1USD87fHZhHxbcIv+UIN+p9yTigBQ9rkC70b9lUdxzXby4YQD
 KMd52RGWYjaaW1mHhmPX5yT+JeYaFygpZY0qhfH1XvQg4NW+V/3WQmadTFO0LuyUmjqI
 Lf4X1oVugf+w+6UILacWvqCQD699Y1sZ4jHxPCht5kQp0Z7gmZzjkNCEjNdcP+9Z/PgR
 xKtXomjP+kvoY2+igh5Qgl1oXuX44weeSxLg17woXyG242n2H2rrMhMI9uPz0uyVFxom
 j9u76QtEXmUQj2ImKEWLR1zsNdb+nKTskysG+XXZFqOdlVy/AMw05nrczKv2DjXofDpL
 i+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/yI+1iHLFKapqIM71Fi477KtJQIbrAd1wE7m0DoVTrg=;
 b=qE4sVyUeDyz1fFJtLz1IadQHMGCb+TTw8Ji3U24CPFxIr5X00C2ur8H1dBhxOJWo0i
 hqaOq21X8+GcQwiOYspdlcIJAb9mXex/TjPq92DpgS2afYPYPXs3X9KnQ1WJN0LA2stC
 RZ42VzifAVaSsW3KHrPS/Wt9hG4i7sGDwtPBOOSOFfl8zvkh5rpezOIiz6SR5EVlYIbk
 0hY8cHY1rqmjv3DdcdaT6WCgTco36Q4qBZKDvsDu77SCckoD5bmUTsUJBJSTwkcwUttP
 FEGPe7ixw+cl/rVJRz+TXFexa2LbeTaABMa/4A/tCdU1kqc9ZBWzdZyp5wBBTSIeJEzp
 eUtw==
X-Gm-Message-State: AOAM533m+cfa8RHmDYdR4bS2Tz0JKSk0lE+sfGZRaWrx7Rb714jA6akw
 OqvgGSJiXicDkyTZysEkXXlmChOHa82/
X-Google-Smtp-Source: ABdhPJyekDaVQfujrpGwc51nGDLUID+Ox5wvRHROwF3BH9GvfkusWzxxeNEpolKSk+8ZEG7ImKIZOKSGzN1P
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:700b:b0:148:ee33:70fe with SMTP id
 y11-20020a170902700b00b00148ee3370femr3741547plk.38.1645723588637; Thu, 24
 Feb 2022 09:26:28 -0800 (PST)
Date: Thu, 24 Feb 2022 17:25:55 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-10-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 09/13] Docs: KVM: Rename psci.rst to hypercalls.rst
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

Since the doc now covers more of general hypercalls'
details, rather than just PSCI, rename the file to a
more appropriate name- hypercalls.rst.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm/hypercalls.rst
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
