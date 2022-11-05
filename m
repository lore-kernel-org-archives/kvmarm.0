Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188251C04
	for <kvmarm@lists.linux.dev>; Sat,  5 Nov 2022 07:23:36 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id h14so6337197pjv.4
        for <kvmarm@lists.linux.dev>; Sat, 05 Nov 2022 00:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
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
        b=1GAsMGOiaPH0ouMUlYD3SE3+0P3B/pI+wfpBRIDHxD8XzlNfs3YLVxzr1LCzaGGkkT
         VI+b1ZWpnnrVfDUdZtw7BtHS3J3DVVPD6GvWTf1YjES0gPqjhlc4aNse8KCuUVTo80yC
         nFC+AwGV+Sgso9oURPU3KRpSy+uG2bkLba/ymRpYs6YbwMqVzWZtOA880LG+NcZa2S7y
         CnzYHydO5K62W1Ti/voIRC8LprqAtlYbg1VntX+6Uy75Yg+73F/1pzv1vSU1iRbkTf/d
         FkZZA4pmMTuDWgYDqkWBfZulaXf/uW/ZTmjTYUA05MDlrVl5FfupwCK0iGxRGq17wgD1
         5Spg==
X-Gm-Message-State: ACrzQf3W9BSYMAowwBGrYPLMuiYhCifSPBahsyHxPgv9WFcarAaKnKgW
	KdxNN3zMBVVbIk7JSg2LFUy5UQ==
X-Google-Smtp-Source: AMsMyM44ZOypFpAKOh/gnh0gedsNVpBtxc3XmEVYmQYriCbTJfC96MuNcATWjqEewuhMoI5TXce8Dw==
X-Received: by 2002:a17:902:e745:b0:187:2033:1832 with SMTP id p5-20020a170902e74500b0018720331832mr31176766plf.119.1667633016062;
        Sat, 05 Nov 2022 00:23:36 -0700 (PDT)
Received: from leoy-huangpu.lan (211-75-219-201.hinet-ip.hinet.net. [211.75.219.201])
        by smtp.gmail.com with ESMTPSA id w27-20020aa79a1b000000b00562ef28aac6sm698138pfj.185.2022.11.05.00.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 00:23:35 -0700 (PDT)
From: Leo Yan <leo.yan@linaro.org>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	John Garry <john.garry@huawei.com>,
	James Clark <james.clark@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v1 0/3] KVM: arm64: Support tracing virtual CPU ID
Date: Sat,  5 Nov 2022 07:23:08 +0000
Message-ID: <20221105072311.8214-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221105072308.B-MF0jir9b5H1pg67jEtUGgS-0j4mO30mz6_7dHw0lE@z>

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

