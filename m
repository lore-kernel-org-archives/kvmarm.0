Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A94C13AFC
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 17:40:03 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-53ba38cf091so7206718a12.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 10:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689010803; x=1691602803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mzbb7xS3YBuH/eMWilsy8aIsa55E6S/F+W5yfrdF6ps=;
        b=BjJnQeY+cn0AJlQsnIMteL/HbVSGc2GSkA2N9pH2OA1ubVjsVXqnRRTSobjrGGNoS9
         NTXL9wOdhFClIubW+nLDVkwMmRWrGFiUExc872o77xFOwmyqVtjtm4qKmOnGDn8GoQ74
         PhNW9cTg+3a1WdFqRmwaIwReuObKCfLmYZJ6hgmoUgbEli7N8mU8IPoeWZ7GLVamW7+A
         ZbRFCw0BVCwWyS9/5kynxXnmB+STIHCB45g52CtmelfjizDpkXs0hgZRbGQPU1N0lUmu
         tc+9wIw/3plQkXyf/anWxggtXvpgMKBN2XGl99V8msWmGdu6ihlV1Wqf2CGh/hMFoyFx
         y4yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689010803; x=1691602803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mzbb7xS3YBuH/eMWilsy8aIsa55E6S/F+W5yfrdF6ps=;
        b=NPEZZaPWtUEZ0Q+pVqMbIEkDlaLZRcRnbSQ3zM7MXgs/EONakt/Qri56zTIGMeFEKd
         Q8RuVf6n8QCdm+CcydKR4DGBTFOZfO6WEV6PSZ1dBPggbnuOaBJqP9K9j9L0Y7RnI9zz
         FvHU1fU2+q5D4HVAbBxP0sLyx+1iFWs4txJXrYV0bAXdx4QLgPS1c1m4Pe3IA8120QK1
         nhO6IbHn4VFTXNPSepKDdpS77QzvVAibfuiGs/C0e9DsVdjIxC2MAMGfEqaL/tVAIqtT
         lBe/e43UcFjuBQCUsNQT7Z5uX4v2HEnPOP9wtbrJelgWaK1IZ6KGKpZSC3hM2LpdtqlA
         BPvg==
X-Gm-Message-State: ABy/qLZ+KUeQA/o3Jrpc+z2ad4A3sh51rtr4RJhCZ3TtwDgLq83EGCj9
	Pl0fxLl1KCaHyyH8BoL+rEvKX3ySJsg=
X-Google-Smtp-Source: APBJJlH+tM8Y/lsaXf9KUpXQAitRtchoryMAjw/RjTURKcbwg2RRlXgn3/drXmB42/p/dtkbirFn2NLNxoM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ca81:b0:1b9:d23a:df78 with SMTP id
 v1-20020a170902ca8100b001b9d23adf78mr3957477pld.4.1689010803365; Mon, 10 Jul
 2023 10:40:03 -0700 (PDT)
Date: Mon, 10 Jul 2023 10:40:01 -0700
In-Reply-To: <CAF7b7mrDH4Y+uWPW9kxL==i1LDURMHdNv+maFj_PH7jwPb3JwQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-8-amoorthy@google.com>
 <ZIoUc2hLd0zMOhO+@google.com> <CAF7b7mrDH4Y+uWPW9kxL==i1LDURMHdNv+maFj_PH7jwPb3JwQ@mail.gmail.com>
Message-ID: <ZKxCcbeXauiOX94I@google.com>
Subject: Re: [PATCH v4 07/16] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 07, 2023, Anish Moorthy wrote:
> Done
> 
> (somebody please let me know if these short "ack"/"done" messages are
> frowned upon btw. Nobody's complained about it so far, but I'm not
> sure if people consider it spam)

I personally think that ack/done messages that don't add anything else to the
conversation are useless.   The bar for "anything else" can be very low, e.g. a
simple "gotcha" can be valuable if it wraps up a conversation, but "accepting"
every piece of feedback is a waste of everyone's time IMO as the expectation is
that all review feedback will be addressed, either by a follow-up conversation or
by modifying the patch in the next version, i.e. by *not* pushing back you are
implicitly accepting feedback.

And an "ack/done" isn't binding, i.e. doesn't magically morph into code and guarantee
that the next version of the patch will actually contain the requested changes.
