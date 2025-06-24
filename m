Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D002EACEA
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 20:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750795511; cv=none; b=Cyzgit4OxciKIkjxri9n0ru24JSD8UFDJDe8JEbPlmi6Xq4AzAejETVQREjqoOcrPIqIfL6mDJaregHXu0k92O+ZBBhCL8II9TtHn3mDjHX4a87EvE8IBLG6YB17qOFLSLvUQ7Tu6bjWqoxwbcDbZkZmcFdTFUomSVCfPK8F6iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750795511; c=relaxed/simple;
	bh=RPF3bPV+itVK+0pJ7f0TUuUy5/dRgnn4yOTV9q1YTkM=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=qgeKvVjBxTUXzAo2EobY/q7MeqFIArBGR1SjzcCApzIFR+eCPVQV7OEv1rcyErZXbrhn4pRTzUPabQHDxmOJU+9BAMZiMhgMbHPnE8ZtiEuaS0qOzarxTWZ2wNHwzjFExwZiYIl2mlspYEyk2slw3oq8C4/Knvlj+5gRgw/iCec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ButgWaq/; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ButgWaq/"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3df300ab18eso12140825ab.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 13:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750795507; x=1751400307; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O0o3enCtFoZv08yCvYAb3ahMkA4aWNe6wCokY+DYhpY=;
        b=ButgWaq/5JW8KJkVdshId5McCJnkb2RCIaYAchVt6vVKlEJbGPUI07/wSs4+ObevXe
         oRrZq6s3+hUllCKG/DxTESmqbryOvAqoNvAVZqKV81roUQKmXpvGvqyuuPS8673jAJtA
         kvSXad12rrNmgQdNuLNraNXPSKhweQQWijBjYBqx4ky8Hk17/8OllDieDoTcxL0Wy9nA
         m2JUZV2RmEOgcgSlwsTR8alruUDR91FuYujbDd7s3zlicNUPin5/kfp4UC+bWf+hPRb+
         mP10Bm5ZaJSo5OC+ietuPp338CEJmBOzh2mEVaGmJFZ91difC2GONtp4LTTdcChoGQB+
         f/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750795507; x=1751400307;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O0o3enCtFoZv08yCvYAb3ahMkA4aWNe6wCokY+DYhpY=;
        b=UN2c9wvlr4oAB8wPzTtFP3ng2nDSGVcuUe3OoKpkSsVOpBnHnN/qrLlHHqRPWTbBkh
         ab8rDkwFYqWuj5MZ7tvOLD7GQoMEWxlI+h1wUrEZl+Vf1dXDdIjYZBGFqFbTuVJAGHOK
         VyOxp2lKVr2MmCaEm+YnPs38pnG0HFGW0rOJcR1aplPAk8Nknws4nCYILQmk1vTQlFYW
         /W3erMH5oHFjGHMBInao0gKudR6Xk8tGqAiuLa3hQalToNGeNbU+IIhtOEOdYJcYNZ6z
         vPfEC1twDxnA7euVCM5P6GHThctEwdbIlFx3gZ5UE8iKJ/3nHoqjHNX6Bu/MOrOSBUks
         Zxig==
X-Forwarded-Encrypted: i=1; AJvYcCWpwV7Byn3HYTm9nJfN/OUcAo28FON7IBr5DbNrnXxEU1MWmz4tyEOKOgG+kNKD0qhJrAkvz1E=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywp7C1ymyh2t+Mgb4HS+jvWabn3HZoVSk5r89IfKlKaFaKPXAr6
	5zCYV+Z/DUt7I/og/qbvoc9S+e/ynlNRcRmELr06OUWpKt2z5ZB8KHWK50fY3lTYNXlLxRQBePI
	bffSgjub+7d8srnDIznohomSWYQ==
X-Google-Smtp-Source: AGHT+IFRBaniVPLdqgtBiY+RRt9A60KwZhLUhr0WNUCFuq3s9GR9zjSj1vgrB9faZftbsD7qku7K0VwW+GoO4k+cFw==
X-Received: from ilbbr10.prod.google.com ([2002:a05:6e02:23ca:b0:3dd:7629:ec3a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:2163:b0:3dd:c04e:49af with SMTP id e9e14a558f8ab-3df327eeacfmr6647305ab.3.1750795506770;
 Tue, 24 Jun 2025 13:05:06 -0700 (PDT)
Date: Tue, 24 Jun 2025 20:05:05 +0000
In-Reply-To: <aFpThZIE2PxjVAVw@linux.dev> (message from Oliver Upton on Tue,
 24 Jun 2025 00:28:05 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntcyasaosu.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 01/23] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Mon, Jun 23, 2025 at 06:25:38PM +0000, Colton Lewis wrote:
>> Oliver Upton <oliver.upton@linux.dev> writes:

>> > On Fri, Jun 20, 2025 at 10:13:01PM +0000, Colton Lewis wrote:
>> > > Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
>> > > counters reserved for the guest.

>> > > This required changing HPMN0 to an UnsignedEnum in tools/sysreg
>> > > because otherwise not all the appropriate macros are generated to add
>> > > it to arm64_cpu_capabilities_arm64_features.

>> > > Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> > > ---
>> > >   arch/arm64/kernel/cpufeature.c | 8 ++++++++
>> > >   arch/arm64/tools/cpucaps       | 1 +
>> > >   arch/arm64/tools/sysreg        | 6 +++---
>> > >   3 files changed, 12 insertions(+), 3 deletions(-)

>> > > diff --git a/arch/arm64/kernel/cpufeature.c
>> > > b/arch/arm64/kernel/cpufeature.c
>> > > index b34044e20128..278294fdc97d 100644
>> > > --- a/arch/arm64/kernel/cpufeature.c
>> > > +++ b/arch/arm64/kernel/cpufeature.c
>> > > @@ -548,6 +548,7 @@ static const struct arm64_ftr_bits  
>> ftr_id_mmfr0[] = {
>> > >   };

>> > >   static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
>> > > +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,
>> > > ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
>> > >   	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,
>> > > ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
>> > >   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE,
>> > > ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
>> > >   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,
>> > > ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
>> > > @@ -2896,6 +2897,13 @@ static const struct arm64_cpu_capabilities
>> > > arm64_features[] = {
>> > >   		.matches = has_cpuid_feature,
>> > >   		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
>> > >   	},
>> > > +	{
>> > > +		.desc = "Allow MDCR_EL2.HPMN = 0",

>> > This feedback still stands...

>> > 		.desc = "HPMN0",

>> > [*] https://lore.kernel.org/kvm/aD4ijUaSGm9b2g5H@linux.dev/

>> Sorry for ignoring your previous feedback. I looked at the other .desc
>> fields and they had more descriptive English, so I think this one should
>> be more than "FEAT_HPMN0" for consistency.

>> If you insist I'll change it.

> I'm not exactly sold on the merits of using descriptive names for the
> capabilities, as the architecture extension names are exact terms that
> can be related back to documentation.

I'll change it.
