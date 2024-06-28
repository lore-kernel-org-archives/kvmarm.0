Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E864D8A4
	for <kvmarm@lists.linux.dev>; Fri, 28 Jun 2024 06:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719554714; cv=none; b=d4HRhnxyyhZdg4Amht9NlkEaytCNq0kyEf0AW2rgYDi5iS0bOK6ztcfZikQckzmZFwG5JdpB2bzMhmAfI9ODq8hQ9DjZuRHNjYtCfzqBEuaoLUzk+ECYKcqdbUwqEH8ywkgr2Ttj74Qk8O9+a70HN9Typ++6lBZre7/R2+Nm/Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719554714; c=relaxed/simple;
	bh=/pX3wzIxmrkatm6Atvy4eoQxDAwEynsnsnpazri5KBk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hHG7rR8BSawNEZLfIlgARRwQE8i+BgtmxCS2Rb/GifqxXXnx1KXfAp1w45TmfX/LHOWQsOGSvKEePWI23op2SXSXFt573yKrEOos56s3M1aC09A4m+K72YgUme9x7Yv7ccQSCDNgo/N3yOK/c/HqTfbuwnwj+3wduM2aldB3Y1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RQCyomvj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RQCyomvj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719554712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I9zn2i4ef/uuSlInb0x78J+Hjt4S8lkHLb69/zw01pU=;
	b=RQCyomvjsuzKa3zbJGtnL/SR7AkK5PDQsYaF0hLuWa1MlrlTnjDvbp+n0xCtgWJpa26T68
	HUIjaKq9T8AcaOo/21NgpPQn85wl1cKorPtYuspTvTNQ9f/eadUMzKDdB+wTGYrXfGo/3u
	S+kX0tOR0zrQ03ncxzFhKxJDCakUtVg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-85-vNQFQkwvPM233aWf-atBog-1; Fri,
 28 Jun 2024 02:05:07 -0400
X-MC-Unique: vNQFQkwvPM233aWf-atBog-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B601119560B1;
	Fri, 28 Jun 2024 06:05:05 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C26321945CB1;
	Fri, 28 Jun 2024 06:05:03 +0000 (UTC)
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
Subject: [PATCH v3 1/2] KVM: arm64: Allow userspace to change ID_AA64PFR1_EL1
Date: Fri, 28 Jun 2024 02:04:51 -0400
Message-Id: <20240628060454.1936886-2-shahuang@redhat.com>
In-Reply-To: <20240628060454.1936886-1-shahuang@redhat.com>
References: <20240628060454.1936886-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Allow userspace to change the guest-visible value of the register with
some severe limitation:

  - No changes to features not virtualized by KVM (MPAM_frac, RAS_frac,
    SME, RNDP_trap).

  - No changes to features (CSV2_frac, NMI, MTE_frac, GCS, THE, MTEX,
    DF2, PFAR) which haven't been added into the ftr_id_aa64pfr1[].
    Because the struct arm64_ftr_bits definition for each feature in the
    ftr_id_aa64pfr1[] is used by arm64_check_features. If they're not
    existing in the ftr_id_aa64pfr1[], the for loop won't check the if
    the new_val is safe for those features.
---
 arch/arm64/kvm/sys_regs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b45a15d068..159cded22357 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2306,7 +2306,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_GIC |
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
-	ID_SANITISED(ID_AA64PFR1_EL1),
+	ID_WRITABLE(ID_AA64PFR1_EL1, ID_AA64PFR1_EL1_MTE |
+				     ID_AA64PFR1_EL1_SSBS |
+				     ID_AA64PFR1_EL1_BT),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
-- 
2.40.1

