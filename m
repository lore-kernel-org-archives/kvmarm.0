Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E341FC4332D
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 18:45:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C4FE20775
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 18:45:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C4FE20775
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECB4C4B09B;
	Fri, 20 Mar 2020 14:45:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YAahf0-gmRrE; Fri, 20 Mar 2020 14:45:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D57444B0A1;
	Fri, 20 Mar 2020 14:45:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C15E4B099
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 14:45:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZBok4E-29-VN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 14:45:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4F0E4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 14:45:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D0791FB;
 Fri, 20 Mar 2020 11:45:08 -0700 (PDT)
Received: from [10.37.12.158] (unknown [10.37.12.158])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DCE53F305;
 Fri, 20 Mar 2020 11:45:06 -0700 (PDT)
Subject: Re: [PATCH 0/6] Introduce ID_PFR2 and other CPU feature changes
To: anshuman.khandual@arm.com, linux-arm-kernel@lists.infradead.org
References: <1580215149-21492-1-git-send-email-anshuman.khandual@arm.com>
 <45ce930c-81b3-3161-ced6-34a8c8623ac8@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <8760fc96-8898-3fca-178d-dc4b3500a090@arm.com>
Date: Fri, 20 Mar 2020 18:49:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <45ce930c-81b3-3161-ced6-34a8c8623ac8@arm.com>
Content-Language: en-US
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Anshuman

On 02/14/2020 04:23 AM, Anshuman Khandual wrote:
> 
> 
> On 01/28/2020 06:09 PM, Anshuman Khandual wrote:
>> This series is primarily motivated from an adhoc list from Mark Rutland
>> during our ID_ISAR6 discussion [1]. Besides, it also includes a patch
>> which does macro replacement for various open bits shift encodings in
>> various CPU ID registers. This series is based on linux-next 20200124.
>>
>> [1] https://patchwork.kernel.org/patch/11287805/
>>
>> Is there anything else apart from these changes which can be accommodated
>> in this series, please do let me know. Thank you.
> 
> Just a gentle ping. Any updates, does this series looks okay ? Is there
> anything else related to CPU ID register feature bits, which can be added
> up here. FWIW, the series still applies on v5.6-rc1.

Sorry for the delay ! The series looks good to me, except for some minor
comments. Please see the individual patches.

Cheers
Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
