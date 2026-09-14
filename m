Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78E54457CE
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386162; cv=none; b=bIDw5isB8twvIX73CckN3XPcm76P0SgbIQvK+3f0x/rWtskIkZnhEozo041ZQAR4E1x1zyIygNX4tzxNWesG+5oxEUTOKxmusbVmnmiW6MMi2uuUCjgYohGu1PMHlorDytPKZfYaLlPkOtrGFDXTZ43HIjuK+Ikp4oyGgvvvHOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386162; c=relaxed/simple;
	bh=LrukgUWWYCoVD9RuLzVkt98Efju8z5qABGWz/GdUAAE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Gv6cXIaQD4sMuX8ltt14LjcLBoi+/VdmmfyUgGna34fRF2Fd+LwKcidBE8QJCKw3qyg6ICO/jLFcAD6ZIZ8X2umrmDkAEQiG1LJPv5sWsX6HrSREQfMiD86lYHUw3kscTyVnBQ2t2HEIWqMcOFHJqWRe7ywK6wfbKAKA3KeHkmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=GWPGqv3h; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="GWPGqv3h"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjs8084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:53 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=bzn7N8+9qJey8yV2EeEgMxhxaQF1swXt+7CAswPQR14=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386113; v=1;
        b=GWPGqv3hokmqSiG2ABuIl59Q586hJ1sSx1sLqhjhSmFPSPowFqk3Y1iF9Yy++Q7h
         PC8GLkWPOMz1M87cM1TJlICT39aKTJgyKK5TII1e7Mmjm9QulqdojOGoBhWVDoqU
         8FPt38FL8oJob9px1NoQdrDl/GTYWyUuIrvFVhSvKmoQBudh9Z0ySZDfMjq4k/K5
         tLlDKQ4kklvx6b66arla+GwFeoiCAMInZ0FM7VutTlX675J00kXJG29DAfK+cy7n
         RpoYpPZlKexq/PpKJg6M5Ug8skLMxk75SKvFeIIZjX2WM6JyQ4/+l6dm71UB2wGL
         pwztGU5F6H4QCy3iENX+hA==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:45 +0900
Subject: [PATCH v10 06/20] KVM: arm64: PMU: Preserve EL2 bitmap state
 during migration
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-6-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
References: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
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
        Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1745;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=LrukgUWWYCoVD9RuLzVkt98Efju8z5qABGWz/GdUAAE=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byu3lLHjAEdfotOSoS06ttnhN+Q+h8HRfrjw1fzj7a0
 npcvoyvo5SFQYyLQVZMkSWlaDe3RnTtp8KE+BaYOaxMIEMYuDgFYCK1oowMa/9M+r7vjzPblutx
 T6vLe3MkfW3/CLIa2pcWPsjY/8vnKMP/YOlNPV+KcrJ7eZ8kL4zcKe7Gsqt7zpLkDZ3esyf2+wT
 zAAA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

KVM_GET_ONE_REG and KVM_SET_ONE_REG transfer raw vCPU state for
migration. Masking PMU bitmap registers with counters accessible at the
current EL drops EL2-reserved bits when the vCPU is stopped in EL1 or
EL0.

Use the implemented counter mask for these userspace accesses so the
complete bitmap state survives migration. Guest register accesses
continue to use the accessible counter mask.

Assisted-by: Codex:gpt-5.6-sol
Fixes: 9a1c58cfefb0 ("KVM: arm64: nv: Adjust range of accessible PMCs according to HPMN")
Closes: https://sashiko.dev/#/patchset/20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=5
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d..42b6705bc21d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1326,7 +1326,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 val)
 {
-	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
 	__vcpu_assign_sys_reg(vcpu, r->reg, val & mask);
 	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
@@ -1336,7 +1336,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 
 static int get_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 *val)
 {
-	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
 	*val = __vcpu_sys_reg(vcpu, r->reg) & mask;
 	return 0;

-- 
2.55.0

