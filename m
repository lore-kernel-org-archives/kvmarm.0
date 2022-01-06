Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3386DC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:28:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD60149ED9;
	Wed,  5 Jan 2022 23:28:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YEHc+jKtQq7v; Wed,  5 Jan 2022 23:28:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF24E49F40;
	Wed,  5 Jan 2022 23:28:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADDE149F17
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DlM-m+TnhWWE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:53 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4656549ED9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:51 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 x128-20020a628686000000b004ba53b6ec72so939763pfd.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=I40ndIQTy7x9VMBHQBZhGGkXME+bWi7SZ7wOPZ0TfR4=;
 b=kP8CfJs9IxAq5ufVq3mYZTyrh7u2l9HtOCw6kwveWBv509zUrkSsovsuKAqt+u71EX
 eVHnTj9zR51B7lJHWuabmWxQCCoGNMzW8a/YIHZ4VMK9AM+WGrhRhLnwP44BJxUFVp4u
 +WK0WGoRvwlHJZC7Tv3lZD9nLuEFoLqZAZK46XoG9U8b6cu0M0kKthBSoVKErqL9JCWg
 X9eIhMWHtrRZe454eJ78Eqh+Wbg/JlscAVNB6BjqFmbNzgickZYsejggXV9cTmHF8tua
 3yUk8wHoawv7IXl83ByuDzOSlnR4glUj0P5p1L6Olbi1h4J0407ccHrKsx1JJcRLci+0
 Fxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=I40ndIQTy7x9VMBHQBZhGGkXME+bWi7SZ7wOPZ0TfR4=;
 b=Uiy+Oo5DBLVFKlVFm3sHsTNALM1E2osootpDu/kxyi/izVTSzQtFLB4LFoAu90psLo
 +IKZMKAnN8umcB041kO5tBqSLMDn5kUopMcX63vxJLQq8szXuc78KhNr/9H+SOM5Dn+U
 e2DljZNemUj9eF6ub4GxwpgTxGW8qqrYlbqdxd63zHOhDwim2mN1K/0KOmfuQWYaqMga
 jPJnG6EAah/D5bzeKGDlTTQxVZcYHlw1h5Q/4pbNpQD7D2FJwAtYB6/8lLtC4FwJeXuJ
 yyuLQo/nCbV+u8+4oWGZTc3LzPzC/3Qy+D3gNFp5NvYTKnichrLnjwFzvzN2tAhrel0B
 s7yA==
X-Gm-Message-State: AOAM530I5ZzzdM+qhQd98+VY3/z95XcjkcM/KicKoLz5xtiJmJe8yQCK
 bWeJNnQGpN1pKOD1iDCPyuwrSCnxFWE=
X-Google-Smtp-Source: ABdhPJz13ECz2/kMTHML2IdEfb9myPi6iTkJL3R7KtM4n8E3Zqigfsh8FnU2U9ys6rXGLm8n3QTpkNKaReM=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:aa7:9a0a:0:b0:4bc:79bb:dcd0 with SMTP id
 w10-20020aa79a0a000000b004bc79bbdcd0mr23775052pfj.70.1641443330495; Wed, 05
 Jan 2022 20:28:50 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:55 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-14-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 13/26] KVM: arm64: Make ID registers without
 id_reg_info writable
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

Make ID registers that don't have id_reg_info writable.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1c18a19c5785..ddbeefc3881c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1859,11 +1859,8 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 		/* The value is same as the current value. Nothing to do. */
 		return 0;
 
-	/*
-	 * Don't allow to modify the register's value if the register is raz,
-	 * or the reg doesn't have the id_reg_info.
-	 */
-	if (raz || !GET_ID_REG_INFO(encoding))
+	/* Don't allow to modify the register's value if the register is raz. */
+	if (raz)
 		return -EINVAL;
 
 	/*
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
