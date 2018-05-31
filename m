From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 2/6] arm64: KVM: Handle Set/Way CMOs as NOPs if FWB is
 present
Date: Thu, 31 May 2018 14:00:11 +0100
Message-ID: <83a4edd3-abea-b6c4-9513-3705cc92b52b@arm.com>
References: <20180530124706.25284-1-marc.zyngier@arm.com>
 <20180530124706.25284-3-marc.zyngier@arm.com>
 <20180531115127.2ymmtlwemz6g5qzj@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180531115127.2ymmtlwemz6g5qzj@lakrids.cambridge.arm.com>
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
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 31/05/18 12:51, Mark Rutland wrote:
> On Wed, May 30, 2018 at 01:47:02PM +0100, Marc Zyngier wrote:
>> Set/Way handling is one of the ugliest corners of KVM. We shouldn't
>> have to handle that, but better safe than sorry.
>>
>> Thankfully, FWB fixes this for us by not requiering any maintenance
>> whatsoever, which means we don't have to emulate S/W CMOs, and don't
>> have to track VM ops either.
>>
>> We still have to trap S/W though, if only to prevent the guest from
>> doing something bad.
> 
> S/W ops *also* do I-cache maintenance, so we'd still need to emulate
> that. Though it looks like we're missing that today...

This doesn't look right: CSSELR_EL1 does indeed have an InD bit, but
that's only for the purpose of reading CSSIDR_EL1. DC CSW and co
directly take a level *without* the InD bit, and seem to be limited to
"data and unified cache".

Am I missing something?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
