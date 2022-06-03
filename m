Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118B8C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  4 Jun 2022 08:02:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 823514B12E;
	Sat,  4 Jun 2022 04:02:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ji-yh72XcQCP; Sat,  4 Jun 2022 04:02:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 405714B2D9;
	Sat,  4 Jun 2022 04:02:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07EAD4B188
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 23:00:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G7NzLKgkNFay for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2022 23:00:37 -0400 (EDT)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C05B4B187
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 23:00:37 -0400 (EDT)
Received: by mail-pg1-f180.google.com with SMTP id u4so3274669pgk.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jun 2022 20:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=RwFDZoCKq6fRLpZhunBY9Ur7VEe8OCcwwcPl9yDvt18=;
 b=QPWow0hQecnmpFGS7YMEdI7KwxvdgX9AsYIbJdi8dH7ZC5xhb+d9ItKtCT9jTHTuBS
 dBHD+IwKfuP8omTmLlp+cDtSQ8WSup1UWi6QZEJdHwh4ouZIk2COzym7AxHRTfx4OVMs
 czR4VHmG4mHYvIfqtQ6Z4kK7GrHUeqr+lI7tOZsDQyEJJ3X5yLFCA+IVxyKRkGwYqbAO
 +8gvILQFJxskBB8dPwmDouG+VxgS+40HzpnwYCOTd6ShOYSuiEkvMj9ZsxP0HoNrcZyk
 LWLv3lYqFdn/HO84j7VFUw/qapYdaDIHY9wHo+A8AiPgXiEfFLEcRWUphndn5y/N8J9d
 b2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=RwFDZoCKq6fRLpZhunBY9Ur7VEe8OCcwwcPl9yDvt18=;
 b=0N0+sOKL3Z55e8wZnAFaA4+JX6xhUCqASYAMMMkrvc4w5VprwM4ybJXhZSbU3XFo3W
 6WScXxjawkB+ALXdonq2PDgQM4hNtl25xc2SMrUr5n2FplGnL5l5NNauyQIJAEh8rY3c
 m+I61QLNziyyq2bt/EPkAGrYzjsZaAltcaOAivxqkprShiT1vga5O1pf9mEsxlvDdNt/
 sQHhuIfmY3v/gPGet1iRhQfWPyTmDzw68P4rPq6aGp+MRN5e7XcZmsgccVXED102izwo
 sdCxc/4H7ySJ305xUJ9mOlv0B7vZTfHeIWO/vhHa6y9ASE5egou+8jD5o6DRi481RR7W
 SLVQ==
X-Gm-Message-State: AOAM532gc20v/czPWkWABXivCHC0xRkMqeKZAByqVVxeI8/dehyaPMBT
 IMOuOAvsKER2JTDFujNmXWGkIQ==
X-Google-Smtp-Source: ABdhPJxxk/mfZYwb8WfRHHkXp7YCcWVr4qixNf3FOqBTH/6gN8fx0bmdVeZo61Yw9D7FBRcNy8HjZA==
X-Received: by 2002:a65:6b8a:0:b0:3db:7dc5:fec2 with SMTP id
 d10-20020a656b8a000000b003db7dc5fec2mr6697410pgw.223.1654225235675; 
 Thu, 02 Jun 2022 20:00:35 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:200:c7ef:20a0:cd88:8a86])
 by smtp.gmail.com with ESMTPSA id
 t19-20020a63dd13000000b003c14af50617sm4086524pgg.47.2022.06.02.20.00.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Jun 2022 20:00:34 -0700 (PDT)
Date: Thu, 2 Jun 2022 20:00:29 -0700
From: Peter Collingbourne <pcc@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
Message-ID: <Ypl5TdMN3J/tttNe@google.com>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-60-will@kernel.org>
 <CAMn1gO4_d75_88fg5hcnBqx+tdu-9pG7atzt-qUD1nhUNs5TyQ@mail.gmail.com>
 <CA+EHjTx328na4FDfKU-cdLX+SV4MmKfMKKrTHo5H0=iB2GTQ+A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTx328na4FDfKU-cdLX+SV4MmKfMKKrTHo5H0=iB2GTQ+A@mail.gmail.com>
X-Mailman-Approved-At: Sat, 04 Jun 2022 04:02:12 -0400
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Fuad,

On Fri, May 27, 2022 at 08:55:42AM +0100, Fuad Tabba wrote:
> Hi Peter,
> =

> On Thu, May 26, 2022 at 9:08 PM Peter Collingbourne <pcc@google.com> wrot=
e:
> >
> > On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
> > >
> > > From: Fuad Tabba <tabba@google.com>
> > >
> > > Return an error (-EINVAL) if trying to enable MTE on a protected
> > > vm.
> >
> > I think this commit message needs more explanation as to why MTE is
> > not currently supported in protected VMs.
> =

> Yes, we need to explain this more. Basically this is an extension of
> restricting features for protected VMs done earlier [*].
> =

> Various VM feature configurations are allowed in KVM/arm64, each requiring
> specific handling logic to deal with traps, context-switching and potenti=
ally
> emulation. Achieving feature parity in pKVM therefore requires either ele=
vating
> this logic to EL2 (and substantially increasing the TCB) or continuing to=
 trust
> the host handlers at EL1. Since neither of these options are especially
> appealing, pKVM instead limits the CPU features exposed to a guest to a f=
ixed
> configuration based on the underlying hardware and which can mostly be pr=
ovided
> straightforwardly by EL2.
> =

> This of course can change in the future and we can support more
> features for protected VMs as needed. We'll expand on this commit
> message when we respin.
> =

> Also note that this only applies to protected VMs. Non-protected VMs
> in protected mode support MTE.

I see. In this case unless I'm missing something the=A0EL2 side seems
quite trivial though (flipping some bits in HCR_EL2). The patch below
(in place of this one) seems to make MTE work in my test environment
(patched [1] crosvm on Android in MTE-enabled QEMU).

[1] https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+=
/3689015

From c87965cd14515586d487872486e7670874209113 Mon Sep 17 00:00:00 2001
From: Peter Collingbourne <pcc@google.com>
Date: Thu, 2 Jun 2022 19:16:02 -0700
Subject: [PATCH] arm64: support MTE in protected VMs

Enable HCR_EL2.ATA while running a vCPU with MTE enabled.

To avoid exposing MTE tags from the host to protected VMs, sanitize
tags before donating pages.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 4 +++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 6 +++---
 arch/arm64/kvm/mmu.c              | 4 +++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm=
_pkvm.h
index 952e3c3fa32d..9ca9296f2a25 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -73,10 +73,12 @@ void kvm_shadow_destroy(struct kvm *kvm);
  * Allow for protected VMs:
  * - Branch Target Identification
  * - Speculative Store Bypassing
+ * - Memory Tagging Extension
  */
 #define PVM_ID_AA64PFR1_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64PFR1_BT) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR1_SSBS) \
+	ARM64_FEATURE_MASK(ID_AA64PFR1_SSBS) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR1_MTE) \
 	)
 =

 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index e33ba9067d7b..46ddd9093ac7 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -88,7 +88,7 @@ static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
 	/* Memory Tagging: Trap and Treat as Untagged if not supported. */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), feature_ids)) {
 		hcr_set |=3D HCR_TID5;
-		hcr_clear |=3D HCR_DCT | HCR_ATA;
+		hcr_clear |=3D HCR_ATA;
 	}
 =

 	vcpu->arch.hcr_el2 |=3D hcr_set;
@@ -179,8 +179,8 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 	 * - Feature id registers: to control features exposed to guests
 	 * - Implementation-defined features
 	 */
-	vcpu->arch.hcr_el2 =3D HCR_GUEST_FLAGS |
-			     HCR_TID3 | HCR_TACR | HCR_TIDCP | HCR_TID1;
+	vcpu->arch.hcr_el2 =3D HCR_GUEST_FLAGS | HCR_TID3 | HCR_TACR | HCR_TIDCP |
+			     HCR_TID1 | HCR_ATA;
 =

 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
 		/* route synchronous external abort exceptions to EL2 */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 392ff7b2362d..f513852357f7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1206,8 +1206,10 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phy=
s_addr_t fault_ipa,
 		goto dec_account;
 	}
 =

-	write_lock(&kvm->mmu_lock);
 	pfn =3D page_to_pfn(page);
+	sanitise_mte_tags(kvm, pfn, PAGE_SIZE);
+
+	write_lock(&kvm->mmu_lock);
 	ret =3D pkvm_host_map_guest(pfn, fault_ipa >> PAGE_SHIFT);
 	if (ret) {
 		if (ret =3D=3D -EAGAIN)
-- =

2.36.1.255.ge46751e96f-goog
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
