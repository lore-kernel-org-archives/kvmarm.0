Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816DA31A93
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 19:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Oh/ZTBJ"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1c9f973d319so25621785ad.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 12:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697485122; x=1698089922; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T+tprJ5evQ3yc1gWAh51A0ljnbQXoQ61VMKRaZ+HB8c=;
        b=0Oh/ZTBJc8136RAXL4fiL4CCKVq76nUmfGLv5FvOHnB2TqGAYZVmYbhqlxHo36eLr4
         /UsfU0o/AniVC+SAajZU0uRr66R0zS8DIFHFfXcEJsMG8WLjM2KDKGBwSujwjqU9p+YT
         2cOyxJtxE1Mho1z5+9/dbzcc6Sv9qEX6L9p8fW03aBYt+KjzhPA854wPsltbJOE9XHBi
         MEOLJaO/1UVQXQJ3T1W9TrM333VOzH25+7HlxBMIrExnks6dYhb0cK1r9B4CzYCY9IeD
         sLhMw2qG7cb1Co/hWdoudFs54AbDFvbiwBuMCD0SOAdqD+qPc5PBfYc/IpdsxUjuWPS+
         K4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697485122; x=1698089922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T+tprJ5evQ3yc1gWAh51A0ljnbQXoQ61VMKRaZ+HB8c=;
        b=aldddME/EOh0507Chc8ywsaAldtzW3z/w3UHjS4ocJoho1FLbIoNbW+uABNacbO2iF
         0evBeHqpit4EUFEKdJJsWNffVASYo66/Y2e10CbO7bsDvipNq79vZKk5MZCLhOqEc22U
         WQZz3fip+x2nSOGY7PU5L6UqlvgJT3iMSHSUH1dYut9DfiNQ/TJpPzOPSmziHfMGFCYF
         s20FAMI0/rhfBIKiUiQJrYhSbU6V245/asr/oqSdD3SFeUNLUSbGXqzWlKg28DnN6XB0
         80EsqTrCXGC128z/pj8z+ctNvbc5MknJw59EIC4UXVqDsLHWEKIZDHtvTYRkFdpBeUWD
         Gi3A==
X-Gm-Message-State: AOJu0YxNFaHa49GZkVbDyxXyJDC2NnAtnmeQ+piwWdY4UjEtEFU6zK7c
	ag0+MpDbEYly9EBBbqsDGBU/8V85R7c=
X-Google-Smtp-Source: AGHT+IEs4kjKHl7kcZuhpmuuS8c2ZTy+FQzFfwSx2kiHvv6VatlGeS27RXZFvvd3dQXcNCum9uf28/BPac4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:23c7:b0:1ca:7a4c:834d with SMTP id
 o7-20020a17090323c700b001ca7a4c834dmr4834plh.13.1697485121706; Mon, 16 Oct
 2023 12:38:41 -0700 (PDT)
Date: Mon, 16 Oct 2023 12:38:39 -0700
In-Reply-To: <CAF7b7mrt-iWduEQusKHhP3TLiWwL1gQjGj0HB=u1R2Vd5yEP0A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-10-amoorthy@google.com>
 <CALzav=f8YDdqxVXNRASNWxuM2WzgBwj=hErj1Yc5da552ecG5Q@mail.gmail.com> <CAF7b7mrt-iWduEQusKHhP3TLiWwL1gQjGj0HB=u1R2Vd5yEP0A@mail.gmail.com>
Message-ID: <ZS2RPy-N1l5wTOLg@google.com>
Subject: Re: [PATCH v5 09/17] KVM: Introduce KVM_CAP_USERFAULT_ON_MISSING
 without implementation
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: David Matlack <dmatlack@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 11, 2023, Anish Moorthy wrote:
> > Bike Shedding! Maybe KVM_MEM_EXIT_ON_MISSING? "Exiting" has concrete
> > meaning in the KVM UAPI whereas "userfault" doesn't and could suggest
> > going through userfaultfd, which is the opposite of what this
> > capability is doing.
> 
> You know, in the three or four names this thing has had, I'm not sure
> if "exit" has ever appeared :D
> 
> It is accurate, which is a definite plus. But since the exit in
> question is special due to accompanying EFAULT, I think we've been
> trying to reflect that in the nomenclature ("memory faults" or
> "userfault")- maybe that's not worth doing though.

Heh, KVM's uAPI surface is so large that there's almost always both an example
and a counter-example.  E.g. KVM_CAP_EXIT_ON_EMULATION_FAILURE forces emulation
failures to exit to userspace, whereas KVM_CAP_X86_DISABLE_EXITS disables exits
from guest=>KVM.  The latter is why I've shied away from "EXIT", but I think that
I'm looking at the name too much through the lens of a KVM developer, and not
considering how it will be read by KVM users.

So yeah, I agree that KVM_MEM_EXIT_ON_MISSING and KVM_CAP_EXIT_ON_MISSING are
better.  Let's go with that.
