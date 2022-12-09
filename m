Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0772B63C5
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 16:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670605026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kutSohfRuT0cPTr7xUVGydvOQR8mvu7/B/e5xyo3DzI=;
	b=eBWMJhM3vrGrhy//bdsu2z9RtFNRqzp3cqXBcrkhgKC6M2cX1UvUnJgGOCUGVfUY5bV3Bi
	xkB5I5TkctHgflji4SAdAqxfNcKtH6/4+OCs1RSGfpHrZs6iruTVbXBCFmYXtlnH/2Pqpx
	n7Wb6XH464Cf7LyyuIWIjL8QTgWHJXw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-55-WyVSU2dNMWGadEagG3bOWg-1; Fri, 09 Dec 2022 11:57:05 -0500
X-MC-Unique: WyVSU2dNMWGadEagG3bOWg-1
Received: by mail-ed1-f70.google.com with SMTP id g14-20020a056402090e00b0046790cd9082so1727329edz.21
        for <kvmarm@lists.linux.dev>; Fri, 09 Dec 2022 08:57:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kutSohfRuT0cPTr7xUVGydvOQR8mvu7/B/e5xyo3DzI=;
        b=F97MrRMfaybuTYLu92BBE4JQDmw36T9MZpZtd+Bd0LfXoaUfZtQPH8Z2tMVcwHTXan
         /OB3fd0lGLbcfu5HhlEAjKB+aIF9FODmGRUGQ4B8ELaWiVblVX7bzuTiJhQDzqt8FaKz
         fVTol1lMNtVkSpx5cnPrNJXRI1P22PU3e2UTiIwmrtM5LfzppI6m7WKIyTu0vmCwVtcq
         hYJZhn266M1gvr15gBLK+AdWbb12N2sY7rjLWjwhG3sALR2ijMzxG/b7e4c6F5EoumnK
         igf1SlaSnKj2y6DhFGOrCd2AZxxIeLH+xtA87aYPzrDpsjQ6YlzHhFP3HJ3Vj3Nt5oun
         o71w==
X-Gm-Message-State: ANoB5pnJj5mUkcaXgLSLhWRqUdQ0nWxR/YHh2rNF2TW54HVBwJr9mDhx
	G63BWKZk2EcsSGFsoNuvLfg3zjd+9s2udEMgF85M5pD6Dbsqp6Wci60U1/2ZKbNKQxJ76kNp6dN
	2c4bLjcA+hxSu7s6K
X-Received: by 2002:a05:6402:183:b0:461:56b2:943 with SMTP id r3-20020a056402018300b0046156b20943mr5551452edv.40.1670605024481;
        Fri, 09 Dec 2022 08:57:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5xY78xD8gU/6JmFuYoh837GurNRUBVaPbDjK9T5d+0vb14K3ITW6tzQi++uHMCwlogdk44yg==
X-Received: by 2002:a05:6402:183:b0:461:56b2:943 with SMTP id r3-20020a056402018300b0046156b20943mr5551438edv.40.1670605024259;
        Fri, 09 Dec 2022 08:57:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id i21-20020a170906a29500b007af0f0d2249sm129159ejz.52.2022.12.09.08.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 08:57:03 -0800 (PST)
Message-ID: <5e51cf73-5d51-835f-8748-7554a65d9111@redhat.com>
Date: Fri, 9 Dec 2022 17:56:50 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Andrew Jones <andrew.jones@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Ben Gardon <bgardon@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck
 <cohuck@redhat.com>, Fuad Tabba <tabba@google.com>,
 Gavin Shan <gshan@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 James Morse <james.morse@arm.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Peter Collingbourne <pcc@google.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
 Quentin Perret <qperret@google.com>, Reiji Watanabe <reijiw@google.com>,
 Ricardo Koller <ricarkol@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Sean Christopherson <seanjc@google.com>, Steven Price
 <steven.price@arm.com>, Usama Arif <usama.arif@bytedance.com>,
 Vincent Donnefort <vdonnefort@google.com>, Will Deacon <will@kernel.org>,
 Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y5EK5dDBhutOQTf6@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5EK5dDBhutOQTf6@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221209165650.KSuUBArZyv0_zMMz3VYtdYEQe-iv60bbBJRnbmMy7Bs@z>

On 12/7/22 22:51, Oliver Upton wrote:
>>
>> I haven't pushed to kvm/next yet to give you time to check, so the
>> merge is currently in kvm/queue only.
> Have a look at this series, which gets things building and actually
> passing again:
> 
> https://lore.kernel.org/kvm/20221207214809.489070-1-oliver.upton@linux.dev/

Thank you!  Squashed 1-2 and applied 3-4.

Paolo

