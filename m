Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3111547E7
	for <kvmarm@lists.linux.dev>; Wed,  1 Oct 2025 02:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759287231; cv=none; b=bcGeTMnDGooxqzQGF9vUzgOKLig66IAi33bAFq5l7e71ZG8p8mnP3IOs7bJLtcTitzwBneP659rJUGEzxnCddUIpA79nB7sPCVNIh6kSZ8XGS0u766dycG6RRF/GZplPjzVw4dcySn0haVTUt6/n0CyLLKetB1L+6faU0YO8PQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759287231; c=relaxed/simple;
	bh=KzThYHZ5eYcdF8LJVbDojnPU19X+AhFyKI8FAJPoTrs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GbtkSx13pEtLp976lP/Chz6TmU4CLp7k9HhwllVT6d2KzfRW3aqW9ila4+MGqBZ9tTrlBWabjj3S0U4aq57x+8SUnOqD01uL9mCgrBX8xRDFY4qUEMhfw3Rkm21tng+UIhOMN5LnZP5HC5Q4nqk1EDrEgNgDz9vF3Xjm16Gy1wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i/s5jkHr; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i/s5jkHr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759287226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vDxUkFE6RsCFHlrGYN+iMQpt+iwaOr4BU0dAo2nVaY0=;
	b=i/s5jkHrVLRon1PmpztO67zgXqTkByBTxs1I0TymkQtmZwItm4apmkMGQefxG/6wIf5cIT
	NsJm4EqzEtnOWDcd8F169g833Ymq9hR2MIzZxD6Zjw4c+wAT65yOBBG7KlvMhHx/oMP2g1
	3elhv0jfyeBLFwoWMeMH2LIOBCVvXqE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2] KVM: arm64: Document vCPU event ioctls as requiring init'ed vCPU
Date: Tue, 30 Sep 2025 16:36:20 -0700
Message-Id: <20250930233620.124607-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM rejects calls to KVM_{GET,SET}_VCPU_EVENTS for an uninitialized vCPU
as of commit cc96679f3c03 ("KVM: arm64: Prevent access to vCPU events
before init"). Update the corresponding API documentation.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

v1 -> v2:
 - I can't read.

 Documentation/virt/kvm/api.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6aa40ee05a4a..15235a465879 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1229,6 +1229,9 @@ It is not possible to read back a pending external abort (injected via
 KVM_SET_VCPU_EVENTS or otherwise) because such an exception is always delivered
 directly to the virtual CPU).
 
+Calling this ioctl on a vCPU that hasn't been initialized will return
+-ENOEXEC.
+
 ::
 
   struct kvm_vcpu_events {
@@ -1309,6 +1312,8 @@ exceptions by manipulating individual registers using the KVM_SET_ONE_REG API.
 
 See KVM_GET_VCPU_EVENTS for the data structure.
 
+Calling this ioctl on a vCPU that hasn't been initialized will return
+-ENOEXEC.
 
 4.33 KVM_GET_DEBUGREGS
 ----------------------

base-commit: 10fd0285305d0b48e8a3bf15d4f17fc4f3d68cb6
-- 
2.39.5

