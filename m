Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFE118B46A
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 08:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729758675; cv=none; b=uw+gMBZSGA7k3qu23A5DZstMwb3eM+ttcVotE8qX2rMCtZh8ynWRsMl8oiIc8RVVjGhYKXnJkobSOKK8aX55CVPf2PNw1/hg3l7yewN+kB9YPhwxxfvhsg07LesDv1EUARomSy0GUHHOWArb7FK8E3aDhB5OfrQwLJr0S5aheeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729758675; c=relaxed/simple;
	bh=SLxGWY68OHG0AINM51aVgPJt6dLPEQxTn05PoCqvbZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWXkK+cVVDoUmOfDxMCZ4gND11+B60b3FmG0jz1uxjkcma+mzyeIcBceu8g8KNQ+r1hT3SO4evBvDRg7Kvq0CnoyAZC5gz4Z3K297JHNP0oRW6pzExu06xI0EL86V42KtqgKRqEijnEeX+X33PyphwXUfEyTpy6QH+Wi/bRkzWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wrG+2ELj; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wrG+2ELj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729758670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjte7RtBn7FVljJYgwwoEgon3WN/ThmaGIVx5uuDnBE=;
	b=wrG+2ELjwwKYlj5fGMNSv9CBTqaOi9XQzss1ya4zurKvYKLDA2w9eohtYAl3zdcuVWEf5T
	WKQ/3Se94bzzj1HQfYBSR9fzytsJI+Q0Z9FQqiEWJ9SIObLRTWvzn7c5mJG6e9ePIfN16q
	Jtx1Vi46vDooxQYyCO3mReKR8Ws5UoU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: rananta@google.com,
	pbonzini@redhat.com,
	thuth@redhat.com,
	subhasish.ghosh@arm.com,
	joey.gouly@arm.com,
	oliver.upton@linux.dev,
	maz@kernel.org
Subject: [kvm-unit-tests PATCH 5/4] arm64: gitlab-ci: Add clang build tests
Date: Thu, 24 Oct 2024 10:31:05 +0200
Message-ID: <20241024083104.44236-2-andrew.jones@linux.dev>
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
References: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Test building aarch64 with clang both with and without --enable-efi.
Use in-tree building for one and out-of-tree building for the other
to get more coverage there too.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 .gitlab-ci.yml | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index b7ad99870e5a..aa69ca594ba3 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -80,6 +80,52 @@ build-aarch64-efi-acpi:
       | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
+build-aarch64-clang:
+ extends: .outoftree_template
+ script:
+ - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu clang
+ - mkdir build
+ - cd build
+ - ../configure --arch=arm64 --cc=clang --cflags='--target=aarch64' --cross-prefix=aarch64-linux-gnu-
+ - make -j2
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
+      cache
+      debug-bp
+      debug-sstep
+      debug-wp
+      gicv2-active
+      gicv2-ipi
+      gicv2-mmio
+      gicv3-active
+      gicv3-ipi
+      its-introspection
+      its-trigger
+      pci-test
+      pmu-cycle-counter
+      pmu-event-counter-config
+      pmu-sw-incr
+      selftest-setup
+      selftest-smp
+      selftest-vectors-kernel
+      selftest-vectors-user
+      timer
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
+build-aarch64-clang-efi:
+ extends: .intree_template
+ script:
+ - dnf install -y edk2-aarch64 qemu-system-aarch64 gcc-aarch64-linux-gnu clang
+ - ./configure --arch=arm64 --cc=clang --cflags='--target=aarch64' --cross-prefix=aarch64-linux-gnu- --enable-efi --enable-efi-direct
+ - make -j2
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
+      selftest-setup
+      selftest-smp
+      selftest-vectors-kernel
+      selftest-vectors-user
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
 build-arm:
  extends: .outoftree_template
  script:
-- 
2.47.0

