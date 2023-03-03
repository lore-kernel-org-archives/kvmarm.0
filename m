Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087FF185D
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 04:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677816670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQDG9bBnmtTidc0/cVUSCHHDYfaWH9vQxXRTGpMW+rY=;
	b=hmCbWvL3hcSBKmMWJ0dQCMh3VpClwqeDYtaFOhXktWaAhxm/yHc3B960hjQJb3ghuYTfwM
	20Ry9Ad6XtqRK91s8ggZlFL+UF5RCDcgmnzvjdZgYhuWUcJGNdIvI/qq9kWuVZMnwp5kEu
	wn0Vke6OeY2ddL6AoCsM3L7IhhH+xwI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-estBNyw-NWCdXU_GC3avMg-1; Thu, 02 Mar 2023 23:11:00 -0500
X-MC-Unique: estBNyw-NWCdXU_GC3avMg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9275C101A52E;
	Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8BE2A140EBF6;
	Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/2] arm: Replace the obsolete qemu script
Date: Thu,  2 Mar 2023 23:10:51 -0500
Message-Id: <20230303041052.176745-2-shahuang@redhat.com>
In-Reply-To: <20230303041052.176745-1-shahuang@redhat.com>
References: <20230303041052.176745-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7

The qemu script used to detect the testdev is obsoleted, replace it
with the modern way to detect if testdev exists which was first
introduced at QEMU v2.7.50 by:
517b3d4016 (chardev: Add 'help' option to print all available chardev backend types).

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/run | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arm/run b/arm/run
index 1284891..b918029 100755
--- a/arm/run
+++ b/arm/run
@@ -59,8 +59,7 @@ if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
 	exit 2
 fi
 
-if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
-		| grep backend > /dev/null; then
+if ! $qemu $M -chardev '?' | grep -q testdev; then
 	echo "$qemu doesn't support chr-testdev. Exiting."
 	exit 2
 fi
-- 
2.39.1

