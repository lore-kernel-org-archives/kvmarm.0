Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17970C4332F
	for <kvmarm@archiver.kernel.org>; Sun, 13 Mar 2022 16:21:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E18404A0;
	Sun, 13 Mar 2022 12:20:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qBoZFzH9yRzB; Sun, 13 Mar 2022 12:20:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70CA940BFA;
	Sun, 13 Mar 2022 12:20:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22D5C404A0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 12:20:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GR84Sa72wvMt for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Mar 2022 12:20:56 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D05CB40C23
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 12:20:55 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 t2-20020a7bc3c2000000b003528fe59cb9so5775389wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 09:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xRLNPKWQW7+hC65Qmnbks6vmJGfKu2nEu3sFlAXyPE4=;
 b=qAX6/PuWTV9ML3ZFV7QIy8MGiQZMNO6Km4UEh/pTL3k+sy2PiP9RK5nlk7kovOe+JU
 +qkkwGr70ZKhUfNO2nMaAuWyQo9m5vdVEa5eO+ZunDafhs8+VmzUGXvNbujGKbhy0y//
 ajC0/QHCsN8lcboZjcmUt8hkFznzX24El+3nR0YtsQK2SqDyv7mQkunwa3TM2Bt1pb/Z
 aHtXPO/qb9fcWm5tq7NbnuMkJLiIUNdCen4SqwdxF8NI6ITjZGh4UiBiDqT9nNyYqlKF
 wMuqHOzUhpZpj4vcAOghsHdjVCdryXQCgfG8ZAvv4Js1FCiHM39DbE1fulTQfIEkzks4
 jGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xRLNPKWQW7+hC65Qmnbks6vmJGfKu2nEu3sFlAXyPE4=;
 b=j2RyRbqzsZ1IUMRaTcqrAgjT2LIx44ID2wp090iUwe+p4DUI9juLsvcWsa6b3V98Zz
 PpmxEazE96tocZX4UbESnra0pvromZwo/9INw/57o28NFxsULSyv9I2PjUucOezh8fdL
 K/r4rwpfk2QB1sVzzXUY01/ugDSHWrtLUUhbWcQRfNZ/0+U0Uhy6+mlTu67sgnB3Rz6D
 y28cii5ZNV8XQBWXnLAJ2iHobmmsqJaiaZZ9jMtKVZJPFlUk4aLL1RGl7NFPFzQiPnfy
 C3hhGel3CDF3rMrktmYrFfvSdviZIEMUSElVUblm1A25d5omy8OLMYTqXpAKEmnkoh+b
 tBVA==
X-Gm-Message-State: AOAM532DTWsuW+MPMx8s5foH6OtwfHhTVnkpIDUGGx7MGPzNKH6+cLih
 Vpp4tA5gNCKDe/jj6LQYqUWlK6W2/70IHnTxHxg=
X-Google-Smtp-Source: ABdhPJwkNB5tp5JuBAYpr2hqSLOs1R8ei9Eat8+26nfA36LM3Juy+JWHu4KJRiwxUWPq0xOBMLw4cKS5rx7nB+uv5ds=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a7b:c2f7:0:b0:389:860c:6d3d with SMTP
 id e23-20020a7bc2f7000000b00389860c6d3dmr14429441wmk.116.1647188455050; Sun,
 13 Mar 2022 09:20:55 -0700 (PDT)
Date: Sun, 13 Mar 2022 16:19:50 +0000
In-Reply-To: <20220313161949.3565171-1-sebastianene@google.com>
Message-Id: <20220313161949.3565171-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220313161949.3565171-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH kvmtool v11 3/3] Add --no-pvtime command line argument
From: Sebastian Ene <sebastianene@google.com>
To: kvm@vger.kernel.org
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

The command line argument disables the stolen time functionality when is
specified.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 builtin-run.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/builtin-run.c b/builtin-run.c
index 9a1a0c1..7c8be9d 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -128,6 +128,8 @@ void kvm_run_set_wrapper_sandbox(void)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
+	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
+			" stolen time"),				\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
