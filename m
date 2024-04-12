Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857426FC6
	for <kvmarm@lists.linux.dev>; Fri, 12 Apr 2024 02:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712889693; cv=none; b=Xddht30RSyPcE0cAy6y/j7iGXY3FVQnt8xIL9xvakvWacrZbMRLqyEZFEn3USouAoQqYkhfcJbHt0PAxrJHZic/lVn3iOTG7HSCGrjDaDNGnxlMWfUXoEqs/UarkisJBgKzuar5B6XeeL8TEKlIe6ed6ZVK50yOToJGsKXQk3p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712889693; c=relaxed/simple;
	bh=r6duq0FA6ngzfgA6UdUjSasdAsCWCsz0uNz4wVJf528=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ko+HkvMeI0yJRBbpuK2Q/iputMmpI98FxMZVI9Kqye+Jv89Yu1n4ePZWNqMtHq/UuG3gfdpy3TCEfEaZB52KD+/aiCa3knM+b0uHKEmv/MDzBUXsQrp+EZXBQbH4WkPB6WeBy8482Jk8pvExeUIPsulJLRZ7Br3u9KodZDZzMDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2A11339;
	Thu, 11 Apr 2024 19:41:59 -0700 (PDT)
Received: from [10.162.42.6] (a077893.blr.arm.com [10.162.42.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2F243F6C4;
	Thu, 11 Apr 2024 19:41:26 -0700 (PDT)
Message-ID: <5a2a74b3-f6cd-4cb6-8ee8-5dd7dc2bd686@arm.com>
Date: Fri, 12 Apr 2024 08:11:23 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 5/8] KVM: arm64: Explicitly handle MDSELR_EL1 traps as
 UNDEFINED
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Jonathan Corbet <corbet@lwn.net>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240405080008.1225223-1-anshuman.khandual@arm.com>
 <20240405080008.1225223-6-anshuman.khandual@arm.com>
 <86a5m8t8s6.wl-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <86a5m8t8s6.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/5/24 15:45, Marc Zyngier wrote:
> On Fri, 05 Apr 2024 09:00:05 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> Currently read_sanitised_id_aa64dfr0_el1() caps the ID_AA64DFR0.DebugVer to
>> ID_AA64DFR0_DebugVer_V8P8, resulting in FEAT_Debugv8p9 not being exposed to
>> the guest. MDSELR_EL1 register access in the guest, is currently trapped by
>> the existing configuration of the fine-grained traps.
> 
> Please add support for the HDFGxTR2_EL2 registers in the trap routing
> arrays, add support for the corresponding FGUs in the corresponding

Afraid that I might not have enough background here to sufficiently understand
your suggestion above, but nonetheless here is an attempt in this regard.

- Add HDFGRTR2_EL2/HDFGWTR2_EL2 to enum vcpu_sysreg
	enum vcpu_sysreg {
		..........
		VNCR(HDFGRTR2_EL2),
		VNCR(HDFGWTR2_EL2),
		..........
	}

- Add their VNCR mappings addresses

	#define VNCR_HDFGRTR2_EL2      0x1A0
	#define VNCR_HDFGWTR2_EL2      0x1B0

- Add HDFGRTR2_EL2/HDFGWTR2_EL2 to sys_reg_descs[]

static const struct sys_reg_desc sys_reg_descs[] = {
	..........
	EL2_REG_VNCR(HDFGRTR2_EL2, reset_val, 0),
	EL2_REG_VNCR(HDFGWTR2_EL2, reset_val, 0),
	..........
}

- Add HDFGRTR2_GROUP to enum fgt_group_id
- Add HDFGRTR2_GROUP to reg_to_fgt_group_id()
- Update triage_sysreg_trap() for HDFGRTR2_GROUP
- Update __activate_traps_hfgxtr() both for HDFGRTR2_EL2 and HDFGWTR2_EL2
- Updated __deactivate_traps_hfgxtr() both for HDFGRTR2_EL2 and HDFGWTR2_EL2

> structure, and condition the UNDEF on the lack of *guest* support for
> the feature.

Does something like the following looks OK for preventing guest access into
MDSELR_EL1 instead ?

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1711,6 +1711,19 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
        return val;
 }
 
+static bool trap_mdselr_el1(struct kvm_vcpu *vcpu,
+                          struct sys_reg_params *p,
+                          const struct sys_reg_desc *r)
+{
+       u64 dfr0 = read_sanitised_id_aa64dfr0_el1(vcpu, r);
+       int dver = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_DebugVer_SHIFT);
+
+       if (dver != ID_AA64DFR0_EL1_DebugVer_V8P9)
+               return undef_access(vcpu, p, r);
+
+       return true;
+}
+
 static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
                               const struct sys_reg_desc *rd,
                               u64 val)
@@ -2203,7 +2216,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
        { SYS_DESC(SYS_MDSCR_EL1), trap_debug_regs, reset_val, MDSCR_EL1, 0 },
        DBG_BCR_BVR_WCR_WVR_EL1(2),
        DBG_BCR_BVR_WCR_WVR_EL1(3),
-       { SYS_DESC(SYS_MDSELR_EL1), undef_access },
+       { SYS_DESC(SYS_MDSELR_EL1), trap_mdselr_el1 },
        DBG_BCR_BVR_WCR_WVR_EL1(4),
        DBG_BCR_BVR_WCR_WVR_EL1(5),
        DBG_BCR_BVR_WCR_WVR_EL1(6),

I am sure this is rather incomplete, but will really appreciate if you could
provide some details and pointers.

> 
> In short, implement the architecture as described in the pseudocode,
> and not a cheap shortcut.
> 
> Thanks,
> 
> 	M.
> 
