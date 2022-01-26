Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0D2C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 15:52:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 757344B091;
	Thu, 27 Jan 2022 10:52:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QkXX8IFZTvll; Thu, 27 Jan 2022 10:52:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6A184B0B6;
	Thu, 27 Jan 2022 10:52:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B7FA408D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 15:50:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zy0d9+EdsLf4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 15:50:40 -0500 (EST)
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com
 [209.85.166.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08ADA408D1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 15:50:39 -0500 (EST)
Received: by mail-il1-f179.google.com with SMTP id z7so763662ilb.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=g1rJEPs0w7TbjO5LiluyOsT70KWk/Gaa2amZ6SzJSNg=;
 b=LuTGWXQWifwYDRK0Ygp4ORRKoXWDKfu7JXpfxYvH6+xWS0MeZ9A4AfeBilXSkvtRDh
 znkkYjymaQGxlMvI2lgPErqRP7a/jxHudidDzFapBEmfCM2qCLbzzch1gj9urnz+FMnL
 Lmh0myULWkTSD9DSPqbNzQPld8cp0zd1ZYqV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=g1rJEPs0w7TbjO5LiluyOsT70KWk/Gaa2amZ6SzJSNg=;
 b=dl0ztsU2XJ1ZN2gZjsgCyvjBGDspKSH89WXgsQVubcL1bKbzQECZ9TM6wp6Ntelv8X
 AXqEjqPrmpZou/yJdhA2cmb1ujzvQNQgI64e0ouFfthPKT9RfKTxtzK3W161QY+Sx96p
 szmdTLrAXqAwACCUY6/1oLothM2OhVZc/66FGEh0mfbUZU6Lw0HT5TYFja6tpfgzV8Xt
 nE3PLOVKmbWlpOsLP9MAJbGsDqK4vh5Ypv6x7gfQNqRM00w60JqSTRJscqlA0GvUkcAg
 jmTOe6VuVPwH31G+TDZkSYY6i1PpmnDNDTPiIoaGkv0RPfS2Yf93V56YoBeSaBdaf4GP
 M1bw==
X-Gm-Message-State: AOAM532LWqGoPTrIiyjExPAW4bHK6DOpNPdjPfSyZfYfgDJ2OLytLMA8
 PdX3tc1rJN9nZYudbFgju3WI1A==
X-Google-Smtp-Source: ABdhPJzLASiBQ1mqUUkmTRKw+Qt83yRsQOKnC9rpNhp0UwVvoRvgbqpJPBIXvFLNV8BTOFeyn3PSHw==
X-Received: by 2002:a92:d4ce:: with SMTP id o14mr645706ilm.218.1643230239216; 
 Wed, 26 Jan 2022 12:50:39 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id f2sm11441452ilu.79.2022.01.26.12.50.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 26 Jan 2022 12:50:38 -0800 (PST)
Subject: Re: [PATCH v3] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
To: Mark Brown <broonie@kernel.org>
References: <20220126145242.3473836-1-broonie@kernel.org>
 <4424dd30-f74b-006f-b540-dbaf02e45e28@linuxfoundation.org>
 <YfGmk1I8l+ROoE/k@sirena.org.uk>
 <48c44d74-6668-7823-ada6-0285a8b32a35@linuxfoundation.org>
 <YfGrXr1/NGREULnB@sirena.org.uk>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2e9162ef-6107-e56c-e713-1f1ac7f83003@linuxfoundation.org>
Date: Wed, 26 Jan 2022 13:50:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YfGrXr1/NGREULnB@sirena.org.uk>
Content-Language: en-US
X-Mailman-Approved-At: Thu, 27 Jan 2022 10:52:41 -0500
Cc: Marc Zyngier <maz@kernel.org>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 1/26/22 1:13 PM, Mark Brown wrote:
> On Wed, Jan 26, 2022 at 01:03:44PM -0700, Shuah Khan wrote:
>> On 1/26/22 12:52 PM, Mark Brown wrote:
> 
>>> If the function fails for any reason other than the system not
>>> supporting vgic-v3 it will abort rather than return.
> 
>> Hmm. vgic_v3_setup() return gic_fd looks like and the interface says
>> Return: GIC file-descriptor or negative error code upon failure
> 
> Yes, but in reality the only return other than a valid file descriptor
> is just -1 rather than a useful error code.
> 

The interface document gives the impression that it will return
error - Oh well. In which case, no point in printing that. Agree.

>> I don't follow the abort part.
> 
> All the TEST_ASSERTS() in the code (including those in the functions
> called) are calls to test_assert() in assert.c which if the test
> asserted isn't true will print some diagnostics and call exit(), the
> general idiom is to give up immediately on error.
> 

Ah right. Makes sense.

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
