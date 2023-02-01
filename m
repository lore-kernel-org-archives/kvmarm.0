Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB27AEDA
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 10:38:13 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id en20-20020a056402529400b004a26ef05c34so2999519edb.16
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 02:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5K0pl1+Hpl1utWVuYLmia50ybxVZ915Svs1mkYim4pM=;
        b=AZ9csdjMBU+FO+3CE5q5XDNRyaZ+1mlI2Lj3G1o2WNntXFQVTVDho9LCPGR3ZrjnXW
         JzNnaFIPmXpm1MpNtgYY9TfcRGV/I80g3/DhYrNneq1VaDoh+xCyAM3n4ZUB4PFiJqFv
         GGn8eklaQ1dnG02WA+6uKaN01WVr/3jbL7WzodfEkxccXhoCtmRiM0EBfAG3LxVXbQZV
         i44+kQsGiH2Ml3pjlbpo89OSHLLMHSBeFOAjyXQ0oG8pg4GtPyrrCZHUYYir8456Jh6h
         5dDC6ExL1FQ8xWFj8hVPrPcEDZ8PoUEG/UNWhCmCOrvuvhxntp5jsxy0+egWKDo9xi3C
         UstQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5K0pl1+Hpl1utWVuYLmia50ybxVZ915Svs1mkYim4pM=;
        b=vsG0yXl2FDSR2hI/zuHZbRBh+Pcnz/28nFi3EAQ4ubfNoP9BdRdAu7MYiBeP3KKRQH
         FCqo9npdUkKlJgfI74PaZlKb7ybBStQYSe+55Hv0ijWiqwCE5KvnFV7qffnkt88nwaud
         uyVRDWPRCGHHLJzL/QnE4g/ex7pFBwHkNquU2vDm4aWKtJ23SPXVXK12l+7RyBKXBIpM
         S6eG2RiCqYamZMS0oEdVjTORiMoJ3LsCLJFEY+FYfLTXd/O8GpPnZIbdyButzwDLkImh
         lCauGV+aKOQVRKSX0nLXnJ6w6cTX9HwYmYWWAIjoGYQLypbrSZvqele+uRvcezA64XLS
         Rmtw==
X-Gm-Message-State: AO0yUKVrJCWW7t7Uz2kY7opIMenjz1p7XAhzOTlDLBda5M/USW3h/QuP
	6LO6K2bDU34N3PmfDX4tCSYlVs70hs/u
X-Google-Smtp-Source: AK7set+MIwBZlCh4FsMdr7pXxaPBRLjcasYsOx+njItP8dkSsNSFXlEsZ3xNBcQ6mJPWDYNmVw5G7qWj5uvy
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:aa7:cb43:0:b0:4a2:46c7:888b with SMTP id
 w3-20020aa7cb43000000b004a246c7888bmr446208edt.36.1675247892003; Wed, 01 Feb
 2023 02:38:12 -0800 (PST)
Date: Wed,  1 Feb 2023 10:37:54 +0000
In-Reply-To: <20230201103755.1398086-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230201103755.1398086-1-qperret@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201103755.1398086-5-qperret@google.com>
Subject: [PATCH 4/4] KVM: arm64: Finalise EL2 state from pKVM PSCI relay
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kernel-team@android.com, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

The EL2 state is not initialised correctly when a CPU comes out of
CPU_{SUSPEND,OFF} as the finalise_el2 function is not being called.
Let's directly call finalise_el2_state from this path to solve the
issue.

Fixes: 504ee23611c4 ("arm64: Add the arm64.nosve command line option")
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index c953fb4b9a13..a6d67c2bb5ae 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -183,6 +183,7 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 
 	/* Initialize EL2 CPU state to sane values. */
 	init_el2_state				// Clobbers x0..x2
+	finalise_el2_state
 
 	/* Enable MMU, set vectors and stack. */
 	mov	x0, x28
-- 
2.39.1.456.gfc5497dd1b-goog

