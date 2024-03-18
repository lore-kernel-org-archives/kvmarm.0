Received: from mail.linx-info.com (unknown [121.69.130.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E1C2CCD6
	for <kvmarm@lists.linux.dev>; Mon, 18 Mar 2024 09:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=121.69.130.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710755761; cv=none; b=MB2hzKulG8SedwmM5Fad4i/6/tQA2tl2JUEOLsE7CQ9CaIRGJDhbVQ4/02BrlXBJ3H541wzR8oVSZqG7kxWFY3NK9u2IgJKISkpD2VyDFPgZh0ypjlAWKMJ0V56aOVss4k/xeKmWw+h9FdnBE5c/FSMtNPGtXlvG/54tNAOliP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710755761; c=relaxed/simple;
	bh=1WDQFhpKa/R8Ph8lakFDG/bkdD7F7LYb7mVgkweFkZM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g8AnRNHgFkvVPU+gjtmQh8f5gYJoGOA89g+TV1/N5R/Piu5QWrsmkF12n1d/Qn0ImaG2bWs8YhSrOtKUG07+XbRlaY8Ps1ec0H9N3N/1RGlL2LFdqNS3QQnyQtTBbzilsNbj/rWmBnLhAYt02y3MtEQpHHOUldVyoB5ZbsjHDAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linx-info.com; spf=none smtp.mailfrom=linx-info.com; arc=none smtp.client-ip=121.69.130.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linx-info.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linx-info.com
Received: from localhost (localhost [127.0.0.1])
	by mail.linx-info.com (Postfix) with ESMTP id 34FD832118A;
	Mon, 18 Mar 2024 17:47:37 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at linx-info.com
Received: from mail.linx-info.com ([127.0.0.1])
	by localhost (mail.linx-info.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZADa5NBaKCuv; Mon, 18 Mar 2024 17:47:37 +0800 (CST)
Received: from linx.. (unknown [172.16.0.253])
	by mail.linx-info.com (Postfix) with ESMTP id 81216321186;
	Mon, 18 Mar 2024 17:47:36 +0800 (CST)
From: Wujie Duan <wjduan@linx-info.com>
To: maz@kernel.org
Cc: oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	kvmarm@lists.linux.dev,
	Wujie Duan <wjduan@linx-info.com>
Subject: [PATCH] Change back kvm fault condition to translation
Date: Mon, 18 Mar 2024 17:47:35 +0800
Message-Id: <20240318094735.220070-1-wjduan@linx-info.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM: arm64: Condition should be esr_fsc_is_translation_fault
In commit '11e5ea5242e3 ("KVM: arm64: Use helpers to
        classify exception types reported via ESR")'
the KVM code was optimized, but the code logic was incorrectly modified.
Therefore, it is being corrected.

Signed-off-by: Wujie Duan <wjduan@linx-info.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 18680771cdb0..dc04bc767865 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1637,7 +1637,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
-	if (esr_fsc_is_permission_fault(esr)) {
+	if (esr_fsc_is_translation_fault(esr)) {
 		/* Beyond sanitised PARange (which is the IPA limit) */
 		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
 			kvm_inject_size_fault(vcpu);
-- 
2.40.1

