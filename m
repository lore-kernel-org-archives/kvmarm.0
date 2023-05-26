Received: from out-29.mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795CF2A9F6
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 22:17:29 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685139447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bWifmxddLT3nvUDIRRuiZb+7qrGg/n9duhLsnxIE7XE=;
	b=aLKBQOv+Oysm0N7VH4KYBc+CT5w++pBdOqrQ/Pjcpfd1B20vzxA/Bn/kExpzNZ04UjDlpe
	NUr2Cyya5kmAQGJUqwMzevHBddTZq9a8XLpBSemxuE5RAKWMf1v3KAhpQ91Mg3Urkcsh/q
	J0MepHhjrgi0Jc/JtQ5gFnU6PN0nqZI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 03/21] Copy 64-bit alignment attrtibutes from Linux 6.4-rc1
Date: Fri, 26 May 2023 22:16:54 +0000
Message-ID: <20230526221712.317287-4-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

An update to vfio.h requires these macros.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 include/linux/types.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/types.h b/include/linux/types.h
index 5e20f10f8830..652c33bf5c87 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -36,6 +36,19 @@ typedef __u32 __bitwise __be32;
 typedef __u64 __bitwise __le64;
 typedef __u64 __bitwise __be64;
 
+/*
+ * aligned_u64 should be used in defining kernel<->userspace ABIs to avoid
+ * common 32/64-bit compat problems.
+ * 64-bit values align to 4-byte boundaries on x86_32 (and possibly other
+ * architectures) and to 8-byte boundaries on 64-bit architectures.  The new
+ * aligned_64 type enforces 8-byte alignment so that structs containing
+ * aligned_64 values have the same alignment on 32-bit and 64-bit architectures.
+ * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
+ */
+#define __aligned_u64 __u64 __attribute__((aligned(8)))
+#define __aligned_be64 __be64 __attribute__((aligned(8)))
+#define __aligned_le64 __le64 __attribute__((aligned(8)))
+
 struct list_head {
 	struct list_head *next, *prev;
 };
-- 
2.41.0.rc0.172.g3f132b7071-goog

