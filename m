Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915AA344052;
	Sun, 13 Sep 2026 07:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789283124; cv=none; b=R/xgUd7tcZp+yeMhckup6xw8ZahOot69unZopWgK6Yyu3Dq8JpYVzqQLccnUaZ4o+P9jxn3m/+vCdKN70KpGqOVcMED6jMv+SfGYHL0iqI/MEKqQ7WTTSwIsHRJDeHAN8u+dpOlWShOZNe5Xwulc2+V+3meMBWwvepl4uNn5xNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789283124; c=relaxed/simple;
	bh=tXmzQ9/0zxImuwG5nlQfSSjAFgmIBS5AnTHtSJv6yLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=psYcWo9cE9vQRMVM230IBFzIWNpa5+LRVkbPaDNwN5SrRwn4jvQGVpyDY5WUmaNPpqQY7OfI6jrzg8xCs4aIl5HyQf3CHfZnU2XOtXXJAAKA1cmzB3qZnsdXste0SRUlW6vkJrfyBmzaiqTe6ijoV9dP+pn/qWHeKs/iXNNLqQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fKYeFqPh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fKYeFqPh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D88F5153B;
	Sun, 13 Sep 2026 00:05:16 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 096833F7D8;
	Sun, 13 Sep 2026 00:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789283120; bh=tXmzQ9/0zxImuwG5nlQfSSjAFgmIBS5AnTHtSJv6yLk=;
	h=From:To:Cc:Subject:Date:From;
	b=fKYeFqPh3Nbti/qjh+YehqPr6Aca/4iAqF2MXvYA0u+kaAREt8vNj+T8KAi3a6Rly
	 rBcuzC95jeKQhJCf5FDEUVOmoK/RbImi7u0g+hnQr9U8v3H4AdsrkPf2FIlVF851S2
	 DZzNOKDUFBta4oUb0hFRQDPRg0PpDM0aJ8FiPpsE=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Date: Sun, 13 Sep 2026 08:04:58 +0100
Message-ID: <20260913070459.2547407-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

If the host attempts to access granules that have been delegated for use
in a realm these accesses will be caught and will trigger a Granule
Protection Fault (GPF).

A fault during a page walk signals a bug in the kernel and is handled by
oopsing the kernel. A non-page walk fault could be caused by user space
having access to a page which has been delegated to the kernel and will
trigger a SIGBUS to allow debugging why user space is trying to access a
delegated page.

There is work in progress to unmap the guest_memfd backed private pages from the
linear map. Until we get that support, we could get spurious GPFs from within
the kernel, e.g., load_unaligned_zeropad(). So, try to fix them up for now.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v17:
 * Pass untagged address to die_kernel_fault() - Sashiko
 * Explicitly check !user_mode() for fixups - Catalin
 * Switch to BUS_OBJERR for si_code from SI_KERNEL - Catalin
 * Clarify the commit description about the upcoming work on
   unmapping guest_memfd backed pages from linear map
Changes since v16:
 * Update the commit description to indicate why we try to fixup GPFs
Changes since v10:
 * Don't call arm64_notify_die() in do_gpf() but simply return 1.
Changes since v2:
 * Include missing "Granule Protection Fault at level -1"
---
 arch/arm64/mm/fault.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 75c3e463df2ef..dc3a87902a60c 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -914,6 +914,24 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
 	return 0;
 }
 
+static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
+{
+	const struct fault_info *inf = esr_to_fault_info(esr);
+	unsigned long addr = untagged_addr(far);
+
+	die_kernel_fault(inf->name, addr, esr, regs);
+	return 0;
+}
+
+static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
+{
+	if (!user_mode(regs) && !is_el1_instruction_abort(esr) &&
+	    fixup_exception(regs, esr))
+		return 0;
+
+	return 1;
+}
+
 static const struct fault_info fault_info[] = {
 	{ do_bad,		SIGKILL, SI_KERNEL,	"ttbr address size fault"	},
 	{ do_bad,		SIGKILL, SI_KERNEL,	"level 1 address size fault"	},
@@ -950,12 +968,12 @@ static const struct fault_info fault_info[] = {
 	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 32"			},
 	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
 	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 34"			},
-	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 35"			},
-	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 36"			},
-	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 37"			},
-	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 38"			},
-	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 39"			},
-	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 40"			},
+	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level -1 granule protection fault (translation table walk)" },
+	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 0 granule protection fault (translation table walk)" },
+	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 1 granule protection fault (translation table walk)" },
+	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 2 granule protection fault (translation table walk)" },
+	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 3 granule protection fault (translation table walk)" },
+	{ do_gpf,		SIGBUS,  BUS_OBJERR,	"granule protection fault" },
 	{ do_bad,		SIGKILL, SI_KERNEL,	"level -1 address size fault"	},
 	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 42"			},
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level -1 translation fault"	},
-- 
2.43.0

