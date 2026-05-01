Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F693A3E7F
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634520; cv=none; b=t0PgXrydCfzoz0OfmwUqqI/tIkHsA031XTHRcFNN7MygIaohJivSoDBvcFZnPsi5DZbR79JVAFXxy2ejPrxDX3dJBo1DScGWl5MPNjXneTqkrE9LrbjszlKf9MFGWB52Uk/hy1LzU6PCRpiQKWsNCitWyHFTSXLwDJUdIeoMcKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634520; c=relaxed/simple;
	bh=S7p3SvZAGgFaCzOgURZOrBYd5goc2tc8o7A1j2alrrE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aZSBHZI3e2PVe7Csp0/PgJmh0ff9kpn0uvLrSSZh1xLRWA9YCWTzSC3K9F0djWe3oJ1p9KzT1S0J8GONLwH3Ud1sb1n97AZCf0MCZfDrB0JQYsYgX7Rj5Nzm/fcBLAXIYgHZ4wGdb47hmGeI53nqrQakIFXMkVlPvfR+H0bAD1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d5y/QbqT; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d5y/QbqT"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-ba78dfab8aaso169713866b.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634517; x=1778239317; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hX/U36pu+btUiKMTGpxWXuvgYMFqfHpYvSZt+8MNmUg=;
        b=d5y/QbqT8GoYYg/472CTRk11mwoNO+GfIGKv/e/d0oWaO0v7dp3lBAy8TTGX+sE9ct
         aAcckS5LY2/Cw+YSbowc26wr/gfq742i//42aHv8oPkiDptKb58BhLmvnjJpjNm9q85k
         Y9hZKlhiVcXdqp8vjP+8aihs3yxvIogOgh69/IuzHAZbb4zr/wSGQA99GEY4deJhp1oC
         T7YViYYwJ7qmDhqwpKZYwJX0j2jlm2AxCs1ZyDV+4vMg+YFWUPMMlURtTjh69IpCaVIw
         eH0UAgiui+ksTryc4OL3Kn1bhcFebyOR74rlWpKQ0tfm6ICMd7r3XWT3hyCVcPaqm9OC
         B7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634517; x=1778239317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hX/U36pu+btUiKMTGpxWXuvgYMFqfHpYvSZt+8MNmUg=;
        b=BwxpsGu/F7ky06g0FIFm5nGNnjo0cbwAFxpACx+bXCJu7gNxblDpIToeDyUfbTVbDE
         PxsUf0mMijYC7ncyyKIkgOTx5gWacTvQ9HQ4erJBdrPJK9JYy16RcoFgRSrTAUKE19eS
         slI7o3jkfEpiDcipKPxarVkuZ7mxLlTcZBnKAFBu7MVpInxnkUbWTjV01UEviDozBQkd
         GCpV6R3KsanlWUx6wTkmXVbkrp99mdWLQ7lhTbRqPils9RlnN2DEkCtrt+D0Kcpc6aSW
         GWx/2UeEosZsnGVwgg/1TW98Ro7ndJL51QUw4eQW4DBHN5EkmEfjZyDJ4dVHhuC9l+yd
         zENg==
X-Forwarded-Encrypted: i=1; AFNElJ9B50FMY40UqymU+4QgMPACI/bWuhlFyIb5pnmaFiH8jqu6THTl+yZh6gKtQWwNhhdg7cEN2wk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywxj9QPNB+lu/X5xPH1sDbkF2BuThTp45ImRcRuDkagnGnSCdyM
	OOiOkDxyymSuh2/reDAUhwGlsQaYRn8ls8Zb8RrFhm4nG364q2RQUSPPauLsB0Dux0rx5NLtC25
	7vg==
X-Received: from ejbwt14.prod.google.com ([2002:a17:906:ee8e:b0:b98:23e7:c41])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:f58e:b0:bb7:be6a:7671
 with SMTP id a640c23a62f3a-bbac5ac10c5mr381051166b.6.1777634516878; Fri, 01
 May 2026 04:21:56 -0700 (PDT)
Date: Fri,  1 May 2026 12:21:48 +0100
In-Reply-To: <20260501112149.2824881-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501112149.2824881-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501112149.2824881-6-tabba@google.com>
Subject: [PATCH v2 5/6] KVM: arm64: Pre-check vcpu memcache for host->guest share
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, yaoyuan@linux.alibaba.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

__pkvm_host_share_guest() ends with kvm_pgtable_stage2_map() to
install the guest stage-2 mapping, after a forward pass that mutates
the host vmemmap (sets PKVM_PAGE_SHARED_OWNED and increments
host_share_guest_count) for every page in the range. The map's
return value is wrapped in WARN_ON() and otherwise discarded,
asserting that the call cannot fail.

WARN_ON() at nVHE EL2 panics, so this assertion is only correct if
the call genuinely cannot fail. kvm_pgtable_stage2_map() can fail
with -ENOMEM when the stage-2 walker exhausts the caller's
memcache, and the host controls the vcpu memcache via the topup
interface, so an under-provisioned share request would otherwise
turn a recoverable -ENOMEM into a fatal hyp panic.

Bound the worst-case walker allocation in the existing pre-check
pass so that kvm_pgtable_stage2_map() cannot fail at the call
site, using kvm_mmu_cache_min_pages() -- the same bound host EL1
uses for its own stage-2 maps. If the vcpu memcache holds fewer
pages, return -ENOMEM before any state mutation.

Fixes: d0bd3e6570ae ("KVM: arm64: Introduce __pkvm_host_share_guest()")
Assisted-by: Gemini:gemini-3.1-pro review-prompts
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 28a471d1927c..e428304f94f2 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1369,6 +1369,22 @@ int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 	return ret && ret != -EHWPOISON ? ret : 0;
 }
 
+/*
+ * share/donate install at most one stage-2 leaf (PAGE_SIZE, or one
+ * KVM_PGTABLE_LAST_LEVEL - 1 block for share). kvm_mmu_cache_min_pages()
+ * bounds the worst-case allocation: exact for the PAGE_SIZE leaf,
+ * conservative by one for the block.
+ */
+static int __guest_check_pgtable_memcache(struct pkvm_hyp_vcpu *vcpu)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+
+	if (vcpu->vcpu.arch.pkvm_memcache.nr_pages < kvm_mmu_cache_min_pages(vm->pgt.mmu))
+		return -ENOMEM;
+
+	return 0;
+}
+
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 {
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
@@ -1453,6 +1469,10 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 		}
 	}
 
+	ret = __guest_check_pgtable_memcache(vcpu);
+	if (ret)
+		goto unlock;
+
 	for_each_hyp_page(page, phys, size) {
 		set_host_state(page, PKVM_PAGE_SHARED_OWNED);
 		page->host_share_guest_count++;
-- 
2.54.0.545.g6539524ca2-goog

