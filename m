Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BE3C4167B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:02:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6459E4B9A6;
	Thu,  8 Dec 2022 14:02:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9XiGOGU-inba; Thu,  8 Dec 2022 14:02:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 430E54B97E;
	Thu,  8 Dec 2022 14:02:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F87D4B984
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:02:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N5VonrIum68D for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:02:03 -0500 (EST)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B5EF4B96D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:02:02 -0500 (EST)
Received: by mail-pj1-f48.google.com with SMTP id u5so2440260pjy.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=+qj/hgsudAsSQeQjwLgM7Er96xTBcPfba5POCbUPtwA=;
 b=OZuydJPyQ7RHibQ69DK8aLxuHXUNvSGO5obZIQv0KYH19XsbkQC1aG0MlCb9PZfWCX
 WANqzP3qFui9udWh/088tR7qgAyIVZwDGFo6GozIXGCty6MttKLjyVr6Wzvr+QVAH/AF
 6CxPB1pZJI35PWxIXsUk570n/LIoeqNl0mKpWtUxBSngeOqY8WIEIU+b2qKpqC3mmnRL
 Dve6GGtJOchEaa/us9OjD0lEqWy44kquFqcZs3uIXXlcOMAgUVCnkwQK7KWcE65oXveM
 9+OVSAKOLGY8YdAZ+y4D4olEzaD3AMRaIj6tQqRenz46uiGZ8DQ8PpV10U+fjEiVoNcZ
 6j8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=+qj/hgsudAsSQeQjwLgM7Er96xTBcPfba5POCbUPtwA=;
 b=LziLWXvQDbGhM3qiAClrjIPyi8I+kWEb5YTbSAwYcCqV3VfFQSKQV7FycGIwItO/vN
 YW4WE9XQbjOidhr9FRm4wtrukRZBRi81llZ5QNj0x1vMJOGEf9kKoLBlAAc0nQIRpayc
 Iu+YLd4JNjYNod4q/nxudd0H+VaEsxWFIoSCxJA52t9W17PRhNEd37LuoxG+yxM9uEzT
 H1nLjo6NnHUbU4Y1058f4IoLnoSdh5fip7D0iiSvbJNrXWE61gSLh3DDouEzhWLzu8EP
 ySjc13177DDgxQQ4wOZXod4aLJz8wK2xsGADU3GoCk6u7OAYdzu0OMpNdCNyCwZ7vj+3
 I0Dg==
X-Gm-Message-State: ANoB5pkUJM5pEqSop9Q7Rm11olD9mZ0zRdYErqwtjLVCj4nZvCZiGY7z
 fhFVMzLRYD5qs76BkSKUyK5qAw==
X-Google-Smtp-Source: AA0mqf4AGgSjtYnu5c8NEL23WDXyqgRNekWyEeU6QVFPhXeyxHMI+VeQ/2t+hiPXrAUk+4iEU+mr5g==
X-Received: by 2002:a17:902:7402:b0:189:58a8:282 with SMTP id
 g2-20020a170902740200b0018958a80282mr1565905pll.3.1670526121972; 
 Thu, 08 Dec 2022 11:02:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 u17-20020a170902e81100b0018996404dd5sm5999822plg.109.2022.12.08.11.02.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Dec 2022 11:02:01 -0800 (PST)
Date: Thu, 8 Dec 2022 19:01:57 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Setup ucall after loading program
 into guest memory
Message-ID: <Y5I0paok+dvTtrkt@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-3-oliver.upton@linux.dev>
 <Y5EoZ5uwrTF3eSKw@google.com> <Y5EtMWuTaJk9I3Bd@google.com>
 <Y5EutGSjkRmdItQb@google.com> <Y5Exwzr6Ibmmthl0@google.com>
 <Y5IxNTKRnacfSsLt@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5IxNTKRnacfSsLt@google.com>
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

On Thu, Dec 08, 2022, Ricardo Koller wrote:
> On Thu, Dec 08, 2022 at 12:37:23AM +0000, Oliver Upton wrote:
> > On Thu, Dec 08, 2022 at 12:24:20AM +0000, Sean Christopherson wrote:
> > > > Even still, that's just a kludge to make ucalls work. We have other
> > > > MMIO devices (GIC distributor, for example) that work by chance since
> > > > nothing conflicts with the constant GPAs we've selected in the tests.
> > > > 
> > > > I'd rather we go down the route of having an address allocator for the
> > > > for both the VA and PA spaces to provide carveouts at runtime.
> > > 
> > > Aren't those two separate issues?  The PA, a.k.a. memslots space, can be solved
> > > by allocating a dedicated memslot, i.e. doesn't need a carve.  At worst, collisions
> > > will yield very explicit asserts, which IMO is better than whatever might go wrong
> > > with a carve out.
> > 
> > Perhaps the use of the term 'carveout' wasn't right here.
> > 
> > What I'm suggesting is we cannot rely on KVM memslots alone to act as an
> > allocator for the PA space. KVM can provide devices to the guest that
> > aren't represented as memslots. If we're trying to fix PA allocations
> > anyway, why not make it generic enough to suit the needs of things
> > beyond ucalls?
> 
> One extra bit of information: in arm, IO is any access to an address (within
> bounds) not backed by a memslot. Not the same as x86 where MMIO are writes to
> read-only memslots.  No idea what other arches do.

I don't think that's correct, doesn't this code turn write abort on a RO memslot
into an io_mem_abort()?  Specifically, the "(write_fault && !writable)" check will
match, and assuming none the the edge cases in the if-statement fire, KVM will
send the write down io_mem_abort().

	gfn = fault_ipa >> PAGE_SHIFT;
	memslot = gfn_to_memslot(vcpu->kvm, gfn);
	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
	write_fault = kvm_is_write_fault(vcpu);
	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
		/*
		 * The guest has put either its instructions or its page-tables
		 * somewhere it shouldn't have. Userspace won't be able to do
		 * anything about this (there's no syndrome for a start), so
		 * re-inject the abort back into the guest.
		 */
		if (is_iabt) {
			ret = -ENOEXEC;
			goto out;
		}

		if (kvm_vcpu_abt_iss1tw(vcpu)) {
			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
			ret = 1;
			goto out_unlock;
		}

		/*
		 * Check for a cache maintenance operation. Since we
		 * ended-up here, we know it is outside of any memory
		 * slot. But we can't find out if that is for a device,
		 * or if the guest is just being stupid. The only thing
		 * we know for sure is that this range cannot be cached.
		 *
		 * So let's assume that the guest is just being
		 * cautious, and skip the instruction.
		 */
		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
			kvm_incr_pc(vcpu);
			ret = 1;
			goto out_unlock;
		}

		/*
		 * The IPA is reported as [MAX:12], so we need to
		 * complement it with the bottom 12 bits from the
		 * faulting VA. This is always 12 bits, irrespective
		 * of the page size.
		 */
		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
		ret = io_mem_abort(vcpu, fault_ipa);
		goto out_unlock;
	}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
