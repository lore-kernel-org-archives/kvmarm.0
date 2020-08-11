Return-Path: <SRS0=6J9q=BV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A77AC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 14:53:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 716EF2083B
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 14:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="QVozODfu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 716EF2083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2B6F4B588;
	Tue, 11 Aug 2020 10:53:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aQoxUrnwAfeY; Tue, 11 Aug 2020 10:53:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A79794B4BD;
	Tue, 11 Aug 2020 10:53:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99FAA4B4B3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 10:53:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pCMgarw9fLH1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2020 10:53:44 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A8884B403
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 10:53:44 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id c19so2281673wmd.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 07:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=eMIJ86kQpuUqaE3aINktOUWIU0IlQ20q4ZeQoTTn5DE=;
 b=QVozODfuuA9QwtiLLiFfN0Du/Ax8NxV+1xejU3x7EHAjT9jTXIAZV4HgMVOvsIiauf
 AnU1Mt6nLxL4+/MZq+uc8VGWb3gb3Tx9TP/gmPOAN0egOuFXABa1XkFkz9bdEV85s6Rk
 kjFxr9OB2aONdOOIfvq80V8PfMhWmOzZCCOsDSXB2mb0goZ2MetBdEMLzPaitS6hCfWt
 MokvStsuBVaUTbObiEOtMm7+Uy4JuTvYuh5c/uhXJHFsxUs30hYE+MmtHrJUyk8GLqFp
 lbuZJmjxzGWqUJ/cF2J6nXrQLpWNNmOcof3Qc+nQE9XEsUAJm0PjaMAF6WRQM7LvqQ2J
 9B6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eMIJ86kQpuUqaE3aINktOUWIU0IlQ20q4ZeQoTTn5DE=;
 b=VQYSTMdwqHWEAgXCOcVogxNZmtlnurVPZYiRvRyAIzlEv+sTBIwSDjzIiJ53xtyfiP
 CjHEeDiTN5kHqBnmG8UHIJJzZeTVT4hZl+HS6uc6wt1mvZsT402coQn2fvMsDPKx7da/
 xJdvdNxPXWKh6Q2lpK81ZNS8+P40lTcGx5BTRJl+I1I53TZGw+09TkFlMPapNBjHtq7T
 0n/4ntz6HJIfKOS0toqB7MbIG3FYZ83qGkcMDQbm7UlMqyy5EAsR8gc+1oWno99jmokk
 u4HYZLB5Dtc1vYZbMFKhThc15SA96CPTl4G/v61K2oS76vaCSejBkdODfhPgk4KrQbqg
 ctXA==
X-Gm-Message-State: AOAM533ENiPXhht8h7CJWvMDyjurwqwvFBgVoiq5J8Pl9tWcJU0/p/47
 x8A5zuzEP9gguCZdfHknzBBTyQ==
X-Google-Smtp-Source: ABdhPJzm06K5oqObPnrW9h3kqvAPoXoJAB+pzqbixXPthjBk0BxG1TFPz3Jyw7xB83EAIbWj7gR4Zg==
X-Received: by 2002:a7b:c765:: with SMTP id x5mr4197943wmk.14.1597157623083;
 Tue, 11 Aug 2020 07:53:43 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id t14sm30379154wrg.38.2020.08.11.07.53.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 Aug 2020 07:53:42 -0700 (PDT)
Date: Tue, 11 Aug 2020 15:53:38 +0100
From: Andrew Scull <ascull@google.com>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
Message-ID: <20200811145338.GB2917393@google.com>
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
 <20200730223144.GA2022880@google.com>
 <6ecc47f3-4733-4f49-660f-f21229176efb@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6ecc47f3-4733-4f49-660f-f21229176efb@arm.com>
Cc: kernel-team@android.com, catalin.marinas@arm.com, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Aug 05, 2020 at 03:34:11PM +0100, James Morse wrote:
> Hi Andrew,
> 
> On 30/07/2020 23:31, Andrew Scull wrote:
> > On Thu, Jul 30, 2020 at 04:18:23PM +0100, Andrew Scull wrote:
> >> The ESB at the start of the vectors causes any SErrors to be consumed to
> >> DISR_EL1. If the exception came from the host and the ESB caught an
> >> SError, it would not be noticed until a guest exits and DISR_EL1 is
> >> checked. Further, the SError would be attributed to the guest and not
> >> the host.
> >>
> >> To avoid these problems, use a different exception vector for the host
> >> that does not use an ESB but instead leaves any host SError pending. A
> >> guest will not be entered if an SError is pending so it will always be
> >> the host that will receive and handle it.
> 
> > Thinking further, I'm not sure this actually solves all of the problem.
> > It does prevent hyp from causing a host SError to be consumed but, IIUC,
> > there could be an SError already deferred by the host and logged in
> > DISR_EL1 that hyp would not preserve if a guest is run.
> 
> I think that would be a host bug.
> 
> The ESB-instruction is the only thing that writes to DISR_EL1, and only if PSTATE.A is
> set. The host should:
> * Read DISR_EL1 after running the ESB-instruction,
> * Not call into HYP from SError masked code!

Good to know that this is the intent and not just what appears to happen
today.

> (VHE only does it to match the nVHE behaviour, as KVM isn't prepared to handle these).
> 
> 
> 'ESB-instruction' is pedantry to avoid the risk of it being confused with IESB, which is
> just the barrier bit, not the writes-to-DISR bit.
> 
> 
> > I think the host's DISR_EL1 would need to be saved and restored in the
> > vcpu context switch which, from a cursory read of the ARM, is possible
> > without having to virtualize SErrors for the host.
> 
> ... I thought this was a redirected register. Reads from EL1 when HCR_EL2.AMO is set get
> the value from VDISR_EL2, meaning the guest can't read DISR_EL1 at all.
> (see 'Accessing DISR_EL1' in the register description, "D13.7.1
> DISR_EL1, Deferred Interrupt Status Register" of DDI0487F.a

The host doesn't run with HCR_EL2.AMO set so it uses DISR_EL1 directly,
but hyp also uses DISR_EL1 directly during __guest_exit. That is the
clobbering I was concerned about. It may not be a problem most of the
time given what you said above, but I think something like the diff
below should be enough to be sure it is preserved:

 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 28f349288f3a..a34210c1c877 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -56,8 +56,12 @@ static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
 	ctxt->regs.pstate		= read_sysreg_el2(SYS_SPSR);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
-		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		if (kvm_is_host_cpu_context(ctxt))
+			ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_DISR_EL1);
+		else
+			ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
+	}
 }
 
 static inline void __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
@@ -152,8 +156,12 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 	write_sysreg_el2(ctxt->regs.pc,			SYS_ELR);
 	write_sysreg_el2(pstate,			SYS_SPSR);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
-		write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_VDISR_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		if (kvm_is_host_cpu_context(ctxt))
+			write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_DISR_EL1);
+		else
+			write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_VDISR_EL2);
+	}
 }
 
 static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)


> >> Hyp initialization is now passed the vector that is used for the host
> >> and the vector for guests is stored in a percpu variable as
> >> kvm_get_hyp_vector() is not suitable for calling from nVHE hyp.
> 
> 
> Thanks,
> 
> James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
