Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763041A629
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 19:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21631C433D6;
	Thu, 10 Nov 2022 19:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668107014;
	bh=JgjPNMsT0WSQCwCn0ZQGT0/MFqkRr7GuwaW4Dnu5rVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkPekOPYPdgKhNfQ0gIkDI57HbSIivzyKO2LUyIQ8gH9935eTQmB05D8Q9M9DUCl1
	 CgM/TXolElVh+H+a7GC9/PYZnV8G/PQM62QtNPo1ik31pi+tys/nIylBBZp8b+VZNP
	 gvcczqPxHnUFYsgNE1z88RKuz7yvDNvM2T0uaEdTETQSMtmC6OFlcP59eYv1BM5Bi2
	 luJV8n3XweV53K25Tg0kbdRtKDXtG9TqvzPFanzh0MjyvOJXkuLKpOFeoQJoAHVu/T
	 ikVVmXYEIV6L3ITBxtIXg2CfrXiTFC4LEjNgkQsIhyDUPkool8PstGOH5Pq3CqtBrH
	 Tp5Cgpaar49Jg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Quentin Perret <qperret@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kernel-team@android.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 07/26] KVM: arm64: Prevent the donation of no-map pages
Date: Thu, 10 Nov 2022 19:02:40 +0000
Message-Id: <20221110190259.26861-8-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221110190259.26861-1-will@kernel.org>
References: <20221110190259.26861-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Quentin Perret <qperret@google.com>

Memory regions marked as "no-map" in the host device-tree routinely
include TrustZone carev-outs and DMA pools. Although donating such pages
to the hypervisor may not breach confidentiality, it could be used to
corrupt its state in uncontrollable ways. To prevent this, let's block
host-initiated memory transitions targeting "no-map" pages altogether in
nVHE protected mode as there should be no valid reason to do this in
current operation.

Thankfully, the pKVM EL2 hypervisor has a full copy of the host's list
of memblock regions, so we can easily check for the presence of the
MEMBLOCK_NOMAP flag on a region containing pages being donated from the
host.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 10069cd32787..f7e3afaf9f11 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -193,7 +193,7 @@ struct kvm_mem_range {
 	u64 end;
 };
 
-static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
+static struct memblock_region *find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 {
 	int cur, left = 0, right = hyp_memblock_nr;
 	struct memblock_region *reg;
@@ -216,18 +216,28 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 		} else {
 			range->start = reg->base;
 			range->end = end;
-			return true;
+			return reg;
 		}
 	}
 
-	return false;
+	return NULL;
 }
 
 bool addr_is_memory(phys_addr_t phys)
 {
 	struct kvm_mem_range range;
 
-	return find_mem_range(phys, &range);
+	return !!find_mem_range(phys, &range);
+}
+
+static bool addr_is_allowed_memory(phys_addr_t phys)
+{
+	struct memblock_region *reg;
+	struct kvm_mem_range range;
+
+	reg = find_mem_range(phys, &range);
+
+	return reg && !(reg->flags & MEMBLOCK_NOMAP);
 }
 
 static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
@@ -346,7 +356,7 @@ static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot pr
 static int host_stage2_idmap(u64 addr)
 {
 	struct kvm_mem_range range;
-	bool is_memory = find_mem_range(addr, &range);
+	bool is_memory = !!find_mem_range(addr, &range);
 	enum kvm_pgtable_prot prot;
 	int ret;
 
@@ -424,7 +434,7 @@ static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
 	struct check_walk_data *d = arg;
 	kvm_pte_t pte = *ptep;
 
-	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
+	if (kvm_pte_valid(pte) && !addr_is_allowed_memory(kvm_pte_to_phys(pte)))
 		return -EINVAL;
 
 	return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
-- 
2.38.1.431.g37b22c650d-goog

