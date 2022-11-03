Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF567488
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667488670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ayp5B1FtOoX/awXyyNk+Et491AUBiGcW44dxue5Nqxo=;
	b=IklfOWlSIKz+yPI8LlGmRypk9wCGXGsFsSkqQEPox1IpX4B6fvcnl/F+8l6RgXH88uuxLD
	eH8sfOisRSrIrdTVTpBtXXmewtA4ENTqfk7866fMI4mUAFh4AC+lWiQUQwXjgp17yPHp6Z
	Qf69+fkmsu9mjXDTnWsmfl3VHF6aHGY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-153-utn6T2kePCK9vw8Zr0L-Jw-1; Thu, 03 Nov 2022 11:17:47 -0400
X-MC-Unique: utn6T2kePCK9vw8Zr0L-Jw-1
Received: by mail-ed1-f71.google.com with SMTP id z15-20020a05640240cf00b00461b253c220so1617458edb.3
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 08:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ayp5B1FtOoX/awXyyNk+Et491AUBiGcW44dxue5Nqxo=;
        b=Zr5GJAEbGba95Tv5M5Y9SxrVHEWbZA3UN+fA6lcwNX3L3Ti4GWf6K0tziv/Sqv01jW
         2y68JQGAFpOCfHUBX0DVgbUhUoRhSzg6FZeybf4xW8F7ZaS4ARfERlCCcov4DQuKhn9i
         DZAM7GAlHBKrulNAJ7uQEw62yQbyU6/Xy62MgEspEh2c2oCgomCapkrR93ctOeE6Sfen
         NIXS+R7A9alzOZ+b0oeCHkpCFeY2iX7MXOM46ckqi9J2AAuurg9ERXite0IwszL5JNzr
         fd4LmXp6K/+M4xxSKuxmgyGUZHju91Ffj402Q3hIlXjd4L8H44SJ3ofDtPqJhJoy2WcY
         mn7A==
X-Gm-Message-State: ACrzQf1ST7cFcHrTBrrhS3wlvsFBmwse2Lq66zq/qOE6XDbOAZhMN1Ve
	+KrcExvuIC5T3N5d2fH6IyY1B0E7Gu0GtbO9WHyEIcpFB2ju2AUCgisfCfbF+DYhCVNFmEk3XVQ
	gUMKEvyOWP09SNe5/
X-Received: by 2002:a05:6402:204d:b0:463:153d:6790 with SMTP id bc13-20020a056402204d00b00463153d6790mr27934880edb.293.1667488666688;
        Thu, 03 Nov 2022 08:17:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM630sytXvddVtAZaAJHdRqOOceHpoBMlPyO4dZ3HgeOBssiaNPhkaiASNbBs9VIOouVbrocUg==
X-Received: by 2002:a05:6402:204d:b0:463:153d:6790 with SMTP id bc13-20020a056402204d00b00463153d6790mr27934856edb.293.1667488666443;
        Thu, 03 Nov 2022 08:17:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id 1-20020a170906210100b007317f017e64sm595545ejt.134.2022.11.03.08.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 08:17:45 -0700 (PDT)
Message-ID: <23bfd709-f99a-5a74-e4b9-1381b88453f1@redhat.com>
Date: Thu, 3 Nov 2022 16:17:43 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Atish Patra <atishp@atishpatra.org>,
 David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, Michael Ellerman
 <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Yuan Yao <yuan.yao@intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102231911.3107438-37-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221103151743.kCSNJNSCnAIx9yS80haj6B6HDYarTqZEeYaR6kcL6-U@z>

On 11/3/22 00:19, Sean Christopherson wrote:
> From: Chao Gao<chao.gao@intel.com>
> 
> Do compatibility checks when enabling hardware to effectively add
> compatibility checks when onlining a CPU.  Abort enabling, i.e. the
> online process, if the (hotplugged) CPU is incompatible with the known
> good setup.

This paragraph is not true with this patch being before "KVM: Rename and 
move CPUHP_AP_KVM_STARTING to ONLINE section".

Paolo

