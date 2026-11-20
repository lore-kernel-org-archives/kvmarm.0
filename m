Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152787;
	b=RaVoTXe1uGoLDvGLinnVv62O35GOuGD2OHMgwvl45zg3jjHzw7HwSaAME3DPC2a8fnBF
	 1uMf+BjP2zmIH+B4EnzMTnLh7RLdd+8K93NLuCSuVGTfBtTI3SUKpmcECEJ9Pxa7tZ6w1
	 aBdU2RIIDa4A3wNRaiFQRZd/rLndJ7wIVZX8syVeB2SGC8u9s3+VNM6asr8yGMifDMC3F
	 a+1vrZY0M4VzQd+ctixo/ww+PgagCyuPSF0vlCZm3+vL2R/K1DJuuzgj4mEYswuDn9NLa
	 2wz23k9gYKwrxNGe+Pyl6T0po4EAP3SOV/PUqJjPVgREUBr8j+j5oj7TO5nvOH1uzMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152787;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=JswpRUgs5UDlZob8ca9OhYXkbPtKRKpD9M0ivfXIf2w=;
	b=UI6FvUCBQqyigLFPON9pEm2e328QLywNXDc7SmD/NuOrUM2KEFRxHg33p8b1SRo7mGeZ
	 fbAg3QAvRkrX8PGsXy1EcMCBiXqCmCa/TDNSdopCMK+wMbhPEiaVdRn+nedEI/QYvqOUn
	 ux/OqkgidgOjfkjr80zKnQ/NEtljAe/jUXPrK0F/EmSZZH+q+RAKCMHenbY4/sN/jhFXL
	 oCRW1MHsbvhkbSUkd9huhGkFOvglHwVDa3XrhiOFT2M/kDqGHL2POrrYCSYn9NECnuDEg
	 jOkMGXDU3QCu1Z7vnkZeXRILuOSeTYDziD5V74MGFLsDzhjM/+7Y8ncEtRuajmTF2Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=QcFFaqCc;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A2F606A333
	for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 05:33:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97A2F606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=QcFFaqCc
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso5231765e9.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 21:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795152785; x=1795757585; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JswpRUgs5UDlZob8ca9OhYXkbPtKRKpD9M0ivfXIf2w=;
        b=QcFFaqCcgUvXp7C3GXMPglApgrbgGCt4/FTyv8JIGmaP58NxT3HH1xRJfcHk4NWOXq
         RyCwe5M5tLRWbemioz0plY5yAcZxsdzXMiMh/p3Sj6RZA+Nh2K3cRO/3LcjDXc0p5fnx
         452gHcgxHynDRuGAarpTrip1o0Jhhm+jI+EDPT1gYkzXaBWCR0s8+BpTpQaAEPHZfa01
         Yo8l2Vic9KDg8kgr15mNPJrIfxWoYu6k4VoDJWAnCxbI6+JZqEQ1co2JovGWSruaSzEQ
         2Njx5JaNE4GZ8cktrlU5PN/URIfq0jkLUwQh2yFStFWOMu5JEz+Pg1tDCe+Iat1h+cbU
         i4WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795152785; x=1795757585;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JswpRUgs5UDlZob8ca9OhYXkbPtKRKpD9M0ivfXIf2w=;
        b=2L5IBDynFAOplBmbkjmYqgwQ9eTe6dbZVY2AonqaucnM0UwR5imJL7Y4rImlUX/vPT
         CK5nNUrb2Nx2ZhP6sUNeIgl5RdzKcK9wwzRXCMBT4BfDByT/0Dc1baWpRTF93I5L5H5+
         jlGcec0S+3tYYDt2dzYTlvGPpa8FQ2/mSBCpBi3l2ihVSeWqke54EnMTqLQIuVesy5x4
         0YW+j0jnL5xEDXoUQawlAew73PM+6iXPpUfoOjAaRelJb7hfj62N9A/qqDumYbdmnlvO
         IoV+cZYYYz7Uj2UqS1ui5/O1KpXNXkKuSPmZ8rYLtAQyXF1oz/ALijf1xhH8S1GREVNk
         Hu3Q==
X-Forwarded-Encrypted: i=1; AL+hErHw8atlrw6VmiJY6H/CY2ko+n52x8qkd+Dk2Eo0W+i54sc0qoVJJ/RvIjoUAh1aTpckE/nsir0=@lists.linux.dev
X-Gm-Message-State: APuU4Z9j6Us4HRpPFbv+NCVnbcuGLejJ4IXjX79ykspkw463UwmMPCv1
	ky0KxEEdXGqjnTpTOFBd7JaXNyMbckJfudllMaYzbbg035cyXpr84k4yu/MFHQEIOTQ=
X-Gm-Gg: AYBFou1di8S/ipVJZw5cf1Gv5tpdhMz2v0oeT2KXmH19zxQpZvG0lqNThkwCvch0J8M
	xPE/wylres+idm81vtcCTDt5Tc3OjyxAIMDl9BmitUiRcwXOIgiEa3ON5bGZFNFggEA/wjcZMJL
	aMkrouj6NA5dUy00lsU+6Mr6rmNLBnvcp+IWCvqOYIyxYszP2y3WZucBUuWPssd72w2BMTo041k
	NmVwjyviKJrb3Em5KTVvS5l1dzJDwTxRz++b3R1W0D0wiM3GeUJGATf/NeWiwo83oOE3pKhl/mY
	WFOi9I0kQE9jGGVxoUmyTXJA54vwzJA/D7TCkCHGQ+neZsXDdONfZ4zC+nxyVr0WYevq2nVJz/8
	iaHaAIKkNS/TgPRBUWkB17TnFTZR4wkJy5d4ORU/pFaB4aAgcwuAUu3XONSaVhk/5p8akVlf/Xb
	p5pu5ou0hfoVOAMc4lz2Fgu/HBiebnE/Edf8qmIvOvJhrTNpvpy1/gBca5J7+D9sf6AMbBgPmp1
	vBLgtb4oPFla+xM0QHH71fvTCc6sGA+xKkeLzqnJwJO2kecHhwji5ddZPuPJEkjTk6LpLEbzzt3
	jhN79IuyJR1EcB14m8E=
X-Received: by 2002:a05:600d:82c5:b0:4a3:5aee:2c25 with SMTP id 5b1f17b1804b1-4bb88822642mr42560215e9.31.1795152784546;
        Thu, 19 Nov 2026 21:33:04 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88442693sm48629875e9.1.2026.11.19.21.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 21:33:03 -0800 (PST)
Date: Fri, 20 Nov 2026 08:33:00 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jintack Lim <jintack.lim@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] KVM: arm64: Trap TCR2_EL1 writes when S1PIE or
 S1POE is hidden
Message-ID: <av_bjCyoM93HColG@stanley.mountain>
References: <20261119-nv-tcr2-v2-0-3deb1a6cdba8@pereq.eu>
 <20261119-nv-tcr2-v2-2-3deb1a6cdba8@pereq.eu>
 <86wlq8zssf.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fvYP6yF1qK5VM2os"
Content-Disposition: inline
In-Reply-To: <86wlq8zssf.wl-maz@kernel.org>

--fvYP6yF1qK5VM2os
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 19, 2026 at 04:32:00PM +0000, Marc Zyngier wrote:
> On Thu, 19 Nov 2026 13:25:35 +0000,
> Dan Carpenter <dan@pereq.eu> wrote:
> > 
> > A VMM can offer FEAT_TCR2 to a guest but hide FEAT_S1PIE or FEAT_S1POE,
> > for example this is done to keep the VM migratable.  KVM then stops
> > loading the PIR_EL1, PIRE0_EL1 and POR_EL1 registers for that guest.  But
> > the guest's writes to the TCR2_EL1 register don't trap, and the CPU still
> > acts on its PIE, POE and E0POE bits.
> > 
> > If a guest turned these features on, it would run with the permission
> > settings another VM left on the CPU.  Technically this is a kind of
> > information leak and a guest could figure out another guests permission
> > setting based on which accesses fault.
> > 
> > For these VMs, set the TCR_EL1 bit in HFGWTR_EL2 so that writes to
> > TCR_EL1 and TCR2_EL1 trap, and clear the hidden bits in a new
> > access_tcr2_el1() handler.
> > 
> > Fixes: 58627b722ee2 ("KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is not advertised to the guest")
> > Fixes: b86c9bea6349 ("KVM: arm64: Save/restore POE registers")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Dan Carpenter <dan@pereq.eu>
> > ---
> > v2: This is a new patch
> > 
> > This is only a partial fix, I will update nested virtualization in the
> > next patch and the !vcpu_has_nv(vcpu) condition in __compute_hfgwtr() will
> > go away.
> 
> No, I really don't want to go down that road.
> 

Yeah.  Thanks, Marc.

I'm still a KVM newbie.  I'm embarrassed I sent that in retrospect.  I
had Claude create a checklist based on analysing your review comments so
I can hopefully get ahead of it a bit.  Attached for your amusement.
Apparently 10% of the time your review is "Why?"

Also Claude says that it could have found the Sashiko bugs by reviewing
patches to see if any different bugs get exposed by making a fix.  We
shall see.

Btw, I'm still hoping to get you that selftest but I need to send a few
more fixes first.

regards,
dan carpenter


--fvYP6yF1qK5VM2os
Content-Type: text/markdown; charset=us-ascii
Content-Disposition: attachment; filename=marc-review-checklist.md

# Predicting Marc Zyngier's review comments (KVM/arm64)

From 1000 of Marc's review emails (`~/progs/kernel/tmp/maz_reviews/sample/`), read in four parts, plus his
replies to our own patches in November 2026.  The counts are emails per 1000 (rough).  The checklist is the
part to use; the rest explains it.

## Pre-send checklist

**Rationale and correctness**
- [ ] The commit message says *why*, with the concrete sequence of events that goes wrong.  "Why?" / "What
      is the rationale?" is his most common question (~100).
- [ ] The behaviour matches the ARM ARM (or the GIC/PSCI spec), using its terms: UNDEF, RES0, CONSTRAINED
      UNPREDICTABLE.  Cite the section if it isn't obvious.  Not "what QEMU does" or "what x86 does" (~95).
- [ ] The root cause is fixed rather than papered over.  A WARN stays until the bug behind it is fixed.

**Cost**
- [ ] Nothing new runs on every entry or exit, and nothing new traps, unless it has to.  Prefer
      vcpu_load()/vcpu_put() or a static key.  Don't make VMs without the feature pay for it.  Under nested
      virtualization, ID-register reads and EL2 accesses trap, so count them.  Any performance claim needs
      numbers from an exit-heavy workload such as hackbench (~55).
      *Ours:* trapping TCR_EL1 to fix TCR2 got "an absolute performance sink"; the `loaded` checks in
      kvm_inject_nested() got "fast-path bloating".

**Minimal fixes**
- [ ] The smallest backportable change: no rework, no churn (renames, reordering, moving files,
      guard() conversions), no speculative fields or hooks, no Kconfig options ("battery included") (~40).
- [ ] Fixes: points at the real culprit, and only at something actually broken.  Cc: stable only if the
      backport is worth having (~30).

**Reuse**
- [ ] Use the existing infrastructure instead of a parallel mechanism: generated sysreg definitions,
      config.c feature maps, FGT/FGU, the trap tables, sanitised registers, vcpu requests, existing helpers.
      No magic numbers or duplicate definitions; use BIT()/GENMASK()/FIELD_PREP() (~55).

**Nested virtualization**
- [ ] Nested virtualization is VHE-only, and nVHE is effectively dead for new features.  Don't add code for
      combinations that can't exist.
- [ ] A new trap register comes with everything it traps: encoding_to_cgt[]/encoding_to_fgt[] entries, FGU,
      RES0/RES1 in kvm_init_nv_sysregs(), and VNCR where it applies.  No half-done features.
- [ ] Keep nested-only hacks local, so that someone who doesn't think about nested virtualization can't undo
      them by accident.

**Userspace ABI**
- [ ] Assume any VMM, in any order, and saving or restoring at any time; not only QEMU.  No KVM-internal state
      in the UAPI, and no new capabilities for KVM's own problems.  Tracepoints and stats are ABI.  Choose the
      errno with care.  Ask whether a WARN can be triggered from userspace: it panics under pKVM (~65).

**Locking**
- [ ] For each lock, READ_ONCE() or preempt_disable(), know what it protects against, and what stops the vcpu
      running or the value changing "behind your back" (~45).

**Code style** (~70, mostly "nit:")
- [ ] Clear names (not "Java-esque"); one helper per job, written once, no single-caller one-liners; no
      unneeded inline/__always_inline; no macro abuse.
- [ ] Comments only where the reason isn't obvious; no stale, wrong or obvious ones.
- [ ] Don't break lines just for 80 columns; he ignores checkpatch line length.

**Commit message**
- [ ] Short and technical: not a cover letter, not a recap of earlier versions, not marketing, no "No
      functional change intended" restating what was said.  It matches the code.  The subject says what the
      patch really does, with the right prefix ("KVM: arm64:", "KVM: arm64: nv:") (~40).

**Series and process**
- [ ] One logical change per patch, bisectable, documentation and UAPI in their own patches, the feature
      enabled last, each hunk in the patch that uses it (~45).
- [ ] A cover letter; a "Changes since vN" log for each version; Cc the maintainers and earlier reviewers;
      based on kvmarm/next or -rc1..-rc3, and only fixes after about -rc6; tested, and say how (QEMU as well
      as kvmtool, 64K pages, lockdep, a selftest for anything with a reproducer) (~60).
- [ ] When he replies with a diff ("completely untested", "How about this instead?"), take it.  If he writes a
      comment, paste it in verbatim.

## What makes him blunt

Ignored review comments, missing changelogs, maintainers left off Cc, untested code ("I stopped reading
here"), churn, hand-waving about performance without numbers, "go read the x86 patch", and wrong bot
findings.  He does credit correct bot findings ("Sashiko has spotted an interesting corner case") and
accepted a patch with "Assisted-by: Claude" without comment: what matters is whether the content is right.

## Our own patches, November 2026

| Patch | His comment | Checklist item |
|---|---|---|
| NULL deref v1, `loaded` checks | fast-path bloat; load the vcpu in the ioctl instead | Cost, minimal fixes |
| AT TCR2 v1 | asked for a comment explaining why it works; gave one | Paste his comment verbatim |
| TCR2 trap patches | trapping TCR_EL1 is a performance sink; load 0s instead | Cost |
| mmio_needed (Sashiko) | "multiple ways to commit" the exception state | Root cause, reuse |

--fvYP6yF1qK5VM2os--
