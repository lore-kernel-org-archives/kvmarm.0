From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 0/7] ARM: KVM: Support for vgic-v3
Date: Tue, 6 Sep 2016 13:32:53 +0100
Message-ID: <57CEB775.5060209@arm.com>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <20160905112853.GF26366@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBAB149B56
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:24:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W188ssZc2koh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 08:24:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C91A349B4A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:24:44 -0400 (EDT)
In-Reply-To: <20160905112853.GF26366@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/09/16 12:28, Christoffer Dall wrote:
> On Tue, Aug 16, 2016 at 11:46:51AM +0100, Vladimir Murzin wrote:
>> Hi,
>>
>> This is an attempt to make use vgic-v3 under arch/arm since save-restore
>> functionality got re-written in C and can be shared between arm/arm64
>> like it has already been done for vgic-v2 and timer.
>>
>> With this patches I'm able to get 32 core ARMv7 guest boot:
> 
> Is it really an ARMv7 guest or an AArch32 ARMv8 guest?
> 

It is an AArch32 ARMv8 guest.

Vladimir
