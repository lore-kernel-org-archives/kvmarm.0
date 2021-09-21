Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3AEC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21E3461100
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 21E3461100
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B88C94B149;
	Wed, 22 Sep 2021 09:11:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FkGkJVyLN2sW; Wed, 22 Sep 2021 09:11:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E00D4B176;
	Wed, 22 Sep 2021 09:11:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B900407D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 18:22:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qCapvk2vrwuO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 18:22:40 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B67484048A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 18:22:40 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 e2-20020ad45582000000b0037e7bdc88d4so7324063qvx.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 15:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=SaTJOdYvXhQ8G/3tAOF5ENdnH5rnLN1tbst38ysy7nQ=;
 b=Itjz4JdPW3Xd6IJyxU+IgSdqBKiKWfONk5ZYvUFx1Qp7H03KTwkiFwOIHlfFvMXymt
 YwweDiNKHXnGRYXCFukOUTERGOQ/qEruVBMYQRHI7PdZqNHSw8roU14gT9Kor+4fUTT4
 TTZKHbsC3Qkywfp5SCnj6IAQonOjcdNizsj/2lnJCojdfgzHIZe5Squv9OS4bmW1W+A7
 ADEEyakQ4kMkMzhUJM+WDyEfP8Kmp6FAQWbK9AmNVrkP5//1yJS+vUOZz2gsLOeT5nFJ
 0uqiBfx8llKig/ymLOcBXfsc23k8km433C5Chi4dZ6WXvU1abTWhpdJAHraPS0n/IdU/
 ygWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=SaTJOdYvXhQ8G/3tAOF5ENdnH5rnLN1tbst38ysy7nQ=;
 b=mtukfKzKU4DVTKScVZFn0rMfKG3WpnzcYjF/Ks1CdBBTqlmvoczNpruvMVeDKJGKH/
 xlLWOxJvQqGSp9n5y+ExaVA4XhoAoA5pyHg/Sxgde+8ShgNduEoXhum0rmUdHw6qIKoo
 eEibN7zpJQ7WNFYAVKBelXjIJKuSHbeYCXa6c9Ha3/CmUu11mjn6k3SWZxh073oGzHOg
 qr7cJfG3vpNlXNNLgU0eQv+LtXV3fkLrUyjchfkN8G9j49Uw69IwBr/SYbAuuSbfdHHc
 e3HyYz9xnDX54aNsLJo+bbppXu1vJvg2nlmF5PaYzBIxfHDwzmY18jhO4FHpz4LLLJMM
 QouA==
X-Gm-Message-State: AOAM5321VKpV5CatyZT5MG0taX84iaawU2Gl+GeP651zNWGaFjvrQi29
 I/UZmnwRNVdB9cBEf4JLBNQCXdVbP6I=
X-Google-Smtp-Source: ABdhPJyo44HrE4gOW7Ep84hk/WccjZLkWsXMwCnXGAAXHM3jyvouSWGzVSAWQqO9FfsVmAnvX6n2wTzz5ww=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:a05:6902:124f:: with SMTP id
 t15mr42649007ybu.161.1632262960332; Tue, 21 Sep 2021 15:22:40 -0700 (PDT)
Date: Tue, 21 Sep 2021 15:22:30 -0700
In-Reply-To: <20210921222231.518092-1-seanjc@google.com>
Message-Id: <20210921222231.518092-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210921222231.518092-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH 1/2] KVM: arm64: Unconditionally include generic KVM's Kconfig
From: Sean Christopherson <seanjc@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 22 Sep 2021 09:11:52 -0400
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Unconditionally "source" the generic KVM Kconfig instead of wrapping it
with KVM=y.  A future patch will select HAVE_KVM so that referencing
HAVE_KVM in common kernel code doesn't break, and because KVM=y and
HAVE_KVM=n is weird.  Source the generic KVM Kconfig unconditionally so
that HAVE_KVM and KVM don't end up with a circular dependency.

Note, all but one of generic KVM's "configs" are of the HAVE_XYZ nature,
and the one outlier correctly takes a dependency on CONFIG_KVM, i.e. the
generic Kconfig is intended to be included unconditionally.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/Kconfig | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a4eba0908bfa..c50f75cf76fe 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -4,6 +4,7 @@
 #
 
 source "virt/lib/Kconfig"
+source "virt/kvm/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -42,10 +43,4 @@ menuconfig KVM
 
 	  If unsure, say N.
 
-if KVM
-
-source "virt/kvm/Kconfig"
-
-endif # KVM
-
 endif # VIRTUALIZATION
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
