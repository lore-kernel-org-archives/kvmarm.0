Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B4C7475
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 22:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670885434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SyXP7MS8bTF3RbvPik+WjzHwHuSSdP6S+AJrUdi5oEE=;
	b=J18LPgwNBiW1SMeSUrCZEdWKTjkBiaoWbx02W4Q104gaku8xXiM1xHtTOKeDvmtBAs4nvk
	gCzB67quGzeIdysB1b1xifOrz4VzmMUOlQfxrxr2zNQbLIjuBR34tVp7FKNo4sVSTQDOre
	hY7YHqVGcHItW1qmiBbNh2S/wPntzB0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-141-CUUY2qfjOAGgNWXOsOAzHg-1; Mon, 12 Dec 2022 17:50:33 -0500
X-MC-Unique: CUUY2qfjOAGgNWXOsOAzHg-1
Received: by mail-wm1-f70.google.com with SMTP id r67-20020a1c4446000000b003d09b0fbf54so4748436wma.3
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 14:50:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SyXP7MS8bTF3RbvPik+WjzHwHuSSdP6S+AJrUdi5oEE=;
        b=1zxpwrpTr+yxOH+eCt01SARV1hA9CRa0mEW2T5hQ/NDUzqAgatk4DMmsvDF2wrqHAA
         GEp8Naq3lRSwNN86TkXi1urGySauGlMHphPr7TUZZKCkRHX5NJd522rpGbcwlnE2VmXl
         JyOegHHi57vJvP8ZX/WD8qzQ1FZE0rCv1sVUKJkwuQKH28SRfImadeFtF9IN4zXGXMKa
         bzAI8LRiJ198EZeiqKDF77gd0sfRRuFciVxxCGPpQ3QEx5loDIjV4cc+/g5EodzJ588l
         g1c0XTVJTOJ6QjD5PE95y0Uxo5RMsQkgt9eSXzYyNKyk/GKULFf3d4R9yBK5zo8ni2K7
         Mhjw==
X-Gm-Message-State: ANoB5pkTnw0mHxs2ZjTr3lNCI3B1Ux/Aoayn2eNlVho5J+7O2EhL5vgo
	IvAma5pyFPxZ1igjWLAIYA/VX1KT3jg3wqP9Ht//IUvivo57cEtsI5LE7gewqVY0r34p0FLRXcp
	xFsAet7V/4ZlK8BhH
X-Received: by 2002:a05:600c:4147:b0:3d2:2904:dfe9 with SMTP id h7-20020a05600c414700b003d22904dfe9mr2900898wmm.21.1670885432385;
        Mon, 12 Dec 2022 14:50:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6IZI0JQ674vEsdHgG0GiqLautfRb0p9b68d9OO4rhlD9rOnbnd3mXqInAe/GEdBqLbG8sv0g==
X-Received: by 2002:a05:600c:4147:b0:3d2:2904:dfe9 with SMTP id h7-20020a05600c414700b003d22904dfe9mr2900870wmm.21.1670885432160;
        Mon, 12 Dec 2022 14:50:32 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id n9-20020a05600c3b8900b003b4ff30e566sm199780wms.3.2022.12.12.14.50.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:50:31 -0800 (PST)
Message-ID: <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
Date: Mon, 12 Dec 2022 23:50:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
 "Yang, Weijiang" <weijiang.yang@intel.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, "Amit, Nadav"
 <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>,
 Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
 Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>,
 Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
In-Reply-To: <Y5dnWgJ0ine55/hN@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221212225029.jAnpbF7Kgvz3EpaMJxuigokPlugtXI4y1luy_Q2okA8@z>

On 12/12/22 18:39, Sean Christopherson wrote:
>> The notion of address spaces is already existing architecture-neutral
>> concept in KVM (e.g. see uses of KVM_ADDRESS_SPACE_NUM in
>> virt/kvm/kvm_main.c), although SMM is the only use-case I'm aware of.
> 
> Yes, SMM is currently the only use-case.

It's possible that in the future Hyper-V VTLs will also have per-level 
protections.  It wouldn't use as_id, but it would likely be recorded in 
the upper byte of the role.

I'm not sure if Microsoft intends to port those to ARM as well.

> My preference would be to leave .smm in x86's page role

What about defining a byte of arch_role and a macro to build it?


> Unless I'm missing something, e.g. a need to map GPAs differently for
> SMM vs. non-SMM, SMM could have been implemented with a simple flag
> in a memslot to mark the memslot as SMM-only.

Unfortunately not, because there can be another region (for example 
video RAM at 0A0000h) underneath SMRAM.

In fact, KVM_MEM_X86_SMRAM was the first idea.  It was uglier than 
multiple address spaces 
(https://lore.kernel.org/lkml/1431084034-8425-1-git-send-email-pbonzini@redhat.com). 
  In retrospect there were probably ways to mix the best of the two 
designs, but it wasn't generic enough.

> And separate address spaces become truly nasty if the CPU can access multiple
> protected regions, e.g. if the CPU can access type X and type Y at the same time,
> then there would need to be memslots for "regular", X, Y, and X+Y.

Without a usecase that's hard to say.  It's just as possible that there 
would be a natural hierarchy of levels.

Paolo

