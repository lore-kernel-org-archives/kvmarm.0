Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118BF79CF
	for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 13:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687525544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=El4VroHOllIBmAMq4mcyvIq/rdpFjMS5b4p6zjgT9ik=;
	b=hDgWb05GDxGlbBsmHpI0iv9mP41tyc7bO8u1yFzaCFfv4ElEUavdyqd++7B4ezsb9a+rtz
	6YMc0nrCX//rPnArV5TA2eGsFjIPY3UsMBvFWCvzmpLdhjEkLwrmGA5ZnJuhz1buvd2YV7
	WZjSNwvW6mxcDQoLOdunX+PVE68X6kI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-Uf5bNq_8M_6EQypVaKhmOw-1; Fri, 23 Jun 2023 09:05:40 -0400
X-MC-Unique: Uf5bNq_8M_6EQypVaKhmOw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25D1783505D;
	Fri, 23 Jun 2023 13:05:32 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.208])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3FB04425357;
	Fri, 23 Jun 2023 13:05:31 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] arm/flat.lds: Specify program headers with flags to avoid linker warnings
Date: Fri, 23 Jun 2023 15:05:28 +0200
Message-Id: <20230623130528.483909-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10

With ld from binutils v2.40 I currently get warning messages like this:

 ld: warning: arm/spinlock-test.elf has a LOAD segment with RWX permissions
 ld: warning: arm/selftest.elf has a LOAD segment with RWX permissions
 ld: warning: arm/pci-test.elf has a LOAD segment with RWX permissions
 ld: warning: arm/pmu.elf has a LOAD segment with RWX permissions
 ...

Seems like these can be silenced by explicitly specifying the program
headers with the appropriate flags (like we did in commit 0a06949aafac4a4
on x86 and in commit 5126732d73aa75 on powerpc already).

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arm/flat.lds | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arm/flat.lds b/arm/flat.lds
index 47fcb649..f722c650 100644
--- a/arm/flat.lds
+++ b/arm/flat.lds
@@ -22,10 +22,16 @@
  *    +----------------------+   <-- physical address 0x0
  */
 
+PHDRS
+{
+    text PT_LOAD FLAGS(5);
+    data PT_LOAD FLAGS(6);
+}
+
 SECTIONS
 {
     PROVIDE(_text = .);
-    .text : { *(.init) *(.text) *(.text.*) }
+    .text : { *(.init) *(.text) *(.text.*) } :text
     . = ALIGN(64K);
     PROVIDE(etext = .);
 
@@ -39,8 +45,8 @@ SECTIONS
     .got      : { *(.got) *(.got.plt) }
     .eh_frame : { *(.eh_frame) }
 
-    .rodata   : { *(.rodata*) }
-    .data     : { *(.data) }
+    .rodata   : { *(.rodata*) } :data
+    .data     : { *(.data) } :data
     . = ALIGN(16);
     PROVIDE(bss = .);
     .bss      : { *(.bss) }
-- 
2.39.3

