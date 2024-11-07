Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0102B1D79BB
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 09:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972425; cv=none; b=miHrXaK5/zdfkLhUuJYbCKwOTcyjbKWygiyC1/kS4+LJxxVJty7PaJocApshQEJYdJ9vQztKLLf7BxXUGSX7hfhuIBzsIN7On9ARaCuoj3UXiUTVJL3ftaRN8LWL6dR79pBD6XuL6uAEacU4K1cIwuPjiVRY31kMHPy/vIlD31o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972425; c=relaxed/simple;
	bh=cBg1qqMZy09oDzfSRdllAKvEmmg2QeJtF/7tXt+wK1Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qGRD34HmU/VwvTg0YhoHjzfDbZ8esED8hreE6F4yFrqxCYMWzef1QF4Rdmkhjz9HZvMmdKdL6sVuqFw4Ih4WERZ5xv6m2X5NshdRuHdJTBgXljuHN+DqF2LER2MuhZ5O1gXqfo7pENjd/W9/vbNfcNC46TwTidbT1yTX1ymIQ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ocsb9I3y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ocsb9I3y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730972423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KtsnR0uVveSGf9j1BUUQ1tqA3+oQh/kCsttRmTjgonY=;
	b=Ocsb9I3y2uw+WVeYyP+R8SG+3Zg+jrtHPdNvoITok9wE9Pgw82VsLbvwcQNKquBx0ek0gI
	PRUVr4aRoCDTUCRiU00rooAvccbOUOBSLV3w0FK+Rde+mKZI1k+gvU1Nu+rEfO7kulh9DB
	4lHiGkOcrAxFibp4yDJGvZdTVvjUmHI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-Sbhb7S26Md2r_BCz682lZg-1; Thu,
 07 Nov 2024 04:40:21 -0500
X-MC-Unique: Sbhb7S26Md2r_BCz682lZg-1
X-Mimecast-MFC-AGG-ID: Sbhb7S26Md2r_BCz682lZg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D69C51979043;
	Thu,  7 Nov 2024 09:40:10 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.192.86])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 050EA1956054;
	Thu,  7 Nov 2024 09:40:05 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	broonie@kernel.org,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	joey.gouly@arm.com,
	oliver.upton@linux.dev,
	shuah@kernel.org,
	pbonzini@redhat.com
Subject: [PATCH 0/3] KVM: arm64: Handle KVM_REQ_VM_DEAD in vgic_init test
Date: Thu,  7 Nov 2024 10:38:47 +0100
Message-ID: <20241107094000.70705-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Mark reported that df5fd75ee305 ("KVM: arm64: Don't eagerly
teardown the vgic on init error") causes vgic_init test
assertion failure. This is due to the fact that now an
incomplete vgic setup causes a KVM_REQ_VM_DEAD request to
be sent. vgic_init test checks such kind of incomplete setups.
As a consequence some KVM IOCTL's fail on the clean up path
(kvm_vm_free) and cause assertion failures in the test.

This series fixes that by checking the VM state and avoid to
call KVM IOCTL's after the occcurence of such failure.

Best regards

Eric

This series can be found at:
https://github.com/eauger/linux/tree/vgic_init_dead_v1

Eric Auger (3):
  KVM: selftests: Introduce vm_dead()
  KVM: selftests: Introduce kvm_vm_dead_free
  KVM: selftests: Handle dead VM in vgic_init test

 .../testing/selftests/kvm/aarch64/vgic_init.c | 41 +++++++++++--------
 .../testing/selftests/kvm/include/kvm_util.h  | 28 +++++++++----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 25 ++++++++---
 3 files changed, 62 insertions(+), 32 deletions(-)

-- 
2.41.0

