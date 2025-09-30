Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7655FFC1D
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 22:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759270536; cv=none; b=X7YZM1Jj0TNTsHcto9iphDTGcqaR+Y1Cig199AuiGP9o4CbhZcRq/J3GV/IEeTZgpKeESw2qvOY6YlTpo9vwmJzXGG2sDER8A8+HrftTvUcN33o64rtrFbA8AjM0QNvCYtnspJlGPzZkySWKZC7G5+16LVg4jy3YYYzkjKE3nLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759270536; c=relaxed/simple;
	bh=td1TJ6OdjmuY0GwZC1+NXyiysQWi5/CtkBj7FJrIYNs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VujfgNPHQ9wLCdPv8fl5MvkyZ+2LyecMZ8GSSmTNJfDxQPMDiqc3WSvKYjCAQWbgFhgxiesamis5pu75gkCr9AFtDPM5D+mlyeZMb7ewx7+EBOAeMWRDPCKNHrryc263UZBVFez/z0bhISDQmRL/ffth+cx4bZdsXT8CT5c70ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YjWdK7K3; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YjWdK7K3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759270530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=64+AzQnMnMqSMFNB2zu0sJZzW5bPzKUvdFCacHUYypU=;
	b=YjWdK7K3oVqfwERK2pqJyg8zVqzPT8k9nD3wO7HGs+7wz7wFUBoMFpid1PCYcp6QC0BbUi
	Tbs2YbB3VpxPQwBpg1COHUITSKd+Bz/tdVuKorHGg6TOju0kYljNNH4JzpkoZEMAg1WEu0
	7g2bOnW7/oIR7hXc2Fko5mvqjeWJ/1I=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Document vCPU event ioctls as requiring init'ed vCPU
Date: Tue, 30 Sep 2025 15:15:21 -0700
Message-Id: <20250930221521.123127-1-oliver.upton@linux.dev>
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
 Documentation/virt/kvm/api.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6aa40ee05a4a..057a9c9336d6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1229,6 +1229,8 @@ It is not possible to read back a pending external abort (injected via
 KVM_SET_VCPU_EVENTS or otherwise) because such an exception is always delivered
 directly to the virtual CPU).
 
+Calling this ioctl on a vCPU that hasn't been initialized will return -ENXIO.
+
 ::
 
   struct kvm_vcpu_events {
@@ -1309,6 +1311,7 @@ exceptions by manipulating individual registers using the KVM_SET_ONE_REG API.
 
 See KVM_GET_VCPU_EVENTS for the data structure.
 
+Calling this ioctl on a vCPU that hasn't been initialized will return -ENXIO.
 
 4.33 KVM_GET_DEBUGREGS
 ----------------------

base-commit: 10fd0285305d0b48e8a3bf15d4f17fc4f3d68cb6
-- 
2.39.5

