From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 1/2] arm/arm64: KVM: Detect vGIC presence at runtime
Date: Thu, 21 Apr 2016 23:41:04 +0100
Message-ID: <CAFEAcA8x4-u_eONVYN9NptNwYoNnJW3WM_m2z3T0ArJ8auXSkQ@mail.gmail.com>
References: <cover.1448874023.git.p.fedin@samsung.com> <f759b4ba37d4cacdc971d2a416cdc8ecf0c3c3d9.1448874023.git.p.fedin@samsung.com>
 <57194919.5080007@suse.de> <CAFEAcA-SK3ZEcF13Zd74DCWRBBkiuz87U2roLaeujZBDu6DVTQ@mail.gmail.com>
 <571955CA.6030503@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <571955CA.6030503@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 21 April 2016 at 23:35, Alexander Graf <agraf@suse.de> wrote:
> It might make sense to have a generic "system register couldn't get
> handled" exit code anyway. If nothing else, at least to display
> unhandled registers in the qemu context where they appear rather than in
> the kernel log (which a guest could deliberately clutter as it stands
> today).

Unhandled sysregs UNDEF so they get logged by the guest if anywhere,
I think.

thanks
-- PMM
