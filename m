Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A474B3ACA7E
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 11:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783682159; cv=none; b=Xe72fVFL4Zf8qw3D4HIubWD2SszJnszq/h73gPiaVAcisQSpbzfAHSMWyL/0m9zwQ6lotr+b4ARjjKN57B6t49x1ouQlq/tlFbsoaooTa80scA39YvtEgsFEevSNGee+QBgZpuLdyGurvlHN217jyS/aa/DN5Ah/PPAiLjJ9Wfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783682159; c=relaxed/simple;
	bh=hp0lEkOwUA4Gek6D7M1hRbpbu/V7WYaGYBv95FZV7oc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CtPnJ43a1cG0wgJM5Dx7XyPhbvsz7z54k5xYnDQao5scwkIuKTN8fI6kx1Dfbn3Etb+SWNfVB+BZ/ls5bl8LnX69sR/HXJ6YKv2ZsBRExCgTQtH3iAxd5gtD6nqdnYkokWrGLPoKJxFVUirl6uCcvQm/cPaWbRFvrAu05l3cyuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=cypq5tmg reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="cypq5tmg"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66ABEvsI024946
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 10 Jul 2026 20:15:10 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=pJjKbNakwtm0jMT04UBxbp6wN2PKOAbYt/K0ZhCrjUc=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1783682110; v=1;
        b=cypq5tmgi8sW1J1vY+7FX5yhIamwUYgJ8fnr/uY3GitaU8yixH4poE4ECyVNednC
         CpQJaOhbEVn4aCzaqk4zNVeEHkOmedKuH0fSuSDr184wCx92thrc4vMugRvyuFr/
         w8Pk/BRGggqeeSD6cdoTNEIVR4xONf3EhlvO2hr0lZ4x3AbbdZ3AR9Gpp5dVOsZn
         nx/HgECEJtwZ4tx3Y7tefssdGAB7Em5FNfC5H5YOeudZ0PnlWw8WZM2gW9dE1nx1
         mAlH8CoRhbOuyt7CpOxC2wkjp/tpBX8nHzJlWUiS0FJzoOX+9w9/lkgEEDrwjo4U
         U6Ky2Ar/ayLG5jEEZiGl4A==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 10 Jul 2026 20:14:58 +0900
Subject: [PATCH v8 04/11] arm64: errata: Require Apple IMPDEF PMUv3 traps
 on all CPUs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-hybrid-v8-4-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
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
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5
X-Developer-Signature: v=1; a=openpgp-sha256; l=1261;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=hp0lEkOwUA4Gek6D7M1hRbpbu/V7WYaGYBv95FZV7oc=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bAFbMHm2WVY578mzc1ruRV9qK3tZ7tuz6LBAXcKpZ5c
 PX4uvJbHaUsDGJcDLJiiiwpRbu5NaJrPxUmxLfAzGFlAhnCwMUpABOJtmVk+DWtN10kdo3lwx0B
 f+4c3f7++GrhIzwq9ez/du/89cbvGzMjQ8OutReeTvjbPzeOpbnvdNtddZ9Em+enI33lObbyFwY
 bsgAA
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

KVM relies on ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS as a system-wide
precondition for PMUv3 emulation on affected Apple CPUs. A local CPU
erratum is too weak for that: once the workaround is enabled, a late CPU
that misses it may still be onlined.

Make the workaround an all-early-CPU capability instead. The matcher is
still local because it depends on MIDR_EL1, but the capability is only
advertised if all early CPUs match, and late CPUs that miss it are
rejected once the capability is enabled.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kernel/cpu_errata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 476a37c82108..14ce49d693c4 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -964,7 +964,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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

