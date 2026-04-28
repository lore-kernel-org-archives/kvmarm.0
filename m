Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CFD3F0752
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 10:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372222; cv=none; b=IGuT8JPaKj0EmrAwI2SAnFeXuBKKTzAjAkL2ikyMhCU09l9cntnxNe1dZhvxO5FweCADunp9pSmQMhOlbvkD9Ak0+PmJgOPpyQX0H39e+iqrxMEYC5UMjBUi37uN4HDR5oj6XXqVIYDmaCvcKNWLvGeqeqlgBSk54fyY0DXmpyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372222; c=relaxed/simple;
	bh=maNkTII608MzcF1ju87MQQ+KK6PcKFHw8+zyZf9QEJg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JHSrnVBWzms8fsPiSJO0Oe0Bopx9RfHcMkZ6klOnIAbk69alLI78LGR9OdQcz4KPV6c7wvO4JQarBOgQYzadEVvidFS+mZScdseIAqQ7KIkwUw0YcVH5IwHGjXiwcWBXw+M4za6mSbVOkpyDZ9hz3TYPT8/H+BzC6A/E18tlaO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SrTmPXnz; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SrTmPXnz"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43fe791a398so8700777f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 03:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777372218; x=1777977018; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZBFwe+kQ1OqLHi9s19ESuOVx/rJg9xLwA9cXX3TmEmg=;
        b=SrTmPXnzXm9BA1Xo+gVDjCoTakHENkke1U89ejGDTwWkepdb6DSgxAx2sApGQUv4vQ
         aG3r7wg7Mabbztzqy5TvNt/EuTVkRht9Gfp2ZXmWap/x5YfjLaLk/vdzFy1gKGyT7QQW
         5W5XcwmNUh/9jfpiasbhP/09Elx4RbdbQB+cCv0ryirjA0fmR53sT4fIW+58WtvU60oN
         xZxmC9JyQKyNgH0RRpxrvGTR1zF0yUZdrEhw2KrgurlK1VXZGT2Ts7YMKevFdMXp5evs
         Jm2Aw8sRCPcLfY8QfvFKlVHKjuL+ttK+Ho+k0+X5dCWRumvq8PShVEKLVYdlwClKS16i
         jzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372218; x=1777977018;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZBFwe+kQ1OqLHi9s19ESuOVx/rJg9xLwA9cXX3TmEmg=;
        b=l09aXO5FY9qRCZIuP48WZCR2YmeJrrdAgdeTXDonj/hg1SA0c965v86oRnZdS2tQ3R
         nKRHfRH6k8TUamw0G7Gg2+nbxWKtO2FwnfmQ//RwPyKri0N0DZj6f57TEzNIPownr7It
         Ft02MA1/w+HPE0e2BLzsw2RGMu0/8wtB0UOZv8LAEnmLMl7XaYPmd2gSI83o663HrpuI
         YosWDn2IWA9s8/HIpIjm+7h5IOXmOXUqZNUT3n7N9JWK5QF5qWyWoGnqmQrxi/DQpAa8
         1HYZiiPupd+U38I+dvFPwmJBOB7PBUPd+6wUih9oRql2d/VSxpLCSA9ezqqw0sI9VoOF
         C8Vw==
X-Forwarded-Encrypted: i=1; AFNElJ+/U0Dh917+04WbC/ztq4OWeOIuYyJ0Ltd9vY9Spq30/5fI9Ojm37CXdCZje97AluHsDLqlTUk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvOf261QUPaAiIjg+jXQmSgbSbR39ROb7/NwCG5HQpAa+86Hek
	JKRaZj6T050GAKrDpBBUTzxZp7iDlB1vHMGqVEJHzl3Ww4mFgK6RV3EgB3G7txs6/21kdbA9W+5
	/3A==
X-Received: from wmbjp7.prod.google.com ([2002:a05:600c:5587:b0:488:a71c:cf48])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b90:b0:488:a639:b772
 with SMTP id 5b1f17b1804b1-48a77af5f04mr37827885e9.7.1777372218008; Tue, 28
 Apr 2026 03:30:18 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:30:08 +0100
In-Reply-To: <20260428103008.696141-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428103008.696141-9-tabba@google.com>
Subject: [PATCH 8/8] KVM: arm64: Propagate stage-2 map failure on guest->host unshare
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

__pkvm_guest_unshare_host() re-acquires exclusive guest ownership of
a page by (i) annotating the host stage-2 PTE via
host_stage2_set_owner_metadata_locked(), (ii) mapping the page in
the guest stage-2 as PKVM_PAGE_OWNED via kvm_pgtable_stage2_map(),
and (iii) restoring host ownership via
host_stage2_set_owner_locked(). The map's return value was wrapped
in WARN_ON() and otherwise discarded.

At EL2 in nVHE/pKVM, WARN_ON() is not warn-and-continue: it expands
to a BRK that enters the invalid-host-el2 vector and branches to
hyp_panic(), declared __noreturn.

__pkvm_guest_unshare_host() calls get_valid_guest_pte() before the
map, which verifies that a valid last-level (PAGE_SIZE) leaf PTE
already exists for the IPA. Because the leaf and all intermediate
tables are in place, the subsequent kvm_pgtable_stage2_map()
replacing it cannot fail via -ENOMEM: no block to split, no new
tables to install. The failure path is not currently reachable.

Nevertheless, WARN_ON() on any fallible call is the wrong pattern at
EL2. Capture the return value and propagate it. The unmap() and
host-side rollback are kept as defensive guards for the currently
unreachable failure path. The rollback's
WARN_ON(__host_set_page_state_range()) asserts an impossible state:
the host leaf PTE was just written by
host_stage2_set_owner_metadata_locked(), so the reverse idmap
rewrite cannot require new page-table allocation from host_s2_pool.
This is the correct use of WARN_ON at EL2 =E2=80=94 an impossible-state
assertion, not a reachable error being ignored.

Fixes: 246c976c370d ("KVM: arm64: Implement the MEM_UNSHARE hypercall for p=
rotected VMs")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 37 ++++++++++++++++++---------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvh=
e/mem_protect.c
index 6fb546af699f..12f3ea7a2d75 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -984,14 +984,10 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcp=
u, u64 gfn)
 				     &vcpu->vcpu.arch.pkvm_memcache, 0);
 	if (ret) {
 		/*
-		 * Stage-2 map can fail mid-walk (e.g. -ENOMEM from the
-		 * memcache), leaving partial leaf entries in the guest
-		 * stage-2 transitioned to PKVM_PAGE_SHARED_OWNED. Tear
-		 * them down so the host does not see a partially-shared
-		 * mapping it has not yet acknowledged via the host
-		 * stage-2 update below. No host bookkeeping needs
-		 * unwinding here: the only mutation prior to the failed
-		 * map is the (now-discarded) guest stage-2 update itself.
+		 * Defensive: get_valid_guest_pte() guarantees a last-level
+		 * leaf PTE already exists, so stage-2 map() cannot currently
+		 * fail here. The unmap() restores the IPA to a clean state as
+		 * a guard should the precondition ever change.
 		 */
 		kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);
 		goto unlock;
@@ -1024,13 +1020,30 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu =
*vcpu, u64 gfn)
 	if (__host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORRO=
WED))
 		goto unlock;
=20
-	ret =3D 0;
 	meta =3D host_stage2_encode_gfn_meta(vm, gfn);
 	WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
 						      PKVM_ID_GUEST, meta));
-	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
-				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
-				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+	ret =3D kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+				     pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
+				     &vcpu->vcpu.arch.pkvm_memcache, 0);
+	if (ret) {
+		/*
+		 * Defensive: get_valid_guest_pte() guarantees a last-level
+		 * leaf PTE already exists, so stage-2 map() cannot currently
+		 * fail here. The unmap() and host-side rollback below are
+		 * kept as guards should the precondition ever change.
+		 */
+		kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);
+
+		/*
+		 * Roll back the host stage-2 mutation above: the host leaf
+		 * PTE was just written by host_stage2_set_owner_metadata_locked(),
+		 * so __host_set_page_state_range() rewrites it in-place
+		 * without needing fresh page-table pages from host_s2_pool.
+		 */
+		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE,
+						    PKVM_PAGE_SHARED_BORROWED));
+	}
 unlock:
 	guest_unlock_component(vm);
 	host_unlock_component();
--=20
2.54.0.545.g6539524ca2-goog

