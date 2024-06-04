Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023AF18028;
	Tue,  4 Jun 2024 18:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717526834; cv=none; b=S200ON/ML27BfkZM7HSzx2T3Qf7tjc+I1s5iTBFtck6pBHdDb7BgRCcP2uRSBD7A5u8dUenpnqfObCdyUaIWAZExVZppqe3cFlv01Lcxoc5je8IzdV+12egUaWP6tryiFcBUGHFcDPTdXt1azEDUVir3l+PIRgCuAATRJJBGLP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717526834; c=relaxed/simple;
	bh=LtpCYs/rieDxgmWuPZaV8oRq3H8m/uiP7O2FlWkkU6E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=iKXKMxezkW3DBWXgubGQuInyyO4EWXe5vRzC72zMnkFijwY70JKnpaJ+zXdj/cZQNNdEUkEtUAE/6/9oCEwv840nfT1yHHjhlwVtb1jt7nmmvCJ7NA1LXJCHOX7FHtM3DMG+cXPcuyON/RRA6v+MmA0yeoNDxAMMfzOV2DqnIc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DL2q++Xn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DL2q++Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C923C2BBFC;
	Tue,  4 Jun 2024 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717526833;
	bh=LtpCYs/rieDxgmWuPZaV8oRq3H8m/uiP7O2FlWkkU6E=;
	h=From:Date:Subject:To:Cc:From;
	b=DL2q++Xn3d+bxgLo6K2aRBRCcxCLwQNltO2lOGL9hKwwUzicwguMRvUaoX0TayHNL
	 G6nRBQlDV3qJk19i10u4JEloAutfE1RROgyh6SGF4irMbbg1LEfAdRcEq8lzu4KJAi
	 LwS0Ey79nf3tA3CK8y0ltfocISMhdToWSOwEwja3hO+S5SPCLCKC8m3ZVRe4fkbdAU
	 jS5Td28kDvTaPd4KUEGFyslEZsFw0s+JkAO6eiDbe9cHcsKBVRRqMomLieODFRry//
	 4yF9B4WH3QRrvHMAmqLZylST5+W55BypESDF4FQFV9VkOOwOXU+9PLWCKi3MpTx/DA
	 41sXRsHyD6gSw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 04 Jun 2024 19:47:01 +0100
Subject: [PATCH] KVM: arm64: Fix confusion in documentation for pKVM SME
 assert
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240604-kvm-arm64-sme-assert-v1-1-5d98348d00f8@kernel.org>
X-B4-Tracking: v=1; b=H4sIACRhX2YC/x3MMQqAMAxA0atIZgNV2ipeRRyCjRqkKo2IIN7d4
 viH9x9QTsIKXfFA4ktU9i1HVRYwLrTNjBJyQ21qa7yxuF4RKUVvUSMjafYnOgqNc8FySx4yPRJ
 Pcv/bfnjfD0wbmHNmAAAA
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=1905; i=broonie@kernel.org;
 h=from:subject:message-id; bh=LtpCYs/rieDxgmWuPZaV8oRq3H8m/uiP7O2FlWkkU6E=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmX2EueYIFwpCK5h2htBWB6yatSlIAm2LAJzZ7L8yK
 BpxQpqiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZl9hLgAKCRAk1otyXVSH0CKaB/
 42Yi8pK/Bp81oc/d+6BAigrvOCLOSucaFzmqzhfl5R0/V1istdU2EHYMlu1gGqakjKO0B7mm0H1ZmD
 rZKgYr98vaM/bo3WyLxSGdmKUZNTWXxGKPEI2iPQ6PsoBGId2jE0mOXk/E6/kPnCDXGDxDJkwD+ajC
 4QeBJiv/+4N9/yVI/KYXF5BpWaO2kIKVXB5LJMUUcn58mMM5wvC+iMvxHiURZ//eUJV/3vhbR7Y3Fs
 0QVxP3jfqCh8B/eqkyE5oO0yjXIj07jA1oKO1cuBrookuVEsSs65h5AdeD65VRufGv4GgCKUGjEVf8
 6dY+bDjWndxtQuhcEQIj24SkTpFH6D
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As raised in the review comments for the original patch the assert and
comment added in afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are
disabled in protected mode") are bogus. The comments says that we check
that we do not have SME enabled for a pKVM guest but the assert actually
checks to see if the host has anything set in SVCR which is unrelated to
the guest features or state, regardless of if those guests are protected
or not.

What I believe the check is actually intended to validate is that we do
not enter the pKVM hypervisor with SME enabled since the pKVM hypervisor
does not yet understand SME and is therefore unable to save or restore
host state with SME enabled, indeed attempting to save SVE state would
fault if streaming mode is enabled on a system without FA64 due to FFR.
Update the comment to reflect this.

Fixes: afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are disabled in protected mode")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 521b32868d0d..f720ba47b85c 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -92,8 +92,9 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * If normal guests gain SME support, maintain this behavior for pKVM
-	 * guests, which don't support SME.
+	 * The pKVM hypervisor does not yet understand how to save or
+	 * restore SME state for the host so double check that if we
+	 * are running with pKVM we have disabled SME.
 	 */
 	WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
 		read_sysreg_s(SYS_SVCR));

---
base-commit: afb91f5f8ad7af172d993a34fde1947892408f53
change-id: 20240604-kvm-arm64-sme-assert-5ad755d4e8a6

Best regards,
-- 
Mark Brown <broonie@kernel.org>

