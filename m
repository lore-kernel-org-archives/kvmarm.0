Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683891B3F16
	for <kvmarm@lists.linux.dev>; Wed, 14 Aug 2024 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646974; cv=none; b=eG9HuD+sOvgYSHV6KuHQj4bKNt65Yk/tDZdUGuOxRj9mM5LIRqYlDoSsQDwCNAeO4L+2GzdvOgFAJUvI0hu+dZk6+8hnPJeDDtuZV7nGeVWuC5woiWFA+OUI+J55tXoyex4UhRqTqphHwzWgj8c4lt60HbHlg5xtnRNlAbBrNQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646974; c=relaxed/simple;
	bh=/+q2N0WMy8zi1EQ8v8/v51IJF0vlxa+BET4jSNKtPHI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TgbZTR6rDaNP3VHxBLg1du3Ca1C9GxMlmjlWSvVWvshKzS1BOF78eZjPIQV0mgA/70I7hLrj8sJdoWjcSMLeKV3qS9zwUFekwvY/pLpP6iyKQWH2iePDriaYlVWNKGwxV/57cDHf0q4Do/mnVqOoN+Ih07bQ/VjZqgGVzUi5jEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XcADASfs; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XcADASfs"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc52d3c76eso72886615ad.3
        for <kvmarm@lists.linux.dev>; Wed, 14 Aug 2024 07:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723646973; x=1724251773; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DnSCSaSy3plYeVBVOGtckRrfN95Z3a9Gqe/5qm41Hxk=;
        b=XcADASfsNwyLC8H8HkTbC3BniyW+X1LCWbvPOfmeOfN2y9f2T7DuA7c1pAVc27nVP+
         Td7XeEGikVMC66BfwpDsXT/hIurSvHH5DltbXCvm9qhwflGb9+S8XMGzg9YH5yGsTuxp
         bPVNdb1/kpsier9cam/secOsIH2nn4HUq8D76n3zFFLYUtrLZjwM/a0v9UrIkwr6bhGL
         ueoiQ0i+eX1iPoaMkOH+sty+A7bK0eQmUGnbdN75SG1NVbg1qA95DAh/Z6MntN+GzNDr
         mv6olqJfXPcqrB0Gvt5RlIoT38yNkmmhhWB0oQADZM87gflTkuEHASDxjth1G8pYPz9N
         blBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723646973; x=1724251773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DnSCSaSy3plYeVBVOGtckRrfN95Z3a9Gqe/5qm41Hxk=;
        b=TWOSbaaWyS+h+gzV5gaNK5EDvakZL2Y1AncM2MWtB8urQeBs3yjyoYOS+aRvtuPQ9I
         I8Pujg8poY2So2iTi/BuENpIM+A9+AyAC8aMLCMJ0piXntTMTlsA58CxW5ukfnWo492p
         eDV2+j0WK6HggrbOZXs+gPMIUaJmhZBQ83fwmfHJnNgaflow5fC+flijq1IjQmtXJ24J
         F6mrn4Lbo8iIuWWGVQl+SouxxoXxSYHL7R3Q9eX3nMYo2+IfT4XiMxGZmK0boPIX7t0Q
         kMP1IDPo7SOurWXdwauF5MbMn/Yc6fXKj/+gabg7Yo07/YIZZ+MCpYUiVEB4PQQFqkr/
         Yrag==
X-Forwarded-Encrypted: i=1; AJvYcCXo8yURWF/wgVqGWqM/w+7DIcteD6QGIho37nNcZNmnsZ94wPInn1sIDfp1TjwPIugGQCYJJ3nBODtepIzHLPP0oREpcebs
X-Gm-Message-State: AOJu0Yy0Kv5Gl2axO/KnF1Sw7qnu1J4g/SZY5Ve4SkkPGtHU1x6O0EXA
	ZBmyZ/X/RsUqbY0P1GrIA/8Prhkwr43b3GAHB18ePhcCSHBJnkF23o2KsBKITaCeCiahTmYa4u9
	x9Q==
X-Google-Smtp-Source: AGHT+IFB61s8uHv+FQHeDsB6TsbibBjrr/ZwNididN1e3znPTPIm8eFzYZIoLcM3rfqSDWNYlAvaPhyrfFs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6544:b0:201:dc7b:a8b5 with SMTP id
 d9443c01a7336-201dc7bac0emr541235ad.12.1723646972522; Wed, 14 Aug 2024
 07:49:32 -0700 (PDT)
Date: Wed, 14 Aug 2024 07:49:31 -0700
In-Reply-To: <yq5ajzgjy1jp.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com> <20240809205158.1340255-4-amoorthy@google.com>
 <yq5aikw6ji14.fsf@kernel.org> <ZrtskXJ6jH90pqB2@google.com> <yq5ajzgjy1jp.fsf@kernel.org>
Message-ID: <ZrzD-3r4XyJr3auG@google.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Perform memory fault exits when
 stage-2 handler EFAULTs
From: Sean Christopherson <seanjc@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Aneesh Kumar K.V wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Mon, Aug 12, 2024, Aneesh Kumar K.V wrote:
> >> Anish Moorthy <amoorthy@google.com> writes:
> >>
> >> > Right now userspace just gets a bare EFAULT when the stage-2 fault
> >> > handler fails to fault in the relevant page. Set up a
> >> > KVM_EXIT_MEMORY_FAULT whenever this happens, which at the very least
> >> > eases debugging and might also let userspace decide on/take some
> >> > specific action other than crashing the VM.
> >> >
> >> > In some cases, user_mem_abort() EFAULTs before the size of the fault is
> >> > calculated: return 0 in these cases to indicate that the fault is of
> >> > unknown size.
> >> >
> >>
> >> VMMs are now converting private memory to shared or vice-versa on vcpu
> >> exit due to memory fault. This change will require VMM track each page's
> >> private/shared state so that they can now handle an exit fault on a
> >> shared memory where the fault happened due to reasons other than
> >> conversion.
> >
> > I don't see how filling kvm_run.memory_fault in more locations changes anything.
> > The userspace exits are inherently racy, e.g. userspace may have already converted
> > the page to the appropriate state, thus making KVM's exit spurious.  So either
> > the VMM already tracks state, or the VMM blindly converts to shared/private.
> >
> 
> I might be missing some details here. The change is adding exit_reason =
> KVM_EXIT_MEMORY_FAULT to code path which would earlier result in VMM
> panics?
> 
> For ex:
> 
> @@ -1473,6 +1475,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> 	if (unlikely(!vma)) {
> 		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> 		mmap_read_unlock(current->mm);
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,
> +					      write_fault, exec_fault, false);
> 		return -EFAULT;
> 	}
> 
> 
> VMMs handle this with code as below
> 
> static bool handle_memoryfault(struct kvm_cpu *vcpu)
> {
> ....
>         return true;
> }
> 
> bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
> {
> 	switch (vcpu->kvm_run->exit_reason) {
>         ...
> 	case KVM_EXIT_MEMORY_FAULT:
> 		return handle_memoryfault(vcpu);
> 	}
> 
> 	return false;
> }
> 
> and the caller did
> 
> 		ret = kvm_cpu__handle_exit(cpu);
> 		if (!ret)
> 			goto panic_kvm;
> 		break;
> 
> 
> This change will break those VMMs isn't? ie, we will not panic after
> this change?

If the VMM unconditionally resumes the guest on errno=EFAULT, that's a VMM bug.
handle_memoryfault() needs to have some amount of checking to verify that it can
actually resolve the fault that was reported, given the gfn and metadata.  In
practice, that means panicking on any gfn that's not associated with a memslot
that has KVM_MEM_GUEST_MEMFD, because prior to this series, it's impossible for
userspace to resolve any faults besides implict shared<=>private conversions.
