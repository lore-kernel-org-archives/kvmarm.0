From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 2/8] arm64: KVM: Move GIC accessors to arch_gicv3.h
Date: Mon, 12 Sep 2016 10:18:12 +0100
Message-ID: <57D672D4.5020509@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-3-git-send-email-vladimir.murzin@arm.com>
 <57D2E426.6000001@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA23940F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:09:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cvxDGjC3NTOH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 05:09:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8281740C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:09:47 -0400 (EDT)
In-Reply-To: <57D2E426.6000001@arm.com>
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

On 09/09/16 17:32, Marc Zyngier wrote:
> On 08/09/16 17:06, Vladimir Murzin wrote:
>> Since we are going to share vgic-v3 save/restore code with ARM keep
>> arch specific accessors separately.
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Thanks!

Vladimir

> 	M.
> 
