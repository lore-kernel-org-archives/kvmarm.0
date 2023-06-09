Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAD0BE4B
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 09:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686301567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eyj9qAaMTXhV0BDBMXgw3bkhoC43Djt8OMEq06UECOo=;
	b=EpEzYbuFJzJ16t3cdUerq6nBDlvoivWJ3MML+Iyfnbd9IV1J+lbRAWAGTC/WE/nnuDkpl6
	tmgga0QiW/vgwKCuBiGxXIdelZsc6ZbDhUQFR4otrSRuKhUIV059Ykvp0/WPBjZhMP/X8X
	lxRNrnwMOi2/nlWxG1ZLVtp2G0u1jZM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-kHopoNLrMHGAB6QeZp3aWg-1; Fri, 09 Jun 2023 05:06:06 -0400
X-MC-Unique: kHopoNLrMHGAB6QeZp3aWg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-51566dc6066so1498204a12.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 02:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686301565; x=1688893565;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eyj9qAaMTXhV0BDBMXgw3bkhoC43Djt8OMEq06UECOo=;
        b=ciE1+BtFieZ2PljZFkMRuiCJdQThQDzkYJozQF1dpuxYd3MBSOzl7Rqfu3vE9pwJdQ
         L362FXP893pKcJ8f6J1GTJVMvK2khDKDSwepPCfjhKEsEKc2beWfnn5TIymlhtzyOOGU
         AzlE07oDt5iVnj0yt7lhr+xQty/jKQx5BIh2IXytUhr/ZXP62x38n7xBLpxQK5Rm4Qbz
         isiNu+x8j2Sk+w/F+WjkQ5St0Pu4KXJ1nS/i4NeoN2UVy/D8sE5EuhE7xR3cFVbMrv+M
         +c43KTOpstJKuigFPL9NyylxGtz1c1Jg18ieqlAstqDSnyqwMRnK/CeR4iHcWSovw6UV
         i6Dw==
X-Gm-Message-State: AC+VfDzJECpMt6UEoX/a66Y64qH8etJIEMuPCP5uFZTpJx0KR/VPV6OD
	PksxKLw7wkIF6TWWx48uVr40+wFC+0hI0Y8a5oK8O0JOE/AsdvNLHPVxkNirQyt4M512Cq0TDYS
	uWD3ZvrkyrZ2HSFdb
X-Received: by 2002:a05:6402:643:b0:510:82b4:844d with SMTP id u3-20020a056402064300b0051082b4844dmr902489edx.2.1686301565421;
        Fri, 09 Jun 2023 02:06:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Eo2fL8sg8ZAFF9ExDb1hoz+RWsXilNiiceAqQ1jh6YF+h+q2Lb+V5P8mQdJn5E/+DPP6p2g==
X-Received: by 2002:a05:6402:643:b0:510:82b4:844d with SMTP id u3-20020a056402064300b0051082b4844dmr902445edx.2.1686301565157;
        Fri, 09 Jun 2023 02:06:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id f9-20020a056402068900b0051495ce23absm1517006edy.10.2023.06.09.02.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 02:06:04 -0700 (PDT)
Message-ID: <f0fc6e43-ffe3-dc38-03c1-77b2105cd0fb@redhat.com>
Date: Fri, 9 Jun 2023 11:06:02 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH mm-unstable v2 09/10] kvm/x86: add
 kvm_arch_test_clear_young()
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
 <20230526234435.662652-10-yuzhao@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230526234435.662652-10-yuzhao@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/23 01:44, Yu Zhao wrote:
> +#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
> +static inline bool kvm_arch_has_test_clear_young(void)
> +{
> +	return IS_ENABLED(CONFIG_X86_64) &&
> +	       (!IS_REACHABLE(CONFIG_KVM) || (tdp_mmu_enabled && shadow_accessed_mask));
> +}

I don't think you need IS_REACHABLE(CONFIG_KVM) here, it would be a bug 
if this is called from outside KVM code.

Maybe make it a BUILD_BUG_ON?

Paolo

