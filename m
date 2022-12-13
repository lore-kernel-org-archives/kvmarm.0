Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07266C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 01:18:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79A034B8E3;
	Mon, 12 Dec 2022 20:18:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WHV7n7JCH7Vo; Mon, 12 Dec 2022 20:18:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 449DD4B91F;
	Mon, 12 Dec 2022 20:18:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6EC54B922
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:18:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ipmn-YIx7VWQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 20:18:41 -0500 (EST)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A6974B8E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:18:41 -0500 (EST)
Received: by mail-pj1-f44.google.com with SMTP id
 z8-20020a17090abd8800b00219ed30ce47so1839780pjr.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=65IDnHecXM4GAPku5HHW6zoqaWMBpSe6UVEVil1rUW8=;
 b=aCbTEC5zVQHMxXGUQTyU3DWgykcdtGQYX+TMVnYfhhivfYDwUdEI2A+rvhEs/NwsaF
 DBS7EUg/X3QUOeZSsBrnvtkOTybUx0UgHQfTJ3hA35ipZDaXqrdLdH18As7YVMN94+FU
 E0ZAjnBtiWq0DWCLJTMY1LLhx6oaO6nTa/LCKJnCfj9cvh92FEO+h9Fh1uCxf/eAl6iw
 7hyDu3aUhJ3UKrfyvsiyjGIexzmF9DmyPzjASetqH/jMJK8TS5INlchOlJfnBagkkznK
 3XYQb4be1caEftz1e2fA0GEffMBeGMtYKiW3GQDIe6ihjILD9JWzVjZUmCWBKLdW3ozR
 bQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=65IDnHecXM4GAPku5HHW6zoqaWMBpSe6UVEVil1rUW8=;
 b=pV4t1mfHK4nX5/d+lXUePrDhnG4dF51hRpP10Hq6u7qOIu6wXRYOcOnoE7ZGsx5iTg
 aZmRdgssE9bpSHrkkFe7gxQj6lRijasMSKWx8vmu/vhqUNSKYNZUjkMGaSJX95ztw5iz
 Qcl8vYYrMouKeo/g09vjvO1p5gsZ0xWwoHoDbkpbPpmdvalThwDpDOavG4NnpMsVUbCQ
 GR7W4vD1csvMv0bgFxj5zR/BrBqtaEX8QEVT+0tWiGiIwBwJeLq9eZIOHOJ/x/7lvy5w
 p0Kwu68C34bvwtq0jAJSc/Q36MbyorK1+A5xkTV7iYrz7xvGokW4xXiHNrVfV0CGkaL7
 qsCQ==
X-Gm-Message-State: ANoB5pnJ7NOtzx/HcAsIfg4SUoBuDOk36quUeM8qKw9s7N8UEePscoua
 Ve/wKmpP1TQKeiUobHgDWG2dpQ==
X-Google-Smtp-Source: AA0mqf5INLD3H26KoHZlGz+PIVih+odmnj70wLNIiESaeaUKfnuuF7xa7n6FGQnW8NJxdar9YAD0/g==
X-Received: by 2002:a05:6a20:2d21:b0:a4:9691:6e9 with SMTP id
 g33-20020a056a202d2100b000a4969106e9mr23637142pzl.1.1670894320396; 
 Mon, 12 Dec 2022 17:18:40 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com.
 [34.125.103.223]) by smtp.gmail.com with ESMTPSA id
 r14-20020a63a54e000000b00460ea630c1bsm5762650pgu.46.2022.12.12.17.18.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 17:18:40 -0800 (PST)
Date: Mon, 12 Dec 2022 17:18:35 -0800
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
Message-ID: <Y5fS69mLXlV+cQlg@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com>
 <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Yang, Weijiang" <weijiang.yang@intel.com>, "Amit, Nadav" <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
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
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
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

On Mon, Dec 12, 2022 at 11:50:29PM +0100, Paolo Bonzini wrote:
> On 12/12/22 18:39, Sean Christopherson wrote:
> > > The notion of address spaces is already existing architecture-neutral
> > > concept in KVM (e.g. see uses of KVM_ADDRESS_SPACE_NUM in
> > > virt/kvm/kvm_main.c), although SMM is the only use-case I'm aware of.
> > 
> > Yes, SMM is currently the only use-case.
> 
> It's possible that in the future Hyper-V VTLs will also have per-level
> protections.  It wouldn't use as_id, but it would likely be recorded in the
> upper byte of the role.
> 
> I'm not sure if Microsoft intends to port those to ARM as well.
> 
> > My preference would be to leave .smm in x86's page role
> 
> What about defining a byte of arch_role and a macro to build it?

Both would work. I went with as_id in the common role since that's how
it's encoded in kvm_memory_slot and because, not matter what, the TDP
MMU still has to handle multiple address spaces. i.e. Even if we hide
SMM away in the role, the TDP MMU still has to access it with some
wrapper e.g.  kvm_mmu_page_as_id() (that would just return 0 outside of
x86). From that perspective, just having as_id directly in the common
role seemed like the cleanest option.

The only way to truly shield the TDP MMU from SMM would be to disallow
it. e.g. Disable the TDP MMU if defined(CONFIG_KVM_SMM), or something
similar. But I don't know enough about how KVM SMM support is used to
say if that's even worth entertaining.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
