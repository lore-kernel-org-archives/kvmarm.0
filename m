Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8750E3C22
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 03:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689736772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=khu8dsP1eNtDOWLTOwMXhcur87DLm12aw9cZwTUOwUM=;
	b=d3rRWsLvTn83waaqM+VFGDCR58pgXmmr+znGij0EbMByUxyxe/GxYQcukZ0eEOfIoqMUwU
	dQAgctktVH8vYryhsWQ3DP0GsIKCU6Vda9EbFtl1mBpsJjVvvWkmcLIwvBwrNMCvCPFTyL
	H5zvHkS12LN64oQLevkU9dxcNDNfIFQ=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-RAjSCbZIPrGg3qdaq6QUbg-1; Tue, 18 Jul 2023 23:19:28 -0400
X-MC-Unique: RAjSCbZIPrGg3qdaq6QUbg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 125043804504;
	Wed, 19 Jul 2023 03:19:28 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB1104CD0F8;
	Wed, 19 Jul 2023 03:19:27 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: andrew.jones@linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 0/2] arm64: Define name for the original RES1 bit but now functinal bit
Date: Tue, 18 Jul 2023 23:19:24 -0400
Message-Id: <20230719031926.752931-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10

According the talk[1], because the architecture get updated, what used to be a
RES1 bit becomes a functinal bit. So we can define the name for these bits, this
also increase the readability.

[1] lore.kernel.org/ZLZQ6r4-9mVdg4Ry@monolith.localdoman

Shaoqin Huang (2):
  arm64: Replace the SCTLR_EL1 filed definition by _BITUL()
  arm64: Define name for the bits used in SCTLR_EL1_RES1

 lib/arm64/asm/sysreg.h | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

-- 
2.39.1

