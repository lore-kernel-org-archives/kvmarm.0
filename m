Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351D243F8CD;
	Thu,  9 Jul 2026 18:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622430; cv=none; b=NsDbNIiTBVtA6LCz7etGoJFjkzo+cT685I5ndM0AA81dgBZvUt+PM4xzaevkBKjeSn75LpRTktv9liRREtzjpnRMUejUpVy/0R4MMDEFcpM8uIXwS/qrukT9CZRlKOok0gS701O28TSFev8A/eC4tWh0duL7dgPK9sZA2i0Fi+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622430; c=relaxed/simple;
	bh=++3RupEjJl/hieRBq4Zb2DcRHMWp0Yu3DKnrxPa5BCI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=svxaZR2UZdFZoesVTZ7QEp/13Vg++aACja11/Wh3MHEwXOSrH0Ub9vQBbOvD3Juo0RHDHJayhY9kGRReUjr0V6GLqcWEjPWuxPakzr8WxFklF/hpJEoQhPre1CrfLR3/u1CFWuHdQzcY2GH3DpdXksSMu9nzXmStlOZ56Eunbg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KQAX3nei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KQAX3nei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1BC1F000E9;
	Thu,  9 Jul 2026 18:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622428;
	bh=ZRzgkCokkYWeOPF3FDrRjraYcAbGSe4f3k3UbSQ8tck=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KQAX3neiOuz3j6XpyVScVIur7/tIYm48onAevH1WIPGExJHl5QKuPc1pG04LZ+YQ/
	 4dVedeC0oERGdMtJ4F/+AJ/P9RtRYSus3ckR600OryhzGZ1C+b7pPC+l7NPHCZQUGv
	 73QQPjCM5xdZVmk5h3wUmPsn1UIf/hq6blUJzSAMcPvKFRlbuaplmIAhBnyhSYwfDI
	 d7GMBo0AfcQXWJQwI423AYf7Jz1CAtmTX2lKrnEV/JGIz4iKhQm7GT8Ik1lVQD0gFp
	 wZ1cIVttxAbFqXQXNOvPJXlyp81+3jNTvhfBz+yEwzKpxfGbEJVLuP+3wfLnPsKwpA
	 M4GfUFY7AKV2Q==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:26 +0100
Subject: [PATCH v12 05/29] arm64/fpsimd: Determine maximum virtualisable
 SME vector length
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-5-d0301d79ef58@kernel.org>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1382; i=broonie@kernel.org;
 h=from:subject:message-id; bh=++3RupEjJl/hieRBq4Zb2DcRHMWp0Yu3DKnrxPa5BCI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+ruBTZpBesslyexlMPN7whcGBMEloy+b7SKJ
 a0kvNcpKqWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q7gAKCRAk1otyXVSH
 0P22B/9is+2aIzwfmXnfruqye5Q2jKLRQ694PLF/utH8NN9EBPjO7Tqz1AY6U4XIewi3lSOynAL
 jUGSASt11mw8AyZhP0ewUZOzBqD0VmkO7ELDd0Zt//yfYlJOGttyV5pGHLe4VH5hS4vS+XZQ2hH
 qIXS8UbT1SDpvwe4mmABAkBV0baO8woClIqVz0u6GKxoisC+sn++1HgDx3rrVGP1icwqrT3y72A
 202AnsT8jabvhvcWIL/0p/aA4YnUjpkgAekX7frH36/TMHCl8NgW34Hz5ntVg2gyOWpZ7sMcgra
 kL1O0OMETpymbfTdqRWhmvUtDQ4f3XaQF8ScMZyOOEWVW14t
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As with SVE we can only virtualise SME vector lengths that are supported by
all CPUs in the system, implement similar checks to those for SVE. Since
unlike SVE there are no specific vector lengths that are architecturally
required the handling is subtly different, we report a system where this
happens with a maximum vector length of 0.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 5c156e2a47ea..7c4e69fd3922 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1277,6 +1277,7 @@ void __init sme_setup(void)
 	 * minimum available VL will be used.
 	 */
 	set_sme_default_vl(find_supported_vector_length(ARM64_VEC_SME, 32));
+	info->max_virtualisable_vl = vec_virtualisable_vl(info);
 
 	pr_info("SME: minimum available vector length %u bytes per vector\n",
 		info->min_vl);
@@ -1284,6 +1285,10 @@ void __init sme_setup(void)
 		info->max_vl);
 	pr_info("SME: default vector length %u bytes per vector\n",
 		get_sme_default_vl());
+
+	/* KVM decides whether to support mismatched systems. Just warn here: */
+	if (info->max_virtualisable_vl < info->max_vl)
+		pr_warn("SME: unvirtualisable vector lengths present\n");
 }
 
 void sme_suspend_exit(void)

-- 
2.47.3

