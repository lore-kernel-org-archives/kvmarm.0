Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E666C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:47:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B324360273
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:47:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B324360273
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B7334B166;
	Tue,  2 Nov 2021 05:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DZ+5ZJ4Ua4fr; Tue,  2 Nov 2021 05:47:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAC134B15D;
	Tue,  2 Nov 2021 05:47:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 895C44B17D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:47:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ChBsp7ah+NtG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 05:47:07 -0400 (EDT)
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com
 [209.85.210.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 835C24B153
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:47:05 -0400 (EDT)
Received: by mail-ot1-f73.google.com with SMTP id
 c19-20020a056830001300b00546faa88f0cso10815154otp.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 02:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nEjtp48gVyB++aYe5TOFGmHYLzUAbR8AMXiOP8caS+Q=;
 b=PH5s6nRr9C9ryg6R7K3KVE7lekvhJ4vWen1srtKgyckfyIL506uPsp1thUwsDGBp2I
 s0rtpTcgH5+RkIAsgGui4xxyoFy2FcKhuqD+zlL2WiqoCNePlOfIDPzVfVMzLVNidPjE
 kDEqKvU6sNqdwfuqSVPXBVcUcyFM0qCKpCDbvWbSDAhF1onWqasK3EH8UcK/mYSHPksz
 mu2apwuLuFAzZv2kxhvJanRAtOYb3H5MRH72mlIaj7J5/KI9xqRFZFs16+BhvHOxddyt
 171ryqXBNwgM1szDlWottlMAZQwysc78EQeNEGivOGb68Tzn2pW9Yt4pXEWl5Giqs3mz
 GENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nEjtp48gVyB++aYe5TOFGmHYLzUAbR8AMXiOP8caS+Q=;
 b=Huku1qZFcLxmUzTRFak6NQN4VH+Scyci3D+LlN/8TjnEgHY88PdUz3fXRZ8K+5huYj
 ml79SsF8ZuGUHsphJJRxmPJ6dM+z7z6VQzzzwkeo9c2dU6E3fLPqmcruck2FC7xvrOvK
 OrB4y/5VydGvYdbVlPI5Mat05JO37hx4E01RhYs4chZEulHtrRFvOGNo5lg8d+1ah1cF
 k+qwFLXqn1YJfiiuPzfva/BFGZg+pwNFwx32hTB7Q8MDIsDS5k2k/crXr2vhz/0AFYzR
 TsrKdZpGZoC3sI7zlzWMB6lyevwHpfZkt++8A2WkLcVRpvUrbZBe1kFVBV3lktHkn+cf
 EZFA==
X-Gm-Message-State: AOAM531teVqd99n8CUq0bkSfN+V9oT4+8jd1aM0Dh3xBNBk11Xvw5CnW
 aNXKb3jvPBcalBcwKyGLUKFuTmn0LfTKzb66eIelc8AVdy+twZ/EomTSGZQK+l6FJcfMnRmQJ4k
 Ydw/WWtXScZHJGS3xBOy1NRDd0rydVwfZq577QfU6nQg8/laNtrZY+IrvxCWsTaNylKWmrg==
X-Google-Smtp-Source: ABdhPJxr747gitpVlJ/b+QoTgbMhfsQFRzNX4vE8pGYUrpL6y/peDJCUncRK+fGW//73XuPwhgpbn5iWeqM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6830:1ace:: with SMTP id
 r14mr25706515otc.232.1635846424779; Tue, 02 Nov 2021 02:47:04 -0700 (PDT)
Date: Tue,  2 Nov 2021 09:46:50 +0000
In-Reply-To: <20211102094651.2071532-1-oupton@google.com>
Message-Id: <20211102094651.2071532-6-oupton@google.com>
Mime-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 5/6] selftests: KVM: Add OSLSR_EL1 to the list of blessed
 regs
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

OSLSR_EL1 is now part of the visible system register state. Add it to
the get-reg-list selftest to ensure we keep it that way.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..0c7c39a16b3f 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -761,6 +761,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(2, 0, 0, 15, 6),
 	ARM64_SYS_REG(2, 0, 0, 15, 7),
 	ARM64_SYS_REG(2, 4, 0, 7, 0),	/* DBGVCR32_EL2 */
+	ARM64_SYS_REG(2, 0, 1, 1, 4),	/* OSLSR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 0, 5),	/* MPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 1, 0),	/* ID_PFR0_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 1, 1),	/* ID_PFR1_EL1 */
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
