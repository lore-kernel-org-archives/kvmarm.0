From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] arm64: KVM: Turn kvm_ksym_ref into a NOP on VHE
Date: Mon, 21 Mar 2016 13:36:10 +0100
Message-ID: <56EFEABA.3010604@redhat.com>
References: <1458321959-11728-1-git-send-email-marc.zyngier@arm.com>
 <CAKv+Gu_at5LXa5jxpM7h=ntxdJNNqmbtVE-bWn3SicMMMuT6Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_at5LXa5jxpM7h=ntxdJNNqmbtVE-bWn3SicMMMuT6Dg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 21/03/2016 09:47, Ard Biesheuvel wrote:
> On 18 March 2016 at 18:25, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> When running with VHE, there is no need to translate kernel pointers
>> to the EL2 memory space, since we're already there (and we have a much
>> saner memory map to start with).
>>
>> Unfortunately, kvm_ksym_ref is getting in the way, and the first
>> call into the "hypervisor" section is going to end up in fireworks,
>> since we're now branching into nowhereland. Meh.
>>
>> A potential solution is to test if VHE is engaged or not, and only
>> perform the translation in the negative case. With this in place,
>> VHE is able to run again.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> I think you need the & when initializing val, otherwise, it will
> silently refer to the value rather than the address of a void* symbol
> if we ever end up using this macro on one.
> 
> That was the whoie point of the opaque struct type in the original
> patch that introduced this macro, to disallow references lacking the
> &, but unfortunately, that was incompatible with the other VHE
> changes.
> 
> With that fixed
> 
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Marc, if you send a v2 I can merge it directly without a pull request.

Paolo
