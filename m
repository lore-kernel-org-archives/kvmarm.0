Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91D47B
	for <kvmarm@lists.linux.dev>; Tue, 25 Oct 2022 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666714077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5KspUNdpIMJ1oi73gHAhE34NL4Dzppd2Wwilq7mP6L8=;
	b=BlnOTPlU0PXNI6fnsuzm7pHid4Tfhm88VbN74jnpYOXytrJMKzHZ0fnqSNMs/RN+fy5t8K
	tcB5x1OFVhQZsEx8hyWVCkS1zPayQktvgGo2NtvEa4OW/6lwk+Wf+zBVwZExDst/4HP8L9
	yrPZgVzAe1mkEUYoqnO/C0ikbzsHPUE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-yzgsZNG4OMq5fO07-66Gqw-1; Tue, 25 Oct 2022 12:07:53 -0400
X-MC-Unique: yzgsZNG4OMq5fO07-66Gqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16775185A7A3;
	Tue, 25 Oct 2022 16:07:53 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.193.32])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A9405410B235;
	Tue, 25 Oct 2022 16:07:37 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
Date: Tue, 25 Oct 2022 18:07:30 +0200
Message-ID: <20221025160730.40846-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Message-ID: <20221025160730.Ypq_Tzo3fhct2J1ZJIZixH-wJE3XFzOvia80F1JfH0k@z>

KVM/arm64 development is moving to a new mailing list (see
https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
kvm-unit-tests should advertise the new list as well.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90ead214a75d..649de509a511 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -67,7 +67,8 @@ ARM
 M: Andrew Jones <andrew.jones@linux.dev>
 S: Supported
 L: kvm@vger.kernel.org
-L: kvmarm@lists.cs.columbia.edu
+L: kvmarm@lists.linux.dev
+L: kvmarm@lists.cs.columbia.edu (deprecated)
 F: arm/
 F: lib/arm/
 F: lib/arm64/
-- 
2.37.3

