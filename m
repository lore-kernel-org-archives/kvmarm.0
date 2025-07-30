Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E169B15199A
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 12:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753880230; cv=none; b=HvioguNOkwxAS7VKRMXHGSnUT+pARkw4y0ucniXT6fVRBcBJmNzXvNSRy0DsvUc4DCbuZADT8/q760pHrvXrCNbnmJl5UoYJMDWZ/Jmcus8X27buNZ4Gco5/1GY0OnmOtiiMoL9+Y0h48gRWcoDITnrw4yCGTmRFnN2/49/6KtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753880230; c=relaxed/simple;
	bh=tbQGkXTx5N8cfzBhsKZ6O8byb9fUPaWpLKuMOPkynhE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sJpYASeqwgabJgRRqCWzRzxDsIOi5Sx5bVwSjjvcRYUA2KwOkKtDjsUo+dgaETHIXKKT9iYMpoPDidrutbe3RPl1coMC3lNbro/InnZBfZ1eC/8OI3HBUS/tU7H1oSEYHefwMqPPfkEd+ARnCPeNUQPyAvyjRq1uaGcA5qgTZy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VKM0y6Vw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VKM0y6Vw"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f729bf733so603045a91.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 05:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753880228; x=1754485028; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AGJERRSxIHYm/D7qRYs3pk5CzuzrfI4TxpqJDm/o52E=;
        b=VKM0y6VwXpPqFbysZEUgYQ5FTJdCLAjvJlO9gai+LjKKyE6t+LPR3z+mJWsHHhhuDv
         w8uO2bn523v7IZzC911s2ctj+SRhc5ZAh8J0MdcP4VJykU1CbsNToGzfnVUDFDxvprNJ
         HWbE+KWsBJ2Zd+jAo4allpS+pnu7ZtV+/tniY4HmHhlrh2N4w25JnLD4d5XTlGQpNQb4
         Af1xMvKPm/4xPTuQvD1qd2oo/K5tWm+x+pDWmOzZGG0/zwI+Y5l40CU859dsguXfcoCy
         BdH6GVy0ZpnYozFF6pHtYGfqtiW5qT54KPBMaSR2hn++Lk05tj/zH2ZBWFEEOo7d9imx
         mKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753880228; x=1754485028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AGJERRSxIHYm/D7qRYs3pk5CzuzrfI4TxpqJDm/o52E=;
        b=FdV/P1zfyrhTIlXrm6n0Z44Tnp6MYgzVj3GU83lunGZDsn/Jtr3j9ltPrtrJ69wq1r
         YdumW3Vlf+ijGngu0hi8Vj9Gmhoj1F1MJxvU5sb0447UzqgUPE8J0nR4a9rkLBbg+y+K
         4E9i5JPPOpNdG4pf39IGFmBhiiSZt+rLTvdeJobeCluzefBLQA8DKAYNHfxWur0AKhKi
         isLYY0OQT5v40kikseAbfKDaQ/bmBX4lkzrUQm7jgrVXVTnZ9S8xWQn2lPonEglnNBaO
         ZfzyIQA5MlqkqVlnkPAGA64zNMf4fieT8bmMWGxX2IuIzkfe7Kg7Fu+YohCYJgXxaleK
         /I8g==
X-Forwarded-Encrypted: i=1; AJvYcCVQ7qhTBEDtPcEKk0ZqQi1fHABdArFxGWR76rmIi5xSgrVaRaIq7/RiZUfqb6Lf8IE2OiliIG4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXtTNlg6hRtX09TbJA0l90y57xxCRF14/NlR6VO6YGM1YVUKPM
	2j9orcLZ13fUEDJQ+qlTdOi8aDrtWDmELytruRnNlP4xuf9qJdEENKUdmeM17PXEH25oBwKYLGX
	qRDmlOQ==
X-Google-Smtp-Source: AGHT+IGTVzSY5NC9djL4t4SYCqSM0WRzbgQXc+av5XxWfwIb706Wi6fuHTkYD9Th8LKmbEzDjnpm2KiAEQI=
X-Received: from pjsa5.prod.google.com ([2002:a17:90a:be05:b0:313:274d:3007])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3948:b0:311:fde5:e224
 with SMTP id 98e67ed59e1d1-31f5dd8ce1amr4347975a91.6.1753880228258; Wed, 30
 Jul 2025 05:57:08 -0700 (PDT)
Date: Wed, 30 Jul 2025 05:57:06 -0700
In-Reply-To: <856487d0-8e1a-4e64-a8e6-13977fd31fed@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-24-seanjc@google.com>
 <856487d0-8e1a-4e64-a8e6-13977fd31fed@intel.com>
Message-ID: <aIoWosN3UiPe2qQK@google.com>
Subject: Re: [PATCH v17 23/24] KVM: selftests: guest_memfd mmap() test when
 mmap is supported
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 30, 2025, Xiaoyao Li wrote:
> On 7/30/2025 6:54 AM, Sean Christopherson wrote:
> 
> ...
> 
> > +int main(int argc, char *argv[])
> > +{
> > +	unsigned long vm_types, vm_type;
> > +
> > +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> > +
> > +	/*
> > +	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
> > +	 * support guest_memfd have that support for the default VM type.
> > +	 */
> > +	vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
> > +	if (!vm_types)
> > +		vm_types = VM_TYPE_DEFAULT;
> > +
> > +	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
> > +		test_guest_memfd(vm_type);
> 
> For ARCHes that don't support KVM_CAP_VM_TYPES, e.g., ARM, vm_types is 0
> (VM_TYPE_DEFAULT). the for_each_set_bit() loop will not execute any
> iteration at all.

Doh, indeed.

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index b86bf89a71e0..b3ca6737f304 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -372,7 +372,7 @@ int main(int argc, char *argv[])
         */
        vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
        if (!vm_types)
-               vm_types = VM_TYPE_DEFAULT;
+               vm_types = BIT(VM_TYPE_DEFAULT);
 
        for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
                test_guest_memfd(vm_type);
