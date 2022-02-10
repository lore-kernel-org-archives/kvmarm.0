Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3E5C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 15:32:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B86E749F2A;
	Thu, 10 Feb 2022 10:32:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wCGPm6FlLPPs; Thu, 10 Feb 2022 10:32:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DD9749F33;
	Thu, 10 Feb 2022 10:32:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0B0049E42
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 10:12:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ygH0iGoIELoK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 10:12:45 -0500 (EST)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
 [209.85.166.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D47C149E08
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 10:12:45 -0500 (EST)
Received: by mail-io1-f41.google.com with SMTP id e79so7597362iof.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 07:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=jB6tKPsvO7dDy/FbilJmE/VrDp+SW+nFJ3vX1gmDEsw=;
 b=KtdJrrZkCdKBA5XuwdDc3fk96WvpYRwpGKkK94fBt9YWkZiYH4GDTawXdVgW+XRo/n
 ELuT2uOUZujEUXnVDvCJRA4xjIJIt0M0Tp7T6+TVTsayp3fMvJJ6c/3xOB7rJlKQ9JQS
 g8/rLvMFAyfcc0MhsUY7LPxDjkUjhCd09obyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=jB6tKPsvO7dDy/FbilJmE/VrDp+SW+nFJ3vX1gmDEsw=;
 b=RnfP5P04V869sZV6qtClosMFTYK4a+EKB2yOTWuyGt73BZFn5qMQ3QIEB/YwnaAYsK
 3hvHaOFTPxt2bPNfn3LrfwC7S4sN+39g96fP885xby3ZwOe2tCwiUcOgkrBWn2k5DL41
 2zdNiwulZ3HtHfCVqa9QO/34cqtBck1fWqnzfjfQtqkR8RZ5F2Q+vuTUuUO620VvQC0U
 MW8A5sANK8qOBSzf/dBBvH7q73p6XAOsaC+yUmQEm90i9MwWlEz5wjEiIXSm3fDwzD43
 bsr2aYP3n7Ust6tJH/9dWMLcPAuki0HqOo3YFnHZh90J9q/OBkWs4CSoSm6D5LgKzqv/
 jD/w==
X-Gm-Message-State: AOAM531YiJumZSertbXQOrYBaazdTJDWaCEV0OSClgaDi5PJ6NVUPIEB
 K4b/fGBG10Q1SzMe+1Cg788jDg==
X-Google-Smtp-Source: ABdhPJysYmraJInuOqIz2To0k9po9IoeNYbbpwP+FM3bjPzUYIvF57Guu0t8ad2M1t0sIFfZs3r97g==
X-Received: by 2002:a05:6638:1493:: with SMTP id
 j19mr4251238jak.242.1644505965252; 
 Thu, 10 Feb 2022 07:12:45 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id q16sm11144556ion.27.2022.02.10.07.12.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 10 Feb 2022 07:12:45 -0800 (PST)
Subject: Re: [PATCH v11 06/40] arm64/sme: Provide ABI documentation for SME
To: Mark Brown <broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-7-broonie@kernel.org>
 <49da0f58-7a20-e557-54c3-34bd7074f711@linuxfoundation.org>
 <YgKQTLwW+ha5XNx8@sirena.org.uk> <YgK4kKrSs6e9seG8@sirena.org.uk>
 <e6d76104-b7f6-1588-d734-1a09c2990299@linuxfoundation.org>
 <YgK9v7u+FcBTB1ur@sirena.org.uk>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d41ec776-5bd0-438f-0ab3-6eb1891e7fdc@linuxfoundation.org>
Date: Thu, 10 Feb 2022 08:12:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YgK9v7u+FcBTB1ur@sirena.org.uk>
Content-Language: en-US
X-Mailman-Approved-At: Thu, 10 Feb 2022 10:32:37 -0500
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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

On 2/8/22 12:00 PM, Mark Brown wrote:
> On Tue, Feb 08, 2022 at 11:48:39AM -0700, Shuah Khan wrote:
>> On 2/8/22 11:38 AM, Mark Brown wrote:
> 
>>> I can't find any free format plain text files with SPDX in them, even
>>> really prominent stuff like README.  The process documentation is silent
> 
>> There are about 570+ files under Documentation directory that have SPDX
>> including Documentation/index.rst
> 
>> Based on a recent doc patch I did, I have seen warns during doc build
>> about the missing SPDX.
> 
>> Let's add it now so it doesn't need fixing later.
> 
> Sure, there are lots of structured files in there like .rst ones which
> have SPDX headers but this is just a free format text file so it's not
> clear what if any format to use.
> 

I think SPDX is applicable to all files free format or not. Are you seeing
any build warns during doc build on this?

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
