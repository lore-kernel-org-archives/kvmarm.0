Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227D423DF
	for <kvmarm@lists.linux.dev>; Thu,  1 Jun 2023 19:34:50 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1b04bc1f3cbso5610985ad.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Jun 2023 12:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685648090; x=1688240090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5uKRy9be5xz+z4blyIXACShVZUPCjj7pk1gtLgfKMYY=;
        b=o0mnB4wbetWEuOs9j3/BtFX+p6AEvGNDPlOy4PgK1rZoo5gbYb04nnEJmzUCoqviIa
         YvumGCxNuWuwea9yUo8PTLK7NZ4rJFxUQaazg/+vcLLIJquNv7kcYevBvav9ZCTrfGZH
         bNDHfBp/ILYkHg/eKzIHeZGTodjpYiTF7ETGdpZOtyaLOGPe+svvOC0zXgFLfh6pfskp
         O2CG/EY1kclP5234P3uhrGKy6Fh3ILV0P+/sWjPEjTpIHfrSB5MSzlvd4ECRcl7/pKYt
         PU9eSe/nzkMFm9dBWIgOUpNMH2CEVR7sPKwXjT2UwJi+21AkqHyjZw10nEuzX2+aRm8h
         /BVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685648090; x=1688240090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5uKRy9be5xz+z4blyIXACShVZUPCjj7pk1gtLgfKMYY=;
        b=etpVspkBGrkLoXYGf8umq1USZiwARoxxod1xOMahs8YTRuhvjHeS4voGKyPxEUYsQH
         hxXjyZV+coffkgi81P3dXc5Aq+2fI+fUFrqjFTRSqg+sChieY6RafL1UratmBtYPMOOY
         WAHHzOiTlFdZauHPjJ6STt5CNzVwgC1t2KY6RwQkZaMMHA4rOF6s6Q+0tqPLMXygO39e
         TRViXkIataUucJk+UHDXXoyWG0+rroQa80Rxlb/cLG96hN3jQELwlNDQ/NOE6hkHARnK
         XngnchqCgSKsrTEgcFEv4IfpEw3qUt+q0PVBDz2VUFkv88vbgFSyKCh5kUC6x4TVKevh
         fMiA==
X-Gm-Message-State: AC+VfDx5ChOdudm6wJtzWlxhOV4+EsdFsQWF3YPbmVAHNXst5cFsPqAd
	ktoCXqUsi5yPICg3qtu8gjCl8fvxYqc=
X-Google-Smtp-Source: ACHHUZ7n+yn1GbM4jMgzCsaCebi+5XoxILoTK5BJ9lRipJN0vk1wv9VJ7+Sh+52SC+g1B8OlV1y3ecIe1Ug=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a585:b0:1a9:8f00:bf6e with SMTP id
 az5-20020a170902a58500b001a98f00bf6emr99690plb.3.1685648090364; Thu, 01 Jun
 2023 12:34:50 -0700 (PDT)
Date: Thu, 1 Jun 2023 12:34:48 -0700
In-Reply-To: <ZHjxjcj4AVTRV2A2@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-18-amoorthy@google.com>
 <ZHjhSZFwEc+VfjGk@linux.dev> <ZHjqkdEOVUiazj5d@google.com> <ZHjxjcj4AVTRV2A2@linux.dev>
Message-ID: <ZHjy2NRDmTmPc3R5@google.com>
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com, maz@kernel.org, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 01, 2023, Oliver Upton wrote:
> On Thu, Jun 01, 2023 at 11:59:29AM -0700, Sean Christopherson wrote:
> > On Thu, Jun 01, 2023, Oliver Upton wrote:
> > > How do we support a userspace that only cares about NOWAIT exits but
> > > doesn't want other EFAULT exits to be annotated?
> > 
> > We don't.  The proposed approach is to not change the return value, and the
> > vcpu->run union currently holds random garbage on -EFAULT, so I don't see any reason
> > to require userspace to opt-in, or to let userspace opt-out.  I.e. fill
> > vcpu->run->memory_fault unconditionally (for the paths that are converted) and
> > advertise to userspace that vcpu->run->memory_fault *may* contain useful info on
> > -EFAULT when KVM_CAP_MEMORY_FAULT_INFO is supported.  And then we define KVM's
> > ABI such that vcpu->run->memory_fault is guarateed to be valid if an -EFAULT occurs
> > when faulting in guest memory (on supported architectures).
> 
> Sure, but the series currently gives userspace an explicit opt-in for
> existing EFAULT paths. 

Yeah, that's one of the things I am/was going to provide feedback on, I've been
really slow getting into reviews for this cycle :-/
