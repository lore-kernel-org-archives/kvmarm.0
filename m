From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: Enable minimalistic support for Thunder
Date: Mon, 29 Jun 2015 18:11:13 +0100
Message-ID: <55917C31.4060107@arm.com>
References: <1435348284-32132-1-git-send-email-tchalamarla@caviumnetworks.com>
 <55910794.6000107@arm.com>
 <AED13EAB-D578-451F-AC35-A45A21816076@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00EE456A16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 13:00:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FlcuHhDg-A0o for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 13:00:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C14FE56A12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 13:00:06 -0400 (EDT)
In-Reply-To: <AED13EAB-D578-451F-AC35-A45A21816076@caviumnetworks.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
Cc: Andre Przywara <Andre.Przywara@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rrichter@cavium.com" <rrichter@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/06/15 18:06, Chalamarla, Tirumalesh wrote:
> 
>> On Jun 29, 2015, at 1:53 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>
>> On 26/06/15 20:51, Tirumalesh Chalamarla wrote:
>>> In order to allow KVM to run on Thunder implementations, add the
>>> minimal support required.
>>>
>>> Signed-off-by: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
>>
>> CCing the KVM/ARM maintainers should be the first course of action.
>>
> thanks. 
> 
>> Also, you may want to try Suzuki's patch instead:
>>
>> http://www.spinics.net/lists/kvm/msg117703.html
>>
> will try with this.
> 
>> Constantly adding new CPUs without providing any insight as to how they
>> should be emulated only brings churn, and not much benefit.
>>
> we are not planning(at this point) to emulate Thunder with QEMU/others.   

Fair enough. If cross-cpu VM migration is none of your concern, then
Suzuki's patch should be enough.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
