Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E702352090
	for <kvmarm@lists.linux.dev>; Tue, 26 Aug 2025 13:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216348; cv=none; b=cMLlaj2E2WUbaPAdN3aY8hy4+qW3aOeMict4GLcsY0ZgdNPoURpUKC96D188aC2eMRSRiNoEZIAHgI2dUk5SmqnorN3sN4LfVjlk6GzhmQjjdNJXx4FvSJtemU98NOTqn6FzusAJh+cfFdm2Ty5x6o/+EudUGv8FZeiqtSgNEGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216348; c=relaxed/simple;
	bh=ekOHapBN3MK0HyC/SCeCFRc8rNUhhpwxn7KoJlL/4hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m80QSZfLFDE6/fpavFtUh3RBy0NbmCub3EOAJ6m1xwpAn1YM1FOb1aNetS+bLDc8i9HKkJanrB8AerspXpf01AyMVLIXbcY5x4cal8XXa7lDVkkERsLalFiNZyLVOFZUq5YMIY0aLBiVicbl08KVvm4KYFlPAtbVUiIsQcM+AlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=BR6jzr+T; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="BR6jzr+T"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b47052620a6so4777365a12.1
        for <kvmarm@lists.linux.dev>; Tue, 26 Aug 2025 06:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1756216346; x=1756821146; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lHGyXOKrjm5oz81TLpvSpWDaUb0vSgaahBghiDLKLpk=;
        b=BR6jzr+TzNfw6LhY2Yd04wTX2l7KxFOWAZ6pvxsgh9H81b4QUy7hRptZFTcFikKXtz
         U4iafdtqDKv3hL28717Va8XJ8CNAWGPc4RVrblBJ3nhxKHmI77jwXNAdWAa4Mk/+O1cz
         kNVYc4ya8Pi7LNjnWZVRDn48nFz2vHPMFQYCPS/+aOlOWdiWTgXl8iGaFt7VHoYxJ5QJ
         Qt7h6Gu5IVAOln0AU5O3t1oITUGDT91moYdHPROxY/Fylk2mv8wAEfWDcCS0V988KJ/V
         oVM66u/P+4CvaZowM/Jtr90AZJX92CkMs5lC/N5mNIaAYN2oro17WuuEshY2LljauBpl
         KvNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756216346; x=1756821146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lHGyXOKrjm5oz81TLpvSpWDaUb0vSgaahBghiDLKLpk=;
        b=vpL0GFvgyZkZCRPq7OH9/kIMR0sEUj7v+7DArOr76PPFN0j1PwQ9SZXg7FNmOkOFkw
         ZWEZ4xkwJjxlVb3jccsnqE3oTR4BkGwwIS0Lf72wMqH82M0OvS37ViTtaG4i8WR26Aw6
         CxP+UOJf9TZ86VbBD6okrjY+yAQ9Y8wBVhXNbWeSLhxi7CxJLvi5LP+QloQLWnhFX6O/
         mYJqzUthz3Pjq0x5jKM+/5WMbiS/wKN11giCW7ipGv//1jsZj9e0Un9/9wQ/dWUoPNbr
         HnNP7g2Y8qaNmpITDp0UqIbMv3bbv33FxlwALol7ZtduW8pQX5xHyxYRoktRFs2zpM0G
         YQKw==
X-Forwarded-Encrypted: i=1; AJvYcCWyAdh7sIFNQKjG/UvZrHV52CoSefoDpqstAENVmiVBOHXZ/gPNQEyMP3Vs/MhC0CkDaK2HjcE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRwluSmp+MeBiE8xyLrJtBMVSYkC5HhmcULo+oX7Ez4EKR31KQ
	VvyRb/yodCPW3SRC1xB4zrB47fle0gItttY/8xNcgTswdXuTCYGgvoMC4rnA1ufh7Z9xpLhfQUn
	hnuW3++CB/AtaD7maegbjWIchdPjORpRM8uM4RuvuU+TbdKg0XQs=
X-Gm-Gg: ASbGncuChaY6d666NBUWdo7jjT+pJtQWy0R7eVFzVIqOR6YEXefThnynmg+hsCyxKp6
	BEDtUjkE8K0Mgmet0JMAQopxTeKwjh2Mkrs673FU3fs1bvNGqGB6EyksTOH4t2Jf4X2kRhbfZD1
	/igdslXh078HBlvgZCMUrGtgi3/LQ4qnNtTjP4xVxtHuHJOYxJFvQ4e3v9gml5JPoyZB+ndxoXv
	T3n7I5DNl0ZG2qjKOzdn8SnIsfUs99k7xuPT/wWgUUxsUzVzWC0z055cfWDIgFj4vQum6XgXNyQ
	lpcwC9GdeM/hEGWt7UdcIA9/wwANuUQR6PdXEfpsnVArU/U3D26xm+ek/PAhhU6lxAsYjwIZGk2
	kcUOk9upU8CZxTMHMCOoDYPf2MKtRDAcrwhFCkSvO+mg6CWSR21nNlmgxJivk/Mb2WOVD
X-Google-Smtp-Source: AGHT+IGxhWDFYVYxqq2b3637yU3GvKWhKRYnWWKXaAejHtAF5wXzw4/2DHVTT2A4Zo0gjU/UoaN6ZA==
X-Received: by 2002:a17:903:238a:b0:245:f860:80b1 with SMTP id d9443c01a7336-248753a264dmr23720075ad.11.1756216345708;
        Tue, 26 Aug 2025 06:52:25 -0700 (PDT)
Received: from zenbook (1-162-83-231.dynamic-ip.hinet.net. [1.162.83.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24668889dbbsm96756765ad.132.2025.08.26.06.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 06:52:25 -0700 (PDT)
Date: Tue, 26 Aug 2025 21:55:11 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: nv: Allow shadow stage 2 read fault
Message-ID: <l4ge3jp2leuzxkpn7nowptl7hjzeiq6amqowibycdhuahgafnw@o3dcvj7njix5>
References: <20250822031853.2007437-1-r09922117@csie.ntu.edu.tw>
 <aKg3l23hheuQ1dJH@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKg3l23hheuQ1dJH@linux.dev>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi Oliver,

On Fri, Aug 22, 2025 at 02:25:43AM -0700, Oliver Upton wrote:
> Hi Wei-Lin,
> 
> You've been finding some good stuff with nested, thank you :)
> 
> On Fri, Aug 22, 2025 at 11:18:53AM +0800, Wei-Lin Chang wrote:
> > I am able to trigger this error with a modified L1 KVM, but I do realize
> > this requires L1 to be very strange (or even just wrong) so I understand
> > if we don't want to handle this kind of edge case. On the other hand,
> > could there also be other ways to trigger this that I have not thought
> > of?
> 
> The architecture is pretty unambiguous here that the stage-2 can
> represent a translation w/o read permission.
> 
> > Another thing is that this change lets L1 get away with not flushing the
> > TLB, but TLBs are ephemeral so it's fine in this aspect, however I'm not
> > sure if there are other considerations.
> 
> FEAT_ETS3 is an interesting one since it provides software with ordering
> expectations around MMU faults (including permission faults) and updates
> to the translation tables. For KVM's shadow stage-2 to comply we need to
> re-walk the guest's stage-2 before injecting the fault at L1.

Thanks for telling me this, I haven't noticed ETS before, let me learn
about it.

> 
> > ---
> >  arch/arm64/kvm/mmu.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 1c78864767c5c..41017ca579b19 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1508,8 +1508,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> >  	VM_BUG_ON(write_fault && exec_fault);
> >  
> > -	if (fault_is_perm && !write_fault && !exec_fault) {
> > -		kvm_err("Unexpected L2 read permission error\n");
> > +	if (fault_is_perm && !write_fault && !exec_fault && !nested) {
> > +		kvm_err("Unexpected S2 read permission error\n");
> >  		return -EFAULT;
> >  	}
> 
> Hmm... I'm also willing to just delete this check altogether. The
> likelihood of KVM creating a stage-2 PTE w/o read permission is rather
> low.

Agreed, and this is in agreement with Marc, let me drop this in the next
version.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Oliver
