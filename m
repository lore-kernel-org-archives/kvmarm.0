Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A926FC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 10:39:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24C5B4B999;
	Mon, 12 Dec 2022 05:39:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bBJ83Ns5EID9; Mon, 12 Dec 2022 05:38:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8CBC4B9C3;
	Mon, 12 Dec 2022 05:38:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90A624B918
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 05:38:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id COP5kdQA2clv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 05:38:53 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8EBB4B911
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 05:38:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670841533;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0geoJp5y5vah58rc3h1onQRI09PobQgX5h6nKaS34UM=;
 b=eEWGQwa9qqz3ysrLQoh2a6rCsqjGjiP8/P+m9bwpM94NFgcZTxrzMlyszei9skbsstOZSh
 eWFdhaXm2WteaAIfolHFBbXXHqXmvz5zecvFSB8b0kyelCgc9PvLOw0rD8iHUjb3oPceEh
 OU+R7TjSc0+nlnom8nhlAqguAxWxhXY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-295-Q2w0huMIOPaiqnHfFQ_tBw-1; Mon, 12 Dec 2022 05:38:50 -0500
X-MC-Unique: Q2w0huMIOPaiqnHfFQ_tBw-1
Received: by mail-wr1-f69.google.com with SMTP id
 g14-20020adfa48e000000b00241f94bcd54so2150043wrb.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 02:38:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=0geoJp5y5vah58rc3h1onQRI09PobQgX5h6nKaS34UM=;
 b=28svGqJLkycQcSamfKb887nIaSzmEiYWMy3pRjisgRQv3XoRileuNupo5jHntFIU2R
 GuiPQl0MHDnEjEzo42Ae+6oeVZ/rX2YmD7BISL8bAacseBPbkdPjTEJUaAy41FOaa8io
 CwDeXnEESqDP2IhmDl1DlMEdQQg9n4vL13mHWVMphMQid+8omM7D8SwL3agRSULD4ngS
 rPzWtR9F9Z309v2WW4lkCibT2DqoCkuxAV5OOxRsgdVVeEirMSql1xKkcfHKNG+35Hry
 aK65LzaFkuIKyh/ni8HSM6+++5FC04DN6q5l2cLZEP/PlMytIpwMrHCg8T7SqejmNtEV
 MxvA==
X-Gm-Message-State: ANoB5pl1dWOAqq6q97Nw0gP0nIRRpekxoKj/WpCynlGzcGCPyLF74TUS
 4bHa36dsWjFvRoO5YPIBmj+M25cttJp8iP6hc38gbIvsePbr0xDLTDQHQ645szi1niox3K9UHfO
 cwdnCeaorhe3iHRJ16gZ9BeY8
X-Received: by 2002:a05:600c:5398:b0:3cf:d0b1:8aa1 with SMTP id
 hg24-20020a05600c539800b003cfd0b18aa1mr12355053wmb.0.1670841529006; 
 Mon, 12 Dec 2022 02:38:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf43hHD3Xh/hVMzgx7AUun3dPtnLezNxJe71/MuBv74YiGy1tG1gohvB+wRobXA4W5SAS5QTYw==
X-Received: by 2002:a05:600c:5398:b0:3cf:d0b1:8aa1 with SMTP id
 hg24-20020a05600c539800b003cfd0b18aa1mr12355032wmb.0.1670841528795; 
 Mon, 12 Dec 2022 02:38:48 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 iw3-20020a05600c54c300b003d220ef3232sm5442368wmb.34.2022.12.12.02.38.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Dec 2022 02:38:48 -0800 (PST)
Message-ID: <2ce6eab8-6156-1282-bf29-87fd74e4587a@redhat.com>
Date: Mon, 12 Dec 2022 11:38:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 7/7] KVM: selftests: Avoid infinite loop if
 ucall_alloc() fails
To: Sean Christopherson <seanjc@google.com>,
 Oliver Upton <oliver.upton@linux.dev>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
 <20221209015307.1781352-8-oliver.upton@linux.dev>
 <Y5OisdH5ohtr6r3j@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5OisdH5ohtr6r3j@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Andrew Jones <andrew.jones@linux.dev>, Peter Gonda <pgonda@google.com>,
 kvmarm@lists.linux.dev, Shuah Khan <shuah@kernel.org>,
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

On 12/9/22 22:03, Sean Christopherson wrote:
> From: Sean Christopherson<seanjc@google.com>
> Date: Fri, 9 Dec 2022 12:55:44 -0800
> Subject: [PATCH] KVM: selftests: Use magic value to signal ucall_alloc()
>   failure
> 
> Use a magic value to signal a ucall_alloc() failure instead of simply
> doing GUEST_ASSERT().  GUEST_ASSERT() relies on ucall_alloc() and so a
> failure puts the guest into an infinite loop.
> 
> Use -1 as the magic value, as a real ucall struct should never wrap.
> 
> Reported-by: Oliver Upton<oliver.upton@linux.dev>
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/lib/ucall_common.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index 0cc0971ce60e..2f0e2ea941cc 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -4,6 +4,8 @@
>   #include "linux/bitmap.h"
>   #include "linux/atomic.h"
>   
> +#define GUEST_UCALL_FAILED -1
> +
>   struct ucall_header {
>   	DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
>   	struct ucall ucalls[KVM_MAX_VCPUS];
> @@ -41,7 +43,8 @@ static struct ucall *ucall_alloc(void)
>   	struct ucall *uc;
>   	int i;
>   
> -	GUEST_ASSERT(ucall_pool);
> +	if (!ucall_pool)
> +		goto ucall_failed;
>   
>   	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>   		if (!test_and_set_bit(i, ucall_pool->in_use)) {
> @@ -51,7 +54,13 @@ static struct ucall *ucall_alloc(void)
>   		}
>   	}
>   
> -	GUEST_ASSERT(0);
> +ucall_failed:
> +	/*
> +	 * If the vCPU cannot grab a ucall structure, make a bare ucall with a
> +	 * magic value to signal to get_ucall() that things went sideways.
> +	 * GUEST_ASSERT() depends on ucall_alloc() and so cannot be used here.
> +	 */
> +	ucall_arch_do_ucall(GUEST_UCALL_FAILED);
>   	return NULL;
>   }
>   
> @@ -93,6 +102,9 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>   
>   	addr = ucall_arch_get_ucall(vcpu);
>   	if (addr) {
> +		TEST_ASSERT(addr != (void *)GUEST_UCALL_FAILED,
> +			    "Guest failed to allocate ucall struct");
> +
>   		memcpy(uc, addr, sizeof(*uc));
>   		vcpu_run_complete_io(vcpu);
>   	} else {
> 
> base-commit: dc2efbe4813e0dc4368779bc36c5f0e636cb8eb2
> -- 

Queued, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
