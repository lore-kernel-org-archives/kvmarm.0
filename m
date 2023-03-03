Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8FA1851
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 04:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677816670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ofXBqMRFaLDwBIweNpr/a3sSGv/P/h/HGrL9mEZalZg=;
	b=SCTFTnZuq3dIEPxJzyl4/ixnf9X9SN2fciCojUPJuKVxolhkgEqSlEhlKCTYTT5vnFFE9k
	JV8FJXbY5WtYj2Ne3MpTrPJbYi7u+qShP8k+AXd56JTB0d4ylbEhaA6tnpFxhPtAyaXHxi
	cxAGhw6UfrGb82vhDGKGIOdVCSDJbM8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-nAljj7KEOsaFQVN2pvPqeQ-1; Thu, 02 Mar 2023 23:11:01 -0500
X-MC-Unique: nAljj7KEOsaFQVN2pvPqeQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7A79830F82;
	Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A1634140EBF6;
	Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/2] arm: Clean up the run script
Date: Thu,  2 Mar 2023 23:10:52 -0500
Message-Id: <20230303041052.176745-3-shahuang@redhat.com>
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

Using more simple bash command to clean up the run script.

No functional change intended.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/run | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arm/run b/arm/run
index b918029..c6f25b8 100755
--- a/arm/run
+++ b/arm/run
@@ -28,7 +28,7 @@ fi
 
 ACCEL=$accel
 
-if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
+if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
 	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
 	exit 2
 fi
@@ -36,7 +36,7 @@ fi
 M='-machine virt'
 
 if [ "$ACCEL" = "kvm" ]; then
-	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
+	if $qemu $M,\? | grep -q gic-version; then
 		M+=',gic-version=host'
 	fi
 fi
@@ -54,7 +54,7 @@ if [ "$ARCH" = "arm" ]; then
 	M+=",highmem=off"
 fi
 
-if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
+if ! $qemu $M -device '?' | grep -q virtconsole; then
 	echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
 	exit 2
 fi
@@ -68,7 +68,7 @@ chr_testdev='-device virtio-serial-device'
 chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
 
 pci_testdev=
-if $qemu $M -device '?' 2>&1 | grep pci-testdev > /dev/null; then
+if $qemu $M -device '?' | grep -q pci-testdev; then
 	pci_testdev="-device pci-testdev"
 fi
 
-- 
2.39.1

