Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794901475;
	b=op6og2drTes7F2tbU4xG887qhlttkI3x16kzMvyepQbICUV7SksJk8oroBSP7mTY/nAE
	 k53cQCe2vy6gN1sfqy2jHlTnL+9VFoa0NQy7Hcju0wy5xOfNJKiMDoVl2umT9/Y0TqFC+
	 tT5rnzYW/d7+0ctu+CGpMusgbfGcB5wHV1fNcCuuDEedwjiEunQiKY0dYISgNWJOchapr
	 jPJ5lHOrpUT54bKboN1UEAbzKtIFq5Y1AmYOfM4FH756Z0upVGxzzHoSzUuuuZMYFprws
	 moRMrMXspmLmpPzkGn8YetRdESthgotJnrsNKpOPnygvmagYJhZRQUcbTdd6EI+Nzkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794901475;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=nJTrCNw3zk+mXzjZgUU06g5zrC28b74qTBb4oPoWMbI=;
	b=s7BncU95ej6q1duwkAv9ZXhiwbkFfQdW8WoXRN94oL6FdTVK6hR+m4UtEFXPJE12n3Am
	 NA0HoKDH570+832Rag9pPcyMYV/8C5YN2IRsUDWvoQFQ66s34tf/bhmnyzEOXR0eAW+Vp
	 GhnE2MN7Agk784vQehxmDnV13cskFxxe/wfby14GMRmI4FJ19XyTTeB4zgWuvcbLEoGOt
	 Y5nueb8/IFoifa7Y1g/MAIwgMNTBhZPsfXo27YW5H18AX2higQBvuvc5yOfpMLylu6pZe
	 I7BxLqsw2TnSaeobU4MqbcO22IFeNvKFvg6M1srioAty9eltqPX730rGO6/6FJoljFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LcnE2VaX;
	arc=none smtp.remote-ip=91.218.175.176
Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915E3606A32C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 07:44:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 915E3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LcnE2VaX
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=jVZ0So2orIv5BaxqX0IyQ9plkTtzDC6ZmcHPOd8EIw8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794901471; v=1; x=1795506271;
 b=LcnE2VaXEP+TPqzgXkMdVBNZgvqDYPebl0F/CaOo2PK3AKIjTNMEuYpvb49G+0UkSOWXZmUv
 vh8Y62g58sZuKdq6b2U6yBhCRR0U2qhJkRVhWaeJbya9W+XUFsJ0tFp3Yey7pmdC0nJZ/VI+jPH
 IhstGmJ1C8EdVtz/lL3Gitlw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d5bc28d01129cadc;
	Tue, 17 Nov 2026 07:44:31 +0000
X-Mizu-Trace-ID: d5bc28d01129cadc
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
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 0/2] KVM: Bound KVM_PRE_FAULT_MEMORY by the vCPU's dirty ring
Date: Tue, 17 Nov 2026 07:44:26 +0000
Message-ID: <20261117074428.7544-1-fuad.tabba@linux.dev>
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

Changes since v1 [1]:
  - Switched the check to kvm_dirty_ring_check_request(). (Sean)
  - The test checks that each page is reported exactly once, whatever
    the order. (Lorenzo)
  - Fixed the test on 64K-page arm64 hosts by sizing its range in host
    pages.
  - Various fixes. (Lorenzo)
  - Dropped Lorenzo's Reviewed-by on patch 1, since the check changed.

KVM_PRE_FAULT_MEMORY never checks the vCPU's dirty ring, so one call
over a large enough range of populated, dirty-logged pages overflows
it. The first patch stops the loop at the soft limit, as KVM_RUN does.
The second patch adds the case to pre_fault_memory_test.

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

[1] https://lore.kernel.org/all/20261110110724.3614412-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's dirty ring is full
  KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a full dirty ring

 Documentation/virt/kvm/api.rst                |   9 +-
 include/linux/kvm_dirty_ring.h                |   5 +
 .../selftests/kvm/pre_fault_memory_test.c     | 101 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   5 +
 4 files changed, 118 insertions(+), 2 deletions(-)

-- 
2.47.3

