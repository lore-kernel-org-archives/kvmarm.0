Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BC235EDA5
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826881; cv=none; b=M0XVWWRQt1dJgAym1+HxtkQYLadgwTDc39HJMl2Q6Jkbo0KhiqYY6NF3WgfOTjeAdpN8ER5Gi1mAqxbBm26JVz8CeYQfz75GZh8M1d6MAPwUaBIVZoiq/GgIdfbhV9oO+5enZtW0YImxcqpNY1qFmnzPJjc//bO7Xt5RX9bCmxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826881; c=relaxed/simple;
	bh=rCOXphOI3XK5NnEllmo3VoHDVO0FW1vpq5O+0ieRUpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWoIRyMmDzbodW1nSOzC07VwbOHxFTD89YOWHDZ3ln8ElJHIdqzhvzeE85lgUVuLaRSz4HNozcRFT0sL/0mupDKRKYMNpw3YBN8g+fi2jc1YxSB267qn5ucSczUsO6+6Xtj5FIMngPYgeNqxjtVXQ0ipt2jN8wEQ0GROOi8gDUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+WpvLTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+WpvLTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BACBC19423;
	Mon, 19 Jan 2026 12:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826881;
	bh=rCOXphOI3XK5NnEllmo3VoHDVO0FW1vpq5O+0ieRUpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+WpvLTFQhrGPx0xi1BvJMivvp00zo/X4d1UCM9uPt4jAwVgDlqhyLUmiejG4PLyL
	 VrxI8K94/3rV3bBzoK59aC9F0qnGzK09jOkE1mtcutqIiMynnESfRGf05GLA1DLXvm
	 WtmYOyRWAAyIkGJ5kM24yERZy9MZrDnwDwu1kpt4tVTGnCtj6XRi18HW9wyH6taZu8
	 2MjF5YOJmXQecsvzpbDhxnlQW+Pw6SH6VOPfrb7wPpMZc2RhV6or+aNDY//j5eomAp
	 GbIUvvaLyuwBZe20yjZviluvzhhN5RVcvclzXgUG262URiayk+4JhZxMtNYFgYq5fk
	 5f1bTbnmWyNTg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 22/35] KVM: arm64: Change 'pkvm_handle_t' to u16
Date: Mon, 19 Jan 2026 12:46:15 +0000
Message-ID: <20260119124629.2563-23-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'pkvm_handle_t' doesn't need to be a 32-bit type and subsequent patches
will rely on it being no more than 16 bits so that it can be encoded
into a pte annotation.

Change 'pkvm_handle_t' to a u16 and add a compile-type check that the
maximum handle fits into the reduced type.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3191d10a2622..60a5c87b0a17 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -247,7 +247,7 @@ struct kvm_smccc_features {
 	unsigned long vendor_hyp_bmap_2; /* Function numbers 64-127 */
 };
 
-typedef unsigned int pkvm_handle_t;
+typedef u16 pkvm_handle_t;
 
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 9f0997150cf5..c5772417372d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -223,6 +223,7 @@ static struct pkvm_hyp_vm **vm_table;
 
 void pkvm_hyp_vm_table_init(void *tbl)
 {
+	BUILD_BUG_ON((u64)HANDLE_OFFSET + KVM_MAX_PVMS > (pkvm_handle_t)-1);
 	WARN_ON(vm_table);
 	vm_table = tbl;
 }
-- 
2.52.0.457.g6b5491de43-goog

