Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128E9C3A5A7
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 21:43:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EA6D403E0;
	Tue,  6 Dec 2022 16:43:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bhz4EDvezSr3; Tue,  6 Dec 2022 16:43:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 203104B3F5;
	Tue,  6 Dec 2022 16:43:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CF0A4B3DF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 16:43:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0P8LRFGaSToM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 16:43:49 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55036403E0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 16:43:49 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670363028;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oHJEWJ+WSS46l6h0W3LMcSJJTcRn5AVH7TfKQIhjMnU=;
 b=P9kWAvKzrhDeN1dIVyTiGBdwz/6X5ALzxyg9S53pMPP/A62OEokEYVkxJzh3iJaICq5XPU
 VH4+zpOrS5Hl6aemwVbyJ3AknX0PF9cjhYxhOZdrf6HOY94dnXMgCG7dSvEOJylYy3jeoK
 LBwoADrPe/HHnxxnQIVVkVKM2Qi8zKQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-192-0NFrwBChPla840apQ6-DXA-1; Tue, 06 Dec 2022 16:43:47 -0500
X-MC-Unique: 0NFrwBChPla840apQ6-DXA-1
Received: by mail-ed1-f70.google.com with SMTP id
 b13-20020a056402350d00b00464175c3f1eso8685678edd.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Dec 2022 13:43:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=oHJEWJ+WSS46l6h0W3LMcSJJTcRn5AVH7TfKQIhjMnU=;
 b=kQeZIzbnABucnfdtGAwsNiPU0RCcFJ/K7ZHAfO8SyOLKRRKmpvPcpF/EnfWaIFeiR2
 vpfMAMs3sSTOeJ4ufsNlEDSdPQgUB8nyV86SnzwrBdvBpxf9MBsax9u9ga04NeYh+WhG
 CbxrGqrkQDxOLeLLlE/Hm27kHQdPE7Lc/vEWZfvKZGbQnHhZ+mi1m8iTUQhBkY7YlEFV
 qp0lmEAsnxtQvdOQuZBgUCoBYHWjm/5BJUy8qdoa5FVdTvLopbeYEl3UfU8C1PQI22c2
 0vOmOvjI4bv22lLFxpYBzQodB8NZY8q3uwZ5zkNdRFXyKrfV372P6+mSIacnetDR3qT9
 IonQ==
X-Gm-Message-State: ANoB5ply0LD2wUrgheGKgWizEjNU2agHsqF39fE6f/vD8kfVp9DZk0Eq
 jtrNJaT/g1+P/toRiRgrGDp7Pv3g5FDTW/PTORK3LxdekYgR3mTw3RpEt6RcP0ZMZoog2qatxpn
 TlzhmF7idEJhEq25n0ZSGqk0o
X-Received: by 2002:a17:906:504:b0:7b5:2d9f:4019 with SMTP id
 j4-20020a170906050400b007b52d9f4019mr64703401eja.536.1670363026704; 
 Tue, 06 Dec 2022 13:43:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7IVVqNkqhwDYPZmryDDbrQqHIHf09mWm2PR1kmcAht6bOcrhNU1Xv53JwT3gSmwfSoJHHbYg==
X-Received: by 2002:a17:906:504:b0:7b5:2d9f:4019 with SMTP id
 j4-20020a170906050400b007b52d9f4019mr64703352eja.536.1670363026398; 
 Tue, 06 Dec 2022 13:43:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 l9-20020a1709063d2900b0073d71792c8dsm7755776ejf.180.2022.12.06.13.43.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 06 Dec 2022 13:43:45 -0800 (PST)
Message-ID: <28e7f298-972b-2cb8-df80-951076724c73@redhat.com>
Date: Tue, 6 Dec 2022 22:43:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
To: Mark Brown <broonie@kernel.org>, Sean Christopherson <seanjc@google.com>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y4+FmDM7E5WYP3zV@google.com> <Y4+H5Vwy/aLvjqbw@sirena.org.uk>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y4+H5Vwy/aLvjqbw@sirena.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Usama Arif <usama.arif@bytedance.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Marek Szyprowski <m.szyprowski@samsung.com>, Marc Zyngier <maz@kernel.org>,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, kvmarm@lists.linux.dev,
 Peter Collingbourne <pcc@google.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
 Andrew Morton <akpm@linux-foundation.org>
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

On 12/6/22 19:20, Mark Brown wrote:
>> I almost suggested doing that on multiple occasions this cycle, but ultimately
>> decided not to because it would effectively mean splitting series that touch KVM
>> and selftests into different trees, which would create a different kind of
>> dependency hell.  Or maybe a hybrid approach where series that only (or mostly?)
>> touch selftests go into a dedicated tree?
>
> Some other subsystems do have a separate branch for kselftests.  One
> fairly common occurrence is that the selftests branch ends up failing to
> build independently because someone adds new ABI together with a
> selftest but the patches adding the ABI don't end up on the same branch
> as the tests which try to use them.  That is of course resolvable but
> it's a common friction point.

Yeah, the right solution is simply to merge selftests changes separately 
from the rest and use topic branches.

We will have more friction of this kind if we succeed in making more KVM 
code multi-architecture, so let's just treat selftests as the more 
innocuous drill...

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
