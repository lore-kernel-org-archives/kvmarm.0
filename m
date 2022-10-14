Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71EF2F5B
	for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 18:46:36 +0000 (UTC)
Received: by mail-pg1-f194.google.com with SMTP id 128so5075240pga.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 11:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r9b1WxYCtQHAvJQbAPYaXXw5JIstR8dPjphyBTVotDg=;
        b=C9ChpAljNx+6EX+b7MIXOhJ/DxR1oEgil1ZdehQzrOHu0htP0Wb4hihn7cdKw7kusB
         unlXoi0fYM8ckb4UqUThqiouQ/fgrebyEJmB7iEik2j7ocpYju1X+GtQNb/e2THXGyfu
         pdn2pYHgdd7SXL+E5NiLfpnCE8W4Xn9DguZTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r9b1WxYCtQHAvJQbAPYaXXw5JIstR8dPjphyBTVotDg=;
        b=cU/plCQfrQmANqInm2IqBeflaOtUKxBcRSLomVEFRcPx1ZlBw8l8nt/tcopD/nFNrS
         HnFFoDyBZMD+cikYnYkcQo4gLG6keARNd9KUbqDG1IUVo0FC6hmEFSkthUcKNO1w4S4p
         NRMPr+zy/1qJY2GsM+Tk2uUZbsgspiTj5ZF+mfzpt6cpoI3IpKvmNC019RRaSN6u/2Xx
         Z2EPN51ppP2BHaZPrL7X/k/TeqdLZt7T4N3SJ6q9giNF/2hzPb3O/QXqknZ3MQmw5s8h
         wqj2mpoSJa42pkRC2LN25U08nd3371fK6MJ+t4El2RsxLEvcKoHeTtE85oxI6SpoIQ9N
         y/CA==
X-Gm-Message-State: ACrzQf2Hjjme6HaV2G3+pdGn+eeCEMpgjeuuN/tt5AiRETfBngFrlH4M
	GogBGC2kW+W/Rg3RYWSAWcVXSg==
X-Google-Smtp-Source: AMsMyM4KxZFUnZ3+JVUZbSV1KdBMKe5N17ONrn6zYeMpUbJ+0CiKCyk427n5W/she7eWjJeNE5SITA==
X-Received: by 2002:a05:6a00:1707:b0:562:e790:dfc3 with SMTP id h7-20020a056a00170700b00562e790dfc3mr6609803pfc.59.1665773196248;
        Fri, 14 Oct 2022 11:46:36 -0700 (PDT)
Received: from localhost ([2620:15c:2ce:200:e8c9:5029:f577:f6ca])
        by smtp.gmail.com with UTF8SMTPSA id 203-20020a6217d4000000b0053653c6b9f9sm2047145pfx.204.2022.10.14.11.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 11:46:35 -0700 (PDT)
From: Denis Nikitin <denik@chromium.org>
To: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Manoj Gupta <manojgupta@google.com>,
	David Brazdil <dbrazdil@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org,
	Denis Nikitin <denik@chromium.org>
Subject: [PATCH v3] KVM: arm64: nvhe: Fix build with profile optimization
Date: Fri, 14 Oct 2022 11:45:32 -0700
Message-ID: <20221014184532.3153551-1-denik@chromium.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221014184532.S8Ifb132E-f6whDlGWYp_nUpBJ1BifTmr6jeLJAwy0A@z>

Kernel build with clang and KCFLAGS=-fprofile-sample-use=<profile> fails with:

error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: Unexpected SHT_REL
section ".rel.llvm.call-graph-profile"

Starting from 13.0.0 llvm can generate SHT_REL section, see
https://reviews.llvm.org/rGca3bdb57fa1ac98b711a735de048c12b5fdd8086.
gen-hyprel does not support SHT_REL relocation section.

Filter out profile use flags to fix the build with profile optimization.

Signed-off-by: Denis Nikitin <denik@chromium.org>
---
V2 -> V3: Filter out the profile-use flags.
V1 -> V2: Remove the relocation instead of disabling the profile-use flags.
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b5c5119c7396..16c6abdda494 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -89,6 +89,10 @@ quiet_cmd_hypcopy = HYPCOPY $@
 # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
 # This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
+# Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profile'
+# when profile optimization is applied. gen-hyprel does not support SHT_REL and
+# causes a build failure. Remove profile optimization flags.
+KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%, $(KBUILD_CFLAGS))
 
 # KVM nVHE code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.38.0.413.g74048e4d9e-goog

