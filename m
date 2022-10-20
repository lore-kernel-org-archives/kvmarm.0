Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCB73C20
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 13:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDD6C433B5;
	Thu, 20 Oct 2022 13:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666273154;
	bh=MMjRrjYVX1bvz+140SYSa0WRofK/Okrgc32KusZO28o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enIzV/B4jHVUe/VxCA/+0JvuLQqJKO5Owf6R8R9BNbLv1T8YpCPBrW/VDKCZ4FntH
	 UIcyRAjVtPV7qGAW+vFgzgah8nRF8lgyBS82Ey8gnizgzcudtMB4VUcwp4nscnuVus
	 R+RWbtE8JOMkoTMzxfH7GVs0aVFmYbfsPo4YkroS6lFh5EMKtQfq0Ht3tc3b+iPRK1
	 aXZLjiG/anFz/cVG+tJtZZ3s0CkJ0FPdSXU3QGqBYT78M9cDFO8SOINZ0uostF7QM/
	 lhI8qasToXQUlHYTrH1317pTkz06BIGZaUZj977cUl4TBujMnwESOP19f05QGHC4Pr
	 PlPbGX91Lepsw==
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
Subject: [PATCH v5 10/25] KVM: arm64: Add hyp_spinlock_t static initializer
Date: Thu, 20 Oct 2022 14:38:12 +0100
Message-Id: <20221020133827.5541-11-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221020133827.5541-1-will@kernel.org>
References: <20221020133827.5541-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fuad Tabba <tabba@google.com>

Introduce a static initializer macro for 'hyp_spinlock_t' so that it is
straightforward to instantiate global locks at EL2. This will be later
utilised for locking the VM table in the hypervisor.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
index 4652fd04bdbe..7c7ea8c55405 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -28,9 +28,17 @@ typedef union hyp_spinlock {
 	};
 } hyp_spinlock_t;
 
+#define __HYP_SPIN_LOCK_INITIALIZER \
+	{ .__val = 0 }
+
+#define __HYP_SPIN_LOCK_UNLOCKED \
+	((hyp_spinlock_t) __HYP_SPIN_LOCK_INITIALIZER)
+
+#define DEFINE_HYP_SPINLOCK(x)	hyp_spinlock_t x = __HYP_SPIN_LOCK_UNLOCKED
+
 #define hyp_spin_lock_init(l)						\
 do {									\
-	*(l) = (hyp_spinlock_t){ .__val = 0 };				\
+	*(l) = __HYP_SPIN_LOCK_UNLOCKED;				\
 } while (0)
 
 static inline void hyp_spin_lock(hyp_spinlock_t *lock)
-- 
2.38.0.413.g74048e4d9e-goog

