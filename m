Received: from mail.linx-info.com (unknown [121.69.130.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C932D61B
	for <kvmarm@lists.linux.dev>; Mon, 18 Mar 2024 10:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=121.69.130.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710756175; cv=none; b=K8FqC9noMrQSU600XaO/qWEXTQI1GFDUzFGYDtB1ZpiOkVrcW7mv1rUorfA+q9xlktWPpipBknkDVbeksm5LtTIu+IqKKasaRTX5EofPd9FwYCVcgUnUOmsdC38gXE0DRIADKdOR41/m/rXtFXzRaaHbtFq4wn7c/xlXg2Cx9HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710756175; c=relaxed/simple;
	bh=EvlgHDWmzdvnNrNyl/1/m1REhFbIQScAOUNceqJZrmg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YxrVL1Iy6T3cydQcSwWFAD4LNumHzss4aZt5LuWs9Pa36YSJejn4lVVNpbShPug7Zsgh9FpsGuTWawFy6yTOMw95j15eYhHutN7lY9497Z9PzVE4m4aMxCURwibV3TgzR/LdMro2HEzofbowGQX2tS2FaZMQlhPzG2Lsjqvn8kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linx-info.com; spf=none smtp.mailfrom=linx-info.com; arc=none smtp.client-ip=121.69.130.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linx-info.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linx-info.com
Received: from localhost (localhost [127.0.0.1])
	by mail.linx-info.com (Postfix) with ESMTP id 16AFB32118B;
	Mon, 18 Mar 2024 18:02:52 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at linx-info.com
Received: from mail.linx-info.com ([127.0.0.1])
	by localhost (mail.linx-info.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hsff18ftpPwW; Mon, 18 Mar 2024 18:02:51 +0800 (CST)
Received: from linx.. (unknown [172.16.0.253])
	by mail.linx-info.com (Postfix) with ESMTP id 5F123320CE6;
	Mon, 18 Mar 2024 18:02:51 +0800 (CST)
From: Wujie Duan <wjduan@linx-info.com>
To: maz@kernel.org
Cc: oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	kvmarm@lists.linux.dev,
	Wujie Duan <wjduan@linx-info.com>
Subject: [PATCH] KVM: arm64: Change back kvm fault condition to translation
Date: Mon, 18 Mar 2024 18:02:49 +0800
Message-Id: <20240318100249.220897-1-wjduan@linx-info.com>
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

