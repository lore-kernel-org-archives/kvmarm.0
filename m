Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF33BA48
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 09:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686301475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLk6gSKtsM+p9Rtgq5+IZGVTEjc3fvT8GmlHeUGj3wU=;
	b=ehUwn+5fAisgAEtAIMl5EIJdeclqSq8CTML5XxKV3vnBdSoKWM2gHwMxwSDWO0iw5VXJLh
	8SS/MgxwDJJJA3Tt6AO+Slri6c8ud7wu7sku5IGptOdbBlKOktrAg+YkIdnNEDgtpKVACA
	bxrEekcdTsq3Acc+35VY7WKEzTLjEFM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-6DUrAw3_NhqHcHZ2XmDmMQ-1; Fri, 09 Jun 2023 05:04:34 -0400
X-MC-Unique: 6DUrAw3_NhqHcHZ2XmDmMQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9715654ab36so150684166b.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 02:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686301473; x=1688893473;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TLk6gSKtsM+p9Rtgq5+IZGVTEjc3fvT8GmlHeUGj3wU=;
        b=RjiDagNgKZtwZNirxuzZyzhHIU58LSTlutSxB/8fjHIaiYpGWleRCXoQDVC8Q2y+r+
         pREobBIHNUpjSCeb1GmhSMvEhQ15zsibeR0Y/ldAQrfdTuSChuIMFUtXqb5jnp26D63k
         XU0xAXEMT+SomJh+cGTl35KmptMXIBxIRJxs19lURf/O/vJRvfCY+uKpoloHjjZILREK
         fLFRoEhJcTbw/InkcFuIe+lsZl/Q62yAVE9vAGFAfdJlOYaFVdU+HiOgtuCYiC76kzv2
         09mgjY48mtJPpGB6j3Q6Bj+bSZAE1M3pe3Bm5Sp3EyokGXNHILMssS/6IsgZ7ldpb3ya
         E//A==
X-Gm-Message-State: AC+VfDywph1GgzwRK5aH/h9A5ENLBMbnrX+S0+EbsDSFiM7CdnM5WIl2
	4f4rMCE+4O9zEM3gzHYb2MlfBvVYUDl2cuYmI0+t9t9GTD99ceg/sNFwsvGniuCNOt94LysP8Zq
	sCedsfDPx+GrvH+Ts
X-Received: by 2002:a17:907:c15:b0:94e:1764:b09b with SMTP id ga21-20020a1709070c1500b0094e1764b09bmr1027436ejc.45.1686301472957;
        Fri, 09 Jun 2023 02:04:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4KrasOi5l6sCNShc9kV8qfG1eq+fRbvkSLL3UxeHKWwdsKczbSQdc/+63BzxHLxAbWxA2H7A==
X-Received: by 2002:a17:907:c15:b0:94e:1764:b09b with SMTP id ga21-20020a1709070c1500b0094e1764b09bmr1027414ejc.45.1686301472616;
        Fri, 09 Jun 2023 02:04:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v5-20020a170906858500b0096f72424e00sm1013932ejx.131.2023.06.09.02.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 02:04:32 -0700 (PDT)
Message-ID: <e948d02f-cd93-b6e2-72fd-123e483f66fe@redhat.com>
Date: Fri, 9 Jun 2023 11:04:29 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH mm-unstable v2 01/10] mm/kvm: add
 mmu_notifier_ops->test_clear_young()
To: Jason Gunthorpe <jgg@ziepe.ca>, Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, Anup Patel <anup@brainfault.org>,
 Ben Gardon <bgardon@google.com>, Borislav Petkov <bp@alien8.de>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, Gaosheng Cui
 <cuigaosheng1@huawei.com>, Gavin Shan <gshan@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 James Morse <james.morse@arm.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Michael Ellerman
 <mpe@ellerman.id.au>, Michael Larabel <michael@michaellarabel.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
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
 <20230526234435.662652-2-yuzhao@google.com> <ZHedMX470b7EMwbe@ziepe.ca>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZHedMX470b7EMwbe@ziepe.ca>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/31/23 21:17, Jason Gunthorpe wrote:
>> +	int (*test_clear_young)(struct mmu_notifier *mn, struct mm_struct *mm,
>> +				unsigned long start, unsigned long end,
>> +				bool clear, unsigned long *bitmap);
>> +
> Why leave clear_young behind? Just make a NULL bitmap mean
> clear_young?

It goes away in patch 2, together with:

@@ -437,7 +412,7 @@ static inline int mmu_notifier_clear_young(struct mm_struct *mm,
  					   unsigned long end)
  {
  	if (mm_has_notifiers(mm))
-		return __mmu_notifier_clear_young(mm, start, end);
+		return __mmu_notifier_test_clear_young(mm, start, end, true, NULL);
  	return 0;
  }
  
@@ -445,7 +420,7 @@ static inline int mmu_notifier_test_young(struct mm_struct *mm,
  					  unsigned long address)
  {
  	if (mm_has_notifiers(mm))
-		return __mmu_notifier_test_young(mm, address);
+		return __mmu_notifier_test_clear_young(mm, address, address + 1, false, NULL);
  	return 0;
  }
  

Paolo

