Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2909FC43334
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jun 2022 19:31:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1E364B346;
	Wed, 15 Jun 2022 15:31:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z8x-PH9D85Sg; Wed, 15 Jun 2022 15:31:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A453A4B32F;
	Wed, 15 Jun 2022 15:31:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 620A24B32D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 15:31:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BQkhe9lM1CYf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jun 2022 15:31:36 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 952614B0B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 15:31:35 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 s23-20020a257717000000b00660719d9f2fso11112767ybc.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 12:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=p5lI2xiHmpMNi5Qspc8ysgo55K7EWn4WgT9n1L+fZKs=;
 b=mG6dyBnv2Z1YIhYMMdOhxpmTOlhI6K5F3pqVu7BBfWjuTllDmyHe24BM5YFrSH3k3m
 k37eaVag1hTqsXm2MRzzXDOHY8me4Bq0JCL74CQUtSUR0vYxJ92PPv59X3Z/tLK9Dn+F
 zeTFHx0m2edykqQZX28LMgGlhp3UWw1H3teXTxJbhpynPri8OGPfBeq2am/bZgiujx0X
 RListKVLmXaPRxX72t+rUnfMj64Mkah1i+sXryEK9ouBTNns2t/OmP+IoEmB0+ArGp0B
 fUYX+EcewLKlIUXdyTsVoKIvawpcNwMHPujF1u2WdawbTnka+vjiHykWjlxZcCf9FAZY
 07pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=p5lI2xiHmpMNi5Qspc8ysgo55K7EWn4WgT9n1L+fZKs=;
 b=14M9VlTcVEyLpv3jhz98DkcQR4L797Rgw7GXLnvVxVtRwF1lzRLfuewnK97vY8Hhb2
 nBWgk3Bph9HWGyWkqpmgk8Xko/Lby849IvDN1wlIvO4Yu26FF+S/ymycq6rutwFKthRI
 ENUl1Lu1JbjJ0XnCsqFCMpD1lEeUhjDV6DCsMdJwdaqSlFQAjHGcimRKlzGd0ap4k8QK
 zBODEemZmGWbdWr1Z/xcLsUTWZJpbXr3oEcawFpV5se+kPcG7OHdxO/VitMUAGz+66Hy
 XsK7hgElp9KM0OQPeUaYa+yndGe/CCXJLmhO/yFk4cknjRJoTExhaEXRRV1aTN2WuACo
 S9QQ==
X-Gm-Message-State: AJIora9YJ8glutnpqF55A9xIKiGvtGeZZjqgDzYlwdl9NJ9L2ehA9AHU
 G+Vf8x21mtliKjRGTUYqvhC64P6p1VTcxlG0Xg==
X-Google-Smtp-Source: AGRyM1se+2rADeaOeSDd5N6eWtlHqK6a1Gro/vu3VtVQEeTKiC1Lznt62mYgLeGnbzgYXtxxD8SkUuHPd61HawlBMA==
X-Received: from coltonlewis-kvm.c.googlers.com
 ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:803:0:b0:314:17cc:1994 with SMTP
 id 3-20020a810803000000b0031417cc1994mr1398832ywi.505.1655321495080; Wed, 15
 Jun 2022 12:31:35 -0700 (PDT)
Date: Wed, 15 Jun 2022 19:31:14 +0000
In-Reply-To: <20220615193116.806312-1-coltonlewis@google.com>
Message-Id: <20220615193116.806312-3-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220615193116.806312-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
Cc: thuth@redhat.com, Colton Lewis <coltonlewis@google.com>, maz@kernel.org,
 vkuznets@redhat.com
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

Increase UCALL_MAX_ARGS to 7 to allow GUEST_ASSERT_4 to pass 3 builtin
ucall arguments specified in guest_assert_builtin_args plus 4
user-specified arguments.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/include/ucall_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index dbe872870b83..568c562f14cd 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -16,7 +16,7 @@ enum {
 	UCALL_UNHANDLED,
 };
 
-#define UCALL_MAX_ARGS 6
+#define UCALL_MAX_ARGS 7
 
 struct ucall {
 	uint64_t cmd;
-- 
2.36.1.476.g0c4daa206d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
