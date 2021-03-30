Return-Path: <SRS0=NHQQ=I4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA5DC433DB
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 10:23:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62341619AD
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 10:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62341619AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE0A64B2E4;
	Tue, 30 Mar 2021 06:23:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SaijFxtkZr6z; Tue, 30 Mar 2021 06:23:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96E164B299;
	Tue, 30 Mar 2021 06:23:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C20E4B23E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 06:23:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y8SSvAr9nZYb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Mar 2021 06:23:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3F8B4B1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 06:23:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3193EED1;
 Tue, 30 Mar 2021 03:23:12 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C59BE3F792;
 Tue, 30 Mar 2021 03:23:11 -0700 (PDT)
Subject: Re: KVM/ARM64: Booting KVM on FVP/fastmodels
To: "yinhua_chen@outlook.com" <yinhua_chen@outlook.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
References: <OSYPR01MB54317CECC49E872ACFD9D84B817E9@OSYPR01MB5431.jpnprd01.prod.outlook.com>
From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <0bbea123-7bea-3a2e-70ae-30f43df3000e@arm.com>
Date: Tue, 30 Mar 2021 11:22:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <OSYPR01MB54317CECC49E872ACFD9D84B817E9@OSYPR01MB5431.jpnprd01.prod.outlook.com>
Content-Language: en-GB
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 29/03/2021 13:13, yinhua_chen@outlook.com wrote:

Hi,

> I want to boot KVM on simulators.
> 
> I don't want to use QEMU since some features are only supported on
> FVP/fastmodels now.
> 
> However, I cannot find documents/blogs/wiki about booting KVM on
> FVP/fastmodels.
> 
> Does KVM support running on FVP?

The FVP emulates the full architecture, including all exception levels
(so also EL2), and the virtualization support of the GIC and the Generic
Timer.
So yes, the models fully support KVM (or any other hypervisor, for that
matter), and are in fact often used for developing KVM support of new
hardware features.

So what are the problems that you are facing? Just running a kernel like
you would normally do on the model should work out of the box.
If you describe your setup and the error messages, we can probably help
you better.

Cheers,
Andre

> 
> Appreciate for your help!
> 
> Sincerely,
> Yinhua
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
