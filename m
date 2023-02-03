Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0F31FBC
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 10:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675421699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RP8qXabbbkVFHjkXGB3iPT4qiggJHLCmrxY/0vUZBsk=;
	b=fIAtTLXkMvSZgrgJlnZO2xWmcxGbTRgSmDTDXSGjjEeGuogbIV2CiKulhV1mpRQ1aYBe/R
	cwDgfRPT5+06L2PwRWlqxIJBknrFIepCO3vTzzjatb+bZ2BJ4+ZZ97Eyohj++VscTQtD4T
	S6D/b20+1Nm/eOtQq604yfMPzID00bE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-96-Vtgvlk0CPr6biBCe5hWiOQ-1; Fri, 03 Feb 2023 05:54:58 -0500
X-MC-Unique: Vtgvlk0CPr6biBCe5hWiOQ-1
Received: by mail-qv1-f70.google.com with SMTP id kd28-20020a056214401c00b0053cd4737a42so2537938qvb.22
        for <kvmarm@lists.linux.dev>; Fri, 03 Feb 2023 02:54:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RP8qXabbbkVFHjkXGB3iPT4qiggJHLCmrxY/0vUZBsk=;
        b=j3X/KoS6ckSlXPnORPshDVOHSg5oRsLmXTaFcOCTbSNGruZgSDTu1Ye5yxLuPRo8y3
         f3BYh1UCPJ1EpAuTiSpuAoCKt+YAhb95NM6wn8gg82D4AFVHNICQDAy4Ps6D+oGIomaw
         MnHQ5z2Kxrrscb0OMqE+t2Zsd9zNqiAa/Gwb7F9tXlhhbcymgM6fMOf0+60DNW5Mj0gQ
         gfPS1Tx7s4mJIeW67nHtznHltbcuhyRWUFnLwJ6f3yXjeFy9NltCZol473DCqQk2N2o9
         O4cSV6jlDz6S0Qu3JEoRcE5yYRfykBabZLD5t+AHWCUNDQyxTBHLISJRiEv0I6WYV3fE
         7YJw==
X-Gm-Message-State: AO0yUKVcaI6UHZH2vAwLEXhpHMHbz/sM7hbO+bUjNdCHHRSTblDnecva
	rh2yFUZvmsd3hp8h8Rh991Qns8ecRWV7HniNm45vB+0J9M64Kv9aJPa7FWhLA9fApEVSZ6lY1wE
	uIKkJhsCeDiThCy6V
X-Received: by 2002:ac8:7d04:0:b0:3b6:3787:679d with SMTP id g4-20020ac87d04000000b003b63787679dmr18376049qtb.8.1675421697837;
        Fri, 03 Feb 2023 02:54:57 -0800 (PST)
X-Google-Smtp-Source: AK7set8N+04AaVpEWJqlRLC4f+pcB8NjgkYdMQcrG47rLW4TpdktzPu1UTGGOpRxuhVJPJmt51StNw==
X-Received: by 2002:ac8:7d04:0:b0:3b6:3787:679d with SMTP id g4-20020ac87d04000000b003b63787679dmr18376027qtb.8.1675421697468;
        Fri, 03 Feb 2023 02:54:57 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-179-40.web.vodafone.de. [109.43.179.40])
        by smtp.gmail.com with ESMTPSA id o11-20020ac87c4b000000b003b9a426d626sm1405276qtv.22.2023.02.03.02.54.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:54:56 -0800 (PST)
Message-ID: <2c37f524-593f-a155-a01f-57a68b2e362c@redhat.com>
Date: Fri, 3 Feb 2023 11:54:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 3/7] KVM: Move KVM_GET_NR_MMU_PAGES into the deprecation
 section
To: Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Marc Zyngier <maz@kernel.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 James Morse <james.morse@arm.com>, kvm-riscv@lists.infradead.org,
 kvmarm@lists.linux.dev, Christian Borntraeger <borntraeger@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-4-thuth@redhat.com> <CQ8UM1FTPEUZ.3F2RONR3AJ5YP@bobo>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <CQ8UM1FTPEUZ.3F2RONR3AJ5YP@bobo>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/02/2023 11.16, Nicholas Piggin wrote:
> On Fri Feb 3, 2023 at 7:42 PM AEST, Thomas Huth wrote:
>> The KVM_GET_NR_MMU_PAGES ioctl is quite questionable on 64-bit hosts
>> since it fails to return the full 64 bits of the value that can be
>> set with the corresponding KVM_SET_NR_MMU_PAGES call. This ioctl
>> likely has also never really been used by userspace applications
>> (at least not by QEMU and kvmtool which I checked), so it's better
>> to move it to the deprecation section in kvm.h to make it clear for
>> developers that this also should not be used in new code in the
>> future anymore.
> 
> Did this get included in the series inadvertently?

No, it's here on purpose, as a second step to patch 2/7 (and a follow up 
from the discussion last year, see 
https://lore.kernel.org/kvm/YpZu6%2Fk+8EydfBKf@google.com/ ) ... sorry, I 
should have elaborated on this in the cover letter, too.

  Thomas

