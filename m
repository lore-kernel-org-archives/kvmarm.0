Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E387C6FD7
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 23:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682119172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gArk5kA5h91jQajZJDrJgiT/ybVjEuAxb1hpzR7LDuo=;
	b=YLPbFFQbVF96lUFsMGryIUbJXQDF9kIwa/nJbhTay3VJCRiBkFzCfKb78Z6VU/Wv5kNMpk
	xBlI6pxIFp300cFiwQrcA3VC64zcbDwLfr30EJ4ZENdADk+U6bdkhTgO6OVI/+xYn+GHrO
	mmxptNjrqvBwJ+ZYj5sl5O5CLsPDNzQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-7iTSRryLNn6FfPOYE0AptQ-1; Fri, 21 Apr 2023 19:19:31 -0400
X-MC-Unique: 7iTSRryLNn6FfPOYE0AptQ-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-50470d68f1eso2138696a12.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 16:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682119169; x=1684711169;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gArk5kA5h91jQajZJDrJgiT/ybVjEuAxb1hpzR7LDuo=;
        b=O1OVDwO6E7t9+w8qo0x6xZ1ZijzKHG9djltscpT1ReDsmirllMIHwYvECqYXWNDYfC
         BouCa9i5vkOCYYDGIuA07doPcfLrorU9/KEl6sbvvHZ1KWmwkwBgH4sQJwF6mLdK0umh
         JKO0SXaJHYnzJ8d+46Rky65nhIP3eu3CiMyEAlP/MuKwZru/lEHwyHaDdIcWRL1KVaKX
         9aOrXVmP1SXxa/Qz9d1zmTMvL+XJ4C9sERWWWlFKlxeH2fDqc8yk5iRAl7mzk23iAnl1
         FdcvTUSHe5MvFm+xAwvTfmNF6M1cZxvj5lJthVGchZ6DFEfYqXTtuMPqkyCldGXw8Rjy
         yEHg==
X-Gm-Message-State: AAQBX9f0+aaKslULuc7XOP2aVpIgjr9dUClAwjx0TGKnRUv9WWsQmiYC
	SqGhGfJx5ch17IVRH7900CYDjDwCJBNQkY3eFqrs3ZONYDXtbFmFUtqeezTxR8jF/mt4fwkugB6
	E1C/JRvMhg3Q4vKPb
X-Received: by 2002:a17:906:6696:b0:94f:296d:75d0 with SMTP id z22-20020a170906669600b0094f296d75d0mr4131497ejo.30.1682119168888;
        Fri, 21 Apr 2023 16:19:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZZ3xqFfRB+TCuv6iug8ekUlrIuTCxxZuHbavzl6Dc3sGW8mAGG3LfQs+u3PgmIl6xEzLAkvg==
X-Received: by 2002:a17:906:6696:b0:94f:296d:75d0 with SMTP id z22-20020a170906669600b0094f296d75d0mr4131473ejo.30.1682119168476;
        Fri, 21 Apr 2023 16:19:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id e6-20020a1709062c0600b0094ef2003581sm2612514ejh.153.2023.04.21.16.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 16:19:27 -0700 (PDT)
Message-ID: <1583e743-2448-6bb9-1653-265887f73eb0@redhat.com>
Date: Sat, 22 Apr 2023 01:19:26 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [GIT PULL v2] KVM/arm64 fixes for 6.3, part #4
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Mostafa Saleh <smostafa@google.com>, Dan Carpenter <dan.carpenter@linaro.org>
References: <ZEAOmK52rgcZeDXg@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZEAOmK52rgcZeDXg@thinky-boi>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/23 17:54, Oliver Upton wrote:
> Hi Paolo,
> 
> Here is v2 of the last batch of fixes for 6.3 (for real this time!)
> 
> Details in the tag, but the noteworthy addition is Dan's fix for a
> rather obvious buffer overflow when writing to a firmware register.
> 
> Please pull,
> 
> Oliver
> 
> The following changes since commit e81625218bf7986ba1351a98c43d346b15601d26:
> 
>    KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs (2023-04-04 15:52:06 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.3-4
> 
> for you to fetch changes up to a25bc8486f9c01c1af6b6c5657234b2eee2c39d6:
> 
>    KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg() (2023-04-19 15:22:37 +0000)

Pulled, thanks.

Paolo

> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.3, part #4
> 
>   - Plug a buffer overflow due to the use of the user-provided register
>     width for firmware regs. Outright reject accesses where the
>     user register width does not match the kernel representation.
> 
>   - Protect non-atomic RMW operations on vCPU flags against preemption,
>     as an update to the flags by an intervening preemption could be lost.
> 
> ----------------------------------------------------------------
> Dan Carpenter (1):
>        KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
> 
> Marc Zyngier (1):
>        KVM: arm64: Make vcpu flag updates non-preemptible
> 
>   arch/arm64/include/asm/kvm_host.h | 19 ++++++++++++++++++-
>   arch/arm64/kvm/hypercalls.c       |  2 ++
>   2 files changed, 20 insertions(+), 1 deletion(-)
> 

