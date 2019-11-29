Return-Path: <SRS0=MZYq=ZV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17008C432C0
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 09:46:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94E34215F1
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 09:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KvAVfzoK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94E34215F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A5514AEB9;
	Fri, 29 Nov 2019 04:46:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T4fXn+hxNa-M; Fri, 29 Nov 2019 04:45:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4FD24A959;
	Fri, 29 Nov 2019 04:45:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FBA14A959
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 04:45:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3K5HQrN6Mzno for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Nov 2019 04:45:57 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32DBA4A7FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 04:45:57 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id y11so31181174wrt.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 01:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=Q4axS6eIwXwN3B1aEypTWu1EhtwhYStbSp0D0vgtDmg=;
 b=KvAVfzoKAbKRVu4rW16GXZ0R71nTETxAall8fBRlV85PTaop9uYVJbog8hBv5MGh/d
 GUUYhWxFaFfjlhlb9/Ce6iIfiKuVEV5zJVRDAwv+sBOH37mZH5wple/9lz0nI1rw0naJ
 lr2MIwXDh6Dg9PNoaB7TKeWQfnja9G/q++swyN2Ik+rTPQXdzUBAoz4a35lfxHMpvx83
 SHOC18+V0UXPAtYX4m1LYjEEefa6UYZKH/g4yUkznkpM3NStNzFzD3WpKI3xr8aFJH8Z
 ABCSrz17KV4/nCmN4zQyvmAOgxcvu1opxXkwVaSKeRkVaM2lunrWyia3poZ9u8DD8uA4
 IkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=Q4axS6eIwXwN3B1aEypTWu1EhtwhYStbSp0D0vgtDmg=;
 b=s8adIz5zjaRxxEXYnTeTPpaKInWBgPNrvdtqtO9/L/lP9PaCCRRPQyjQwOozcAVVQ/
 HkhcDmEs8OxgJBGpL2UtjWRqzCYlVKpH0xY0iWx5Wy5fCmdIsi57vAdR7Yf+aemqW/bY
 k7H6+Dhk20Lxs9hE5GbIV1xKsOyfi53+EgAjyOKSL4XABd2R7PC8edqrqQOBh2MQanRI
 pFoAWXF7vdR1svalS6lw4m7AEZKw6nSB2QqVyQYswpvIXzORHRXOHh44ObV7bTrwUqpR
 1zAjDKL7JbyPFNQFdW5x4R26A66FGEYFlec9EQ9byFtcRjH5VHe0BRvtipTjx+s5+T5J
 nglA==
X-Gm-Message-State: APjAAAWNLFBJ6iLdyDnVa5msZ+0dFJBwgEv5TH1gqee/zIzVVeD/kl0Q
 NUEsZjaGd3BD0aKnbaZBykw=
X-Google-Smtp-Source: APXvYqyftnTdsmUvsLO6HTRsQ0aYAbyextWego9GfGBJcnv3CqMmmOBav3gaS7BtqdgxSlbzyW/MtQ==
X-Received: by 2002:adf:de84:: with SMTP id w4mr17413903wrl.97.1575020756017; 
 Fri, 29 Nov 2019 01:45:56 -0800 (PST)
Received: from localhost (ec2-34-244-242-0.eu-west-1.compute.amazonaws.com.
 [34.244.242.0])
 by smtp.gmail.com with ESMTPSA id u16sm26879784wrr.65.2019.11.29.01.45.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 29 Nov 2019 01:45:55 -0800 (PST)
Date: Fri, 29 Nov 2019 10:45:57 +0100
From: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/3] target/arm: Handle trapping to EL2 of AArch32 VMRS
 instructions
Message-ID: <20191129094557.GB25295@toto>
References: <20191128161718.24361-1-maz@kernel.org>
 <20191128161718.24361-4-maz@kernel.org>
 <20191129082806.GF29312@toto>
 <3a53b096bd101f9627d4c61ecfd742de@www.loen.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3a53b096bd101f9627d4c61ecfd742de@www.loen.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: richard.henderson@linaro.org, qemu-devel@nongnu.org,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Nov 29, 2019 at 09:24:37AM +0000, Marc Zyngier wrote:
> On 2019-11-29 08:28, Edgar E. Iglesias wrote:
> > On Thu, Nov 28, 2019 at 04:17:18PM +0000, Marc Zyngier wrote:
> > > HCR_EL2.TID3 requires that AArch32 reads of MVFR[012] are trapped to
> > > EL2, and that HCR_EL2.TID0 does the same for reads of FPSID.
> > > In order to handle this, introduce a new TCG helper function that
> > > checks for these control bits before executing the VMRC instruction.
> > > 
> > > Tested with a hacked-up version of KVM/arm64 that sets the control
> > > bits for 32bit guests.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  target/arm/helper-a64.h        |  2 ++
> > >  target/arm/internals.h         |  8 ++++++++
> > >  target/arm/translate-vfp.inc.c | 12 +++++++++---
> > >  target/arm/vfp_helper.c        | 27 +++++++++++++++++++++++++++
> > >  4 files changed, 46 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/target/arm/helper-a64.h b/target/arm/helper-a64.h
> > > index a915c1247f..311ced44e6 100644
> > > --- a/target/arm/helper-a64.h
> > > +++ b/target/arm/helper-a64.h
> > > @@ -102,3 +102,5 @@ DEF_HELPER_FLAGS_3(autda, TCG_CALL_NO_WG, i64,
> > > env, i64, i64)
> > >  DEF_HELPER_FLAGS_3(autdb, TCG_CALL_NO_WG, i64, env, i64, i64)
> > >  DEF_HELPER_FLAGS_2(xpaci, TCG_CALL_NO_RWG_SE, i64, env, i64)
> > >  DEF_HELPER_FLAGS_2(xpacd, TCG_CALL_NO_RWG_SE, i64, env, i64)
> > > +
> > > +DEF_HELPER_3(check_hcr_el2_trap, void, env, int, int)
> > > diff --git a/target/arm/internals.h b/target/arm/internals.h
> > > index f5313dd3d4..5a55e960de 100644
> > > --- a/target/arm/internals.h
> > > +++ b/target/arm/internals.h
> > > @@ -430,6 +430,14 @@ static inline uint32_t syn_simd_access_trap(int
> > > cv, int cond, bool is_16bit)
> > >          | (cv << 24) | (cond << 20) | (1 << 5);
> > >  }
> > > 
> > > +static inline uint32_t syn_vmrs_trap(int rt, int reg)
> > > +{
> > > +    return (EC_FPIDTRAP << ARM_EL_EC_SHIFT)
> > > +        | ARM_EL_IL
> > > +        | (1 << 24) | (0xe << 20) | (7 << 14)
> > > +        | (reg << 10) | (rt << 5) | 1;
> > > +}
> > > +
> > >  static inline uint32_t syn_sve_access_trap(void)
> > >  {
> > >      return EC_SVEACCESSTRAP << ARM_EL_EC_SHIFT;
> > > diff --git a/target/arm/translate-vfp.inc.c
> > > b/target/arm/translate-vfp.inc.c
> > > index 85c5ef897b..4c435b6c35 100644
> > > --- a/target/arm/translate-vfp.inc.c
> > > +++ b/target/arm/translate-vfp.inc.c
> > > @@ -759,15 +759,21 @@ static bool trans_VMSR_VMRS(DisasContext *s,
> > > arg_VMSR_VMRS *a)
> > >      }
> > > 
> > >      if (a->l) {
> > > +        TCGv_i32 tcg_rt, tcg_reg;
> > > +
> > >          /* VMRS, move VFP special register to gp register */
> > >          switch (a->reg) {
> > > +        case ARM_VFP_MVFR0:
> > > +        case ARM_VFP_MVFR1:
> > > +        case ARM_VFP_MVFR2:
> > >          case ARM_VFP_FPSID:
> > > +            tcg_rt = tcg_const_i32(a->rt);
> > > +            tcg_reg = tcg_const_i32(a->reg);
> > > +            gen_helper_check_hcr_el2_trap(cpu_env, tcg_rt,
> > > tcg_reg);
> > > +            /* fall through */
> > >          case ARM_VFP_FPEXC:
> > >          case ARM_VFP_FPINST:
> > >          case ARM_VFP_FPINST2:
> > > -        case ARM_VFP_MVFR0:
> > > -        case ARM_VFP_MVFR1:
> > > -        case ARM_VFP_MVFR2:
> > >              tmp = load_cpu_field(vfp.xregs[a->reg]);
> > >              break;
> > >          case ARM_VFP_FPSCR:
> > > diff --git a/target/arm/vfp_helper.c b/target/arm/vfp_helper.c
> > > index 9710ef1c3e..44e538e51c 100644
> > > --- a/target/arm/vfp_helper.c
> > > +++ b/target/arm/vfp_helper.c
> > > @@ -1322,4 +1322,31 @@ float64 HELPER(frint64_d)(float64 f, void
> > > *fpst)
> > >      return frint_d(f, fpst, 64);
> > >  }
> > > 
> > > +void HELPER(check_hcr_el2_trap)(CPUARMState *env, int rt, int reg)
> > > +{
> > > +    if (arm_current_el(env) != 1) {
> > > +        return;
> > > +    }
> > 
> > I think we could move the EL1 check to translation time, couldn't we?
> 
> I think that depends whether the translated code is tagged by EL
> or not, or if an exception entry (and exception return) invalidates
> the JIT-ed code (and it this case it would have to be CPU-private).
> 
> I can perfectly imagine the same piece of code being executed both
> at EL0 and EL1, and this would fail if it was executed using the
> same JIT-ed code.
> 
> So if QEMU gives us the above as a guarantee, we're good. Otherwise,
> we need this check. How can I find out?

Hi Marc,

IIRC, the current EL was always known at translation time but I've
not been tracking recent changes.

There are several ways to check this, one way is to look in
cpu_get_tb_cpu_state() and see if the state needed to extract the
the EL goes into the TB-flags.

Another way is to look in arm_tr_init_disas_context() and see what gets
extracted from the tb_flags just before translating a block.

From arm_tr_init_disas_context():
    dc->current_el = arm_mmu_idx_to_el(dc->mmu_idx);

Unless I'm missing something it's still there, so I think this could be
done at translation time. Peter?

Cheers,
Edgar
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
