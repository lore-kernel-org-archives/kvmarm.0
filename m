Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4348F53
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 07:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685000120; x=1716536120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c+5BYx6uxDzf2AOSUkteXATXATp9lAsrDmetUgOlVVk=;
  b=lMPmTih9SnsLYtUi2njKtoKwcJ08vzwSCYZn34IQD1iWvmNa3ZRSVPbW
   7i5zgFYQAXXDgoKwhoq++6qfGaT7D6E316Xkmu8Si9XZAeamz/MVuOnDd
   I4sxUOrUCognQBTfSqZ/l8TIZFPcohq1I9yx1IWDTwnFLvYgdClMdyfmQ
   xjHFU1AKhVuD+Y+kOVY+sTz9aAoiOhW78zZFXiAvQw5nmxFLkEsNCB/tV
   KdxyyMs65or/AmtJE/4E2VSa5Wh4c9Gx6W+oSuxmvb26aQLMaibnHtGrl
   MBs6S6Z4fIyu+QECsv+NULNl/bEIXFyDYrwW0hUIVR1noOOvpeVSbeL1X
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="417280982"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="417280982"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 00:33:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="769774904"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="769774904"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 00:33:00 -0700
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
	David Matlack <dmatlack@google.com>,
	Ben Gardon <bgardon@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 02/11] KVM: arm64: selftests: Drop SVE cap check in print_reg
Date: Thu, 25 May 2023 15:38:26 +0800
Message-Id: <259df68b544dd7254fe4a65be8f39e9d766ac6da.1684999824.git.haibo1.xu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1684999824.git.haibo1.xu@intel.com>
References: <cover.1684999824.git.haibo1.xu@intel.com>
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

