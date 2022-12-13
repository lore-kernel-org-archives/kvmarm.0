Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 277BCC00145
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 01:11:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B72C4B8FD;
	Mon, 12 Dec 2022 20:11:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WbKt7Xz7Jlkb; Mon, 12 Dec 2022 20:11:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 386CF4B925;
	Mon, 12 Dec 2022 20:11:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 489984B8FE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:11:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kHXTVdBG3kkD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 20:11:09 -0500 (EST)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A4CB4B8FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:11:09 -0500 (EST)
Received: by mail-pj1-f45.google.com with SMTP id
 b13-20020a17090a5a0d00b0021906102d05so1865124pjd.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=hinRxz3gZAj3ZK/aMCsc0q1wjnPrltO2NY/c3Ugkfq0=;
 b=BNMWSdc+G8UMrGiE9cfwTCPOtvSd4SGR5xx9j3KogRRggicjQJNSWnM6KzvI+ruZLT
 Z5/+c4GRAmzfjVgnsKmZRqnzwxy3jUi/VmUYCAee+psZ2RDnJgcc1z+MUbcUtpmBqhIZ
 n2Xll8zjiyxpmJ3nyLDrFyGmzI72Dw1KgllTInw6mNRJPlPPq+xSIjWfB9YG8CN/8PRG
 r3MG2HeXYjSqtpUEiCGlGf9/Jk4XWxaXIBwinsPc1K0QooX+vTYegu4v2wV32ww/FxE5
 7U3ovhcjmqh4WLC5088r7J3ACzaSHYWslRMcTvYMNLnN6V4ac7AvMNHAI+noZZdCx3Mm
 2p7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=hinRxz3gZAj3ZK/aMCsc0q1wjnPrltO2NY/c3Ugkfq0=;
 b=ZcObsth+lxn2ZzIvtvnKIYTK+c9ItzwfPENyAMmai2DqU2VmdCvpGk9faZeE94v4vK
 bpFLtq5MK3/35H10rrviWUKY6+YZsQuTIpaukHRuDPVSowfLSfmUiEcFsuLXMcbS0qoc
 mSDfAvmp6Csesb7D+/H6Y3UXLMAaTYpSoIq2MD+4Uj9CLhw28T7TWd8mO04c+QgvLrHV
 XP+dCzcmi9ZOCwuB4o7PYCllYX/y67zTApPiAEHP5WsH1qvmvkkLWfUjy7AepBAiEU1S
 Ye13jRic0LyRwgHQI0dk4QWJ+Uv+nE3jlw/NwRks6hFGp8Z0Z9wN+T/H4kNlCtPUYhTQ
 ltPw==
X-Gm-Message-State: ANoB5pk1ZOCJGyN8cTKjh8nUqLHB7WEDoHp/Djyxnuu3MW8oawAStDlh
 I0TggZsZQLxsAX7cCez+mqTLPQ==
X-Google-Smtp-Source: AA0mqf4K7zeWWztu3csfWQBbFCCVxqGsIhKZt6mbUg55HAzsJAXNVoEUxec6VV36cFbnYl7q+RITOA==
X-Received: by 2002:a17:902:7001:b0:189:a208:d130 with SMTP id
 y1-20020a170902700100b00189a208d130mr18915329plk.31.1670893867860; 
 Mon, 12 Dec 2022 17:11:07 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com.
 [34.125.103.223]) by smtp.gmail.com with ESMTPSA id
 l11-20020a170903120b00b0017f72a430adsm7043661plh.71.2022.12.12.17.11.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 17:11:07 -0800 (PST)
Date: Mon, 12 Dec 2022 17:11:02 -0800
From: David Matlack <dmatlack@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
Message-ID: <Y5fRJr34/BnsE+Dv@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com> <Y5dwQEJHNiTPE+jz@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5dwQEJHNiTPE+jz@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Yang, Weijiang" <weijiang.yang@intel.com>, "Amit, Nadav" <namit@vmware.com>,
 Ben Gardon <bgardon@google.com>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Yu Zhao <yuzhao@google.com>, Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Atish Patra <atishp@atishpatra.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 Colin Cross <ccross@google.com>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Dec 12, 2022 at 06:17:36PM +0000, Oliver Upton wrote:
> On Mon, Dec 12, 2022 at 05:39:38PM +0000, Sean Christopherson wrote:
> > On Fri, Dec 09, 2022, David Matlack wrote:
> > > On Fri, Dec 9, 2022 at 9:25 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> > My preference would be to leave .smm in x86's page role.  IMO, defining multiple
> > address spaces to support SMM emulation was a mistake that should be contained to
> > SMM, i.e. should never be used for any other feature.  And with CONFIG_KVM_SMM,
> > even x86 can opt out.
> 
> +1
> 
> I don't think something is architecture-neutral by virtue of it existing
> in virt/kvm/*.

Put another way, just because something exists in virt/kvm/* doesn't
mean it is used (or will be useful) to more than one architecture.
Totally agree.  In this case, there never turned out to be any other
usecases for memslot address spaces.

As for role.arch.smm vs role.as_id, I'll post my response on the other
thread with Paolo. Juggling these threads is hard.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
