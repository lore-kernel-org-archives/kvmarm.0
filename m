Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC34394497
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 11:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789903044; cv=none; b=D+VnGnX434PuWUFNF7sU/FkBaD80Hzf20tL6GB3oJwRkLkLhqX52PrNYrFKt5sY7WJmpZIu0uugRJe8QGg5nzflQJw2qseB5h17l5JEl+8vErAFOahld2+pgF0oc0FmUPcGrXeKFHSvyIzbWiWSZ89+WQ+muT5Y6qkcNJI6rvJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789903044; c=relaxed/simple;
	bh=MrNqsf8vl79pbAxP49QCfE5TLu/s5O9EUAaIBtYYaqg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dblmJQs3g5ocJK26u9BeDpLHJBub5NX5SllLR29tj+aMe27eMmsCvSy9gXR7CHcVlzcaHB9DqAEVKftexWqPjPN1YRa3gwtUAFAIXCAt90eA9VtoGYXyGfdpZa6Y+vDIZYsH7KbHjahsG8heJR1biXz6GHcPrx83jKSF70Ucvv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=dtHQfMG4; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="dtHQfMG4"
Received: from [192.168.10.153] (p865013-ipoe.ipoe.ocn.ne.jp [153.242.222.12])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68KBG36Q088236
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 20 Sep 2026 20:16:09 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=Vt2ftUzXwwEiNRXjnC8qV9jrJvkIkUdpYX0jSjdAkkA=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789902969; v=1;
        b=dtHQfMG4J2oxJlDgsvUSENT5TaRXH95fbJnfsmbO5SiUXP0qi43UfHw9XdeKmQcU
         C2aJZyVoKZJZ5V34b/ghwMae+i4XGXhHQ0IkhKWUDMcHcPoi6y2Pn+PItiXSTaBs
         gJCN2IMpk1hvdE6i5GXLYzlmbQW033yNoRgoFwdsT4zDccsewrBDZm9xMo3CBcra
         6Nd7XH7vsKaZ/2qUzD9eQtgM8igEGIDl15ZP2/MgOF9wIVkBztK1JINUuF/MXhV5
         8xWnUvuwf3Ck9EfSxBH2hoX6q3UiG27qQrHVIfk1YD3s7fVk4ycDTVgWJIdg+8Ws
         RNgPKnCepB808TqDXFcXGQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Sun, 20 Sep 2026 20:15:44 +0900
Subject: [PATCH v11 03/21] KVM: arm64: PMU: Freeze counter count after
 first run
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-hybrid-v11-3-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Andrew Jones <andrew.jones@oss.qualcomm.com>,
        Fuad Tabba <fuad.tabba@linux.dev>, Mark Rutland <mark.rutland@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1162;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=MrNqsf8vl79pbAxP49QCfE5TLu/s5O9EUAaIBtYYaqg=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9b6A6mrD1z5vilWVrfGcs7FU0/+ayX3nOlcpnzU2NNdb
 1d2Xp9RRykLgxgXg6yYIktK0W5ujejaT4UJ8S0wc1iZQIYwcHEKwESsrzD892bUPfGsa2OmuNom
 TpF0vhDW8NcsfcuYXugWzBe2vGc9neGfJctU3as6p2cUnTneJXuy7sbuJSrnltjsjJMLqW70cyv
 gBwA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

PMU configuration is VM-scoped, but SET_NR_COUNTERS can be issued
through any vCPU. Checking only whether that vCPU's PMU has been
initialized allows userspace to change the counter count through an idle
sibling after another vCPU has run.

Reject the attribute once any vCPU has run. This keeps the VM-wide
implemented counter mask and the PMCR_EL0.N value stable after guest
execution begins.

Fixes: b7628c797376 ("KVM: arm64: Allow userspace to limit the number of PMU counters for EL2 VMs")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 832dd145af2a..950b7a349659 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1112,6 +1112,9 @@ static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
 {
 	struct kvm *kvm = vcpu->kvm;
 
+	if (kvm_vm_has_ran_once(kvm))
+		return -EBUSY;
+
 	if (!kvm->arch.arm_pmu)
 		return -EINVAL;
 

-- 
2.55.0

