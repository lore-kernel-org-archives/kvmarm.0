Return-Path: <SRS0=M1Jp=A3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66747C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jul 2020 12:08:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF96D2074B
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jul 2020 12:08:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rXwi/yat"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF96D2074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A95A4B49A;
	Thu, 16 Jul 2020 08:08:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qiL-NgTIlKXu; Thu, 16 Jul 2020 08:08:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FCD94B492;
	Thu, 16 Jul 2020 08:08:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 204AB4B476
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2020 08:08:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8PjWOcXjNplD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jul 2020 08:08:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3A874B472
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2020 08:08:10 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B31302074B;
 Thu, 16 Jul 2020 12:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594901289;
 bh=3PipD2VgqpMm6NsDZAGjXt1uT7SJIOeABIEJHpL222Q=;
 h=From:To:Cc:Subject:Date:From;
 b=rXwi/yatQ9N3eqMd3+e05P1NKXMpa2fhrezNvIvWkkCo83u/x/SrD4e2gIUA9CY43
 gNhNZ98RIG45MZ8yoUg4cLP8SFQC7tz5gQ99iboC201BRJuvJ2h5JEDn9ioqi0w7QJ
 E++j+ak1gTjcFHTdM9xdD3gRdyO+e3IM2Iiz6n3g=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jw2gK-00CIGX-0B; Thu, 16 Jul 2020 13:08:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [kvmtool][PATCH] arm64: Use default kernel offset when the image file
 can't be seeked
Date: Thu, 16 Jul 2020 13:08:01 +0100
Message-Id: <20200716120801.2996-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, will@kernel.org,
 julien.thierry.kdev@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

While introducing new code to extract the kernel offset from the
image, commit fd0a05b ("arm64: Obtain text offset from kernel image")
introduced a regression where something such as:

  ./lkvm run -c 8 -p earlycon <(zcat /boot/vmlinuz-5.8.0-rc5-00172-ga161216e31ba)

now fails to load the kernel, as the file descriptor cannot be
seeked.

Let's assume the good old 0x80000 offset when the seek syscall fails,
with a warning for a good measure.

Fixes: fd0a05b ("arm64: Obtain text offset from kernel image")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arm/aarch64/kvm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index a46d438..49e1dd3 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -15,6 +15,7 @@ unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd)
 	struct arm64_image_header header;
 	off_t cur_offset;
 	ssize_t size;
+	const char *warn_str;
 
 	/* the 32bit kernel offset is a well known value */
 	if (kvm->cfg.arch.aarch32_guest)
@@ -22,8 +23,10 @@ unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd)
 
 	cur_offset = lseek(fd, 0, SEEK_CUR);
 	if (cur_offset == (off_t)-1 ||
-	    lseek(fd, 0, SEEK_SET) == (off_t)-1)
-		die("Failed to seek in image file");
+	    lseek(fd, 0, SEEK_SET) == (off_t)-1) {
+		warn_str = "Failed to seek in kernel image file";
+		goto fail;
+	}
 
 	size = xread(fd, &header, sizeof(header));
 	if (size < 0 || (size_t)size < sizeof(header))
@@ -37,7 +40,9 @@ unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd)
 	if (le64_to_cpu(header.image_size))
 		return le64_to_cpu(header.text_offset);
 
-	pr_warning("Image size is 0, assuming TEXT_OFFSET to be 0x80000");
+	warn_str = "Image size is 0";
+fail:
+	pr_warning("%s, assuming TEXT_OFFSET to be 0x80000", warn_str);
 	return 0x80000;
 }
 
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
