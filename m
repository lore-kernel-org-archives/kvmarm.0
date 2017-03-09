From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 00/10] KVM/ARM fixes for 4.11-rc2
Date: Thu, 09 Mar 2017 15:52:23 +0000
Message-ID: <87a88uwiq0.fsf@on-the-bus.cambridge.arm.com>
References: <20170309095539.14512-1-marc.zyngier@arm.com>
        <20170309151652.GA3210@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170309151652.GA3210@potion> ("Radim \=\?utf-8\?B\?S3LEjW3DocWZ\?\=
 \=\?utf-8\?B\?Iidz\?\= message of "Thu,
        9 Mar 2017 16:16:52 +0100")
Sender: kvm-owner@vger.kernel.org
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <cdall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>, Linu Cherian <linu.cherian@cavium.com>, Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 09 2017 at  3:16:52 pm GMT, Radim Krčmář <rkrcmar@redhat.com> wrote:
> 2017-03-09 09:55+0000, Marc Zyngier:
>> Paolo, Radim,
>> 
>> Here's the KVM/ARM updates for 4.11-rc2. The usual bag of vgic
>> updates, making the memslot array large enough to handle guests with
>> tons of devices assigned to them, a tidying up of exception handling,
>> and a rather annoying TLB handling issue on VHE systems.
>
> Pulled, but what made you change the GPG key into a revoked one?
>
>   # gpg: Signature made Thu 09 Mar 2017 10:36:07 AM CET
>   # gpg:                using RSA key AB309C74B93B1EA1
>   # gpg: Good signature from "Marc Zyngier <marc.zyngier@arm.com>"
>   # gpg: WARNING: This key has been revoked by its owner!
>   # gpg:          This could mean that the signature is forged.
>   # gpg: reason for revocation: Key has been compromised
>   # gpg: revocation comment: Revoked after kernel.org hacking
>   # Primary key fingerprint: 6958 C9F2 233C 5E9D 6CCA  818A AB30 9C74 B93B 1EA1

Gahhh... New laptop, keyring restored from a backup containing the
revoked key, gpg-agent picking the revoked key as a default, idiot
sitting behind the keyboard not paying attention :-(. Now fixed.

Sorry about that.

	M.
-- 
Jazz is not dead, it just smell funny.
