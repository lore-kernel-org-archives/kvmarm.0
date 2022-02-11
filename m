Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A099BC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 08:13:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1413B49F09;
	Fri, 11 Feb 2022 03:13:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3uRmczPeIrVF; Fri, 11 Feb 2022 03:13:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 395E149F32;
	Fri, 11 Feb 2022 03:13:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDEB149F32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 03:13:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZeRpUxs+rZJN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Feb 2022 03:13:51 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE71349F09
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 03:13:51 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1644567231;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OUVR/zoupdoX6+ubOzd6knBoEGVnkn4cOQdoBMCfCbw=;
 b=UKSxmPRqGMN2HQsjtYFNB8/C7uWKe7rx/wkh11bGUWQIVI7lXVvdWdUScnncF6oy180yRd
 ubB9H1mjMgVRGCh8fCerEKUrjPl8YNinVRWGEKpumslgGavW8iXPq3laMla3QWaIscZAQ2
 jnPvDb77Sapd3fyD89kED/NU+E+YXVY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-P8E9wMuqPIeJ4V8XJFRSBw-1; Fri, 11 Feb 2022 03:13:50 -0500
X-MC-Unique: P8E9wMuqPIeJ4V8XJFRSBw-1
Received: by mail-wm1-f71.google.com with SMTP id
 c7-20020a1c3507000000b0034a0dfc86aaso5546044wma.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 00:13:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=OUVR/zoupdoX6+ubOzd6knBoEGVnkn4cOQdoBMCfCbw=;
 b=qUSTug9fZpg0arf9C6x73OcDCd6OJONi1cOsTXCFZRuOFNGCIROuwTEL89Jc1gXIZf
 inIRVCj0MMGdF5qMVkSmfSvVX2MTVHnYt0XmDJ6iMGotBWoZoOYdxkXp8b2wKDmwUyGX
 kM7rCE7TX13kU75a1kwQqlsgBjksmlT+mXAJFNZKbMyFdWyhQNr3s8ZsNKUkLZ+3apto
 EYpRQ+tKIXn678oBIgBj2vtu7URZ5DTPll1/liYo7+0glnTzsEDZB+vIkIZBP3iCqDmm
 O/w4YFfwGy4VSMHWbFRQ3kc8YwJxSqwwIiVJNthucof/SfuXbt/G0OR2L1VynJgp1osa
 o46A==
X-Gm-Message-State: AOAM53169WJxqlWQ6jAPuvt0tdvDwQweii/qIAs75o9R5rO/JsDPKq7v
 0iGTJHHKnvhATfmDh6maHHLXjzUiqAYgYCAP5MWj9KDG/E7gXuhoyW0naz8bdImvN6TKN8uFOx6
 krqdq4jGLNipEx9/RxazH2/pc
X-Received: by 2002:a05:600c:4295:: with SMTP id
 v21mr1158172wmc.19.1644567229080; 
 Fri, 11 Feb 2022 00:13:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFDwMOqNhdLMmzCS9As9GMXonsgOfpQhipriYO985eA+t9E1y7/H8f0Oa+d3sbWGyRVAQfEA==
X-Received: by 2002:a05:600c:4295:: with SMTP id
 v21mr1158150wmc.19.1644567228874; 
 Fri, 11 Feb 2022 00:13:48 -0800 (PST)
Received: from [192.168.8.104] (tmo-098-218.customers.d1-online.com.
 [80.187.98.218])
 by smtp.gmail.com with ESMTPSA id l28sm19947430wrz.90.2022.02.11.00.13.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Feb 2022 00:13:48 -0800 (PST)
Message-ID: <f326daff-8384-4666-fc5e-6b7b509f6fe8@redhat.com>
Date: Fri, 11 Feb 2022 09:13:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
To: Zixuan Wang <zxwang42@gmail.com>, Sean Christopherson <seanjc@google.com>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com> <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
 <YgVpJDIfUVzVvFdx@google.com>
 <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=thuth@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
 Paolo Bonzini <pbonzini@redhat.com>, Varad Gautam <varad.gautam@suse.com>
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

On 10/02/2022 20.48, Zixuan Wang wrote:
> On Thu, Feb 10, 2022 at 11:36 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Thu, Feb 10, 2022, Zixuan Wang wrote:
>>> On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
>>> <alexandru.elisei@arm.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
>>>>> On Thu, Feb 10, 2022, Alexandru Elisei wrote:
>>>>>> I renamed --target-efi to --efi-payload in the last patch because I felt it
>>>>>> looked rather confusing to do ./configure --target=qemu --target-efi when
>>>>>> configuring the tests. If the rename is not acceptable, I can think of a
>>>>>> few other options:
>>>>>
>>>>> I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
>>>>> seems like it would be sufficient.
>>>>>
>>>>>> 1. Rename --target to --vmm. That was actually the original name for the
>>>>>> option, but I changed it because I thought --target was more generic and
>>>>>> that --target=efi would be the way going forward to compile kvm-unit-tests
>>>>>> to run as an EFI payload. I realize now that separating the VMM from
>>>>>> compiling kvm-unit-tests to run as an EFI payload is better, as there can
>>>>>> be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
>>>>>> a test runner, so I think the impact on users should be minimal.
>>>>>
>>>>> Again irrespective of --target-efi, I think --target for the VMM is a potentially
>>>>> confusing name.  Target Triplet[*] and --target have specific meaning for the
>>>>> compiler, usurping that for something similar but slightly different is odd.
>>>>
>>>> Wouldn't that mean that --target-efi is equally confusing? Do you have
>>>> suggestions for other names?
>>>
>>> How about --config-efi for configure, and CONFIG_EFI for source code?
>>> I thought about this name when I was developing the initial patch, and
>>> Varad also proposed similar names in his initial patch series [1]:
>>> --efi and CONFIG_EFI.
>>
>> I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
>> configure option and is familiar for kernel developers.  But for the actually
>> option, why require more typing?  I really don't see any benefit of --config-efi
>> over --efi.
> 
> I agree, --efi looks better than --target-efi or --config-efi.

<bikeshedding>
Or maybe --enable-efi ... since configure scripts normally take 
"--enable-..." or "--disable-..." parameters for stuff like this?
</bikeshedding>

  Thomas

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
