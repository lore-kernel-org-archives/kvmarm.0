From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v9 0/6] KVM: arm/arm64: gsi routing support
Date: Mon, 25 Jul 2016 09:22:41 +0200
Message-ID: <ca233656-593e-6118-52f1-263363f99607@redhat.com>
References: <1469204442-3220-1-git-send-email-eric.auger@redhat.com>
 <20160722171354.GC11512@potion> <57925900.8020104@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <57925900.8020104@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Radim, Marc,
On 22/07/2016 19:33, Marc Zyngier wrote:
> On 22/07/16 18:13, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>> 2016-07-22 16:20+0000, Eric Auger:
>>> With the advent of GICv3 ITS in-kernel emulation, KVM MSI routing
>>> becomes mandated for proper VIRTIO-PCI vhost integration.
>>
>> Changes to interfaces and common code look ok,
>>
>> Acked-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>=20
> I'll let it sink into -next for a few days, so that I can rerun my
> non-reg stuff, and will send another PR if everything turns green.
>=20
> Thanks you both for the quick turnaround!
Thank you for your support!

Eric
>=20
> 	M.
>=20
