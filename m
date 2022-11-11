Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CB71B54F
	for <kvmarm@lists.linux.dev>; Fri, 11 Nov 2022 23:20:02 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668208800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FmNsJgQsGNOtJgVX1p1TSDR/6XSvxYRuK6DmS7w9sD4=;
	b=LuT2xS0xvyBb4BuQlbPGxoHJsIzKUW15/41hKrCQAKUp+srlIVOqkf/LIWx5jdkSzgxKui
	YYbIXxGP7YF8SRl/vTQxq/WZWk7OXe7uYnMCYZ4krwEJH4PpfAfpKtTGmlINsyynuXA14r
	lMV4KJO7dgSyAJXuA2lMl/d9ZDI4FGM=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: selftests: Build access_tracking_perf_test for arm64
Date: Fri, 11 Nov 2022 23:19:46 +0000
Message-ID: <20221111231946.944807-3-oliver.upton@linux.dev>
In-Reply-To: <20221111231946.944807-1-oliver.upton@linux.dev>
References: <20221111231946.944807-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221111231946.q3ccoIhw1N0FTc25ZkyWZOZdNos13VWNOwc0w3fdVSs@z>

Does exactly what it says on the tin.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0172eb6cb6ee..4c0ff91a8964 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -156,6 +156,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
+TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
-- 
2.38.1.431.g37b22c650d-goog

