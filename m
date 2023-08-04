Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34863A92F
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 10:13:59 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3146C1007;
	Fri,  4 Aug 2023 03:14:41 -0700 (PDT)
Received: from e127643.arm.com (unknown [10.57.3.154])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A9FDE3F6C4;
	Fri,  4 Aug 2023 03:13:55 -0700 (PDT)
From: James Clark <james.clark@arm.com>
To: coresight@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: James Clark <james.clark@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Leo Yan <leo.yan@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Rob Herring <robh@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] coresight: Support exclude_guest with Feat_TRF and nVHE
Date: Fri,  4 Aug 2023 11:13:13 +0100
Message-Id: <20230804101317.460697-4-james.clark@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230804101317.460697-1-james.clark@arm.com>
References: <20230804101317.460697-1-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With nVHE the filters need to be applied before switching to the guest,
so supply the per-cpu filter status to KVM.

Signed-off-by: James Clark <james.clark@arm.com>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index 5ca6278baff4..f78f05e656f5 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -9,6 +9,7 @@
 #include <linux/coresight-pmu.h>
 #include <linux/cpumask.h>
 #include <linux/device.h>
+#include <linux/kvm_host.h>
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/init.h>
@@ -510,6 +511,7 @@ static void etm_event_start(struct perf_event *event, int flags)
 	}
 
 out:
+	kvm_etm_set_events(&event->attr);
 	/* Tell the perf core the event is alive */
 	event->hw.state = 0;
 	/* Save the event_data for this ETM */
@@ -627,6 +629,8 @@ static void etm_event_stop(struct perf_event *event, int mode)
 
 	/* Disabling the path make its elements available to other sessions */
 	coresight_disable_path(path);
+
+	kvm_etm_clr_events();
 }
 
 static int etm_event_add(struct perf_event *event, int mode)
-- 
2.34.1

