Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F702C636CE
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97F906121F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97F906121F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B4954B108;
	Wed, 21 Jul 2021 08:20:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6K6zCYY89GGK; Wed, 21 Jul 2021 08:20:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55EAE4B147;
	Wed, 21 Jul 2021 08:20:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D8B94B100
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 07:57:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aGF7DSrACo4B for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 07:57:14 -0400 (EDT)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 599F74B0FF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 07:57:14 -0400 (EDT)
Received: by mail-pg1-f178.google.com with SMTP id i16so1623918pgi.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 04:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=to:cc:references:from:subject:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=1aayxhP7LR5pbpYNWPExB3m6iym6gHf5XQMlRKlxp94=;
 b=Gb3sYMtxc/kWDCMnCmYUN5o70Tvt9W/hvjABaQVw6GepiW6AF7jJcANbzNBRV1gq0H
 KVgsqId2MY+RXzDpDGY6dPw0M9zOWZUAQNGPy7PM2rys/HzrGgdYJ1JWxUE1QI9btZVV
 O6Nge5AQbsqTmzXcQomJIje10kgbOVDLOw6CAEgavNSXA2gO45gvZInn+kY7JYMZv+qO
 7oKYPWFeZHS6IplBXQIb7MGoEHkzU7p7v5SEAUS6Qb0XpyY5ciKG5wbqqw5mBV2thXmN
 kc5wkdciG83RddYCL0ig7AXvXY6vLlAn6fNTtakKWWWjb2B/kLBoNRRLEWJHhmSw7M5h
 laRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=1aayxhP7LR5pbpYNWPExB3m6iym6gHf5XQMlRKlxp94=;
 b=ofY78W1gejSJrSE1N9COG/HXMw6HrRgWRXO9PHcKAsx2sd3LZ8TLlgaNxjfSVvUwac
 xNQynS4c5xVaL7TwDWjKMDmPHWZKo40caELvHZjnbumMAUluTAhEY6zdT40byUen6NZn
 VyCRzWwdPQ9lphOj4ZyT3KeU0xK7SCcL4xtT5hGiXctyrdh3ACuxkpOJtYtF06EK/tDI
 njdiiSNJE21c+mv2Tph6M05UVsgBe6wUPzE2yrhXf5CxvIFBqfS8EslBhebcA/cf7nn+
 K2PyKEnCy9aNxU5FcYfBNObLSLCKvIDQdJLRKcNKEUcir0MSwnmIhqvBulXwSK7Qj4qN
 QPUw==
X-Gm-Message-State: AOAM5327BWgp5DDOO9TKVsjzZbmitCZEZ7kU/c8YJMTxLHbMaXOrkIKO
 XSP4JmiwXgUpCul/AoFqtdA=
X-Google-Smtp-Source: ABdhPJx8Jc6D+8J2xe+jplPG6WjflufBXyqLNydLZmg9K2ukmxfm1tClEJcFPfqxf5GDpWMtdTO8gQ==
X-Received: by 2002:a63:a01:: with SMTP id 1mr35267098pgk.360.1626868633306;
 Wed, 21 Jul 2021 04:57:13 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
 by smtp.gmail.com with ESMTPSA id j12sm25930570pfj.208.2021.07.21.04.57.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 21 Jul 2021 04:57:12 -0700 (PDT)
To: Zhu Lingshan <lingshan.zhu@intel.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
 <20210716085325.10300-2-lingshan.zhu@intel.com>
From: Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH V8 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <fd117e37-8063-63a4-43cd-7cb555e5bab5@gmail.com>
Date: Wed, 21 Jul 2021 19:57:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210716085325.10300-2-lingshan.zhu@intel.com>
Content-Language: en-US
X-Mailman-Approved-At: Wed, 21 Jul 2021 08:20:04 -0400
Cc: wanpengli@tencent.com, Like Xu <like.xu@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, eranian@google.com,
 Guo Ren <guoren@kernel.org>, linux-riscv@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kan.liang@linux.intel.com, ak@linux.intel.com, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, joro@8bytes.org, x86@kernel.org,
 linux-csky@vger.kernel.org, wei.w.wang@intel.com,
 linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org,
 liuxiangdong5@huawei.com, bp@alien8.de,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, boris.ostrvsky@oracle.com,
 jmattson@google.com, Nick Hu <nickhu@andestech.com>, seanjc@google.com,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 vkuznets@redhat.com
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

T24gMTYvNy8yMDIxIDQ6NTMgcG0sIFpodSBMaW5nc2hhbiB3cm90ZToKPiArCX0gZWxzZSBpZiAo
eGVucG11X2RhdGEtPnBtdS5yLnJlZ3MuY3BsICYgMykKCkxpbmdzaGFuLCBzZXJpb3VzIGZvciB0
aGlzIHZlcnNpb24gPwoKYXJjaC94ODYveGVuL3BtdS5jOjQzODo5OiBlcnJvcjogZXhwZWN0ZWQg
aWRlbnRpZmllciBvciDigJgo4oCZIGJlZm9yZSDigJhyZXR1cm7igJkKICAgNDM4IHwgICAgICAg
ICByZXR1cm4gc3RhdGU7CiAgICAgICB8ICAgICAgICAgXn5+fn5+CmFyY2gveDg2L3hlbi9wbXUu
Yzo0Mzk6MTogZXJyb3I6IGV4cGVjdGVkIGlkZW50aWZpZXIgb3Ig4oCYKOKAmSBiZWZvcmUg4oCY
feKAmSB0b2tlbgogICA0MzkgfCB9CiAgICAgICB8IF4KYXJjaC94ODYveGVuL3BtdS5jOiBJbiBm
dW5jdGlvbiDigJh4ZW5fZ3Vlc3Rfc3RhdGXigJk6CmFyY2gveDg2L3hlbi9wbXUuYzo0MzY6OTog
ZXJyb3I6IGNvbnRyb2wgcmVhY2hlcyBlbmQgb2Ygbm9uLXZvaWQgCmZ1bmN0aW9uIFstV2Vycm9y
PXJldHVybi10eXBlXQogICA0MzYgfCAgICAgICAgIH0KICAgICAgIHwgICAgICAgICBeCmNjMTog
c29tZSB3YXJuaW5ncyBiZWluZyB0cmVhdGVkIGFzIGVycm9ycwoKPiArCQkJc3RhdGUgfD0gUEVS
Rl9HVUVTVF9VU0VSOwo+ICAgCX0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
