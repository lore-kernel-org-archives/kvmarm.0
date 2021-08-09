Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10469C43214
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9204C61056
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9204C61056
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 322C44B109;
	Mon,  9 Aug 2021 11:25:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aQr2MoZW4jeR; Mon,  9 Aug 2021 11:25:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A66E4A319;
	Mon,  9 Aug 2021 11:25:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 952874A3A3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wIxwnyyQLAKK for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:10 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05FB54A19B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:10 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 y12-20020adfee0c0000b0290154e82fef34so1220911wrn.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Io0EDWR3PIis5nkH0gOz1mjrCvg673G9g4IXwa5GIus=;
 b=jfaqF6Wq0Q9e4kkR+jmQAYTa2BnTkBr9q1lmRTdsQdJw/Lh0h/noCoRqRFHW979Vpn
 FDKKbqzoWj8dqTthh4xSOmxkqcsPWcuNm+/ndBqE4q2EeOVzZY5mqOV525AiuZvLD4vO
 sS+vwhpt6tu/ukL509vBuZlbxwKpNeB2AAN77VyY2yLrcUYdbxSOO5/Yxf4wwTvU8W1N
 AmTljU+kIMZA+bYoLJRjetYMG/tcu4In0+GCs4r0zidT6ZPDR4xX/vsgr9gTLMWH1g8h
 xAk0qlE1XeZybchFEHU0YlCCJpuW++Vrxa1Y0KQ43VfgFVirxcu6/bwjge3Al4LJOlkE
 Jf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Io0EDWR3PIis5nkH0gOz1mjrCvg673G9g4IXwa5GIus=;
 b=LGkXQVYhku4ySwP5OuCLzmrmvZXJ3ehOFyfro9AXCyJmu2PHZLJBinoLeHcnP9iEJ/
 1dc2jhuJyLY0z0Kgj6PB8furVWFzfoNI/wP1GKm8PKEBeY3hZoeI5mT77FclGQvv8oQN
 JAA1ofolcUZ+LL6Of2di6PUcq8dBzi4Wna6ExoMFFUjL3mhdFJEUS1LaCsVE0YeDSOUT
 KaQU0T2D+iOX6/n9Zh00250mszDVlUd3mSO7+jJ4jn3OmcZvksV0EOP++ekUrZh5Chgd
 QIgjvYCAiz1hHqeR67R2kfTW9AgoT3rroa6GAz2188QDC8jDkqBBLQ9d25k+Gb9S097w
 OkZQ==
X-Gm-Message-State: AOAM530h/h34nAZCoixPv5m/LHMuSiCQFDLx1KInccr4O29kjNh5QxUL
 t+ACZ28WsECHyaaCKjhkRbGSG7X1jU5W
X-Google-Smtp-Source: ABdhPJz9dh/8xSQuBObFyZiVhTM2lFEjdAUdZfHfPEw63Mx6TEFaOYVnO3fFNdHkbUVeYnSFomkPJvPUytlF
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a05:600c:410b:: with SMTP id
 j11mr34327897wmi.27.1628522709110; Mon, 09 Aug 2021 08:25:09 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:35 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-9-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 08/21] KVM: arm64: Don't overwrite software bits with owner
 id
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

We will soon start annotating page-tables with new flags to track shared
pages and such, and we will do so in valid mappings using software bits
in the PTEs, as provided by the architecture. However, it is possible
that we will need to use those flags to annotate invalid mappings as
well in the future, similar to what we do to track page ownership in the
host stage-2.

In order to facilitate the annotation of invalid mappings with such
flags, it would be preferable to re-use the same bits as for valid
mappings (bits [58-55]), but these are currently used for ownership
encoding. Since we have plenty of bits left to use in invalid
mappings, move the ownership bits further down the PTE to avoid the
conflict.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 59a394d82de3..1ee1168ac32d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -46,7 +46,7 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 56)
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
 #define KVM_MAX_OWNER_ID		1
 
 struct kvm_pgtable_walk_data {
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
