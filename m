Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4658163
	for <kvmarm@lists.linux.dev>; Sat,  9 Sep 2023 00:15:50 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59285f1e267so68622457b3.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 17:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694218549; x=1694823349; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gaKhly8Aj9nDlRectFKYGw3FxO6EGE4C2aH6vsrGIcs=;
        b=mmWzKt2McVAxJZQeyTopavuAzTGoioLQLJG3WVyZwqJkhOSM8zjUUorArmjSX9K9Sh
         1bB8iF4o/ZBeOUGzoxHk0eyVT0wHaU7tYFRpTMw1zfM60SRX/o8Ka1mTY46wM7NybRJu
         wplepfndp7uDwK0do0DGVyKrF+D0VJHsVqttWSRGjC+SvAf7vg4y9SwZVi50pu7ILZGf
         UNCB4m+JhlABnAn3iU8Hvw9Ql+GwUJoCoywS+QCWfSInuaPxMohglSsknnj4H4827z9G
         awnH+Yg4hYmeHsUE8TdFizom25RCzE7hRYq4QZSuCRmjVoFbZ589K9NGkuNVCUYBYNIC
         wjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694218549; x=1694823349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gaKhly8Aj9nDlRectFKYGw3FxO6EGE4C2aH6vsrGIcs=;
        b=mqEqfmZ8HZxt3KMQNeEAQANjY097WqjyASTht+33FSLXGxPAUm0mo0dy02d2DOtZUI
         1bsB+F6A3P8KlnmY7NMsIQ+yvoZPWrdexQ7/Td66eLshpgtOK058JEr0kMqGSQQgMx+B
         AusLnt8APc7MTCNiGzRPAhQV62joyhEqs0+LHjl5q9zjBFpJ2qjiqH6TcNzejyPdbZUm
         uSnHhg/9opySDP0ZBjJ/xNSnn/RUcYA/+qNIMhKmBfRFhFpVGMEE6yqqOy6e718TQMu5
         Zq0ErRyd7smtvG4Q0E4fi0n4HAwsG/kyw/IqDea2RZrNg8Ix9do4VJt40MzcGoouthBC
         qxsw==
X-Gm-Message-State: AOJu0YyJzwwvXIO3RTBaZfPoK7+y6Q8Dvp4ghZOn5sp2X1a6jqgoJZ0d
	9hxyMv9bMaIHPIZkeA+yQJNwOAQU6sI=
X-Google-Smtp-Source: AGHT+IF1C60bg2DJN40Ko3jIsOcOxP0NOjMSP0DFTt+pfC3PQMs+2qr1EtNSX5EQJ2FP9+vXkLa3AHa75+U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9848:0:b0:59b:5a5b:3a91 with SMTP id
 p69-20020a819848000000b0059b5a5b3a91mr89060ywg.2.1694218549752; Fri, 08 Sep
 2023 17:15:49 -0700 (PDT)
Date: Fri,  8 Sep 2023 17:15:33 -0700
In-Reply-To: <20230908074222.28723-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908074222.28723-2-vbabka@suse.cz>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <169421599820.98577.9267896589643015779.b4-ty@google.com>
Subject: Re: [PATCH gmem FIXUP v2] mm, compaction: make testing
 mapping_unmovable() safe
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Vlastimil Babka <vbabka@suse.cz>
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
Content-Type: text/plain; charset="utf-8"

On Fri, 08 Sep 2023 09:42:23 +0200, Vlastimil Babka wrote:
> As Kirill pointed out, mapping can be removed under us due to
> truncation. Test it under folio lock as already done for the async
> compaction / dirty folio case. To prevent locking every folio with
> mapping to do the test, do it only for unevictable folios, as we can
> expect the unmovable mapping folios are also unevictable. To enforce
> that expecation, make mapping_set_unmovable() also set AS_UNEVICTABLE.
> 
> [...]

Applied to kvm-x86 guest_memfd, thanks!

[1/1] mm, compaction: make testing mapping_unmovable() safe
      https://github.com/kvm-x86/linux/commit/4876a35647b9

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
