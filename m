Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E639C4332F
	for <kvmarm@archiver.kernel.org>; Sat,  5 Nov 2022 07:23:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A429F49A51;
	Sat,  5 Nov 2022 03:23:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oUzAPvGEDyJD; Sat,  5 Nov 2022 03:23:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 683E649E1A;
	Sat,  5 Nov 2022 03:23:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E11C749A51
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Nov 2022 03:23:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dRvNpIc8fJhX for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Nov 2022 03:23:37 -0400 (EDT)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A76740FF0
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Nov 2022 03:23:37 -0400 (EDT)
Received: by mail-pj1-f48.google.com with SMTP id
 r61-20020a17090a43c300b00212f4e9cccdso10116408pjg.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Nov 2022 00:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=LgggK8hkZgVH++8BD/dM0aO2tMGo/D//b9l3kVhUdaM=;
 b=U/x0+UrK6WD6QwysmwpCA6LmD53P1GxIR19amIkClJs1U+DHkp7esj810/Xw7URgnY
 6NZVQQh5o9g8yaYpc02GHR8JOzUihaJcqSDdOE4cbtwJ85fzUguLvM3x7ZP842rNUC4G
 IOH+V7ahbW783oQ8t1L6kNWapP1kP/J2F7tFsu6XQqecGj3cX7fYSRayd64pTmcy8HAn
 d6cI4eeNhbX20o3Zwkz6bJbo5zvNtLkTeCPbaESHSN2yBcXQQxv6d5gjfmS+2xwxXfSZ
 fv3McoM3OjyE9c0uf4tT/4mLzwamPM6YxCUj/eClgwuZOznnXV4mUenapD7gr/s648tl
 fm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=LgggK8hkZgVH++8BD/dM0aO2tMGo/D//b9l3kVhUdaM=;
 b=I4z+s/z7A0uIzxR1QJV7waNHdHwohF5PneOSmDV37EykyiaiFT2ARIiJhNYWRAnsIj
 n22Un9xa1F1TduP6foMySbaoP0sLNWoR7RUYfLPpZI32EbINTVHvXPZ9sAXbRqib4SqF
 5kJWL6CoGHrohKBMrHTCehbEg8u8T02WimHaOKHUcHyWVv7wXctvloBW+McLpgQezMiI
 c0yRNjrgQ5gZR4Rj1DX+gXrlc5OHqAjkq21XKErF/MnGrWNJjcieAIM1a806V5dNj3rb
 zl/y2bHs11a7h5Vb1cvHS/+R3h8gPUyTPz357Ii7En3I9UYQuPs/Nbt1yWTDW6YHJd1k
 wAKA==
X-Gm-Message-State: ACrzQf1KgbR632NIDNwCmGnubNuEPtd3HXvtLx1A8CSdU0skHZFWTv/+
 m/IN3pC5uvFgNih31jTZuZS0xA==
X-Google-Smtp-Source: AMsMyM44ZOypFpAKOh/gnh0gedsNVpBtxc3XmEVYmQYriCbTJfC96MuNcATWjqEewuhMoI5TXce8Dw==
X-Received: by 2002:a17:902:e745:b0:187:2033:1832 with SMTP id
 p5-20020a170902e74500b0018720331832mr31176766plf.119.1667633016062; 
 Sat, 05 Nov 2022 00:23:36 -0700 (PDT)
Received: from leoy-huangpu.lan (211-75-219-201.hinet-ip.hinet.net.
 [211.75.219.201]) by smtp.gmail.com with ESMTPSA id
 w27-20020aa79a1b000000b00562ef28aac6sm698138pfj.185.2022.11.05.00.23.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 05 Nov 2022 00:23:35 -0700 (PDT)
From: Leo Yan <leo.yan@linaro.org>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 John Garry <john.garry@huawei.com>, James Clark <james.clark@arm.com>,
 Mike Leach <mike.leach@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Subject: [PATCH v1 0/3] KVM: arm64: Support tracing virtual CPU ID
Date: Sat,  5 Nov 2022 07:23:08 +0000
Message-Id: <20221105072311.8214-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Cc: Leo Yan <leo.yan@linaro.org>
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

Before there have some efforts and discussion for supprot tracing
virtual CPU ID in Arm64 KVM, see [1][2].

The issue was blocked with a main concern that we cannot change the
existed trace events to avoid ABI breakage.  So the question is how
we add new trace events with tracing virtual CPU ID and also need to
keep backward compatibility.

This patch set is to restart the work, it's inspired by Qais Yousef's
work for adding scheduler tracepoints [3].

The first patch changes to register tracepoint callbacks, this can allow
us to support multiple trace events with a single call site, it's a
preparation to add new trace events.

The second patch is to add two new trace events kvm_entry_v2 and
kvm_exit_v2, and these two trace events contain the field "vcpu_id" for
virtual CPU ID.

For more complete view, the third patch is the change in perf tool.
It dynamically detects trace nodes under sysfs and decide to use the
version 2's trace events or rollback to use original events.

This patch set has been tested with mainline kernel on Arm64 Ampere
Altra platform.

Note: I used checkpatch.pl to validate patches format and observed it
reports error for second patch for adding trace events; since the trace
event definition uses its own coding style, I just keep as it is.

[1] https://lore.kernel.org/lkml/1560330526-15468-2-git-send-email-yuzenghui@huawei.com/
[2] https://lore.kernel.org/lkml/20200917003645.689665-1-sergey.senozhatsky@gmail.com/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/kernel/sched/core.c?id=a056a5bed7fa67706574b00cf1122c38596b2be1


Leo Yan (3):
  KVM: arm64: Dynamically register callback for tracepoints
  KVM: arm64: Add trace events with field 'vcpu_id'
  perf arm64: Support virtual CPU ID for kvm-stat

 arch/arm64/kvm/Makefile               |  2 +-
 arch/arm64/kvm/arm.c                  |  4 +-
 arch/arm64/kvm/trace.c                | 35 +++++++++++++++++
 arch/arm64/kvm/trace_arm.h            | 53 ++++++++++++++++++++++++++
 tools/perf/arch/arm64/util/kvm-stat.c | 54 ++++++++++++++++++++++++---
 5 files changed, 140 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/kvm/trace.c

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
