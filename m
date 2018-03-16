From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v6 06/26] KVM: arm/arm64: Do not use kern_hyp_va() with
 kvm_vgic_global_state
Date: Fri, 16 Mar 2018 11:38:48 +0000
Message-ID: <CAKv+Gu-gtGQj8YzEEawqykzYeqJXTKKjm8CN5t6ovcdaz4vUtQ@mail.gmail.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-7-marc.zyngier@arm.com>
 <5AAAC67E.4010002@arm.com> <98ec10c0-73a3-db00-b78b-2777c0874968@arm.com>
 <20180316113507.apyvlsvekvjm36ix@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180316113507.apyvlsvekvjm36ix@kamzik.brq.redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Jones <drjones@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, Steve Capper <steve.capper@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, James Morse <james.morse@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16 March 2018 at 11:35, Andrew Jones <drjones@redhat.com> wrote:
> On Fri, Mar 16, 2018 at 09:31:57AM +0000, Marc Zyngier wrote:
>> On 15/03/18 19:16, James Morse wrote:
>> >
>> > (I had a go at using 'Ush', to let the compiler schedule the adrp, but couldn't
>> > get it to work.)
>>
>> I tried that as well at some point, but couldn't see how to use it. The
>> compiler was never happy with my use of the constraints, so I gave up
>> and did it my way...
>>
>
> What's 'Ush'? I tried to search for it, but came up short. I'm wondering
> what things I can try (and fail) to use it on too :-)
>

https://gcc.gnu.org/onlinedocs/gccint/Machine-Constraints.html
