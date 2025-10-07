Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CA727381C
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 22:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875298; cv=none; b=DgJsk89e8Up6yEByb+O2489vEMmJDBNFxb8o4p9pUHjFL+ep2IkNzQMEzvB9r5wjmXxmSYYSbe4ozaygaSW36vkZNVzssWGyZl077EaSEyf9IuSxwzKhoB1C9nCH+hGTO9sOl1W61lcSO2eKfkEubcnY1ViiSjxixcC8ebbY/Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875298; c=relaxed/simple;
	bh=pEAhEjGmE/6E3+3IorVbdBNzf37J42NibPq0N4C1YsA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nMmIGXAPWFslTaAZVa0vpVBmWz/xwgFVpIl7fZYVY5Gk/y5X9lLpdztS5DiSKfScrmqvk9tQoP5flcHIkjKHfiUzp6iSqRfY+Zxoa7ci3ymxj/CAjXwq2b2FNBZhUhaxOWou/0QspKrrH5wHN00SqdhjqxPUCfXQn68Pr4WuXck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xy52i7Fs; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xy52i7Fs"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2699ed6d43dso67558165ad.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 15:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875295; x=1760480095; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zTQs0EnNDco2mpUUW8A1kWTJ2V3fPeD2Oux5tvQu97s=;
        b=xy52i7Fshr5EexAAYbynSvCp9vmscNxWsIprPNPk+9s0NawE8TP1/GhpJOKpFZWJSB
         Ui9RqYr2sYHSVK1NOKtod5SHD2EZFC6k9GCLC17KhYEZ/32I5nGk8NTt7KAdijQGgCsF
         AMnc4qPRZ/z+J1WR4/KFF3Qt4EBTk4kIO7wVPCqOAVF45fg6waKVkRzEEJCzRDA8MdVm
         MmOOCRjuTwqFzAYYu7qxGiy9ts0ZaETPTQXjVi5OhX+t/3SOZt6kxOrbm5jOw3IrE97m
         6kqW+4CXiQZ7WZ9uhZeIky+kwH6phM8f61DaiIb9vBXOar5m3wNM4D1s1nqzI3ry5bv5
         CyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875295; x=1760480095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zTQs0EnNDco2mpUUW8A1kWTJ2V3fPeD2Oux5tvQu97s=;
        b=blK2bfumXuP/Z4F94p+THDhVu6b6Q4ryDg9gp20kmnLHQLQ08/gQyM0ev3i1OAuNRy
         QUZti/R7qpUk8IOHjgr44grhMMnIt9vyVeU/k35ORSDyjp9draXrTwGfBbU1Zn2YKCmn
         TOQTASxeJ97nnoMb087p2aXhMHJu6suANWyv4OSc5mr6IAQj4x280SM79QPW5ZQexeuy
         w1ATWzHW6FQpjM2YJ+4m6aGwc0JX/CnLidn756Ug9bM8+9sKgqJnes+wLpOnJ3Ujza+c
         oTK926kMTKcQP3j+lVY3V68QadYStCA4lMwo+bEDdODsp9+a6aUQfgaCqfkSuGjZRnBC
         3Wrg==
X-Forwarded-Encrypted: i=1; AJvYcCXLx91kjKivISMLB9VfB+n0KyA+S05oi4P02l9eKPH3gpiFuYhuEpExL/SVb8N+0O4M57fbFgE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYhMVayBiLS/LCeA9FzMt9djoj4QkUqnvtoKOqhQeEAOsh0TAW
	+H/NjJcdYJXH/9nv5D91DMpA8xC+6JyrrCyJowxjJQ2vAZhH+cVNo3S0ozncIRcYZZWnueaMj5v
	IcHxfKA==
X-Google-Smtp-Source: AGHT+IE4iOU9kwHgBlllnocBeU6IrHkDCIzq84NfugFiFee0pXpv+6bFVeJqE6gHwaZr6A6SdSFRTrYPG7c=
X-Received: from plhx16.prod.google.com ([2002:a17:903:2c10:b0:269:8ca7:6998])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e943:b0:269:ba8b:8476
 with SMTP id d9443c01a7336-2902741f0c1mr13607885ad.56.1759875294643; Tue, 07
 Oct 2025 15:14:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:18 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-11-seanjc@google.com>
Subject: [PATCH v12 10/12] KVM: selftests: Add helpers to probe for NUMA
 support, and multi-node systems
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

From: Shivank Garg <shivankg@amd.com>

Add NUMA helpers to probe for support/availability and to check if the
test is running on a multi-node system.  The APIs will be used to verify
guest_memfd NUMA support.

Signed-off-by: Shivank Garg <shivankg@amd.com>
[sean: land helpers in numaif.h, add comments, tweak names]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/numaif.h | 52 ++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
index 1554003c40a1..29572a6d789c 100644
--- a/tools/testing/selftests/kvm/include/numaif.h
+++ b/tools/testing/selftests/kvm/include/numaif.h
@@ -4,6 +4,8 @@
 #ifndef SELFTEST_KVM_NUMAIF_H
 #define SELFTEST_KVM_NUMAIF_H
 
+#include <dirent.h>
+
 #include <linux/mempolicy.h>
 
 #include "kvm_syscalls.h"
@@ -28,4 +30,54 @@ KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
 		   const unsigned long *, nodemask, unsigned long, maxnode,
 		   unsigned int, flags);
 
+static inline int get_max_numa_node(void)
+{
+	struct dirent *de;
+	int max_node = 0;
+	DIR *d;
+
+	/*
+	 * Assume there's a single node if the kernel doesn't support NUMA,
+	 * or if no nodes are found.
+	 */
+	d = opendir("/sys/devices/system/node");
+	if (!d)
+		return 0;
+
+	while ((de = readdir(d)) != NULL) {
+		int node_id;
+		char *endptr;
+
+		if (strncmp(de->d_name, "node", 4) != 0)
+			continue;
+
+		node_id = strtol(de->d_name + 4, &endptr, 10);
+		if (*endptr != '\0')
+			continue;
+
+		if (node_id > max_node)
+			max_node = node_id;
+	}
+	closedir(d);
+
+	return max_node;
+}
+
+static bool is_numa_available(void)
+{
+	/*
+	 * Probe for NUMA by doing a dummy get_mempolicy().  If the syscall
+	 * fails with ENOSYS, then the kernel was built without NUMA support.
+	 * if the syscall fails with EPERM, then the process/user lacks the
+	 * necessary capabilities (CAP_SYS_NICE).
+	 */
+	return !get_mempolicy(NULL, NULL, 0, NULL, 0) ||
+		(errno != ENOSYS && errno != EPERM);
+}
+
+static inline bool is_multi_numa_node_system(void)
+{
+	return is_numa_available() && get_max_numa_node() >= 1;
+}
+
 #endif /* SELFTEST_KVM_NUMAIF_H */
-- 
2.51.0.710.ga91ca5db03-goog

