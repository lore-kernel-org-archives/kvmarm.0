Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120F1275AF4
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 06:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755499238; cv=none; b=LVl+n4sOXb+1O/g2InN1GIVi0pPwbsGxMceA6n7688ks9zBglzY4YWdBF+lVM5mb9AbERPdJwQlrIWtIl5PQrHdmZ2RalvJA+IpMin49WW3UYpSCcuTqFHw5nY3ssLKjP0zYh66bDuJJfQHdkx/E+4DcbtT9t8+UrlfLENTeBW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755499238; c=relaxed/simple;
	bh=PqVtQltJJVPFzvDdM8xIl1JmjsoZKNqJCBf6AORsL0w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a5hfwqHTfVEJpwY3TRnuk2a7kzRuTDnn/118x4Ax7DmuVTrWzP7Gm5ypyzJQzuW5QS6ZlhmaRlN5xWcCOtjffkyHcsJIADVAKDCRJt36Lg5EsqqeXGVtNDJWRm4mdPrbEZCi06Y8COm/F1BzCSuNBRnRzyJbdMe+ogLXGRqnJBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=etvIdd9h; arc=none smtp.client-ip=117.135.210.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="etvIdd9h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=IP
	n1FN8sp4GGoUD3tpDW+Holf9bFEHra2JNM2nDhbAg=; b=etvIdd9hPkOSpqQObc
	R+rOFpoKSwuSj4KoCtweaiA89dHvrr89OvXFoXy/4cmqK2S4mlxIffSmwB/Vr9zN
	oUJkSPgIwdV28qzpQD8OGjPUZCqZWFk0xn/ttKhXJj9sqgeOS37E/J578YwH8d26
	R/uCzRdlrmVfuttG9l3X1tM/0=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCkvCgD3v_qxyqJoi5PoBg--.55496S2;
	Mon, 18 Aug 2025 14:39:46 +0800 (CST)
From: lingfuyi@126.com
To: maz@kernel.org,
	oliver.upton@linux.dev
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lingfuyi <lingfuyi@kylinos.cn>
Subject: [PATCH] KVM: arm64: Fix whitespace inconsistency in cpu_reg assignments
Date: Mon, 18 Aug 2025 06:39:42 +0000
Message-Id: <20250818063942.1900014-1-lingfuyi@126.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCkvCgD3v_qxyqJoi5PoBg--.55496S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF4UGrWUWry7uFW3ur48Zwb_yoW8ZF4fp3
	y7tr1jyw48GF1DuayI9a1DX3y8GrZ5tr95Aa98AwnYyryYqwn5Gw4kGayY9rW3AFWxZa4S
	vF1UtF13WayUAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uc18QUUUUU=
X-CM-SenderInfo: polqwwxx1lqiyswou0bp/1tbiYBytR2iivT-o3AAAsq

From: lingfuyi <lingfuyi@kylinos.cn>

Several cpu_reg() assignments had inconsistent spacing around the '='
operator. Some lines had double spaces while others used single space.
Standardize to single space for better code consistency.

This is a pure formatting fix with no functional changes.

Signed-off-by: lingfuyi <lingfuyi@kylinos.cn>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3206b2c07f82..cfe7a82730a7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -232,7 +232,7 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		fpsimd_lazy_switch_to_host(vcpu);
 	}
 out:
-	cpu_reg(host_ctxt, 1) =  ret;
+	cpu_reg(host_ctxt, 1) = ret;
 }
 
 static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
@@ -266,7 +266,7 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
 
 	ret = __pkvm_host_share_guest(pfn, gfn, nr_pages, hyp_vcpu, prot);
 out:
-	cpu_reg(host_ctxt, 1) =  ret;
+	cpu_reg(host_ctxt, 1) = ret;
 }
 
 static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
@@ -287,7 +287,7 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 	ret = __pkvm_host_unshare_guest(gfn, nr_pages, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
 out:
-	cpu_reg(host_ctxt, 1) =  ret;
+	cpu_reg(host_ctxt, 1) = ret;
 }
 
 static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ctxt)
@@ -367,7 +367,7 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
 
 	ret = __pkvm_host_mkyoung_guest(gfn, hyp_vcpu);
 out:
-	cpu_reg(host_ctxt, 1) =  ret;
+	cpu_reg(host_ctxt, 1) = ret;
 }
 
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
-- 
2.34.1

