Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B861189915;
	Tue,  3 Dec 2024 03:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733198035; cv=none; b=o0tQdtXD/EGtEtj+0ZOZpUhqST2muV3ZqO8XesgLeQ5TBPgXz3lW4AmyPxMAN1l6YoAe1MQLRIT+BW9WDOtcoEFt1oNzMQopN5Ltr3C48XjjEQRAlT6o7MjeOACu4FIHB14nDQKGtZoksIck0s1v/acYJOdmsfrpLNH2mU3lGTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733198035; c=relaxed/simple;
	bh=5JTvuvrdp0PoYfG53M8VM3nL/O7q9cv2Ozg4pvy3nm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaIf3QNS1pvelTjAnDUBC5DvREefMP0PeVFD3jcWFEDmo/PwfkkJ0fT5o/to2juqmZBx4y4UaxJGC/i4czlydQFBP0qSDKaw4tuy+0cDofqGHSaWt9NLiU/pBmMCE6qXRqeEI5ZmMTjeYCNc2RkTN3ZeJ21WivnDn9Ns0l7ZmCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNuRtadN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNuRtadN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EC8C4CEDA;
	Tue,  3 Dec 2024 03:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733198035;
	bh=5JTvuvrdp0PoYfG53M8VM3nL/O7q9cv2Ozg4pvy3nm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNuRtadNTVdxpVKXGZaEaD13aKY94tGuHOkj1GnuOUrIUC8+GKWqTc4yfIQ7O9kQD
	 +w8dUQ73s55I9Lhbc1pKlD37K4W/19JoJLdtS07UOlYS0y166Q+eGc0qzMH1fMy6tn
	 P1SjQALdFIXbV2yayFv7gFRBq4VZ6SOzse+C7ib+BsB6V4wPO4QuqHpcQu/7KO6ZqJ
	 YLwHIDUqpV9KTQEV+KmTjBMuOX4WYyxYZyeSk9Vxod79wjMMkIHqWs8cQoVI7RP58T
	 DDovXlH/3E2Uk0CqhxZ2bVli60DQ1DkEko1Y+ZgFYupKTuUJ2s3yZkHOYUzAtG47aK
	 p25O9VXu+l03Q==
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Subject: [PATCH 05/11] tools headers: Sync arm64 kvm header with the kernel sources
Date: Mon,  2 Dec 2024 19:53:43 -0800
Message-ID: <20241203035349.1901262-6-namhyung@kernel.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241203035349.1901262-1-namhyung@kernel.org>
References: <20241203035349.1901262-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To pick up the changes in this cset:

  97413cea1c48cc05 ("KVM: arm64: Add PSCI v1.3 SYSTEM_OFF2 function for hibernation")

This addresses these perf build warnings:

  Warning: Kernel ABI header differences:
    diff -u tools/arch/arm64/include/uapi/asm/kvm.h arch/arm64/include/uapi/asm/kvm.h

Please see tools/include/uapi/README for further details.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/arch/arm64/include/uapi/asm/kvm.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index 964df31da9751c96..66736ff04011e0fa 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -484,6 +484,12 @@ enum {
  */
 #define KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2	(1ULL << 0)
 
+/*
+ * Shutdown caused by a PSCI v1.3 SYSTEM_OFF2 call.
+ * Valid only when the system event has a type of KVM_SYSTEM_EVENT_SHUTDOWN.
+ */
+#define KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2	(1ULL << 0)
+
 /* run->fail_entry.hardware_entry_failure_reason codes. */
 #define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
 
-- 
2.47.0.338.g60cca15819-goog

