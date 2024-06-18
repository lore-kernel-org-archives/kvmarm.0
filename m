Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2751A4DA08
	for <kvmarm@lists.linux.dev>; Tue, 18 Jun 2024 06:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718692705; cv=none; b=DKLK5fAbDIpKGtvtOezSoalY5CH5OansANgXf8AWz/3DKzv8gS4JKlVuQ+/iYFCXFICe2JZ8jLAZpOJJaXOs+eCH5m3rGYIuS3+dwtNUdYq4O8aqZPb2ajMH9pyuGTWD5v28VUmkln6QYZ5EkYUf2ZYL1A/WfHqZziewadnpOnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718692705; c=relaxed/simple;
	bh=gr/1SwPJAVw0cJI2ym1vviBSRlIVKgVhxz//Y+b5Aok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eDMKVJcmG19uo8KHDgmi1RBjBRuIONNHZleBtVfuZC2AIGUDCvRdPa2MoBEyVk24MaXr89xYHKN35FzDOA0SC/v4OynYASTHHq8g7G788V2K/Wqz/3LbpYEbVuWcQ3JX+lXRCTA3SmfakHehQRUwTxstuEiTY3QHT0feXeI+Bok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g89KtPx/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g89KtPx/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718692703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=alVkXy29B6lCCtrvfQsOKPf61sX9EkJJRVUtXFrupoY=;
	b=g89KtPx/HSSR742PQI1PWvA9sJhl9PnaS43eqgd6q/vUJyST7946ZBAs4vInSOOsfsOOga
	lUttjYJmONVQWNhIkKLOk0rHiJi1RgKz0APqRvzpdhg46yk5EIO7pg2ujw62gYcJ6Xjoch
	pTth6FqZTl7Hid7BGniz1RVVVYs3ii0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-H7SqDQxRMM23ukg-vVGD_g-1; Tue,
 18 Jun 2024 02:38:19 -0400
X-MC-Unique: H7SqDQxRMM23ukg-vVGD_g-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 671A919560B0;
	Tue, 18 Jun 2024 06:38:17 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A4F811956055;
	Tue, 18 Jun 2024 06:38:14 +0000 (UTC)
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
Subject: [PATCH v2 1/2] KVM: arm64: Allow userspace to change ID_AA64PFR1_EL1
Date: Tue, 18 Jun 2024 02:38:06 -0400
Message-Id: <20240618063808.1040085-2-shahuang@redhat.com>
In-Reply-To: <20240618063808.1040085-1-shahuang@redhat.com>
References: <20240618063808.1040085-1-shahuang@redhat.com>
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

  - No changes to features not virtualized by KVM (MPAM_frac, RAS_frac)
---
 arch/arm64/kvm/sys_regs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b45a15d068..bead81867bce 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2306,7 +2306,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_GIC |
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
-	ID_SANITISED(ID_AA64PFR1_EL1),
+	ID_WRITABLE(ID_AA64PFR1_EL1, ~(ID_AA64PFR1_EL1_RAS_frac |
+				       ID_AA64PFR1_EL1_MPAM_frac)),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
-- 
2.40.1

