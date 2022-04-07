Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E63C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 01:16:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83CAE4B20A;
	Wed,  6 Apr 2022 21:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bxrncj7Be3jM; Wed,  6 Apr 2022 21:16:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C99E4B1A2;
	Wed,  6 Apr 2022 21:16:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65A814B1CB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 21:16:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id quA6xKaYbV3g for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 21:16:23 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E12604B1B6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 21:16:21 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 md13-20020a17090b23cd00b001ca7df65e1cso2601566pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2022 18:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=sXF/n8xvBk0FaoqPxko9Blx99fwDwCfccorRyyHCGmI=;
 b=Ku987wK6rt+m7eJsyZLO6atNDPGpbqe4iAXnvp/z+wT4OAEoeg5o3OAlVCchPx2L90
 102SSaR5cOkN6fP9KK1z++y2/yupbiYjbDvWjD2Qece4MWsVopP3FCXHX4y/zHjbpWC1
 gPOj/Frc3z6/rMyZik2wcjHitIQ4/twgDnejS7ftwlIb7sbfGEUikTJBplt2AK2+GVaZ
 07sKnoPUR6sFzjL+MzpauXdv8UdFJexw9xi8RG6979lRl0UQdLY95bXFxQyCZdMoIbFU
 0VtliYgcNZH8l/+6VtdO2QrethSXUAVc7WRMaO/7ps9olTMrNkeZKKeVqELA9bxuRt6C
 2ERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=sXF/n8xvBk0FaoqPxko9Blx99fwDwCfccorRyyHCGmI=;
 b=5D9gkZfSzH1vzIotv9T5stSR4N6G+AHjDcOfaOFfnyYDvjmEX0e5dVSeOrq+/ghpsF
 WSOGectnvBat3nEcQxDGvh7yfw3nVTJT5uwfcSi8r/rcRxVtBLHJ/IJW2rJN99T6Trma
 YDoJPA3cylCVNubrSoKACtfxUAaD3QccKZchdNoaHxnjO0j7z4r7Edo2Jk8JNWzGN3rL
 0q4hBUkDlOfIugieYq4QSDs42S7HS73FeYF/Js8TdXhzDND7xvLLVsKrsBztQQrk11HO
 Rl/lrj0huzHz8z3+7Q4A2Rlw39Z3jwwAzrduBZNcyaRJwtQbcYMWH4R3TcdSg0/C/CnN
 W8kw==
X-Gm-Message-State: AOAM530oKNd9StL0cMa20k7rx2iKOzCHJBYURuifAMvbe2cntR84Of3b
 A/aUw1ntz7InG/b9nwhxiKCdE+svEpbP
X-Google-Smtp-Source: ABdhPJw2dezSQVSintcsyWAePk4VuF7JuHzdsneJX2UxM+MFRSiIefC4mvBoj4uqrdxw8cb/zhGbCkzWilbb
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:440c:b0:4fa:da3f:251c with SMTP
 id br12-20020a056a00440c00b004fada3f251cmr11599625pfb.73.1649294181092; Wed,
 06 Apr 2022 18:16:21 -0700 (PDT)
Date: Thu,  7 Apr 2022 01:16:00 +0000
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Message-Id: <20220407011605.1966778-6-rananta@google.com>
Mime-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 05/10] Docs: KVM: Rename psci.rst to hypercalls.rst
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
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
