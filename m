Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD36D50C
	for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 17:03:43 +0000 (UTC)
Received: by mail-ed1-f73.google.com with SMTP id z15-20020a05640240cf00b00461b253c220so12802624edb.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 09:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=a3MXKKuWStfRtq6RuTXYEk9eQ6tMlejkQS8AIRBSHeJj02rUkmTQMr6lFokgPBYP2s
         7djLRkF6axlyzhmXbkRTJ8zzT9/mV2d0qPB7xLjyiapuiouPVKAk34N3ys+IFuIV9rQ8
         f5gacj6oJYwHTyRJGnt2AlEiYDkyUuyX1OtyYOHJT07yXqd++/FWqghhyO6POH1yPLci
         LMFaYKccCpdeLxr0M69NblCSWQhOht7h0rrw8+uFxm9CAAcaZmVkh/eqldwl8Zi+iZZ7
         ZljLNn9lufdNXQjZM7RmCgz14QZk1OIXKqbpL/bz0891i5SDaUH14kCz3jAJW463wgqT
         QaRg==
X-Gm-Message-State: ANoB5pm7f8p/QyKwIghCD5XQ13xeFUd7UQHKiqIl9GMHqiFfk1BFa4Bw
	IPPVxts3sSpgodzPSUaekUqeAF1EAXXz
X-Google-Smtp-Source: AA0mqf6QO3MDsO7JzLptdiGQKZSsnQfuLfYcQHIY4zJIFRNqovseLoflW/BcyRmShwPFqqN6vg48qiCIOxkh
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:907:8c15:b0:78d:9e04:d8c2 with SMTP id
 ta21-20020a1709078c1500b0078d9e04d8c2mr17680562ejc.614.1668618223040; Wed, 16
 Nov 2022 09:03:43 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:25 +0000
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221116170335.2341003-1-qperret@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-3-qperret@google.com>
Subject: [PATCH 02/12] firmware: arm_ffa: Move comment before the field it is documenting
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Andrew Walbran <qwandor@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221116170325.yNIO4fjRGaSQ0Su78wkvf38JaM1V-zwCsACynvVsX-k@z>

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

