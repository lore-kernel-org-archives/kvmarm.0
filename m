Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19352A93E
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674149045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ZLCun6ndTUYHIhway+dCjRST8plu+DLSlmudJ+9iGA=;
	b=CehysE+TUacqwSdjT82SO7EuPi9Xnh72N3GAGX2k/RNneWP02MHvdGKgi5uXk6qnIvapol
	aIUa2hYdrCIPZPsmYMspX6gJr6cM4LOB8+wUIBdBiGyFeylOs0AelfTEEjd44GSA6i9QaW
	feAMvzDuLRTjMlesbCl7mgDrUSmAN+c=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-377-rhyelC-QMCGal3sM4viNOQ-1; Thu, 19 Jan 2023 12:24:02 -0500
X-MC-Unique: rhyelC-QMCGal3sM4viNOQ-1
Received: by mail-ua1-f72.google.com with SMTP id y10-20020ab0560a000000b003af33bfa8c4so736547uaa.21
        for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 09:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZLCun6ndTUYHIhway+dCjRST8plu+DLSlmudJ+9iGA=;
        b=vvQAbvKsfvDRa7tuYgXgW8zfIxqUmpx2OsJXR2t0WTcvr5JyF5txmvsCWSwsqM3FsZ
         b+R1z90fIKVEjoxPG8rIDfK78yLl2s6XN272TL/8rWGjFgD5pdCnMOk4gkQp3+DAsDCO
         tGBfmRfZlwl5PGca/uG1f/sPMIHOxSLV4QxtpudGZvgCJ5XvyAYeDAmAcGI8wP7vQLG+
         5n5mIycHCao7rIP9mVNyFyJ57ztGkIBkefVmh+3TQqWmtJ0TO5Z842ghGr3y/s6AHyXE
         izq+iLjkwFM3mjRBETM9mZdTWvuti7lDYJn7lFKYHLyOBBECaDFh2UcQbZQDAlMy96K4
         yegg==
X-Gm-Message-State: AFqh2koryd7U8FyXfKCCGW1wpump/jTrS4+Q91UN34IW0QJc4EgzsMsZ
	Bpa9MaeL/951kTQlbHjuFOjnXcQ9JtBnxZbJggg97XrM+ePR56+5Ka1OyLRqC0nm/Ud5SkbTvDj
	m1sCeFCOpJQDomLjg5Gn89qCg5lgK0LDR
X-Received: by 2002:a05:6102:3d14:b0:3b5:2762:568b with SMTP id i20-20020a0561023d1400b003b52762568bmr1578192vsv.62.1674149041479;
        Thu, 19 Jan 2023 09:24:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtKcbEgINpJzFLAqIx7zgVheHf3U2vYRZ/ijgft8zgf2upp0swiwUYbMZZIryC08LRzFEnE4XMqgG5fhaMKrn4=
X-Received: by 2002:a05:6102:3d14:b0:3b5:2762:568b with SMTP id
 i20-20020a0561023d1400b003b52762568bmr1578157vsv.62.1674149041226; Thu, 19
 Jan 2023 09:24:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <Y8l6egh2wWN7BUlZ@google.com>
In-Reply-To: <Y8l6egh2wWN7BUlZ@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 19 Jan 2023 18:23:49 +0100
Message-ID: <CABgObfaTEZ1_SaQ9ThbeMe8gX2y35ZGTFzgb9K9yZwz8dbOYdQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common code
To: David Matlack <dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
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
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Raghavendra Rao Ananta <rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 19, 2023 at 6:14 PM David Matlack <dmatlack@google.com> wrote:
> Paolo and Sean, what are your thoughts on merging the Common MMU
> refactor without RISC-V support?

I have no objection. We know what the long-term plan is, and it's not
so long-term anyway.

Paolo

