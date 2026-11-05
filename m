Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793921697;
	b=NloNE0gmKhsH8QQvfzn/9itEBkPzRHqsJosp0oac7fZfabEBf2+D3RIzvTbY3BauJMkV
	 Ymw5/G7hUi26PcaiZSMWetsYrPCxVf5HaFPrzHqVQ3czb6TbQix82P/UxmvB3iBSHKEb4
	 vrqd+pWZIH8pWLdty5f5r44P20d4RLs6Nehfknyr7eD1pfCcgrb+AT6w7WwXBIV/ierk2
	 H8ZZ2IQY+EsyiD+FrZxxhdmm6wRzgV07kuBE1ihSv4Z40Pj6+BLwD3Vw25JvytnzH1gsd
	 gk31gSNQthfwO9tW82tKo3cikFCDLNI0ES26zA1d4a0YSj7Qz5vJo23LAcRjVMYmeQA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793921697;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=uW24Oo6SzxhmQfdFBJWhZnZ3z5QiPA441Ft/BalVdAE=;
	b=mUnDyGAa9J1T99oU9dZd+EN1re7Xgj5MvL64g2YyOa+mxwzCQ+EZfAwAvrwv1nCU7GEl
	 xqlZVLNBUiiGC1EMaPFzCugEv2H3/aWFbVOfXzpCFwWw91p7JHiiKPj6TWHYYM544Ms16
	 Dk5kw9mzY2njYDgVW43RwlUzKmgX3PHkEP2kTqinPpGmmHEjbfuH/+6bAGsNSuUzld4dP
	 xnRESugRAydWzZl38cAX8GcyfqIqyFVgIuBhgbDCdn+EAZCPtOUc2WNLwYL4RFyj6gWD8
	 p2vkYyVQkPJM4y9wuIKlT8Su9G+SEGOKsG4c8/1n4rP/N2iVf2XuaLglJ/bg1/J5m+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UzgDizeQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97492606A31B;
	Thu,  5 Nov 2026 23:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UzgDizeQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793921696;
	b=Jc3VnRNug1FfZnUV1rT6TvzHuqCy59Ln8BraD9M8FOa6XXDBBQaP4h6iKnL/hGGrdQ5K
	 SwgdbkDoqElTxBXj+vBA26hnrgnx0wMOrCOeT0SDrIrJWswc8eOAcWTISNlUEAG0p8Uv0
	 ezORHvJNIpyBQhO2o1yejhnJmFQRwxY1POvdP7oHyGbGjENnB25DPvWnzOgeFuJ+JmhQ6
	 gaKaB63Hux840YDqFN10pd2nbf0GkJNAbfiXhYhb6QrPYW5dsHwkodWKchhaj1hiCrhpI
	 Z2QtM6F42nnU5T42DKztidvKysc+/DmOXvW+sphgRNLVUArPG8sisUy/WuCJhxqoOYg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793921696;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=uW24Oo6SzxhmQfdFBJWhZnZ3z5QiPA441Ft/BalVdAE=;
	b=icxuiiw4wxZUWJt+pwgOATnxZzwptozXPpwEwoMt43cmqld+iTDLjkeh2zNCNdOWZpYe
	 Q+iLb2JvvmLlQXtPgKFdjm38+IpqSx/2iQAhOdsBQwl+a9fgICp4YqkIB3/hbgKiPbrOk
	 K2SziBTYxIPb5dSRR2g9Vpqf0k0KMEu4LiktoWbz+aS7SypKNFUk+g3FsZ0QM1ZftGJ74
	 SHzD8PUxYOiSQc+BEtLu1teJRtbWkFSit/HeEdA0SxM9FilwE8khiurp7kFd0N9cwzbTk
	 S52RzLGoMeTPnvj6OXgOz6FJGpgKHcGJq3YEBPX6ZaTveZUgiU0KcFWb7Y1Z5NdCgwQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 789611F0089F;
	Thu,  5 Nov 2026 23:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793921696;
	bh=uW24Oo6SzxhmQfdFBJWhZnZ3z5QiPA441Ft/BalVdAE=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=UzgDizeQYbDUaC3v4t2iVebuTaQGdRjO/KFU4nH/F7naRQgpDUhML41q/rFt6s4bc
	 +S3lvegkxz6sCDTIG7Ptks+ge3+Rqid0Y648Vbay2baW7jZJM3iuffQ1iyX2ozWhRR
	 5wkn1qp/GY0oEdXclb116u+X8bvGfGLkPaUgwhEGZwbXaR3D14nwrAfcuqy7W5yrUg
	 5G9odG9u6SFkiCxJ+5A0syXeWrQjJ6SYULLgAQaNo2pTvVHzFAZtt842myaHyJYZfh
	 bB+g4iEpIt+m0+TqwOxHkep2p0kPVAU5W4OaV2yGkRwleCWoV8c9sftzbAztbCUAAb
	 2bu8V+TwXHe3w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CDEF645AEA;
	Thu,  5 Nov 2026 23:34:54 +0000 (UTC)
From: Xuheng Li via B4 Relay <devnull+xuheng.cs.columbia.edu@kernel.org>
Date: Thu, 05 Nov 2026 23:34:55 +0000
Subject: [PATCH RFC] KVM: arm64: Document that overlapping MEM_SHARE and
 MEM_UNSHARE are unordered
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261105-mem-share-unshare-v1-1-e4c7d12d5d1d@cs.columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQwNT3dzUXN3ijMSiVN3SPAhtYWSSbGSWbJScYpCkBNRXUJSallkBNjN
 aKcjNWSm2thYALP9kbWgAAAA=
X-Change-ID: 20261105-mem-share-unshare-824c26c2cd0b
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Xuheng Li <xuheng@cs.columbia.edu>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793921694; l=3950;
 i=xuheng@cs.columbia.edu; s=20261028; h=from:subject:message-id;
 bh=OzLNUOC4vto8JqdWrzx35j81FrnSzjGjA2GXE09YggQ=;
 b=HUDjW/ZmysBcCBXniSKFPhnOhTavoITcJ1jjduOTg6SJw1V4bsVs6djzi+v4ELA5KYPjC9do7
 QBWylx+J0kMAZ4tYY1lgRngualFHsjiqY6MtYKLtE3nDpZwes4PjOHQ
X-Developer-Key: i=xuheng@cs.columbia.edu; a=ed25519;
 pk=L1HVV+goqxYmEMO/OXakL6uf9isSpgk2QrLlFqyZ2Qs=
X-Endpoint-Received: by B4 Relay for xuheng@cs.columbia.edu/20261028 with
 auth_id=1349
X-Original-From: Xuheng Li <xuheng@cs.columbia.edu>
Reply-To: xuheng@cs.columbia.edu
Content-Transfer-Encoding: 7bit

From: Xuheng Li <xuheng@cs.columbia.edu>

The pKVM guest interface does not say what happens when a protected
guest issues MEM_SHARE and MEM_UNSHARE for the same page concurrently,
for example on two vCPUs.  The two calls are not ordered: a MEM_SHARE
that has not returned yet may take effect after a MEM_UNSHARE of the
same page has returned, and leave the page shared although the vCPU
that unshared it saw SUCCESS.

  vCPU A                         vCPU B
  ------                         ------
  MEM_SHARE(P) issued ...
                                 MEM_SHARE(P)    -> SUCCESS
                                 MEM_UNSHARE(P)  -> SUCCESS
                                 write private data to P
  ... MEM_SHARE(P) takes effect  -> SUCCESS: P is shared again

How long a share can stay pending is up to the host.  When the page is
not yet mapped in the guest's stage-2, pkvm_memshare_call() turns the
call into a data abort for the host (__pkvm_memshare_page_req()),
rewinds the guest's PC and exits; the share is performed from scratch
only when the host runs the vCPU again, with no record of the suspended
call and no lock held across it.  So the host can make vCPU A's share
complete after vCPU B's unshare, and read what B wrote to P.

Document that such calls are unordered, so that a guest knows it must
wait for all its shares of a region to return before treating the
region as private.

Signed-off-by: Xuheng Li <xuheng@cs.columbia.edu>
---
We noticed this while studying pKVM's guest memory-sharing interface as
part of our research project, and are not sure whether documenting it is
the right answer.

A guest racing MEM_SHARE and MEM_UNSHARE of the same page on two vCPUs
is arguably asking for trouble, and Linux guests don't do it today.  But
nothing in the interface tells a guest when a page is private again,
and because a share of an unmapped page is suspended until the host
runs the vCPU again, the host controls how long the window stays open.
The alternative to this documentation change would be to record a
suspended MEM_SHARE (for example in the hyp vCPU) so that a later
MEM_UNSHARE of the same page cancels it, or to fail the unshare while a
share of that page is pending.  We'd be happy to work on either if you
prefer a code change.
---
 Documentation/virt/kvm/arm/hypercalls.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
index 7400a89aa..ad7082da1 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -99,6 +99,16 @@ Revoke access permission from the KVM host to a memory region previously shared
 with ``ARM_SMCCC_KVM_FUNC_MEM_SHARE``. The size of the region is equal to the
 memory protection granule advertised by ``ARM_SMCCC_KVM_FUNC_HYP_MEMINFO``.
 
+Calls to ``ARM_SMCCC_KVM_FUNC_MEM_SHARE`` and ``ARM_SMCCC_KVM_FUNC_MEM_UNSHARE``
+for the same region that overlap in time, for example on different vCPUs, are
+not ordered with respect to each other: a share that has not yet returned may
+take effect after an unshare of the region has returned, leaving the region
+shared. A share of a region that is not yet mapped is restarted after the host
+has mapped it, so such a share can remain pending for as long as the host
+delays the vCPU. A guest must therefore not treat a region as private again
+until every ``ARM_SMCCC_KVM_FUNC_MEM_SHARE`` it issued for the region has
+returned.
+
 +---------------------+-------------------------------------------------------------+
 | Presence:           | Optional; pKVM protected guests only.                       |
 +---------------------+-------------------------------------------------------------+

---
base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
change-id: 20261105-mem-share-unshare-824c26c2cd0b

Best regards,
-- 
Xuheng Li <xuheng@cs.columbia.edu>


