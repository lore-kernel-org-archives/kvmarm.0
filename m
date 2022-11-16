Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A79DBC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 17:03:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 426314B862;
	Wed, 16 Nov 2022 12:03:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SmYFY86aa2mq; Wed, 16 Nov 2022 12:03:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4A84B890;
	Wed, 16 Nov 2022 12:03:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39FE84B866
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:03:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CrJQkb7Mvm50 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 12:03:47 -0500 (EST)
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com
 [209.85.208.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCC7E4B89C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:03:43 -0500 (EST)
Received: by mail-ed1-f74.google.com with SMTP id
 y20-20020a056402271400b004630f3a32c3so12878873edd.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 09:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=ZZfWEaD62D9o2yY+d8fPCV/TvX2mmnJ/lA4TWGZpU/Y=;
 b=owF7hcDYc7ARmaK3i4us45Buk3Hh4AaTv5/+cKPRjHVZDIsgAhyaaD8kUAeUCfxSO2
 i34X8FsVMm6muOHaIq3236zRzgJxUIIVryWbc2zaClYOFG+cg2kubcLxii5YzeBJ/Wrb
 6XN+W6iPnAXY4mwrIR2eERMKLpuNuF2/WSzaFKJUP5zVeqebPik7UrCEc8nmyl9o+/QX
 rVi4S1f2Bl6lq9gEqZHRpokRv9qHjUua4dbVaLgePsKR8mzYVbxv/j24DM6IAAtCetIJ
 e+axcpBqUiKKMYaoUZeUmyYLnvJmFgcHinFuYHvL3lHYSGhSKFyJRdi9y+aYHde6hcCU
 BTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ZZfWEaD62D9o2yY+d8fPCV/TvX2mmnJ/lA4TWGZpU/Y=;
 b=vV4qEywqp59WZAixGJ2gydizol2NNC4QrcGy+99X0yFYyW9wPxP/dKa+nHEPfCdsDO
 puinD7rEUrbN39Kzr6fv98jysfDkJZ/VdBLUAu0k8jnb2wC4ckvI6J8vwf5b+DGJtEl3
 8Gaj12rwmeZ79k1flzJ1iqko+seMYwZZQ2QaBZoThaV/RJEW/uVJmqJ9+qbNMGj8kfL3
 m9I7cqVwjerKmnIsxVDFB7J5q9o+OPDYj78AzAVpcVyomPRIuBDMocSQDpVw42ugC9Q3
 Cug5k+qeuQ1k3vB8XBRIMDtqPHAdu64eO+7hzFH7FO3dt4KdR1d2ZiyRJN0NDYdmQOjS
 SYLw==
X-Gm-Message-State: ANoB5pmuJzxEketejBO9UYMimfj6E6Z8mGuPjkH1zBbHvzc6WzSYqHbD
 rcZtutJG211/6ARfum+SBUBMMj7Fw/cV
X-Google-Smtp-Source: AA0mqf6QO3MDsO7JzLptdiGQKZSsnQfuLfYcQHIY4zJIFRNqovseLoflW/BcyRmShwPFqqN6vg48qiCIOxkh
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:907:8c15:b0:78d:9e04:d8c2 with SMTP id
 ta21-20020a1709078c1500b0078d9e04d8c2mr17680562ejc.614.1668618223040; Wed, 16
 Nov 2022 09:03:43 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:25 +0000
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
Mime-Version: 1.0
References: <20221116170335.2341003-1-qperret@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-3-qperret@google.com>
Subject: [PATCH 02/12] firmware: arm_ffa: Move comment before the field it is
 documenting
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
 Andrew Walbran <qwandor@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

From: Will Deacon <will@kernel.org>

This is consistent with the other comments in the struct.

Co-developed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 include/linux/arm_ffa.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index daff44d777fa..c87aeecaa9b2 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -244,11 +244,11 @@ struct ffa_mem_region_attributes {
 	 */
 #define FFA_MEM_RETRIEVE_SELF_BORROWER	BIT(0)
 	u8 flag;
-	u32 composite_off;
 	/*
 	 * Offset in bytes from the start of the outer `ffa_memory_region` to
 	 * an `struct ffa_mem_region_addr_range`.
 	 */
+	u32 composite_off;
 	u64 reserved;
 };
 
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
