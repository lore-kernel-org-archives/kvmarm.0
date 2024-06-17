Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3302619412F
	for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 10:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718620067; cv=none; b=Euvjv3V4/cbf6I6BpXyGRXPowFRsYdcbqV97thuWBxbngkmaIbTnSNP+GnZ4CcOYTZzfh2L+MvV89/0LmYlNOTcXlAl65+fYS3QmXqKSAEtJT4wGP8xjoV+tp0JBgWLC8aaPawpIDdmr8jiCYz4dRA+ED4JSeD+HYNvivwMeVis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718620067; c=relaxed/simple;
	bh=t7JP/HGFJDwk2M/R92BFPhUlm/Hwfwtb8ue0IF8mlwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bl/KGRcsmrTX2RmLpuZwRC9xBMWlCR6wiwWw7yHEID1mJvVFc9Cku75Hvfeg7q1k1yxB20vmLYKFMzsjuXlWjpUrP8qucgMzXaRxj4GXXNhJzfHDWDVjSW1FTTVbkhL6C/bidFKSWDN2ZQR+vN+sNK7BJ7Z3fiM+MCiFOMqhx/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gjtQCnwJ; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gjtQCnwJ"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57c73a3b3d7so4718285a12.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 03:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718620062; x=1719224862; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uXp/Yz17OzdkV2gV0XI8xrmGqd5+ox1Pqhqcmx8WT9w=;
        b=gjtQCnwJDqN78DTZk6mXht69IUp+HhT8W5B17mqeODWi2yzXwUj98z3ORp7MuhmcM1
         nRlH1SFVC4E/dVwE9iIm7wazohG8Hacd2zQ1MUbZjumr6jldg66Hl34OlfRBB6Ek67hn
         1i/Pivw7+kC0/57jGDMGo2atk7ffjefUgvAxS/47tHWT9IujnjdEj80leGnHaSgedB5X
         Fxr5kRReP7R3s/cHdngSpAH7UCeytMYZUGwRU1AxY/1YVv+CI+iwc0+yHCvZyWCnqRQD
         Gf6TiJ/mmaRcsPLgHZpdd1Mf6nVihAEClh+kMf9xhCN8I3jD1de0jfWIpcPpnX838FHx
         UbnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718620062; x=1719224862;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uXp/Yz17OzdkV2gV0XI8xrmGqd5+ox1Pqhqcmx8WT9w=;
        b=gvdVSuRJbC6uoNO7S3Xk+McrOCbnIHKX4h1aUy0ffxr1bZoGpb4GvQ3i0nNVedGtD5
         TF67EvmjOzRVn02KWGoV0/q6W2J1msvjG15LFmw0beMkAKoQwvdK95sr/hBZYDJ6GaLL
         Iv/lRWAKRfFmhg9MRyhp22uspHk466j2KWhkJHB9LSE1MFM5cVf12SmiwAR3laXBTYdJ
         WLkz6Wp1kg79EBr4Gb357yo8BacZcsLTSR5auX9/+yX0j5YYF+G/4uTKFUCTm2Wk7kR5
         D/4iK1YLGg4IcupIs93XgjDaeSFQfFCnJfwDjnX1TI+QOQB0PyFCTYVo5mWWjSD1/Lij
         7fHg==
X-Forwarded-Encrypted: i=1; AJvYcCUk5LHoiIJ6N1RSw9OfE1K/7MFUKJ/SICoJSajiRjgMz/To5AOC3ItbB925SBWICmX79DQ8gmfOK5sdB9AeamiwQsGdvVxX
X-Gm-Message-State: AOJu0Yws0fqGEPdH+mMe3xRCwifo7Mbc7UiWuSCP/DMkHOyNuAF7282D
	J39RfMlgz3s3kbhLYoxLblBzm0bm4eHTe5YUba+fyuDj3lAUfEWChtWhUEtVYmKcddS+1J2eYsC
	ODMTTHKf0kl8Z4+CfAsMyeqGSTRtQekziCve4wg==
X-Google-Smtp-Source: AGHT+IHa1KyYv1IKw590sCplWvhogQlO8OvOBxMlNOdOwgi5TbD9kl95KoZfAoxfCiWfEz/NonSQTv/NuyiSNK1pPCg=
X-Received: by 2002:a50:a458:0:b0:57a:322c:b1a5 with SMTP id
 4fb4d7f45d1cf-57cbd6a6d1dmr5332493a12.38.1718620062388; Mon, 17 Jun 2024
 03:27:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605093006.145492-1-steven.price@arm.com> <20240605093006.145492-3-steven.price@arm.com>
 <20240612104023.GB4602@myrica> <3301ddd8-f088-48e3-bfac-460891698eac@arm.com> <20240613105107.GC417776@myrica>
In-Reply-To: <20240613105107.GC417776@myrica>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 17 Jun 2024 11:27:31 +0100
Message-ID: <CAFEAcA99bPtEr2OpE45wCgfSArZdtz4tu9rggLNb+=Rujh0ZvQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] arm64: Detect if in a realm and set RIPAS RAM
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Jun 2024 at 11:50, Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> On Wed, Jun 12, 2024 at 11:59:22AM +0100, Suzuki K Poulose wrote:
> > On 12/06/2024 11:40, Jean-Philippe Brucker wrote:
> > > On Wed, Jun 05, 2024 at 10:29:54AM +0100, Steven Price wrote:
> > > > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > >
> > > > Detect that the VM is a realm guest by the presence of the RSI
> > > > interface.
> > > >
> > > > If in a realm then all memory needs to be marked as RIPAS RAM initially,
> > > > the loader may or may not have done this for us. To be sure iterate over
> > > > all RAM and mark it as such. Any failure is fatal as that implies the
> > > > RAM regions passed to Linux are incorrect - which would mean failing
> > > > later when attempting to access non-existent RAM.
> > > >
> > > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > Co-developed-by: Steven Price <steven.price@arm.com>
> > > > Signed-off-by: Steven Price <steven.price@arm.com>
> > >
> > > > +static bool rsi_version_matches(void)
> > > > +{
> > > > + unsigned long ver_lower, ver_higher;
> > > > + unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
> > > > +                                         &ver_lower,
> > > > +                                         &ver_higher);
> > >
> > > There is a regression on QEMU TCG (in emulation mode, not running under KVM):
> > >
> > >    qemu-system-aarch64 -M virt -cpu max -kernel Image -nographic
> > >
> > > This doesn't implement EL3 or EL2, so SMC is UNDEFINED (DDI0487J.a R_HMXQS),
> > > and we end up with an undef instruction exception. So this patch would
> > > also break hardware that only implements EL1 (I don't know if it exists).
> >
> > Thanks for the report,  Could we not check ID_AA64PFR0_EL1.EL3 >= 0 ? I
> > think we do this for kvm-unit-tests, we need the same here.
>
> Good point, it also fixes this case and is simpler. It assumes RMM doesn't
> hide this field, but I can't think of a reason it would.
>
> This command won't work anymore:
>
>   qemu-system-aarch64 -M virt,secure=on -cpu max -kernel Image -nographic
>
> implements EL3 and SMC still treated as undef. QEMU has a special case for
> starting at EL2 in this case, but I couldn't find what this is for.

That's a bit of an odd config, because it says "emulate EL3 but
never use it". QEMU's boot loader starts the kernel at EL2 because
the kernel boot protocol requires that (this is more relevant on
boards other than virt where EL3 is not command-line disableable).
I have a feeling we've occasionally found that somebody's had some
corner case reason to use it, though. (eg
https://gitlab.com/qemu-project/qemu/-/issues/1899
is from somebody who says they use this when booting Windows 11 because
it asserts at boot time that EL3 is present and won't boot otherwise.)

Your underlying problem here seems to be that you don't have
a way for the firmware to say "hey, SMC works, you can use it" ?

-- PMM
