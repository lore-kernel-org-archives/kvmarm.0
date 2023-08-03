Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8DC1F934
	for <kvmarm@lists.linux.dev>; Thu,  3 Aug 2023 19:15:58 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-564656d952aso873081a12.3
        for <kvmarm@lists.linux.dev>; Thu, 03 Aug 2023 12:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691090157; x=1691694957;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1QAbc+4fCOMN1wq3LOwJ4k1bsXl9R1Q+x4bhgj3rFIg=;
        b=DSNF3uKlxbN1/j9sGPdV4RLbiLmTPzUp9Zu3X+X+jI/CXp8qoKO4kiLFxh0eWH4ras
         3UHMbP1YaoUXHaU6RKc0xiD6OqP0/G8GaXsxhmkMXaXcobPCXbuINlBumVapPQ9eL9WI
         SQMF6MIyr2Twu3rQpgN63Ty4xEmvWMdFcq1qk0s/bO53R4WtT4D6mxqEq84CrHbE24tW
         R+R0wb7QBQEWXSd0EQn3phD4GyYVVYig+DH6wM230PxAw/bTqhOS8nPt+LaY5XqmbBEo
         2lNVu9E2Fm9D/OSL8FvXxR34+QmBLtfkxeWiU2TVRkIK5+koZ6XE0PUmvWk9wsqvFkyB
         PpQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691090157; x=1691694957;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1QAbc+4fCOMN1wq3LOwJ4k1bsXl9R1Q+x4bhgj3rFIg=;
        b=BKxmEoSH1TdJvGYezJTfik8P9yYEfHlzU085lLqor5KwP3oQZUXfXays8a8VV59DQC
         k+n/fmRSbo3juSFmJvFzb4rYlN7iw6E//idYKE0oZ+HDoekDYFes2sM16YApmmGupuct
         27gR/IktNNdgdh3iJwn6JRPGYMGzTO9/LoZm3O9U7y5t/MAqK6qrixTnt1V+bVuphukM
         b1WOZFmUgQnqnNf9eUlirrAcEoLToY7J9m82aGp5kRP0bPEBgX3irLo4WJoJh8CoHqou
         Y39Xq66neC9/snUzLTPFA97dvwp9XIsGnJPscqUkd4AVfWhbc0uRhnzbzFTlAr39oZoL
         StqA==
X-Gm-Message-State: ABy/qLa8lCpz91Q4ZwGQEv4Z6/NgvKiw0AFP0Khai2uC0R9bqxJwU9fO
	jpSuqLSw0fqnvmxAOoQKPE8r0cfC8G4g
X-Google-Smtp-Source: APBJJlHtGvcJEMYqDDCqDrlA6FqIV7ZBvnc2RG3ctaXexB6pNXaY+PGUAOnc1N44cMVGOG5WgF6ZzIYHZzSS
X-Received: from afranji.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:47f1])
 (user=afranji job=sendgmr) by 2002:a63:295a:0:b0:563:5065:9d40 with SMTP id
 bu26-20020a63295a000000b0056350659d40mr129290pgb.5.1691090157410; Thu, 03 Aug
 2023 12:15:57 -0700 (PDT)
Date: Thu,  3 Aug 2023 19:15:54 +0000
In-Reply-To: <20230718234512.1690985-13-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-13-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230803191554.205599-1-afranji@google.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Ryan Afranji <afranji@google.com>
To: seanjc@google.com
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
	vannapurve@google.com, vbabka@suse.cz, wei.w.wang@intel.com, 
	willy@infradead.org, yu.c.zhang@linux.intel.com
Content-Type: text/plain; charset="UTF-8"

> +static struct folio *kvm_gmem_get_folio(struct file *file, pgoff_t index)
> +{
> +	struct folio *folio;
> +
> +	/* TODO: Support huge pages. */
> +	folio = filemap_grab_folio(file->f_mapping, index);
> +	if (!folio)
> +		return NULL;

In Linux 6.4, filemap_grab_folio() may also return an error value.
Instead of just checking for NULL, "IS_ERR_OR_NULL(folio)" will be needed.
