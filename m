Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F2B1FECBD
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748010818; cv=none; b=CEGyTbTQHVcv068mQ2dv8JPi6y9YKniFxDMXnJxr0gyW6W0nV6Bx2eD36mH7BQZTe89KG7l+0l2ACDactzFD0suSiZm3URnpOonJ4UDekrgoZdPBY6Ufo0iElMukw2MZdY3NPtoN7n1GZ5vqinp2UMk4kyNBh5lUpbKu/xPrCHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748010818; c=relaxed/simple;
	bh=M0JM/iagUnyNnadh7PX4hbYGXfsli6u0A5pI6J9XwVs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dussb7Mo1zpxVZ9rJSWUfMqC87xL6hm0Zz/P1oDAJi4HuxTinMYOiT7O2qQgNHLNoU5B66nVrV9fhf3d4NcQoRIeAyPRi1eWD4Htr9z3YIAJBPNRSlMTwKORZwFSq+fHiObjZGUNqLNukFCTA+/UcHoqgWZHbEt1Tjt8w+Xh4wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=umf9lMuw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="umf9lMuw"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-310efb64693so23257a91.0
        for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 07:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748010817; x=1748615617; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/uvu6aXDIrLF08vsxpzyNfXk0GOFzmWSaZdsX/BEX7c=;
        b=umf9lMuwkY+X/6pPw1uX8lQqx7UVzh+2qDLd+7u9j6wtlelUKXrrjAlBpDd/COnWtY
         PNTDUw9R2Qxgy7nb4ipq9iezKcnvejifFwiRoLK+7Ry4K7PxijDw7l2hYZ+TUiqjE0nO
         T1X26JFu7JVqr3gfyP7L8M8T/tr9JuaXpFkCDTR6vzS35/oRhwhpn4pE3hsMsXHSdNt/
         anFsW/bNR72OcFcyeOXojXqY52lECDIjJQdfSjUvCYKRh5oMG5AVTwNDn6YU0B2mY6Cr
         nukBI6fWE+mm/WLDlvdKCDFMhuRtouyUVee+lyN7Vu68tkJaLotRcsSvqHr34K3sP2zY
         n6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748010817; x=1748615617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/uvu6aXDIrLF08vsxpzyNfXk0GOFzmWSaZdsX/BEX7c=;
        b=Ye0VNdOqmxhs7+GxDIevdrwit41g3gpuBqVUa2TcqdJ+xCCMindNRSTDF3k+k+G0cv
         tmwvNggfiaHJscIT2Dpue11909NEQG33kw324+Jq0BvY1h+EPlu+eoDmdBaGIgSfWPbp
         fSJg/An4DD+GM8jpWNrkmopp0fDxUf5fhEF3E4K8VAdmQBoO8hkP9a/ctI2CkziBfW5o
         OQZt6oJVTjAuP2seFSsHEizlrepyPOJxFwDU++H9BwCZvxXTANeIqun3btjCrHZAvZvY
         eOfv7kfdwH4rAkyT/NkBQFJH54TiuNdGCFnaat+MPMm6EfeJ6sYlnehz3aAhPN0ugbez
         4vWA==
X-Forwarded-Encrypted: i=1; AJvYcCVnrQaqP6FgjzMgfVHk/04MAOwru89HYdIg6gnuALAg7l9XEgxwTemorXxrIrQ9opyM3nx0PWc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6NaJ8i81y9PCRLJdfTmpsQwUK8hU0m5JT3h6tAk374X//ghdh
	Wlc9Z/hm43C1UTLSwmSSQGCWPRbuQltmn+AWjOKJ2wUJImUlQS+bHrLZiKYQLj/4inJ7MoHbI1p
	8wtthkg==
X-Google-Smtp-Source: AGHT+IHsZ0QnOLBFT5oLqgFlsou+V6RqzdnkAMpT1uyTVqCC/FSYHIecluEf4Yy5p3wiVYxCHPutaUGV15c=
X-Received: from pjbmf7.prod.google.com ([2002:a17:90b:1847:b0:30e:7b26:f68b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1846:b0:301:9f62:a944
 with SMTP id 98e67ed59e1d1-30e7d5ca287mr50858908a91.33.1748010816755; Fri, 23
 May 2025 07:33:36 -0700 (PDT)
Date: Fri, 23 May 2025 07:33:30 -0700
In-Reply-To: <2c52daad-0b64-48a9-8e73-d1aba977993b@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com> <20250522235223.3178519-14-seanjc@google.com>
 <2c52daad-0b64-48a9-8e73-d1aba977993b@amd.com>
Message-ID: <aDB-2lcq4jJm9-OV@google.com>
Subject: Re: [PATCH v3 13/13] KVM: selftests: Add a KVM_IRQFD test to verify
 uniqueness requirements
From: Sean Christopherson <seanjc@google.com>
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 23, 2025, Sairaj Kodilkar wrote:
> On 5/23/2025 5:22 AM, Sean Christopherson wrote:
> 
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	pthread_t racing_thread;
> > +	int r, i;
> > +
> > +	/* Create "full" VMs, as KVM_IRQFD requires an in-kernel IRQ chip. */
> > +	vm1 = vm_create(1);
> > +	vm2 = vm_create(1);
> > +
> > +	WRITE_ONCE(__eventfd, kvm_new_eventfd());
> > +
> > +	kvm_irqfd(vm1, 10, __eventfd, 0);
> > +
> > +	r = __kvm_irqfd(vm1, 11, __eventfd, 0);
> > +	TEST_ASSERT(r && errno == EBUSY,
> > +		    "Wanted EBUSY, r = %d, errno = %d", r, errno);
> > +
> > +	r = __kvm_irqfd(vm2, 12, __eventfd, 0);
> > +	TEST_ASSERT(r && errno == EBUSY,
> > +		    "Wanted EBUSY, r = %d, errno = %d", r, errno);
> > +
> > +	kvm_irqfd(vm1, 11, READ_ONCE(__eventfd), KVM_IRQFD_FLAG_DEASSIGN);
> > +	kvm_irqfd(vm1, 12, READ_ONCE(__eventfd), KVM_IRQFD_FLAG_DEASSIGN);
> > +	kvm_irqfd(vm1, 13, READ_ONCE(__eventfd), KVM_IRQFD_FLAG_DEASSIGN);
> > +	kvm_irqfd(vm1, 14, READ_ONCE(__eventfd), KVM_IRQFD_FLAG_DEASSIGN);
> 
> Hi Sean,
> I dont see any allocation for the GSI 13 and 14..
> Is there any reason for the deassigning these two GSIs ?

Yes, KVM's rather bizarre ABI is that DEASSIGN is allowed even if the VM doesn't
have a corresponding assigned irqfd.  The reason I added these early DEASSIGN
calls is so that there will be an easier-to-debug failure if KVM's behavior
changes (the racing threads part of the test abuses KVM's ABI).  I didn't add a
comment because the helpers already have comments, but looking at this again, I
agree that main() needs a better comment.
