Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650CF1E52D
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 10:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DA4C433EF;
	Tue, 23 May 2023 10:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684837128;
	bh=Mmlqv0ANhcPLl4mKcN4ZvQAijiK59/HWKAkdzlhZNUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOG/dy1TcuS/tahyLHNgciz3FvfXXXj+EPq55+g5hKcLH1/WgqjBqsq+G4dvMHyZS
	 3tHxCJxa4YoHj1wnFvtNKugaO9l7ewXsB6/nIj3YFjIBz/dKh+Tc+RZ/iDUnQWwIIQ
	 6FfOuT8+LeSiG63GyeDsH4TvYTbsmNKeuHROIPRjyEDfdy4HsmzKLOdBtNBRVi/cqj
	 Dl89l/R+hrLwww3P5zyPOJDaJvMeA7evoK2sA0cjhdUPbVEDSnZm0AA8JeKoaeEaJp
	 9AGzzvaVpFeHgZhOApPceK0Xq831qKThSCHcVBJQ9x9EQVkpGgwOvX33iWE9de0GnP
	 JtASt5wcwQXLg==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	kernel-team@android.com,
	Andrew Walbran <qwandor@google.com>
Subject: [PATCH v3 05/10] KVM: arm64: Add FF-A helpers to share/unshare memory with secure world
Date: Tue, 23 May 2023 11:18:22 +0100
Message-Id: <20230523101828.7328-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230523101828.7328-1-will@kernel.org>
References: <20230523101828.7328-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend pKVM's memory protection code so that we can update the host's
stage-2 page-table to track pages shared with secure world by the host
using FF-A and prevent those pages from being mapped into a guest.

Co-developed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  3 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 68 +++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index b7bdbe63deed..0972faccc2af 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -57,6 +57,7 @@ extern struct host_mmu host_mmu;
 enum pkvm_component_id {
 	PKVM_ID_HOST,
 	PKVM_ID_HYP,
+	PKVM_ID_FFA,
 };
 
 extern unsigned long hyp_nr_cpus;
@@ -66,6 +67,8 @@ int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
+int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
+int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2e9ec4a2a4a3..e327e94d0e40 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -842,6 +842,13 @@ static int check_share(struct pkvm_mem_share *share)
 	case PKVM_ID_HYP:
 		ret = hyp_ack_share(completer_addr, tx, share->completer_prot);
 		break;
+	case PKVM_ID_FFA:
+		/*
+		 * We only check the host; the secure side will check the other
+		 * end when we forward the FFA call.
+		 */
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -870,6 +877,13 @@ static int __do_share(struct pkvm_mem_share *share)
 	case PKVM_ID_HYP:
 		ret = hyp_complete_share(completer_addr, tx, share->completer_prot);
 		break;
+	case PKVM_ID_FFA:
+		/*
+		 * We're not responsible for any secure page-tables, so there's
+		 * nothing to do here.
+		 */
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -918,6 +932,10 @@ static int check_unshare(struct pkvm_mem_share *share)
 	case PKVM_ID_HYP:
 		ret = hyp_ack_unshare(completer_addr, tx);
 		break;
+	case PKVM_ID_FFA:
+		/* See check_share() */
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -946,6 +964,10 @@ static int __do_unshare(struct pkvm_mem_share *share)
 	case PKVM_ID_HYP:
 		ret = hyp_complete_unshare(completer_addr, tx);
 		break;
+	case PKVM_ID_FFA:
+		/* See __do_share() */
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1235,3 +1257,49 @@ void hyp_unpin_shared_mem(void *from, void *to)
 	hyp_unlock_component();
 	host_unlock_component();
 }
+
+int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
+{
+	int ret;
+	struct pkvm_mem_share share = {
+		.tx	= {
+			.nr_pages	= nr_pages,
+			.initiator	= {
+				.id	= PKVM_ID_HOST,
+				.addr	= hyp_pfn_to_phys(pfn),
+			},
+			.completer	= {
+				.id	= PKVM_ID_FFA,
+			},
+		},
+	};
+
+	host_lock_component();
+	ret = do_share(&share);
+	host_unlock_component();
+
+	return ret;
+}
+
+int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
+{
+	int ret;
+	struct pkvm_mem_share share = {
+		.tx	= {
+			.nr_pages	= nr_pages,
+			.initiator	= {
+				.id	= PKVM_ID_HOST,
+				.addr	= hyp_pfn_to_phys(pfn),
+			},
+			.completer	= {
+				.id	= PKVM_ID_FFA,
+			},
+		},
+	};
+
+	host_lock_component();
+	ret = do_unshare(&share);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.40.1.698.g37aff9b760-goog

