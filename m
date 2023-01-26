Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BA246A7
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 16:53:54 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id n194-20020a2540cb000000b008038647d9ebso2455366yba.5
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 08:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=epBcuambf17d1PuUuyXKbaHvfLnz0Zdv1rlsdBONwcI=;
        b=DT5VFB0mDWJZLx00VsPU50OfcBBAaBDJAJZUPbXwCzc3/qKXaqJYoiL6cyunNbfSCx
         SRHCJEE45dCejOHYGbuXGRrEQUfFzZBTdWXxrntXsic9A+sLMxdcO1oGpxsiVGjLHDkv
         ujjKaqT/VRthMWj9VzasYsZpqHRbB5dbKJmErFOibXzvhBwEwdIqotcj+6j5RLSAIIso
         tv9Ab+crTFEtRoCuY3GDQlvM1LiU7+O8BGNVOYB2RwBMnJX3ucFXIPGlSH9T8IAKSFy9
         K1X+OoTV7GzqQFSJxv5jR5xCErKlDv6hiqsgCxaObDxxRwXoGuEKY68C3mB96NWx7AfH
         ZEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=epBcuambf17d1PuUuyXKbaHvfLnz0Zdv1rlsdBONwcI=;
        b=EbOU9bK9KY8XVnRehRndf5qRL3Rb7tbS0uEfKiplywtfbfPXyzR3Nmg5QlOFcRX+G5
         lIyAWA5+nWDNre8Ap+HVA/hZIxZH1Rma8vlAD0NcxSXw7xUiFo0xIipGXB0fM8rZxsfa
         5r3oSN/S97rf4/lKRCKDIRhPkSFkNKYSQHRYTYHHtOCzKVOWpLHtVBMRkVH/Cu7gfSzo
         M8REr30QUqD638ASgymSs1RwVV6UIkD6GXc/hWTcGhxcL7UZWQnqRCC8Mt9bvWziE0uv
         8xi1jtaVRQvzM1s1wDvPRkST7p30chHtAs39vuzVGyJerWvS3Cytefkqy+6Y9VuqHfjS
         9fXQ==
X-Gm-Message-State: AFqh2kqdCQKTRK05OSTARquwdHLXELoZwOnvu5RwXQpuDQnQLWArPqqM
	qd4vzUbdBc3mfTRJGdSgqTZbtrMRMOjKXw==
X-Google-Smtp-Source: AMrXdXvbmfT5pbJ0FBY7B6hBNsV45pYZbsBPZgTKAmCuwD4RYT7YUzrJWfpzk+e8xk8EIddj5wSqaUJxRh6atg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:98c3:0:b0:6ff:84be:717 with SMTP id
 m3-20020a2598c3000000b006ff84be0717mr4149755ybo.314.1674752034067; Thu, 26
 Jan 2023 08:53:54 -0800 (PST)
Date: Thu, 26 Jan 2023 16:53:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126165351.2561582-1-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v4 0/6] arm: pmu: Add support for PMUv3p5
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

Changes from v3:
- Added commit to fix test_overflow_interrupt(). (Reiji and Eric)
- Separated s/ALL_SET/ALL_SET_32/ and s/PRE_OVERFLOW/PRE_OVERFLOW_32
  into its own commit. (Reiji and Eric)
- Fix s/200/20. (Eric)

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

Ricardo Koller (6):
  arm: pmu: Fix overflow checks for PMUv3p5 long counters
  arm: pmu: Prepare for testing 64-bit overflows
  arm: pmu: Rename ALL_SET and PRE_OVERFLOW
  arm: pmu: Add tests for 64-bit overflows
  arm: pmu: Print counter values as hexadecimals
  arm: pmu: Fix test_overflow_interrupt()

 arm/pmu.c | 298 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 188 insertions(+), 110 deletions(-)

-- 
2.39.1.456.gfc5497dd1b-goog

