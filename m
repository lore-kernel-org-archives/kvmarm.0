Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FA9C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 06:45:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD12C20829
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 06:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTxNMcbb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD12C20829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA464B439;
	Fri, 31 Jul 2020 02:45:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LCZQpjSvBekJ; Fri, 31 Jul 2020 02:45:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C0444B449;
	Fri, 31 Jul 2020 02:45:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BA664B447
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 02:45:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OLLZflOdbiuW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 02:45:01 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1325B4B439
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 02:45:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596177900;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=akcf5o31IxmDQVV9nGhhRCpgu422ncpTC7D3b7rqbA4=;
 b=KTxNMcbb+M3BiDFUP3MTUs52R6f5/LgzLO4WVApA/7IEjJazaqbvQ1rYhKw79jig5uwEOB
 C5oPB25BMMfm3u776OR1o8QXSfi32vTvF74xWryFVEoKfxeAukSTLdSVj3sxtzz7OgSBth
 SqW+m7950k3paJ6S5Fu5bp+IILF1jKQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-H4b3tlzpNteG5ktiq7Gbug-1; Fri, 31 Jul 2020 02:44:58 -0400
X-MC-Unique: H4b3tlzpNteG5ktiq7Gbug-1
Received: by mail-wm1-f70.google.com with SMTP id u14so1765417wml.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 23:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=akcf5o31IxmDQVV9nGhhRCpgu422ncpTC7D3b7rqbA4=;
 b=YSTlGPgbhj73yM/9wMgk05/GjOi4KNfdSFlJzhqxK+BkSqwbQvavh94lXssKhyIe4M
 OeOENhzKroGdR7+V2t6NJlfTgaC29BgmcCkNScDzoWow9yFp53ndLLJT05s7N8U5y6PG
 8vleQAYHGTnn6+PoVKc4Nzwez39QVrY4IiONVKsG/clzm9YvdWLy3EK0bfaBMOudsz9d
 qTBvZDkgEmPRU46rlXoHroYaamyV4Kwohi3cqT27AExQXQfzdqmUczFzPDM1eCwy79y2
 GQ1NQmUMLgVgNXkpCT0/yyVuiIgZBS8DEAnBJJRVL5ILsXO7dx1m+rYpbLjYHDJs+7Nm
 aPnw==
X-Gm-Message-State: AOAM530TmIVmpiFeO9APFAmMv+SElSYp+M7brG3rKduCs2XSW9hIog9F
 /AyzONt5gwp3uayHZDc536ypTwFXt+tJX11vHKCjKpDC7VlaU6rSLpA9HNPDJVYW6XRNEnwSra+
 bBt60wsOrhLz/Te21saBciW8O
X-Received: by 2002:a5d:4109:: with SMTP id l9mr2102414wrp.398.1596177897800; 
 Thu, 30 Jul 2020 23:44:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxb5GRvfk7uYiQKiLNWu3grzIfY78jWIsuxWLgPwULOyAUG8/2c+Tmj75lzVnz9+VNZS5ExPA==
X-Received: by 2002:a5d:4109:: with SMTP id l9mr2102394wrp.398.1596177897568; 
 Thu, 30 Jul 2020 23:44:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:90a5:f767:5f9f:3445?
 ([2001:b07:6468:f312:90a5:f767:5f9f:3445])
 by smtp.gmail.com with ESMTPSA id 32sm14850330wrh.18.2020.07.30.23.44.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Jul 2020 23:44:57 -0700 (PDT)
Subject: Re: [Question] the check of ioeventfd collision in
 kvm_*assign_ioeventfd_idx
To: Zhenyu Ye <yezhenyu2@huawei.com>
References: <bbece68b-fb39-d599-9ba7-a8ee8be16525@huawei.com>
 <CABgObfbFXYodCeGWSnKw0j_n2-QLxpnD_Uyc5r-_ApXv=x+qmw@mail.gmail.com>
 <4aa75d90-f2d2-888c-8970-02a41f3733e4@huawei.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cffcf9e1-6675-6815-ccfc-f48497ade818@redhat.com>
Date: Fri, 31 Jul 2020 08:44:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4aa75d90-f2d2-888c-8970-02a41f3733e4@huawei.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, "S. Tsirkin,
 Michael" <mst@redhat.com>, linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 31/07/20 08:39, Zhenyu Ye wrote:
> On 2020/7/31 2:03, Paolo Bonzini wrote:
>> Yes, I think it's not needed. Probably the deassign check can be turned into an assertion?
>>
>> Paolo
>>
> 
> I think we can do this in the same function, and turnt he check of
> p->eventfd into assertion in kvm_deassign_ioeventfd_idx(). Just like:
> 
> ---8<---
> static inline struct _ioeventfd *
> get_ioeventfd(struct kvm *kvm, enum kvm_bus bus_idx,
>               struct kvm_ioeventfd *args)
> {
>         static struct _ioeventfd *_p;
>         bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
> 
>         list_for_each_entry(_p, &kvm->ioeventfds, list)
>                 if (_p->bus_idx == bus_idx &&
>                     _p->addr == args->addr &&
>                     (!_p->length || !args->len ||
>                      (_p->length == args->len &&
>                       (_p->wildcard || wildcard ||
>                        _p->datamatch == args->datamatch))))
>                         return _p;
> 
>         return NULL;
> }
> 
> kvm_deassign_ioeventfd_idx() {
> 	...
> 	p = get_ioeventfd(kvm, bus_idx, args);
> 	if (p) {
> 		assert(p->eventfd == eventfd);
> 		...
> 	}
> 
> ---8<----
> 
> This may be easier to understand (keep the same logic in assign/deassign).

I think you should also warn if:

1) p->length != args->len

2) p->wildcard != args->wildcard if p->length

3) p->datamatch != args->datamatch if p->length && !p->wildcard

but yeah it sounds like a plan.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
