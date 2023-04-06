Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCECAD29
	for <kvmarm@lists.linux.dev>; Thu,  6 Apr 2023 17:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680802511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FVq6vuqCUvv437Ye4jb4CJk28rz37KbFIJLyeie7Yy0=;
	b=bkgFBkJU3ZG0sNYDQ5+9o2imRz2shI//Was4KcGCsDXQEa214CZP1LfXmRV2LaktMt3Txo
	6JWI+21wRuJCNaQWI/Lbb1qGZccQalTgeePtIqbEBqGcVQaV8ixqdhY04ZpIVFDYJYbRYl
	NoKsqhofqVAK1J8mIAtUcIch4QVd8jI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-MwEga3sbMMCLoqJuMX3NLQ-1; Thu, 06 Apr 2023 13:35:08 -0400
X-MC-Unique: MwEga3sbMMCLoqJuMX3NLQ-1
Received: by mail-ed1-f72.google.com with SMTP id c1-20020a0564021f8100b004acbe232c03so52247481edc.9
        for <kvmarm@lists.linux.dev>; Thu, 06 Apr 2023 10:35:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680802507; x=1683394507;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FVq6vuqCUvv437Ye4jb4CJk28rz37KbFIJLyeie7Yy0=;
        b=odS30fbJfVZdoGTLxvqxT//sHiOeSwqraB//yaq+T9Y5aiXOXndBiiVlUbGcdXl5L4
         UM5zp2mgXNQb4LVvFmlJZFLO3tUAiFatK9Vl5iBRU9N/Koe52mvxcLu56LJMbgq8V3Tk
         7YdQf+xOsQgbMyZIt9xp09QrPxcgzA4Lb+LGYKSD7h/vd+kmZuXxFCUT2pi/OdXABKmX
         SuXHWGr32pm3dbMK5H4sP9u9vEbcOqNFR7mIYHpSChhwFg9G9Q5tBDB/xWW4Mhts68MH
         PMYDJ861AfvdjlGaIb+bIn3NhLYcs4/0GMNkDSNHUT4DLtMNF/M3PrKmtG4wxTj3Xoic
         M1eg==
X-Gm-Message-State: AAQBX9dE5vIgLNaJ5f04NOjbSrwRxEtApghTFurgJHA97QzprSqyuWWA
	ide3sBmo7g0x5Uxa7cjIvZasjuAr/diXYuPp39f4yL67Sa2MGK406oZg2Bj+1PhJ8r0qDdyMi9T
	V3o33MJsqXzsAzxWh
X-Received: by 2002:a17:906:9383:b0:948:d1af:3afb with SMTP id l3-20020a170906938300b00948d1af3afbmr5583607ejx.13.1680802507619;
        Thu, 06 Apr 2023 10:35:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350YdZ23vTC3jb6Q4OZMvCq+v951UYx7wh1E9GCULBeCPXKfyfGJdz8NaX5Do6DoIVSdjPKIWMA==
X-Received: by 2002:a17:906:9383:b0:948:d1af:3afb with SMTP id l3-20020a170906938300b00948d1af3afbmr5583592ejx.13.1680802507340;
        Thu, 06 Apr 2023 10:35:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id i24-20020a170906a29800b00948021c1629sm1049160ejz.182.2023.04.06.10.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 10:35:06 -0700 (PDT)
Message-ID: <bfab2767-0b31-4dce-c077-b72cac4bcb2e@redhat.com>
Date: Thu, 6 Apr 2023 19:35:05 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.3, part #3
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>,
 Reiji Watanabe <reijiw@google.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <ZC2eAXc9UE7Vesmn@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZC2eAXc9UE7Vesmn@thinky-boi>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/5/23 18:12, Oliver Upton wrote:
> Hi Paolo,
> 
> Sending out what is likely the last batch of fixes for 6.3. Most
> noteworthy is the PMU fix, as Reiji found that events counting in guest
> userspace stopped working after live migration on VHE systems.
> Additionally, Fuad found that pKVM was underselling the Spectre/Meltdown
> mitigation state to protected VMs, so we have a fix for that too.
> 
> Also, FYI, Marc will reprise his role for the 6.4 kernel. Nothing is
> set in stone but the working model is that we'll alternate the
> maintainer duties each kernel release.

Pulled, thanks.

Paolo

