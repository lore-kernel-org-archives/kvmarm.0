Return-Path: <SRS0=tVNh=FB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED1FC64E75
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 11:21:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB47A21D7F
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 11:21:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="H63Vu6qu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB47A21D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DBB84BE9D;
	Fri, 27 Nov 2020 06:21:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Etws1m1fwZFa; Fri, 27 Nov 2020 06:21:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12E284BE78;
	Fri, 27 Nov 2020 06:21:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF3CF4BE75
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 06:21:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PokVRj1Ks5Oe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2020 06:21:23 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED2B04BE77
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 06:21:22 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EAE8521973;
 Fri, 27 Nov 2020 11:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606476082;
 bh=PewcZ0rzrlxCPatqpFVI8s3T+tQgk8XqSu8BrcC/ilQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=H63Vu6qusRwErPgOfLpBLFRWoEte988yFNickgfvXC+IYjUnhqYu7DvOU2urmnqNK
 nlFK/wdYkQg1aHaZ2dWReYE/eN+BYg/v9r+vZdxIPv57goM4FM/HSaAbi6XBBwct25
 OIloVfJMIjMAvooAdKZUsIqBbdIEFPg06MnWpeOA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kiboW-00E2fR-4z; Fri, 27 Nov 2020 11:21:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/2] KVM: arm64: vgic-v3: Drop the reporting of
 GICR_TYPER.Last for userspace
Date: Fri, 27 Nov 2020 11:21:01 +0000
Message-Id: <20201127112101.658224-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201127112101.658224-1-maz@kernel.org>
References: <20201127112101.658224-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com,
 eric.auger@redhat.com, jamie@nuviainc.com, zhukeqian1@huawei.com,
 will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Jamie Iles <jamie@nuviainc.com>, stable@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Zenghui Yu <yuzenghui@huawei.com>

It was recently reported that if GICR_TYPER is accessed before the RD base
address is set, we'll suffer from the unset @rdreg dereferencing. Oops...

	gpa_t last_rdist_typer = rdreg->base + GICR_TYPER +
			(rdreg->free_index - 1) * KVM_VGIC_V3_REDIST_SIZE;

It's "expected" that users will access registers in the redistributor if
the RD has been properly configured (e.g., the RD base address is set). But
it hasn't yet been covered by the existing documentation.

Per discussion on the list [1], the reporting of the GICR_TYPER.Last bit
for userspace never actually worked. And it's difficult for us to emulate
it correctly given that userspace has the flexibility to access it any
time. Let's just drop the reporting of the Last bit for userspace for now
(userspace should have full knowledge about it anyway) and it at least
prevents kernel from panic ;-)

[1] https://lore.kernel.org/kvmarm/c20865a267e44d1e2c0d52ce4e012263@kernel.org/

Fixes: ba7b3f1275fd ("KVM: arm/arm64: Revisit Redistributor TYPER last bit computation")
Reported-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20201117151629.1738-1-yuzenghui@huawei.com
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 52d6f24f65dc..15a6c98ee92f 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -273,6 +273,23 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 	return extract_bytes(value, addr & 7, len);
 }
 
+static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
+						 gpa_t addr, unsigned int len)
+{
+	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+	int target_vcpu_id = vcpu->vcpu_id;
+	u64 value;
+
+	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
+	value |= ((target_vcpu_id & 0xffff) << 8);
+
+	if (vgic_has_its(vcpu->kvm))
+		value |= GICR_TYPER_PLPIS;
+
+	/* reporting of the Last bit is not supported for userspace */
+	return extract_bytes(value, addr & 7, len);
+}
+
 static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
 					     gpa_t addr, unsigned int len)
 {
@@ -593,8 +610,9 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
 		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
-		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_TYPER,
+		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi,
+		vgic_uaccess_read_v3r_typer, vgic_mmio_uaccess_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
