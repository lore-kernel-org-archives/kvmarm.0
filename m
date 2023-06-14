Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A9E7F
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 14:39:53 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bc4c832c501so810547276.0
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 07:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686753592; x=1689345592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/AH6uPigy9LtuLTFoZ1Kn9i9/l/hz+EtqMRDMoYV1fo=;
        b=epo0PuzWzte/OOmmEpqmE/GWTr1GBMpsc1uSar8XtkuWWX/h9QhWhJgdlFLOdQWDm4
         nNboqSPgDKhsqcs67Drod790hyCrPEwzGFMcvYUJXAM9E/WftZVCGCbunkPA3Av41LHa
         DdJY4bj497l6ZNJHK73iTGuFjrsVmAHXB4U4RGMqsaxqjtyNdXHtPXdJcqrO60NOmFnq
         5V9pYmzbrvOOoAAm8XHHxQfghMU8PCTCf6RJV03ztC8Y8iFv8Jeo0OHRR6+Yf2AAP9YH
         vaEos6bb26U7EF2SaGEYXOzJCyFY99k0e0e/p/jHbI2uHooKhGF61Oy0ZJ/RsMFSy8uH
         MhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686753592; x=1689345592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/AH6uPigy9LtuLTFoZ1Kn9i9/l/hz+EtqMRDMoYV1fo=;
        b=UPuuYlJpz4XFPXSQO7dCXVmfUrBqwbp0kJhq3Djg/PnIzl5e2AnO7RUK9dWsu+B1S9
         r4wp91mtvV8RClWJb0Zi52tvReoQbrPuk5AmNqx/QF77nySalzRJrFKzvVfi8h8/DXDd
         a78ojHJK0SRvPUyhpsBVXLRiJiav6lq1LsKX4yqHhiAYcVDPxqu8iAPPcTtircOVoPWq
         3wDzIPxBiS23hOUB7CY4xdGkSM+nVZbxoqn9nnoHe+iKqZh5AmNFOh8MGbiSl04X5SZL
         kCGkNh5xF3TszY6jrmaHpEJYTDozxS3/nb8GdVn7/rRols8MG4KglMLTK54R6bqYrsP6
         PG7Q==
X-Gm-Message-State: AC+VfDwGykM1GIh9iNSxOSoSmlaVWuEs1d5UQedd08SJXVRb18RhiWFe
	Py1lTTwqtyDXLZezp3tRi++3r5g4k2s=
X-Google-Smtp-Source: ACHHUZ5C7ugUcDxAC4fyHl3lyT/DeF+mM58NhmS8t+GMlBXVtTje+z3/5W4u/dYfKlCTI+LfGB9ZWiVGr5o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ec0d:0:b0:bac:faf4:78fd with SMTP id
 j13-20020a25ec0d000000b00bacfaf478fdmr289336ybh.7.1686753592568; Wed, 14 Jun
 2023 07:39:52 -0700 (PDT)
Date: Wed, 14 Jun 2023 07:39:50 -0700
In-Reply-To: <20230602161921.208564-2-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-2-amoorthy@google.com>
Message-ID: <ZInRNigDyzeuf79e@google.com>
Subject: Re: [PATCH v4 01/16] KVM: Allow hva_pfn_fast() to resolve read-only faults.
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

Don't put trailing punctation in shortlogs, i.e. drop the period.

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> hva_to_pfn_fast() currently just fails for read-only faults, which is
> unnecessary. Instead, try pinning the page without passing FOLL_WRITE.

s/pinning/getting (or maybe grabbing?), because "pinning" is already way too
overloaded in the context of gup(), e.g. FOLL_PIN vs. FOLL_GET.

> This allows read-only faults to (potentially) be resolved without

"read-only faults" is somewhat confusing, because every architecture passes a
non-NULL @writable for read faults.  If it weren't for KVM_ARM_MTE_COPY_TAGS,
this could be "faults to read-only memslots".  Not sure how to concisely and
accurately describe this.  :-/
