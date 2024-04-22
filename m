Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867C0155A5F
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 20:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816169; cv=none; b=Foo2e/AlMLXMc/WBp/nG7EZMbUYo+XpUf3lazaEOluSmAvWpuTUba5Auym/5VAWlqf58ysho0lHSbIPosYijO2GRTeD8RAiZ6vSDTMudAJmMS59syue5QrQ1c1vmY9pt1OFHtw4v1uOOIBFyaJAZ4W7ikPuZ6QAkBdPShZGd87A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816169; c=relaxed/simple;
	bh=OqRT4vyLL9JNz4i8v7IELyOBQ8UzdiPojX7Qfa2MHjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdfS+IMc0mweXNEfXbkQftBnBcZEpOKBHyHz+ZbJA+SWZBrixXwJwr2uwlquhx777QMyZ1dRvsR2nicHCZdHQZ01Ei6ACBHQ0QjnWOk7dodUrDHaIqB0QEx2QcdlGOSaXxwEGhsqWg4hgV5XvI8FbK4/8hymsKwxafOWrF50UIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ARy4ZoIB; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ARy4ZoIB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRnbQnTSsBAmMS7Tz50SzmI/2F32L8j2hXeWgv8RvsQ=;
	b=ARy4ZoIBo6Y6351tznumkbCDtAqbW4f+IuV2gf/lnYvyRkWd+adVwRoq82TqRkyRlzQupo
	+Y9SnY9UAVWhCxPM2C8kegHLTgRbUsxOC8jLdj6QLOHzePiKLSICchMqrz4gZlA2CGzDBT
	sqdtdIzoy3esTcg4vRB0QOIZRzUgPWU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 18/19] KVM: selftests: Use MPIDR_HWID_BITMASK from cputype.h
Date: Mon, 22 Apr 2024 20:01:57 +0000
Message-ID: <20240422200158.2606761-19-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

No need for a home-rolled definition, just rely on the common header.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/aarch64/psci_test.c         | 2 ++
 tools/testing/selftests/kvm/include/aarch64/processor.h | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 9b004905d1d3..9fa3578d47d5 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -13,7 +13,9 @@
 
 #define _GNU_SOURCE
 
+#include <linux/kernel.h>
 #include <linux/psci.h>
+#include <asm/cputype.h>
 
 #include "kvm_util.h"
 #include "processor.h"
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index f129a1152985..331ff6b2dbe2 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -58,8 +58,6 @@
 	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |				\
 	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT))
 
-#define MPIDR_HWID_BITMASK (0xff00fffffful)
-
 void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init);
 struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  struct kvm_vcpu_init *init, void *guest_code);
-- 
2.44.0.769.g3c40516874-goog

