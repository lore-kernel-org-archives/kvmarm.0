Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.73
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795433683;
	b=BBwocA/ex1GaMCZgEMH9eK0dqvETeE60RIJlUdFG6Cn7XbQ7eoSt7TDf+GwcuLmsYYAp
	 DMhApBwJO/GYI/HO3xxKUSXX6CzaVZUZLzXKgpq2MwAaehpwTi2GLRD3TFY8/uklZXWG7
	 SgXzgqRlM5D+LdYVMHf2OusZKXU9lSpNr7VAHP8GHgizRClzgBCiZNbLVkowQBIMf9wYy
	 P/c1xPDlsTZ0u9ScMwLE7WujUA3TXr9yk0ZM5XmjiFskoJ26TnTzoAo1SwfyAi2WDDyd7
	 5M7QPRykgbno7PMzsPsWWuRJc6DhJsJKjU1TBqxoTvG/XgZq6xuYfSJLUeyg9j3f8SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795433683;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=NPRhYDnwJRvicd4u9ac46NRRTHp7yf2uOQ6I7pysTOs=;
	b=5Z70e6NqK9MKKrqARbnUp1B5Wk/41GS58ue21ahn6oUJFyk+NotCVYLXSiNBXBXLSD5Z
	 GdXXb6XzhiIOAl5HBgMb+QXpv9DK2EdLZZ5/GlhjggyU6i7Qz9/7Dl+yi+qlkJhpMkklM
	 Duh81S0u2jad3PIJTdfMZeQQBU+j/xPx2W3/JU6vlGv1oq3I+qJXmZVD0BNP0SLyHgctb
	 pA3TG4PT/kM2XyAJKk3kKHkJBcAqXcmL4HH2yNDEERsLRKZ1SeHQhSkPDUAVdHsNPnGPV
	 P5/8znAdzA9pja0rt/tf0BMCKHzHr8ltyMJ4KpOwNLqrlbljfDjHV3JRJhyrsCReVyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LJyZfoTK;
	arc=none smtp.remote-ip=91.218.175.73
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55814606A32E
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 11:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55814606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LJyZfoTK
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sjV6qrYMC8GhJztUOTln5L8ygixllt0tnTT6CrNeYyI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795433680; v=1; x=1796038480;
 b=LJyZfoTK8ZtIYq9wmTcSMfhlUK4V/QQiyUq0/16fublnXDwgzY+bHufptb+40LP4Btx/jvBA
 tgXKmtXeFKVh5OcpvJu9iiFbyoBSjybXUlU/ZuYeQdOrleefE2eqzdiLKQDG/oSAAlKgTUANJKM
 GQzMMepdx6XCOdQtir/HYZbE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b141b18848b98b72;
	Mon, 23 Nov 2026 11:34:40 +0000
X-Mizu-Trace-ID: b141b18848b98b72
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	kvm-riscv@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 0/3] KVM: Bound KVM_PRE_FAULT_MEMORY by the vCPU's dirty ring
Date: Mon, 23 Nov 2026 11:34:32 +0000
Message-ID: <20261123113435.1170711-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v2 [1]:
  - Added patch 2, which warns in api.rst against calling ioctls other
    than KVM_RUN while an exit is pending. (Sean)
  - Mentioned riscv as well as arm64 in patch 1's exit_reason
    paragraph. (Lorenzo)
  - Collected Lorenzo's Acked-by on patch 3. (thanks!)

KVM_PRE_FAULT_MEMORY never checks the vCPU's dirty ring, so one call
over a large enough range of populated, dirty-logged pages overflows
it. The first patch stops the loop at the soft limit, as KVM_RUN does.
The second warns userspace against calling ioctls other than
KVM_RUN while an exit is pending. The third adds the case to
pre_fault_memory_test.

Pre-faulting isn't the only ioctl that can push past the ring's
reserve. On x86, KVM_SET_MSRS does too when it writes the wall clock or
the Hyper-V hypercall page. A guest can also push past the reserve
within one exit, for example through the arm64 ITS. What those paths
should do when the ring fills is an open question for the dirty ring
API, which I don't think belongs in this series.

I didn't include the kvm_dirty_ring_check_request() rewrite that Sean
sketched on v1, since I think it can lose a request. It tests the
request first and clears it afterwards. If the vCPU is scheduled out in
between, loongarch sets the PV preempted flag in guest memory and x86
updates a Xen guest's runstate area, either of which pushes an entry.
When that push makes the ring soft full, the request it makes is then
cleared, and the vCPU runs with the ring soft full until its next push.
Clearing first and re-setting, as the code does now, doesn't have that
window.

Based on Linux 7.4-rc2 (7475ea8b58616; also applies to kvm-x86/next
cbe54fc3462b3 with git am -3).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261117074428.7544-1-fuad.tabba@linux.dev/

Fuad Tabba (3):
  KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's dirty ring is full
  KVM: Warn userspace against ioctls while an exit is pending
  KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a full dirty ring

 Documentation/virt/kvm/api.rst                |  20 ++--
 include/linux/kvm_dirty_ring.h                |   5 +
 .../selftests/kvm/pre_fault_memory_test.c     | 102 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   5 +
 4 files changed, 126 insertions(+), 6 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.47.3

