From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with Linus' tree
Date: Thu, 16 Apr 2015 21:39:06 +0200
Message-ID: <55300FDA.1010606@redhat.com>
References: <20150318144111.1e56c6d9@canb.auug.org.au> <20150318075537.GC23225@cbox> <552403BF.8090008@redhat.com> <20150416191044.GF6186@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20150416191044.GF6186@cbox>
Sender: linux-next-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Stephen Rothwell <sfr@canb.auug.org.au>, Marc Zyngier <marc.zyngier@arm.com>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 16/04/2015 21:10, Christoffer Dall wrote:
>> > 
> As it turns out, it was not the same logic as Stephen's resolution.
> Stephen's resolution is bussy, because vlr is passed by value to
> vgic_queue_irq_to_lr() and therefore the call to sync the elrsr does not
> have any effect.
> 
> Unfortunately, it seems Paolo's more correct fix did not end up in
> Linus' tree, so I guess I should just send a patch?

Uhm, sure it did :)

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/virt/kvm/arm/vgic.c#n1121

Stephen's resolutions never end up in Linus's tree, as Stephen never
sends anything to Linus.

Paolo
