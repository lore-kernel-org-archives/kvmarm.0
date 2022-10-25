Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00983C04A95
	for <kvmarm@archiver.kernel.org>; Tue, 25 Oct 2022 16:08:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5905948FA4;
	Tue, 25 Oct 2022 12:08:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C5afhsC-LFr4; Tue, 25 Oct 2022 12:07:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EECE049F51;
	Tue, 25 Oct 2022 12:07:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EDE148A48
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2022 12:07:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2+IWECl34cMY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Oct 2022 12:07:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1368140BDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2022 12:07:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666714075;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=5KspUNdpIMJ1oi73gHAhE34NL4Dzppd2Wwilq7mP6L8=;
 b=NvcTC61iqpXGy2+AhQpWLLJ9b4kq20C7zkVczavC5t5/9krFJ8yWuXviBUTWOu7gw1GRSj
 Udqk8sF6wij+YYXMKHeC/p47OtwUxHnQNLtPtCgLj51yphkKEP7kMMsLa51LM6wV2+S7p1
 W2zYhSr2C1xG96NVr9Tgq6UTXEWhv68=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-yzgsZNG4OMq5fO07-66Gqw-1; Tue, 25 Oct 2022 12:07:53 -0400
X-MC-Unique: yzgsZNG4OMq5fO07-66Gqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16775185A7A3;
 Tue, 25 Oct 2022 16:07:53 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.193.32])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A9405410B235;
 Tue, 25 Oct 2022 16:07:37 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
Date: Tue, 25 Oct 2022 18:07:30 +0200
Message-Id: <20221025160730.40846-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: kvmarm@lists.linux.dev, Cornelia Huck <cohuck@redhat.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
