Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23418BE53
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 09:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686301690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+lS4qtD2LImPdpu4Ozd1FIICWXob78VQWCuBmNpNqeU=;
	b=iMpy6h9MGhybAsGZPh0/hEsnC8MrGq+DU1A23pFDVfnL4yPv5Xh/0FRsPPNI8sQCbm3VIZ
	Zi2/QueZQI56iusjrOZw8Jj4FQITVd9r97NdKVMrrXXYxAKTpZabAyDO6w5hMHeo6lywsH
	TWtxRSzz1BEmOWDM0CYLyR2YmhR2ZVU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258--jXK01O2MvibG0wCi3ecNA-1; Fri, 09 Jun 2023 05:08:02 -0400
X-MC-Unique: -jXK01O2MvibG0wCi3ecNA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94a348facbbso186016966b.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 02:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686301681; x=1688893681;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+lS4qtD2LImPdpu4Ozd1FIICWXob78VQWCuBmNpNqeU=;
        b=cyY0hUYMGAnPCh1sehLtYywg6T3EfDMQE7w+H/aI7VVKinTFRJN/P34yOUgmkrQg1I
         jAEu4t+PS4AVxK6vcGmiPJdYTVTZ/FG9cmnSkZDUvaAlj/j3Ph3krBSDIobc9dumhIYn
         gN5Y+29KNuQbX5qJys7ZQ6x6GhDzlztBb/th0GQfROmKjw+xdp6siw8T+21zdXVtHoyX
         cBanqLrQM4llZmq5gRC2SL4kVpTvfcJbHPU4H0eeOhExkS0t+3DBMfAocGReS+Vto+Ed
         Dq/uovjkIgvdH8F7W4vM1Tlmrhi2hHEbmcUSv1ycIDQFM42S5Bxg+svtnR0PMl5syhAw
         nU+g==
X-Gm-Message-State: AC+VfDyR80Bnzvo3Doact3GakdBT1E/lPItRmduDYRDVAXjUnjMSM8aA
	Ng5skeCzZtRtE/WiCHRwlQF4GThye39kL+uwso3ZbXASrt7LnrIDm/y7TNy1pJQDdDL//gXhfNu
	ab0gSOzcXLIf/BNcG
X-Received: by 2002:a17:907:94cb:b0:97a:e0c0:2f8f with SMTP id dn11-20020a17090794cb00b0097ae0c02f8fmr315226ejc.65.1686301681504;
        Fri, 09 Jun 2023 02:08:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6fk08I4RsyK9p9wcnjDRbMYLy3XBaoHlqt3xl1DLkFDODgHMHCV4XPzuR/CPTVwoW0y6Qefw==
X-Received: by 2002:a17:907:94cb:b0:97a:e0c0:2f8f with SMTP id dn11-20020a17090794cb00b0097ae0c02f8fmr315171ejc.65.1686301681128;
        Fri, 09 Jun 2023 02:08:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id z8-20020a1709067e4800b00977ecf6942bsm1036209ejr.90.2023.06.09.02.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 02:08:00 -0700 (PDT)
Message-ID: <26cf0b0a-cda5-08a9-a669-6966f9e626b1@redhat.com>
Date: Fri, 9 Jun 2023 11:07:55 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>, Anup Patel <anup@brainfault.org>,
 Ben Gardon <bgardon@google.com>, Borislav Petkov <bp@alien8.de>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, Gaosheng Cui
 <cuigaosheng1@huawei.com>, Gavin Shan <gshan@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 James Morse <james.morse@arm.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Michael Larabel <michael@michaellarabel.com>, Mike Rapoport
 <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, Paul Mackerras <paulus@ozlabs.org>,
 Peter Xu <peterx@redhat.com>, Sean Christopherson <seanjc@google.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>,
 Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
 x86@kernel.org, linux-mm@google.com
References: <20230526234435.662652-1-yuzhao@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH mm-unstable v2 00/10] mm/kvm: locklessly clear the
 accessed bit
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/23 01:44, Yu Zhao wrote:
> TLDR
> ====
> This patchset adds a fast path to clear the accessed bit without
> taking kvm->mmu_lock. It can significantly improve the performance of
> guests when the host is under heavy memory pressure.
> 
> ChromeOS has been using a similar approach [1] since mid 2021 and it
> was proven successful on tens of millions devices.
> 
> This v2 addressed previous requests [2] on refactoring code, removing
> inaccurate/redundant texts, etc.
> 
> [1]https://crrev.com/c/2987928
> [2]https://lore.kernel.org/r/20230217041230.2417228-1-yuzhao@google.com/

 From the KVM point of view the patches look good (though I wouldn't 
mind if Nicholas took a look at the ppc part).  Jason's comment on the 
MMU notifier side are promising as well.  Can you send v3 with Oliver's 
comments addressed?

Thanks,

Paolo

