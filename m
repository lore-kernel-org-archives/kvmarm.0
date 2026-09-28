Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB564E8E0B
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609184; cv=none; b=NA2Qu0OjUJ1e0efew2bcAmIOo3z50T4Vek3L5XbjnyPNSASgB9FZXU8wMum0D/Jq06EsUfpgv+ex+W4rKXHzJtYdySQ9MHUThhk7uV3vqWvaFfvfQvVcd+T16NqCkWA11lk/b/xqE3QSolRVNDCszm4P82FbmwBWJBaGd04oU78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609184; c=relaxed/simple;
	bh=gCZ4+xDzVSAKXpVOsX9KJAGTjtUx6xvPoFZNvNTGzOQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wxp1EfCwM0UlIHzzqQ9KvinngNDWYR921Iq/TNTOgdLlm9WYq8G2ppzGANL1S6u+3ornFgQ+P0UEnjZUl4J9CPA405nFOyGEC6JLNZIfUXh2iYsNHSrENVcoXoxZRLwT9KJLld/QLn8j9PANUWhXzSi+0JXT3PU3i2a1uchEuF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AT9jcM7Q; arc=none smtp.client-ip=91.218.175.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AT9jcM7Q"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=gCZ4+xDzVSAKXpVOsX9KJAGTjtUx6xvPoFZNvNTGzOQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790609178; v=1; x=1791213978;
 b=AT9jcM7Qb7MVac0xNbLN2XpMVJzWexGkjlsRZBfPM4eZ9YjBEOmOjPuFeyEFfvDvaSiTCQ0V
 pB/heBaslEVTk+8x2ASGL4xQ6gsNjOmniWZl1dNa6z93fBb4C+XM559RmHGQrKdfWXKiAMkCzev
 soUuKHZE2vX0fTuntJ42Bh9Y=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 741b53cb36a0a279;
	Mon, 28 Sep 2026 15:26:18 +0000
X-Mizu-Trace-ID: 741b53cb36a0a279
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 10/10] KVM: arm64: selftests: Free the thread arrays in vgic_lpi_stress
Date: Mon, 28 Sep 2026 16:25:07 +0100
Message-Id: <20260928152507.2116110-11-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260928152507.2116110-1-fuad.tabba@linux.dev>
References: <20260928152507.2116110-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

run_test() allocates the vCPU and LPI thread arrays and never frees
them, while destroy_vm() frees the rest of the test's allocations. Free
them once the threads have been joined.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index 9a69c439a0f8f..d09db95db3bd5 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -330,6 +330,9 @@ static void run_test(void)
 		kvm_pthread_join(vcpu_threads[i], NULL);
 
 	report_stats(delta);
+
+	free(lpi_threads);
+	free(vcpu_threads);
 }
 
 static void setup_vm(void)
-- 
2.39.5

