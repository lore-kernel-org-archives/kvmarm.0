Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1990FC32774
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 05:10:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C79064E2E6;
	Thu, 25 Aug 2022 01:10:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bIqICuKfQE0K; Thu, 25 Aug 2022 01:10:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB10B4E2DD;
	Thu, 25 Aug 2022 01:10:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2964E2C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zsdxSXLvu5+d for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 01:10:20 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8642B4E2DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:19 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 r6-20020a17090a2e8600b001fbb51e5cc1so135516pjd.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 22:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=pEzlhIhHkJ9oe9us+Ap6efv2GvV7LuN1d5BuceK5HtQ=;
 b=GDyPQuvB4CGkscQbFZesosca0zjSklRpbtqexkueZNX0/pQlIx18BczSNbJOP6N52r
 VK0YZIjzcrbwa8JnR5p94cA3vM3FOALNsiaDpTwkEQ5sYP8zR2+ZCDGSbAHtV1d2ntKO
 1nscFoy1pN1GJ/KqunnMWBDzX60HpvGeV1ZFpeTg2j/LI9cFvBStu4bK+XXveF0y/P93
 iIpNZOY8Cm/V3G+MHqg8np+I0RwEFmMV9x4YMP+uyhlRuqHaRf87tYe6/Jaha/2Nqe24
 hjZfCUriCXxAGqR5uLeTWRpq8z3vDgesV9E3/ACXNMNELEY5hwkQ7ZH9wBrfCwDKEHHR
 b/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=pEzlhIhHkJ9oe9us+Ap6efv2GvV7LuN1d5BuceK5HtQ=;
 b=fLeoBF1JMgc7YANQThuR1diRjjNwUX9Xi+a5FeTYdgJ7rFtP53O9v2W07tT3rvmfci
 VZk9bOsM+y5A9JNU0JYIy+jpL143r/JXyUJJzGY30DGyn0R0YLsOk/m6YfjtgRfdCYxM
 +eXQ0HPbA9wHcAP808ncV8GGsIzTUjVETAFx/hiYT4WLO9SB3k63rzyXEKnXnBO7OBS/
 wN7rfHeQtUj2RpWQ6qVEI0m2H92J0oDM049RoQ+Y33zW/WitQrvpdH/FC9GXwfCm+w1Z
 9JVG7j0fYDCy4JEEnhL4npUnB8H/zKpdyDGa7NNZ7vJf8Z5/VdK8GuMycxs+lmWk5LfR
 z/mA==
X-Gm-Message-State: ACgBeo2twi2UM+BQ6IupBJZP7XXmcQnhdOzh/TGnB4DPkWOs8ea9xrnV
 YK0CrGYp0S1xy+rYjlURrDbGEl7FAI8=
X-Google-Smtp-Source: AA6agR4QwGnPgJc9EXrJlzOPJDZW1awp7QnK0mmHC+92n4anJ3Yqks2hO/x4pF1tFVBJVUjLL44mvc2Kwdg=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:90a:de96:b0:1fa:e427:e18e with SMTP id
 n22-20020a17090ade9600b001fae427e18emr12097875pjv.116.1661404218605; Wed, 24
 Aug 2022 22:10:18 -0700 (PDT)
Date: Wed, 24 Aug 2022 22:08:42 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-6-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 5/9] KVM: arm64: selftests: Have debug_version() use
 cpuid_get_ufield() helper
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

Change debug_version() to use cpuid_get_ufield() to extract DebugVer
field from the AA64DFR0_EL1 register value.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 713c7240b680..17b17359ac41 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -320,7 +320,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
 	uint64_t id_aa64dfr0;
 
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
-	return id_aa64dfr0 & 0xf;
+	return cpuid_get_ufield(id_aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT);
 }
 
 int main(int argc, char *argv[])
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
