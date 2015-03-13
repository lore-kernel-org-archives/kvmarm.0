From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: fix missing unlock on error in
 kvm_vgic_create()
Date: Fri, 13 Mar 2015 10:24:21 +0000
Message-ID: <5502BAD5.3040004@arm.com>
References: <1425037305-23292-1-git-send-email-weiyj_lk@163.com>
 <20150302172947.GC10137@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D500E4883A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 06:18:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jXeQLv1Zcu8L for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Mar 2015 06:18:17 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 300DD487E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 06:18:16 -0400 (EDT)
In-Reply-To: <20150302172947.GC10137@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, weiyj_lk@163.com
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Gleb Natapov <gleb@kernel.org>, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hej Christoffer,

On 02/03/15 17:29, Christoffer Dall wrote:
> On Fri, Feb 27, 2015 at 07:41:45PM +0800, weiyj_lk@163.com wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Add the missing unlock before return from function kvm_vgic_create()
>> in the error handling case.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Thanks, applied.

Have I missed this or is this patch nor appearing in any of your branches?

Cheers,
Andre.
