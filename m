Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F92B63CE
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F63C433C7;
	Mon, 24 Jul 2023 12:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690201136;
	bh=YzbNbz001bsuZJHb7mliu62Hj7vauK4wh8AaumbnPAA=;
	h=From:To:Cc:Subject:Date:From;
	b=Kw8PsT3wtcqo4pvvE99Z0kL7peS/vy7EfU+HWuVYfFptTDPAL03xwb0JVD23cTGUJ
	 iPS2bCnYfoz9bf1LswQ9Qqan3kXSa6UxGHTuKl1kDlVGa8N7wKdsbYjEl/Oi1tcuMA
	 xBl74bjrLa+Mf7Q5++Q4WFWLK0jePgn6Lqny9mfV7Pt1B5aEmDVDMneFBCZ4voyzjg
	 4pp7lZqJy5Dpvboryz3uoAlyXLMaUdGfDHVL8EyOvvhGzy1VqX2A9bq4BdCTfbbvKf
	 1q5WSQzv/86GNfImKaIVJGYMnlPZCuLB1wxxv9jilgFlDfKX2O3oB+Sfv6EgxrXFmU
	 viRu/dmvHxVFA==
From: Arnd Bergmann <arnd@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mostafa Saleh <smostafa@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Quentin Perret <qperret@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: fix __kvm_host_psci_cpu_entry() prototype
Date: Mon, 24 Jul 2023 14:18:42 +0200
Message-Id: <20230724121850.1386668-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The kvm_host_psci_cpu_entry() function was renamed in order to add a wrapper around
it, but the prototype did not change, so now the missing-prototype warning came
back in W=1 builds:

arch/arm64/kvm/hyp/nvhe/psci-relay.c:203:28: error: no previous prototype for function '__kvm_host_psci_cpu_entry' [-Werror,-Wmissing-prototypes]
asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)

Fixes: dcf89d1111995 ("KVM: arm64: Add missing BTI instructions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/kvm_asm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 7d170aaa2db41..24e28bb2d95b6 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -278,7 +278,7 @@ asmlinkage void __noreturn hyp_panic_bad_stack(void);
 asmlinkage void kvm_unexpected_el2_exception(void);
 struct kvm_cpu_context;
 void handle_trap(struct kvm_cpu_context *host_ctxt);
-asmlinkage void __noreturn kvm_host_psci_cpu_entry(bool is_cpu_on);
+asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on);
 void __noreturn __pkvm_init_finalise(void);
 void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
 void kvm_patch_vector_branch(struct alt_instr *alt,
-- 
2.39.2

