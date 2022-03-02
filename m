Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93543C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 11:53:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9F7C49EAA;
	Wed,  2 Mar 2022 06:52:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RUlvmSFP2+SA; Wed,  2 Mar 2022 06:52:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B0A49EB1;
	Wed,  2 Mar 2022 06:52:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A6B949E46
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 06:52:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v+2ytDbSWYXK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 06:52:57 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20E9149E43
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 06:52:57 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1E2FF618A0;
 Wed,  2 Mar 2022 11:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE279C004E1;
 Wed,  2 Mar 2022 11:52:52 +0000 (UTC)
Date: Wed, 2 Mar 2022 11:52:49 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v11 03/40] arm64: cpufeature: Always specify and use a
 field width for capabilities
Message-ID: <Yh9akZaM+qeWPgEz@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-4-broonie@kernel.org>
 <Yh6kqaR9FQXg8Q4w@qian> <878rts3bpi.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <878rts3bpi.wl-maz@kernel.org>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Shuah Khan <shuah@kernel.org>, Alan Hayward <alan.hayward@arm.com>,
 Qian Cai <quic_qiancai@quicinc.com>, Mark Brown <broonie@kernel.org>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Mar 02, 2022 at 10:12:09AM +0000, Marc Zyngier wrote:
> On Tue, 01 Mar 2022 22:56:41 +0000,
> Qian Cai <quic_qiancai@quicinc.com> wrote:
> > 
> > On Mon, Feb 07, 2022 at 03:20:32PM +0000, Mark Brown wrote:
> > > Since all the fields in the main ID registers are 4 bits wide we have up
> > > until now not bothered specifying the width in the code. Since we now
> > > wish to use this mechanism to enumerate features from the floating point
> > > feature registers which do not follow this pattern add a width to the
> > > table.  This means updating all the existing table entries but makes it
> > > less likely that we run into issues in future due to implicitly assuming
> > > a 4 bit width.
> > > 
> > > Signed-off-by: Mark Brown <broonie@kernel.org>
> > 
> > Do we leave this one alone on purpose?
> > 
> >                 .desc = "GIC system register CPU interface",
> >                 .capability = ARM64_HAS_SYSREG_GIC_CPUIF,
> >                 .type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
> >                 .matches = has_useable_gicv3_cpuif,
> >                 .sys_reg = SYS_ID_AA64PFR0_EL1,
> >                 .field_pos = ID_AA64PFR0_GIC_SHIFT,
> >                 .sign = FTR_UNSIGNED,
> >                 .min_field_value = 1,
> >
> > Since width == 0, it will generate an undefined behavior.
> 
> I don't think that's on purpose, and we should definitely address
> this. Maybe we should have a warning if we spot an occurrence of
> .width being 0.

We should indeed have a check. Alternatively, assume the default to be 4
and convert all 0s to 4 during boot (less patch churn).

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
