From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 3/8] arm64: KVM: Move vgic-v3 save/restore to
 virt/kvm/arm/hyp
Date: Mon, 12 Sep 2016 10:18:41 +0100
Message-ID: <57D672F1.7080902@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-4-git-send-email-vladimir.murzin@arm.com>
 <57D2E448.304@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A765140F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:10:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ubeIvkbf4iK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 05:10:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A913340C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:10:03 -0400 (EDT)
In-Reply-To: <57D2E448.304@arm.com>
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

On 09/09/16 17:33, Marc Zyngier wrote:
> On 08/09/16 17:06, Vladimir Murzin wrote:
>> So we can reuse the code under arch/arm
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Thanks!

Vladimir

> 	M.
> 
