Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47802A958
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 18:02:41 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id l7-20020a056e020dc700b0031534e3f1dbso3573832ilj.2
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=70xvWuvYdaN0RHC9y2y+6cAohvWGNUH5IWQYtqhnjZE=;
        b=URPZnrYEApr1It+IVm3J16L4qUg2cigXzrcfhjuyLm3gPm2LeW9+RwiQI/kFr/6ju1
         QRO6gvU1kY6dLPzMq2+wCiHIcftw3NDrPbCYlTgca1cM2BNmpFb0BRx5X9OGtMV8iMKn
         4GC9+VjpgnH3ZAy+lR+VvnIrWIq2xvRyCFftvMcT7dG5qXF65SenNlCXkyi51D30k9MG
         Abkslkc8PQo9JTtVqLGYkkodvZP1FK5TTm+dDZmUgRPrThCwyXSKOQumFLGyGTRNrShi
         Ag9sAoQFvgZNJPH5i4fSQ1WSw6K2yJobD3ohEm/lMQeQ/f+tIPe4oookQuuonepQMnv3
         WQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=70xvWuvYdaN0RHC9y2y+6cAohvWGNUH5IWQYtqhnjZE=;
        b=E6thaSB4ilZd5QRYCxGWqYQxV8dt3nF6johcHegUaRpceBsdw67UDJ30Fw7EGuyFHH
         O68rMXGBYlPOISPYTNIlj+53btF/DFJ+/+ZZNNecEOGoKBLwBt2qTaCG+cbv7mhoWQI4
         bzuVeYPjpTf4HocS56kjuqwS6JVI4tgIMUflRTutMXAaTwNnR0XL8hvOwyo39kSYwr/g
         c2Ov1CWiNRtdIayngVJLLumG3VLgMhEmFUh/rh6P22U5jk+aCFcbM5zTM9BTyk8VtXdk
         TkQNp/Vj8Rpl40BgMZ7iZZdMVQkjEiLiQTwZbdWzRqyHuXtv8STf7DMxEWOBkAsvB2OG
         DXlg==
X-Gm-Message-State: AO0yUKUrKEGCf+E6DZ170GgTuVz9lgoW4p65GxtM5n95MtwJrzGqnTDz
	Rm4SzCTC8gj290VXwW3UnuqTjcY2Xep0
X-Google-Smtp-Source: AK7set/8lUVnM/xUxlc5ev5n38xMQU6UonaUcN7oe3E/mMvqt3yuPRKRB7RT8I01SIqBC8WTFb8l0KoRBFtB
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a92:2613:0:b0:310:9afc:aa6 with SMTP id
 n19-20020a922613000000b003109afc0aa6mr2640960ile.0.1676311360373; Mon, 13 Feb
 2023 10:02:40 -0800 (PST)
Date: Mon, 13 Feb 2023 18:02:22 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-2-rananta@google.com>
Subject: [PATCH 01/13] selftests: KVM: aarch64: Rename vpmu_counter_access.c
 to vpmu_test.c
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The upcoming patches would add more vPMU related tests to the file.
Hence, rename it to be more generic.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../kvm/aarch64/{vpmu_counter_access.c => vpmu_test.c}          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/testing/selftests/kvm/aarch64/{vpmu_counter_access.c => vpmu_test.c} (99%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index b27fea0ce5918..a4d262e139b18 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -143,7 +143,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
-TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
+TEST_GEN_PROGS_aarch64 += aarch64/vpmu_test
 TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
similarity index 99%
rename from tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
rename to tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 453f0dd240f44..581be0c463ad1 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * vpmu_counter_access - Test vPMU event counter access
+ * vpmu_test - Test the vPMU
  *
  * Copyright (c) 2022 Google LLC.
  *
-- 
2.39.1.581.gbfd45094c4-goog

