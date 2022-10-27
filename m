Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A977B
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 21:16:11 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 128so2873776pga.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 14:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LNt31XDCqvQYDG7+0BMGK/WlDbK27aGdIMHRTxeZ0wQ=;
        b=ZYrTTMrWePuLcJ18bRff53zV9D4b8EhsIelPCHJrVgAwY5RLupekLDnMK0rH45tEVy
         4qTDcpoRC8lYKcEUiH5iLn/MP0S7ui9/bkLvQIeTHk7kfD+erJF+mpR2z1kDIOKc7whD
         XvOsRYnD8REc/P3eg6CKJOd4caysNcyqIuNTLYOylXNXeMXho8Qn//ZCp4neEadz94M6
         w9UPPH6v1v0jVColNON9dgJM2dT3A+A1s60ZPV6h4Q9+RhW3nTdZ59iuC5UcOvMGiU/K
         0zSvC/jqOeuhP3ELhfghO94v18407egmeHSrCiucR4JtLXB7KG0p0cKocXXFcnVwzdJn
         /gHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LNt31XDCqvQYDG7+0BMGK/WlDbK27aGdIMHRTxeZ0wQ=;
        b=LDpO+Q+zZ9qintnRVoYiOKUREQtytfLOcw3vzvjY3Q6RciVxCuJM6gRFOO3gQuiuU1
         v3FCzZFdvd4xqm4fXVippvhg63HGu6YnSH4r5y+X2tMT6kGcLaP5LOSHAtGYYWyDy7BI
         8Xf95zBgeDRIPaxiVwYHx6aOR11WPHHE+0DViod1X9fFnmUWhCgp+FX+VcWu3PUVXuye
         Cey2L+rpOZfoP7x8SQ628uKlc0CqrswVUCNsZ5vuUe7tdzKS3aZ2rBzgI6EQP9T2dNgh
         usBvG1DBM1qODsCO7IHEJIA7+LfuL70NUrN6HjnJAKrNNnADxjy0pIOzbiXytF69iBzV
         tcXQ==
X-Gm-Message-State: ACrzQf10XSyU44s4P9UHDhlB7Bx7u8iZEoWShDE9t9Q7alOstQ9pc/Pe
	CdvVnn8pc3BPpBCPJUHVii61ew==
X-Google-Smtp-Source: AMsMyM5LJ9ieAwXj0Rp00MSCQltzvLX6aF6NWrrfGk1gzAK8r/iUaUAumh5fVJKYcrvFgOxRCBFesw==
X-Received: by 2002:a65:5241:0:b0:46e:f67c:c108 with SMTP id q1-20020a655241000000b0046ef67cc108mr21718674pgp.362.1666905371376;
        Thu, 27 Oct 2022 14:16:11 -0700 (PDT)
Received: from ?IPV6:2001:8003:501a:d301:93c4:c1c9:4368:47fa? ([2001:8003:501a:d301:93c4:c1c9:4368:47fa])
        by smtp.gmail.com with ESMTPSA id x35-20020a17090a38a600b0020ad26fa65dsm1346282pjb.56.2022.10.27.14.16.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 14:16:10 -0700 (PDT)
Message-ID: <5f00782b-d91b-0214-ff72-4ca32237f4ec@linaro.org>
Date: Fri, 28 Oct 2022 07:16:04 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: Hang with nVHE mode and SME
Content-Language: en-US
To: Peter Maydell <peter.maydell@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Vincent Donnefort <vdonnefort@google.com>,
 kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org
References: <Y1lEWJ7rO4m1CKWL@google.com> <Y1lNKcXfy/nHzTQ9@sirena.org.uk>
 <86ilk6ef5x.wl-maz@kernel.org> <Y1lhrB3lq5dZAin1@sirena.org.uk>
 <CAFEAcA-mo_ywRnC53aFfkYP=q3zDBD7U4sBSrzg7ZfRQA7QYXA@mail.gmail.com>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <CAFEAcA-mo_ywRnC53aFfkYP=q3zDBD7U4sBSrzg7ZfRQA7QYXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/22 19:44, Peter Maydell wrote:
> On Wed, 26 Oct 2022 at 17:34, Mark Brown <broonie@kernel.org> wrote:
>>
>> On Wed, Oct 26, 2022 at 05:13:46PM +0100, Marc Zyngier wrote:
>>> Mark Brown <broonie@kernel.org> wrote:
>>>> On Wed, Oct 26, 2022 at 03:29:44PM +0100, Vincent Donnefort wrote:
>>
>>>> rather than on the if statement?  A brief grep around the qemu source
>>>> suggests that this register and fine grained traps in general are not
>>>> implemented which is invalid with SME since this is required for SME in
>>>> nVHE.  SME is a v9.2 feature, and v9.2 includes all the requirements of
>>>> v8.7.  FEAT_FGT has been mandatory since v8.6 (where it was added).
> 
> Yeah. This is pretty common for QEMU, because we don't have the
> resources to implement the full breadth of the architecture. We
> just implement various features and rely on the kernel to do
> fine-grained checking of ID registers rather than assuming that
> because feature X is present feature Y must be too, or that because
> some feature is in vX.Y then it must imply presence of all features
> in some other vA.B. Mostly this works out OK...

Yep, I knew I was skipping over FGT while implementing SME.
I left some TODO comments at the time.
I simply optimistically hoped that it wouldn't be critical.

We can certainly increase the priority.


r~
