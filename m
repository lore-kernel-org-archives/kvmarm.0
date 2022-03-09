Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2021C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 13:35:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76EF649F27;
	Wed,  9 Mar 2022 08:35:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KmRZQTu8Wlvw; Wed,  9 Mar 2022 08:35:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DA1549E48;
	Wed,  9 Mar 2022 08:35:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0960249E1A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 08:35:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tj2Exq-Nn2yH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 08:35:03 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3445549EF0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 08:35:03 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 c62-20020a1c3541000000b003815245c642so2591200wma.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Mar 2022 05:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=txkn166+EfY7PppLWw4qc4C+/p2UR63wD9i9h0OJBgQ=;
 b=ZCgrb3FToHMhfcZlVFPL3oJER5BGYQVAaQvgcAUa/DciOsVvbDUTwDTOFRZvZzEBWL
 2rwa48OxFzZN8vZl6zkdwmKD2j2spF1kvSe3fcpRqlzqOKr4ibCm3eBH+2jHSMrlpFdQ
 /B4v+x/KYK7zLPQxU/V9AxHHcAOTMT8vn1FF/Xhift8Ml9ZG3rtUhkB8OxLiaO3YI8V7
 ElI2gQyQlBen8ohgI6m9Xw2ZAZRRnqz8jlB2L1aQYdwQrlaHHyRhnOKR+StiyI+Dl1J9
 Mf3CS+Op2k9SV5smEB6D6Nxy8f8Ox7t+iSzgwvMGlCdFoNc5PYkXQixN1cEV76AK5cEi
 q6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=txkn166+EfY7PppLWw4qc4C+/p2UR63wD9i9h0OJBgQ=;
 b=S/0tZkNHY8KR2+AtMkX+wPvrOWkv34yGmgHGu0YTEZ/06aGmpaqT86VwZ3enpxLVBD
 knrYT8Ose1Tvx2HCHUm+TwhsKMQwDAqh8js9Bfazx3vGeeZ73YFt2KdtEI3ko5UXktbE
 c4FMT1LWTiD6wAh9aEOM7MXBm8TSHS0hZukx+o5jU5wyCJ0Qig0/qeEFGZthR1VKMTNJ
 p0LginC9ljhkb3w/mRAxdBth8Sx81shsNYrLcsVZo2ubCq5eiV3DrJRubu0J7ZbnWKix
 I2dVSEtm3jYsU2A8sQ5bNRuJyE8CZU4hGLFGeodlrJ5zAebOsbn1IyLOaz32E31XIUma
 zQ7A==
X-Gm-Message-State: AOAM531gdusJhVrq8XxywtiOUyV2OqdwjaYus0zSRQyRfYTMtYlyBCaL
 jvPLR9LFHym+MlSJ7fV3yCDjCX4TDuOa/fj/tf4=
X-Google-Smtp-Source: ABdhPJyy5Jec64Gj0xLgU8Y1HqV/oWzty8Va5II4Mvi0EqoCxwaWwm9iCORkRTBPpUECUBLrnJrTnt8dB1Nt8F/AA+Y=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:1c02:b0:389:cf43:da63 with
 SMTP id j2-20020a05600c1c0200b00389cf43da63mr3332701wms.205.1646832902270;
 Wed, 09 Mar 2022 05:35:02 -0800 (PST)
Date: Wed,  9 Mar 2022 13:34:24 +0000
In-Reply-To: <20220309133422.2432649-1-sebastianene@google.com>
Message-Id: <20220309133422.2432649-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220309133422.2432649-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v10 3/3] Add --no-pvtime command line argument
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
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
