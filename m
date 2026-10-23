Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792764677;
	b=lX6pBgoPzC7UL2ZJbjX8Ns4cE2ckcjw/IrMieWrcNtMrTwiLXtr/BLZNHmk+MZ/qf6LW
	 +8+mtOgEG7+z241g7tCiDf0ubrmzLLGEAeXtz79HaMBrxzj/pSjXmj382ZtKJyrB0YXfk
	 xS6J2DyvVOfyQERcZnDA59Vio6ftcqGiG8dOv3/UqxyLuPsB5zXxxsVGcUvTm/fnvPwKH
	 Z0q7KWYYbf2yE0Tb5FiwLeGOyNy5YWXtUxCBddaawXbl9RgGrgcjf7bi0AVkZzrhrDRDr
	 YerdOYb+8D2vh8UZPSWkoLBlfiVusvM3XBaRCfcWSzegLHehDBUzUmJNaGp7UxyY3ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792764677;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=VHsYbMWajiPGkaPnQFmHr/q3XA6XDqqarKFTwdVqZaA=;
	b=n2Td1G9SsZCX5JRlvrXhKluzCvROCselVi2nQwn7nHLCsq6j9G722THAFPjMVQspiyoW
	 DVcIOixI9HvQ5keU9U67nEoAfzEthYar9G0vXjQ/kd5D36twsfJ2n/TgaNzdbnUyNOB2E
	 cf/qUS3Z8pfjbR0jj7b3DiYHAkxBbz8eqGSDdl/K5SK9GGo5YqlI9tJ3tC9Qy2Cik8OyW
	 TUumDc9IrRNCAH1Gkll5A+htxjR38eAd3owOUnm6srttNxx700kYhD54smFElAl2r/PO+
	 2TepoBQfdVyFmrLPxe9gdyp3BnwkKxRZKh6tdqY+9IrgcPgtLooBHTQwCjT0pcZhUaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arndb.de;
	spf=pass smtp.mailfrom=arndb.de;
	dkim=pass header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm1 header.b=dpSgweoN;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=fEtKMigR;
	arc=none smtp.remote-ip=202.12.124.155
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACF2606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 14:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8ACF2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm1 header.b=dpSgweoN;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=fEtKMigR
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 958F07A0281
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 10:11:15 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 23 Oct 2026 10:11:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1792764666;
	 x=1792851066; bh=VHsYbMWajiPGkaPnQFmHr/q3XA6XDqqarKFTwdVqZaA=; b=
	dpSgweoNo091s7m8gEE03TEoLCYOXysEbhnCXk/AIsmM5kxGSm2dUuKlVfvGECHK
	+K/ddLXrwrWLj/Ew6QOZuwuVr+lElBRHoiExO3wwgNkI7riU60tKTWhaFjhPlyYi
	i57RD4GnTk65ehTHhv/UIW9nBV/q/rsPPwanqDQT1m1eaGWrRwTiyLO/PARv23Z3
	EG2EVyf7fFb2reTmq8PlpHnEgg50MjJ14ykR/SecNcvP3VQTEv9ncLE/2IWvtEyX
	FKm7ni4MQlrQ69DAATruiytl0Cm6TXwi63HDPpfROl5xPqzHWHWZbQBw4U6FshzD
	MUUDX3pjPv9xl3zEWJhUGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1792764666; x=
	1792851066; bh=VHsYbMWajiPGkaPnQFmHr/q3XA6XDqqarKFTwdVqZaA=; b=f
	EtKMigR3n+7M8yQnILxn9DnRqg3symMwVA2w8qqJwkMEtu2I6l1ZFs+Qm308SpSt
	Qk+XpWgz9xsZryG96EvSVTnnRHyYHbn9IJefbrr/tWae+abt5K+WagPrTAHtcDeb
	dwfXoOWOCZRbDczMkGooxdhGIcD5KXwED9f/54SoctF3NgvCKmyK4SOQzr/mts08
	SWj2GAzJOhPJEAuS8uEpqjZ1hsPahdGXbmOcUwf1LImEmTh2AvZsCihUiyR8kQXL
	VP4IQhVE1OkQNBhpyFR+BzDemrhLR9FY+4Yt+PEDVyawUwrIBa8zpGCz0HRqRikm
	7SJx4TLb3xr684352XI4Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792764666; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGt2bWFybUBsaXN0cy5saW51eC5kZXY+;
	s=fm1:rsa-sha256:bdZEvG926szG08mFYNrwrxfVISvCrXe/JhKfOBFZiBQz2UL
	EaPQri5S8wzIx8r6Ebr7PbJL18Dj/QI+FodFA1t6mL+Wru2bZgUksTeIxx8lS+yU
	BWrUDPWRzyDvFp3iqlhzBNnYY/9Kc8/E0asCz87LfRP3ZHXyAaRK6dMTu+bLfvhn
	ZJpkfd7T3nFEmhsdfBSq5A0qNOJ4Ir8WoVS4mW0Mb4ej0vX+M5v9UyvAkNjoxXZ3
	m5wA77cCIrbIWPBzh/5eoOj5IKerTUdh1RfL25wSqWtBOlikJ2lpTsgNrVa6AJpN
	0tLjfmFPNJ+qL94JxjWfnlu0NjJW9qRdU0upP2w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:gLdcu4wlVTeOqtG+F1nxk9aFgt/lv+jaAPp2yGbIQCA=:sNAftTAns3R115dm8xVuq12ndv8JtTHMJC021bb9264=;
X-ME-Sender: <xms:82rbagk6Dq3FqIIZNwQeZvb8UrzoSTfx2XbQVZ0GIx0gWK-vZHFIEA>
    <xme:82rbaqqfDaHFTgbQCrRmODZqUJZAvgzdPa3Fex-d-IQXFCNveUcaYoBeHYejUNOwu
    D28_ZhxN-shpJl6RjlkdY-qf3Yx0lkGIFWf6UN1Y1MzBO3tPuUDvvdFhw>
X-ME-Proxy-Cause: dmFkZTF+XKMUw2hOuK6Q78JhubtZyyLXH043ZxI8uxm2Aug6BXA6W4PTfA0AquoOYCC6F8
    +oMyCseuDN6IBluJBj0IwaLeH3SqeCuU20fhuONXou8mT14m9M5y77ASHsOEApCpYu8L12
    Pu/qh/PTXW/nxsXtG5o+7GlUxJw8mg45mvXwW+eN7oGJuudUYU7gupqr7aEyGWP91sKUTZ
    EymCikImgjItHKrkU8TMXGgEkh9ZGZPPeYDB83uWc8vNUSqdrV9rdA76GhTF3HW2rhJtmH
    fJwGR2G9l4fhsSO4IqIEvqX4RtlRImBdMzqak5k6Fy36+Tdv5vTtuj4kcSqJAx/EXajBIZ
    JoreQFcjxeFbx5U7XTo9leDLmnzdh/5qv9vdbgjwAVa6S4BHEAdM+McnsdlhTrWD4b6WJN
    BAQxcGfhczEBah4yEZ8VAKU9ChzjyZriavARcfwFTYLaTcOulXV8wEp/TahuJgts4Wqi/o
    XZaZhJgFdX/H9sqw8ctmYjf3/SCuaG1/klo7AEin36mC37fUPKFrMa0YPdP2lQn6BRCK0O
    PVNYM5qUU+Vp93vy+IIpLHbLOb2WTwonDPBJc824V8lrj/JaPs/TAOuZ7kAD1pZdeZJMc8
    M8W3+yLp61dXxCfwKsCnUMUC0l8bUijYOIUCj7vIEVqUqVFLgXcC7+ML/7og
X-ME-Proxy: <xmx:9mrbapsRwNp7ht9Ikq6wixfPE8ymJ-VYAOvX9Y47eN-NMI4Oat1s0g>
    <xmx:9mrbajY_tZQK14hboBgnxNgMvTpwyOjC4kA2BiHSjY-4Iu0RD2ztSA>
    <xmx:9mrbatFzayDMZSrfbRE8sfRwSRoxu0IViKt52HEB9I3a-i77So2SOg>
    <xmx:9mrbaurf-wdnHzYyU6nuOuObs-JYf3fFL2Qjd9jq_K-bPvbrVFeynQ>
    <xmx:-mrbanNI2vuXFG-cC9EUW3LXr-6UVbc5hfQT-UnN6Y7rKCuwnQ2JtJlf>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 88E4C32A0097; Fri, 23 Oct 2026 10:10:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AmcrnnMArev7
Date: Fri, 23 Oct 2026 16:10:23 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Fuad Tabba" <fuad.tabba@linux.dev>, "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>, "Steffen Eiden" <seiden@linux.ibm.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>,
 "Yicong Yang" <yangyicong@hisilicon.com>,
 "Zhou Wang" <wangzhou1@hisilicon.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <ad724195-3452-495a-a50a-5e5c8093a483@app.fastmail.com>
In-Reply-To: 
 <CA+EHjTy0jpY3sdVCENJRj_kfRDwbZ6TpkCAHQ2xUO-7ZuErpcA@mail.gmail.com>
References: <20261023070110.1833446-1-fuad.tabba@linux.dev>
 <20261023070110.1833446-2-fuad.tabba@linux.dev>
 <86fqxwzul7.wl-maz@kernel.org>
 <CA+EHjTw08SZC_3Uodt6ew6vXVH-doW-8G41fVCF-rmaKsv+0fQ@mail.gmail.com>
 <86ecdgzp6m.wl-maz@kernel.org>
 <CA+EHjTy0jpY3sdVCENJRj_kfRDwbZ6TpkCAHQ2xUO-7ZuErpcA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Hide FEAT_LS64_ACCDATA from guests
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Oct 23, 2026, at 12:37, Fuad Tabba wrote:
> On Fri, 23 Oct 2026 11:28:17 +0100, Marc Zyngier <maz@kernel.org> wrote:
> [...]
>> No, I want this fixed by enabling ACCDATA support by default, which is
>> what we have *already* promised to userspace, and see the fireworks.
>> You can add an arm64.nols64 kernel option if you want, which is
>> consistent with what we do for CNTPOFF, NV3, and other extensions that
>> depend on FW enabling them.
>
> Will do. v2 will have your patches 3 and 4 from [1] rebased, EnAS0 set
> when the guest has LS64_ACCDATA, and an arm64.nols64 option.

That sounds good. For reference, I have prototyped support for
LS64_ACCDATA in Linux drivers based on the corresponding x86 code.
The code is not yet tested on hardware, but it may help understand
how this may be used in the future.

       Arnd

----
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] arm64: dynamically enable st64bv0 for SVA

I/O devices that understand the st64bv0 instruction for doing shared
virtual access from userspace need to set the pasid value in the
accdata_el1 register, but in general we want this to be disabled unless
a driver actually hands an MMIO area to userspace that accepts these
commands and installs a pasid using iommu_sva_bind_device().

Rather than trying to find all threads that use an mm_struct by the
time the pasid created, iommu_sva_bind_device() only stores the pasid in
'struct iommu_mm_data' and sets up the iommu domain in the device. The
first attempt to use SVA from userspace traps into do_el0_other(),
which checks that this is indeed valid and then sets the configured
pasid before enabling SCTLR_EL1_EnAS0.

This is pretty much a lifted from the x86 try_fixup_enqcmd_gp()
function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index a2da3cb21c24..7c61b50718d6 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -81,6 +81,7 @@ void do_el0_sys(unsigned long esr, struct pt_regs *regs);
 void do_sp_pc_abort(unsigned long addr, unsigned long esr, struct pt_regs *regs);
 void bad_el0_sync(struct pt_regs *regs, int reason, unsigned long esr);
 void do_el0_cp15(unsigned long esr, struct pt_regs *regs);
+void do_el0_other(struct pt_regs *regs, unsigned long esr);
 int do_compat_alignment_fixup(unsigned long addr, struct pt_regs *regs);
 void do_el0_svc(struct pt_regs *regs);
 void do_el0_svc_compat(struct pt_regs *regs);
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 803b68758152..55965d752ad5 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -16,6 +16,7 @@
 #include <linux/mm_types.h>
 #include <linux/pgtable.h>
 #include <linux/pkeys.h>
+#include <linux/iommu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
@@ -247,6 +248,20 @@ static inline void __switch_mm(struct mm_struct *next)
 	check_and_switch_context(next);
 }
 
+/* switch to PASID if new task has enabled st64bv0 */
+static inline void switch_iommu_mm(struct mm_struct *mm, struct task_struct *tsk)
+{
+	u32 pasid;
+
+	if (!IS_ENABLED(CONFIG_IOMMU_SVA) ||
+	    !(tsk->thread.sctlr_user & SCTLR_EL1_EnAS0))
+		return;
+
+	pasid = mm_get_enqcmd_pasid(mm);
+	if (pasid != IOMMU_PASID_INVALID)
+		write_sysreg(pasid, accdata_el1);
+}
+
 static inline void
 switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	  struct task_struct *tsk)
@@ -254,6 +269,8 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	if (prev != next)
 		__switch_mm(next);
 
+	switch_iommu_mm(next, tsk); /* FIXME: is there a better place to do this? */
+
 	/*
 	 * Update the saved TTBR0_EL1 of the scheduled-in task as the previous
 	 * value may have not been initialised yet (activate_mm caller) or the
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 11d3f888fcd8..abeffb7f1fb2 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -806,6 +806,14 @@ static void noinstr el0_fpac(struct pt_regs *regs, unsigned long esr)
 	arm64_exit_to_user_mode(regs);
 }
 
+static void noinstr el0_other(struct pt_regs *regs, unsigned long esr)
+{
+	arm64_enter_from_user_mode(regs);
+	local_daif_restore(DAIF_PROCCTX);
+	do_el0_other(regs, esr);
+	arm64_exit_to_user_mode(regs);
+}
+
 asmlinkage void noinstr el0t_64_sync_handler(struct pt_regs *regs)
 {
 	unsigned long esr = read_sysreg(esr_el1);
@@ -869,6 +877,9 @@ asmlinkage void noinstr el0t_64_sync_handler(struct pt_regs *regs)
 	case ESR_ELx_EC_FPAC:
 		el0_fpac(regs, esr);
 		break;
+	case ESR_ELx_EC_OTHER:
+		el0_other(regs, esr);
+		break;
 	default:
 		el0_inv(regs, esr);
 	}
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index d6391ab20db3..ce968cce11e7 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -13,6 +13,7 @@
 #include <linux/kprobes.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
+#include <linux/iommu.h>
 #include <linux/hardirq.h>
 #include <linux/kdebug.h>
 #include <linux/module.h>
@@ -543,6 +544,55 @@ void do_el1_mops(struct pt_regs *regs, unsigned long esr)
 	kernel_fastforward_single_step(regs);
 }
 
+/*
+ * PASID/ACCDATA is shared by the entire mm, while sctlr_el1
+ * is maintained per thread. Keep things simple and enable
+ * ACCDATA dynamically on first access if available.
+ *
+ * After exiting back to userspace, the st64bv0 instruction
+ * should no longer trap.
+ */
+static bool try_enable_st64bv0(struct pt_regs *regs, unsigned long esr)
+{
+	u32 pasid;
+	u64 isar1;
+	u64 sctlr;
+
+	pasid = mm_get_enqcmd_pasid(current->mm);
+	if (pasid == IOMMU_PASID_INVALID)
+		return false;
+
+	isar1 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
+	if (!(isar1 & ID_AA64ISAR1_EL1_LS64_LS64_ACCDATA))
+		return false;
+
+	sysreg_clear_set(accdata_el1, ACCDATA_EL1_ACCDATA, pasid);
+	sctlr = current->thread.sctlr_user;
+	sctlr |= SCTLR_EL1_EnAS0;
+	current->thread.sctlr_user = sctlr;
+	update_sctlr_el1(sctlr);
+
+	return true;
+}
+
+void do_el0_other(struct pt_regs *regs, unsigned long esr)
+{
+	switch (ESR_ELx_ISS(esr)) {
+	case ESR_ELx_ISS_OTHER_ST64BV0:
+		if (try_enable_st64bv0(regs, esr))
+			return;
+		break;
+
+	case ESR_ELx_ISS_OTHER_ST64BV:
+	case ESR_ELx_ISS_OTHER_LDST64B:
+	default:
+		break;
+	}
+
+	/* Treat all other "other" trapping instructions as illegal opcode */
+	force_signal_inject(SIGILL, ILL_ILLOPC, regs->pc, 0);
+}
+
 #define __user_cache_maint(insn, address, res)			\
 	if (address >= TASK_SIZE_MAX) {				\
 		res = -EFAULT;					\
@@ -842,6 +892,7 @@ static const char *esr_class_str[] = {
 	[ESR_ELx_EC_FP_ASIMD]		= "ASIMD",
 	[ESR_ELx_EC_CP10_ID]		= "CP10 MRC/VMRS",
 	[ESR_ELx_EC_PAC]		= "PAC",
+	[ESR_ELx_EC_OTHER]		= "OTHER",
 	[ESR_ELx_EC_CP14_64]		= "CP14 MCRR/MRRC",
 	[ESR_ELx_EC_BTI]		= "BTI",
 	[ESR_ELx_EC_ILL]		= "PSTATE.IL",
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index b15a59b9e95d..e358d9ad229b 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3656,6 +3656,11 @@ Sysreg	TPIDR_EL1	3	0	13	0	4
 Field	63:0	ThreadID
 EndSysreg
 
+Sysreg	ACCDATA_EL1	3	0	13	0	5
+Res0	63:32
+Field	31:0	ACCDATA
+EndSysreg
+
 Sysreg	RCWMASK_EL1	3	0	13	0	6
 Field	63:0	RCWMASK
 EndSysreg

