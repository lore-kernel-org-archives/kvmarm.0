Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3193A8759
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 05:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784525950; cv=none; b=SrRwLEjFXfXmqiH5gaEVXzSWbrSb32jLVNrI0PgFNgE1yOSS7WdhnBBjWx/LDS/ea/8uKdhY9+M6aspQnjYwqBQpevUCeAUJfWnpbwr4Vg1vPm0BGX9ITpFAyTRW+eD1OVzvk8c9ubet3S0WA1yHOvwCc9h8urv2uhAxchIvc/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784525950; c=relaxed/simple;
	bh=nDU8HixdRK1d+2i2v52T+AZ6ha5pTl2G+ZCt/ZW0yyI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=heftz2NvvtGzvMquOWLY5BQayCvAZ/vxIINwK9LUFEebP6f83OqtRsMv5718VQSKRQlNmxWv6WP3SUBwfPYnuuW6NdFCHeWo5388o4HtbjHxPGBd9C4s4Yrpimyp6/KXgD1yIvfsJOeNKv8WeaPeMvXE0Z6/oGlGULJ8eBhA/xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=AZH0nuF/ reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="AZH0nuF/"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66K5c7ou075973
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Jul 2026 14:38:28 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=ieFQW3xe2YYYDcYZo+2gysoiQSrGYoM9MEjQ+nrFpOg=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1784525909; v=1;
        b=AZH0nuF/xXQaSP46dM8HH0MZuKjJeAaUaaLl83y8jHsvOO6qDlwtf97xkLV6DbnN
         OX+5w3p1K2tj8MMwz8cVtKWD8w90P+22cS7CZMIZ2/PFsoZTjf6lBjPyAgwKD6Nu
         UmN3n3lSV3YbSNU1fHpnGchMu89JPetp4+9wFrolKvroAmFZ2ozpkXrFdZhV/Pr8
         fV3O0YtthXdPE7wQRwXU5jmK7KszqgvUpCspETi7Iyb3OAM16VQbX4uXUXwTbkf+
         DsL6fuSG6j4XPSachvWDDGdJqNqx7fhKRyLNWWvB6/M4oyR/vnGtSa7ozWKoZey6
         6dJoDjigTDDYVtiac9Q5GA==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Jul 2026 14:38:06 +0900
Subject: [PATCH v9 12/16] KVM: arm64: PMU: Pass the pPMU to
 kvm_map_pmu_event()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hybrid-v9-12-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1455;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=nDU8HixdRK1d+2i2v52T+AZ6ha5pTl2G+ZCt/ZW0yyI=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bsFh8vq4BJpRNjM/9+n1184c2Pm9Pue6hynNdcUKfyp
 n32CWWrjlIWBjEuBlkxRZaUot3cGtG1nwoT4ltg5rAygQxh4OIUgIkIszAyvEhaL5L38Dr30hvn
 BIw/d3v8XGnSnPB3Kyvvlkmz/8mc/MbIcN3BuLRCqfuH4nfH98eOz1J7O41p6b7yiD37Hr7g6JO
 6zQgA
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

Replace the VM argument with the pPMU used for event creation. The
current caller still passes the VM's default pPMU, but this removes the
implicit lookup from kvm_map_pmu_event() so later changes can map events
against the pPMU selected for an individual vCPU.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/pmu-emul.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index c5c505b6fc61..27db8877f96e 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -670,10 +670,8 @@ static bool kvm_pmc_counts_at_el2(struct kvm_pmc *pmc)
 	return kvm_pmc_read_evtreg(pmc) & ARMV8_PMU_INCLUDE_EL2;
 }
 
-static int kvm_map_pmu_event(struct kvm *kvm, unsigned int eventsel)
+static int kvm_map_pmu_event(struct arm_pmu *pmu, unsigned int eventsel)
 {
-	struct arm_pmu *pmu = kvm->arch.arm_pmu;
-
 	/*
 	 * The CPU PMU likely isn't PMUv3; let the driver provide a mapping
 	 * for the guest's PMUv3 event ID.
@@ -725,7 +723,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	 * Don't create an event if we're running on hardware that requires
 	 * PMUv3 event translation and we couldn't find a valid mapping.
 	 */
-	eventsel = kvm_map_pmu_event(vcpu->kvm, eventsel);
+	eventsel = kvm_map_pmu_event(vcpu->kvm->arch.arm_pmu, eventsel);
 	if (eventsel < 0)
 		return;
 

-- 
2.55.0

