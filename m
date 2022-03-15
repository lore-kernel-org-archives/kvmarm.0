Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A8AC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 14:21:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 350E44076A;
	Tue, 15 Mar 2022 10:21:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wEFsqCuuDUm3; Tue, 15 Mar 2022 10:21:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 097764086C;
	Tue, 15 Mar 2022 10:21:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57DB24086C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 10:21:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XBXeacVt95gx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 10:21:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1CEA4076A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 10:21:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647354106;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7o+dVXIRX3PUfrylBhmOJ1IjtNvLAddRpzAp+y2JIUg=;
 b=MiOkir14g9qIfFuz6ae5vo/JvxKQqqpQ+x+fbiVTiBRHHFutfvggphSgkixjxIU1UFv8vA
 oSQKkb9YGWKNK2TX3e/UvdQE0n/tjZlYQo6jzyKPOtqe2v1BtAiOZx8ZFrzKSZEJ+rGbAt
 oBIrMGRb6y9oQSwHiQ/zbpWPUoUU+LU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-LIQ6nwmKNQ-NdrGETcQd0A-1; Tue, 15 Mar 2022 10:21:44 -0400
X-MC-Unique: LIQ6nwmKNQ-NdrGETcQd0A-1
Received: by mail-wm1-f72.google.com with SMTP id
 r133-20020a1c448b000000b00385c3f3defaso6705252wma.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 07:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=7o+dVXIRX3PUfrylBhmOJ1IjtNvLAddRpzAp+y2JIUg=;
 b=hpx50rD4uTQe/OSDOLRLL3Cm21PfsYtqbHRlw5saIhAYHxTVLYQOu9+QJCpYgbP/VQ
 obW9l6Y0vW4YSkKAE5acamM6sTLAGOl6U97AuPoO5DHLgKpXunzex5f2S32EWap9wGpL
 X18oWt394Yz/1nuQ1U74ZS9/CSlGgXN9s9O3BIBplJZSm44CvEk0zh7uHYyvQwmdQ05u
 D+YQI/hIA2LrAYmRGbzt1BwNmSTgmqftXuzVvwUvJrMZ9u034P+DHgYqoTtM6Bd8y5EX
 Ttu0H7uUsbt6qUq0KVkagir7sKv7yX5mNxI4Pt+NVguxC6No0/lHaE23veIkw8MpWBpK
 4Mbw==
X-Gm-Message-State: AOAM533dovnO4EKAvBoLdO8UaSUDXsyRw1mjBgmYAxJheKD59dihzl+Y
 QTLzWz1R8fCCvPBxnL+pcLHRcQC1C87U9YeVE9UjE1VEwqKgKxCV/MKhVogXJ6MSsz6MmUKOG4d
 +HdDxO39Yv6hVh3nBWRKgf7bh
X-Received: by 2002:a05:600c:4296:b0:38c:1b43:1562 with SMTP id
 v22-20020a05600c429600b0038c1b431562mr1352862wmc.122.1647354102766; 
 Tue, 15 Mar 2022 07:21:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK6Yb1VdEQLbeaGqI3HGFeG6+S8T9reHNHXB33jwMdYCBjxnxNe7ZZesEpwCLsV4703roQaw==
X-Received: by 2002:a05:600c:4296:b0:38c:1b43:1562 with SMTP id
 v22-20020a05600c429600b0038c1b431562mr1352843wmc.122.1647354102505; 
 Tue, 15 Mar 2022 07:21:42 -0700 (PDT)
Received: from [192.168.8.104] (tmo-098-218.customers.d1-online.com.
 [80.187.98.218]) by smtp.gmail.com with ESMTPSA id
 c24-20020a7bc018000000b0038a18068cf5sm2363742wmb.15.2022.03.15.07.21.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 15 Mar 2022 07:21:41 -0700 (PDT)
Message-ID: <b1d5e4b7-c07c-0e34-ef6d-58aab19a41b2@redhat.com>
Date: Tue, 15 Mar 2022 15:21:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
To: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
 drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=thuth@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

On 15/03/2022 14.33, Alexandru Elisei wrote:
> Hi,
> 
> Arm is planning to upstream tests that are being developed as part of the
> Confidential Compute Architecture [1]. Some of the tests target the
> attestation part of creating and managing a confidential compute VM, which
> requires the manipulation of messages in the Concise Binary Object
> Representation (CBOR) format [2].
> 
> I would like to ask if it would be acceptable from a license perspective to
> include the QCBOR library [3] into kvm-unit-tests, which will be used for
> encoding and decoding of CBOR messages.
> 
> The library is licensed under the 3-Clause BSD license, which is compatible
> with GPLv2 [4]. Some of the files that were created inside Qualcomm before
> the library was open-sourced have a slightly modified 3-Clause BSD license,
> where a NON-INFRINGMENT clause is added to the disclaimer:
> 
> "THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
> WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
> ARE DISCLAIMED" (emphasis by me on the added clause).
> 
> The files in question include the core files that implement the
> encode/decode functionality, and thus would have to be included in
> kvm-unit-tests. I believe that the above modification does not affect the
> compatibility with GPLv2.

IANAL, but I think it should be ok to add those files to the kvm-unit-tests. 
With regards to the "non-infringement" extension, it seems to be the one 
mentioned here: https://enterprise.dejacode.com/licenses/public/bsd-x11/ ... 
and on the "license condition" tab they mention that it is compatible with 
the GPL. On gnu.org, they list e.g. the 
https://www.gnu.org/licenses/license-list.html#X11License which also 
contains a "non-infringement" statement, so that should really be compatible.

  Thomas

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
