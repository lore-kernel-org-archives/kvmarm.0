Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6B21841
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 10:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670841302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KFD4bXF9HfKCTB2bqwvpTx8dBPmnhTdXw6WlgJmCRVE=;
	b=DL7TV2Vw2lDnUZaurH+Mcneo4ZZYgueHH5sKzd24E/gcWlQ5Inf87CfYTcF9lxTt1cSdiq
	BFCc2PlxE8cou+nQlPyYzd5rq3ssdStNd2fGB4NHLG3mdA5U+0ssNenqxPj3PUdXgMKZhf
	b0tI7/I57ZzYOHohGuXPHPIsB+mfluw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-100-a81Tu-vzMGGAzTT8USB4rw-1; Mon, 12 Dec 2022 05:34:59 -0500
X-MC-Unique: a81Tu-vzMGGAzTT8USB4rw-1
Received: by mail-wm1-f69.google.com with SMTP id r129-20020a1c4487000000b003d153a83d27so3185645wma.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 02:34:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KFD4bXF9HfKCTB2bqwvpTx8dBPmnhTdXw6WlgJmCRVE=;
        b=1jKMz4XAVE4YAtLBxqheC7c7Bbi4N1YPzs8bi6SRwNxQPRiAQmetZBB1OOwDgP9ayb
         thBiUhKY8j9cGYol6r+/oikCOyzQ7C86I+XR7xZ3QukenyObzz/kffRQ2zgJGb8YQ8lE
         nLQkVu2iyKJIUi1cva4uJo65/OlftFeVnEZxuxxujcBo+TXScYI3EsS4mTdh93f6bXeh
         Eflco5EzZSAGgQF0w02Cs5waeLosfwW/E9RTt4ZOQ8aPq6IG3WptbaGFEqXqqQi7iGDl
         r6B6ZzYjZLtbuzE7pVQRb2y19yinxOe/0hP67KmmbmvEVMzmxhG/t0/gFgOWu328l8Hk
         4Yuw==
X-Gm-Message-State: ANoB5pldoCMnGoxgKcZct3kyeAKTkCVbgO7ciM2SbaUmTY3fWNCs0458
	po8crHOXE89OGeSCGg5lnvnhgZ7z732KGfClcwbkD6K6/CtMnefwA+2jUVHtPVafq6hVTvvTT/g
	scwni4NdpmDMbUjYt
X-Received: by 2002:a5d:4888:0:b0:232:be5d:5ecc with SMTP id g8-20020a5d4888000000b00232be5d5eccmr9224040wrq.35.1670841298284;
        Mon, 12 Dec 2022 02:34:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7wvWIVuOKysZf5Mx8cCdDopdcGEnGqjatRwKG8EB36UeyRpqDFxHDI9VsIf8PVP5iD55AkPA==
X-Received: by 2002:a5d:4888:0:b0:232:be5d:5ecc with SMTP id g8-20020a5d4888000000b00232be5d5eccmr9224016wrq.35.1670841298004;
        Mon, 12 Dec 2022 02:34:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id bn1-20020a056000060100b00242269c8b8esm8603207wrb.25.2022.12.12.02.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 02:34:57 -0800 (PST)
Message-ID: <322454c7-0a3b-e055-2405-f485fa149e7a@redhat.com>
Date: Mon, 12 Dec 2022 11:34:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 4/7] KVM: selftests: Correctly initialize the VA space
 for TTBR0_EL1
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ricardo Koller <ricarkol@google.com>, Sean Christopherson
 <seanjc@google.com>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
 <20221209015307.1781352-5-oliver.upton@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221209015307.1781352-5-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221212103456.e_yQVqQhaySrrth2Rastt087emK2YubjU9UYS716iq0@z>

On 12/9/22 02:53, Oliver Upton wrote:
> @@ -268,17 +305,17 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
>   #ifdef __aarch64__
>   	if (vm->pa_bits != 40)
>   		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
> +
> +	/* selftests use TTBR0 only, meaning there is a single VA region. */
> +	vm->has_split_va_space = false;
> +#else
> +	vm->has_split_va_space = true;
>   #endif
>   

Even though there happens to be already a suitable #ifdef, I don't
really like them and don't think there should be a new bool unless
something else uses it.

However, the new comment is very useful, so I added it to kvm_util.c as
follows:

/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 759a45540108..56d5ea949cbb 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -186,6 +186,15 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
  _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
  	       "Missing new mode params?");
  
+/*
+ * Initializes vm->vpages_valid to match the canonical VA space of the
+ * architecture.
+ *
+ * The default implementation is valid for architectures which split the
+ * range addressed by a single page table into a low and high region
+ * based on the MSB of the VA. On architectures with this behavior
+ * the VA region spans [0, 2^(va_bits - 1)), [-(2^(va_bits - 1), -1].
+ */
  __weak void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
  {
  	sparsebit_set_num(vm->vpages_valid,

