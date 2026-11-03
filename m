Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712947;
	b=DhBunL6dDT3mKIySVdlS0xZ38Css5s8MGLe/WZ1jiCl2BUmE2oNNA0rK/Fb17kfMEHQH
	 LD5tC3AQQ18ZvDbUMn3QvZxPG4fxTvuZ5J3qz0WdzVKSqa52HoVPLM86UFaJ24hWXrevY
	 7O0FlQ2/3q1BpEZPjtKYxBHtARmj6QuI+zXIXGvtDo/XR7rYfiwZDq7zUTbZvcOIg6bfR
	 FFtGHNlOcudR7RxvJJM2sbT40TJJePMIJr8SCVO9TaAj1LxgiE94jvvSQqBEjmjGPes0S
	 4qi2lFYwzuBeYESV1UY9XMIq0sayQUEXDhiH6hCghBg0K8GLLn7fbwyx3BjUaPB3flQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=icIsySJGcXUdtLov4qJWwicOP9j/Ac6QxnPMHKYOOYI=;
	b=LvFbseI14IU1xLGgdQ7o/kmy/HK5c+wxjqIyPrHefbmMHPnrHh23DOM5AiKrOtoyI+T6
	 F9OTQ3V6DKE+xnQABMfKHcmYHLuLSZ/mB7VBkSkXUFRvzZ4ruFGHublez39C4Ti+FEgH1
	 SwpJEQ6BwS8an7E7EmUSzutt9tZHPRqT4CLelMmV0QRAFksRlgtBBb8UpqfCCRdOh14eY
	 Sgr0N3B6q01dBwOvRkYeSh3X0gpadav4q+SCRK79a5p0uIzEaMnztdpJinj1Px0XI4p0D
	 SpRq8wUzQK10eP2gNSF/ZtMysWo9Brja3uOsN+shmAx3lw5z9QCQaOFjw+B85B/7wjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fWCpJ5pm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA51606D802;
	Tue,  3 Nov 2026 13:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fWCpJ5pm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88FF1F000C1;
	Tue,  3 Nov 2026 13:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712946;
	bh=icIsySJGcXUdtLov4qJWwicOP9j/Ac6QxnPMHKYOOYI=;
	h=From:To:Cc:Subject:Date;
	b=fWCpJ5pmWBh6d3zY10/CN5XnM39fFe9ChDLSdFrHHRvksL23UaRsrtLIfRsEZ4SzW
	 0UUKtAxvZMBV04Nr9y2Y1eLQJs+ypDB7zbeU3JY6LIilb5KTpsl8u5T26hckSuCU8R
	 bvXS5YZh2FVS8HBV/x+Q3Tft+UzfwcovNdoW5lRRy/NT1+mAgodNq20ccUdvdYn8tc
	 xZ/WYyTHiJqIH7n/O04252vEOQr6INIba5nwmhWi+3UqUpsONf+6zpbVgX66/pJSOK
	 4pcoTz8MJt4759xx/oatc+XXnaJTIzyT/7WVDNNwXYJIW6oY2JAqbgx8nhXaoGEuoB
	 ly6F/mLSsC9SA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] KVM: arm64: Use S1E1A when Stage-1 PIE is supported
Date: Tue,  3 Nov 2026 13:35:39 +0000
Message-ID: <20261103133540.29566-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a system with stage-1 PIE, a guest can try to execute from an
execute-only mapping at stage-1 but trigger a permission fault at
stage-2 if the stage-2 mapping is execute-never.

In this case, the EL2 permission fault handler will attempt to translate
the faulting VA using an AT S1E1R operation, which will fail due to the
lack of read permission at stage-1. We will then return to the guest and
take the exact same fault the next time around.

Similarly to commit 55f4b215fb60 ("KVM: arm64: use `at s1e1a` for POE"),
use the S1E1A operation to bypass stage-1 permission checks when
obtaining the IPA for a stage-2 permission fault. Like FEAT_S1POE,
FEAT_S1PIE implies FEAT_ATS1A, so extend the existing AT invocation in
__translate_far_to_hpfar() to use the permission-bypassing variant when
S1PIE is implemented.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Steffen Eiden <seiden@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---

I've been debugging an external report of a failure in Android related
to S1PIE. The symptoms match what I would expect from this issue and
this patch has been reported to fix the problem, but I don't have enough
information to know for sure that my analysis is correct. I've had to
piece things together based on partial information and bits of logs.

 arch/arm64/include/asm/cpufeature.h    | 5 +++++
 arch/arm64/kvm/hyp/include/hyp/fault.h | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4f04ad82ea34..f05ace660fa2 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -841,6 +841,11 @@ static inline bool system_supports_lpa2(void)
 	return cpus_have_final_cap(ARM64_HAS_LPA2);
 }
 
+static inline bool system_supports_pie(void)
+{
+	return alternative_has_cap_unlikely(ARM64_HAS_S1PIE);
+}
+
 static inline bool system_supports_poe(void)
 {
 	return alternative_has_cap_unlikely(ARM64_HAS_S1POE);
diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
index fc573fc767b0..741ea12be07d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/fault.h
+++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
@@ -38,8 +38,9 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	 * saved the guest context yet, and we may return early...
 	 */
 	par = read_sysreg_par();
-	ret = system_supports_poe() ? __kvm_at(OP_AT_S1E1A, far) :
-	                              __kvm_at(OP_AT_S1E1R, far);
+	ret = system_supports_poe() || system_supports_pie() ?
+		__kvm_at(OP_AT_S1E1A, far) :
+		__kvm_at(OP_AT_S1E1R, far);
 	if (!ret)
 		tmp = read_sysreg_par();
 	else
-- 
2.56.0.385.gac671c819a-goog

