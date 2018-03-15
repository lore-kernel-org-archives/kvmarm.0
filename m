From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] KVM: arm: reserve bit in KVM_REG_ARM encoding for
 secure/nonsecure
Date: Thu, 15 Mar 2018 18:48:45 +0000
Message-ID: <6591fb85-0e7c-3ab9-b613-13ddc7d03746@arm.com>
References: <20180306194741.30395-1-peter.maydell@linaro.org>
 <CAFEAcA-p-N6eF4LpDVfXOM4niBZTEyZi+Xg6RnjM7a5RQk+WCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAFEAcA-p-N6eF4LpDVfXOM4niBZTEyZi+Xg6RnjM7a5RQk+WCw@mail.gmail.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Peter Maydell <peter.maydell@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, Christoffer Dall <cdall@kernel.org>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 15/03/18 17:57, Peter Maydell wrote:
> On 6 March 2018 at 19:47, Peter Maydell <peter.maydell@linaro.org> wrote:
>> We have a KVM_REG_ARM encoding that we use to expose KVM guest registers
>> to userspace. Define that bit 28 in this encoding indicates secure vs
>> nonsecure, so we can distinguish the secure and nonsecure banked versions
>> of a banked AArch32 register.
>>
>> For KVM currently, all guest registers are nonsecure, but defining
>> the bit is useful for userspace. In particular, QEMU uses this
>> encoding as part of its on-the-wire migration format, and needs to be
>> able to describe secure-bank registers when it is migrating (fully
>> emulated) EL3-enabled CPUs.
>>
>> Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
>> ---
>> v1->v2: expanded comment
> 
> Ping -- is this version OK, Marc?

Sorry, I thought I had replied.

Yup, this looks good to me. I start building the patch queue tomorrow,
and this will likely be the first patch.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
