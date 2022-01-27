Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18FEC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 03:09:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3902649EEF;
	Wed, 26 Jan 2022 22:09:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d9K+Wbqwwp02; Wed, 26 Jan 2022 22:09:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E483349EE2;
	Wed, 26 Jan 2022 22:09:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6336549EC1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 22:09:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L3M0PNmlJqQb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 22:09:05 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37BFB49EC0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 22:09:05 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 e17-20020a63f551000000b0034d214ccec5so697247pgk.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 19:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=y8xiYhpGFxFKO0m5kKEQAv7sJcYQ8XNaG5VWu+Ph1Do=;
 b=FEdpoVYgU4JntAof5I9WPwlqD9ZAVq8CUvLK6LaYoB1EHNTpqXFRq12cfq0POmb7u4
 iwYEykWf5MFxuGpvTqbIeaHJmgchKLL9KC1XEH+L+9QbWZJDbn3bZc8H3/u00ZPHtr0X
 VuRcbdSQdY18NlDVx9MBPJBs/5uX5ghdFrbf4hHJDui+jCFIRSYmq3J+/k2aAAZQ2crs
 x98ADrn7phtxBIpgPUpS+kmW4QqRruyi9+Wrds4PZGFQa3+cEBJTeyV1aUaSgBE6VrRr
 ui92v01imlYes9h9PEykIb9PDmtvZK5kxw/IFLpZcaPVIrnzb6DRfnLa/aXe2eLRHe0a
 qJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=y8xiYhpGFxFKO0m5kKEQAv7sJcYQ8XNaG5VWu+Ph1Do=;
 b=Yc1lYWJJceyW1NN8rxOSOOYAGWZbZoXBPse1t3STR9yOgtEjY5YLREf23OtS0RRV0v
 N6C7/pk/UGuTXSsnM46xyodgnSMGwWrcij7MyYRZZ1Np/upQH5/1YIfJXXwkomN2NDEC
 j14T4tJXf5hGsVjS12UdRQxYN9WibKlLZ7cuRCJYw+cBL+73dQsLdeeXuXrMOHxn1lnq
 Bc5jL5i0w5XDcebXyN6MwFwJazFcblkheT1WtT0D9U4+tSmwcs/XVQ20Pwe4XhffSnSI
 mtJAztGPu+0y1ZQ9aRu5b114J6yy3/sF9RRO2U3B94Szk5eBsJYRTCql4mhKABoMO9mj
 WLwg==
X-Gm-Message-State: AOAM532Cjk9FyMAh1Ph5gVUZu6kVcL5RZPiAAa1q2pts66MUUSD74Fkc
 LU37WgTDFHbMdC2UaZaZ9rMf2hTjcAxtOA==
X-Google-Smtp-Source: ABdhPJxmaasoGq2r0NV2rJ2gM2vKa93DMcKl2L+uSImOPLZd8TXUisygF0ba4SClaxCVIoaZZ4OxxQkMcxetyw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:d943:: with SMTP id
 e3mr1310151pgj.427.1643252944210; Wed, 26 Jan 2022 19:09:04 -0800 (PST)
Date: Wed, 26 Jan 2022 19:08:54 -0800
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
Message-Id: <20220127030858.3269036-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 1/5] kvm: selftests: aarch64: fix assert in gicv3_access_reg
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

The val argument in gicv3_access_reg can have any value when used for a
read, not necessarily 0.  Fix the assert by checking val only for
writes.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 00f613c0583c..e4945fe66620 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -159,7 +159,7 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 	uint32_t cpu_or_dist;
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
-	GUEST_ASSERT(*val < (1U << bits_per_field));
+	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
 	/* Some registers like IROUTER are 64 bit long. Those are currently not
 	 * supported by readl nor writel, so just asserting here until then.
 	 */
-- 
2.35.0.rc0.227.g00780c9af4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
