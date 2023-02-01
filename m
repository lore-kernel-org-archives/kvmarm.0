Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DEB2F45
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:53 +0000 (UTC)
Received: by mail-wr1-f53.google.com with SMTP id y1so17249800wru.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3XQ8jSpys2Hws9/7ixJG0IKBklTR26Fi7D4CXfNjCZM=;
        b=GWi08w8bd79vvKrXk4BmiTVSIiEylmmpgFWd2pmPUbgeLTqOFj0BxthGC7YaErnCgM
         +3wzH8OdCcZne3jjsM3iX6FsHh2Qw19742RfrWV0OYuOAdgikEKePVcpTnrnNNpv/OFZ
         Qt8b8r18XGgsfkaJBSyC7bENzqhfBnWrK4JVC1xFCtwNme4oMvRC7uUW2QKOCgcEY76Z
         0gj8tAD4dK4bj/e/ok5esM2nOlSukbC74w2yWTnJYK0GaPyR7G03JlruX/JPDpt9wXFA
         xB8eodzYviO5c6lRMG/LMY/TCARvCBwZnKsSutQ33xe3LQZYEABHMW6UqQOzFKEQJAZD
         GGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3XQ8jSpys2Hws9/7ixJG0IKBklTR26Fi7D4CXfNjCZM=;
        b=Q6aG5/ghzupPivZWQNKPIVMhmEtfRS6RYtMiw5wB2nH3NgIzX39Pr4w/yTx9QHZuwG
         49Ce6lbpaKBOyLHbDBfbHd1FI4kdo6svS6L7fI9FLBJrQPRX2VhV7IRGeegwNmGABImF
         mFOI6MnpQT2lck3WvvxzCtObrYoKL+YWzPUPQ3UVqwzna7kFmKktl2M/eE1IsYGZDYBz
         HYR3BsyIIr/GnacFiGksxUxLmphTCthEfccb6LICJkZ2r9bY3UZVpDJ5gyZm5RjyFkJ6
         uaSnrjv3SvalpSamsy4FyOKjr50t0HDPAJEAHerHjhA3Il5Oo30dT+Lgyh1ZZegfj5H2
         oCYw==
X-Gm-Message-State: AO0yUKW9josxaJ01d5vC5kyYDj/LX/JkdUAOsJ7KpgevUXyFnd5OnivW
	8eFG7QPKDExXYD+PTrqU3TAfQw==
X-Google-Smtp-Source: AK7set+p3RZCyUqjM7HvNLHrPv8GDGafCYhqQ48BWrrnF24tXgDMI5DbpRPrwpMXGq/D5XyaJddJZw==
X-Received: by 2002:a5d:4c49:0:b0:2bd:ed75:808c with SMTP id n9-20020a5d4c49000000b002bded75808cmr5620860wrt.38.1675256391893;
        Wed, 01 Feb 2023 04:59:51 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:51 -0800 (PST)
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
Subject: [RFC PATCH 41/45] KVM: arm64: pkvm: Add __pkvm_host_add_remove_page()
Date: Wed,  1 Feb 2023 12:53:25 +0000
Message-Id: <20230201125328.2186498-42-jean-philippe@linaro.org>
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

Add a small helper to remove and add back a page from the host stage-2.
This will be used to temporarily unmap a piece of shared sram (device
memory) from the host while we handle a SCMI request, preventing the
host from modifying the request after it is verified.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index a363d58a998b..a7b28307604d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -75,6 +75,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *hyp_vcpu, u64 ipa);
 int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *hyp_vcpu, u64 ipa);
 int __pkvm_host_share_dma(u64 phys_addr, size_t size, bool is_ram);
 int __pkvm_host_unshare_dma(u64 phys_addr, size_t size);
+int __pkvm_host_add_remove_page(u64 pfn, bool remove);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index dcf08ce03790..6c3eeea4d4f5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1954,3 +1954,20 @@ int __pkvm_host_reclaim_page(u64 pfn)
 
 	return ret;
 }
+
+/*
+ * Temporarily unmap a page from the host stage-2, if @remove is true, or put it
+ * back. After restoring the ownership to host, the page will be lazy-mapped.
+ */
+int __pkvm_host_add_remove_page(u64 pfn, bool remove)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u8 owner = remove ? PKVM_ID_HYP : PKVM_ID_HOST;
+
+	host_lock_component();
+	ret = host_stage2_set_owner_locked(host_addr, PAGE_SIZE, owner);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.39.0

