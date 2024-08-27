Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6A31FAA
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718181; cv=none; b=uo7uCQwwG+BRzbjqzXdylT+JSU+q1xjoHptCBqAq8mKF3TO/62HDmQXVwvdnP6EsjhPBca1soTUv+0ljF8CCiOuhLPlLVljIcA/d19Ai3cdUKsqnOHietb+iS1KsvsdcNk1t3yH1tBEASKLRCU4B/iK6c+hA14noaxpLFi8BD0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718181; c=relaxed/simple;
	bh=HAhg1hxnwZ1EbJrF+SUlYe89RRnc5LlmdaDCXeczO2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fi1tIkxTtNcQ6bMXELvdc37dTzLIpWbGSfjdYwtjyQnlSKrb7F2cPWnRo5WsleRgPwwAvEgG1BBfWgOX/MwHHWM1s719M9FlEZWqmvxCAzZV1ZNhp3IpddkweRiWi2BDnaMn4YDjrGbf2o0wHjeMlbbsSXxbjRlRRh6fhgXYBYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NVcY+DCK; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NVcY+DCK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iIw8ugyIYNYKBm45FitK3B1h/xL/COAKwRyJiompqQM=;
	b=NVcY+DCK9Ho1ZeD+F2mEjD1WKh6IsdfvNIQvY9YOZXpti9FUYo4gBv27/9WWdkMcqj3EGR
	HCNIBy/uI2tQn1kXi8CFvz+Zd1Py/0fkqPW9eMf6Pds4ppSqSbGrSL9AGrLf2NC1DNE+LB
	3sFDk8TQDOoDXlrke66p65ov6PHGQOA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 06/12] KVM: arm64: nv: Honor MDCR_EL2.{TPM, TPMCR} in Host EL0
Date: Tue, 27 Aug 2024 00:22:29 +0000
Message-ID: <20240827002235.1753237-7-oliver.upton@linux.dev>
In-Reply-To: <20240827002235.1753237-1-oliver.upton@linux.dev>
References: <20240827002235.1753237-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

TPM and TPMCR trap bits also affect Host EL0. How fun.

Mark these two trap bits as such and take advantage of the new
infrastructure for dealing w/ EL0 traps.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 4548725a0899..41839ad85bcf 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -296,13 +296,15 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TPMCR,
 		.mask		= MDCR_EL2_TPMCR,
-		.behaviour	= BEHAVE_FORWARD_RW,
+		.behaviour	= BEHAVE_FORWARD_RW |
+				  BEHAVE_IN_HOST_EL0,
 	},
 	[CGT_MDCR_TPM] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TPM,
 		.mask		= MDCR_EL2_TPM,
-		.behaviour	= BEHAVE_FORWARD_RW,
+		.behaviour	= BEHAVE_FORWARD_RW |
+				  BEHAVE_IN_HOST_EL0,
 	},
 	[CGT_MDCR_TDE] = {
 		.index		= MDCR_EL2,
-- 
2.46.0.295.g3b9ea8a38a-goog

