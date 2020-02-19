Return-Path: <SRS0=1n5P=4H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A087BC34047
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 15:47:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 257522464E
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 15:47:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 257522464E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=siemens.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A02A94AC89;
	Wed, 19 Feb 2020 10:47:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qNQPR7QAKYaQ; Wed, 19 Feb 2020 10:47:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ED1A4AEEA;
	Wed, 19 Feb 2020 10:47:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D6E14AC89
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 10:47:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6V2XuKV1vJ1Z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Feb 2020 10:47:05 -0500 (EST)
Received: from goliath.siemens.de (goliath.siemens.de [192.35.17.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DC884A5A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 10:47:05 -0500 (EST)
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
 by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 01JFkkEi023113
 (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 19 Feb 2020 16:46:46 +0100
Received: from [139.25.68.37] ([139.25.68.37])
 by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 01JFkgTh026670;
 Wed, 19 Feb 2020 16:46:42 +0100
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>
References: <20200210141324.21090-1-maz@kernel.org>
 <CAK8P3a3V=ur4AgLfat2cSyw8GrkCS2t06eqkzC-gXcc0xBpEPw@mail.gmail.com>
From: Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <ea7bc1d0-0a11-8ed6-da70-d603d8107bf6@siemens.com>
Date: Wed, 19 Feb 2020 16:46:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3V=ur4AgLfat2cSyw8GrkCS2t06eqkzC-gXcc0xBpEPw@mail.gmail.com>
Content-Language: en-US
Cc: jailhouse-dev@googlegroups.com, Anders Berg <anders.berg@lsi.com>,
 Russell King <linux@arm.linux.org.uk>, kvm list <kvm@vger.kernel.org>,
 jean-philippe.brucker@arm.com,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 19.02.20 16:09, Arnd Bergmann wrote:
> On Mon, Feb 10, 2020 at 3:13 PM Marc Zyngier <maz@kernel.org> wrote:
>>
>> KVM/arm was merged just over 7 years ago, and has lived a very quiet
>> life so far. It mostly works if you're prepared to deal with its
>> limitations, it has been a good prototype for the arm64 version,
>> but it suffers a few problems:
>>
>> - It is incomplete (no debug support, no PMU)
>> - It hasn't followed any of the architectural evolutions
>> - It has zero users (I don't count myself here)
>> - It is more and more getting in the way of new arm64 developments
>>
>> So here it is: unless someone screams and shows that they rely on
>> KVM/arm to be maintained upsteam, I'll remove 32bit host support
>> form the tree. One of the reasons that makes me confident nobody is
>> using it is that I never receive *any* bug report. Yes, it is perfect.
>> But if you depend on KVM/arm being available in mainline, please shout.
>>
>> To reiterate: 32bit guest support for arm64 stays, of course. Only
>> 32bit host goes. Once this is merged, I plan to move virt/kvm/arm to
>> arm64, and cleanup all the now unnecessary abstractions.
>>
>> The patches have been generated with the -D option to avoid spamming
>> everyone with huge diffs, and there is a kvm-arm/goodbye branch in
>> my kernel.org repository.
> 
> Just one more thought before it's gone: is there any shared code
> (header files?) that is used by the jailhouse hypervisor?
> 
> If there is, are there any plans to merge that into the mainline kernel
> for arm32 in the near future?
> 
> I'm guessing the answer to at least one of those questions is 'no', so
> we don't need to worry about it, but it seems better to ask.

Good that you mention it: There is one thing we share on ARM (and 
ARM64), and that is the hypervisor enabling stub, to install our own 
vectors. If that was to be removed as well, we would have to patch it 
back downstream. So far, we only carry few EXPORT_SYMBOL patches for 
essential enabling.

That said, I was also starting to think about how long we will continue 
to support Jailhouse on 32-bit ARM. We currently have no supported SoC 
there that comes with an SMMU, and I doubt to see one still showing up. 
So, Jailhouse on ARM is really just a testing/demo case, maybe useful 
(but I didn't get concrete feedback) for cleaner collaborative AMP for 
real-time purposes, without security concerns. I assume 32-bit ARM will 
never be part of what would be proposed of Jailhouse for upstream.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
