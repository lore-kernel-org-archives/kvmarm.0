Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722D339AE8
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705916736; cv=none; b=djkrXzVALsv4v+cLwASEG2y8RA/+DLf2Skym9P4vmZZllNv3gWf0iyZaZdCVrhNl/bWNtuWEIVNXfgE14cQPwxQ8ct5gsAjO7x1EIaCiUFkiVbUEV9iQYT3/Z7etE8nRhzcvCZ0TrAgMg2exvh6lk/G50qOvN0xhlDylnNkG/nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705916736; c=relaxed/simple;
	bh=g6et7PUrB+XhJnaLfQ/iOAuZuiRzqn2XXWA27POxfk8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lZas4kJZQW5S/wZJ7pqvVEu/IfY6tdF9V4DvrTRm3El1ZEgZrLkn5PdW0rXHLbV5JgaFKUosz6KDq3rEhMG0jsQUTu1b7ZqYG5BfLEV89anluXSu9SmFQURm8OijDFtxfoTKHrre3H4JdFSnFjEyL4C7EBz70/IRL8ACTjQWAMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CEC/MjtT; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CEC/MjtT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705916736; x=1737452736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g6et7PUrB+XhJnaLfQ/iOAuZuiRzqn2XXWA27POxfk8=;
  b=CEC/MjtTEvL70KJAVjpApVXTQXmxGZItOPP228P+/MfcAYUUgwN0DRGP
   ODCLSp0rWYrAmsNk9oIV9iXMavFDINoQ1HtI7A9uCzlGylnp/hU8idQ72
   FQuwQEwrFGC7jQa/9zLo0xXb7+HNJHWq02RR4NlMgZNRH9wX0VLmzIuXF
   54MWG/8pLlGdPl4TAemSRF9wk0UENV9hp5RBq7ccWnZjGvnCr41m0zzM9
   I6BR8HLYgmNQuQfNHb4Sfw0TXWwYwmt7ch2qLWriQA+vdOnYKAivb7hhl
   fpJHM6IgpDAKDtLrj3g0nPJX4QXAEvJCRmiIuHY9/Lsb0+CVIs9FrCUHV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="22641573"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="22641573"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 01:45:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="778535319"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="778535319"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 01:45:25 -0800
From: Haibo Xu <haibo1.xu@intel.com>
To: 
Cc: xiaobo55x@gmail.com,
	ajones@ventanamicro.com,
	Haibo Xu <haibo1.xu@intel.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Guo Ren <guoren@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	wchen <waylingii@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Samuel Holland <samuel@sholland.org>,
	Jisheng Zhang <jszhang@kernel.org>,
	Minda Chen <minda.chen@starfivetech.com>,
	Sean Christopherson <seanjc@google.com>,
	Peter Xu <peterx@redhat.com>,
	Like Xu <likexu@tencent.com>,
	Vipin Sharma <vipinsh@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Thomas Huth <thuth@redhat.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [PATCH v5 02/12] KVM: arm64: selftests: Data type cleanup for arch_timer test
Date: Mon, 22 Jan 2024 17:58:32 +0800
Message-Id: <173c9b64c4c43cd585f6b177a7d434dcedc905fa.1705916069.git.haibo1.xu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1705916069.git.haibo1.xu@intel.com>
References: <cover.1705916069.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change signed type to unsigned in test_args struct which
only make sense for unsigned value.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 274b8465b42a..3260fefcc1b3 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -42,10 +42,10 @@
 #define TIMER_TEST_MIGRATION_FREQ_MS	2
 
 struct test_args {
-	int nr_vcpus;
-	int nr_iter;
-	int timer_period_ms;
-	int migration_freq_ms;
+	uint32_t nr_vcpus;
+	uint32_t nr_iter;
+	uint32_t timer_period_ms;
+	uint32_t migration_freq_ms;
 	struct kvm_arm_counter_offset offset;
 };
 
@@ -57,7 +57,7 @@ static struct test_args test_args = {
 	.offset = { .reserved = 1 },
 };
 
-#define msecs_to_usecs(msec)		((msec) * 1000LL)
+#define msecs_to_usecs(msec)		((msec) * 1000ULL)
 
 #define GICD_BASE_GPA			0x8000000ULL
 #define GICR_BASE_GPA			0x80A0000ULL
@@ -72,7 +72,7 @@ enum guest_stage {
 
 /* Shared variables between host and guest */
 struct test_vcpu_shared_data {
-	int nr_iter;
+	uint32_t nr_iter;
 	enum guest_stage guest_stage;
 	uint64_t xcnt;
 };
-- 
2.34.1

