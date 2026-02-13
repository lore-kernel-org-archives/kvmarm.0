Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E49F221F26;
	Fri, 13 Feb 2026 14:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770992185; cv=none; b=k+H7MnCy8yF/RNZDqu+0CWiZdN1Pc2YnAgRv4IkfHPJrsuYAiaD9+JI3mnduD3hm77QEOXwrBQCMgR8HdrzglYBuu5IKAChX6kH0j7+IXgCgoR3jyLk9Z16jUEmixfWwmZIcC48t4v6lVqevOgCoYTjYFll7UnBcRYuitJ6r6g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770992185; c=relaxed/simple;
	bh=4edQuEePW6yhcvYTSlisOuKCCvknpEatDy/ILAJ726E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h3P1OzfCsxQgVdJ8/CLyY2PhH2SpXE2zjQTY2drfE8vHiH+J28WxcVNuzk1YfXdWrHs/V1i5XWm8WPqc+goJztYo5Kjx0DtmIY06tWnyDy2kHt6DSyXfk9RjI22Vhv+MHtWDvpkLCADaRVxsjHcmMYDNQgisLg5h5TuCat9zJAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VeaChKw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VeaChKw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE35C116C6;
	Fri, 13 Feb 2026 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770992184;
	bh=4edQuEePW6yhcvYTSlisOuKCCvknpEatDy/ILAJ726E=;
	h=From:To:Cc:Subject:Date:From;
	b=VeaChKw6nltt5Ypc/+SNuu+Jp1k7Y9AOgbYJ6Wd7lspMS8zXmbSrgW3Bjr8Dk6gPa
	 +HTtlL0t/d8KN0wH45bJdNtivXBryVhDrBLUqAiRs5PN3Guw4mdwdmKulgbin4JA7B
	 xI+kU4Qeii1VCTdw3AYTIHtDEDTF9DGQq0MEYApCYXc78TPsF+MM/nu1hjw/TmmWBn
	 3ud7Svd+XXMkWZ5oGjApNj5qugYht/Te15/sMR76D8niVSKymJ1qwbNTjtaVb2iYoH
	 qMhfpT90u1nNADpoFr/pNbY+TPJvwECle9i5tqdWMwwz+usGQ2bHymwcW2qYeUUftT
	 nSedNidnzQlQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vqty2-0000000Ate3-1GZW;
	Fri, 13 Feb 2026 14:16:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Hyesoo Yu <hyesoo.yu@samsung.com>,
	Quentin Perret <qperret@google.com>,
	stable@vger.kernel.org
Subject: [PATCH] arm64: Force the use of CNTVCT_EL0 in __delay()
Date: Fri, 13 Feb 2026 14:16:19 +0000
Message-ID: <20260213141619.1791283-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, hyesoo.yu@samsung.com, qperret@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Quentin forwards a report from Hyesoo Yu, describing an interesting
problem with the use of WFxT in __delay() when a vcpu is loaded and
that KVM is *not* in VHE mode (either nVHE or hVHE).

In this case, CNTVOFF_EL2 is set to a non-zero value to reflect the
state of the guest virtual counter. At the same time, __delay() is
using get_cycles() to read the counter value, which is indirected to
reading CNTPCT_EL0.

The core of the issue is that WFxT is using the *virtual* counter,
while the kernel is using the physical counter, and that the offset
introduces a really bad discrepancy between the two.

Fix this by forcing the use of CNTVCT_EL0, making __delay() consistent
irrespective of the value of CNTVOFF_EL2.

Reported-by: Hyesoo Yu <hyesoo.yu@samsung.com>
Reported-by: Quentin Perret <qperret@google.com>
Reviewed-by: Quentin Perret <qperret@google.com>
Fixes: 7d26b0516a0df ("arm64: Use WFxT for __delay() when possible")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/ktosachvft2cgqd5qkukn275ugmhy6xrhxur4zqpdxlfr3qh5h@o3zrfnsq63od
Cc: stable@vger.kernel.org
---
 arch/arm64/lib/delay.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
index cb2062e7e2340..d02341303899e 100644
--- a/arch/arm64/lib/delay.c
+++ b/arch/arm64/lib/delay.c
@@ -23,9 +23,20 @@ static inline unsigned long xloops_to_cycles(unsigned long xloops)
 	return (xloops * loops_per_jiffy * HZ) >> 32;
 }
 
+/*
+ * Force the use of CNTVCT_EL0 in order to have the same base as WFxT.
+ * This avoids some annoying issues when CNTVOFF_EL2 is not reset 0 on a
+ * KVM host running at EL1 until we do a vcpu_put() on the vcpu. When
+ * running at EL2, the effective offset is always 0.
+ *
+ * Note that userspace cannot change the offset behind our back either,
+ * as the vcpu mutex is held as long as KVM_RUN is in progress.
+ */
+#define __delay_cycles()	__arch_counter_get_cntvct_stable()
+
 void __delay(unsigned long cycles)
 {
-	cycles_t start = get_cycles();
+	cycles_t start = __delay_cycles();
 
 	if (alternative_has_cap_unlikely(ARM64_HAS_WFXT)) {
 		u64 end = start + cycles;
@@ -35,17 +46,17 @@ void __delay(unsigned long cycles)
 		 * early, use a WFET loop to complete the delay.
 		 */
 		wfit(end);
-		while ((get_cycles() - start) < cycles)
+		while ((__delay_cycles() - start) < cycles)
 			wfet(end);
 	} else 	if (arch_timer_evtstrm_available()) {
 		const cycles_t timer_evt_period =
 			USECS_TO_CYCLES(ARCH_TIMER_EVT_STREAM_PERIOD_US);
 
-		while ((get_cycles() - start + timer_evt_period) < cycles)
+		while ((__delay_cycles() - start + timer_evt_period) < cycles)
 			wfe();
 	}
 
-	while ((get_cycles() - start) < cycles)
+	while ((__delay_cycles() - start) < cycles)
 		cpu_relax();
 }
 EXPORT_SYMBOL(__delay);
-- 
2.47.3

