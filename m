Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F51836AEC
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 03:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721274685; cv=none; b=ex3Fgj2zY4wtbMSJueJv6gHsafOYf4HIkXKW9sVfaELQiwcuhH8ySs6WCTTlnKBRyyX4uTiu1gVhVyPkuWESj1VXoq462NigRzJwRyp59IFX2AknK7sLQ9MfTM0/tmQy8uAXFXwAqiaryldCza3I1UprgJg6hWEKGqHFRMaaC8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721274685; c=relaxed/simple;
	bh=hjUCG+q0HREzgYmR5r7WJo3qIZ6wc8Ex0QI8HfWNF5g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=scJqkn2R188LzSLqnFY27Ct4L2Wu7Y++d9nQAHw22vAxm4fQS/jjanqQO7wtB8OaVFv4vVCk9QWZvYICexhZE/JHgK6j8+m114RAuSVWymQ2+wkq6a1f0evnszvDJ/pO4bkXom/A1Ryn3HKXQeDFOivgshly1F6fhPB5sKuXB2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RaXO7dsj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RaXO7dsj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721274682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O89ColwbFbMOP9rVqtVS+t6scjVmCqG2F84LAXBK61M=;
	b=RaXO7dsj/M2uuh1o7TqnQgRa8FsnJCD17Gg+s629CeTM3HP1jwAl2dHHIXNsNVLmJdTpSr
	XnD8MlN+B4dT2sjFtteJTnxlHOPxJnLXkx6f6koq52IOq1mxqJfNbk3T0CCemyXrye61hL
	LmcNu7mvlelc+LvukYcSHEoqDH9n2vc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-WLlbco4bNGCj9RqX9v7jGA-1; Wed,
 17 Jul 2024 23:50:40 -0400
X-MC-Unique: WLlbco4bNGCj9RqX9v7jGA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 964C419560AB;
	Thu, 18 Jul 2024 03:50:38 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 699FB1955D42;
	Thu, 18 Jul 2024 03:50:36 +0000 (UTC)
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
Subject: [PATCH v4 2/3] KVM: arm64: Allow userspace to change ID_AA64PFR1_EL1
Date: Wed, 17 Jul 2024 23:50:15 -0400
Message-Id: <20240718035017.434996-3-shahuang@redhat.com>
In-Reply-To: <20240718035017.434996-1-shahuang@redhat.com>
References: <20240718035017.434996-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Allow userspace to change the guest-visible value of the register with
different way of handling:

  - Since the RAS and MPAM is not writable in the ID_AA64PFR0_EL1
    register, RAS_frac and MPAM_frac are also not writable in the
    ID_AA64PFR1_EL1 register.

  - The MTE is controlled by an internal flag (KVM_ARCH_FLAG_MTE_ENABLED),
    so it's not writable.

  - For those fields which KVM doesn't know how to handle, they have
    are not exposed to the guest (being disabled in the register read
    accessor), those fields value will always be 0. Allow those fields
    writable is fine, since the userspace can only write 0 into those
    fields. Maybe in the future KVM know how to handle some of the
    fields, then they can be written into other value.
    So let them writable.
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
 arch/arm64/kvm/sys_regs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4508288b9d38..26b38165a8be 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2314,7 +2314,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_GIC |
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
-	ID_SANITISED(ID_AA64PFR1_EL1),
+	ID_WRITABLE(ID_AA64PFR1_EL1, ~(ID_AA64PFR1_EL1_RES0 |
+				       ID_AA64PFR1_EL1_MPAM_frac |
+				       ID_AA64PFR1_EL1_RAS_frac |
+				       ID_AA64PFR1_EL1_MTE)),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
-- 
2.40.1

