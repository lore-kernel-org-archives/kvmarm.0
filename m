Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6E71BC09A
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155283; cv=none; b=eKGXgG0fmUO7QGLrNHgVNkzIE4sbas99PiuSANT+OMRwDkL0J8YfK+6NFD9/77fBoqfhDiKnLjiCYWlk7ttgo1LUQajU7+6y2IjRSL8odZSK2VccWZF3DgkhP+qlsCgomT1CLTIBgx8MPgMDDRzjfiD/uW56yBDXJTlANlRiPDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155283; c=relaxed/simple;
	bh=AMxR5ZSQxPzg55A/d06ZNoezPQDhKj5nrMW5f/fdjoA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eOEmvpxK9n49oLIGvDlRph30KbDgdYh3Un39FEhrkoPlLAECTPt9qo2c4ClYc46o4wzGHO4TOlOY4okwyKsa9sSdgik+pyMajDVui1N5YXnK5SR+oxuXMDr/nadwglFZSv8Fjd9RSOQM+OSsCXYsRTNKfe0KHBXZM3n9AE7MwjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D828hQ75; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D828hQ75"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740155277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nvihCTLUnpjmg13KE8NiIArlIRl2NHcMe9sLvn5Y8Zc=;
	b=D828hQ75x7LcOdaHJUuv76LZ+nhQ8J8i5aSAy56h5icG2a3z371jSsXKTo/xvKiOMfb03n
	+n5E3c5bSCajtQAXd17J+nj4FAGLlOTFGxjBu1nKXL1xxRFVF3WoIyo/cEpDFsrYEqfKlV
	O/MyDN77kIR7K5XqOhTjQ58Vd911NTI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	atishp@rivosinc.com,
	cleger@rivosinc.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 0/2] riscv: Run with other QEMU models
Date: Fri, 21 Feb 2025 17:27:54 +0100
Message-ID: <20250221162753.126290-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Provide a couple patches allowing a QEMU machine model other than 'virt'
to be used. We just need to be able to override 'virt' in the command
line and it's also nice to be able to specify a different UART address
for any early (pre DT parsing) outputs. 

Andrew Jones (2):
  configure: Allow earlycon for all architectures
  riscv: Introduce MACHINE_OVERRIDE

 configure | 88 +++++++++++++++++++++++++++----------------------------
 riscv/run |  6 ++--
 2 files changed, 47 insertions(+), 47 deletions(-)

-- 
2.48.1

