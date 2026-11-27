Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795771162;
	b=hx1onMV/Lz8jnxhmv4P/wxCpp54SOIvrT7SDEYLte2CZaZisKjRqoBcBvCgyDXJhANGH
	 SgIRmh2hhsbn+ssRTt6G7iiiTK8Tf7zMjSD6/aODyhz4rYJi3EVO5Wbwkf1OqEWsH+CgV
	 x0V72qJglwRfPeHfz1AlDYPz0N9M8RGTad+Dz2BOJG1dnvaaYNbaeY/JsWEuKJji5IDba
	 tv83RjRXIL0KQKAInkgWQKkStXM4bxtqBHeUv4KJRUhc8/fkQWgaXIFe2u5nHIjVN6qxJ
	 eraccJEaLv1UHI7lPW4l3W7QTGuKdMeG5eGTm9cEQVC7FiSeyILqSD0ow9cx5H6kEyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771162;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=WEiknYOGnWAiIBXTLUJNV1DE++CQc9r9ihlhMXP9mRs=;
	b=zzktDDx6Qygi3fKpB2oOX8Nrmrozn3mlHutLAHu50JJfMke5kQvfHa0+LXgkREB0ZZRs
	 vDfQtLEbopnLGIxM4Nm3dYit6zOeKUtydWt12zXVYxpFi8fA0gJhgrPzpJfm7IQaCjdyI
	 HCg4fI4r2dLPYPwEKiV2KYgE7yd2kn81IW0tC0WXyEWZ4VTQ7E1dZxxdWig1JsaL/9/Dp
	 zxBSxvGpIH/Rk4hoHj0xOWuRj+TUKw9i+EibpT8xYkGHk22mQJVMoCgJ6PmUzkRFb+Bun
	 cHzfImAHo7/D3PXARVPzLUtc9hcn9/K0DQbSQ8e7wVbtcGZlzLX08etKE3xBXY3Z0UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Yh2TadT5;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3BE606A31E
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 09:19:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB3BE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Yh2TadT5
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb72b44a97so67339145e9.0
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 01:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795771160; x=1796375960; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WEiknYOGnWAiIBXTLUJNV1DE++CQc9r9ihlhMXP9mRs=;
        b=Yh2TadT52KiCmXMfu40KnHiktFw6Olv89gDt9uNUufentxGjYIvLuEuVHbm+t64pbC
         S/NmoUnizd+tHwZ2f5Sij8sLesiGd2Tz/3hWqhgauEn/Fw6GHee8WizvkuqIoJGO9Gi7
         KtqWx914Wmo+OxZX5+COsWjbJgAyH74o2o6X4RebFOeq8dY5neoo5vDG8w4TUzaopQhF
         JD4c9fSUzMZ5YjPKCrb2niokApWU4aZvUQeSCgxkQsSoIl6Il5FzMcgVk1MmFNSzWHEk
         1/MOnEJBLxteLZZfQ1uGY2pLo+9Cmu3e7wz4GoUjpjJ5mdJ02zUFdE64zsPble7LDJLj
         1JKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795771160; x=1796375960;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WEiknYOGnWAiIBXTLUJNV1DE++CQc9r9ihlhMXP9mRs=;
        b=f78DkCF3XA+Ke4zjPdicJysmj7/83hurtlw9rS00Hgdc+xiM561O39pkYY2kLYTVOA
         fu5VtH/+TMOFpMW6Y8815mtLPgFYKOxhNWzin9nH67XkY1OCKWIcGZ6c0F2MF/HNdp3X
         NCH/dk9Te8V+mg1tWDrKF0AgQJRi2FIC+6oDwct6yPdgFSPizT0LV/xiHKbz7nyJKUdU
         kJpqWymEtrqtChXSQku7Dbn6Q77CzEBIsAvzgOpV1erBZwVd9caXB1iCRGIl8fjhU6fk
         N8R4jp211TZfBkP9G9jpWDbtmraPkfl4q4pjJUvbqvQ4QGl/gd/ejWN1Eyi1ahrZk9FE
         K+iw==
X-Forwarded-Encrypted: i=1; AL+hErG7alr0UD7OU70wpcwR48eputD0H0UpNA1DTF46ruQBCDGGXscWMi1AiKAa8yHjVuCjQC0yd6c=@lists.linux.dev
X-Gm-Message-State: APuU4Z9NDu/CEYUdCkyLQ8fLRUe5eZ39ByL2wX0r4pWBlGso3cqWaLxK
	GEfBKZ/OegkizdhEM+7iPAl4dqI8B4Houjxu6kWfVamhAYUNOaLD7Qyyoyga992yOA==
X-Gm-Gg: AZFdTZd4x2riM9GR7M/pXG5fyzHrLyhVYgsrxg3WvNw9E73NZGtvJc25tUvSCQrv3Js
	+BDgWIHl9fyjiwvV88JR30C60TN+Dpei3GUJOPF64/lO0FFKWAthdZPP4gYeFi3TvpGsNk5A6YF
	2K+sgh4nSSxgbSGNiS/YKQQpVnywsDGQk5gVgpFLaRnuMeR3McboCxHAzpQungA8MzFYiCasPLJ
	Cpy4o87BbiDW8PhcQmvXZjo7XjXs0ulQ6lsoPY+9YPoXX/jRudvDIWGK6/PubOWsSRLoCS/Q/FM
	9N3A97xtGL1txwHqNxgeox2VpJb4N2mlLTdopiV5Ly5pwTMkNuZO9JvlIGUHtuY3UKkJ7nq6w8s
	xsszmXiTAGijCsr+oo6wlPyWrMfExjHpH3DdEytT0UHA2ab5yArkRJz7XEibgAUwI+rF+lVHfjd
	T7PlS76AqrfGg/V7LNz+yKO22ql5bcATJbFj1GrumrXy/ok+VRpagPLnnrD0Q8nLIzn8lGIRxMN
	wPkUkpoPF8r8N6UYGdN+jOYqTOm7DfSbuo4fh0tzNZGw6ImthcUS9kgHBuZdBxerKiU5RyWIupg
	PWFOlOVVH1piJoBiXO8i3L3Br/TdAtdQTZWGUFOjEiaWqXdaPJFLzjHSySeMnVKfyl0HZTXIpC9
	VDWs1nvEiUKbZ5TkVxHV7e+dkRH6BpXexPDJIs8UYxDM=
X-Received: by 2002:a05:600c:46d0:b0:4bb:7987:fbc4 with SMTP id 5b1f17b1804b1-4bb88817eb2mr492863995e9.19.1795771159362;
        Fri, 27 Nov 2026 01:19:19 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm661484675e9.5.2026.11.27.01.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:19:18 -0800 (PST)
Date: Fri, 27 Nov 2026 09:19:15 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com, weilin.chang@arm.com
Subject: Re: [PATCH v4 21/23] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
Message-ID: <awlLEwegiWQZLeay@google.com>
References: <20261117174403.58762-1-vdonnefort@google.com>
 <20261117174403.58762-22-vdonnefort@google.com>
 <CA+EHjTzZkAf8+BGNH15TKCEYUyO=VFvGSeJg5hfaFoefNOTVpg@mail.gmail.com>
 <awiQzMZxQDEHrRf4@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awiQzMZxQDEHrRf4@google.com>

On Thu, Nov 26, 2026 at 08:04:28PM +0000, Vincent Donnefort wrote:
> On Mon, Nov 23, 2026 at 08:49:00PM +0000, Fuad Tabba wrote:
> > Hi Vincent,
> > 
> > On Tue, 17 Nov 2026 17:44:00 +0000, Vincent Donnefort
> > <vdonnefort@google.com> wrote:
> > [...]
> > > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > > index c55b6d442d0e..58ca7ffa68e3 100644
> > > --- a/arch/arm64/kvm/pkvm.c
> > > +++ b/arch/arm64/kvm/pkvm.c
> > [...]
> > > +static int __pkvm_pgtable_stage2_split(struct kvm_vcpu *vcpu, phys_addr_t ipa, u64 size)
> > > +{
> > [...]
> > > +        ret = folio_add_pins(page_folio(pfn_to_page(mapping->pfn)), nr_pages);
> > > +        if (ret)
> > > +                goto unlock_mmu;
> > > +
> > > +        ret = kvm_call_hyp_nvhe(__pkvm_host_split_guest, gpa_to_gfn(ipa), size / PAGE_SIZE);
> > > +        if (ret) {
> > > +                for (int i = 0; i < nr_pages; i++)
> > > +                        unpin_user_page(pfn_to_page(mapping->pfn + 1 + i));
> > > +                goto unlock_mmu;
> > > +        }
> > 
> > Could you use unpin_user_folio() here, to mirror folio_add_pins()?
> 
> Ack.
> 
> > 
> > [...]
> > > @@ -765,6 +890,23 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
> > >          return !ret || ret == -EAGAIN;
> > >  }
> > >
> > > +static int pkvm_hyp_req_handle_split(struct kvm_vcpu *vcpu, u64 gfn, u64 nr_pages)
> > > +{
> > > +        phys_addr_t addr = ALIGN_DOWN(gfn << PAGE_SHIFT, PMD_SIZE);
> > > +        phys_addr_t end = ALIGN((gfn + nr_pages) << PAGE_SHIFT, PMD_SIZE);
> > > +
> > > +        while (addr < end) {
> > > +                int ret = __pkvm_pgtable_stage2_split(vcpu, addr, PMD_SIZE);
> > 
> > Could you drop nr_pages from the split request? Patch 22, the only place
> > that raises it, passes 1, so this loop runs once.
> 
> Hum, it is just we have range everywhere now so it feels a bit weird of not
> having one here. But then I agree this isn't a stable API.
> 
> -- 
> Vincent

Looking at the existing kvm_pgtable_stage2_split() interface, I see it does take
a size as a parameter and so does its caller. So I wonder if it isn't better to
align everything and to keep that nr_pages argument.

However, setting nr_page=1 is indeed a bit weird. I believe the hypervisor
should just emit a PMD-aligned request. I can also drop the loop iterating over
nr_pages.

> 
> 
> > 
> > Cheers,
> > /fuad

-- 
Vincent
