Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F71B7E
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 08:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23712C4339E;
	Thu, 13 Apr 2023 08:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681373691;
	bh=1TLRUE6hxNsNLutNh1cOZu+lay+ak1KILzdQaIgRJ1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfVRViDKJ5NarJdzVtwi99l9ZN86tJDpsnCU0pjCH/caGVjn+U7JeABmdgkE5/Kkk
	 /dpnwc3H0d0Fs5hsphLtVrRW75TTx3V5QtpJbOTHk8bYxQDfjqLntETGvISJxtI25N
	 R4wFX4zfEEUOo12xA1Z4L+p9Wt8BqZj9xyYdYW+HnFNrZ2+eSxjsfmpNyMquIJ6XYC
	 DZILX+jNtXYXxV65i+UqQoelYRm3z2ydvIVYpsXprg6tOyd2AdSs3EYiDebZVwcfJH
	 /zEBM33yiqxSX2VHwKuvSkjeVU1hQ50BYJ3vlbCL/SAclQ3po5aK4nyfrml0uthwR3
	 0azvvC5LNwx5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pms6T-0082qd-Af;
	Thu, 13 Apr 2023 09:14:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Ricardo Koller <ricarkol@google.com>
Subject: [PATCH v3 5/5] KVM: arm64: vhe: Drop extra isb() on guest exit
Date: Thu, 13 Apr 2023 09:14:41 +0100
Message-Id: <20230413081441.165134-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230413081441.165134-1-maz@kernel.org>
References: <20230413081441.165134-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

__kvm_vcpu_run_vhe() end on VHE with an isb(). However, this
function is only reachable via kvm_call_hyp_ret(), which already
contains an isb() in order to mimick the behaviour of nVHE and
provide a context synchronisation event.

We thus have two isb()s back to back, which is one too many.
Drop the first one and solely rely on the one in the helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index cd3f3117bf16..3d868e84c7a0 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -227,11 +227,10 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/*
 	 * When we exit from the guest we change a number of CPU configuration
-	 * parameters, such as traps.  Make sure these changes take effect
-	 * before running the host or additional guests.
+	 * parameters, such as traps.  We rely on the isb() in kvm_call_hyp*()
+	 * to make sure these changes take effect before running the host or
+	 * additional guests.
 	 */
-	isb();
-
 	return ret;
 }
 
-- 
2.34.1

