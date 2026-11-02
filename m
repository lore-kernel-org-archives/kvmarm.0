Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793608177;
	b=3NOQAt1kBAUXoolLpVrU/fWrjjrT/HDIl0M2bJr8I8Q0KGqig/jwCz3gtppbKrCNndtI
	 63aQJRS66TRoS7LjwWVveFNkT9eNw9z+mAhC3eT4nA/r4TRIqD4Fe0uPlniwzkZfDzpJI
	 goyNj/59yZ8smQR2dwrAsoutyJXzzPaO1TDHLMvOi+7vc8AAa1LWKbhouon+TqHhLWhj+
	 wtOBAzQCAhG+x4bjOb4jj1xTWrNQtdoUOl+WVoQJHhm9IcKC9XRHdkXQ36Dv5SMLyA3ZI
	 Fi9byDmz+0+oFpySSpKN2ek8cDFsRW/L7BHq5aMEbvZq308uZ9l2HxLqfW053tIQThA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793608177;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=euznYBocIb8kfNgcKlt2GHcUVDSBs2gzY/11E05nVeE=;
	b=wql4P9jBBtH2fWQT20XnCgqn81Sk8UU27eLTMAgTVMvM160TiPtIcfuF9Y287l+CxAn2
	 WiQ1ljL6gDpInQPWqNaNyr2iR7Fat1kr6wC/o0y93rOPQDmeF55GK7hchVSuYvT3Opx+M
	 /Bf/1lZkDbtzj8URJuZRn0Br0VYXrf6E5LJo8NjbB4h8pjg8JfoWlbQ6WxYT1HndHCxBn
	 BkpucYf3TyQTBz8UzXC2+QIozMHYCiu6jiArwwuQgvbBp0bYc1nhU1B3+Zd8o7E6Jlqgb
	 jQbGh8PwypIU91CGn8XrBtMzNcKEdbtMyCIdkgz1CTzC2qhp4jm45iAvPYjfBZj+Xhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F+5WWgPW;
	arc=none smtp.remote-ip=91.218.175.150
Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B4606A329
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 08:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD5B4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F+5WWgPW
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=y8BgwjagvHGf78IlM6ng3nm9vDTk3b3hu1EyL1SF7ec=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793608174; v=1; x=1794212974;
 b=F+5WWgPWHTgZkLOdWp34fjp8vKNTzLwWGqZ/4900AI/b1FTmGpR1sFpQt8SzIiPVy20OvRLv
 h7fwwNHkpAZeLqoAxkwBPghJibjqFi5yr5vvVF8G2NWNsTRh8Fx/D44CNgsqKctPTHRQgrIphKQ
 IaHcegGiTwV+63OFDSO3Vjy0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id eddade33f188acbf;
	Mon, 02 Nov 2026 08:29:34 +0000
X-Mizu-Trace-ID: eddade33f188acbf
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>,
	Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: vgic-its: Update GITS_CTLR.Enabled under its_lock
Date: Mon,  2 Nov 2026 08:29:33 +0000
Message-ID: <20261102082933.2673799-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
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

A GITS_CTLR write that disables the ITS clears its->enabled and
invalidates the translation cache under cmd_lock, while an MSI
injection tests the enable bit and populates the cache under its_lock.
An injection that passed the test before the disable can cache its
translation after the invalidation, and the cached path then injects
the LPI from the disabled ITS on every later MSI for that event.

Take its_lock around the store and the invalidation, so that it
serializes the store against the test. Nest it under cmd_lock, as the
command handlers do.

Fixes: 86a7dae884f38 ("KVM: arm/arm64: vgic-its: Check the LPI translation cache on MSI injection")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/ah6Lsi4MfKUU6wBR@v4bel/
Suggested-by: Oliver Upton <oupton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes since v1 [1]:
      - Reworded the commit message.
      - Rebased on 7.4-rc1.
    
    Picking up the fix Marc was worried had stalled [2].
    
    The GICR_CTLR.EnableLPIs path has the same window and is left as
    is. vgic_its_invalidate_all_caches() can't take kvm->lock there (it
    runs with vcpu->mutex held) or config_lock (the userspace GICR_CTLR
    route already holds it). Instead, the vgic_target_oracle() check in
    my LPIs-disabled series [3] keeps an LPI off a redistributor with
    EnableLPIs clear. The two don't depend on each other.
    
    vgic_its_free_collection_list() still leaves the cache alone. A
    guest reaches it only through a GITS_BASER write, which already
    drops the cache (8cd92f77ae4f). An ITS reset frees the devices
    first, which drops it too. That leaves a failed collection-table
    restore. A VMM gets there with translations cached only by enabling
    the ITS before the restore, against the documented order. Those
    translations then keep injecting their LPIs into the old target
    vCPUs.
    
    Based on Linux 7.4-rc1 (6628e7d4c6b25; also applies to kvmarm/fixes
    79f3724ca8913).
    
    [1] https://lore.kernel.org/all/20260917162020.1612577-1-fuad.tabba@linux.dev/
    [2] https://lore.kernel.org/861pbr6emw.wl-maz@kernel.org/
    [3] https://lore.kernel.org/all/20261026092802.2636798-1-fuad.tabba@linux.dev/

 arch/arm64/kvm/vgic/vgic-its.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7e9b265b1f521..68e3034e52236 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1800,9 +1800,12 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 		 !(its->cbaser & GITS_CBASER_VALID)))
 		goto out;
 
+	/* vgic_its_resolve_lpi() tests the enable bit and caches under its_lock. */
+	mutex_lock(&its->its_lock);
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
 	if (!its->enabled)
 		vgic_its_invalidate_cache(its);
+	mutex_unlock(&its->its_lock);
 
 	/*
 	 * Try to process any pending commands. This function bails out early

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.3

