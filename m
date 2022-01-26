Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B54C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 15:52:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2584A417;
	Thu, 27 Jan 2022 10:52:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IB6aw732NEcu; Thu, 27 Jan 2022 10:52:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8D84B091;
	Thu, 27 Jan 2022 10:52:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 496CE4B0C5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 15:03:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PdR19VE626+H for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 15:03:47 -0500 (EST)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17F9F4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 15:03:46 -0500 (EST)
Received: by mail-io1-f50.google.com with SMTP id q204so961037iod.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=aMe8O0ITicLrwj3c7mkhip/6OJuBkx0HlJG/uCBDyG0=;
 b=GhbYXCdsWaR3jqth7tUcp6GURNRcQA9iWuWLPFpC4acl8+N0xmi8+YgjFbT+hjwtxV
 n9aH/ZAlQ8EG7r9RgIms4WlycA2RMMCtn17Y5Ci065Wa4bLpaTOhvEABpXWmv3dWWNVR
 BURZtEgbYWrUy6b8ON1vY06AvY1l8w0QMPw7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=aMe8O0ITicLrwj3c7mkhip/6OJuBkx0HlJG/uCBDyG0=;
 b=LgVSVff+64gz3ai3Kf1HSgs02UawYQIvTOVVbGwrmt20tDZXOkuuNGo87+IHSCrfpd
 BBC5/EgGL46aOGpy+ztGdkL5fd2ylK29Y/GDYxKgCtzH2DqNruJ7DTtiUFywCLZbGERX
 KjRubAlWsmIN9rdK9keuYfQcoJdia0tk0EYXZatH1JbCy6h4kZKkWxuKPtqwWz4w1jZB
 Zbux3GNqNtHYZyIEpJ2pFbICBiSUnKrzWduItas6yKoz8W57OL/RABLkidKvNGELZx9x
 /O1DPZZIM+YUFRDCxgMrt8MvapAFlBDq+ffQpqJTu1g+sOvIrNXrJ1xXIIkasni+yTAM
 t7tA==
X-Gm-Message-State: AOAM5301KKy9pjnRCT0ogyfnUVZ30cpEyrFx1KkZBo906OZAphejj9+0
 meCRhz85UIcWe/BNRzhDiR9KHg==
X-Google-Smtp-Source: ABdhPJwNTLVDSEQaWj4ahmayvU+7w5oefhIemb+BKQSc24utvCF3MytvBjt5ASR37I+v9VEo/79llw==
X-Received: by 2002:a02:9709:: with SMTP id x9mr123411jai.53.1643227426312;
 Wed, 26 Jan 2022 12:03:46 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:f2e:a7f7:d853:1e3?
 ([2601:282:8200:4c:f2e:a7f7:d853:1e3])
 by smtp.gmail.com with ESMTPSA id k5sm845601ilr.7.2022.01.26.12.03.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 26 Jan 2022 12:03:45 -0800 (PST)
Subject: Re: [PATCH v3] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
To: Mark Brown <broonie@kernel.org>
References: <20220126145242.3473836-1-broonie@kernel.org>
 <4424dd30-f74b-006f-b540-dbaf02e45e28@linuxfoundation.org>
 <YfGmk1I8l+ROoE/k@sirena.org.uk>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <48c44d74-6668-7823-ada6-0285a8b32a35@linuxfoundation.org>
Date: Wed, 26 Jan 2022 13:03:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YfGmk1I8l+ROoE/k@sirena.org.uk>
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

On 1/26/22 12:52 PM, Mark Brown wrote:
> On Wed, Jan 26, 2022 at 12:22:41PM -0700, Shuah Khan wrote:
>> On 1/26/22 7:52 AM, Mark Brown wrote:
> 
>>> +	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
>>> +	if (ret < 0) {
>>> +		print_skip("Failed to create vgic-v3");
> 
>> Printing the negative error code returned by vgic_v3_setup will be useful.
> 
> If the function fails for any reason other than the system not
> supporting vgic-v3 it will abort rather than return.
> 

Hmm. vgic_v3_setup() return gic_fd looks like and the interface says
Return: GIC file-descriptor or negative error code upon failure

I don't follow the abort part.

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
