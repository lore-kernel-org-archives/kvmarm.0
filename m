Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03E0C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 18:55:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EE3649F4C;
	Thu, 10 Feb 2022 13:55:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TX6Jhqs41cSS; Thu, 10 Feb 2022 13:55:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6746749F0A;
	Thu, 10 Feb 2022 13:55:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D27649F0C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 11:46:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nV24w0IlI5eb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 11:46:04 -0500 (EST)
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com
 [209.85.166.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F22D14086D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 11:46:03 -0500 (EST)
Received: by mail-il1-f182.google.com with SMTP id n5so4792225ilk.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 08:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=DDtHBrYV020bBGjtIYRFzMtZ1rUWWBBixnBxzXJeFHg=;
 b=b6JQx2r2RiP/MMxSjrD6RoqNR1f8sgY/J8ogD1k5zuepBjN9K4EpBTF4U3DnkeWghn
 OiqY/c+ldn1HMMXxr57ZqhnHntCkvLwMwdaoBNgntrz9ZtxNLhNEmUo3JG7R+L6XMQxb
 0v7lJ4uHDLla/82flidGVeDfm9T2y7xdlc+iY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=DDtHBrYV020bBGjtIYRFzMtZ1rUWWBBixnBxzXJeFHg=;
 b=pMZuLzQ/L7tJ2WJDZz+6HJsjyUUyWIwULpFzVQp8QigT3U9DZ/4vk15xacyhEYb6Sj
 t5Cxzmo5nOpAqN3CRwaThMuokIlIeMkBZExd07B3iuIQ3ZuKwTwxQaeR/OvlT21o1C9D
 pzD8zq8XU/x18ISxiBvRowSQHFj1PI0vQOOmoHzgYUZmR/C57COflJab4/AxQJw13wBI
 fpZu/EnFxIBBkJZAs3v8qzovpcXpdwN0XQKpeaZZ0NvA45OUk5YSvWXCoJT6TRhRzV3w
 2wRdHnO47LJI1ZWqhEY7vxiqRYZyNoNLjXAaoekgIqhDzSM94A4/5h9vNkUgcHnWc6Dv
 O9VQ==
X-Gm-Message-State: AOAM530Gf3cg4pEwP4t2gsyZfMUvdFgtZO9ver4lq3QaspvymWGlfkxm
 rw7x26fUaZ6Yt/h7Sp13kh+SCw==
X-Google-Smtp-Source: ABdhPJwBlZn/97+3CiBD8ZcFr5rKXnOkyTzDg+cp7L6qXTI403VmIgvZfUlQKv423UjT5i7Ow2M58Q==
X-Received: by 2002:a05:6e02:1544:: with SMTP id
 j4mr4346609ilu.77.1644511563158; 
 Thu, 10 Feb 2022 08:46:03 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id d2sm4037645iog.42.2022.02.10.08.46.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 10 Feb 2022 08:46:02 -0800 (PST)
Subject: Re: [PATCH v11 06/40] arm64/sme: Provide ABI documentation for SME
To: Mark Brown <broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-7-broonie@kernel.org>
 <49da0f58-7a20-e557-54c3-34bd7074f711@linuxfoundation.org>
 <YgKQTLwW+ha5XNx8@sirena.org.uk> <YgK4kKrSs6e9seG8@sirena.org.uk>
 <e6d76104-b7f6-1588-d734-1a09c2990299@linuxfoundation.org>
 <YgK9v7u+FcBTB1ur@sirena.org.uk>
 <d41ec776-5bd0-438f-0ab3-6eb1891e7fdc@linuxfoundation.org>
 <YgU66pT3efqwwn7U@sirena.org.uk>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <fb795b74-e44e-9b18-fb37-505b18d129fc@linuxfoundation.org>
Date: Thu, 10 Feb 2022 09:46:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YgU66pT3efqwwn7U@sirena.org.uk>
Content-Language: en-US
X-Mailman-Approved-At: Thu, 10 Feb 2022 13:55:27 -0500
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

On 2/10/22 9:18 AM, Mark Brown wrote:
> On Thu, Feb 10, 2022 at 08:12:44AM -0700, Shuah Khan wrote:
>> On 2/8/22 12:00 PM, Mark Brown wrote:
> 
>>> Sure, there are lots of structured files in there like .rst ones which
>>> have SPDX headers but this is just a free format text file so it's not
>>> clear what if any format to use.
> 
>> I think SPDX is applicable to all files free format or not. Are you seeing
>> any build warns during doc build on this?
> 
> No, but I'm not exactly going out of my way to do anything with them.
> As far as I know these files don't get touched during builds, they just
> exist in the kernel tree.  If there is some way of generating warnings
> from them there are quite a lot of other such files already there and
> doing so.  Like I say I can't find any evidence that anyone has looked
> at adding SPDX to these files, as far as I know the long term plan such
> as it is is to convert to other formats and I can't immediately think
> how one would do it otherwise in a way that works well.
> 

If build isn't saying anything, we can move on from SPDX comment. :)

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
