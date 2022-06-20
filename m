Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A874AC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 12:04:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48BDB4B4EF;
	Mon, 20 Jun 2022 08:04:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id axjQv-zhLaU6; Mon, 20 Jun 2022 08:04:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AE854B4C9;
	Mon, 20 Jun 2022 08:04:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 985B54B4BC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:04:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 79lJHr9Hnbyu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 08:04:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DBCF4B4BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:04:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655726690;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=IUXmv+GsqzyvnhaDhp9YkGYuGwZ5GKnH9Fu0vf0lnGk=;
 b=BZVfVK3ARnkoVgmicrv6tjEkixtLpDpOTjuFNwrvWnVkYudIFMEn4RbhUu/q2C+5CoX9Yf
 ElomPeUm//+T4csrdXXxvkW80CkQLWVxO6Wzfwp8UbYm4HuhGQXBq4ohs1Ne9U5bGpODVJ
 k+boQLI95+m88+r2/U3W3OjPsEpiAQU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-bWHRdnbtOpK_JkhDpYpItg-1; Mon, 20 Jun 2022 08:04:48 -0400
X-MC-Unique: bWHRdnbtOpK_JkhDpYpItg-1
Received: by mail-ed1-f71.google.com with SMTP id
 s15-20020a056402520f00b004327f126170so8582816edd.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 05:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=IUXmv+GsqzyvnhaDhp9YkGYuGwZ5GKnH9Fu0vf0lnGk=;
 b=xHN3+Q5kpqU+A/59E8txnR2K5B8zMrMiuw8O8atXjkRNfQNQHuXuBagx5nM9jRwKz9
 /yDe1oUpETobQFi5+8CGN1hdC9HUWqPz2U0mg2vYXXS+Q8Eqa28ZcpnMsDTP3+jfmxbX
 OXTwqPrtb2TA1nnKcrEpGYtjmYAWbTignrLyshrqKKH/A2kxwnmIXOFac+3tBiHLvFxS
 ISZ/wNEWair8m6BPMmYdbCwgXA+CezaXxjqHCJ9G2m3UCU2F2RV0oS1VzsxQeMwTuApb
 bfnDW0S6e2Km0JmJVXx2IvzOQ2dKMjJu2Gp775NmFKo3oTe85L0OpErjIecm8VOvBisv
 cQkw==
X-Gm-Message-State: AJIora9lIrC9zyWEGBUr1OC2H3ZB1ygcuy2OgG3nRiJ0RU2YZ9zibtgH
 3HHNC7RVhdlFGuAtSuKe1IaRd2+aZYHWR+aJTzosTTdc+vr7jSZqvhitiTpKEsKqrecOR8aY8j/
 rdlco4b1GJxXTHm6FpdIr5y8A
X-Received: by 2002:a17:906:51c6:b0:712:2a1a:afc8 with SMTP id
 v6-20020a17090651c600b007122a1aafc8mr21439963ejk.649.1655726687696; 
 Mon, 20 Jun 2022 05:04:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uc7990kaGVy2NBjJ6jUWCy9T1osk/a++J5cKPnIJZesaYbWIXlQk2enQG7zkinbsWXRGeDWQ==
X-Received: by 2002:a17:906:51c6:b0:712:2a1a:afc8 with SMTP id
 v6-20020a17090651c600b007122a1aafc8mr21439934ejk.649.1655726687452; 
 Mon, 20 Jun 2022 05:04:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 o2-20020a170906768200b0070b8a467c82sm5876491ejm.22.2022.06.20.05.04.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 20 Jun 2022 05:04:46 -0700 (PDT)
Message-ID: <2fc82066-f092-bc19-ae69-6852820f41ef@redhat.com>
Date: Mon, 20 Jun 2022 14:04:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 4/4] KVM: selftests: Fix filename reporting in guest
 asserts
To: Andrew Jones <drjones@redhat.com>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-5-coltonlewis@google.com>
 <20220616124519.erxasor4b5t7zaks@gator>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220616124519.erxasor4b5t7zaks@gator>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: thuth@redhat.com, kvm@vger.kernel.org, g@gator, maz@kernel.org,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On 6/16/22 14:45, Andrew Jones wrote:
>> +#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {	\
>> +		if (!(_condition))					\
>> +			ucall(UCALL_ABORT, GUEST_ASSERT_BUILTIN_NARGS + _nargs,	\
>> +			      "Failed guest assert: " _condstr,		\
>> +			      __FILE__,					\
>> +			      __LINE__,					\
>> +			      ##_args);					\
> We don't need another level of indentation nor the ## operator on _args.
> 

The ## is needed to drop the comma if there are no _args.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
