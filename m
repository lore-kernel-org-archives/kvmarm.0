Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DFE46B3
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 16:54:04 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id o1-20020a252801000000b0080b8600bdc9so2461354ybo.3
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 08:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bB+klmLMzU6sC10FeFNal2TB7uAaIFG8RIqJADzg1hw=;
        b=defmWuPcSX0rx6PAkaZvSab8Ui3ahIP51HTTVLzdQVcey8LDHaKIKfUhBoogt1PCVh
         RWBvMIKnPWAeRjq2D7aV/VbFTlWIhGzA5Yet/vluKdyZ/4mk+w3gSz/htFfxdwXyDD2/
         Zn0fT6lua5GSiel+06MbcoS70OQbfQtSnrFZKaOM3gcSoSi1qzEACjdxpygGvgVc6zdM
         A5ykqWWeDhD9/cgwQQecJCWyqWpyeKrJqswoa/wVRTc1gROsWNPUDS8Xo9CawxOAZCSH
         a5ux1EAps9cZa5pyK9WaSF0kOyjIkmrD8WSfjE21da5K2GWiedPkWx4PGsuaRm5qxTFe
         n+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bB+klmLMzU6sC10FeFNal2TB7uAaIFG8RIqJADzg1hw=;
        b=fArT8YjOdMiAfTpILyVyRNbo/ap6fKYl7InDqUd6cCFtQ3YSkNFquh4Bd3q7zHlu5e
         QBd1QcrZ/FPCFTuEHYNPfQUV9QEHxloIKK3UmEvkCjn7TwVpHXHnJ+XLccJnxw3+WUXy
         JO4yomm2+We1ouplCDrAWq5lPr2AJIybZrFxuMqvLQxUVdtZH41+IzccIR/2TP6NQF3R
         jeu47YGVfyC2q8Z5wYAc91BXI9aRjCRHC3jjWi+Q6rRpJbFQwCDCvonEtzpO7lx17dCJ
         XyY7F+67OtTU4N2CRFzQb2LxUz83gSLuwYlqodcwhVOiGi+5YXgejJIr3QD/lWiE9oQP
         /RpA==
X-Gm-Message-State: AO0yUKVr9kElRZzj3UrwF17UDczQp4jmmB1lU0VIRBrT+XUsGJ/8YATR
	w8gA5Oue+4CltnoMDLjeBio27ilN29m8bw==
X-Google-Smtp-Source: AK7set87Kh7//SFpwrnNUjDXgO1zm00dWJo5vzBtlOGAMpaXt8X/NlOOEIDPD+eUpvUdzn2ZvuSsZUl/cLU4qg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9109:0:b0:80b:e21f:2865 with SMTP id
 v9-20020a259109000000b0080be21f2865mr289916ybl.373.1674752043525; Thu, 26 Jan
 2023 08:54:03 -0800 (PST)
Date: Thu, 26 Jan 2023 16:53:51 +0000
In-Reply-To: <20230126165351.2561582-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126165351.2561582-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126165351.2561582-7-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v4 6/6] arm: pmu: Fix test_overflow_interrupt()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	oliver.upton@linux.dev, reijiw@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

test_overflow_interrupt() (from arm/pmu.c) has a test that passes
because the previous test leaves the state needed to pass: the
overflow status register with the expected bits. The test (that should
fail) does not enable the PMU after mem_access_loop(), which clears
the PMCR, and before writing into the software increment register.

Fix by clearing the previous test state (pmovsclr_el0) and by enabling
the PMU before the sw_incr test.

Fixes: 4f5ef94f3aac ("arm: pmu: Test overflow interrupts")
Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 1e93ea2..f91b5ca 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -914,10 +914,15 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 
 	write_regn_el0(pmevcntr, 0, pre_overflow);
 	write_regn_el0(pmevcntr, 1, pre_overflow);
+	write_sysreg(ALL_SET_32, pmovsclr_el0);
 	write_sysreg(ALL_SET_32, pmintenset_el1);
 	isb();
 
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x3, pmswinc_el0);
 
-- 
2.39.1.456.gfc5497dd1b-goog

