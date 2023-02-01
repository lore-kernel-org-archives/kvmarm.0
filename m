Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0680D2F5E
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:30 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id bk16so17210039wrb.11
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTVD2fQtd31jg24PflRIs2adMeiXA9dKMS0aZE3JHMI=;
        b=HgseBKQJR3mUP4ey4NQiqlt22BAAegJr70aI92CwFpJAsdt0eLdcdkeX4f0PdvjHrp
         Zj1aAgh/KUpylBjc5xQXtKIG2A/Nwa/2YINMMc3PtWgMR/N4QpRe0ODXXfSJrAXEDUtz
         xERnKveM4HB3z7TGKqVKpIc6rg0joIdZU1zmjyIDTn4eXa+wA3lZg/+fA7rFvBX6rxY0
         0IQBXXWZsFDBElNLhlItHdshDMESxCzOp5LE/CQ9ja9Rty5K+toEHeTpBzYoB3ri2g7t
         gtywvnEpfqPDNv+mKroN/cCOtastA+PJD+XFtNCz38u9spceEJotlwv8BZo4Fh3eW/40
         6H3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yTVD2fQtd31jg24PflRIs2adMeiXA9dKMS0aZE3JHMI=;
        b=N/ePw5l9n4IKAD2Pr6a5e3NxqKKQwcvbkyz8mTRx7btWFtH/qMEHMUB1ylx5YUgOL8
         QqPcRortCTBnOOyMmYpsma2vk4atoS5KMLrB0HXJsQuTZW9IU87lE6pgUA/BOBbaPope
         YuVfZuY8n9wW1InjBEFBLrVTEr312f9f+wUJK9CLXT0vicNZA0oE7YS9jcCfbdo2Ci1c
         FGLrpimY4QmAElv7X0bvwfECDJDJFSqKCJ9wxQpbsy2D7H42scRAnx6NwlpuzxsDDL/J
         jApwTmmp+6JOvhFrCfjbU7vez3MBRgMs7pFSc8fO8YArTWZd08MTwLsQTy/kvPofzOaZ
         Z/Hw==
X-Gm-Message-State: AO0yUKW9IcJ7WRIZkir0P85KUVjHivT0IbainF76GwxLnuk0IY3oYN8a
	M1m9EurRsoT9t0E/KfVsnNho/Q==
X-Google-Smtp-Source: AK7set+anVUapcTWowjU9gRbchOJLs0dsis9UuqvCSYhzwBfEh+gNQ4gaKCP92MQeUd1Iw/kaXXq4A==
X-Received: by 2002:adf:c754:0:b0:2bf:d554:30c9 with SMTP id b20-20020adfc754000000b002bfd55430c9mr2456675wrh.21.1675256369585;
        Wed, 01 Feb 2023 04:59:29 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:29 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 13/45] KVM: arm64: pkvm: Add hyp_page_ref_inc_return()
Date: Wed,  1 Feb 2023 12:52:57 +0000
Message-Id: <20230201125328.2186498-14-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a page_ref_inc() helper that returns an error on saturation instead
of BUG()ing. There is no limit in the IOMMU API for the number of times
a page can be mapped. Since pKVM has this limit at 2^16, error out
gracefully.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index a8d4a5b919d2..c40fff5d6d22 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -57,10 +57,21 @@ static inline int hyp_page_count(void *addr)
 	return p->refcount;
 }
 
+/*
+ * Increase the refcount and return its new value.
+ * If the refcount is saturated, return a negative error
+ */
+static inline int hyp_page_ref_inc_return(struct hyp_page *p)
+{
+	if (p->refcount == USHRT_MAX)
+		return -EOVERFLOW;
+
+	return ++p->refcount;
+}
+
 static inline void hyp_page_ref_inc(struct hyp_page *p)
 {
-	BUG_ON(p->refcount == USHRT_MAX);
-	p->refcount++;
+	BUG_ON(hyp_page_ref_inc_return(p) <= 0);
 }
 
 static inline void hyp_page_ref_dec(struct hyp_page *p)
-- 
2.39.0

