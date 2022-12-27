Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C4D28FA
	for <kvmarm@lists.linux.dev>; Tue, 27 Dec 2022 14:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F315DC43396;
	Tue, 27 Dec 2022 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672151650;
	bh=sG9v2Kt6FCDopacILFBaWr43bInSjVesEWi3vJNnqW4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ql5BiyIX48YzftPSFqt6JMm9s+SE9cyeMtoJj8ABqFWIT8glzycmauwdBDpRoucfq
	 KLOJfrpdIUVeOll/uL4x5gTwlJICF24BIrrum5cthr9kgujRusajhsklEIolz9YnGA
	 5F4t/Y0VT7fglOvQir3yoBesSKjvvToPHEFtzMHTZjMThuMKYgxAbYp2/MOKU1Dciu
	 HIqEsW/k29bMwK+rU+l6UIcny0IYHacEct+Z1vKUhLKuJ/2fQzjpoDkS+CPj7OcnvD
	 v1eYQAb+aGKQXKvo9AvsfzLhF5f00aM8tznKN3yeKYh3MDN6GnRge4uvxmgUT1FI/Z
	 36pN7qx1cugOQ==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 27 Dec 2022 14:33:38 +0000
Subject: [PATCH 1/3] KVM: arm64: Document check for TIF_FOREIGN_FPSTATE
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id:
 <20221214-kvm-arm64-sme-context-switch-v1-1-383b4699de06@kernel.org>
References:
 <20221214-kvm-arm64-sme-context-switch-v1-0-383b4699de06@kernel.org>
In-Reply-To:
 <20221214-kvm-arm64-sme-context-switch-v1-0-383b4699de06@kernel.org>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.12-dev-7ab1d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1080; i=broonie@kernel.org;
 h=from:subject:message-id; bh=sG9v2Kt6FCDopacILFBaWr43bInSjVesEWi3vJNnqW4=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhuTVTFG+b5jjFj36tUB09rTe2eG1H++/KroWfVNXqvipTb7X
 9NqLnYzGLAyMXAyyYoosa59lrEoPl9g6/9H8VzCDWJlApjBwcQrARDz2s/+VOKDNxvzHOOqFfkx46o
 TlTC+27urdcoK3Ol3qoF1hgzvjc9Od9lYTLFf6hLBOlw3anVx14eK6v5EFM1zmNonwm/BX+P28OXFz
 0PEZfXJWm0u/6ts+kpNdaS+Rt9eC8XBIjPJvkZBDbXa5rBvjijJFCqW3POy5WzZ7anCtYv16gbK3D4
 23L7aX7AmfIPb42lbhbS42CxuFt2QWS7o++HNyszLP5LgGJz3ZbzZJRsskJvqeiJ/At0rT2OjmvdRs
 zwv5Hoc8K/l0c1b21rjczS7QO7ns1LLunvVGTafOdSRysMUo2RW6slXHdX8SvDn9rmZ4hjVH4T8lmd
 Lcv7/09BecWLm/wMjmxKwY1ZZaAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In kvm_arch_vcpu_load_fp() we unconditionally set the current FP state
to FP_STATE_HOST_OWNED, this will be overridden to FP_STATE_NONE if
TIF_FOREIGN_FPSTATE is set but the check is deferred until
kvm_arch_vcpu_ctxflush_fp() where we are no longer preemptable. Add a
comment to this effect to help avoid people being concerned about the
lack of a check and discover where the check is done.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 02dd7e9ebd39..6c1cb945c777 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -81,6 +81,11 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 
 	fpsimd_kvm_prepare();
 
+	/*
+	 * We will check TIF_FOREIGN_FPSTATE just before entering the
+	 * guest in kvm_arch_vcpu_ctxflush_fp() and override this to
+	 * FP_STATE_FREE if the flag set.
+	 */
 	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);

-- 
2.30.2
