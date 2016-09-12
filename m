From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 4/8] KVM: arm64: vgic-its: Introduce config option to
 guard ITS specific code
Date: Mon, 12 Sep 2016 10:23:59 +0100
Message-ID: <57D6742F.6080206@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-5-git-send-email-vladimir.murzin@arm.com>
 <57D2E76E.2000607@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 083BF40F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:15:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YI3cfD0w7pR3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 05:15:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1304B40C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:15:20 -0400 (EDT)
In-Reply-To: <57D2E76E.2000607@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/09/16 17:46, Marc Zyngier wrote:
> On 08/09/16 17:06, Vladimir Murzin wrote:
>> By now ITS code guarded with KVM_ARM_VGIC_V3 config option which was
>> introduced to hide everything specific to vgic-v3 from 32-bit world.
>> We are going to support vgic-v3 in 32-bit world and KVM_ARM_VGIC_V3
>> will gone, but we don't have support for ITS there yet and we need to
>> continue keeping ITS away.
>> Introduce the new config option to prevent ITS code being build in
>> 32-bit mode when support for vgic-v3 is done.
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks!

Vladimir

> 
> 	M.
> 
