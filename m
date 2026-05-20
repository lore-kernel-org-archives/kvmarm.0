Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD8A36C9D5;
	Wed, 20 May 2026 08:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779267054; cv=none; b=WT9DbFRcPBL4QFo0W8GO0dVvFKrruwPS2V073QrmexGHi0duYMji+G80OjeVVdjXcf3GndSMHiYEJBd/iIdQPoTb5iB0HlCWbZzR3MV4s7kHAPYnplO97GmMJwZ1rugXjCbOLTDNPEcADbJXB2dwgX4KBABjCU//aMLxEvoEwB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779267054; c=relaxed/simple;
	bh=c5kdWl+y4beGFsESYmy3xO397Dj/KsMvn5975JH+kxw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mm01RNvzcMV5D05Dcj8CDE076wbftZjWCfR5hrBuQRMlpAGKbkMSnZ5iK0xS5or/T6ivRSpvfMJJUv0d+ke3rFJVwef5l4NJsdrZsARLkNmkobyo41Ngg7YfGjwG0h1BH890/GFeKye7gjppSBJHYsbvQybDLvuBQwchWVC/sqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lyr7vTrz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lyr7vTrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4526C1F00893;
	Wed, 20 May 2026 08:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779267053;
	bh=dUGv8oIgE91WwfwK6ezX3xvVxWVU55LwkhTCXk2cXTo=;
	h=From:To:Cc:Subject:Date;
	b=lyr7vTrzuEUPWYUQ1jyu+OJJxxIVAGUJcGTeWIUwu3vddGICaHXpzg9T3BiSnU50T
	 MtXziZRZWx/SPAc9D9F42VyHthyOkdUPnbEdaao+2R3OBi2iP0tcTcAfs3bQ474Ikn
	 Viy48D6BATML9M42plqZn1GdvEKAYSKYYDMTGY/XyjiuSP+Y6WSGo5DHzyib7g6g7x
	 c0QMunuEebH8hZTdwnD5tnJPbFe6oIIQxlHCyDFDvyjhMQaIc5v1PmKra8jdDcQk+u
	 UOPjDQQoapoIBC+yVngONgJO7ebB/H3UxH9nivfUvZ9toMLdAEbTyqSlfKXdRRxzd6
	 L23gHqJDnDclA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPcdf-00000004Hno-0fBo;
	Wed, 20 May 2026 08:50:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: nv: Reduce FP/SVE overhead on exception/exception return
Date: Wed, 20 May 2026 09:50:34 +0100
Message-ID: <20260520085036.541666-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, mark.rutland@arm.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the second version of this short series optimising away a lot
of unnecessary FPSIMD/SVE context switch with NV.

* From v1 [1]:

  - New commit message on patch #2 (Mark)

  - Additional comments and WARN_ON_ONCE() (Mark)

If nobody screams, I'll stick that into -next.

Thanks,

	M.

[1] https://lore.kernel.org/r/20260512140755.3676306-1-maz@kernel.org

Marc Zyngier (2):
  KVM: arm64: nv: Track L2 to L1 exception emulation
  KVM: arm64: nv: Don't save/restore FP register during a nested ERET or
    exception

 arch/arm64/include/asm/kvm_host.h |  3 ++-
 arch/arm64/kvm/emulate-nested.c   |  4 ++++
 arch/arm64/kvm/fpsimd.c           | 23 +++++++++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

-- 
2.47.3

