Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B749A21D5A9
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 18:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680940; cv=none; b=Eikxza7kCihvL9jTaV4bQggtLWmgHrUTbAqnSz5ABZ3bUYf0z+D7RL0Sr47Tsv+bTBHbwZ/UIs7m8Epwtm8/cgxkY8neVAljuasnnSWvqqpuH6T3WHCwZt7FNYjEhqUw97NA0RZu7mWh42tPgmuOu11blxAsfnBAvhZGxUISxjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680940; c=relaxed/simple;
	bh=02DhIDJiTY5SN586FcWil6j3M7CNOC2X358tokby4WI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qK7bXhbVPksnSvgtpICH0tnDkovMQLrIIltAhWKJWgfuJG5tWjvuat6yMZSqIiEhYf53ooFiwkOmqsqzI2BFBAR5de1OawiC9wEsj6+zz83k6L0b5Mkxf9cPb6llpqlkrQFCGCFt/VgzdM3x1iXok/nLs5x8hmWDdoab4SXOw1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jsu/ToOU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jsu/ToOU"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e78145dc4so4901213a91.2
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 11:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680938; x=1748285738; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OKVb/rjt7xbg7iGYLrHxAz9ea9MJSgJFrfmn1LPAXvg=;
        b=Jsu/ToOUKb5rKMMimoKmKpO9qHVfmKrXmVCAp4TvkLPlb7XjEBmo47/mc/dIz73Y7U
         O2u8WAe9YhfUjdCTtPco/7IXRAJqSGnrBvOjMPQWjzd+ZuLNIZRmZ9RRDbKhmURVeUpr
         epVUEQjVEQ7iuZi/av0wma/x0DmG0Jq18A7oG1xp8sqLad+eF+voackGM3CY/WeFgmAR
         mQAZB5bNXBdrI9Nkkx/Z/VBhWAqaiVtEqKDI9n+BXSWowuLazb5ExJSSi058EX2wtjI/
         PdrCE+bMSGNjytoXBjNrt/OCFisLtaHEmBst8srfKq6lViwtfk92PfzrFS/APmgX2g0E
         n9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680938; x=1748285738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OKVb/rjt7xbg7iGYLrHxAz9ea9MJSgJFrfmn1LPAXvg=;
        b=C/q9DDbonwTC125mswcS8DjqjHJZC1apf+l+RTJn2dDA3M06fDyGPFfiSIPvJu9wBi
         aKtZeJFGvHzSt9kdOhe/TLKt54s8j6mtNuKRHCOqnKBf/YTDluEDiBnrRzJwp7i6SYrL
         R3ohtVNex8tHvmLRjwaPGb22vn6MNWEvu34d+5Lko/LUySZz/IFzjGFPdxN8gD5d+qsP
         rrplgCoAFj8aWwd2WkbdSwOk6DKuQUWdsRN6JWnxmUkb5ZU6k9XACMPV0SxBT5Bo25eL
         XYV5a//d12aN/dGmFOw8f+aBA1nT/V4DKew6+E07j7g7H+OTk7fZnX2c1R7wxh0xnPdQ
         2+LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdQxX/NRCsBn9gzLuJ1LVyOhfiKtBARnAbn+DtNctJeirEKyMw1BLb9KxX/UTD/r9Wr0bED0Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YypulqgGcQQkPN/Jcm7KJKnZi/v/WzPlO7QDNQlW4bMpuMOTX0O
	MrXg3v2A5T8+imHlGoP6TUdtF6GI5FjExAMsmgtZWH5XhUdFbtKYK0cbDGai3nQFIG8NVTPlOfm
	Ow8COBA==
X-Google-Smtp-Source: AGHT+IEj2WzLh67Ixl+YoFxokm7fFAzAUdnIzgu7IZZuNo0LIfTZvWOpLGE1fjEGyPSa8CLIT1wrF7Tf+5Y=
X-Received: from pjbqa8.prod.google.com ([2002:a17:90b:4fc8:b0:30e:85f1:6fa5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c08:b0:30e:6a10:bb41
 with SMTP id 98e67ed59e1d1-30e7d5a85c1mr21316229a91.27.1747680938275; Mon, 19
 May 2025 11:55:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:13 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-12-seanjc@google.com>
Subject: [PATCH v2 11/12] KVM: selftests: Add utilities to create eventfds and
 do KVM_IRQFD
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Add helpers to create eventfds and to (de)assign eventfds via KVM_IRQFD.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c  | 12 ++----
 .../testing/selftests/kvm/include/kvm_util.h  | 40 +++++++++++++++++++
 .../selftests/kvm/x86/xen_shinfo_test.c       | 18 ++-------
 3 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index f4ac28d53747..a09dd423c2d7 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -620,18 +620,12 @@ static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
 	 * that no actual interrupt was injected for those cases.
 	 */
 
-	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
-		fd[f] = eventfd(0, 0);
-		TEST_ASSERT(fd[f] != -1, __KVM_SYSCALL_ERROR("eventfd()", fd[f]));
-	}
+	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++)
+		fd[f] = kvm_new_eventfd();
 
 	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
-		struct kvm_irqfd irqfd = {
-			.fd  = fd[f],
-			.gsi = i - MIN_SPI,
-		};
 		assert(i <= (uint64_t)UINT_MAX);
-		vm_ioctl(vm, KVM_IRQFD, &irqfd);
+		kvm_assign_irqfd(vm, i - MIN_SPI, fd[f]);
 	}
 
 	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a1fc52bbdf7a..befa3d8ea84c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -18,6 +18,7 @@
 #include <asm/atomic.h>
 #include <asm/kvm.h>
 
+#include <sys/eventfd.h>
 #include <sys/ioctl.h>
 
 #include "kvm_util_arch.h"
@@ -496,6 +497,45 @@ static inline int vm_get_stats_fd(struct kvm_vm *vm)
 	return fd;
 }
 
+static inline int __kvm_irqfd(struct kvm_vm *vm, uint32_t gsi, int eventfd,
+			      uint32_t flags)
+{
+	struct kvm_irqfd irqfd = {
+		.fd = eventfd,
+		.gsi = gsi,
+		.flags = flags,
+		.resamplefd = -1,
+	};
+
+	return __vm_ioctl(vm, KVM_IRQFD, &irqfd);
+}
+
+static inline void kvm_irqfd(struct kvm_vm *vm, uint32_t gsi, int eventfd,
+			      uint32_t flags)
+{
+	int ret = __kvm_irqfd(vm, gsi, eventfd, flags);
+
+	TEST_ASSERT_VM_VCPU_IOCTL(!ret, KVM_IRQFD, ret, vm);
+}
+
+static inline void kvm_assign_irqfd(struct kvm_vm *vm, uint32_t gsi, int eventfd)
+{
+	kvm_irqfd(vm, gsi, eventfd, 0);
+}
+
+static inline void kvm_deassign_irqfd(struct kvm_vm *vm, uint32_t gsi, int eventfd)
+{
+	kvm_irqfd(vm, gsi, eventfd, KVM_IRQFD_FLAG_DEASSIGN);
+}
+
+static inline int kvm_new_eventfd(void)
+{
+	int fd = eventfd(0, 0);
+
+	TEST_ASSERT(fd >= 0, __KVM_SYSCALL_ERROR("eventfd()", fd));
+	return fd;
+}
+
 static inline void read_stats_header(int stats_fd, struct kvm_stats_header *header)
 {
 	ssize_t ret;
diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index 34d180cf4eed..23909b501ac2 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -547,11 +547,8 @@ int main(int argc, char *argv[])
 	int irq_fd[2] = { -1, -1 };
 
 	if (do_eventfd_tests) {
-		irq_fd[0] = eventfd(0, 0);
-		TEST_ASSERT(irq_fd[0] >= 0, __KVM_SYSCALL_ERROR("eventfd()", irq_fd[0]));
-
-		irq_fd[1] = eventfd(0, 0);
-		TEST_ASSERT(irq_fd[1] >= 0, __KVM_SYSCALL_ERROR("eventfd()", irq_fd[1]));
+		irq_fd[0] = kvm_new_eventfd();
+		irq_fd[1] = kvm_new_eventfd();
 
 		irq_routes.info.nr = 2;
 
@@ -569,15 +566,8 @@ int main(int argc, char *argv[])
 
 		vm_ioctl(vm, KVM_SET_GSI_ROUTING, &irq_routes.info);
 
-		struct kvm_irqfd ifd = { };
-
-		ifd.fd = irq_fd[0];
-		ifd.gsi = 32;
-		vm_ioctl(vm, KVM_IRQFD, &ifd);
-
-		ifd.fd = irq_fd[1];
-		ifd.gsi = 33;
-		vm_ioctl(vm, KVM_IRQFD, &ifd);
+		kvm_assign_irqfd(vm, 32, irq_fd[0]);
+		kvm_assign_irqfd(vm, 33, irq_fd[1]);
 
 		struct sigaction sa = { };
 		sa.sa_handler = handle_alrm;
-- 
2.49.0.1101.gccaa498523-goog

