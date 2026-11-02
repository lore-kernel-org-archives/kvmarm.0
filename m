Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793628832;
	b=n9R+sKwazioe4t/Gz+afljCD5ghfNw/8E/LY6cVdj/+NRSmFX96ACSiR/qa13tXenuUO
	 N/B012jDEoY5YOXKu1cIvhSwNVUXsH0FiTR0maLIEiUUFSkzhOXYGxNvqyyCYAwXV+t1R
	 4qenODlV/7zXeODPhqUyyR2dLdBQENAHKt+12iR0qalagIkJyihGk6t5CQuMeZfHYXmT3
	 +rp4TaL3CxCxotXpBLM/xk4gV/TwYEoMRK0EQMykpDWIr0oc+n9TBNbV0rj/lxFUAK9BH
	 Tkx0AdgzOQsIGFhxQ59giQyJfiaB4I7SBRuZZHHVUfkZ3m4SIwJ0l7FKj8YdmjCZdEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628832;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ET496Gzwj43x8I7ewRvTn0IIrLk3rzMMwwxV+tD8iR0=;
	b=WPJTFfpdP/LyXjjAwzDwC00FLl9gg9PzGIu8ms+vjq0qvXnXVLI/tR+6RxpianGvGVdZ
	 qeTKwTRswQKWDSBPmgj4H/3FCZ1a2YwD2s0yQOBP6A96K/+d0SnUEK19RAMX3S5msT5sZ
	 NcAOuXGg+iThiHWfUwaG2NqQWBrOTd88D7AmHEOtk2Pq/qmYA/vzlU2OKJvg2t47LFJze
	 cfyT0VXzFZVMp297+S5RDNOvbRlQ8CouzdlR3HnYnbyxpgdB55ZeFEsVA9BeV0L5m6G0C
	 tZa9bj17UOUBuq6Ee0KsbDH+Wy11btoxM1fmA9nIcBdgT56DPnZN/UrGcfKPyc5xYqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CxyBiLlf;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F8360A2604;
	Mon,  2 Nov 2026 14:13:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50F8360A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CxyBiLlf
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B8342A6B;
	Mon,  2 Nov 2026 06:13:46 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 773743F59E;
	Mon,  2 Nov 2026 06:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793628829; bh=5GOUK/m9ms1YU9j5P67FGLqCUA3VCOThOsPuqKea4gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxyBiLlfzyRJ7kfsy06U1+1A4KmThWoeNEv+JKzVoTAUt3oZmI+hyYtrXiC+MWG3f
	 cC1pdZtB4exgq02AEiFOGkhMez/dHZkXiGS7ViY5eH9ZUX3mNngjYYPOdUga3Dz1+k
	 IdTZBYljvvAR4f1vg5agoAw254aZxWAM7INir6XA=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 04/11] KVM: arm64: CCA: Check for LPA2 support and SHA-256
Date: Mon,  2 Nov 2026 14:12:55 +0000
Message-ID: <20261102141304.126883-5-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102141304.126883-1-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If KVM has enabled LPA2 support then check that the RMM also supports
it. If there is a mismatch then disable support for realm guests as the
VMM may attempt to create a guest which is incompatible with the RMM.

Also check for SHA-256 support in the RMM as to begin with we only
support SHA-256 based measurements. This can be relaxed in the future.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/rmi.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 9d118768550d..5b07beff8bc9 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -6,8 +6,30 @@
 #include <linux/arm-rmi-cmds.h>
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_pgtable.h>
 #include <asm/virt.h>
 
+static bool rmi_has_feature(int reg, unsigned long feature)
+{
+	return !!u64_get_bits(rmi_feat_reg(reg), feature);
+}
+
+static int rmm_check_features(void)
+{
+	if (kvm_lpa2_is_enabled() &&
+	    !rmi_has_feature(0, RMI_FEATURE_REGISTER_0_LPA2)) {
+		kvm_err("RMM doesn't support LPA2\n");
+		return -ENXIO;
+	}
+
+	if (!rmi_has_feature(1, RMI_FEATURE_REGISTER_1_HASH_SHA_256)) {
+		kvm_err("RMM doesn't support SHA-256 measurements\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 void kvm_init_rmi(void)
 {
 	if (kvm_get_mode() != KVM_MODE_RMM)
@@ -16,5 +38,8 @@ void kvm_init_rmi(void)
 	if (!is_rmi_available())
 		return;
 
+	if (rmm_check_features())
+		return;
+
 	/* Future patch will enable static branch kvm_rmi_is_available */
 }
-- 
2.43.0

