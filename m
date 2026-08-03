Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BEBE41D134;
	Mon,  3 Aug 2026 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764824; cv=none; b=txsN5A3G9TUySY4iM3tpO8onpmq8U45qv3ibec8ODl7teWo77r5WIWwVDCxxDZOGcoZIbIhCvkIFVE6uFJSqTdsCPdaIMv/FC9AxY6k+z8jhDMazIAui7+5qCFXKMUkCoIiVJ82TXkwFXdAp0KcMN8V3C1Rm1FIHlvni6dn4pI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764824; c=relaxed/simple;
	bh=R90GSqHKgNKLq0IbPcgJ2Xy7BoduOtRWpnHj0KKueKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkx0DtQLt8WmxDwA0wthnKyWHsbYJYQ6Iok8ojO2CWB+gkQV55GI0NGbGu6/LJDAok78Cld9vJ7yYlBsnRtXNtoYA3QlrHd/jjKzRcpPacjrPGr5qsOmovzvgxKgTt5ZWIcOrqKtjZOemb+5qaSAtDanO4/hZbqJ9bMhUbL5kPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W5i9r3b6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W5i9r3b6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6C3C1655;
	Mon,  3 Aug 2026 06:46:57 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B96F3F66F;
	Mon,  3 Aug 2026 06:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764821; bh=R90GSqHKgNKLq0IbPcgJ2Xy7BoduOtRWpnHj0KKueKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5i9r3b6l4ACstwJ4hcdMWGUNalMjpqK3Kfd2nYwLQ/rPRTuQYAK7sF0ZcIktlg2B
	 HasUL/a8gkc/mzH1Bv24AeL0mjMDbypOSPJ+yuhJ4kIVYfC73yJuZiUsIlugGhPmd6
	 /2xke7+wX/ywgclM9eJm8JOCYys0O6htTk+rDxZ8=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v16 35/45] KVM: arm64: CCA: Support RSI_HOST_CALL
Date: Mon,  3 Aug 2026 14:43:51 +0100
Message-ID: <20260803134403.80630-36-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Realm VMs can talk to the hypervisor using the RSI_HOST_CALL SMC. The
RMM forwards this to the host and KVM handles them as regular
hypercalls.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Adapt to new exit handling.
Changes since v7:
 * Avoid turning a negative return from kvm_smccc_call_handler() into a
   error response to the guest. Instead propagate the error back to user
   space.
Changes since v4:
 * Setting GPRS is now done by kvm_rec_enter() rather than
   rec_exit_host_call() (see previous patch - arm64: RME: Handle realm
   enter/exit). This fixes a bug where the registers set by user space
   were being ignored.
---
 arch/arm64/kvm/rmi-exit.c | 1 +
 arch/arm64/kvm/rmi.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
index 1749cde2edff..7cde820bb77b 100644
--- a/arch/arm64/kvm/rmi-exit.c
+++ b/arch/arm64/kvm/rmi-exit.c
@@ -164,6 +164,7 @@ int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
 	case RMI_EXIT_SERROR:
 		return ARM_EXCEPTION_EL1_SERROR;
 	case RMI_EXIT_PSCI:
+	case RMI_EXIT_HOST_CALL:
 		rec_exit_hvc(vcpu);
 		kvm_make_request(KVM_REQ_RMI, vcpu);
 		return ARM_EXCEPTION_TRAP;
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 3f31ad25680f..904df7c7245d 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1203,6 +1203,10 @@ int kvm_rec_handle_request(struct kvm_vcpu *vcpu)
 		return kvm_rec_complete_psci(vcpu);
 	case RMI_EXIT_RIPAS_CHANGE:
 		return kvm_complete_ripas_change(vcpu);
+	case RMI_EXIT_HOST_CALL:
+		for (int i = 0; i < REC_RUN_GPRS; i++)
+			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
+		break;
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unhandled realm exit_reason");
 		return -ENXIO;
-- 
2.43.0

