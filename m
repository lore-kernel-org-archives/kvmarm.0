Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859131A629
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 19:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293FEC43470;
	Thu, 10 Nov 2022 19:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668107025;
	bh=9k8/sPRwAUxVgNQjSTnI7ywjADt90l5tppp1aip6mdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTi/Hf84Vy+VWu9hpaGWuHkfvicFUfV9DsbCdu5qpupNkNWATg6oRl/6zDsLN6T6j
	 CwiHaN5Eptw6sdukQ1p3sPa2KY+uADScJVA84oXqhptuBcBhZo/dvtLT1WmRo3oR7E
	 FNf7RNFm/htN8j7KaiTkBfAFhVI6W73XhURKcwUp4mWzd6VGRknyb5NxeBNxaR8e5w
	 sC7+gMpgAGAjf1L1mOeh3xleekEgulWcfCt4AtNOklHLoAzRnACzr2BdoA9F3v4Dvs
	 EFR92jfxFdnCmVIpa+5pTucM9NZkeZTvzAGpUH5rdq2I+t04Z/Cv/gY72X4mT8Fn24
	 AvsYuBpD3tFVQ==
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
Subject: [PATCH v6 10/26] KVM: arm64: Add hyp_spinlock_t static initializer
Date: Thu, 10 Nov 2022 19:02:43 +0000
Message-Id: <20221110190259.26861-11-will@kernel.org>
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
2.38.1.431.g37b22c650d-goog

