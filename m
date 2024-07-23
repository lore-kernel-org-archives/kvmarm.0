Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95E814B973
	for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 07:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721719230; cv=none; b=sQaSOqj65OqW9/7c4RZArAF7zHtTwhks1CH2LGxiBu2RBHPiCmXr0TjD5mMnftZVkq6ATBWxrNlpjJXSJgG5WISklvDvynUoIcAx/oGvk+Uowe0n0+H60LQfnNH2SPSvCiDgMVbxPDikjiecVkvy6az0R2UdbBVVR9CD/zz9H98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721719230; c=relaxed/simple;
	bh=2UtI091furSDVehGsAMVcORQG02M1Xny3fItIEC1iAM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tNWl+7v8yNXdkt9bxEAhjfHRj3SgPeGd6RpGLtJWbFjFdKgv3w0JaJpCPGt0LPizh/9IL+z2SziopumfE0CR0JszI2PVcR/3iMIMP9f7ecYikoRzzIK/6AMmCAX0y41AHQuK3HLok9NB+s1WhpZQ38jIwYmN97Cg5L2SCnnXZdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iZ564ysN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZ564ysN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721719228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98Hb6QoCOuSuNStSuOs/MMCP2mQIqPds8i/L8/Sm/UA=;
	b=iZ564ysNyaNEOOrSWjoAqSDP9ekEeKYXnIfGEWQqpRSRV+pB0Isk5njWbgBAl6kqfMaNfh
	EbQRZaRmrT9zoTYCuK2LmWN9H+Z7AAQKkR6IcbtjkynrPH+KSnbtd0Af3Uxxttps3yZvuT
	3DKlgxFJEq+iyaMAGmAD0rOIrseduo8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-548-m4PTslFHMD6sqUJnS42_EQ-1; Tue,
 23 Jul 2024 03:20:24 -0400
X-MC-Unique: m4PTslFHMD6sqUJnS42_EQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BA531955D45;
	Tue, 23 Jul 2024 07:20:22 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 21A721955F40;
	Tue, 23 Jul 2024 07:20:19 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Cc: Eric Auger <eauger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/4] KVM: arm64: Allow userspace to change ID_AA64PFR1_EL1
Date: Tue, 23 Jul 2024 03:20:02 -0400
Message-Id: <20240723072004.1470688-4-shahuang@redhat.com>
In-Reply-To: <20240723072004.1470688-1-shahuang@redhat.com>
References: <20240723072004.1470688-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Allow userspace to change the guest-visible value of the register with
different way of handling:

  - Since the RAS and MPAM is not writable in the ID_AA64PFR0_EL1
    register, RAS_frac and MPAM_frac are also not writable in the
    ID_AA64PFR1_EL1 register.

  - The MTE is controlled by a separate UAPI (KVM_CAP_ARM_MTE) with an
    internal flag (KVM_ARCH_FLAG_MTE_ENABLED).
    So it's not writable.

  - For those fields which KVM doesn't know how to handle, they are not
    exposed to the guest (being disabled in the register read accessor),
    those fields value will always be 0.
    Those fields don't have a known behavior now, so don't advertise
    them to the userspace. Thus still not writable.
    Those fields include SME, RNDR_trap, NMI, GCS, THE, DF2, PFAR,
    MTE_frac, MTEX.

  - The BT, SSBS, CSV2_frac don't introduce any new registers which KVM
    doesn't know how to handle, they can be written without ill effect.
    So let them writable.

Besides, we don't do the crosscheck in KVM about the CSV2_frac even if
it depends on the value of CSV2, it should be made sure by the VMM
instead of KVM.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4508288b9d38..0f2c2a1182cc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2314,7 +2314,19 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_GIC |
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
-	ID_SANITISED(ID_AA64PFR1_EL1),
+	ID_WRITABLE(ID_AA64PFR1_EL1, ~(ID_AA64PFR1_EL1_PFAR |
+				       ID_AA64PFR1_EL1_DF2 |
+				       ID_AA64PFR1_EL1_MTEX |
+				       ID_AA64PFR1_EL1_THE |
+				       ID_AA64PFR1_EL1_GCS |
+				       ID_AA64PFR1_EL1_MTE_frac |
+				       ID_AA64PFR1_EL1_NMI |
+				       ID_AA64PFR1_EL1_RNDR_trap |
+				       ID_AA64PFR1_EL1_SME |
+				       ID_AA64PFR1_EL1_RES0 |
+				       ID_AA64PFR1_EL1_MPAM_frac |
+				       ID_AA64PFR1_EL1_RAS_frac |
+				       ID_AA64PFR1_EL1_MTE)),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
-- 
2.40.1

