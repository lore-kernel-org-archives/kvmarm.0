Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6510F17CB
	for <kvmarm@lists.linux.dev>; Sat,  1 Jul 2023 13:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688218652; x=1719754652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SG9GcgXHxEAjLOgy9zCFtnTjBIS7anAQ+78nBSk9tVQ=;
  b=bdVs+75hDIRFJ6pYGN3xQZf0rR+6fVDIizneyXiP4On0jiOVI9kDDEBb
   ZZu0lmClw6q5l4x7AliD6jNzP6tDGe/vAIQw0QLYVweJpCyixljiwBEK3
   kyqEoRJ38ys3FMQ/e2QC1N8cB0e7TSptEcjJ5h0idRSQKdiDMS126NwCi
   pnTTXkv12aI1aeormoKjrjIf1WXnN2zdNWE0O8QDqW9CvQ6dGigemfUzv
   GeQz0nfnJu+BrUxKI4S4s8Ppfc5+x1zjao9NPFzfNTcgpvBR4ID1s4JKA
   vcAQkdE/+M0di44F6lKDNulecZ4H2JgYiP3v9pttcG+ez8ojNxGerZxmc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10758"; a="342926078"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="342926078"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2023 06:37:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10758"; a="747693864"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="747693864"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2023 06:37:24 -0700
From: Haibo Xu <haibo1.xu@intel.com>
To: 
Cc: xiaobo55x@gmail.com,
	haibo1.xu@intel.com,
	ajones@ventanamicro.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	seanjc@google.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Shuah Khan <shuah@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	David Matlack <dmatlack@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v5 02/13] KVM: arm64: selftests: Drop SVE cap check in print_reg
Date: Sat,  1 Jul 2023 21:42:50 +0800
Message-Id: <66676d5e56b6e23e380e6182ab89b33d7c4bb18f.1688010022.git.haibo1.xu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1688010022.git.haibo1.xu@intel.com>
References: <cover.1688010022.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

The check doesn't prove much anyway, as the reg lists could be
messed up too. Just drop the check to simplify making print_reg
more independent.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
---
 .../testing/selftests/kvm/aarch64/get-reg-list.c  | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index c152523a5ed4..915272c342f9 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -100,16 +100,6 @@ static const char *config_name(struct vcpu_config *c)
 	return c->name;
 }
 
-static bool has_cap(struct vcpu_config *c, long capability)
-{
-	struct reg_sublist *s;
-
-	for_each_sublist(c, s)
-		if (s->capability == capability)
-			return true;
-	return false;
-}
-
 static bool filter_reg(__u64 reg)
 {
 	/*
@@ -287,10 +277,7 @@ static void print_reg(struct vcpu_config *c, __u64 id)
 		printf("\tKVM_REG_ARM_FW_FEAT_BMAP_REG(%lld),\n", id & 0xffff);
 		break;
 	case KVM_REG_ARM64_SVE:
-		if (has_cap(c, KVM_CAP_ARM_SVE))
-			printf("\t%s,\n", sve_id_to_str(c, id));
-		else
-			TEST_FAIL("%s: KVM_REG_ARM64_SVE is an unexpected coproc type in reg id: 0x%llx", config_name(c), id);
+		printf("\t%s,\n", sve_id_to_str(c, id));
 		break;
 	default:
 		TEST_FAIL("%s: Unexpected coproc type: 0x%llx in reg id: 0x%llx",
-- 
2.34.1

