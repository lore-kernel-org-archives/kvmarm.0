Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B611A320F
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 00:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729124403; cv=none; b=ru6bKbRrGnImpt/31m1uTxlAbieJPBcCbFZGTOktgCjpJkK3f+ElYd2SaOT9RKhxkDBt5IwehMj7gUywiURdkfQ8o3dVHB1laL5NBOVBN2k+sk2EUlrQtl0CQdYqfqi0YKwupwofsJ6911kzGA1jMCdpVGKFwT803jNxtSx5dS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729124403; c=relaxed/simple;
	bh=Z86pjIxTmSwo5JWN8TufTE6rXOA9sDnKwTlpJaCfr1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyzVTwffkEiYoqeXzdJAymbIQqe2zEfl1j27Ug2OlaNra6giKIqjPdk2Bzo9KNqcxBPKQBQ9GKDNnRFrsX5ynFQrEsFGCbmUQhBQ496LVTTK4FY7eLHJpqvwFqpzd4mjQ5y2lcP3iAMfGB+qAIMkE1vMgD8SU004+svI3nGi9io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FT3wnwxn; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FT3wnwxn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729124400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5a4rdq/dZFJET2R2UN6TqBgnWlSQknpJ3lC0WwLbtE=;
	b=FT3wnwxnDBT+6f+kwHIGKwdhfILYIcR834NRJWOjLw1ou9yqPHpsLzfdSXs47eSWMYe4EP
	hgiXQdXsiSdFSdsn5IMrKe3INpvXuzYVhMzC6lY/k+CfvzGvG1Suf5emu7CW4prkc6+6cq
	jLDS6TsI8s2b1BhxRTSdcURLgLfHlak=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: Ensure vgic_ready() is ordered against MMIO registration
Date: Thu, 17 Oct 2024 00:19:47 +0000
Message-ID: <20241017001947.2707312-3-oliver.upton@linux.dev>
In-Reply-To: <20241017001947.2707312-1-oliver.upton@linux.dev>
References: <20241017001947.2707312-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

kvm_vgic_map_resources() prematurely marks the distributor as 'ready',
potentially allowing vCPUs to enter the guest before the distributor's
MMIO registration has been made visible.

Plug the race by marking the distributor as ready only after MMIO
registration is completed. Rely on the implied ordering of
synchronize_srcu() to ensure the MMIO registration is visible before
vgic_dist::ready. This also means that writers to vgic_dist::ready are
now serialized by the slots_lock, which was effectively the case already
as all writers held the slots_lock in addition to the config_lock.

Fixes: 59112e9c390b ("KVM: arm64: vgic: Fix a circular locking issue")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index d88fdeaf6144..48c952563e85 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -544,14 +544,23 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	if (ret)
 		goto out;
 
-	dist->ready = true;
 	dist_base = dist->vgic_dist_base;
 	mutex_unlock(&kvm->arch.config_lock);
 
 	ret = vgic_register_dist_iodev(kvm, dist_base, type);
-	if (ret)
+	if (ret) {
 		kvm_err("Unable to register VGIC dist MMIO regions\n");
+		goto out_slots;
+	}
 
+	/*
+	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
+	 * registration before returning through synchronize_srcu(), which also
+	 * implies a full memory barrier. As such, marking the distributor as
+	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
+	 * a completely configured distributor.
+	 */
+	dist->ready = true;
 	goto out_slots;
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.47.0.rc1.288.g06298d1525-goog

