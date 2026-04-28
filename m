Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31BD3ED12A
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 10:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372220; cv=none; b=EBZlEOz2HWpWqrUzjszroWzT7TKDEu2vAWsrVXio3XEoGv9TMmP90ptMz1mZJTb+p+6k5VzszrH916SGozuYliSdlW/uZniah2PJmRxJVozrzR+zVRraJcxS2aacVaXD/vf5tixzb9az0shEG/zsLg11auT+J1B2ANao7Fr1QKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372220; c=relaxed/simple;
	bh=Kn1z2vYj7fovu9i0b/eXjuXPOoyK7xrPU6Ci1PU8424=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VQ14Ak7jXnlqSxwWpse9a+nmhqhc96FzCkg6bD4AFhnhaXekAdosfk/xpnklJr/x45iOiF2TeKjSZ2ix+swEDxsJ6Y09JebGuMvjq4jS0Y28KK4evzFDmC2DplE09j6PIiIJXJms6B7Jthhqua12cCrMJtkmHPzaWBtumc71ag8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sIkZvwgu; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sIkZvwgu"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43cfedb10a8so7317170f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 03:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777372216; x=1777977016; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YBzgBVDAjOycqgcIzeu+4bme8jBbglGvTuoHc/CuC0c=;
        b=sIkZvwguSUcfhVH4wdYcMa2jQeq3GfcR8CHJGayJbB6zp6/JthbNbCgouuJfBtESvQ
         cW+HxAoNOd8nceFYhlSyW4Rbef9c0sa54TDLlpFy6nqCviNM0Va4//DLekYc4bfYsaUL
         0MnpXsz0XTB2xHAtO8nAJmjAkVzdM7m9W7Ffh9QbSyzqhnoKwfr+pmjx+JhLwK31W7iU
         bk2MP57Rhm0aRzWX3JQHNgG6fqlF0f+470RalDhnYDQgxAWy3o5y7qpSYvu2hxdl/dlp
         LT7rRzBNUL7yGWXZVdCiOG5w1bK6H8PMW9d8C/rejPb1gaI4JWtFzn1V6LLQ2XTuAu0/
         DdEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372216; x=1777977016;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YBzgBVDAjOycqgcIzeu+4bme8jBbglGvTuoHc/CuC0c=;
        b=IV/1M8I/ISwdR48ykTGMYusSfLc1U/oe/jbbDsoaMtFZ0ZsK4DFvQhJ2V9fWbhDItD
         nPI3Iz1H3RDKCSCWRC3chKo/pao4pGmz5+ZZM2C8eZBmayfQge5CXMr/MK+Oo0R0l0J0
         BPJAFuUNxUhzNeZZKWBjmZTc9/iJTRhVy0lR86BM5hWiTgRAFuqurf8Q7oip6YaLkqYn
         oTaB2IoIc9sLTJfTl9zSOq7bBk1gXZmKAGRo/D7pj5QvKMCRCNSxISqXbt8s4c/Z6xZS
         wqdbFoheY8T3Y72tO42HayyBCJvI5a+USd0l6N1f+1fut3ei7QIweqeur6CTr747Stk4
         7RNQ==
X-Forwarded-Encrypted: i=1; AFNElJ8DftO5xNJd5GeS+i+TMXrIe3sibT/gRMYDsjtBlW1ilUN5BPb3vhsDsDZeuOcDiYfbq87lHHk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywfcr99aj06R+Wsma/Ht8fbuPsm3zM6KLt9CmC+fEZmAssRyYAG
	7A8XrVkA9nJKBNz0SljJG9e35yYo/s88NWcB+ZDFZS2n8P434Vv9zxjSxmrsflVR4mkRM4Q4Ags
	8Mg==
X-Received: from wrvw10.prod.google.com ([2002:a5d:544a:0:b0:43e:a8da:c95a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:3109:b0:43d:7aa8:f64e
 with SMTP id ffacd0b85a97d-44649c995b6mr4775338f8f.32.1777372216035; Tue, 28
 Apr 2026 03:30:16 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:30:06 +0100
In-Reply-To: <20260428103008.696141-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428103008.696141-7-tabba@google.com>
Subject: [PATCH 6/8] KVM: arm64: Propagate stage-2 map failure on host->guest donation
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

__pkvm_host_donate_guest() flips the host stage-2 PTE for the donated
page to a non-valid annotation (KVM_HOST_INVALID_PTE_TYPE_DONATION,
owner =3D PKVM_ID_GUEST) via host_stage2_set_owner_metadata_locked()
and then calls kvm_pgtable_stage2_map() to install the matching guest
stage-2 mapping. The map's return value was wrapped in WARN_ON() and
otherwise discarded.

At EL2 in nVHE/pKVM, WARN_ON() is not warn-and-continue: it expands
to a BRK that enters the invalid-host-el2 vector and branches to
hyp_panic(), declared __noreturn. WARN_ON of a reachable failure at
EL2 is a panic primitive, not a debug aid.

kvm_pgtable_stage2_map() can fail in reachable ways even at PAGE_SIZE
granularity: __pkvm_host_donate_guest() verifies PKVM_NOPAGE for the
guest IPA before the map, meaning no valid stage-2 entry exists. The
walker must allocate new page-table pages from the vcpu memcache to
install the mapping, returning -ENOMEM if exhausted. The host
controls the vcpu memcache via the topup interface, so an
under-provisioned donation request converts a recoverable error into
a fatal hyp panic.

Capture the stage-2 map return value and propagate it. The walker
may have installed partial leaf entries for the IPA before failing,
so unmap the range to clear them; otherwise the guest would retain
stage-2 access to a page the host is about to reclaim as
PKVM_PAGE_OWNED. Then roll back the host stage-2 mutation: the only
forward mutation is host_stage2_set_owner_metadata_locked() flipping
the host vmemmap from PKVM_PAGE_OWNED to PKVM_NOPAGE and the host
stage-2 PTE from idmap to invalid+annotation.
host_stage2_set_owner_locked(_, _, PKVM_ID_HOST) restores both.

The rollback calls host_stage2_set_owner_locked() under WARN_ON.
This is the correct use: host_stage2_set_owner_metadata_locked()
just wrote the host leaf PTE as an invalid+annotation entry, so the
reverse idmap rewrite cannot require new page-table allocation =E2=80=94 it
rewrites the leaf in-place. The WARN_ON asserts an impossible state
under correct EL2 execution, semantically distinct from the misuse
being fixed.

Fixes: 1e579adca177 ("KVM: arm64: Introduce __pkvm_host_donate_guest()")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvh=
e/mem_protect.c
index 7044913a0758..b8c57a95e9bf 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1391,9 +1391,30 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struc=
t pkvm_hyp_vcpu *vcpu)
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
+		 * Stage-2 map can fail mid-walk (e.g. -ENOMEM from the
+		 * memcache), leaving partial leaf entries installed in the
+		 * guest stage-2. Tear them down before rolling back the host
+		 * stage-2; otherwise the guest would retain access to a page
+		 * the host is about to reclaim as PKVM_PAGE_OWNED.
+		 */
+		kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);
+
+		/*
+		 * Roll back the donation annotation applied above by
+		 * host_stage2_set_owner_metadata_locked() (host vmemmap
+		 * PKVM_NOPAGE -> PKVM_PAGE_OWNED, host stage-2 PTE
+		 * invalid+annotation -> idmap). The leaf PTE was just
+		 * installed by the forward call, so reinstating the idmap
+		 * rewrites it without needing fresh page-table pages from
+		 * host_s2_pool.
+		 */
+		WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
+	}
=20
 unlock:
 	guest_unlock_component(vm);
--=20
2.54.0.545.g6539524ca2-goog

