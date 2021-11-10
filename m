Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC075C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 18:06:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42E5361208
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 18:06:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 42E5361208
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FC504B1F5;
	Wed, 10 Nov 2021 13:06:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JNBChD3pzdcL; Wed, 10 Nov 2021 13:06:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09B374B222;
	Wed, 10 Nov 2021 13:06:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09CB34B0EF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 13:06:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yCbWdT1vx-d0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 13:06:27 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7001D4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 13:06:27 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636567587;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cqzkKKVU1TFefm2txuHW5tA1oBvnHRU7MmXEb01dQtg=;
 b=a70ULvnQZnM0QKBho/JrkwZhStoJZeaYyfrtGZ2jnTJyRimeDnjfDGquetjjas5uAs8VVB
 dapbyFWQAUVmzg2Jgvr26S+2bq/LNBRTUZXEyYJ3T9xdu/ctTD6lsEFIa23BfnG/TkX+lE
 hsAWn8hhM3iQ4PU3P1QOSxve46xHac0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-VtrfVYjJOUGJqO9wq8F7Hw-1; Wed, 10 Nov 2021 13:06:26 -0500
X-MC-Unique: VtrfVYjJOUGJqO9wq8F7Hw-1
Received: by mail-wr1-f70.google.com with SMTP id
 h13-20020adfa4cd000000b001883fd029e8so596459wrb.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 10:06:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=cqzkKKVU1TFefm2txuHW5tA1oBvnHRU7MmXEb01dQtg=;
 b=G8T5qPTYSeDVxnMhT0jyHsZimTpexfcDxJ9kJMhvKR7KR1iBfGrrvC0Ad1tajoNI0y
 fYoWp6yy37LMdQY+02K3LwlhOoPiz4VS7hbRLr50b0ZZh/8lNmyr6zI5dzcFU/3Gns3W
 LDwgvh0l2jUUGKMkpfP9oB+7x37ZvKae01NJVgzDMhZaHD+RzsQiXSaG2kgdSozRUutO
 Ug94nqfCEvxyTtFqFCN8qs2iP3j2neisGa9AtVyN8grQOMoC+WBtPW6W414GNQHdssB1
 m1KDXBYy/29aOEEqN+7DZObxa+IuqQOhR+04lxIV/Je01rZyS8o8evDnw+mT2nADR+KV
 Tb6A==
X-Gm-Message-State: AOAM531Wnh/A8mCBTZ+ftVZjFlCNEPXYMY5uf5JrhKN9pj1RwZ/Fr9nc
 5wcRZSX33nVhJrD3AzCtALzPstLSxBb3foBfCEsLmzWO07yoj9S9rmrcj0YTOx/g98jdbcKFpS+
 FYhJGh0534ZbKoq6Lx1VeHekH
X-Received: by 2002:a05:600c:510d:: with SMTP id
 o13mr18448370wms.104.1636567584296; 
 Wed, 10 Nov 2021 10:06:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxU9y/NX64qlc3vXZ1ejqNHzYKNDlRCKkpWhRwE8xA5Lk7aS9uc4qTP3ah1NLedT0vvveXpAw==
X-Received: by 2002:a05:600c:510d:: with SMTP id
 o13mr18448327wms.104.1636567584080; 
 Wed, 10 Nov 2021 10:06:24 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id y6sm621380wrh.18.2021.11.10.10.06.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 10:06:23 -0800 (PST)
Subject: Re: [PATCH v4 06/15] KVM: arm64: Add paravirtualization header files
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-7-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <82506a31-7b32-f8e2-c0cb-0f39d204ef3a@redhat.com>
Date: Wed, 10 Nov 2021 19:06:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815005947.83699-7-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

Hi Gavin,

On 8/15/21 2:59 AM, Gavin Shan wrote:
> We need put more stuff in the paravirtualization header files when
> the asynchronous page fault is supported. The generic header files
> can't meet the goal.
you need to explain why
 This duplicate the generic header files to be
s/This duplicate/Duplicate
> our platform specific header files. It's the preparatory work to
> support the asynchronous page fault in the subsequent patches:
why duplication and not move. Shouldn't it be squashed with another
subsequent patch?

Eric
> 
>    include/uapi/asm-generic/kvm_para.h
>    include/asm-generic/kvm_para.h
> 
>    arch/arm64/include/uapi/asm/kvm_para.h
>    arch/arm64/include/asm/kvm_para.h
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_para.h      | 27 ++++++++++++++++++++++++++
>  arch/arm64/include/uapi/asm/Kbuild     |  2 --
>  arch/arm64/include/uapi/asm/kvm_para.h |  5 +++++
>  3 files changed, 32 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_para.h
>  create mode 100644 arch/arm64/include/uapi/asm/kvm_para.h
> 
> diff --git a/arch/arm64/include/asm/kvm_para.h b/arch/arm64/include/asm/kvm_para.h
> new file mode 100644
> index 000000000000..0ea481dd1c7a
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_para.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_ARM_KVM_PARA_H
> +#define _ASM_ARM_KVM_PARA_H
> +
> +#include <uapi/asm/kvm_para.h>
> +
> +static inline bool kvm_check_and_clear_guest_paused(void)
> +{
> +	return false;
> +}
> +
> +static inline unsigned int kvm_arch_para_features(void)
> +{
> +	return 0;
> +}
> +
> +static inline unsigned int kvm_arch_para_hints(void)
> +{
> +	return 0;
> +}
> +
> +static inline bool kvm_para_available(void)
> +{
> +	return false;
> +}
> +
> +#endif /* _ASM_ARM_KVM_PARA_H */
> diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
> index 602d137932dc..f66554cd5c45 100644
> --- a/arch/arm64/include/uapi/asm/Kbuild
> +++ b/arch/arm64/include/uapi/asm/Kbuild
> @@ -1,3 +1 @@
>  # SPDX-License-Identifier: GPL-2.0
> -
> -generic-y += kvm_para.h
> diff --git a/arch/arm64/include/uapi/asm/kvm_para.h b/arch/arm64/include/uapi/asm/kvm_para.h
> new file mode 100644
> index 000000000000..cd212282b90c
> --- /dev/null
> +++ b/arch/arm64/include/uapi/asm/kvm_para.h
> @@ -0,0 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_ASM_ARM_KVM_PARA_H
> +#define _UAPI_ASM_ARM_KVM_PARA_H
> +
> +#endif /* _UAPI_ASM_ARM_KVM_PARA_H */
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
