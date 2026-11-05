Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793919590;
	b=yu2xsP3TO0HQXpdmIsZ99DmvxYJ3tTgIf8v0d19uZGIdTzBnprrXTGNxBRpiYUPb986Q
	 VIjDAafdJH6nGEn7E3Nmg50LSHgXiTaS0PWU6IRanrs6zBEoKMH13eC+yilRav47BWJqj
	 BRJlqm8vGEl/N8D5e9Pfbno82rJQI09cxJh7LQ+S0nCv5IZ5A5axf/jJnJkIH4fc8Og1s
	 SuEBG2M1o5ePjckmdA8HlU/0Yv3efr1boeTb4TBdsxevY6PmbsackMXVYbzR08TRg45m7
	 AHrpEqI6pNpPvPPUKwVyOQuLcTj6LifnYXNeBendWsMOKd2BmYWFcHareGhnldpJkrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793919590;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=clOx71cOsA26RUdAeVKpCY0AdtjlbFGk/TTkJ7LEcnk=;
	b=OgZT+QL9OHO7C/JxeEzDrUP+kroQ2kHRSGY7OK1tkXcnV6rtnaGKEQOliosZfi0XIsHz
	 X+m5rdTaNlN+RlHcWTijhcu7PC1ljDevE2WbweVvwLvc34ckPb6xyy4cJJuOE0A3iZr8P
	 Dd+HmKk850fe2DL358vo+TxzW+B76s7Onm21ykc2hPy7aYbrAheq/e5lN7fCQWpGacU6Y
	 UThNmX0VRCY6gn9oWUS0M3n+p4t4Fky2kWZBe5rOQaxYFV941hZZI31cNTnSTPcLToAgj
	 hkxUYuqkyyqzWCxsnbUcdQbizfIZwtn2ofWinyrhbreBo0Pv/8pvdfQPYd2DpP9RiOg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=meOAyAez;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5320606A31B;
	Thu,  5 Nov 2026 22:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=meOAyAez
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793919589;
	b=R2S0E9Iq+vIORcZmlBkeeAUqgsrIod7bzg94Ojw3Vrul79CZn37Z4Ri6IRDDQJ4mW+fD
	 /xsWMPsuuy5XhXZ4/R4xoZYJBKXsoywD9hNiw1j37woUtBFD3x2l3g5SfgFpiE/oiDAcu
	 qMW8dqyB/ur5OW/jKJNtoNNKsQRdEtgyqqO0empAY7UMpx07MW/32JJlAEDzdRNxq93tr
	 VFXoYQB3FJZLkPIpJgZwWFDmea4Sya2z1/6ckthN1bhkxnmy6viFDWQw1BjP7ERNeUrYw
	 rnZe2UsxETOknoMIU9g9jV2ViN10Al6bfayIP5m73ULZuHxsLTL9WUj1n5ofC/NLfeQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793919589;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=clOx71cOsA26RUdAeVKpCY0AdtjlbFGk/TTkJ7LEcnk=;
	b=CajpFD5xP5UdeIOltXmOUAQI4n4cnoBkETgxCjhYF5EQ7YkFd02OTfBpu5hn9dZ6nJpM
	 36arLfd10/Cs00mG3YSfq8aYIS4RjQXjcU9DmLmyz+XDl1eeluW7W1YtiESmkgneaZtze
	 n/Wj9DNcZl6ow5OEzR1rPuUgT3djq64trlx4bRGvpYOUyI9b6pl45GbeFhTPC1mdvuNwh
	 ES0cdsXkdkmwwnA217PFd/tBNN9IwfrGuYx44mV1IxTyb0CNrHIeVhZZzyhKxbdXW/Wdh
	 2CiQgFIKIrYroacOpc4wbh5hD+ttkGM3uXH078LlPTirbrxdiu7BKAh7cI6ZjmR/t2g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7F7C71F008A3;
	Thu,  5 Nov 2026 22:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793919589;
	bh=clOx71cOsA26RUdAeVKpCY0AdtjlbFGk/TTkJ7LEcnk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=meOAyAezF4UnXUQ8FX/tw7PM1C0pMN5pu/804Yj00OYsGJioM+yrM1YiMhIvOoyW1
	 TC0RV5RUxDnjLcCv1u0D46aevoVe4W8yrVS5fYW5yMePCo1cRBT26uQDjEzVIjcgw8
	 i2G54oUHf33CLldExJNNYmuvDFP1SUuArrnCCdULgE/gLxT/6CsnF8OCmFkA2FTBu7
	 u78r10nG4WBoo57mO7AXohNGfVA1mhoYQv0/OA+6X3FPsYHT2QehE/+p5TOZIs9EFo
	 cGGmkhj1aKsbD1XRnknXcIOznNz3aMr9pcucWGp3z47KOSIUIM74HKWOk+kmz0XSGp
	 f5RxRAaqLJrOA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0A3D545ADB;
	Thu,  5 Nov 2026 22:59:48 +0000 (UTC)
From: Xuheng Li via B4 Relay <devnull+xuheng.cs.columbia.edu@kernel.org>
Date: Thu, 05 Nov 2026 22:59:50 +0000
Subject: [PATCH v2 3/3] KVM: arm64: Don't replace a valid hyp block mapping
 with a table
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
Message-Id: <20261105-hyp-pool-and-map-v2-3-44a6ca90190b@cs.columbia.edu>
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
In-Reply-To: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Xuheng Li <xuheng@cs.columbia.edu>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793919587; l=1509;
 i=xuheng@cs.columbia.edu; s=20261028; h=from:subject:message-id;
 bh=UqwLIs4gUAaU1DFo5IEMy2L+DohqOBeFqpV1fxyeXnM=;
 b=RGzjFUFx7mvUIxn1cSt9bemQ3coav41Jf/AuM4uYqwKDJjEzN3YdwgHqcNpkqvnnDS+kutDeY
 JJhDKLlWAyND6RJDqKJZlv2eRaJwba8TAQr8lXVDGdwnBf1j3Tf4wMi
X-Developer-Key: i=xuheng@cs.columbia.edu; a=ed25519;
 pk=L1HVV+goqxYmEMO/OXakL6uf9isSpgk2QrLlFqyZ2Qs=
X-Endpoint-Received: by B4 Relay for xuheng@cs.columbia.edu/20261028 with
 auth_id=1349
X-Original-From: Xuheng Li <xuheng@cs.columbia.edu>
Reply-To: xuheng@cs.columbia.edu
Content-Transfer-Encoding: 7bit

From: Xuheng Li <xuheng@cs.columbia.edu>

When kvm_pgtable_hyp_map() is asked to map part of a range that a valid
block mapping already covers, hyp_map_walker_try_leaf() declines, as the
request cannot be a leaf at the block's level.  hyp_map_walker() then
allocates a zeroed table and stores it over the valid block entry.  The
walk descends into the new table and maps the requested pages, but the
rest of the block is now unmapped, and the valid block was replaced
without break-before-make.

No in-tree caller maps into an existing hyp block mapping today, so this
cannot be triggered in mainline.  Fail such a request with -EEXIST
instead, so that a future caller gets an error rather than silently
losing the rest of the block.

Signed-off-by: Xuheng Li <xuheng@cs.columbia.edu>
---
 arch/arm64/kvm/hyp/pgtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c83837b1..4c731b101 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -434,6 +434,13 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (WARN_ON(ctx->level == KVM_PGTABLE_LAST_LEVEL))
 		return -EINVAL;
 
+	/*
+	 * Replacing a valid block with a table would need break-before-make,
+	 * and the new table would leave the rest of the block unmapped.
+	 */
+	if (WARN_ON(kvm_pte_valid(ctx->old)))
+		return -EEXIST;
+
 	childp = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
 	if (!childp)
 		return -ENOMEM;

-- 
2.53.0


