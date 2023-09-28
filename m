Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E0D374FC
	for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 17:32:13 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5a1d352a86dso142969527b3.0
        for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 10:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695922333; x=1696527133; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x/RP+maPZNCNmU4rPU/bGW3TvnAjHmTxUTEQuDee5QM=;
        b=NATt6Mu4fVt9lYmylcIZqE3ZEGeYDvctRUCTzol5lozBoqx+L4fvWatXZ5V6LbhzI/
         emi2LdOHiO8/dDIWmE/bb98253sjjpKw+guNPfaaXJa4LjuKPiKUFg+ptrgTs+lqyafx
         XMKw+ogxiZ21naKkMYgkF8Of0pobul5istj7fSEiJVY6ryGzKLGwWdIT83aXeCpUXgtO
         1v/gNU3M8M/AebsEsgrdcvXd09iWMWtBXesXG4c9g4r31OHXGC1d8CIjzuf6Wttml1OO
         HLQA65au7/s9c+gPcLFf9pX83HKv9dAeDWIR/vLPVMWE/7QETXjC7SS8idRfSnlQK048
         CzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695922333; x=1696527133;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x/RP+maPZNCNmU4rPU/bGW3TvnAjHmTxUTEQuDee5QM=;
        b=vBWs3EAgsMFJzNiIdCm/huxOmLovBpc6Q9EK/ZANsW6SadFTrSd3eSeJ7m/6P7Sz5J
         5BL4nMZizh6QkDAl4sC+MVnK39vGzgepOa0sMFOkuyCmUxOHGw6NQ6xCi8p7CJTtaqyr
         B12uMeWtoOZmloDviO+qhf4XRZsOGcuDvBc2o0A3stZ2KXpsKn+aTCOvG2znrjvQGPT0
         XKOyD/bFJZ518ARjBamBWojQf/XPXiRnVoe17B3n7Ll+YmLI4kJyV668juUqwOoVm8ax
         3dSUc+auxt1eGIHEyhRxwfiYbeIPalU08sucdRn7+1aWhD3F5X14cGC5yX1Kklex/ASX
         GwKw==
X-Gm-Message-State: AOJu0Yy7XZelz8hNKdVbKivd56b0VBfjkUtJGWZjL3xXRqG6Lu/KO9UZ
	XWKTsUGA9a9325lekeAqBZMvcZTsW5vIS/B0
X-Google-Smtp-Source: AGHT+IF0+c3V9EwlV61yF9V60ltd2J0GAarY1FKV2E/7LLRKyOngzXE6cFwhjiWhK/TFxTEE/LhLm/8+GYFnkfCc
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a25:b293:0:b0:d81:fc08:29ea with SMTP
 id k19-20020a25b293000000b00d81fc0829eamr25721ybj.2.1695922332813; Thu, 28
 Sep 2023 10:32:12 -0700 (PDT)
Date: Thu, 28 Sep 2023 18:32:02 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230928173205.2826598-1-vdonnefort@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: Use folio for THP support
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org, willy@infradead.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

With the introduction of folios for transparent huge pages [1], we
can rely on this support to identify if a page is backed by a huge one,
saving a page table walk.

v1 -> v2:
  * Add git reference to [1] in the commit message
  * GUP always acted on the Head page under the hood. Update the commit
    message.

[1] https://lkml.kernel.org/r/20220504182857.4013401-3-willy@infradead.org

Vincent Donnefort (2):
  KVM: arm64: Do not transfer page refcount for THP adjustment
  KVM: arm64: Use folio for THP adjustment

 arch/arm64/kvm/mmu.c | 79 ++------------------------------------------
 1 file changed, 3 insertions(+), 76 deletions(-)


base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.42.0.515.g380fc7ccd1-goog

