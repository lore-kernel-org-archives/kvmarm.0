Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D116418F
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 00:32:22 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id l2so15608713pld.13
        for <kvmarm@lists.linux.dev>; Tue, 08 Nov 2022 16:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RQ1jZB3m3JNgwDhXjvr6dpP648h3M6Z1s+n2GIXxEIo=;
        b=CRbqjBhRSNWKJ3gP6OhmCaglk6IoBDsubUDFV3xuv6NJpkfqtcN9cbk64wS63YwRkL
         RYJuhevVxMdwp6TpG2m6ovEqDuDi1rwnzTwbi5q6x6UW9LIRkegtLbQR6q5gkS9ZH0d4
         DlS9gO7IoPlW72kRJL68GlEhrzpniTOQ5j1auw/oqGpfNgGSlMSLVMCso9wiLUH0rjJK
         Ss723yFE+QJqxvL0FnZFGbqdioM536DIOSQ4ubJ6BvOmnJ4OXZokz2QYGvXy3+supDzP
         oyn6hCR3gkiZRzEElNgifAkcXPS+BZTIV1sfwb1ZkpZYjc64KOAyHnn3iNgBtCeNBj77
         byfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQ1jZB3m3JNgwDhXjvr6dpP648h3M6Z1s+n2GIXxEIo=;
        b=7QNJC3bljp6AQVuyaKchL1ZGmTLXVHeJENczA6/RMe2YDn5XQ4K4iZ1j1pWXRyOoQV
         Z8TmGum34UmuefB+OMI3j/h7bH2YIgmURu4L0aJ9avGzBdPl55MUFnsXvKPuZR7khP/g
         rvfwmCNuzv64+5JheU1HDVra5peAbHuZve+eQ1G1MUND7cepVqcZDzkbJONwWt91XYj9
         TEjXj44lKNAfAnEANXlSmkYL8L6GHkgGPd0cL26A+MYFI/dqi9ytif6xZHaaYJsY63mL
         H8W0AEwokuVEilh3Sex1YTUNAIpJ0d3LoCNMLyHAkMO1o15DkGbe8DCY1y9AiEP+n1f2
         xubA==
X-Gm-Message-State: ANoB5pnCS50p+PLbSP+1fMUQ7yMh0gTmwu0c+qicbcSDHRjInu2F2xg7
	dgCK+c3nNTujPZm5Bs7emXT9Iw==
X-Google-Smtp-Source: AA0mqf47wfHd+WN4Dx8uEDBo8ewcqOBktb14YxfpMVMVZOcUCSxxNuC8Mn5JxqjFHWRaslv52qtr7A==
X-Received: by 2002:a17:90b:1e10:b0:217:4fd0:acbd with SMTP id pg16-20020a17090b1e1000b002174fd0acbdmr25583534pjb.235.1667953942140;
        Tue, 08 Nov 2022 16:32:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s5-20020a17090a440500b0020b7de675a4sm6612962pjg.41.2022.11.08.16.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:32:21 -0800 (PST)
Date: Wed, 9 Nov 2022 00:32:18 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
	andrew.jones@linux.dev, ajones@ventanamicro.com, bgardon@google.com,
	dmatlack@google.com, will@kernel.org, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, pbonzini@redhat.com, maz@kernel.org,
	peterx@redhat.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2r1ErahBE3+Dsv8@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com>
 <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
 <Y2rurDmCrXZaxY8F@google.com>
 <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
Message-ID: <20221109003218.E_HOoIdH-ahHqOq3fdmEY9BEPNkUBEi1ZiutAdGqw3E@z>

On Wed, Nov 09, 2022, Gavin Shan wrote:
> Hi Sean,
> 
> On 11/9/22 8:05 AM, Sean Christopherson wrote:
> > On Wed, Nov 09, 2022, Gavin Shan wrote:
> > > On 11/9/22 12:25 AM, Sean Christopherson wrote:
> > > > I have no objection to disallowing userspace from disabling the combo, but I
> > > > think it's worth requiring cap->args[0] to be '0' just in case we change our minds
> > > > in the future.
> > > > 
> > > 
> > > I assume you're suggesting to have non-zero value in cap->args[0] to enable the
> > > capability.
> > > 
> > >      if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> > >          !kvm->dirty_ring_size || !cap->args[0])
> > >          return r;
> > 
> > I was actually thinking of taking the lazy route and requiring userspace to zero
> > the arg, i.e. treat it as a flags extensions.  Oh, wait, that's silly.  I always
> > forget that `cap->flags` exists.
> > 
> > Just this?
> > 
> > 	if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> > 	    !kvm->dirty_ring_size || cap->flags)
> > 		return r;
> > 
> > It'll be kinda awkward if KVM ever does add a flag to disable the bitmap, but
> > that's seems quite unlikely and not the end of the world if it does happen.  And
> > on the other hand, requiring '0' is less weird and less annoying for userspace
> > _now_.
> > 
> 
> I don't quiet understand the term "lazy route".

"lazy" in that requiring a non-zero value would mean adding another #define,
otherwise the extensibility is limited to two values.  Again, unlikely to matter,
but it wouldn't make sense to go through the effort to provide some extensibility
and then only allow for one possible extension.  If KVM is "lazy" and just requires
flags to be '0', then there's no need for more #defines, and userspace doesn't
have to pass more values in its enabling.

> So you're still thinking of the possibility to allow disabling the capability
> in future?

Yes, or more likely, tweaking the behavior of ring+bitmap.  As is, the behavior
is purely a fallback for a single case where KVM can't push to the dirty ring due
to not having a running vCPU.  It's possible someone might come up with a use case
where they want KVM to do something different, e.g. fallback to the bitmap if the
ring is full.

In other words, it's mostly to hedge against futures we haven't thought of.  Reserving
cap->flags is cheap and easy for both KVM and userspace, so there's no real reason
not to do so.

> If so, cap->flags or cap->args[0] can be used. For now, we just
> need a binding between cap->flags/args[0] with the operation of enabling the
> capability. For example, "cap->flags == 0x0" means to enable the capability
> for now, and "cap->flags != 0x0" to disable the capability in future.
> 
> The suggested changes look good to me in either way. Sean, can I grab your
> reviewed-by with your comments addressed?

I'll look at v10, I don't like providing reviews that are conditional on changes
that are more than nits.

That said, there're no remaining issues that can't be sorted out on top, so don't
hold up v10 if I don't look at it in a timely manner for whatever reason.  I agree
with Marc that it'd be good to get this in -next sooner than later.
