From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] arm64: Add workaround for Cavium erratum 26026
Date: Fri, 5 Aug 2016 09:37:39 -0700
Message-ID: <57A4C0D3.2060408@caviumnetworks.com>
References: <1470302117-32296-1-git-send-email-mbrugger@suse.com>
 <20160804205707.GJ2151@rric.localdomain> <57A3B660.4040309@gmail.com>
 <20160805070030.GQ22012@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20160805070030.GQ22012@rric.localdomain>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Robert Richter <robert.richter@cavium.com>
Cc: mark.rutland@arm.com, Matthias Brugger <mbrugger@suse.com>, christoffer.dall@linaro.org, david.daney@cavium.com, kvm@vger.kernel.org, suzuki.poulose@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, rkrcmar@redhat.com, will.deacon@arm.com, linux@armlinux.org.uk, agraf@suse.de, ard.biesheuvel@linaro.org, lorenzo.pieralisi@arm.com, james.morse@arm.com, dave.long@linaro.org, zlim.lnx@gmail.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/05/2016 12:00 AM, Robert Richter wrote:
> On 04.08.16 14:40:48, David Daney wrote:
>> On 08/04/2016 01:57 PM, Robert Richter wrote:
>>> The patch below is on top of Matthias' patch series:
>>>
>>>   arm64: Implement IPI based TLB invalidation
>>>
>>> The series is used to enable a workaround for Cavium ThunderX pass 1.x
>>> systems.
>>
>>
>> Where are the rest of the patches in the series?  I would have expected
>> something like "[PATCH 1/X] arm64:..." with X being greater than one.
>
> You are cc'ed here too:
>
>   https://lkml.org/lkml/2016/8/4/101
>

OK, I got confused by the fact that this patch was retroactively added 
to the patch set and was missing the sequence numbering.

> -Robert
>
