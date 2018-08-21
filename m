From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v3 7/9] KVM: arm/arm64: Only clean the dcache on
 translation fault
Date: Tue, 21 Aug 2018 15:42:30 +0200
Message-ID: <f01ed8f5-8b73-7876-89a8-14a8ed1d9138@suse.de>
References: <20171023161122.15291-1-marc.zyngier@arm.com>
 <20171023161122.15291-8-marc.zyngier@arm.com>
 <bfeee11e-f8bf-78f2-ab61-27e43781e2e3@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2AB34A214
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Aug 2018 09:42:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9tYgs1PYuNXV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Aug 2018 09:42:32 -0400 (EDT)
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7DDE4A1E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Aug 2018 09:42:32 -0400 (EDT)
In-Reply-To: <bfeee11e-f8bf-78f2-ab61-27e43781e2e3@suse.de>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: =?UTF-8?Q?Dirk_M=c3=bcller?= <dmueller@suse.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 08/21/2018 03:35 PM, Alexander Graf wrote:
> On 10/23/2017 06:11 PM, Marc Zyngier wrote:
>> The only case where we actually need to perform a dcache maintenance
>> is when we map the page for the first time, and subsequent permission
>> faults do not require cache maintenance. Let's make it conditional
>> on not being a permission fault (and thus a translation fault).
>>
>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>
> This patch unfortunately breaks something on Hi1616 SoCs when running 
> 32bit guests. With this patch applied (and thus with 4.18) I get 
> random illegal instruction warnings from 32bit code inside VMs. I do 
> not know at this point whether this affects other CPUs as well.
>
> If anyone is interested in a reproducer, I have something handy. But 
> for now I believe we should just revert this patch.

Ok, I'm slightly confused. The patch in question is already upstream 
since 4.16, but the regression reportedly came with the switch from 4.17 
to 4.18. I'll try to bisect it down a bit further ...


Alex
