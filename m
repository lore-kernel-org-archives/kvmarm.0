Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA896FD7
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 23:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682121110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VAFP2288uyWDKnQaDiMb9JDvr08+DkWektgG+J7MkUQ=;
	b=FAFATolsf2au/EVDZcgXfPKn73/JNIye4bl0k0wf3ZJgbxWZay6duic4W8CyDFSoT7BdMr
	fYhzdoyE3CAU03jvNddp8i7wGpUGaWChG3L5NzEbuxWyqEq68Q4+V/fH7y0uQ48zv7LSgY
	ytn/5tUNsXcRQf/NWUxxH8GhIdoUXBM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-jwm-X5gpMe-ZZkrFT6jbXQ-1; Fri, 21 Apr 2023 19:51:49 -0400
X-MC-Unique: jwm-X5gpMe-ZZkrFT6jbXQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-506a455ee4cso2051930a12.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 16:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682121108; x=1684713108;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VAFP2288uyWDKnQaDiMb9JDvr08+DkWektgG+J7MkUQ=;
        b=eBXUKrDWKswm/h3r9TC/U8fXWBU0ajh6eNjEIsfrSCIWQUlruykFIYyDJqd56L0hXa
         4PXf5P+fnIYg4zW/IUPsi3kFQK1BkpkUiLfyjReo1WCxt5oJQ4bUUvolNDJuMzQvWgDs
         xklmtCR0DV8X3lwt7IXOp5u+Cdfn2XNtwz0KRQZjxwnkOTvNuMRRYXu/413Xz8FfHClR
         i6AWyi98JC3f/zMn+NBwughceFIC+4SBT0FcnSheJuOlh4xAlaDJmjgO2fz/2Eg7imTN
         JQUaDdsmIK5DzPMzBbPF6CjBUS8EywmhQQTqtcho+FPZpYdFtldau2x20IHpy2S4uH2/
         l8Mw==
X-Gm-Message-State: AAQBX9dn4qtMMKIIpzYbjyAtK1kg2stJ4sgPkes1dCl/aGc1qfsrONNb
	xjngHcSkZX+ftjACMWsbsn6hH1Cx+r/UsLCZv2Ma1kRAem0LDgCV9AoEv3At9jyTSV13bCEfEzV
	IyWm/AMfHcAbAaXKW
X-Received: by 2002:aa7:c0c8:0:b0:508:46d4:898 with SMTP id j8-20020aa7c0c8000000b0050846d40898mr6632994edp.4.1682121107936;
        Fri, 21 Apr 2023 16:51:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350YzUsfT5OzAaPvtfkCtGstYci4TW877mQiPePfbMHufEdXmAlB27b5i/YoYiyZeasdBM4nQLw==
X-Received: by 2002:aa7:c0c8:0:b0:508:46d4:898 with SMTP id j8-20020aa7c0c8000000b0050846d40898mr6632974edp.4.1682121107624;
        Fri, 21 Apr 2023 16:51:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id f7-20020a05640214c700b004fa380a14e7sm2293807edx.77.2023.04.21.16.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 16:51:47 -0700 (PDT)
Message-ID: <417f815d-3cf1-45ea-eba7-83e42f249424@redhat.com>
Date: Sat, 22 Apr 2023 01:51:45 +0200
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

At least going by the Fixes tag, I think this one should have been Cc'd 
to stable as well.  Can you send it next week or would you like someone 
else to handle the backport?

Thanks,

Paolo

