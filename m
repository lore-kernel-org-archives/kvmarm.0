Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED0BC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 10:45:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B207549EC1;
	Wed, 16 Mar 2022 06:45:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qAgQoivekYc3; Wed, 16 Mar 2022 06:45:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 349ED41019;
	Wed, 16 Mar 2022 06:45:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A076D40BD6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 06:45:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o-JIWeqCv62K for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 06:45:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 104E640BC0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 06:45:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85A651476;
 Wed, 16 Mar 2022 03:45:00 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FBC83F73D;
 Wed, 16 Mar 2022 03:44:59 -0700 (PDT)
Message-ID: <88915dc5-e156-f864-ac28-c40ddb8cc799@arm.com>
Date: Wed, 16 Mar 2022 10:44:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
Content-Language: en-US
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <drjones@redhat.com>
References: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
 <20220315152528.u7zdkjlq6okahidm@gator>
 <YjG/FyAaFsAxTLKd@monolith.localdoman>
From: Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
In-Reply-To: <YjG/FyAaFsAxTLKd@monolith.localdoman>
Cc: pbonzini@redhat.com, thuth@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

Hi Andrew, Alexandru,

On 16/03/2022 10:42, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Mar 15, 2022 at 04:25:28PM +0100, Andrew Jones wrote:
>> On Tue, Mar 15, 2022 at 01:33:57PM +0000, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> Arm is planning to upstream tests that are being developed as part of the
>>> Confidential Compute Architecture [1]. Some of the tests target the
>>> attestation part of creating and managing a confidential compute VM, which
>>> requires the manipulation of messages in the Concise Binary Object
>>> Representation (CBOR) format [2].
>>>
>>> I would like to ask if it would be acceptable from a license perspective to
>>> include the QCBOR library [3] into kvm-unit-tests, which will be used for
>>> encoding and decoding of CBOR messages.
>>>
>>> The library is licensed under the 3-Clause BSD license, which is compatible
>>> with GPLv2 [4]. Some of the files that were created inside Qualcomm before
>>> the library was open-sourced have a slightly modified 3-Clause BSD license,
>>> where a NON-INFRINGMENT clause is added to the disclaimer:
>>>
>>> "THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
>>> WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
>>> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
>>> ARE DISCLAIMED" (emphasis by me on the added clause).
>>>
>>> The files in question include the core files that implement the
>>> encode/decode functionality, and thus would have to be included in
>>> kvm-unit-tests. I believe that the above modification does not affect the
>>> compatibility with GPLv2.
>>>
>>> I would also like to mention that the QCBOR library is also used in Trusted
>>> Firmware-M [5], which is licensed under BSD 3-Clause.
>>>
>>> [1] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
>>> [2] https://datatracker.ietf.org/doc/html/rfc8949
>>> [3] https://github.com/laurencelundblade/QCBOR
>>> [4] https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses
>>> [5] https://git.trustedfirmware.org/TF-M/trusted-firmware-m.git/tree/lib/ext/qcbor
>>>
>>> Thanks,
>>> Alex
>>>
>>
>> Assuming the license is OK (I'm not educated in that stuff enough to give
>> an opinion), then the next question is how do we want to integrate it?
>> Bring it all in, like we did libfdt? Or use a git submodule?

Thanks for your feedback.

> 
> This is still a work in progress and at this time I'm not sure how it will
> end up looking. Do you have a preference for one or the other?
> 

My two cents. With the submodule approach, we can move to the later 
versions of the QCBOR library (if needed, in the future) without much
noise in the history.

Cheers
Suzuki

> Thanks,
> Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
