Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE1C44A3E7
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386170; cv=none; b=RX4kE/f2gnaAN3v+lWGTRc1UzfjcQYIBmQVNYlMYk+jTkTTtsKyqQQr125PIHTC3kmzqsS1hDdtmWDbZQm/ck8ZJZd4mXpY6+c6BPs3oHnUqMxCDwsXcY7IranNcP2b+Bzx0S7CPWmuWjLSJVJvKN3kclZkRMyXVk+1+tzLOgP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386170; c=relaxed/simple;
	bh=GZptWV53eKd3XykurHHePIoGgjkvW4Yf7ho1CKj455U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BwP6EhesKz1lJS1iyl5MLh/NI92tc1qpAz5NS/VJKhiqXgb++rfJFfeh8JkAiEP/jkkoYm9XKYkP6E6EywFh83wqVlpMX4CAk62gTn/dSZqQEtXkllvBCMU7I2Sd49rkdV4dS1sPxYajPgEwm8VUN6W5WeO9npEY9UVYfjXeKYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=PtsKHTN2; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="PtsKHTN2"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjsF084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:55 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=J5E3S5wzjQZPQcPZwG9WQNUEJeT1MUbUa+eHNNdRQlk=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386116; v=1;
        b=PtsKHTN2V8NNuAw1rIdDWFKG1yL60G85AzkD8xemEJNKjTCgC0SzMizShw637gyC
         LbPT0NTxe9cEPNCymx2P33Ctt44ItTTQB2Do4Zt3UBhK1EoH1fqk0eyEEK4FNhVL
         M8jfrO9E/eFPOHXit5OKS7GK2PB2B2596pC8bYTCntdS3vwEfFjZlbUnwX9+cskL
         dl2FOrk+LVDzoPcLH7rWCdcrWaNlUpKlc0vGOWU/vwxsLWgBa0+dPhHEWwiCt5rz
         4RkAUeGnLKXwqDRpr8ZH4vBbD0lH1ZYdEFL81oQjmrQ5Lr9FnwQSRSROxv6sf9bQ
         lebBnv8JQkgAd0Vre1Us6w==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:52 +0900
Subject: [PATCH v10 13/20] arm64: errata: Require Apple IMPDEF PMUv3 traps
 on all CPUs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-13-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
References: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
        Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2262;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=GZptWV53eKd3XykurHHePIoGgjkvW4Yf7ho1CKj455U=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byu8Wb2xZ8eOb+7Ifg+UniJiwr41V6Ptiuf+hszFL2i
 N1M8tTcjlIWBjEuBlkxRZaUot3cGtG1nwoT4ltg5rAygQxh4OIUgIn8yGH4768n+P3q+aZYVc9q
 s/fz53bx9sfmHLqr9WOmT8/K4uI9hxn+CtUeY+C+zFb57K5kKRfro6Sndc27bi2bXiJi8GLR2UV
 xnAA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

KVM relies on ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS as a system-wide
precondition for PMUv3 emulation on affected Apple CPUs. A local CPU
erratum is too weak for that: once the workaround is enabled, a late CPU
that misses it may still be onlined.

Make the workaround an all-early-CPU capability instead. The matcher is
still local because it depends on MIDR_EL1, but the capability is only
advertised if all early CPUs match. A late CPU that misses an advertised
capability is therefore rejected.

Although kept in the errata capability table, this capability describes
optional trap support, not a workaround required for safe CPU operation.
Therefore, a late CPU can safely match the capability even when the
system does not advertise it.

On these CPUs, ID_AA64DFR0_EL1.PMUVer == 0xf means the
Arm-architected PMUv3 is not implemented. Without the system
capability, KVM does not advertise PMUv3, and direct accesses to
architected PMUv3 registers remain UNDEFINED. HACR_EL2[56] only makes
those accesses trap to EL2 so KVM can emulate PMUv3; leaving it clear
does not make them access Apple's native PMU.

The native Apple PMU uses separate implementation-defined system
register encodings, which KVM independently traps with
HCR_EL2.TIDCP. Allowing a late CPU with extra HACR_EL2 trap support
therefore does not expose host PMU state to a guest.

Fixes: bed9b8ec8c71 ("KVM: arm64: Advertise PMUv3 if IMPDEF traps are present")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kernel/cpu_errata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 78e4e105f6ab..9b2d9d0f1738 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -1012,7 +1012,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "Apple IMPDEF PMUv3 Traps",
 		.capability = ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS,
-		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.type = ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
 		.matches = has_impdef_pmuv3,
 		.cpu_enable = cpu_enable_impdef_pmuv3_traps,
 	},

-- 
2.55.0

