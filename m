From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 1/5] KVM: arm/arm64: Refactor vGIC attributes handling
 code
Date: Fri, 4 Sep 2015 16:16:35 +0100
Message-ID: <55E9B5D3.4020200@arm.com>
References: <cover.1441180858.git.p.fedin@samsung.com>
 <f92e6d50897d2eb9e48dc91c0264e9409a50bc41.1441180858.git.p.fedin@samsung.com>
 <55E9968C.9010703@arm.com> <022701d0e723$f6bf7b00$e43e7100$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <022701d0e723$f6bf7b00$e43e7100$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 04/09/15 16:11, Pavel Fedin wrote:
>  Hello!
> 
>> Isn't the len parameter redundant here? I see that you don't initialize
>> mmio.len (which is a bit scary, btw), so can't you just use that field?
> 
>  This was because of split below. I did not know about call_range_handler(), and now i will redo
> this.
> 
>> That (and other parts of this patch) sneak in some endianness handling,
>> which I'd like to be mentioned in the commit message, but preferably be
>> in a separate patch. The commit message here talks only about refactoring.
> 
>  These come from mmio_data_read() and mmio_data_write() in original vgic_attr_regs_access().
> These inlines cannot be used with arbitrary data length, so i opened them up (they contain
> endianness conversion plus masking which isn't used in our case) and moved endianness conversion to
> load/store part.
>  If i make this a separate patch, it will be two lines patch. Does it worth that? In the next respin
> i'd better add this explanation to commit message. Would it be OK?

>From a review (and later bisecting) point of view separate patches would
be better. Ideally the refactoring does not introduce any change except
code moving around.

Cheers,
Andre.
