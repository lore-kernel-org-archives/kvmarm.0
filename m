Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59F03EA94
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 09:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708507699; cv=none; b=EBquhtr87DUsFwOeDN/F7Ai5LkgerddwRfR5hyqDws9xNWuu7kOtL8yvf7+ijrWpEk7BnpbIt57P/NyioXonfPRPM8/3OIbdxzRv0bDXvC/Vo7+eMHQSH7nVTb2wJIMkE5tri4bjw6cHu5PqeX14wQi3CvvXI7NjJ78R86Oanro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708507699; c=relaxed/simple;
	bh=6kW69nUVg/Rxfj+xdEAgitjnNj9KPRfyvIFkVHS94Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lyQUbyAjxr/L6vODGAjhmsrjefJQvYJOMtPzN5sxgQ5lu0lh8DGHuc6elWB5aDhuO1xxybJYsQWIjfG40QGzFQ+5NSBm64VLI4HWfeRwvVBPa0Q0t9rTU8aXdIg3Qyf40aX6wis/neZ0n1SOqk3+Sy6jcXH+HyPfR4yphGQs8QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xnY0iWHD; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xnY0iWHD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708507693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TK+ImS5prwZeVBjxZHX1cX7QBywn/XXQCYNS6zg7Ous=;
	b=xnY0iWHDzNxyKyCoF3t6vmepezpK53BOWhzPtPeIArf3EI/gWOGLSHuzX2O3MnGvx0y7kv
	Fn0Y9mXHf6ewbh9aPs4Q7cDudGss4JEtPiINbtHCK7SOi8KBlyMbL9VxLEzvQpT4rCRvuG
	HAv7c6NsfrHFwN+rM189+p6M1CoxPXo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: vgic-its: Fixes for 6.8
Date: Wed, 21 Feb 2024 09:27:30 +0000
Message-ID: <20240221092732.4126848-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Spotted a couple issues in the way KVM's ITS emulation handles intids
returned from vgic_copy_lpi_list().

Marc, I'd like to get these in ASAP, ideally as fixes for 6.8.

Oliver Upton (2):
  KVM: arm64: vgic-its: Test for valid IRQ in
    its_sync_lpi_pending_table()
  KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler

 arch/arm64/kvm/vgic/vgic-its.c | 5 +++++
 1 file changed, 5 insertions(+)


base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.44.0.rc0.258.g7320e95886-goog

