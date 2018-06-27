From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 4/6] KVM: arm/arm64: Consolidate page-table accessors
Date: Wed, 27 Jun 2018 15:53:45 +0100
Message-ID: <38b5b90d-131f-ebd2-7a0f-491b92cf9f38@arm.com>
References: <20180627122058.8210-1-marc.zyngier@arm.com>
 <20180627122058.8210-5-marc.zyngier@arm.com>
 <0afbb729-d801-1563-a319-4d3e3d6ac6a9@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <0afbb729-d801-1563-a319-4d3e3d6ac6a9@arm.com>
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
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 27/06/18 14:59, Suzuki K Poulose wrote:
> Marc,
> 
> On 27/06/18 13:20, Marc Zyngier wrote:
>> The arm and arm64 KVM page tables accessors are pointlessly different
>> between the two architectures, and likely both wrong one way or another:
>> arm64 lacks a dsb(), and arm doesn't use WRITE_ONCE.
>>
>> Let's unify them.
> 
> nit: Feel free to ignore. The changes introducing kvm_p.d_populate
> is not mentioned in the commit description and they do look a bit
> disconnected from the change described above.

That's a good point. I've moved those into patch #5, where they make
much more sense.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
