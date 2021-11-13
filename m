Return-Path: <SRS0=3yKf=QA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F9CC4332F
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:23:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 74C866115A
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:23:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 74C866115A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 247374B340;
	Fri, 12 Nov 2021 20:23:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ibvsDYMtDWNi; Fri, 12 Nov 2021 20:23:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19CEE4B26B;
	Fri, 12 Nov 2021 20:23:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 721004B2E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:23:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zsGB916170Bl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 20:23:05 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 107334B322
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:23:04 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 x25-20020aa79199000000b0044caf0d1ba8so6613961pfa.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 17:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Q7GrWuTY0VLlfBXSVo/l1AbRU3c932xDVsXpIdGJOrQ=;
 b=Qmzc0naE2HLfLu5C2KfMiITU+UJiTaXnpCuFgySBcgb58yGhXt/fTDiojjVpCSj2E7
 jIYeXWI43Mlupul7TfFnith9qWXSb/JWu9NvAQq21lHSzusJ1WVCxxpLuI9ftGeD/FLj
 AXxNCkeI8yA+FJ+odDw+8Yx60MOcHICOIGSaETOI2q9GsL++lJUuG9X1BY5TNG/pRWYH
 TzP5x6ZXpeiyibR6glYKFyx+v7Sod8MrhMPNOwyOMc0ccYYcp8tKq8j7516kKiXGo+0e
 z02V/ThWb4O2kALL4Ayv6zetGqgPT1sQQW14SJ4i37TYo0VO6zNOyOnGm28ClqVuX/Nb
 fMFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Q7GrWuTY0VLlfBXSVo/l1AbRU3c932xDVsXpIdGJOrQ=;
 b=yzMksOquhSa0Q2H+dEo6Dnw0nW5Lk3Xpy+YBHxvBSeLiJIONUNPattUkPC/0nMvG0U
 eOqHBP9OEhZSpnZB1HmMWG9xAUP337kd3mElH7UMMTx5oOHoiv6yExCTGJWwb8dV6CYN
 dgUpcdlDc9/I4z2+RZ4zrB1+hGmhLg33c1WHyESEoUNQ4UUEWV58ZZbca3RT0zo04BTg
 B+ldzlNfBySTuLfmNx/pckreU2sbrAli+z8mJHqrns9vCYffPE1Vzf9xSckItRvOazCF
 ZudqTCSN3gJlYfsAKlDNsdVrkdFaEv+/gyhEztjkd4SLp9nUZABEqL+ukzRuKfraNxyK
 9ENA==
X-Gm-Message-State: AOAM530XGo8YlJo0C3799n/qiQfucO8AYTQ03H2FfCUiDpwce7aUBE28
 UJyVRoARtW7N3FulDT7lzdL5SHLnsi15
X-Google-Smtp-Source: ABdhPJzq7F0HIvX+HNKivSfbV1x5ZTlVJPloR1co4VbUadyRLqRwx5DRYLGw8MvzuMhDYyd7Cv5Zq3lt07td
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:c643:b0:141:cf6b:6999 with SMTP id
 s3-20020a170902c64300b00141cf6b6999mr13246105pls.80.1636766583281; Fri, 12
 Nov 2021 17:23:03 -0800 (PST)
Date: Sat, 13 Nov 2021 01:22:31 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-9-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 08/11] Docs: KVM: Rename psci.rst to hypercalls.rst
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
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
