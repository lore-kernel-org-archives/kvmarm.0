Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123EE63D2
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 17:57:42 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-3e78d07ab4fso62052597b3.9
        for <kvmarm@lists.linux.dev>; Fri, 09 Dec 2022 09:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bMZ9vaUyXosUBjlo9WUDdUBep5JMYYDWXkYuJRTyBRc=;
        b=PNNz0qgco2CC6vK8iX8A8CdQ9XYG/eiYEJI0PFBFwEDrAJkafbZh+wNNez+eyMKsNW
         dyYIVM2JUEXFIo3AsWaRZNjWiZwyFaVdNR0pQpuSKF0S76DLKWQFl1oZGEBDU5afM86c
         4MHyLC00G+IV14UOCOsjUR6HTn+tapMh3yj6v/QPIYSR6ep3HNH6Adic+iJisjvPkwA/
         hLPuSxDfDTXFbxYKTocYksmV9tgslNTPcnfgAPbkxh/jMNo9/8AxKFzwYVG9ZAJJI+XR
         ZLWDlt7dnT+fbIaDz/1md454IG3J2J19ANvQ4CvzY4M0DlboF2jrnlXjyCT1tHR69aMt
         lUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bMZ9vaUyXosUBjlo9WUDdUBep5JMYYDWXkYuJRTyBRc=;
        b=vwBbED56lsgzyYj89OQ9JNNHmhGQ/5EGzAdmklJVVrnn0ByCJh/yqVPWzttIZ11TC5
         qeR0lbr7D7Jk+2/Pd0HEw5bdSGN1oVtNtmaLqg/ObaqVT7yoqZGmE+mHWJ6dbtR+eiPa
         gV+vAK5Mi7TQYdFfWObj+peRv1mGu7N2KjCjrb4jhEgFV0Xvv5dcK+T8XoMPQq4ug8pG
         m/QxPNKDyeYbpf7CpbK9yrwLqA/v9c1t1+NCLgksYJ9jtsorxJzHIsccDNYwP4qKHGuR
         3r5KRAyott8Jll5vdnFyaBoUm2cU0yiO61qHnweF3A6ci2LbKx+T8m2Q/ZHLBqGqjbFb
         a4nw==
X-Gm-Message-State: ANoB5pk0QILh2wu/urL4Buaq0vsle3D1hEmpl8FNQkjHRPgPBWvo/ShL
	IttZhNdB4qSs4eUGr8T4Nnc9OcEtxsPnDP2QT1a5Dg==
X-Google-Smtp-Source: AA0mqf7ZLFzH7tn8G3mgBGvDrhVn7KNrvvpffIzBOW371A0vYuDJaiDqvxR+ZPRcFAJZ2LX4aVuYJ3WS6sGEmfbkAcg=
X-Received: by 2002:a81:148d:0:b0:36a:75b3:fdda with SMTP id
 135-20020a81148d000000b0036a75b3fddamr7388556ywu.168.1670608661842; Fri, 09
 Dec 2022 09:57:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-24-dmatlack@google.com>
 <Y5NxCYz9XV3hgGYX@google.com>
In-Reply-To: <Y5NxCYz9XV3hgGYX@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 9 Dec 2022 09:57:15 -0800
Message-ID: <CALzav=f-qDqJcvPEo1ZxxVizAE77crMFsbKUVif5B-mNgGEHyQ@mail.gmail.com>
Subject: Re: [RFC PATCH 23/37] KVM: MMU: Move VM-level TDP MMU state to struct kvm
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit <namit@vmware.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221209175715.qWKR1FFpgpA-kZqQZZxd_fcVwyfhF9ogxjUiySGRpDc@z>

On Fri, Dec 9, 2022 at 9:32 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hey David,
>
> On Thu, Dec 08, 2022 at 11:38:43AM -0800, David Matlack wrote:
> > Move VM-level TDP MMU state to struct kvm so it can be accessed by
> > common code in a future commit.
> >
> > No functional change intended.
>
> Could you instead introduce a structure to hold all of the MMU state and
> stick that in struct kvm? If the goal is to eventually supersede all
> uses of the arm64 pgtable library we are going to need the ability to
> operate outside of a KVM VM context.

This patch does introduce a tdp_mmu struct to hold all of the TDP MMU
state. Did you have something else in mind?
