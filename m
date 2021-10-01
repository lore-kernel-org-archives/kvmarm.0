Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD93AC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 16:42:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53D1B61A6E
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 16:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 53D1B61A6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFEC04B0CC;
	Fri,  1 Oct 2021 12:42:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wP7KSDLf5yNe; Fri,  1 Oct 2021 12:42:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C01BA4B0B6;
	Fri,  1 Oct 2021 12:42:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04B0F49FE6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 12:42:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jouk8SLa5VOR for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 12:42:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26FA6407D1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 12:42:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633106553;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bKf6HNVdrrxE0cl0he0ADvO2+hNrL9mNvfSRy2hS5xg=;
 b=d24piMJR0XQ7dRtFXwsM+1iwK9gsnIj5UOO2qqMxcxrNJ/LR4+6FqofFF+MW0O1sSLeLzE
 UABBbKkoKDtAPYNugu1Vi8jnsmcTchoTfA84xjbuNTMw13f4iNA9tSPN3R9Alia8I98DKr
 V6MZlH4xavuMdZPu/6jtTrhFV0VHqKc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-UFM9XGt8NZCYSu3HDgbnhQ-1; Fri, 01 Oct 2021 12:42:28 -0400
X-MC-Unique: UFM9XGt8NZCYSu3HDgbnhQ-1
Received: by mail-ed1-f69.google.com with SMTP id
 x7-20020a50ba87000000b003dabd8354f1so6292265ede.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Oct 2021 09:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=bKf6HNVdrrxE0cl0he0ADvO2+hNrL9mNvfSRy2hS5xg=;
 b=FrHGFizjtwSq/j2eP7DN5zuDmPO0NDm1mtrD+iQsCi5rsZB4kfcO9x95KFSu2EJ80y
 Ce2PzAYgX8Rd1zEV3eUkS4OEh4U7OyV+i2SMmZg5p/Eln3Q5fMQYzU6ibZ9+2xz1Qxry
 522bWH/6kB1mvEkvpASr/7ZM7R8T00RaWY8VcuWudIEhNLk4VLUZQYjHlFBZCQuRDyfC
 drYjr4LVC46qC1fPDQNqCpczLtuk7L+aOdVMypGPwuuAT8sJ3rZhsvqyJs9DZ3aychE7
 i5Q2aKSpGvnwvwszCL6LzyNMclFE9fJTqKq4JM0e62v54c0q3uFFfUn176JinCQkl76X
 hXcg==
X-Gm-Message-State: AOAM533T5z2otZHtBd/cBZRaA0QBY2NAHTIxO/lHTakXc7gpSuQ72bG9
 j/dJkNZEbllkquCdW4OXsaLA/TA61oCckQFIEWpdsPZUSWjrS7HURfmWyuQ+JvkFVVGXsoxq68D
 49ZVJhZnmpk0qBomBKq2zzPTq
X-Received: by 2002:a17:906:369a:: with SMTP id
 a26mr7157440ejc.539.1633106547758; 
 Fri, 01 Oct 2021 09:42:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG7u5UEQd6wXYgj1iX7w961eI5iTHKv9Fm/E4iQVqpTwU2cNSgXa2csZS0bC0Jul9BytmVuQ==
X-Received: by 2002:a17:906:369a:: with SMTP id
 a26mr7157408ejc.539.1633106547580; 
 Fri, 01 Oct 2021 09:42:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id n22sm3171833eju.50.2021.10.01.09.42.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 01 Oct 2021 09:42:26 -0700 (PDT)
Message-ID: <eaf9b9ed-47b7-20a9-7d8b-14ab85fc5bcc@redhat.com>
Date: Fri, 1 Oct 2021 18:42:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
To: Oliver Upton <oupton@google.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <d88dae38-6e03-9d93-95fc-8c064e6fbb98@redhat.com>
 <746cfc82-ee7c-eba2-4443-7faf53baf083@redhat.com>
 <CAOQ_QsgmpsjKD7SVzX4ftOUkDtMF+egorOyNwG8wpYqw2h44pw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAOQ_QsgmpsjKD7SVzX4ftOUkDtMF+egorOyNwG8wpYqw2h44pw@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 01/10/21 17:39, Oliver Upton wrote:
>> Nevermind, KVM_SET_CLOCK is already rejecting KVM_CLOCK_TSC_STABLE so no
>> need to do that!
>
> Yeah, I don't know the story on the interface but it is really odd
> that userspace needs to blow away flags to successfully write the
> clock structure.

Yeah, let's fix it now and accept all three flags  I would like that, 
even though it cannot be fixed in existing kernels.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
