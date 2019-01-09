From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [kvmarm:kvm-arm64/nv-wip-v5.0-rc1 4/75]
 arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:700:7: error:
 'SYS_CNTP_TVAL_EL0' undeclared
Date: Wed, 9 Jan 2019 10:09:51 +0000
Message-ID: <8fd0977c-9ca1-8ad8-a6b7-e36e115745b8@arm.com>
References: <201901091219.igdmvhpC%fengguang.wu@intel.com>
 <a82a7868-f3c0-0b3e-d0b7-182992c268fa@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E44624A439
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 05:09:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a5ofVl-sampY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jan 2019 05:09:54 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BF6D4A3E1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 05:09:54 -0500 (EST)
In-Reply-To: <a82a7868-f3c0-0b3e-d0b7-182992c268fa@arm.com>
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
To: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/01/2019 09:13, Andr=E9 Przywara wrote:
> On 09/01/2019 04:40, kbuild test robot wrote:
> =

> Marc, Christoffer,
> =

>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.gi=
t kvm-arm64/nv-wip-v5.0-rc1
>> head:   688c386ca096f2c1f2eee386697586c88df5d5bc
>> commit: 2b1265c58a873d917e99ac762e243c1274481dbf [4/75] KVM: arm/arm64: =
consolidate arch timer trap handlers
>> config: arm-axm55xx_defconfig (attached as .config)
>> compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
>> reproduce:
>>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sb=
in/make.cross -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         git checkout 2b1265c58a873d917e99ac762e243c1274481dbf
>>         # save the attached .config to linux build tree
>>         GCC_VERSION=3D7.2.0 make.cross ARCH=3Darm =

>>
>> All errors (new ones prefixed by >>):
> =

> I was looking at this yesterday: It's a bit nasty, don't know a good
> solution beside bringing back this part of my original timer rework serie=
s.
> The problem is that those symbols contains the Aarch64 specific
> (instruction) encoding of the timer registers, plus we need the AArch32
> encodings for 32-on-64 guests.

Why? There is exactly one timer that needs trapping for AArch32 (the EL1
physical timer). All we need is:

- the SYS_AARCH32_CNTP_* encodings on 32bit
- some CPP magic to prevent the compilation from breaking

> =

> That's why I used the generic UAPI encoding for the registers, because
> we only need *some* identification for them, it doesn't need to be
> something defined by the architecture.

I disagree. By doing so, you're conflating userspace access and
trapping, which has proved to be a bad idea in the past. For example,
you'd end-up having both CVAL and TVAL in UAPI, which is not something
I'm keen to have. On the other hand, the trapping function do need to be
able to handle these.

Thanks,

	M.
-- =

Jazz is not dead. It just smells funny...
