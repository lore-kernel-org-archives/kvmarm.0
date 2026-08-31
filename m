Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10012EA498
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 19:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204253; cv=none; b=YyPOTqKJERWYDdDRKHwwY+JWNXzEa4unMgHHPQdwvIPAnx2FlFoBnsOPVQnqcC54B2wFZQmTLWpyCmDMF4PNousZlVr9b8WERDOu+Df0hPuvWXCq7EQNzhqdo2BLrRrZXGY4VUJAcJSxm7Lbc7fWIcmkgSUdpXzNYaUHN9xWElA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204253; c=relaxed/simple;
	bh=J0wvNNsKZk/gYAmxZaddN9TFkYVvOOmWr7/PCcg+8Ac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=smzUCKV9YotcrnuPGm41bTKv0RibiHIaeK2dCWePhWcQzeWDu0pQI6SXeVjSwf1CtuVyYhwp4y/uqnTWMnxkCrOCdmvGL4heGS5ZijUWIhzDRF8owuEjMEZTXhgDNncJMk+buisgQeoVDvYPn1V8PKqqghYXerHhr9U7mdizRKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bfAInWhB; arc=none smtp.client-ip=91.218.175.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bfAInWhB"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=J0wvNNsKZk/gYAmxZaddN9TFkYVvOOmWr7/PCcg+8Ac=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788204249; v=1; x=1788809049;
 b=bfAInWhB1EW0SgL05G4MdTxdjeYpfEg94fzAEoBg1eMUHytnaK0ul8RgjOgxOeA7671CQ03N
 9gX8pcZULhpShS0Qghp9pGLw5aHGcMTgFq2uoi4uCYVay5lvsqnr78m6288NyBXcmj2IOasa28m
 hS6nfzT+5F6ysjIjgim50o1g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 25abdb32732d8663;
	Mon, 31 Aug 2026 19:24:09 +0000
X-Mizu-Trace-ID: 25abdb32732d8663
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool 4/5] arm64: Query steal-time support on the VM fd
Date: Mon, 31 Aug 2026 20:24:05 +0100
Message-Id: <20260831192406.1341841-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831192406.1341841-1-fuad.tabba@linux.dev>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_cpu__setup_pvtime() probes KVM_CAP_STEAL_TIME with
kvm__supports_extension(), which issues KVM_CHECK_EXTENSION on the
global /dev/kvm fd. That reports the host's raw capabilities, unaware of
any per-VM restrictions.

pKVM does not offer steal-time to a protected VM, and reflects that on
the VM fd alone. kvmtool goes on to KVM_HAS_DEVICE_ATTR, the kernel
refuses the PVTIME attribute with -EPERM, and kvm_cpu__arch_init() dies:

  Fatal: Unable to initialise vcpu

Query it on the VM fd via kvm__supports_vm_extension(), as
commit 84464ba0246b ("arm64: Query per-VM capabilities when selecting
vCPU features") did for the vCPU feature probes. kvmtool then takes the
no_pvtime path it already has when steal-time is unsupported.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arm64/pvtime.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm64/pvtime.c b/arm64/pvtime.c
index 2933ac7..839aa8a 100644
--- a/arm64/pvtime.c
+++ b/arm64/pvtime.c
@@ -58,8 +58,8 @@ int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
 	if (kvm_cfg->no_pvtime)
 		return 0;
 
-	has_stolen_time = kvm__supports_extension(vcpu->kvm,
-						  KVM_CAP_STEAL_TIME);
+	has_stolen_time = kvm__supports_vm_extension(vcpu->kvm,
+						     KVM_CAP_STEAL_TIME);
 	if (!has_stolen_time) {
 		kvm_cfg->no_pvtime = true;
 		return 0;
-- 
2.39.5

