Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.88
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795433685;
	b=tgrf5zVIJ+LvKVbCw08GI1gOlwD/CPP5xLR4eUDFPmaHVj3lMVRsZHzda4l2FFQ1+JcJ
	 6TMjVUaiFN/LKVl96+NhgDWmlXuAXeMxqt9y2O5zwSI5Eag6gtE15axcbXMmW1H9RlkkE
	 KKTtt4DffP07reCoFSePj6GJ/aHPzIOoSv7+cja2lS8MIK7TU5mWguPnIRhJELkRudTd0
	 gb6CUNliU1FOY5eonH4YWPniGSZL84uvybjKEH0Cz1vn2ur717xH3iKsS9f3TOq4xbRvD
	 fE5MT/QBl6rGExYnVns1a7jsoxI7uiEDolVWfDyp8WQh1pyQw24w5/+nGXxNfXLZvhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795433685;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UppeewSJQTI9wML/iAiukB2NfsE5bh7Xk8VoIJRzzKE=;
	b=XYKCMkta+GBsxA9QqwU9grJLKmH6P07ElOKbFYq8VIQbufWnziZQnlm6AUNH9FY0gBgs
	 TkOd4Trdo8RjEa+fxeoNpdR+KgF3h5wEX4ibqSyknJksfwQu93hiYCYfe5BjTDkaPgY9R
	 mLmdcq7daYXnU4365AhIEurRvFKW5b1BQwUkm5N2MTLDSL9IDm2u39Kyo9UakWfjNaLA4
	 56ZqRU0eu9O6JDxUOxOzkbyq4UbXglXwjdq/pZKFtpDFH8AAzUMBZni/NsrJVnzmR6OHf
	 aXoaA4wX4oGr4ttxczj8+s18bJYbY3/5oMEZWg8lLk3tDbDdXSfalveKQwCsGFTUUKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=G0TQwbQf;
	arc=none smtp.remote-ip=91.218.175.88
Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42986606A696
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 11:34:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42986606A696
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=G0TQwbQf
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kJVYvwnmwcWNzEw2JdWH14aPDZC8p2gGMQyighOKNqY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795433683; v=1; x=1796038483;
 b=G0TQwbQf7Kj4y/R6ox6nny9M8jPCzE187Ty8ReY69/nju2wzoC+y5I9ya0vYj9QW/3FWlWyH
 G25nR7EQEz3etHUljY+sBKLfq+jmR6sCb2TE89hKrsEC2encTA8VdM4IZNCEMihAEQlDswljmJj
 inhMt+6tpk4fOfwl+SEyyLPs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9a34595c63725e53;
	Mon, 23 Nov 2026 11:34:43 +0000
X-Mizu-Trace-ID: 9a34595c63725e53
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
Subject: [PATCH v3 2/3] KVM: Warn userspace against ioctls while an exit is pending
Date: Mon, 23 Nov 2026 11:34:34 +0000
Message-ID: <20261123113435.1170711-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123113435.1170711-1-fuad.tabba@linux.dev>
References: <20261123113435.1170711-1-fuad.tabba@linux.dev>
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

KVM_PRE_FAULT_MEMORY sets run->exit_reason to KVM_EXIT_DIRTY_RING_FULL
when it stops on a full dirty ring. If an MMIO exit is pending at that
point, the next KVM_RUN on arm64 and riscv doesn't complete it. Rather
than document that case alone, which could suggest that other ioctls
are safe, warn against invoking any ioctl other than KVM_RUN before a
pending exit is completed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/virt/kvm/api.rst | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 89eb6be9bc6e3..980ef0cdc1c91 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6974,10 +6974,13 @@ to the byte array.
 
       The pending state of the operation is not preserved in state which is
       visible to userspace, thus userspace should ensure that the operation is
-      completed before performing a live migration.  Userspace can re-enter the
-      guest with an unmasked signal pending or with the immediate_exit field set
-      to complete pending operations without allowing any further instructions
-      to be executed.
+      completed before performing a live migration.  In general, userspace should
+      exercise extreme caution when invoking ioctls other than KVM_RUN prior to
+      completing the original operation.
+
+      Userspace can re-enter the guest with an unmasked signal pending or with
+      the immediate_exit field set to complete pending operations without
+      allowing any further instructions to be executed.
 
 ::
 
-- 
2.47.3

