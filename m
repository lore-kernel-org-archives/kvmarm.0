Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF713381B15;
	Sun, 19 Jul 2026 23:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502716; cv=none; b=J1zQtiYFI0e1Mdu/aOfERL51RRhD+vBHNMLt2z+vDJHRyLzNeEHt+FhzZX3HqKsTlfuHlcK7Umn7RqDxcqYLIghITJdWTL7/4bmx+ETza/3rmDmPG5M5QiWm3zlWPYJ1x1FBoc2qqjHRZMGHTw5L0ejCggK4VXKvBmLAAj33tNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502716; c=relaxed/simple;
	bh=hn1y/Ii/xUjl5TfgGrGM2KMGs+69hqwXhinvJnIOmPQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UM6vZnYVKzSsAG+KT4t6tZy8Wp7jA23Fslgfl/gQ3D9gWixp1X8GS9P9I6sBdbP87eip3bQZHZqI9gVPrladvIHXFMqFx5R5ouvMQGifD3fTWuc3xBqMlUISlfYoXEwssoqlCDm7HPYWkXkwjJM5maZWnGLuqHruLwsnQJsLSXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c141UijV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c141UijV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB8D1F00A3D;
	Sun, 19 Jul 2026 23:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502714;
	bh=0sz8gGxyAlkQMG+rUT9zspvd+PY5FDI251nuvd5HfjQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c141UijV90dOfxJQJR7hg//rHLStvXnj+ICH6TcRlXifhTOAVR2jQZTXFsqDlRbTC
	 zzkKQ3nAyE7m/flMUlffRcvh2F5KcaQh501/WPxk4LZyJhr2iSvgibe5ZkQMBI5Qd1
	 IVviqhfmb/ysDcvRbdDldy25KLYeMuJBKo4/W4yWWjTg65az2clRuyKG31q6ewxA+6
	 87RlfXzIYPudPGurbD+A/JarqhD87HhTksX/lZUzgBwOGOSGWIH3QglWWFGM6OtqEe
	 vvS3z5y3UnOGZKTUJbL0UDaDNexk5vYwerBuXvu56fgVmgaBhO7fo8aSB0PM3SURiz
	 8RqHnrGw7z7lA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:54 +0100
Subject: [PATCH v13 27/32] KVM: arm64: Expose SME to nested guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-27-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2042; i=broonie@kernel.org;
 h=from:subject:message-id; bh=hn1y/Ii/xUjl5TfgGrGM2KMGs+69hqwXhinvJnIOmPQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVk8nQnmN3m+uGAvuZGpAWgUu53Wf+RRuZH0/
 cDlJNuNbiyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZPAAKCRAk1otyXVSH
 0IorB/9CVjtR+do2u9SU5XXbIj5Z/P4o6NWAArtRleoYGdv9x1iD4a8PQ1xXIXi7xmB3V7B39if
 /AYdqI7yxQiNG/5G+yWNw5cgUH+68ec3SxNXeOQSqjrydddIgx5YGG/dW50vBbUmj5ZJgeu6bob
 6pI9MY26qaXxQQ7rQbT233TWOCHdRdfO2cVg5AzDZfa3WiKwXNLUZrH2+e5MrxOb9Da637aniRD
 8w+dv+BS+xJZyQ1/4dFeyFj7ygrsfJXExC5CRjBKhzAjCWdtnnvz3tU/bHJGrpUURWMq4C4QAaO
 1BN65V9aBsc0jY77rIe12YC2fAuOdfbHP2+Y59IqbNWyd1Ik
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

With support for context switching SME state in place allow access to SME
in nested guests.

The SME floating point state is handled along with all the other floating
point state, SME specific floating point exceptions are directed into the
same handlers as other floating point exceptions with NV specific handling
for the vector lengths already in place.

TPIDR2_EL0 is context switched along with the other TPIDRs as part of the
main guest register context switch.

SME priority support is currently masked from all guests including nested
ones.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 2 ++
 arch/arm64/kvm/nested.c             | 3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index cdf3e8422ea1..9df3cea39b09 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -42,6 +42,8 @@ static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
 		cpacr_el1 |= CPACR_EL1_FPEN;
 	if (!(cptr_el2 & CPTR_EL2_TZ))
 		cpacr_el1 |= CPACR_EL1_ZEN;
+	if (!(cptr_el2 & CPTR_EL2_TSM))
+		cpacr_el1 |= CPACR_EL1_SMEN;
 
 	cpacr_el1 |= cptr_el2 & (CPTR_EL2_TCPAC | CPTR_EL2_TAM);
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 7de9b7f8f90a..cc80d4c8ec20 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1630,14 +1630,13 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64PFR1_EL1:
-		/* Only support BTI, SSBS, CSV2_frac */
+		/* Only support BTI, SME, SSBS, CSV2_frac */
 		val &= ~(ID_AA64PFR1_EL1_PFAR		|
 			 ID_AA64PFR1_EL1_MTEX		|
 			 ID_AA64PFR1_EL1_THE		|
 			 ID_AA64PFR1_EL1_GCS		|
 			 ID_AA64PFR1_EL1_MTE_frac	|
 			 ID_AA64PFR1_EL1_NMI		|
-			 ID_AA64PFR1_EL1_SME		|
 			 ID_AA64PFR1_EL1_RES0		|
 			 ID_AA64PFR1_EL1_MPAM_frac	|
 			 ID_AA64PFR1_EL1_MTE);

-- 
2.47.3

