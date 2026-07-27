Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5FF379ECD
	for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169577; cv=none; b=YW4NtUyTxghSxPcq+/pI2DNhuQn+xpdgwfwZEIgqEz5+Fy+h0axXJ0IA43Vuy/v5MRpeALkgOWMERGIfNFzMSh5JKC5ysqOih5rR70o8C+d4apXlyqGVuZ7xOKsqTGY/FqV1oW6l20PYUO6sQcH5tI5wegsq0f9YuUwmszenHig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169577; c=relaxed/simple;
	bh=Z3A9rUSX1s0cyq/IHb1vYqt9l1lfzKrXOO+iVbuV+Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PJ45ISrnqsYH+rk9oRykEerPFjctaD8H2avsfcL+u/VB40QlYwVZCZqIv6xiReZbUxw6wUDyuVI+rFYhn7B5bfgsbZfZiLtRmS639tuF4ydFKR9zquR9O5BK1brtnPnk78xAaGMV0Pz8r06frfypkb6GO7U87GKiLjA/DaPOTBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pl9DLzuH; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pl9DLzuH"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso3228286a91.2
        for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 09:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785169575; x=1785774375; darn=lists.linux.dev;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DgrRLhpZSK6Izvy9wC/OSvwPYaLpWx3DeYUDgz9uc04=;
        b=pl9DLzuH/fPzJQLNSe3QBglS36MPfsJ9+AZXKKBE/vKZ5Pk6iFUKdrkMROjYnG1g8u
         WiG7DOApu5nO9oa7JBER3wsW3Ro8v7fL6kPx1H1LICJcUKTtkPhihjpDaFhtMU/3QV8Y
         tIPWeP0zzGWc42KMQoWbBt/SR6QTkBBl/+W2xIY2g6468wDpXWrLZjOZYIUac8okYty/
         26UIZ4bzPIFS6DrVUEOYtd5j6D1AC/j6BD4YqtiVpRRkUrXLaCJyn35qjMEWMhMO+kBT
         3RzFtAhyZTsLeqk/lCKmAsIEKf+mIqdDDzcSnDOCNsvouyveomFbnG24jr0PoBU+nWKK
         3PhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785169575; x=1785774375;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DgrRLhpZSK6Izvy9wC/OSvwPYaLpWx3DeYUDgz9uc04=;
        b=tOIQtDmzhMCS2oRqUJ6pO+KQzwnAfFb32ye3L9I2mH0tSpIOIjB0EfYJ2V0teDilp0
         rMTxnFy7BzsD+pC1yFzyxfHzCOhS6+gdQ/QdByFunZFD+fQuzU7z7XAbiKoxSGNrHBvq
         /8dFVJFskcq0NKiqAdHCXvzCENA2Y91QhbsQK3DLciNFNNZxBcBdYQWp/OWQpm+FQpEK
         hlD0G4Kv/dSb8JUFnrPmN8yjPRbENwiZXjsjO2r/1BFEZyGOauhO5B9kyu0dLT1UCFx1
         TDUd2hkfn9m/pw+J+gRxraA1A9T06yVwwo2/tpl34b9EAjOapBSiohDMlPBlXZF59/sn
         MCyg==
X-Forwarded-Encrypted: i=1; AHgh+RogEesn8fYaA7iucHhDO07EJbCXnnbLCKs0uXL/IZbDwMtPK4DTKIdwBA64NUoLYeJKuutF+pQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdGGdugnMKpZyCRCQvMHcdahKa2VRmlTHtU8EY1Uy+d85zKRnC
	0eew2ay13/uC7eQX88i3JzdielADgXX9aGwy79Nxq4o3iootwnq24zPf
X-Gm-Gg: AR+sD130TXOo1Vb3CtPBRHyJI2RvADDRWDlSLlH4AmC03tJ3lZrCPmwDBV3Z6Akv6da
	hDPSDWxHinD09emc5vynop4DTvY/gkDT3XYL+iU462kH0vpz4ttYVrJvZoaF0FFG0KmvCpR6x2N
	SKh2/70ACmBTY97NDQldGfbZ9I7WbEW7uRprHYTiUTHaLcLqS7AmUVZp4KsJwSnTKzXYHrYxsBF
	fRpQLWihtLrs0Mh6liROfM1zdryOJkqslfHyDDOMzC6PitUIupC+S+qi+d3c9jqNBnz4qzsEj9s
	8zX3Ao1NY8NdOCGG6In63f3bBsi0VsEagv0qKX2G4q7HR+09YZ8kgU+qR706aFMR3fqmg6PLQj8
	dCTLrRRRLr2oeh0CjmgNGha/2p1bdQyC7j6/6TNVfLk1OIWiVveruZGAtaZ8XC+E7C7jG73UfNN
	LCpIVfLIm14gjRTNmxXZqt6w==
X-Received: by 2002:a17:90b:390c:b0:37f:eafd:3505 with SMTP id 98e67ed59e1d1-38f293cf360mr8125929a91.6.1785169575425;
        Mon, 27 Jul 2026 09:26:15 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f64117003sm81826a91.6.2026.07.27.09.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 09:26:14 -0700 (PDT)
Date: Tue, 28 Jul 2026 01:26:11 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, tabba@google.com, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: [PATCH] KVM: arm64: nv: Don't skip VNCR invalidation when the TLB
 size is unknown
Message-ID: <ameGoxbn2wzBq2kL@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

ttl_to_size() returns 0 when no size is defined for the (granule, level)
pair. That is the case for level 0 with 4kB pages, and for levels 0 and 1
with 16kB and 64kB pages. For a VNCR pseudo-TLB this happens when the
guest runs with SCTLR_EL2.M cleared, because __kvm_translate_va() returns
success with wr->level left at S1_MMU_DISABLED, and that s8 value becomes
level 1 as it goes through the u8 parameter of pgshift_level_to_ttl(). The
size is then 0 if the guest has TCR_EL2.TG0 set to 16kB or 64kB.

kvm_invalidate_vncr_ipa() and invalidate_vncr_va() feed that 0 straight
into the range computation. When the size is 0 the alignment mask is 0 as
well, both ends of the range collapse to 0, and the first comparison, the
one that decides there is no overlap, is always true. As a result the
pseudo-TLB is skipped whatever range the caller asks for, including the
full IPA range passed by kvm_nested_s2_wp() and kvm_nested_s2_unmap().

kvm_nested_s2_unmap() is called from kvm_unmap_gfn_range(). A guest that
meets the above conditions therefore keeps its VNCR fixmap mapping across
an MMU notifier that reclaims the page, and still holds a writable EL2
alias of that page once it has been freed and reallocated for something
else.

compute_tlb_inval_range() and compute_s1_tlbi_range() already treat a size
of 0 as "no size information" and fall back to a conservative value. Apply
the same principle here, folding the range computation into a helper that
reports an overlap when the size is unknown. This also removes the
computation that was duplicated between the two functions. The result of
the test is unchanged for a non-zero size.

Fixes: ebb2d8fd81b8 ("KVM: arm64: nv: Fix incorrect VNCR invalidation range calculation")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/nested.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dfb96edbdc43c6..3ac8789b458f39 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -985,6 +985,21 @@ static void invalidate_vncr(struct vncr_tlb *vt)
 		clear_fixmap(vncr_fixmap(vt->cpu));
 }
 
+static bool vncr_tlb_intersects(struct vncr_tlb *vt, u64 addr,
+				u64 start, u64 end)
+{
+	u64 size, tlb_start, tlb_end;
+
+	size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift, vt->wr.level));
+	if (!size)
+		return true;
+
+	tlb_start = addr & ~(size - 1);
+	tlb_end = tlb_start + size;
+
+	return !(tlb_end <= start || tlb_start >= end);
+}
+
 /*
  * VNCR TLB invalidation occurs from MMU notifiers or TLBI instructions, and
  * either can race against a vcpu not being onlined yet (no pseudo-TLB
@@ -1008,14 +1023,7 @@ static void kvm_invalidate_vncr_ipa(struct kvm *kvm, u64 start, u64 end)
 		return;
 
 	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
-		u64 ipa_start, ipa_end, ipa_size;
-
-		ipa_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
-							    vt->wr.level));
-		ipa_start = vt->wr.pa & ~(ipa_size - 1);
-		ipa_end = ipa_start + ipa_size;
-
-		if (ipa_end <= start || ipa_start >= end)
+		if (!vncr_tlb_intersects(vt, vt->wr.pa, start, end))
 			continue;
 
 		invalidate_vncr(vt);
@@ -1045,28 +1053,21 @@ static void invalidate_vncr_va(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
-		u64 va_start, va_end, va_size;
-
-		va_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
-							   vt->wr.level));
-		va_start = vt->gva & ~(va_size - 1);
-		va_end = va_start + va_size;
-
 		switch (scope->type) {
 		case TLBI_ALL:
 			break;
 
 		case TLBI_VA:
-			if (va_end <= scope->va ||
-			    va_start >= (scope->va + scope->size))
+			if (!vncr_tlb_intersects(vt, vt->gva, scope->va,
+						 scope->va + scope->size))
 				continue;
 			if (vt->wr.nG && vt->wr.asid != scope->asid)
 				continue;
 			break;
 
 		case TLBI_VAA:
-			if (va_end <= scope->va ||
-			    va_start >= (scope->va + scope->size))
+			if (!vncr_tlb_intersects(vt, vt->gva, scope->va,
+						 scope->va + scope->size))
 				continue;
 			break;
 
-- 
2.43.0

