Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B411C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 08:02:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0177F49F0C;
	Tue, 15 Mar 2022 04:02:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EeTzzeY7SmTP; Tue, 15 Mar 2022 04:02:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9488449EC3;
	Tue, 15 Mar 2022 04:02:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 700CD49E37
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 04:01:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DBM1WewOLNkl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 04:01:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AD7749AF7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 04:01:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647331317;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=/tURFiAb+syl9b/OzqHzCooVvPgsFgRn6oKitexyDEY=;
 b=KIV3/f4SSnZ0G+7qxHD8saYbVRxeApXPcZ9kh4BQFKZoUnBIHWD527PT/TxvWdQX1849iC
 NsEiV4piwxHFjQY2rVKkopXcjFP2jaYy/Jl6ZEicL7iXfBJM0l9BNDqxAQu7+JVDBF6S1Q
 hQ6puph8EnXeoUtVSV1vLUlcwaemYXg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-2ZY7at7tOja_bAXmSqGo3w-1; Tue, 15 Mar 2022 04:01:56 -0400
X-MC-Unique: 2ZY7at7tOja_bAXmSqGo3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E33C81C05AFA;
 Tue, 15 Mar 2022 08:01:55 +0000 (UTC)
Received: from gator.home (unknown [10.40.193.57])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 2B0F32156A2E;
 Tue, 15 Mar 2022 08:01:53 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvm-unit-tests] arch-run: Introduce QEMU_ARCH
Date: Tue, 15 Mar 2022 09:01:52 +0100
Message-Id: <20220315080152.224606-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Cc: pbonzini@redhat.com, thuth@redhat.com
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

Add QEMU_ARCH, which allows run scripts to specify which architecture
of QEMU should be used. This is useful on AArch64 when running with
KVM and running AArch32 tests. For those tests, we *don't* want to
select the 'arm' QEMU, as would have been selected, but rather the
$HOST ('aarch64') QEMU.

To use this new variable, simply ensure it's set prior to calling
search_qemu_binary().

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/run               | 4 ++++
 scripts/arch-run.bash | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arm/run b/arm/run
index 0629b69a117c..28a0b4ad2729 100755
--- a/arm/run
+++ b/arm/run
@@ -13,6 +13,10 @@ processor="$PROCESSOR"
 ACCEL=$(get_qemu_accelerator) ||
 	exit $?
 
+if [ "$ACCEL" = "kvm" ]; then
+	QEMU_ARCH=$HOST
+fi
+
 qemu=$(search_qemu_binary) ||
 	exit $?
 
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index aae552321f9b..0dfaf017db0a 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -176,8 +176,10 @@ search_qemu_binary ()
 	local save_path=$PATH
 	local qemucmd qemu
 
+	: "${QEMU_ARCH:=$ARCH_NAME}"
+
 	export PATH=$PATH:/usr/libexec
-	for qemucmd in ${QEMU:-qemu-system-$ARCH_NAME qemu-kvm}; do
+	for qemucmd in ${QEMU:-qemu-system-$QEMU_ARCH qemu-kvm}; do
 		if $qemucmd --help 2>/dev/null | grep -q 'QEMU'; then
 			qemu="$qemucmd"
 			break
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
