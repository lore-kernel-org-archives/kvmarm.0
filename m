Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF37C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 18:59:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB56D4B1E7;
	Tue,  8 Feb 2022 13:59:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qsj+dyikFsye; Tue,  8 Feb 2022 13:59:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19B8F4B1C0;
	Tue,  8 Feb 2022 13:59:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38F3D4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 13:50:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D6xs+93khrXN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 13:50:03 -0500 (EST)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
 [209.85.166.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3E694A119
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 13:50:02 -0500 (EST)
Received: by mail-io1-f41.google.com with SMTP id p63so182696iod.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Feb 2022 10:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=Up9s3VVyRq3gUPhujQummCRkFjt5TIPVI87trpcElzg=;
 b=BGKJpotKRvg9wbEaGyU52UDLSBHBOdnH0ozTUDjnP5Llw3UWs+GztkRlCP3t0AqK2W
 00Tb2TU8KE6B5rASBMivmtLcxUCDUVv1S8Ct6p97DJlUNdW8L+aMDP8ycjq8tFuoiqZE
 bquMmHDbTIS4UEk9DDqMDwR+EEzOTfHX59l7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Up9s3VVyRq3gUPhujQummCRkFjt5TIPVI87trpcElzg=;
 b=DYukZTbOXhcQlHgevsJ1pwtqqAym8NPB/W1w3MPH4MPVTKk7OM/I5vXSdM0HCn1Wy7
 sakCXHHDyoOcnEDq/r35xDEKlDR4zt45BUKovUS+rnpp0mKixQsJUG8+3V5jQ4Iq/XPD
 QrAmrzmdl7B73wLlSQk6gC9p1vQ07Y5PMg/BDXCOjYXHOg+fZZxEMb/KxSLEmBRaWZUG
 ZKOlsq25zjt4+3z/UET6KrC6oa0yefJ6hIod8Sm8kSfPvN8nGt7Qx9TPONj2pkuOFZtj
 nQVCm0AP0gzmObz+lsWVfUrgb9WpV9i/0dMpWxDNO0XGXmqvSa44Z8GCRuAVI238XRQ5
 9Edg==
X-Gm-Message-State: AOAM531+st7Ac0ucuMgZ8noYdeWlVYgm9uJrA91NwBj1yYYwN0DJ1ShA
 n7jQrCFEZLMa3XTGC8mcGD6mXQ==
X-Google-Smtp-Source: ABdhPJwftdpUC+GK+1Mlp6jRp8pl74aOJ+aLuxMv4f6itmu9L1GMVyRPhLCD9Etj1CtWGgoqIV22sA==
X-Received: by 2002:a05:6638:329a:: with SMTP id
 f26mr2675913jav.28.1644346202072; 
 Tue, 08 Feb 2022 10:50:02 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id e17sm7625070ilm.67.2022.02.08.10.50.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Feb 2022 10:50:01 -0800 (PST)
Subject: Re: [PATCH v11 40/40] kselftest/arm64: Add SME support to syscall ABI
 test
To: Mark Brown <broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-41-broonie@kernel.org>
 <676aa270-7801-9689-7c88-27368f32a532@linuxfoundation.org>
 <YgKzXs2Eti+Z2A1+@sirena.org.uk>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5ab8ec1b-c978-3eed-9e32-3d99d7cba4e3@linuxfoundation.org>
Date: Tue, 8 Feb 2022 11:50:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YgKzXs2Eti+Z2A1+@sirena.org.uk>
Content-Language: en-US
X-Mailman-Approved-At: Tue, 08 Feb 2022 13:59:31 -0500
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

On 2/8/22 11:15 AM, Mark Brown wrote:
> On Mon, Feb 07, 2022 at 06:52:06PM -0700, Shuah Khan wrote:
>> On 2/7/22 8:21 AM, Mark Brown wrote:
> 
>>> +static int check_za(struct syscall_cfg *cfg, int sve_vl, int sme_vl,
>>> +		    uint64_t svcr)
>>> +{
>>> +	size_t reg_size = sme_vl * sme_vl;
> 
>> Is there possibilty of size_t overfolow here?
> 
> No, if the size of a vector were anywhere near to being able to being
> able to do that I think we'd have serious design issues with the ABI -
> the size being calculated here is the size of a single register.  The
> current architectural maximum vector length is 2048 bits, which would
> give a size of 64K for ZA if implemented.
> 
>>> +	if (memcmp(za_in, za_out, reg_size) != 0) {
>>> +		ksft_print_msg("SME VL %d ZA does not match\n", sme_vl);
> 
>> Print the expected value in addition to the sme_val.
> 
> This is not comparing the vector length, this is comparing the contents
> of the ZA register which may be up to 64K in size.  There are serious
> presentational issues with displaying any errors in a useful fashion for
> such a large register which IME needs custom display code adding by
> whoever is debugging the issue that takes account of what the pattern
> being observed is.
> 
>>> @@ -265,8 +357,36 @@ static void test_one_syscall(struct syscall_cfg *cfg)
>>>    		if (sve_vq != sve_vq_from_vl(sve_vl))
>>>    			sve_vq = sve_vq_from_vl(sve_vl);
>>> -		ksft_test_result(do_test(cfg, sve_vl),
>>> +		ksft_test_result(do_test(cfg, sve_vl, default_sme_vl, 0),
>>>    				 "%s SVE VL %d\n", cfg->name, sve_vl);
> 
>> Print default_sme_vl as well.
> 
> default_sme_vl is just being passed in as a dummy value here since the
> function takes a fixed number of arguments, this is testing the case
> where SME is not used or enabled and will be run on systems which do not
> have SME at all so there won't be any defined vector length for SME.  I
> fear that it would cause confusion to display a SME VL here, and
> do_test() won't actually pay any attention to that argument in this
> case.  We will individually step through all possible combinations of
> SVE and SME vector lengths in separate tests.
> 

Sounds good.

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
