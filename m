Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A9B3890F2;
	Fri, 13 Mar 2026 09:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773395371; cv=none; b=f5Ao80/DFF7IbQHCGT5GZpdeXZidwwjX0bii5QQhiw2ERS+ytjEsPQm1cuG0vM/t1jYwvn/3+6oqZmCLbcA5+48G6Rff2KgAnez9PNWINDg5N5gZervcF0Y7XLtZYh4ZUiTBoqcLf6fHkbA695UBfcwObl9OSMNIln7w5Lry7WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773395371; c=relaxed/simple;
	bh=rUQb+Z8XCOJJahxSZ1DbE4oOFCh6UGrqUYNgYHqSvAc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LQzl8OFV1Mj4S/HnvzUUSFwyHjXiKhEo9hLZSURqmPHKaxm/R0HglagWjYRaNNIQatkqavbOsH1jGlnnAUUD0tQIRaECeBtwGD1WiBCDymx3hPYHq0fgxYzYl5s0iAY44NLIeU1NDgOm0iIuBjkM5W7W9CDtW8lSCiFLjluidAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOFe69m1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOFe69m1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6D0C2BC87;
	Fri, 13 Mar 2026 09:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773395371;
	bh=rUQb+Z8XCOJJahxSZ1DbE4oOFCh6UGrqUYNgYHqSvAc=;
	h=From:To:Cc:Subject:Date:From;
	b=FOFe69m1WQfLhVow/0Ckx8JOq7W24G+NglJ4NKzNaolAFffFHSiFOHMKX1KnAOyp2
	 DPiVvZfYC9fp7NYsn+Rg0wFPY89hoJv0M8r7kc64yKHjP+gVS/mf6qr6jtezqWSoCX
	 gUGxAz8O7vTGBLzXDzlfas+C1Hsg0t4fTaTQ+zJLtn0YMTNh4yWau+TgDeZv92ZUsQ
	 ugT/wNX90RTDc64tOcq3B51ufIG7syS7EigPbQnZaME0q5IIoehOuWiKlda494jEml
	 X3tAAumWhc7XYRxSkIiJY8sR54prjDVQeXZwe2YvyiylIw0gNJpcPT4f3QNa5y9F/5
	 kfev1hEH9EBOw==
From: Arnd Bergmann <arnd@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: avoid unused-variable warning
Date: Fri, 13 Mar 2026 10:49:16 +0100
Message-Id: <20260313094925.3749287-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The 'cpu' variable is only used inside of an #ifdef block and causes
a warning if there is no user:

arch/arm64/kvm/hyp_trace.c: In function 'kvm_hyp_trace_init':
arch/arm64/kvm/hyp_trace.c:422:13: error: unused variable 'cpu' [-Werror=unused-variable]
  422 |         int cpu;
      |             ^~~

Change the #ifdef to an equivalent IS_ENABLED() check to avoid
the warning.

Fixes: b22888917fa4 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/kvm/hyp_trace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index c1e28f6581ab..8b7f2bf2fba8 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -424,17 +424,16 @@ int __init kvm_hyp_trace_init(void)
 	if (is_kernel_in_hyp_mode())
 		return 0;
 
-#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
 	for_each_possible_cpu(cpu) {
 		const struct arch_timer_erratum_workaround *wa =
 			per_cpu(timer_unstable_counter_workaround, cpu);
 
-		if (wa && wa->read_cntvct_el0) {
+		if (IS_ENABLED(CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND) &&
+		    wa && wa->read_cntvct_el0) {
 			pr_warn("hyp trace can't handle CNTVCT workaround '%s'\n", wa->desc);
 			return -EOPNOTSUPP;
 		}
 	}
-#endif
 
 	hyp_trace_init_events();
 
-- 
2.39.5

