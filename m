Received: from out-206.mta0.migadu.com (out-206.mta0.migadu.com [91.218.175.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97B8328CD
	for <kvmarm@lists.linux.dev>; Wed,  4 Oct 2023 23:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jjjQI7sI"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696463406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mcIa/NkG2FAKexwMOC6WDg/mn/GraXvI+ND48eIlonE=;
	b=jjjQI7sIy3PUhEiPyR2Mld6Iu6fYNaGRku3ewb2rDTcKpqGRQnBF3mkzj7X0hfY23GzbPq
	x2og+KorcnH0sregQ0vwE1DOIN1sZ3HR6FWde5SzC1ICXiGhB8t3XQIvaN3K1m3TlW7gdu
	1/2VnR+6HO6HNEOrqNYJPiwIzIZr96I=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/3] KVM: arm64: Add a predicate for testing if SMCCC filter is configured
Date: Wed,  4 Oct 2023 23:49:45 +0000
Message-ID: <20231004234947.207507-2-oliver.upton@linux.dev>
In-Reply-To: <20231004234947.207507-1-oliver.upton@linux.dev>
References: <20231004234947.207507-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Eventually we can drop the VM flag, move around the existing
implementation for now.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hypercalls.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 7fb4df0456de..35e023322cdb 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -158,6 +158,11 @@ static void init_smccc_filter(struct kvm *kvm)
 
 }
 
+static bool kvm_smccc_filter_configured(struct kvm *kvm)
+{
+	return test_bit(KVM_ARCH_FLAT_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags);
+}
+
 static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user *uaddr)
 {
 	const void *zero_page = page_to_virt(ZERO_PAGE(0));
@@ -201,7 +206,7 @@ static u8 kvm_smccc_filter_get_action(struct kvm *kvm, u32 func_id)
 	unsigned long idx = func_id;
 	void *val;
 
-	if (!test_bit(KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags))
+	if (!kvm_smccc_filter_configured(kvm))
 		return KVM_SMCCC_FILTER_HANDLE;
 
 	/*
-- 
2.42.0.609.gbb76f46606-goog

