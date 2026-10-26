Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793002991;
	b=Av0KOXHGAfKGAsb/9zIh/BCcVI4Jk1MCDL68Ld3y26HONahIm95kdNRg3VEGHhpnND7x
	 QvhKJMiH8/w/lwZBkDoZSaixKCC1wNw+XzucYB0yLtgdn3pAYWaNWHRyZWjEgSl0XKeJP
	 zbRPYc6/lpZbmTXJmB1fbmUbNxhLTxZMEIM749qFpHKgYMxQo+xZlIi+o7Hi1oRqtJPa1
	 fweYicTZ15B/DvpkbJeF/ZxSPgqP/ic+ry1rW+5UaEy1lL+y7JZY9y5j50VqSHnRsQ0nr
	 NQ1f7YRC1xR8gBfqgE9sOGZkvG4at/bfzjNTtE5WMj7XlYLKJ+GCEH9XIuERw6RIAtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793002991;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=iaCdCVyt1C7egWZ6jI8Y0J3eVgASMFjDhFgq4khrhao=;
	b=l3aosQR/Gth4x3BkHziWjfYSFCgoIq5msMTnTgEocQYMlwdO8MrOi4MMtVAhZ1VtiFyz
	 GrE6X5RV8jyhXbVneFBphSR2QYvpluN1M+zgilSjuCUEVUlh3gGR2vHxYxHsqK5uaS0+H
	 6+of0BHadatrL5XamqFhcJt+BIEtJnS21+hYqg4wsG+s7+KzCsxGl68loUNhJ65JzN8oD
	 A2vC/tsscXknHC5lUJvXf2MEVtnFoXKoUrGzekz7TO9xTkfv2oFGmFnNp3qNltP3TlP+P
	 bCGEMRSlUnLw10FXApQA6WroCTPxuKOdWwQvZPzE4+aQDTWGgQaxs84Hda2jwZU3gmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D0mujMOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5675C606A31B
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 08:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D0mujMOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1496A1F031E2;
	Mon, 26 Oct 2026 08:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793002991;
	bh=iaCdCVyt1C7egWZ6jI8Y0J3eVgASMFjDhFgq4khrhao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0mujMOQvxaakhh5DiXKDIQkG60Tnho4R78TJjGDJj/hVjKK6za+eim4Yz1RQ1306
	 N0bUuIm3HpxA3AkavvniuvVNgJHF3X5tgGL1/78fVzXU49yVURcdoM7Cm+5v7TtEY9
	 Ayx5V+3duCxEXAxyPhPeQaPN482cTXsRMPMsh0YkCDbi42/uTIjqf73r6cOdF+AzaN
	 OAUdaTtO/5jdCOJdoDCuitb/5xTcCOjQ9aWojn9NYzhU87i4JDzbLLShWa9eyluGxS
	 9JRV5ZPzd/aWptPW9jrXPzqEMUSV12ALQDwwoja30ilmw8S/z+0saz0aX6aV8bZisW
	 Pr0qEeUAhilGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLFz3-00000007A40-1Ich;
	Mon, 26 Oct 2026 08:23:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 2/2] KVM: arm64: Reenable MTE tag checking on exit from guest when running VHE
Date: Mon, 26 Oct 2026 08:23:05 +0000
Message-ID: <20261026082305.2515705-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026082305.2515705-1-maz@kernel.org>
References: <20261026082305.2515705-1-maz@kernel.org>
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
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Once we're back from running a guest, it is important to set TCO to
zero so that MTE is functional again.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 4c965f9b1e1de..73c2dd61e6c69 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -193,6 +193,13 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	if (!arm64_kernel_unmapped_at_el0())
 		host_vectors = __this_cpu_read(this_cpu_vector);
 	write_sysreg(host_vectors, vbar_el1);
+
+	/*
+	 * We're now able to take MTE exceptions, make sure the VBAR_EL2 is
+	 * set to the correct value.
+	 */
+	if (mte_disable_tco_entry(current))
+		isb();
 }
 NOKPROBE_SYMBOL(__deactivate_traps);
 
-- 
2.47.3

