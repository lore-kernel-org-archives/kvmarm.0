Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CE5C04FDE
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 10:35:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5114B4B960;
	Mon, 12 Dec 2022 05:35:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BWwERgbpiuYk; Mon, 12 Dec 2022 05:35:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 281C24B999;
	Mon, 12 Dec 2022 05:35:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16E674B960
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 05:35:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ag1yJmpnN5lT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 05:35:02 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE63A4B95E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 05:35:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670841301;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KFD4bXF9HfKCTB2bqwvpTx8dBPmnhTdXw6WlgJmCRVE=;
 b=XtcBuogrVlAYOgrn9RpxLwB9dq8l+t3xevpG3yn42B4fo/hwPk//p0Oem/FLWSXTrvfxQj
 mFJV+08Wl58guTndX+tMWTXYKQ24C8o1imml7C3KXaRAN1zrXAWCYv9X3hX30enychXO15
 UU/GhwKB6lNiORvVb91HMHWva5p4AvU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-275-znFA3hXhM865r8YMfSGw0Q-1; Mon, 12 Dec 2022 05:35:00 -0500
X-MC-Unique: znFA3hXhM865r8YMfSGw0Q-1
Received: by mail-wm1-f71.google.com with SMTP id
 r129-20020a1c4487000000b003d153a83d27so3185673wma.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 02:35:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=KFD4bXF9HfKCTB2bqwvpTx8dBPmnhTdXw6WlgJmCRVE=;
 b=ULrw8IvX+XuKITeiA6U0w4uqqCFIwU8qr6Ymy8ijnZFufaep6406fJaM2rUfJ3KTXL
 YJDpyv87CqWzyrPdyJmFtw0OxX1PKPH7sbRsIB2mivYMgOEnh6doxf2eFEUEOGJ5Hs1P
 hbU2vI6LzJ1IDvE+CtS7cq11Z9zhK4AD6P1j9BWOz8ADnp9c0zm9cmeIWZg1doTU+sAu
 39oIvThcxwPf1ZL8VDK7uFEWW6fwzt3p+2YFoKjosILFFiIBykO2hwRpj8gfiaDNm3FF
 W3i4+ntMP2slIa5H5HAF607Jwmf99RXbeZgOeei1+y20IU+NJFbGEC1XIIj4Wcy2+Xc3
 lurw==
X-Gm-Message-State: ANoB5pm9I4U3QtsRKvd7ewez0/BbPy6zJ5+neh6eWZCwWGXRRxOq4MvR
 Ia/+yZVnIEzmu6AmjYBCky8gAA5u0hcYRRC6iId/tQiiVrSdyjT0dhMelh+vAZpXm1r3HQ4qpHm
 kUhPpHTwH0Txa63N24NCXuBYy
X-Received: by 2002:a5d:4888:0:b0:232:be5d:5ecc with SMTP id
 g8-20020a5d4888000000b00232be5d5eccmr9224096wrq.35.1670841299295; 
 Mon, 12 Dec 2022 02:34:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7wvWIVuOKysZf5Mx8cCdDopdcGEnGqjatRwKG8EB36UeyRpqDFxHDI9VsIf8PVP5iD55AkPA==
X-Received: by 2002:a5d:4888:0:b0:232:be5d:5ecc with SMTP id
 g8-20020a5d4888000000b00232be5d5eccmr9224016wrq.35.1670841298004; 
 Mon, 12 Dec 2022 02:34:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 bn1-20020a056000060100b00242269c8b8esm8603207wrb.25.2022.12.12.02.34.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Dec 2022 02:34:57 -0800 (PST)
Message-ID: <322454c7-0a3b-e055-2405-f485fa149e7a@redhat.com>
Date: Mon, 12 Dec 2022 11:34:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 4/7] KVM: selftests: Correctly initialize the VA space
 for TTBR0_EL1
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Shuah Khan <shuah@kernel.org>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
 <20221209015307.1781352-5-oliver.upton@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221209015307.1781352-5-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
