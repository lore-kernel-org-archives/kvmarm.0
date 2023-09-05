Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0775FC1E
	for <kvmarm@lists.linux.dev>; Tue,  5 Sep 2023 23:56:33 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d782a2ba9f9so747290276.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Sep 2023 16:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693958193; x=1694562993; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BTMdUX0G2lv2+kU2WiYySTJObpffzgV002stI1a1W7I=;
        b=P6nTDGsqrvOlsUpkJ+uU9k6KmMSLVztzZ4rQWUWSQ/ReoSNncuaqG3bj9H4LZt/jnq
         KvZ1ShcQbsklC366kKYBG3UtJSAxvfPYVIi0yEK4cr+jtU++2QVEu345Hi192abzillv
         h2QD5sqhdoSt7S9/rt9ME3lgmbCnOWfE5/SaU4izL28WX9+FXlUIkgHq8PYDWYSEewtw
         Gjl7pzhBBlPCEMWjizVuWv5RypJ2IGtIRJdn6TTYdsACHcaymBEfKiSMSZ0ri9BskeeC
         lYTcHh8gnO25obqMNKkuve18LdjwvE/8HOnQxa9qE1LkkZ2oICBEfaQkjmF4DcMfT1hg
         Bcvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693958193; x=1694562993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BTMdUX0G2lv2+kU2WiYySTJObpffzgV002stI1a1W7I=;
        b=PqdxaPq2ozaaTJxilpXNzxSuG5KHf2p8OE5AZSh4OxjnCJhqXkFOm7z464Mbb6fpYX
         CXNLwlsss01bXFh1wOP8bhPX9+16/lBEGc+0vo+ETopHRNTFj0r/hobzyHbBNkYzj/RN
         tqGSZDEOKMrppdKj+QN2E4wEbQDmOCOsehzsMDSvD2vOZaPHSrew81OOTHA4c5+AkDsK
         1iIRcL+U2kmtxuRd8ak/EPHqK/MWrpQJYDenLAKvY19PaTFFeuCzoiRaC0OnGGuepyQN
         DJKnigwONlunxiRZdyftcpUy/GjoY4cVkvsYEAILqHQpsILAGVHvYMdEe1yvftdGJnki
         o6WA==
X-Gm-Message-State: AOJu0YzPFa8EDahODZ6byJJdyxFr4qfXQhkHZGhvWBrX1NrAIs7MFx/L
	5DLFv5lKbKTp57BMDi802r7VcoogaGc=
X-Google-Smtp-Source: AGHT+IGHRLIyxOEOlqNogao+wtJt3d7D+zZNTRSCijTepfZz1QuZZsrU81NGe3dzgdfi+rQuqyfdUQCuPic=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4211:0:b0:d7e:c4af:22d2 with SMTP id
 p17-20020a254211000000b00d7ec4af22d2mr293199yba.4.1693958192804; Tue, 05 Sep
 2023 16:56:32 -0700 (PDT)
Date: Tue, 5 Sep 2023 16:56:31 -0700
In-Reply-To: <20230901082025.20548-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230901082025.20548-2-vbabka@suse.cz>
Message-ID: <ZPfAL0D95AwXD9tg@google.com>
Subject: Re: [PATCH gmem FIXUP] mm, compaction: make testing
 mapping_unmovable() safe
From: Sean Christopherson <seanjc@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: ackerleytng@google.com, akpm@linux-foundation.org, anup@brainfault.org, 
	aou@eecs.berkeley.edu, chao.p.peng@linux.intel.com, chenhuacai@kernel.org, 
	david@redhat.com, isaku.yamahata@gmail.com, jarkko@kernel.org, 
	jmorris@namei.org, kirill.shutemov@linux.intel.com, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	liam.merwick@oracle.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-security-module@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, mail@maciej.szmigiero.name, maz@kernel.org, 
	michael.roth@amd.com, mpe@ellerman.id.au, oliver.upton@linux.dev, 
	palmer@dabbelt.com, paul.walmsley@sifive.com, paul@paul-moore.com, 
	pbonzini@redhat.com, qperret@google.com, serge@hallyn.com, tabba@google.com, 
	vannapurve@google.com, wei.w.wang@intel.com, willy@infradead.org, 
	yu.c.zhang@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 01, 2023, Vlastimil Babka wrote:
> As Kirill pointed out, mapping can be removed under us due to
> truncation. Test it under folio lock as already done for the async
> compaction / dirty folio case. To prevent locking every folio with
> mapping to do the test, do it only for unevictable folios, as we can
> expect the unmovable mapping folios are also unevictable - it is the
> case for guest memfd folios.

Rather than expect/assume that unmovable mappings are always unevictable, how about
requiring that?  E.g. either through a VM_WARN_ON in mapping_set_unmovable(), or by
simply having that helper forcefully set AS_UNEVICTABLE as well.
