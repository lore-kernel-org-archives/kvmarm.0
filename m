Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F46342539
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 06:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779257078; cv=none; b=beL3+gRv/seWzCf1QQ3n0YM0uiOmUhNZpV4KkWatFCEDHRhT/CRUYev/pwVAoQtdDPriSqXPOVpryRSZx/oCHsnghkU6l80MDZ8UtdrxlhzjArPyZz+vW30Dkb139DqOTrd8G+s0Qmg/kTc+6kOHg6Jq+juvSSK705j6xI87KT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779257078; c=relaxed/simple;
	bh=A0RGoPz6I20kvbvwiwVIlm+qEWQ5NT3ofZeWseaMUss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QdJd5jwZ1LUJl1RRqB2Ke2rwm7N8jWwJrdf/DWQE2wm8iNT/zne/6164HXRhZTswEEvbHo4t5TfCSi85uc51rxTyo+1dDdHqj+uRoOQ5+FBsF/QCqjnpwnAK5dTASorWO0ulzxmVLUN9q3wf5wnw3VpGOiAmNoeF2jBoO/DIpSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jGZgBDu3; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jGZgBDu3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779257068; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=zS9MMjBWMQqyNg08agfQFcVT/1XkZ5RtW9KXjSv4aHI=;
	b=jGZgBDu3UlAwcz0OT1A0c7FCuc+H4xH500GqrsuHLzkzLqzW4MhnSJU6dkHohBhpVebcdErMtTo3nZx0ZKpwb4mcBbtyOVbTpTj/pYkxiJE12QsWVlnmfMmO9uhUY9xQIPyu0TPRWdtVRUGJ8qG62GrbkyMmWb45MQBkByq9XLw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X3HXL1A_1779257067;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X3HXL1A_1779257067 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 May 2026 14:04:27 +0800
Date: Wed, 20 May 2026 14:04:26 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Michael Bommarito <michael.bommarito@gmail.com>, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-its: reject restored DTE with
 out-of-range num_eventid_bits
Message-ID: <4v4zv3y5yxwkfnouqcjxhrwxvnpd7c4oodevrcgivxu2aeaiyg@2b3arv4mmv7n>
References: <20260517174955.273004-1-michael.bommarito@gmail.com>
 <w6zdprlry2y37wtkirv4zhiy5awau3stbkjohmvfwkswgoaafe@ul53z6xwyuhw>
 <8633zpxh1v.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8633zpxh1v.wl-maz@kernel.org>

On Mon, May 18, 2026 at 09:23:08AM +0800, Marc Zyngier wrote:
> On Mon, 18 May 2026 07:05:13 +0100,
> Yao Yuan <yaoyuan@linux.alibaba.com> wrote:
> >
> > On Sun, May 17, 2026 at 01:49:55PM +0800, Michael Bommarito wrote:
>
> [...]
>
> > > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > > index 2ea9f1c7ebcd0..a5dcf9a6a2854 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > > @@ -2307,6 +2307,15 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
> > >  	/* dte entry is valid */
> > >  	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
> > >
> > > +	/*
> > > +	 * The MAPD command rejects this case; mirror the cap here so a
> > > +	 * restored DTE cannot install an out-of-range num_eventid_bits
> > > +	 * that vgic_its_restore_itt() would then convert into a
> > > +	 * sign-extended scan_its_table() length.
> > > +	 */
> > > +	if (num_eventid_bits > VITS_TYPER_IDBITS)
> > > +		return -EINVAL;
> >
> > Hi,
> >
> > IIUC, the same issue is still there when VITS_TYPER_IDBITS
> > change to >=28, I know it's limited to 16 in GITS_TYPER's
> > definition. I mean the issue is still there w/o really be
> > fixed.
>
> Change how? This is a hard-coded limit that reflect a practical use of
> the ITS (and is already 32 times larger than what PCIe allows).
>
> Are you suggesting a possibility of making this userspace
> configurable?

So far No, may until one day it has more than 16 definition :-)

>
> >
> > Change the scan_its_table() and other related code path to
> > avoid such date conversion issue is more reasonable
> > fixing to me, please also wait others' input yet.
>
> I don't think this is a reasonable course of action. scan_its_table()
> is generic (it doesn't know about any table in particular), and
> assumes that the scan parameters are validated upfront.

Ah I see.

I thought that even w/ chekcing VITS_TYPER_IDBITs, the
size_t -> int -> unsigned long conversion is still there, which is
big -> small -> big, looks odd to me, so I thought it should be fixed yet.
But it can't fix this issue directly.

>
> Thanks,
>
> 	M.
>
> --
> Without deviation from the norm, progress is not possible.
