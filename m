Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3BE7470
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667484273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ld7KbWWPpVg/DGXuI3WKVRs5TJPSNq4PfcjQdMphjo=;
	b=KEJc5mWK/XGWIDAdswXjbXXVhcNodZETUC0DjLncFSUJiYaRwGfZdz3ddf9Oyd19MXRNQB
	PF8Dd/Sp3F8oadxGZ+gMW/Uvi+eqZIknjP7HDLbOUfM19qxP2oV/A5FyyyVaEc+XE+HO2A
	YwufaRodatiRBgQuhnMpX8STv4olxLE=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-424-Hh1c-mD-M1eleuuNh6ES9Q-1; Thu, 03 Nov 2022 10:04:30 -0400
X-MC-Unique: Hh1c-mD-M1eleuuNh6ES9Q-1
Received: by mail-vs1-f70.google.com with SMTP id p63-20020a674242000000b003ad8a237369so105194vsa.23
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 07:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ld7KbWWPpVg/DGXuI3WKVRs5TJPSNq4PfcjQdMphjo=;
        b=KsdfLCYUT1AOdCPwW9+N7iQMsXueiX+8TGdMnb4K767Qj5rM6IoY4Fu57mLFzKPPIx
         tavdXTGtZKob7X0q6bCAQ02lqxfJik7ZQAE6/3kuK4pLjGjMs5hqeJ3mZktCBYyTFrj8
         TKm69VdpzYnNV4hyV4qwCIOYbtXaufMaR9BrkZwzVEqCotEf8IspMYkNvL8JTkDS/kUx
         demDqBf7kdeeYN9Lgvi/OSyaemL2Sc4HixyzwmSQ4zwvgqGHIW8+Z58malMStNi4ywzV
         ZCUKU0+f7g3y0ZxvQvc6MoSoUy8eS1iec5yUGzHeIO8X0T27S0OouyPPOO/BFLOnMy97
         1O+w==
X-Gm-Message-State: ACrzQf37yoc4ZE7uaydi8pz+sFEl1d7lSHGoIgR8hR5CyuvYRk7kBUHw
	zhqANSt5hKcbxgrwibX8V1Bc+c6OEifUAT+kawoInZ4FMhtScj0byqjKvy6wEAgQbdW1dI8ppMx
	KqAie7yjDnlxQdTc3cOI2GYkjo9Pk3dbz
X-Received: by 2002:a67:c997:0:b0:3aa:1d0c:6bc7 with SMTP id y23-20020a67c997000000b003aa1d0c6bc7mr18114543vsk.16.1667484269588;
        Thu, 03 Nov 2022 07:04:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM57ejOKzdNWqeTyWHPkPRmEBqAcfUgljrJu10jVJC1iEGC5QqKTnJr+aHwKv6/RTPPoYaQADtoBOTHZ/wIpPrc=
X-Received: by 2002:a67:c997:0:b0:3aa:1d0c:6bc7 with SMTP id
 y23-20020a67c997000000b003aa1d0c6bc7mr18114480vsk.16.1667484269311; Thu, 03
 Nov 2022 07:04:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com> <20221102231911.3107438-11-seanjc@google.com>
 <d641088f-87d9-da77-7e98-92d1a9de6493@redhat.com>
In-Reply-To: <d641088f-87d9-da77-7e98-92d1a9de6493@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 3 Nov 2022 15:04:17 +0100
Message-ID: <CABgObfZDngVgmPetJEQGFW-MZGqYvW9tTa5jzcKheO5EO703Vw@mail.gmail.com>
Subject: Re: [PATCH 10/44] KVM: VMX: Clean up eVMCS enabling if KVM
 initialization fails
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Fabiano Rosas <farosas@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Yuan Yao <yuan.yao@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221103140417.XTh7G0gKzmb-6vBtz4kdyBMxmArMuDhjoYRwAY19XSI@z>

On Thu, Nov 3, 2022 at 3:01 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/3/22 00:18, Sean Christopherson wrote:
> > +static void hv_cleanup_evmcs(void)
>
> This needs to be __init.

Error: brain temporarily disconnected.

Paolo

