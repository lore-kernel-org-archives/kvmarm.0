Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E163EC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D9C261360
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8D9C261360
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D8104B0C3;
	Tue, 19 Oct 2021 08:13:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JU9gTmLdPnFT; Tue, 19 Oct 2021 08:13:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 388474B10A;
	Tue, 19 Oct 2021 08:13:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E76D4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KFPZs6xE5+J1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:19 -0400 (EDT)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C1BE4B14D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:19 -0400 (EDT)
Received: by mail-ed1-f73.google.com with SMTP id
 l10-20020a056402230a00b003db6977b694so17360646eda.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Xom4QB7AOMzMrKQIokAKkuFuVfZT5vZhj8rSYX3sNOQ=;
 b=UEBfi9pZv9JWQ9n6/h/iOXEYKZp+KAlUh2DKJbB4tCbbbpQt6Q9qFpuPdsiYcGSHx4
 LX6u3LKvK+ZLLiBEXefMFZZuJL/m57dP0wNf92XMwUS2Vc4dHj+r3kRAM+CL+lqpMimX
 354GwtJhsJ/BwC6r/0XdfiJNr9uoaPCzbdcNTOih4LRbc2iBl63nuNe9XPomDGTu4R52
 5h9hahfNMP9P3o1jfQpOzoMJ43rFPXjB2Uz7vART5kBtHnDArZemdhxKKysPgIU8UxyD
 IXWd2hd/An+PUfJ97+ttKWnIHwUIuxY1/PzKFQseQtOWrSYNG0vc08yZilX4NoOhQn46
 fInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Xom4QB7AOMzMrKQIokAKkuFuVfZT5vZhj8rSYX3sNOQ=;
 b=uLaNqi+dW50D02qd0DsLZ6lnSeHpjWsmtceOvnhBocwh/h8TfUzC2kuTpNUtDLQ6zK
 6GB8FfqQB4AyPUJ2YZQf657DQolITfT1iQ+01/J5GQdXTxXko9Jz9n5e7f3bsf2Z7IJr
 IE1EFrjioY1/2tQVlgnsx3qc2CopoxtA03NR0iuhEK/ldMCldGei6ckupsK1p2TE4+t+
 6r1d4gbOQHSMkohI6m1hH/jABjZvN5aHXr0NK03WVzeC9LKzWdprsymDEforpEqmaftl
 Jw+iA6eLbqQdybHHMj8gSyQQ/ICiFLINY68GOccoL3T4MESgjZ29r/ZfDq+aWNq1HDlc
 drSg==
X-Gm-Message-State: AOAM531CLdAi2l1KE+KiTzLyU9VxJy0UafWPioRoWbfp4uQHewhu6sWY
 1wVITGJ+NDx8LxlWhUG8sTFFXG/PVrGG
X-Google-Smtp-Source: ABdhPJxpv/+Qrz1w29XpbnCupLR0QNbk4QaH0nM4qXe1dCgEnX/Y+92sdhWJIqq0OnYUXAbOKpiNqDTYPy5k
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:aa7:dbcf:: with SMTP id
 v15mr53721659edt.243.1634645598342; Tue, 19 Oct 2021 05:13:18 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:12:54 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-6-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 05/15] KVM: arm64: Hook up ->page_count() for hypervisor
 stage-1 page-table
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

From: Will Deacon <will@kernel.org>

kvm_pgtable_hyp_unmap() relies on the ->page_count() function callback
being provided by the memory-management operations for the page-table.

Wire up this callback for the hypervisor stage-1 page-table.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 9e5c92237a51..56343b1bb3a9 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -247,6 +247,7 @@ void __noreturn __pkvm_init_finalise(void)
 		.virt_to_phys	= hyp_virt_to_phys,
 		.get_page	= hpool_get_page,
 		.put_page	= hpool_put_page,
+		.page_count	= hyp_page_count,
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
