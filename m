Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273FC36A
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 02:41:24 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-662f0feafb2so236968b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 19:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686796884; x=1689388884;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H0KWirj61OciDiKkuJb2kcKl5riA4zYenELsrCoOXwc=;
        b=g0x4Kk5QVrYK6g3XrklRcZ2chcFjE/ajQ+magWolwg5VZcTZdwXKxBIyHwi7EQsr72
         cWCzFXhpyM7eUudHMqc/JmeuNptP6gmufrlD/Eqf1Op677rlYm517hhuz9Grxm11ZvIz
         7cvG0dDawb5JGYrOWdVkZPH25y0daOLmtmd2cCPEtXBg7sPz+5+Hi7I0Nesn6VKcj/mK
         qHI4Lc13Um0e98ruYJOdmfSxQwIIVnusO8EsjQM5mTe1TRf2UoHhk+h4OiqRboEa1RlY
         8D1GitmfKqO64qhL8VDf5bM5YGiJpl1PikeNpOGJXXbVNn6Kb43CeBqZwm5FIX+VI2aY
         5wug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686796884; x=1689388884;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H0KWirj61OciDiKkuJb2kcKl5riA4zYenELsrCoOXwc=;
        b=JTyf7K63UVxa/rY+f8iKrR3CGkFpWkK/mTG3T2hmr8UktD/6t+Xaaadf7Gw/Sr9Asc
         doIuvzXL2ArA5eCYVOOtMYsMTqFjxr6mRxXJYC6eRQyAEb0hJpzJCDAGti2cab/qUY3/
         1dpZAKPrjpEAQN5uKlUAzdS53A2eEYk152BFZQnH155wadmApSPM6srZYYyV84OelRe1
         9s0a9KGpxLQc8uSmderXl0B92IDjDJp7nSXaazG4Tfrg76+6dOkZ8Q+8/33V8wCKF2B0
         MBLFzRjjBTE9ZUGQoIcbtkiiZhHvl1bpHnTG5YqkDQ1Ioyi2mlkj1ljlrQDqWWFVGz5f
         iXPA==
X-Gm-Message-State: AC+VfDwL+TqytFrzGQONUIGtaOhJfKk4YYfZkFM3soxHG0pZU2Zg3HGi
	U8ukXU6ZoDM32c5AP8nVIBo=
X-Google-Smtp-Source: ACHHUZ5bcWotQvDPkVXRNgOwhiD4egWOFQz0n0Qy54KMeekV8MW45E7iLjrggEVf+3fljnRbnXrp7A==
X-Received: by 2002:a05:6a00:1901:b0:666:7eb0:12d8 with SMTP id y1-20020a056a00190100b006667eb012d8mr2667177pfi.12.1686796884275;
        Wed, 14 Jun 2023 19:41:24 -0700 (PDT)
Received: from [172.27.232.119] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id b24-20020aa78718000000b006666699be98sm1703746pfo.34.2023.06.14.19.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 19:41:23 -0700 (PDT)
Message-ID: <d5ebb72d-393d-f61b-6a6f-760c6a5d7469@gmail.com>
Date: Thu, 15 Jun 2023 10:41:17 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From: Robert Hoo <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v4 04/16] KVM: Add docstrings to __kvm_write_guest_page()
 and __kvm_read_guest_page()
To: Anish Moorthy <amoorthy@google.com>, seanjc@google.com,
 oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, jthoughton@google.com,
 bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
 axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
 isaku.yamahata@gmail.com
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-5-amoorthy@google.com>
Content-Language: en-US
In-Reply-To: <20230602161921.208564-5-amoorthy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/3/2023 12:19 AM, Anish Moorthy wrote:
> The order of parameters in these function signature is a little strange,
> with "offset" actually applying to "gfn" rather than to "data". Add
> short comments to make things perfectly clear.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>   virt/kvm/kvm_main.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 09d4d85691e1..d9c0fa7c907f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2984,6 +2984,9 @@ static int next_segment(unsigned long len, int offset)
>   		return len;
>   }
>   
> +/*
> + * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'
> + */
>   static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>   				 void *data, int offset, int len)
>   {
> @@ -3085,6 +3088,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>   }
>   EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>   
> +/*
> + * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
> + */
>   static int __kvm_write_guest_page(struct kvm *kvm,
>   				  struct kvm_memory_slot *memslot, gfn_t gfn,
>   			          const void *data, int offset, int len)

Agree, and how about one step further, i.e. adjust the param's sequence.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2c276d4d0821..db2bc5d3e2c2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2992,7 +2992,7 @@ static int next_segment(unsigned long len, int offset)
   */
  static int __kvm_read_guest_page(struct kvm_memory_slot *slot,
                                  struct kvm_vcpu *vcpu,
-                                gfn_t gfn, void *data, int offset, int len)
+                                gfn_t gfn, int offset, void *data, int len)
  {
         int r;
         unsigned long addr;
@@ -3015,7 +3015,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void 
*data, int offset,
  {
         struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);

-       return __kvm_read_guest_page(slot, NULL, gfn, data, offset, len);
+       return __kvm_read_guest_page(slot, NULL, gfn, offset, data, len);
  }
  EXPORT_SYMBOL_GPL(kvm_read_guest_page);

@@ -3024,7 +3024,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t 
gfn, void *data,
  {
         struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);

-       return __kvm_read_guest_page(slot, vcpu, gfn, data, offset, len);
+       return __kvm_read_guest_page(slot, vcpu, gfn, offset, data, len);
  }
  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);

@@ -3103,7 +3103,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
   */
  static int __kvm_write_guest_page(struct kvm *kvm, struct kvm_vcpu *vcpu,
                                   struct kvm_memory_slot *memslot, gfn_t gfn,
-                                 const void *data, int offset, int len)
+                                 int offset, const void *data, int len)
  {
         int r;
         unsigned long addr;
@@ -3128,7 +3128,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
  {
         struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);

-       return __kvm_write_guest_page(kvm, NULL, slot, gfn, data, offset, len);
+       return __kvm_write_guest_page(kvm, NULL, slot, gfn, offset, data, len);
  }
  EXPORT_SYMBOL_GPL(kvm_write_guest_page);

@@ -3136,8 +3136,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t 
gfn,
                               const void *data, int offset, int len)
  {
         struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-       return __kvm_write_guest_page(vcpu->kvm, vcpu, slot, gfn, data,
-                                     offset, len);
+       return __kvm_write_guest_page(vcpu->kvm, vcpu, slot, gfn, offset,
+                                     data, len);
  }
  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);

