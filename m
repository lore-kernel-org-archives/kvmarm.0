Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51E13A875A
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 05:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784525950; cv=none; b=RxPyojrc8ZrPGLJAdjZ2HSD6HyAcwIknsVEQlfByh00ZK0FfxNKYsdEkWw3wSRQc6vWqp3ZhG15mHzmOakn3WEAhjcEEFGj5zD6czxxGYtfwAa097SXRiCSgLB+qrqix/OOr757qWopAXVGoDJ1Sw0dLFISFWfz8bUNGPZDZCvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784525950; c=relaxed/simple;
	bh=8DcNWD473O5mxKX4hIYKD0DwQc9QDM6rn/VJdtyi9jg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pth9Ki8/shqydtcfUqbPEDLP9Qsim+yO2XQz9313Zfkn/mIyQhcKiqodTCPEe9zC07PtMzUBb7xl2SooEruQONdjlPP2hniMgB8hw2MmUQglelnPOVadEclQOJhlupUZPo1APqeA20AnOc2mGxKkYxAozn5XYMj27Xd+WaVH0e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=KR9J/1Ls reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="KR9J/1Ls"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66K5c7ol075973
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Jul 2026 14:38:25 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=0hksgsoHb+5DPEqDI69vVoWioOdWpzFWo2XEINBkKEY=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1784525906; v=1;
        b=KR9J/1LsfcCUHiMKtSXTbiglekYsTdFxmUTKfBN55AS3aEINv6Zv7uLbXeoND/tQ
         l6KYch1zNeOAzBqeI6GLTxYhk2ipCxNMldf9dSHxe2QBEa3KDNLTq8ggkCM6LGC8
         jvllIlTKUkZ4GajUWKNaX9xxYcEC3e6cWc/8JYo6vLDHbfVba32+o/MGxLwA5Ic0
         x8KCZu4IWmDazK5jEb7xM055vqqzghw2I+ey/rMrk/7IMpIKNcvT8lUSLaxboOAC
         DcmrbrJphLS3jNQNMS3Ev9h7VJsSS39Ldps22jVT18l/zL9/8p5gbzyqv4F9AdsB
         vojYUpqc+eLoLvjkgmZszg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Jul 2026 14:37:57 +0900
Subject: [PATCH v9 03/16] KVM: arm64: PMU: Freeze counter count after first
 run
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hybrid-v9-3-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
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
        Steffen Eiden <seiden@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5
X-Developer-Signature: v=1; a=openpgp-sha256; l=1114;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=8DcNWD473O5mxKX4hIYKD0DwQc9QDM6rn/VJdtyi9jg=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bsFpdWCZXNC13nb33sknhDYZrRs2Sm3+/el3NfSjvy3
 zRLJWZyRykLgxgXg6yYIktK0W5ujejaT4UJ8S0wc1iZQIYwcHEKwETaWRgZ5u/ee9gnmnfj3v6J
 b7mDJJRMom8/c/N4wBYteE73ZW3zcoY/POq3P779e25nZtBbjySrZw5aOhuLKjJOumSvPmAU+eA
 bGwA=
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
---
 arch/arm64/kvm/pmu-emul.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b5df6843dbcd..b4b877f31097 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1087,6 +1087,9 @@ static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
 {
 	struct kvm *kvm = vcpu->kvm;
 
+	if (kvm_vm_has_ran_once(kvm))
+		return -EBUSY;
+
 	if (!kvm->arch.arm_pmu)
 		return -EINVAL;
 

-- 
2.55.0

