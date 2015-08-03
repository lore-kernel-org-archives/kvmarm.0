From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 14/15] KVM: arm64: implement MSI injection in ITS emulation
Date: Mon, 03 Aug 2015 11:07:29 +0200
Message-ID: <55BF2F51.6020701@linaro.org>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com> <1436538111-4294-15-git-send-email-andre.przywara@arm.com> <55BB7678.5080105@linaro.org> <55BE7BA1.40403@arm.com> <00a201d0cdb7$70a623f0$51f26bd0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00a201d0cdb7$70a623f0$51f26bd0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, 'Andre Przywara' <andre.przywara@arm.com>, 'Marc Zyngier' <Marc.Zyngier@arm.com>, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre, Pavel,
On 08/03/2015 08:41 AM, Pavel Fedin wrote:
>  Hi!
> 
>> When I reworked our code to only use a flag and not a separate routing
>> type I ended up with the flag only guarding assignments, which wouldn't
>> hurt if done unconditionally (since they are all u32's). So the whole
>> usage of the flag is somewhat in jeopardy now.
>> Either the eventual MSI consumer requires a DevID (ITS emulation, which
>> will not work without it) or the consumer does not care at all and can
>> totally ignore it (GICv2m). So I think we can always pass on the DevID
> 
>  I have just checked my current code, and you know what... You are right. We already have a per-VM
> capability which actually tells us that MSIs for this VM require devID. Therefore, we really don't
> need this flag at all, neither for MSI doorbell, nor for GSI routing.
>  All we need is 'devid' field, which indeed can be just ignored for GICv2(m), just for simplicity.
> Ignoring would happen automatically, because IIRC older kernels do not explicitly check 'pad' for
> being zero, do they? And indeed in this case the userland can supply devid unconditionally, making
> things even simpler.

Again the case that leaves me uncomfortable is the one where the
userspace does not provide the devid whereas it must (GICv3 ITS case).
We cannot be confident in userspace to behave correctly. In such a case
devid == 0 and we cannot discriminate this from a valid devid. Do I miss
something?

Best Regards

Eric
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

