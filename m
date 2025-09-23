Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE162745E
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 09:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758619146; cv=none; b=Evf+rXUIpM96tmzdxk05NoBl1vNCw4wQujtiuHZfm4ZZNtMhwu94zszzhZGFGCjUgT4aP+O6T2a0QNuCFO9Yo+bCHQjQuOjMPkxn5DqtJpL801hyfRXOI7jrfgfiu1ATs+THaodCKM36sJobPrz1vojLmdx56AvtNlNa9kFWgw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758619146; c=relaxed/simple;
	bh=Ob4PEJnRCFKX5Dh4OXIt58T1AxKizBgCT6fTu8PMUdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AoyWsOTlA6NkSoygsgWOsG2VWfRzs9Gs6eMieqJ8hZwQFL0c/ABj9rEcM0pwZkpwxEGEoqXDObv/dLuboJleOH2TyTteoqImxm9eQ7gMGqW8LGaloJVnvOsiAVxt00LJkl4JHVY0vL18qK4pwzSe0PK3RxWnMq9xKPGLDSDI9dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rWd7Op9v; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rWd7Op9v"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3ee64bc6b90so2580947f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 02:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758619143; x=1759223943; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rzPVgnzMxw0u/5rPyRAI2idtL300s+mFFNLf4vaxnoI=;
        b=rWd7Op9vsnJcf1APERfRH1Exfn8QcFEpXj16fA/pW9wkxyOWAoFVsC4juEOOU0mzae
         TNnt8OINmpHv55BSCouhKWlCw2buslUwk1AufEykzVBp2+ixb/xJHdmdksFay5DHR/XI
         TcvYqlECxZDNWqCtyU2ny0bfuHX4q9sap9kxWPQiA2PUssMsP9nwi4qjf/gXrC+93kKR
         GGL92ggfroxIUelGTgz+SOmJmsMAihgJBGjDrjQ1njeGX4wL7Fz5T922OxtBGfylaTQ+
         K39Oh89JGmKGCwZ/DIaehpJ9ZsmfBKKgdpJTq1amc6bP+z79iOtncRTvMWDE2Q/iSnVs
         yvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758619143; x=1759223943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzPVgnzMxw0u/5rPyRAI2idtL300s+mFFNLf4vaxnoI=;
        b=s0pLtWE8pDR5WcxydNDko1JYaPaSgkEX2+Uluk7NqiQem2nxewvyfOk/J0HGiQr4mN
         ldoirGAD84fra9L262Z4J232kBdV1DOHwvluMRSUXVEJcz/jJ3jmisZfQYX6awtKeMqy
         mmOZZ4fkTYTO8ppyifwrZiKsVs424NmKTcVYAqi0Nv0XlkCanOtPU8wPEIWYuUuKsk42
         gLJvSrgSKXaHbiBBFThdA34mCiKbXh2GPJGZaYcav/hDc+gPijqq2hv7Z70/0fUc08Uf
         9lHf7MHjGcOF3O7KKoKf9+9mXkx7MR8jM4/gT7Z6n3OatcZdE2OsBp/kpf5RR7sFpIkt
         3wzA==
X-Forwarded-Encrypted: i=1; AJvYcCXtrDMtG4srjboDUvbNEEUq39LgYqHZDmsDLDumUWpKd81pnZFQ3qmh7nlAhTHBuAL+Srp4giQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKAKl4Of6dQZTYVnEhpbD/Z1Kwyy2qIO/lJTIWMGtBpnSpO8Ol
	8800onLAuYf0PnHoUVxnsUiT4iSZOyjlexQQfy72UYLR+O101C7DT0vzXsnRi2R95w==
X-Gm-Gg: ASbGncuFwDOGTJNEqDBPYWsDmjO4iY3d3hnE3wLu4jt8gvUE5emyM9nePNOCuZh74oL
	+05LX7gtFIi1MpqN9TOXH2xuOjv3EKpcqllU7BrtyfTXuFYjEP+ltiutva7ESf9SY5JeId8aHBP
	JSN6KCYLFiQt7UOZ48eW7gfeYF7P4Yw6fBByk9+VIZWjsj3gIE9ejR3emGb3SbKV64UHKl7SD8/
	GDTFMgdqaAQlXVXAKaaTVt8w/wFDN6b/5J8v0LlfzYBMufkqxCEo8eo86FukC6RUVQpj8Bn7mQJ
	8/zOgbh9HQuKy5tGQtjDqwQuLfKpDarhKvWlu/fDQpvlOxdmtCY3l633TVXFLAHQPq9xNXTzw18
	Zkw0YYVJEyQA5vNndvEGKfpC/BPky2BBVbWorUWD4nSPnD6b7MQeN1SrFHYB2SqLIL7s0Jmxu
X-Google-Smtp-Source: AGHT+IGW/BGKmTwR+8ZWW1MRwZl0fncm95Jhv/kZ6B+0I1aPkL40IEURTciwlEaJlI8gawUIXIITSw==
X-Received: by 2002:a05:6000:4313:b0:3da:d015:bf84 with SMTP id ffacd0b85a97d-405c76a1cb2mr1589577f8f.25.1758619143195;
        Tue, 23 Sep 2025 02:19:03 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee106fd0edsm22499598f8f.53.2025.09.23.02.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 02:19:02 -0700 (PDT)
Date: Tue, 23 Sep 2025 10:18:59 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com,
	sebastianene@google.com, keirf@google.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2] KVM: arm64: Check range args for pKVM mem transitions
Message-ID: <aNJmA-1ZlikW2Knw@google.com>
References: <20250919155056.2648137-1-vdonnefort@google.com>
 <87plbkxcvv.wl-maz@kernel.org>
 <aNG417MneSKBxyn8@google.com>
 <aNHcxAJXHeS2T7TH@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNHcxAJXHeS2T7TH@linux.dev>

On Mon, Sep 22, 2025 at 04:33:24PM -0700, Oliver Upton wrote:
> On Mon, Sep 22, 2025 at 10:00:07PM +0100, Vincent Donnefort wrote:
> > On Sun, Sep 21, 2025 at 12:29:08PM +0100, Marc Zyngier wrote:
> > > On Fri, 19 Sep 2025 16:50:56 +0100,
> > > Vincent Donnefort <vdonnefort@google.com> wrote:
> > > > 
> > > > There's currently no verification for host issued ranges in most of the
> > > > pKVM memory transitions. The subsequent end boundary might therefore be
> > > > subject to overflow and could evade the later checks.
> > > > 
> > > > Close this loophole with an additional check_range_args() check on a per
> > > > public function basis.
> > > > 
> > > > host_unshare_guest transition is already protected via
> > > > __check_host_shared_guest(), while assert_host_shared_guest() callers
> > > > are already ignoring host checks.
> > > > 
> > > > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > > > 
> > > > ---
> > > > 
> > > >  v1 -> v2:
> > > >    - Also check for (nr_pages * PAGE_SIZE) overflow. (Quentin)
> > > >    - Rename to check_range_args().
> > > > 
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > index 8957734d6183..65fcd2148f59 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > @@ -712,6 +712,14 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vm *vm, u64 addr,
> > > >  	return check_page_state_range(&vm->pgt, addr, size, &d);
> > > >  }
> > > >  
> > > > +static bool check_range_args(u64 start, u64 nr_pages, u64 *size)
> > > > +{
> > > > +	if (check_mul_overflow(nr_pages, PAGE_SIZE, size))
> > > > +		return false;
> > > > +
> > > > +	return start < (start + *size);
> > > 
> > > I will echo Oliver's concern on v1: you probably want to convert the
> > > boundary check to be inclusive of the end of the range. Otherwise, a
> > > range that ends at the top of the 64bit range will be represented as
> > > 0, and fail the  check despite being perfectly valid.
> > 
> > Do you mean allowing something like start == 0xfffffffffffff000 and size ==
> > 4096?
> 
> Yes, this is what I was alluding to on v1.
> 
> > But I guess that would still put all the following checks using "addr + size" at
> > risk. Also, I believe even the code in pgtable.c wouldn't support a such range
> > as it is also using a u64 end boundary.
> 
> I'm not sure I follow. Ranges are pretty commonly expressed as a range
> terminated by an exclusive value. This just hasn't been an issue yet as
> the page table code is only ever dealing with TTBR0 or VTTBR
> translations.

If I do exclude the end boundary, evading checks would be as simple as making
sure we overflow the end boundary?

e.g. __pkvm_host_share_guest(phys = 0xfffffffffffff000, size = 4096) 

        check_range_allowed_memory(phys, phys + size) /* nop */
	....
	for_each_hyp_page(page, phys, size) {  /* nop */
               ...
	} 
	...
	/* Install a valid mapping to phys */
	kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys, ...) 

> 
> Anyway, I'd rather these range checks have as few assumptions of the
> applied address space as possible.
> 
> Thanks,
> Oliver
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
