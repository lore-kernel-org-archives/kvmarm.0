Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B82BC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 14:41:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E72961A03
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 14:41:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7E72961A03
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F39D34B0DF;
	Fri,  1 Oct 2021 10:41:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3eOWCAVll7wb; Fri,  1 Oct 2021 10:41:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 001034B091;
	Fri,  1 Oct 2021 10:41:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0479F4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 10:41:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 93Ihkc6qsh9u for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 10:41:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0391E4A534
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 10:41:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633099297;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XkkeMCPL2Vp7JorOEy5gw2lNiI4B4lS4i/E97mBslbc=;
 b=CnYxq89RKdbG0tm6sJ5O933RmGmynw9lpNuRdFXPWHkn54vsjoy6QmoYh8Pat428PoZo+S
 tmdccellJqdcZcNoVj+BV+gBixL4OwSEfyJ/fP1yXXqKqG6A8nu1bqk7uycBhO0PeysmRP
 2v895stSBz55zbaYQ+OKUmQ7pX/fcwY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-YIGLwvNdPdCm03-i805TnA-1; Fri, 01 Oct 2021 10:41:36 -0400
X-MC-Unique: YIGLwvNdPdCm03-i805TnA-1
Received: by mail-ed1-f72.google.com with SMTP id
 h8-20020a50cdc8000000b003dad77857f7so858383edj.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Oct 2021 07:41:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:from:to:cc:references:in-reply-to
 :content-transfer-encoding;
 bh=XkkeMCPL2Vp7JorOEy5gw2lNiI4B4lS4i/E97mBslbc=;
 b=q6DhwmoCWbIblnXrRuU/2/draY9syJPEGCNRpf88/zCVQ7mBuTRUZeFltNXTnkqHfM
 x7+b+7idQxdyqDuh49WsThYtMN4Ec6ooZcho8OGShRR68OKAZ552tq4zVaBxNVkUVA8L
 vUVssIRt5b32X+nVAfy3oYVJMVWqszjsEVVVBfL7M5OCgn2li3KQv7olgyVfwhPD5jbn
 JU5tM11sAlKa74NAKwtUp42buLNrTvllaIMHUpWzFGqob2x6AjND3zVxk7xheegc//Kv
 +YQ9OT1pNI9UWwGwztZrPHeGG+iQBZXKNRCjTiG744v9YBMxifQ7KRGq53U5GKHBKQO/
 ycXQ==
X-Gm-Message-State: AOAM532gl/f2xLdsFSsgCpIRX2qXtQYAhtSFj2Xg8rUU/RG2IgolVTud
 8L6e5c05FohpjMP7vol140BAFjnl1HyOGqBwdgZSdPo2OGtPN5q0U1KScYWWh7K5Sj3hwKH1m9C
 tKTb+5dMQauQnHZR/fqaPILx7
X-Received: by 2002:a05:6402:1d9c:: with SMTP id
 dk28mr9728529edb.241.1633099295531; 
 Fri, 01 Oct 2021 07:41:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIscIfxGLMs/yfLoygqBiGNTRk5EVkFolzj6ew78/IWPq8S7bQHiwT65Cmf2dESwTn0KKxSQ==
X-Received: by 2002:a05:6402:1d9c:: with SMTP id
 dk28mr9728502edb.241.1633099295343; 
 Fri, 01 Oct 2021 07:41:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id jl12sm2938613ejc.120.2021.10.01.07.41.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 01 Oct 2021 07:41:34 -0700 (PDT)
Message-ID: <746cfc82-ee7c-eba2-4443-7faf53baf083@redhat.com>
Date: Fri, 1 Oct 2021 16:41:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
From: Paolo Bonzini <pbonzini@redhat.com>
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <d88dae38-6e03-9d93-95fc-8c064e6fbb98@redhat.com>
In-Reply-To: <d88dae38-6e03-9d93-95fc-8c064e6fbb98@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMDEvMTAvMjEgMTY6MzksIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4gT24gMTYvMDkvMjEgMjA6
MTUsIE9saXZlciBVcHRvbiB3cm90ZToKPj4gK8KgwqDCoCBpZiAoZGF0YS5mbGFncyAmIH5LVk1f
Q0xPQ0tfUkVBTFRJTUUpCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiAK
PiBMZXQncyBhY2NlcHQgS1ZNX0NMT0NLX0hPU1RfVFNDIGhlcmUgZXZlbiB0aG91Z2ggaXQncyBu
b3QgdXNlZDsgdGhlcmUgCj4gbWF5IGJlIHByb2dyYW1zIHRoYXQgZXhwZWN0IHRvIHNlbmQgYmFj
ayB0byBLVk1fU0VUX0NMT0NLIHdoYXRldmVyIHRoZXkgCj4gZ290IGZyb20gS1ZNX0dFVF9DTE9D
Sy4KCk5ldmVybWluZCwgS1ZNX1NFVF9DTE9DSyBpcyBhbHJlYWR5IHJlamVjdGluZyBLVk1fQ0xP
Q0tfVFNDX1NUQUJMRSBzbyBubyAKbmVlZCB0byBkbyB0aGF0IQoKUGFvbG8KCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
