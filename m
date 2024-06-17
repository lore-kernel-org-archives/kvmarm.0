Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04CC190078
	for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 07:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718610714; cv=none; b=LD0PF/zRo6l9HnSbDG7D6BMcx4Go0Z3lA1UgvkVE/jGuekCoSlLHtsotRNgM6hbjKGq/WirinrQnALxlXVj8/9M6x0wZd5pzomuuus8U6LDtgk95bGPixR1qfSvwYSbrgp4Ro5x6u/YD67dsiDfc/hNzAdbO+WmAt1OOWnZxKcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718610714; c=relaxed/simple;
	bh=sy/XSptWOIJGXycNJbzclX2yIvmazhUpt9sbtRhpmBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cWjZrL7DMJ4/GN2CS3/C5kc575nwmISWoW56XVmG8LGGTeQzoXc5qU1fVef1ws8NqqZIRFnVWYqMlJgGpR9ko61dVGPc/aHsNIyvsL5AxHxjXwxjLVaXpGRVvDOUazQUQFIHBWLf4+g9hrjQ+H0XvD+vbOSp3ZeMdsQ7UT4bhPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lem76iZ+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lem76iZ+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718610710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KPXmcpazuVrMqUJPORzGFpRReNsdKA0hgm49aNQmAl8=;
	b=Lem76iZ+384nQyv11YVlpgDS+HJ2ZB39lGpvY5mpv3TjuJNZSvVRE93zmIQzWntz1+UyDD
	TfSICQobod+po5X9HP8U0NKy/7Ux2lzGlDIgT2xSDa+wjMXxrVNjEDngR1+MaCsm1xh5TR
	u08yZ7q7DZBw3xkEKWKufJBaZnVhq4I=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-R6eXFVDiPGqWuOClDLqc0Q-1; Mon,
 17 Jun 2024 03:51:45 -0400
X-MC-Unique: R6eXFVDiPGqWuOClDLqc0Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50E0F19560A1;
	Mon, 17 Jun 2024 07:51:43 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5F72919560AB;
	Mon, 17 Jun 2024 07:51:41 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] KVM: arm64: Allow BT field in ID_AA64PFR1_EL1 writable
Date: Mon, 17 Jun 2024 03:51:30 -0400
Message-Id: <20240617075131.1006173-2-shahuang@redhat.com>
In-Reply-To: <20240617075131.1006173-1-shahuang@redhat.com>
References: <20240617075131.1006173-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

When migrating between some of the ARM machines, the BT field value in
ID_AA64PFR1_EL1 register is different and not writable. This causes
migration failed.

The BT field means Branch Target Identification mechanism support in
AArch64 state. The value 0 means BT is not implemented, the value 1
means BT is implemented.

Here is an example of the migration if the BT value is different:
* On Migration Src, the BT value is 0.
* On Migration Dst, the BT value is 1.

As it defined in the ftr_id_aa64dfr0, the samller value is safe. So if
we make the BT field writable, on the Migration Dst the BT field will
be overrided with value 0.
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9f4f387155f..958e4d251535 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2292,7 +2292,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_GIC |
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
-	ID_SANITISED(ID_AA64PFR1_EL1),
+	ID_WRITABLE(ID_AA64PFR1_EL1, ID_AA64PFR1_EL1_BT),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
-- 
2.40.1

