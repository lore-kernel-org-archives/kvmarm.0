Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795476412;
	b=j158NOvo0cP+rD9r6Ng/yaDBieo2/OVUCdo5pwqovS0NL4IsDbM9SnoYuPakcBDZ1bUA
	 yehASTp0TXZ434v3cgPSCDMZBT2p2qkMGbOcxlSDNj69345vFQbYvtmz7MF6cXmBxoGxj
	 mndcylEK8WZDfjSFCDECaaqIMnNZoS6LOWkIhx8VrcOie7CiAOlZw04y4DuIrozzD+G/4
	 p99PQ0VFBzibtNWzCD4Obr0t4mGNDQCwBdmTqED1sxIhSJ23TWkpYvTRW0SHzvaaeL7dq
	 Hx2uj+KRVVeuz2g3oCmORXqKFryJLXIdP34/9BQXTfCEYOPAQ0iSHN6fjlEFZd600QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795476412;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=WJVCNKr0SmGP9iVV1suMI71pk9j/vqJGLO6NxitJm1w=;
	b=4Q1QH4PP73r4E2lBduL6mJn6ciL2wDQAilc9zC/eCk7EFst0IjOSWet9MXHeoV6kEc+O
	 CPrsIitvuIc0NT9AyOYD6PI/9T9H3CxFWdap7lGm05GeD5f/QH53Zx0BWjVkeS55p2bzq
	 CuEXABOWuBoZ4ZWb5gK1+7j0wffxLJYx3f63M7iF2txFBOBj27PWMP+EyDB4ZnLhvn1SB
	 UNHcPeyC3dS936xu3SIVIIvZdQmW8tnENfLBg+ZSpCi8jbXXvZdyMB87HBImKcQ2UWJy+
	 ECMHRiqgyDEG7qNqcUSS/Oxtz8jptGP2ZRM/PvfsRA8ZtETang2ecX/2pgkQLFlxJTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=h5hjL9PR;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B93E606A680
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 23:26:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B93E606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=h5hjL9PR
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-8628955a085so4206075a34.3
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 15:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795476410; x=1796081210; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WJVCNKr0SmGP9iVV1suMI71pk9j/vqJGLO6NxitJm1w=;
        b=h5hjL9PR+dh1f24N+tinMiRDbXmLeB1XHgiqV1OHM0R/yeeEzxieWUCu3jMnfhKrjr
         il0tRB7Mx1qjzBn8DcxwDa2sOXz4IEo4ZvyEFRlwqozCaJBdHH04s4XwoPOguKxzih9a
         vxHFUgGJ+ZqCbSwSYHowKd9ZknhAt6hApmZemF1qhOlKGBXiV3yJevBuaJVbKZBeZUs5
         v7rZUVej1HGk17Xj2bJpMcOxjh7xoowqHbl/lJiH1b9vnqSEJ1F1sPvW8DSw5MecfwPK
         OaGcGvDWzlO1k3Xkoc5fg67nFEpAm1PxDsxf28YqFGaxth2iuArU50aMhbqMn7xlAD4Y
         5EBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795476410; x=1796081210;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WJVCNKr0SmGP9iVV1suMI71pk9j/vqJGLO6NxitJm1w=;
        b=1IyofePXmtqPIvBtZAYPaV/hXHrDcAvTwYjootT/BX3kc1zlB6PRuFlJrH7tF4Jkj7
         LCw1b3dlPRuyqzJlMJX5OBcBLX5m2d76gVLohzcOzLK5XQmLtodA9rKBasI8N9X+D2P1
         NIbv84hGJze29UM0TbiuY33IBKiKKn5V86JN1aXjR6b6HTjClFfu1kM4dBBPGxIqyLtt
         NucDpbQfG0VsAjBeeNg2xmb3CF3mwU0AShgxTecoh0BN1qMm8VhtytLnLDDs5N4bwj6a
         HyRfYZJmnPE4Ls6JCuARftDRcKkveIlLfO2lFOBu9hDLwELfY6Yi/IXHIuW9EB834OVm
         ojlw==
X-Forwarded-Encrypted: i=1; AL+hErHosX+mucte5p2leGTV1zQX1w3hHFSTLLf0IbiuuL7cI1qdOhPXadQioQ8AlpD1nwTlpxA9P3g=@lists.linux.dev
X-Gm-Message-State: APuU4Z9HxLMFC7zXuMQH+ggL//eWZ/lsKRAfhgsOm2pdxT/PePXaODjS
	FrVUdeD9buPfGiiIgrYLF7LL7MBFCmBLZ4PuoMDe+AF2YIwJOhg0ALKZHBa26K6zI0ANQbruASz
	BeUygdIJRs8SArXNM1+jMZdGhHA==
X-Received: from iohk21-n1.prod.google.com ([2002:a05:6602:a615:10b0:9e8:de6c:a5a3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1645:b0:567:c9d6:b2b2 with SMTP id 5614622812f47-57a0c3aa32emr13284763b6e.47.1795476409974;
 Mon, 23 Nov 2026 15:26:49 -0800 (PST)
Date: Mon, 23 Nov 2026 23:26:47 +0000
In-Reply-To: <20261123232647.3733149-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261123232647.3733149-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261123232647.3733149-3-coltonlewis@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: nv: Avoid duplicate guest stage-2 mapping entries
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Dan Carpenter <dan@pereq.eu>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_record_guest_s2_mapping() unconditionally inserts a new entry into
both guest_s2_mappings interval trees. Parallel stage-2 faults on the
same IPA or retries after -EAGAIN can therefore insert identical
entries for the same nested and canonical IPA range.

Check mmu->guest_s2_mappings under guest_s2_tracking_lock before
inserting, and free the new entry if an identical one is already
present.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/nested.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d3a19b1db2144..18868e0d701c0 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -930,6 +930,30 @@ static unsigned long s2_mapping_to_nested_start(struct kvm_guest_s2_mapping *map
 	return mapping->nested.start & ~S2_MMU_IDX_MASK;
 }
 
+static bool guest_s2_mapping_exists(struct kvm_s2_mmu *mmu,
+				    struct kvm_guest_s2_mapping *mapping)
+{
+	struct interval_tree_node *node;
+
+	for (node = interval_tree_iter_first(&mmu->guest_s2_mappings,
+					     mapping->nested.start,
+					     mapping->nested.last);
+	     node;
+	     node = interval_tree_iter_next(node, mapping->nested.start,
+					    mapping->nested.last)) {
+		struct kvm_guest_s2_mapping *curr;
+
+		curr = container_of(node, struct kvm_guest_s2_mapping, nested);
+		if (curr->nested.start == mapping->nested.start &&
+		    curr->nested.last == mapping->nested.last &&
+		    curr->canonical.start == mapping->canonical.start &&
+		    curr->canonical.last == mapping->canonical.last)
+			return true;
+	}
+
+	return false;
+}
+
 void kvm_record_guest_s2_mapping(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
 				 gpa_t nested_ipa, size_t map_size,
 				 struct kvm_guest_s2_mapping *mapping)
@@ -950,6 +974,11 @@ void kvm_record_guest_s2_mapping(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
 	tag_s2_mapping_mmu(mapping, mmu);
 
 	guard(spinlock)(&kvm->arch.guest_s2_tracking_lock);
+	if (guest_s2_mapping_exists(mmu, mapping)) {
+		kfree(mapping);
+		return;
+	}
+
 	interval_tree_insert(&mapping->nested, &mmu->guest_s2_mappings);
 	interval_tree_insert(&mapping->canonical, &kvm->arch.mmu.guest_s2_mappings);
 }
-- 
2.56.1.839.g22a8290db9-goog

