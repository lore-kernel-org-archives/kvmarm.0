Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20798184C
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 07:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690184412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VUFdjV8PorXzgyBYbzZbuwBKjrzFWv5AGRDAvUDIsRY=;
	b=YNGL7KQOZh1j3w7Koy2eN1cAlKMI2Lzde8GNd49JeD4LiykLHJiHBMWqzgnWTzZGAt0DhA
	tZ1DmfhxRVJVclCCxey9X71iXAiycVTaTA2crdTAn5MRilzgKa1M4+K2aVYzPU7ePPsRNp
	0O9/KnTIlJ7Z21WgUI5exavLqSFlyvU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-9fDtQRixNRG1-7pa52odOQ-1; Mon, 24 Jul 2023 03:40:08 -0400
X-MC-Unique: 9fDtQRixNRG1-7pa52odOQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBCBA8A31A2;
	Mon, 24 Jul 2023 07:40:07 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0D44200BA63;
	Mon, 24 Jul 2023 07:40:07 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: andrew.jones@linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/2] arm64: Define name for the original RES1 bit but now functinal bit
Date: Mon, 24 Jul 2023 03:39:46 -0400
Message-Id: <20230724073949.1297331-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4

According the talk[1], because the architecture get updated, what used to be a
RES1 bit becomes a functinal bit. So we can define the name for these bits, this
also increase the readability.

[1] lore.kernel.org/ZLZQ6r4-9mVdg4Ry@monolith.localdoman

v1:
https://lore.kernel.org/all/20230719031926.752931-1-shahuang@redhat.com/
Thanks, Eric for the suggestions:
- Rephrase the commit title in patch 1.
- Use the _BITULL().
- Delete the SCTLR_EL1_RES1 and unwind its definition into
INIT_SCTLR_EL1_MMU_OFF.

Shaoqin Huang (2):
  arm64: Use _BITULL() to define SCTLR_EL1 bit fields
  arm64: Define name for these bits used in SCTLR_EL1

 lib/arm64/asm/sysreg.h | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

-- 
2.39.1

