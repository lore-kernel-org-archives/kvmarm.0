Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53E25221
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 21:17:57 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id o8-20020a17090a9f8800b002260d01b221so7890488pjp.8
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 13:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C+A/7tP9mvR5o1GtT1H6KbVlKl608UdMee+76BtuWKY=;
        b=NYrhvrbbfkSmHLJAY5CoZsw9Z3pb8ZX1ARyBNHXSy5UxUbbLAOboQMst98y0xabMqe
         muJWrH8SW/zai8ix/V5vd6Cvvd1FxWt2qsVrDAqaHmBhUC7E8K2daLlkiKTBZLmKRxts
         Y4sY6z61Q50T9kyRSJ9hReFHU2j8uWDaU3tdwAvts5+Op/7tQdP79goWGPgDMFXlEUvG
         mZluVz0K5AgRFjdLSJ1yyRBwriqOmg5Gd1XlQgnk8PvYQbVlC639wCpvg2lL29nylI2c
         HrsRFjRvlHfutZtzuOq8hXnm1DeeKK1aMK+sUlKxGsWeQ9GnYz3ewoJvu7z/ruRqZ8RX
         qS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C+A/7tP9mvR5o1GtT1H6KbVlKl608UdMee+76BtuWKY=;
        b=LKD6i51NsC9OIp+rP3xIqGuc5NV9oFuUw2FbgxVDxJvPDv+2RqfgMvOvNQhQQENROh
         IJNHmgNOjZE1COM1P6f9LcAtvJd7J7Ky7XEqNT5/8+tdhIMJVuYNgEwTBJD3qHdGfPAb
         ZXbDEZZR4tOqQOzCh6X/IVjBG3FLRdDts5HCu7GjHGpA8UcwvA6V1k7cnq7IUZB6yV2Y
         58AXSy1k/eleJ8uo5nYzQaiw2vnQbCgHgdpwQFQ59CWKweNRHGNca87g70Y9Nj/Fa/BS
         o6N9DquAiOvaIc76lQBh/6KZeLYlGXyiS2oB/i4dxqGTJlrQEqt/U4I0/4bqH9JPwOnT
         8LTw==
X-Gm-Message-State: AFqh2kqlSEoXqMYYVZjRNfNr2mRBjC9eOCtTp1kFLlYKpYhRYNNtTXjj
	5AM4k6+kSaeaTdmUxl/HzyD/X930ZXnV6g==
X-Google-Smtp-Source: AMrXdXsuzGhN57hreYNDB9W34vnllmBsMvmdjRf6dJryLCkM6AVR0IfSHN4dMqg2O1uk8SFEEXOTG7dfKPg2wg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a62:5f87:0:b0:57f:ef13:63aa with SMTP id
 t129-20020a625f87000000b0057fef1363aamr4334401pfb.42.1673299077120; Mon, 09
 Jan 2023 13:17:57 -0800 (PST)
Date: Mon,  9 Jan 2023 21:17:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109211754.67144-1-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v3 0/4] arm: pmu: Add support for PMUv3p5
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	oliver.upton@linux.dev, reijiw@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

The first commit fixes the tests when running on PMUv3p5. The issue is that
PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
for overflowing at 32 or 64-bits. Tests are currently failing [0] on
PMUv3p5 because of this. They wrongly assume that values will be wrapped
around 32-bits, but they overflow into the other half of the 64-bit
counters.

The second and third commits add new tests for 64-bit overflows, a feature
added with PMUv3p5 (PMCR_EL0.LP == 1). This is done by running all
overflow-related tests in two modes: with 32-bit and 64-bit overflows.
The fourt commit changes the value reporting to use %lx instead of %ld.

This series was tested on PMUv3p5 and PMUv3p4 using the ARM Fast Model and
kvmtool.  All tests pass on both PMUv3p5 and PMUv3p4 when using Marc's
PMUv3p5 series [0], plus the suggestion made at [1]. Didn't test AArch32.

Changes from v2:
- used Oliver's suggestion of using pmevcntr_mask() for masking counters to
  32 or 64 bits, instead of casting to uint32_t or uint64_t.
- removed ALL_SET_AT() in favor of pmevcntr_mask(). (Oliver)
- moved the change to have odd counter overflows at 64-bits from first to
  third commit.
- renamed PRE_OVERFLOW macro to PRE_OVERFLOW_32, and PRE_OVERFLOW_AT() to
  PRE_OVERFLOW().

Changes from v1 (all suggested by Alexandru):
- report counter values in hexadecimal
- s/overflow_at_64bits/unused for all chained tests
- check that odd counters do not increment when using overflow_at_64bits
  (pmcr.LP=1)
- test 64-bit odd counters overflows
- switch confusing var names in test_chained_sw_incr(): cntr0 <-> cntr1

[0] https://lore.kernel.org/kvmarm/20221113163832.3154370-1-maz@kernel.org/
[1] https://lore.kernel.org/kvmarm/Y4jasyxvFRNvvmox@google.com/

Ricardo Koller (4):
  arm: pmu: Fix overflow checks for PMUv3p5 long counters
  arm: pmu: Prepare for testing 64-bit overflows
  arm: pmu: Add tests for 64-bit overflows
  arm: pmu: Print counter values as hexadecimals

 arm/pmu.c | 260 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 163 insertions(+), 97 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

