From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Correctly handle zero register in system
 register accesses
Date: Thu, 03 Dec 2015 13:12:38 +0000
Message-ID: <56603FC6.20200@arm.com>
References: <cover.1449136209.git.p.fedin@samsung.com> <fff7d3cedc4d6ac0c81b089a4b2d7a992c83fb80.1449136209.git.p.fedin@samsung.com> <56601E36.5070700@arm.com> <00cd01d12dba$f14ac070$d3e04150$@samsung.com> <56602951.1040305@arm.com> <00e001d12dc1$812a34e0$837e9ea0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00e001d12dc1$812a34e0$837e9ea0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/12/15 11:55, Pavel Fedin wrote:
>  Hello!
> 
>>> It's simply more convenient to use a pointer for exchange with
>>> userspace, see vgic_v3_cpu_regs_access() and callers. I wouldn't like
>>> to refactor the code again. What's your opinion on this?
>>
>> I still don't think this is a good idea. You can still store the value
>> as an integer in vgic_v3_cpu_regs_access(), and check the write property
>> to do the writeback on read. Which is the same thing I asked for in this
>> patch.
> 
>  Started doing this and found one more (big) reason against. All sysreg handlers have 'const struct sys_reg_params' declaration, and
> callers, and their callers... This 'const' is all around the code, and it would take a separate huge patch to un-const'ify all this.
> Does it worth that?

maz@approximate:~/Work/arm-platforms$ git diff --stat
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++------------------
 arch/arm64/kvm/sys_regs.h |  2 +-
 2 files changed, 19 insertions(+), 19 deletions(-)

Hardly a big deal... You can have that as a separate patch.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
