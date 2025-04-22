Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D611DFED;
	Tue, 22 Apr 2025 07:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745306222; cv=none; b=bHxx4DCM61yM3lPgRJRzQUlsy2M6s2MD+5s5QIIyseDhlZPUUfEy5g+0dydeSfZ0plK3AYa33GkEPdUgBVCbkdsEUk3tMZm5vQXV2Fih2DkISvx0sacaCVAYgYGYMJD6V8iK8+CuHn+aH8sa8nSzbrlgUAPjjRdKsV8lbOux3Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745306222; c=relaxed/simple;
	bh=RiTI1786nQLxvyfzX1F1f6bY2solbSkPuhlCMQ3AVsA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=LQOooGr3qDBj9QiUvA+4MS35G4KE+zlCzt3IZdlwJODJ8RYs9TA+Lx+U7AeG//uiNbG7jANE7iw2iAag9+EXnj/IYkq/WNN/IjDWqoUNBVFsSqxp1+N0yn1Or2marUMBD1DDMM9tz6eRZyJgM0ttGlaDoivstow1MF0lK/zE8Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaTkccIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaTkccIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302C4C4CEE9;
	Tue, 22 Apr 2025 07:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745306221;
	bh=RiTI1786nQLxvyfzX1F1f6bY2solbSkPuhlCMQ3AVsA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=KaTkccIQT4Hj4wl5qytIacStNZKSWbqhtXoNOctHhsPpxriMscG5pUm6m8YkEZT3b
	 aWUzvXcP/TT0iox9qA1x/+NRmx7TroDGaYeHTvqybHwORU2FQFQ3zol/mh2YtGVj7y
	 /zura4dbKPXL9h1GiaSRRSOeu/QQuHjX9/axTY8w=
Subject: Patch "arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9" has been added to the 6.12-stable tree
To: anshuman.khandual@arm.com,catalin.marinas@arm.com,corbet@lwn.net,gregkh@linuxfoundation.org,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,mark.rutland@arm.com,maz@kernel.org,oliver.upton@linux.dev,robh@kernel.org,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 22 Apr 2025 09:16:59 +0200
In-Reply-To: <20250415045728.2248935-8-anshuman.khandual@arm.com>
Message-ID: <2025042259-iron-exclusive-714d@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     arm64-boot-enable-el2-requirements-for-feat_pmuv3p9.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-132691-greg=kroah.com@vger.kernel.org Tue Apr 15 06:58:05 2025
From: Anshuman Khandual <anshuman.khandual@arm.com>
Date: Tue, 15 Apr 2025 10:27:28 +0530
Subject: arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, robh@kernel.org, mark.rutland@arm.com, anshuman.khandual@arm.com
Message-ID: <20250415045728.2248935-8-anshuman.khandual@arm.com>

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit 858c7bfcb35e1100b58bb63c9f562d86e09418d9 upstream.

FEAT_PMUv3p9 registers such as PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1
access from EL1 requires appropriate EL2 fine grained trap configuration
via FEAT_FGT2 based trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2.
Otherwise such register accesses will result in traps into EL2.

Add a new helper __init_el2_fgt2() which initializes FEAT_FGT2 based fine
grained trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2 (setting the
bits nPMICNTR_EL0, nPMICFILTR_EL0 and nPMUACR_EL1) to enable access into
PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 registers.

Also update booting.rst with SCR_EL3.FGTEn2 requirement for all FEAT_FGT2
based registers to be accessible in EL2.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Fixes: 0bbff9ed8165 ("perf/arm_pmuv3: Add PMUv3.9 per counter EL0 access control")
Fixes: d8226d8cfbaf ("perf: arm_pmuv3: Add support for Armv9.4 PMU instruction counter")
Tested-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250227035119.2025171-1-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/booting.rst |   22 ++++++++++++++++++++++
 arch/arm64/include/asm/el2_setup.h   |   25 +++++++++++++++++++++++++
 arch/arm64/tools/sysreg              |    1 +
 3 files changed, 48 insertions(+)

--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -285,6 +285,12 @@ Before jumping into the kernel, the foll
 
     - SCR_EL3.FGTEn (bit 27) must be initialised to 0b1.
 
+  For CPUs with the Fine Grained Traps 2 (FEAT_FGT2) extension present:
+
+  - If EL3 is present and the kernel is entered at EL2:
+
+    - SCR_EL3.FGTEn2 (bit 59) must be initialised to 0b1.
+
   For CPUs with support for HCRX_EL2 (FEAT_HCX) present:
 
   - If EL3 is present and the kernel is entered at EL2:
@@ -379,6 +385,22 @@ Before jumping into the kernel, the foll
 
     - SMCR_EL2.EZT0 (bit 30) must be initialised to 0b1.
 
+  For CPUs with the Performance Monitors Extension (FEAT_PMUv3p9):
+
+ - If EL3 is present:
+
+    - MDCR_EL3.EnPM2 (bit 7) must be initialised to 0b1.
+
+ - If the kernel is entered at EL1 and EL2 is present:
+
+    - HDFGRTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
+    - HDFGRTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
+    - HDFGRTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
+
+    - HDFGWTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
+
   For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
 
   - If the kernel is entered at EL1 and EL2 is present:
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -215,6 +215,30 @@
 .Lskip_fgt_\@:
 .endm
 
+.macro __init_el2_fgt2
+	mrs	x1, id_aa64mmfr0_el1
+	ubfx	x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
+	cmp	x1, #ID_AA64MMFR0_EL1_FGT_FGT2
+	b.lt	.Lskip_fgt2_\@
+
+	mov	x0, xzr
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
+	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
+	b.lt	.Lskip_pmuv3p9_\@
+
+	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
+	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
+	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
+.Lskip_pmuv3p9_\@:
+	msr_s   SYS_HDFGRTR2_EL2, x0
+	msr_s   SYS_HDFGWTR2_EL2, x0
+	msr_s   SYS_HFGRTR2_EL2, xzr
+	msr_s   SYS_HFGWTR2_EL2, xzr
+	msr_s   SYS_HFGITR2_EL2, xzr
+.Lskip_fgt2_\@:
+.endm
+
 .macro __init_el2_nvhe_prepare_eret
 	mov	x0, #INIT_PSTATE_EL1
 	msr	spsr_el2, x0
@@ -240,6 +264,7 @@
 	__init_el2_nvhe_idregs
 	__init_el2_cptr
 	__init_el2_fgt
+	__init_el2_fgt2
 .endm
 
 #ifndef __KVM_NVHE_HYPERVISOR__
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1238,6 +1238,7 @@ UnsignedEnum	11:8	PMUVer
 	0b0110	V3P5
 	0b0111	V3P7
 	0b1000	V3P8
+	0b1001	V3P9
 	0b1111	IMP_DEF
 EndEnum
 UnsignedEnum	7:4	TraceVer


Patches currently in stable-queue which might be from anshuman.khandual@arm.com are

queue-6.12/arm64-sysreg-add-register-fields-for-hfgwtr2_el2.patch
queue-6.12/arm64-boot-enable-el2-requirements-for-feat_pmuv3p9.patch
queue-6.12/arm64-sysreg-add-register-fields-for-hdfgwtr2_el2.patch
queue-6.12/arm64-sysreg-update-register-fields-for-id_aa64mmfr0_el1.patch
queue-6.12/arm64-sysreg-add-register-fields-for-hfgrtr2_el2.patch
queue-6.12/arm64-sysreg-add-register-fields-for-hfgitr2_el2.patch
queue-6.12/arm64-sysreg-add-register-fields-for-hdfgrtr2_el2.patch
