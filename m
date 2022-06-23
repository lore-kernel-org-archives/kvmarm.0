Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201F3CCA47E
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 13:10:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 971D24B3B6;
	Thu, 23 Jun 2022 09:10:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ouPnF6N3u7NQ; Thu, 23 Jun 2022 09:10:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DD284B382;
	Thu, 23 Jun 2022 09:10:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E65724B377
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 09:10:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21c6A-bRm6xL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 09:10:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 626F04B376
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 09:10:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655989825;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=rmoM2sqrNH4gB4OMADyCrtt+JYV77lbslouxb07UaD0=;
 b=ZOv9Z+CamERy+09igdSDh8FrfwnlgW7YgEWF3MROYaaIf55Eunupitv3JbbEU+Ow0T+wZx
 St6iimL5PjE+z1fNmxu7NEG+OG3MvC4zgn9y7PiyBg/ZyqY6sLbyZoGeCE3tvc17/B8Jhi
 5e57xREOPI1ocsIHSKOxDYg1lXSSLUs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-l24YVwCaORSxh1PyRf7X7Q-1; Thu, 23 Jun 2022 09:10:22 -0400
X-MC-Unique: l24YVwCaORSxh1PyRf7X7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9A538032F6;
 Thu, 23 Jun 2022 13:10:21 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.193.109])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 58C5940CF8EE;
 Thu, 23 Jun 2022 13:10:18 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvm-unit-tests] MAINTAINERS: Change drew's email address
Date: Thu, 23 Jun 2022 15:10:17 +0200
Message-Id: <20220623131017.670589-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Cc: maz@kernel.org, thuth@redhat.com, qemu-devel@nongnu.org,
 nikos.nikoleris@arm.com, qemu-arm@nongnu.org, andre.przywara@arm.com,
 pbonzini@redhat.com
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

As a side effect of leaving Red Hat I won't be able to use my Red Hat
email address anymore. I'm also changing the name of my gitlab group.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bab08e740332..5e4c7bd70786 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -55,7 +55,7 @@ Maintainers
 -----------
 M: Paolo Bonzini <pbonzini@redhat.com>
 M: Thomas Huth <thuth@redhat.com>
-M: Andrew Jones <drjones@redhat.com>
+M: Andrew Jones <andrew.jones@linux.dev>
 S: Supported
 L: kvm@vger.kernel.org
 T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
@@ -64,14 +64,14 @@ Architecture Specific Code:
 ---------------------------
 
 ARM
-M: Andrew Jones <drjones@redhat.com>
+M: Andrew Jones <andrew.jones@linux.dev>
 S: Supported
 L: kvm@vger.kernel.org
 L: kvmarm@lists.cs.columbia.edu
 F: arm/
 F: lib/arm/
 F: lib/arm64/
-T: https://gitlab.com/rhdrjones/kvm-unit-tests.git
+T: https://gitlab.com/drew-jones/kvm-unit-tests.git
 
 POWERPC
 M: Laurent Vivier <lvivier@redhat.com>
-- 
2.34.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
