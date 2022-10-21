Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58A96AB5
	for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 23:48:22 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso1590686pjc.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 16:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bief6n2KJvPdjYY33jpAwU4FAk9kTl6ZJ/dHDzSqnN4=;
        b=Yjpn3oeOaIAH47+IOvfOeU0jRd8BaPvu7wwEL2pMd13h+cVXfmEaixLurg40U2+klp
         Uj2Ky/2o883ODq1xtibPnjbDkcDT2ZfDLVO/UeW+x4epQRtAKY3bnziZ7eFHXUF6Wi+6
         buKbVuJ3t31AnagOmcsttdoZkf85MCwxmJCFBg2dr4WH2L1jsf/9YVBIINy/+QUnKp4t
         fiEBNo/lZ0CLVRUKwQTe2YvhleBL9gOwctEiJszR8UY73iipOBm3wm4S3lAYsRWWSSxp
         VRLSxmsavFHczKvfI4KQNuRB+ARncl5LMr0e03cp6mL8Ff4pKGzZuM+kNmDBskwI0XQC
         Rrkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bief6n2KJvPdjYY33jpAwU4FAk9kTl6ZJ/dHDzSqnN4=;
        b=ITIFf5B3kKhTyxQOeVK7LwkbEWnkqvSMMkPUgH8BmP74BO+kCo3w0ak6UuK7azMti0
         eD42e9Gq/LYsQK5m0SgZdU7aun6IJ9Xydc+ou4mVFTRHFn7QKdM+SYAt6XOti8DHYo6n
         5QWipt2cUiDbP/dhg/a5nneptJeadXaJnqX40WiTUaZ/9uO4kYYFbxGA+Ix2Zy6gUFig
         W2/dK61PGTwA8ze1mneM1DYzdIqElWozHvVe0+ehCHLLsLBZvrc+hCRd7kMbvO38I8ZD
         vMDn0uY7sf+XsudYhEiZbGnR+u4q8++hFxLyUVABd7YcOUvRCb/WgmvWWtD2gKJyKLYo
         dsCA==
X-Gm-Message-State: ACrzQf0JRXzw25updE1WDP1dpo5lrzl8E2t3B3nJaJmbpApO+qnqj1Wn
	pnmiNRB93lPiz7MctImSsnGimg==
X-Google-Smtp-Source: AMsMyM7noZbvnVAq4AOTxjObtKJ7KW8KLfOredevk9btt7ajna0zmmAFT3KLuQYUZheRmxNn23w1SA==
X-Received: by 2002:a17:90a:8c8e:b0:202:883b:2644 with SMTP id b14-20020a17090a8c8e00b00202883b2644mr60087896pjo.89.1666396102217;
        Fri, 21 Oct 2022 16:48:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o8-20020a63f148000000b0041ae78c3493sm13648691pgk.52.2022.10.21.16.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 16:48:21 -0700 (PDT)
Date: Fri, 21 Oct 2022 23:48:18 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, peterx@redhat.com, maz@kernel.org,
	will@kernel.org, catalin.marinas@arm.com, bgardon@google.com,
	shuah@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
	pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
	suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	oliver.upton@linux.dev, shan.gavin@gmail.com
Subject: Re: [PATCH v6 1/8] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Message-ID: <Y1Mvwq5PJ0gxC+47@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-2-gshan@redhat.com>
 <Y1HO46UCyhc9M6nM@google.com>
 <db2cb7da-d3b1-c87e-4362-94764a7ea480@redhat.com>
 <Y1K5/MN9o7tEvYu5@google.com>
 <85d15a4a-bbae-c5e6-f6dc-1d972d07dafb@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85d15a4a-bbae-c5e6-f6dc-1d972d07dafb@redhat.com>
Message-ID: <20221021234818.A7IZLMvluM_Hvz9oAO_7kB7vTYhTZxD2PHOOldPtMMY@z>

On Sat, Oct 22, 2022, Gavin Shan wrote:
> > > When dirty ring becomes full, the VCPU can't handle any operations, which will
> > > bring more dirty pages.
> > 
> > Right, but there's a buffer of 64 entries on top of what the CPU can buffer (VMX's
> > PML can buffer 512 entries).  Hence the "soft full".  If x86 is already on the
> > edge of exhausting that buffer, i.e. can fill 64 entries while handling requests,
> > than we need to increase the buffer provided by the soft limit because sooner or
> > later KVM will be able to fill 65 entries, at which point errors will occur
> > regardless of when the "soft full" request is processed.
> > 
> > In other words, we can take advantage of the fact that the soft-limit buffer needs
> > to be quite conservative.
> > 
> 
> Right, there are extra 64 entries in the ring between soft full and hard full.
> Another 512 entries are reserved when PML is enabled. However, the other requests,
> who produce dirty pages, are producers to the ring. We can't just have the assumption
> that those producers will need less than 64 entries.

But we're already assuming those producers will need less than 65 entries.  My point
is that if one (or even five) extra entries pushes KVM over the limit, then the
buffer provided by the soft limit needs to be jacked up regardless of when the
request is processed.

Hmm, but I suppose it's possible there's a pathological emulator path that can push
double digit entries, and servicing the request right away ensures that requests
have the full 64 entry buffer to play with.

So yeah, I agree, move it below the DEAD check, but keep it above most everything
else.

> > > > Would it make sense to clear the request in kvm_dirty_ring_reset()?  I don't care
> > > > about the overhead of having to re-check the request, the goal would be to help
> > > > document what causes the request to go away.
> > > > 
> > > > E.g. modify kvm_dirty_ring_reset() to take @vcpu and then do:
> > > > 
> > > > 	if (!kvm_dirty_ring_soft_full(ring))
> > > > 		kvm_clear_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> > > > 
> > > 
> > > It's reasonable to clear KVM_REQ_DIRTY_RING_SOFT_FULL when the ring is reseted.
> > > @vcpu can be achieved by container_of(..., ring).
> > 
> > Using container_of() is silly, there's literally one caller that does:
> > 
> > 	kvm_for_each_vcpu(i, vcpu, kvm)
> > 		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
> > 
> 
> May I ask why it's silly by using container_of()?

Because container_of() is inherently dangerous, e.g. if it's used on a pointer that
isn't contained by the expected type, the code will compile cleanly but explode
at runtime.  That's unlikely to happen in this case, e.g. doesn't look like we'll
be adding a ring to "struct kvm", but if someone wanted to add a per-VM ring,
taking the vCPU makes it very obvious that pushing to a ring _requires_ a vCPU,
and enforces that requirement at compile time.

In other words, it's preferable to avoid container_of() unless using it solves a
real problem that doesn't have a better alternative.

In these cases, passing in the vCPU is most definitely a better alternative as
each of the functions in question has a sole caller that has easy access to the
container (vCPU), i.e. it's a trivial change.

> In order to avoid using container_of(), kvm_dirty_ring_push() also need
> @vcpu.

Yep, that one should be changed too.

> So lets change those two functions to something like below. Please
> double-check if they looks good to you?
> 
>   void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset);
>   int kvm_dirty_ring_reset(struct kvm_vcpu *vcpu);

Yep, looks good.
