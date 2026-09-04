Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3B6488763
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 12:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524703; cv=none; b=mUSanpsyQ5WXvQMDhKnTsqbdMLr9PsQVmHi1Z/ol61+H/2dGcSr7ghuSBtPWtQUQaqqyR6G3FwkKPntqz1tEcYOxxn+yPs67rVo3uNYdsjQumDdpFmoYVd6rMAinHf5EgGXVJ5c5cPqIEnNTzj2ghyy2FLwJltoQdLZ9i5Yx5nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524703; c=relaxed/simple;
	bh=PqwhrNyABnZAOTbk3+DQqjSMv0diEZDOtPwkTzZvqnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5dFBFV2T8kUqML000o257VEUD6BUaVjpyMJRySP55w5EKNqcwPgX6dz1U6JSYKgDM1h9ytdzsMY41pSgt8obn/kLoFKhPuePWpZpY6PAYP4BUthzVF/b86jRK+53AbX6q5A4lpFD0Qz6O8n8h9fPxDgiLUYnl9+rQuoSmD1VtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aFG1GAFs; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aFG1GAFs"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7f5934ba2a5so498956a34.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 05:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524700; x=1789129500; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kjXI7c1o2fMUZ4gP/lf6VLU7Bny6ysM8MfilUau8IZs=;
        b=aFG1GAFsrfjW/tDRU7JPlso6XmIQ7FTMnHZq0cT2qVpVVSvVQ1XvZvwMg6HnJY6zuF
         JgpvCTc2jxFx0zmNlT1IFYitAVExYXC47BOZc5pZ0aNR11yfzTSDAGO48g/VrtKeG6Xa
         GP6hzHlraOl1xWHq3vyk8eypDtDzfmrBFDZt5R+bz8LmTHob/skP9zMKb2NPrfdWcdBB
         dQhvULFQ31olSyh8/2fx5X5UTk0ksVz1WLQNpelSf/Jm9ftogMIAv2BCtweFhCPV4GkO
         l1K6GvANm+OY4G0UddRdC2ZoVisnS9XkK2w90zwN5VEBRSIeMBHtrB8R1sTfKKRd3du0
         Vxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524700; x=1789129500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kjXI7c1o2fMUZ4gP/lf6VLU7Bny6ysM8MfilUau8IZs=;
        b=f3hTdT+z7b3Yf+lndtCspkFZ8CTGyFtAVl0iz4uzOAzcb28Fnc4VgYzc71ftYAOfl3
         Uyr42FbKKC7HKwZwjFRKP/aeOIyZeeYeQvXmZavYXvH7t1u8v7AN9ljRuJINEpKqBmqi
         6hujmmTiwrZDvjHlU8TIZwcP2P07BqHLFNZItGoCBynsRrtm9bTuRXDwJFosHeidjYzr
         YfuV7r3OuuNsc5dpW4BWRzZUn2O/8J9YLSM2/jQ9/qcaYW9QgFMoLw4H7nKpTqg3Gecs
         bQSNrXrK8mKe9p9MsT87nuCDnwKxv8HIZS/Mieg7GGeauq5SCmAwbXTq4eSbr+zv8vo4
         z+BA==
X-Forwarded-Encrypted: i=1; AKwUvByDIuCiOtUV6VpBPsvExICGGbbRPxJTLhmT0UNleeK//Mwba0efJ6pWSYpozZM/6BtK8Xf2src=@lists.linux.dev
X-Gm-Message-State: AFuF++nzYvv8oPEOxzvPoslD25hEPgwlDQp8FfO3X1DLBvalL9n3AgYV
	OYoXdMB44ogheiuMtrJFcMjCDLTca3ZAuMzSKQBlDzfrio56yeeTOoXe
X-Gm-Gg: AYBFou0IiPlABvFKRPbmRRESmSEVjJPwIPXd5FXE//ZQhLEdko38t77fs5biXh80VYN
	WUFZJircLcmMlTaHYvsfNAgxD3QmAamI+glNj8jcJpvS6zsav+X1IOK7tQm5uJ1qv1pKYRNl7M7
	lZslwfIeeez0gvSug3X7vmdfMW3wlv6SqUoj0wGu8dSHQyP+jB8itO3YXHTNSKMBQDsSAkUjV8w
	zDUZFxyypP0rj2lugdRyIZZzyUvkLH8qnVxpb34b3VkMILPmYVNuZ3t+P8QGOnwu/6N06Z7A/e1
	fiuwea8A+7tUvxUZDIsNf0LzVq+wv+Yeh3jkFQ/5gP8H0gEZ+wsW4W0NVYFLI6u2ADyJvv/p8cJ
	lg1vsWbiisuknbldWE8C0vG7EvDqI6YgVrSlAs3wicoq9zSlBNNTgqSOsCE3PaA9uxa2z5h7wmK
	h43+ndkuyEb4FYxqh+qfsNKUjbFpzBWpvWMof5hgMzQvfreH0q72wz8fgSRvIK8PvyIlmx4CWmh
	mcEcMkDoZ5U2uY=
X-Received: by 2002:a05:6820:160b:b0:6b0:1b86:fb0 with SMTP id 006d021491bc7-6b6fe59c86dmr3821145eaf.31.1788524700176;
        Fri, 04 Sep 2026 05:25:00 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b8f787esm5880860eec.23.2026.09.04.05.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:24:59 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 2/3] selftests: kvm: fix typos in comments
Date: Fri,  4 Sep 2026 17:54:41 +0530
Message-ID: <20260904122445.31163-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904122445.31163-1-hemanth.selam@gmail.com>
References: <20260904122445.31163-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 tools/testing/selftests/kvm/arm64/debug-exceptions.c | 2 +-
 tools/testing/selftests/kvm/arm64/hypercalls.c       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/debug-exceptions.c b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
index 7dc5f0b4f6ad..9da6dc5bcfe6 100644
--- a/tools/testing/selftests/kvm/arm64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
@@ -387,7 +387,7 @@ static void guest_code_ss(int test_cnt)
 		 * Enable Single Step execution.  Note!  This _must_ be a bare
 		 * ucall as the ucall() path uses atomic operations to manage
 		 * the ucall structures, and the built-in "atomics" are usually
-		 * implemented via exclusive access instructions.  The exlusive
+		 * implemented via exclusive access instructions.  The exclusive
 		 * monitor is cleared on ERET, and so taking debug exceptions
 		 * during a LDREX=>STREX sequence will prevent forward progress
 		 * and hang the guest/test.
diff --git a/tools/testing/selftests/kvm/arm64/hypercalls.c b/tools/testing/selftests/kvm/arm64/hypercalls.c
index 5d96cdf382c4..a24becda9e62 100644
--- a/tools/testing/selftests/kvm/arm64/hypercalls.c
+++ b/tools/testing/selftests/kvm/arm64/hypercalls.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
-/* hypercalls: Check the ARM64's psuedo-firmware bitmap register interface.
+/* hypercalls: Check the ARM64's pseudo-firmware bitmap register interface.
  *
  * The test validates the basic hypercall functionalities that are exposed
- * via the psuedo-firmware bitmap register. This includes the registers'
+ * via the pseudo-firmware bitmap register. This includes the registers'
  * read/write behavior before and after the VM has started, and if the
  * hypercalls are properly masked or unmasked to the guest when disabled or
  * enabled from the KVM userspace, respectively.
-- 
2.48.1

