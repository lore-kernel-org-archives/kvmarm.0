Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF25C43461
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:34:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE9CE22453
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="kuz0lgsV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE9CE22453
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F26E4B4EE;
	Wed, 16 Sep 2020 13:34:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4BGB5JsNsjuP; Wed, 16 Sep 2020 13:34:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 620984B4FD;
	Wed, 16 Sep 2020 13:34:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52A9C4B4DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VONmjCELWMNW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 13:34:52 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 622574B4A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:52 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id k15so7761018wrn.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 10:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ki62FqIiIgJ8yaBZSKIYHGl1mRsUtoqotQFZS0p5Has=;
 b=kuz0lgsVij7wLKItfIOGcuCmtvwNys1htJnrFzCNRHaLjnVgElf4udXEubZns0dGAz
 NqFkPkuvm9TbHN4J5VCtVm7UDYsIf+4wGcbWnp5r2GIAd9r+/SBADS9HcvFM14SFeAoq
 P2YaGqpnPwU/jtKoPyr2enlSJh9RNiWe4T5dguCXaWfc0N0jpNjqUEXj8iL+3zzKLce5
 gQOmsMW24e8arpUJ3wc5JQTLKSJiijZpRkX/RtKzwFR8HA3+DbxQCE5+3Z9HI+eiTgxx
 FbB0gtfKqTpG/ce9J6iO28HJ/sQI4vk6jtZNWmtWmSFxB01rO8VQFJ/ro1Fry1BHESOm
 8VGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ki62FqIiIgJ8yaBZSKIYHGl1mRsUtoqotQFZS0p5Has=;
 b=XnkgQveIagaaYLkC83Fu6iKsOpssvqV7ZVNGLnr8EAqKafY+JwnyVbdgWz0Of5sHFI
 KFaIJcf/LkfS3OXK2Jkdm90YdGPrP7OgCDzrBjMCVqcsRN+gpTwjaSgb5sc8Gjado2sp
 SyBOea9LL9Z3OAWu/S2OAOWdCasmVybybRymCl0rEHPZfyxW396XwV9n7O6PKqGxVBrG
 5CpvCLLFpOLB5OnoY3EbyLShniQd4I0RlXqssLDmgxJ89nRZmG+JleQY5LSndSMqOfxx
 D9HxHkc1YOtYl/U+AO17Dmo+MEjsnPoBtAuB3f8FjaN1TEVFu73L5VgMzwcU2F5niF1+
 kLmw==
X-Gm-Message-State: AOAM531z2UOcOpEJeU7bog2TFpMZCBw4ic3NnAFDvA1sXyK1MaCYFe3I
 efycmL/f+SwC4HmhqOzcrO+hoWGHVHpaFa6E
X-Google-Smtp-Source: ABdhPJzQzJxXIxJM0jRA7b3rUmMwdVhHQPWJyctJSUBa7YGa64yNP8fcblWJOLLn4QkX3rVzCKMVDg==
X-Received: by 2002:a05:6000:1184:: with SMTP id
 g4mr27622757wrx.20.1600277691141; 
 Wed, 16 Sep 2020 10:34:51 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id o16sm32123548wrp.52.2020.09.16.10.34.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Sep 2020 10:34:50 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 03/11] kvm: arm64: Only define __kvm_ex_table for CONFIG_KVM
Date: Wed, 16 Sep 2020 18:34:31 +0100
Message-Id: <20200916173439.32265-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916173439.32265-1-dbrazdil@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Minor cleanup that only creates __kvm_ex_table ELF section and
related symbols if CONFIG_KVM is enabled.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/vmlinux.lds.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 7cba7623fcec..0d543570e811 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -21,11 +21,15 @@ ENTRY(_text)
 jiffies = jiffies_64;
 
 
+#ifdef CONFIG_KVM
 #define HYPERVISOR_EXTABLE					\
 	. = ALIGN(SZ_8);					\
 	__start___kvm_ex_table = .;				\
 	*(__kvm_ex_table)					\
 	__stop___kvm_ex_table = .;
+#else /* CONFIG_KVM */
+#define HYPERVISOR_EXTABLE
+#endif
 
 #define HYPERVISOR_TEXT					\
 	/*						\
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
