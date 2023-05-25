Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D52BE61
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 07:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685000136; x=1716536136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+u1HJaFTXrPVFD+3NbnmJ/AGWJcDm8pIPpTYzo4Zo5U=;
  b=Oy5RzMN99zRg3lr59Dd3pxL1aerIpWUHNuYn8sHGNfiNixdDooXEbj88
   5ldTu0W4D9Z11wK83PcH87UEtIzDw3VOvhNGr9rpS8SVhKfgbRivs1yJl
   ev06eEf6C2TNiQZcyO1Ak+eq2CoOWGkFYh31yRvv4kR7/hPNfwh6erlX8
   bVcZAVZnoK3wN5YocskmJ60Nif9Tnl68Ezd77MbmuVI5L6cxCqzGlSKGu
   ZO+cI2/LW1SqcHjMfjsLbYdssgFPQqW/od6yIUdX4om/S0zif6oRhPbAo
   /DD8oYCLBssKkXRehdVK+OISnbs54+ykOT0hrINRoaWGQLKabmX40tP4R
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="356164561"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="356164561"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 00:34:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="769776197"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="769776197"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 00:34:48 -0700
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
Subject: [PATCH v2 10/11] KVM: riscv: selftests: Skip some registers set operation
Date: Thu, 25 May 2023 15:38:34 +0800
Message-Id: <a10cd1ff57e07e408d08eca7e6a4557217ca0af3.1684999824.git.haibo1.xu@intel.com>
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

Set operation on some riscv registers(mostly pesudo ones) was not
supported and should be skipped in the get-reg-list test. Just
reuse the rejects_set utilities to handle it in riscv.

Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
---
 tools/testing/selftests/kvm/get-reg-list.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
index f1fc113e9719..ebd6b580b33b 100644
--- a/tools/testing/selftests/kvm/get-reg-list.c
+++ b/tools/testing/selftests/kvm/get-reg-list.c
@@ -211,16 +211,22 @@ static void run_test(struct vcpu_reg_list *c)
 			++failed_get;
 		}
 
-		/* rejects_set registers are rejected after KVM_ARM_VCPU_FINALIZE */
+		/*
+		 * rejects_set registers are rejected after KVM_ARM_VCPU_FINALIZE on aarch64,
+		 * or registers that should skip set operation on riscv.
+		 */
 		for_each_sublist(c, s) {
 			if (s->rejects_set && find_reg(s->rejects_set, s->rejects_set_n, reg.id)) {
 				reject_reg = true;
-				ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
-				if (ret != -1 || errno != EPERM) {
-					printf("%s: Failed to reject (ret=%d, errno=%d) ", config_name(c), ret, errno);
-					print_reg(config_name(c), reg.id);
-					putchar('\n');
-					++failed_reject;
+				if ((reg.id & KVM_REG_ARCH_MASK) == KVM_REG_ARM64) {
+					ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
+					if (ret != -1 || errno != EPERM) {
+						printf("%s: Failed to reject (ret=%d, errno=%d) ",
+								config_name(c), ret, errno);
+						print_reg(config_name(c), reg.id);
+						putchar('\n');
+						++failed_reject;
+					}
 				}
 				break;
 			}
-- 
2.34.1

