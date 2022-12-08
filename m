Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02402C4167B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:49:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 836B84BA12;
	Thu,  8 Dec 2022 14:49:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hBpnueMSKQNy; Thu,  8 Dec 2022 14:49:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ADF94BA04;
	Thu,  8 Dec 2022 14:49:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76EF44B9F0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:49:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YqUA-JuZxUue for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:49:31 -0500 (EST)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3095B4B9E1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:49:31 -0500 (EST)
Received: by mail-pj1-f45.google.com with SMTP id
 k88-20020a17090a4ce100b00219d0b857bcso2629230pjh.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=/iRRuEpq3SHF2tTVNW+V0pd2eP3QVViktpfmGsJo8SE=;
 b=kbZjAjJOckI+jlOCJbuKM/9hTPPtgPZftSrpNxz+6MLKgxGWvBLLNyUR+yLtAe1FHf
 wJpg2MHXkTzpBNyZxTGd1AdsYy4ZLs6dxynTISt9vca/TyPOGTgUZjlcmzeqpYDnp/lr
 nfbOFjW274MxXgm+RUWP24N0ybK+fuofYxDYYO/sGvPoD5lfmmfOO3tdwNjQLoMr4mpd
 /RF/OCtj9uVDzdQiD1V8pMJXjG1PPQFii8S4PnRl+HioQe97ZvVWKQiPgKLeNQV2/HJw
 gBUXqS7+VDy/y8Zx1/EhxyC9Yxe7Bai4askP49YC2QyLOF6z9J+4HJ7bjYXM/dfQMhAm
 uWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=/iRRuEpq3SHF2tTVNW+V0pd2eP3QVViktpfmGsJo8SE=;
 b=SuyQ/vIgNPLuA2BM8hr3dx+1tk3PMhgjz1vvTegEKNRkshP+elTV8tmQRj/HlgiPGN
 RL4qmPasez3ctoehzww3aP9I1mXOUuy3yv+NGJeCr80lGa4D8PdIOfxoQjwCRmgYAFUJ
 bnfjQPqJzXB56RpygiYDo15SMY+948gR2d1a+GwSmP+C8Pg/yr8nD/hP0OxDvdMP8E6s
 hPT+outcT16L7m0dUfBiStUNCZli0GNLb8nohTPWxy7eUUhHU+sIfe4xa++x39sdvfTU
 sR5QZkq2sUugA8P6auJ0xCoFNG8+3tMs1bksL4KxI9GkQzvJuJIUsfZSrpvfX0k2xVzH
 kuBw==
X-Gm-Message-State: ANoB5pnzgESFXzJjeii9VLArB/sx5vx9b1YAQkmfyfRrPk+nrmnPJaji
 eMuTXcx6FWpsqkmwyOQ5siS0Qg==
X-Google-Smtp-Source: AA0mqf4+sYmN6TRhUnqm6pJbxgGCoSUwTGEipBsiO/jKS6U41yXiKghC+TQNsnXSTcuYW70TLswWgg==
X-Received: by 2002:a17:90a:d681:b0:218:84a0:65eb with SMTP id
 x1-20020a17090ad68100b0021884a065ebmr1775305pju.1.1670528969909; 
 Thu, 08 Dec 2022 11:49:29 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 d15-20020a17090ac24f00b0020b7de675a4sm34718pjx.41.2022.12.08.11.49.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Dec 2022 11:49:29 -0800 (PST)
Date: Thu, 8 Dec 2022 11:49:26 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Setup ucall after loading program
 into guest memory
Message-ID: <Y5I/xiFMLVbpAZj+@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-3-oliver.upton@linux.dev>
 <Y5EoZ5uwrTF3eSKw@google.com> <Y5EtMWuTaJk9I3Bd@google.com>
 <Y5EutGSjkRmdItQb@google.com> <Y5Exwzr6Ibmmthl0@google.com>
 <Y5IxNTKRnacfSsLt@google.com> <Y5I0paok+dvTtrkt@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5I0paok+dvTtrkt@google.com>
Cc: Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Dec 08, 2022 at 07:01:57PM +0000, Sean Christopherson wrote:
> On Thu, Dec 08, 2022, Ricardo Koller wrote:
> > On Thu, Dec 08, 2022 at 12:37:23AM +0000, Oliver Upton wrote:
> > > On Thu, Dec 08, 2022 at 12:24:20AM +0000, Sean Christopherson wrote:
> > > > > Even still, that's just a kludge to make ucalls work. We have other
> > > > > MMIO devices (GIC distributor, for example) that work by chance since
> > > > > nothing conflicts with the constant GPAs we've selected in the tests.
> > > > > 
> > > > > I'd rather we go down the route of having an address allocator for the
> > > > > for both the VA and PA spaces to provide carveouts at runtime.
> > > > 
> > > > Aren't those two separate issues?  The PA, a.k.a. memslots space, can be solved
> > > > by allocating a dedicated memslot, i.e. doesn't need a carve.  At worst, collisions
> > > > will yield very explicit asserts, which IMO is better than whatever might go wrong
> > > > with a carve out.
> > > 
> > > Perhaps the use of the term 'carveout' wasn't right here.
> > > 
> > > What I'm suggesting is we cannot rely on KVM memslots alone to act as an
> > > allocator for the PA space. KVM can provide devices to the guest that
> > > aren't represented as memslots. If we're trying to fix PA allocations
> > > anyway, why not make it generic enough to suit the needs of things
> > > beyond ucalls?
> > 
> > One extra bit of information: in arm, IO is any access to an address (within
> > bounds) not backed by a memslot. Not the same as x86 where MMIO are writes to
> > read-only memslots.  No idea what other arches do.
> 
> I don't think that's correct, doesn't this code turn write abort on a RO memslot
> into an io_mem_abort()?  Specifically, the "(write_fault && !writable)" check will
> match, and assuming none the the edge cases in the if-statement fire, KVM will
> send the write down io_mem_abort().

You are right. In fact, page_fault_test checks precisely that: writes on
RO memslots are sent to userspace as an mmio exit. I was just referring
to the MMIO done for ucall.

Having said that, we could use ucall as writes on read-only memslots
like what x86 does.

> 
> 	gfn = fault_ipa >> PAGE_SHIFT;
> 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
> 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
> 	write_fault = kvm_is_write_fault(vcpu);
> 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
> 		/*
> 		 * The guest has put either its instructions or its page-tables
> 		 * somewhere it shouldn't have. Userspace won't be able to do
> 		 * anything about this (there's no syndrome for a start), so
> 		 * re-inject the abort back into the guest.
> 		 */
> 		if (is_iabt) {
> 			ret = -ENOEXEC;
> 			goto out;
> 		}
> 
> 		if (kvm_vcpu_abt_iss1tw(vcpu)) {
> 			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
> 			ret = 1;
> 			goto out_unlock;
> 		}
> 
> 		/*
> 		 * Check for a cache maintenance operation. Since we
> 		 * ended-up here, we know it is outside of any memory
> 		 * slot. But we can't find out if that is for a device,
> 		 * or if the guest is just being stupid. The only thing
> 		 * we know for sure is that this range cannot be cached.
> 		 *
> 		 * So let's assume that the guest is just being
> 		 * cautious, and skip the instruction.
> 		 */
> 		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
> 			kvm_incr_pc(vcpu);
> 			ret = 1;
> 			goto out_unlock;
> 		}
> 
> 		/*
> 		 * The IPA is reported as [MAX:12], so we need to
> 		 * complement it with the bottom 12 bits from the
> 		 * faulting VA. This is always 12 bits, irrespective
> 		 * of the page size.
> 		 */
> 		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
> 		ret = io_mem_abort(vcpu, fault_ipa);
> 		goto out_unlock;
> 	}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
