Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2993C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 13:58:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40D654B156;
	Tue,  8 Feb 2022 08:58:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EwPZd+HtBNtG; Tue,  8 Feb 2022 08:58:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C2F14B1A9;
	Tue,  8 Feb 2022 08:58:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C92C349F5F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 18:57:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uFrBep0JC4Nm for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 18:57:29 -0500 (EST)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com
 [209.85.166.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4119B49F5D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 18:57:29 -0500 (EST)
Received: by mail-il1-f181.google.com with SMTP id z18so12566893ilp.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 15:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=ej/oxUOPfotPxZF6x1ri18KCfGD2YGEa1yg//ehHnUo=;
 b=JM1m+wmNu9FmFD+riCw6wb0p0d0pPl0h2477lD+tG9SKyf0FsP7JkN9pPVcDr3gd+W
 j2ePlxvb84+QbHooh0I29hU87nJlmnnGpzAlcozQSqqYKSVKvv0ozt9M9NGf7soKkz/n
 HC6i2z7jO6xoxajglXYzdv/Xw1DRQ96BgXnt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=ej/oxUOPfotPxZF6x1ri18KCfGD2YGEa1yg//ehHnUo=;
 b=m7LnYGP8iHQU/14pS8jURHbLWlr79ThRu0QoS1xrwt8vJoILBZK83PhoZXzxURwXC8
 2xc7AUGTZZs3G9+StCEQ8pB+1v/7eCPMYQo7OG/Z8zol+GvIXDF3eeYuiRdXIgq3pV+q
 IUYSp9ktNt3HDYfPNq6yHlnv+cdpv89RobUjFP30jHTs81AffHHYU3EDz14CP6gze/lA
 KK7RQe5QS19uuTbXUg5NsQj+QJA3Q9WlC/aEYos07oHIadpgCC6Zf/1LN4c5OT6zVhbz
 MgfvkDmDjK+907Pbq+OeuYnYVcPecjqqmWMYnPTxe8Ok75XNJ+MGBtGtixT623X29aLX
 +ejA==
X-Gm-Message-State: AOAM532XZGFOcsIhxkiPTqtCKiCJqZHD3hwzSTiiR0FgucnZsGIOjRw3
 pgUOTimjK0xPpqmEg5EssRAwCA==
X-Google-Smtp-Source: ABdhPJwk8Uh5JobMOPX23+iidTPeN7IN+ed0TPp/GJ65/GbrujVjigZ3b7VgXcHPdBWjo2As4O2qpQ==
X-Received: by 2002:a05:6e02:e12:: with SMTP id
 a18mr886458ilk.200.1644278248618; 
 Mon, 07 Feb 2022 15:57:28 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id b4sm2861038iln.15.2022.02.07.15.57.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Feb 2022 15:57:28 -0800 (PST)
Subject: Re: [PATCH v11 30/40] kselftest/arm64: Add manual encodings for SME
 instructions
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-31-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <638b7ae1-6669-5524-318a-6b8a07cf3919@linuxfoundation.org>
Date: Mon, 7 Feb 2022 16:57:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207152109.197566-31-broonie@kernel.org>
Content-Language: en-US
X-Mailman-Approved-At: Tue, 08 Feb 2022 08:58:27 -0500
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, Shuah Khan <skhan@linuxfoundation.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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

On 2/7/22 8:20 AM, Mark Brown wrote:
> As for the kernel so that we don't have ambitious toolchain requirements
> to build the tests manually encode some of the SVE instructions.
> 

Thank you for thinking about toolchain requirements. Please add a bit more
information on how these defines are used here in this commit log.

> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---

Rest looks good to me.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
