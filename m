From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 0/2] KVM: arm/arm64: Clean up some obsolete code
Date: Thu, 08 Oct 2015 14:36:08 +0300
Message-ID: <008a01d101bd$86d0c290$947247b0$@samsung.com>
References: <cover.1443796321.git.p.fedin@samsung.com>
 <20151008101408.GA20936@cbox> <56164BC4.80104@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <56164BC4.80104@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I don't mind the simplification (Andre was already removing the
> piggybacking stuff as part of his ITS series). I'm a bit more cautiou=
s
> about the sync_elrsr stuff, but that's mostly because I've only read =
the
> patch in a superficial way.

 If you are really afraid of it, you can omit 2/2. The reason why i've =
done it is exactly what i
said in commit message - LR setting and ELRSR sync *always* go together=
=2E
 The main part of the cleanup is 1/2.

> But yes, this is probably going to clash, unless we make this part of=
 an
> existing series (/me looks at Andr=E9... ;-)

 It a little bit clashes, patch No 0012 needs small modifications, but =
i'd say they are trivial. If
you want, i could rebase the whole thing on top of current kvmarm.git b=
y myself.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


