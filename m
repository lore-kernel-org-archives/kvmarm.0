From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 1/5] arm: KVM: export vcpi->pause state via MP_STATE ioctls
Date: Tue, 10 Mar 2015 04:55:29 +0900
Message-ID: <CAFEAcA_43_2Qi2e8c9PKN4gMSM30-r4CeNWDzrJ6-odaaU3HNw@mail.gmail.com>
References: <1425302944-6276-1-git-send-email-alex.bennee@linaro.org>
 <1425302944-6276-2-git-send-email-alex.bennee@linaro.org> <20150309135055.GC20559@cbox>
 <87pp8ib04y.fsf@linaro.org> <20150309192942.GF20559@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150309192942.GF20559@cbox>
Sender: linux-doc-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Russell King <linux@arm.linux.org.uk>, kvm-devel <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <marc.zyngier@arm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 10 March 2015 at 04:29, Christoffer Dall <christoffer.dall@linaro.or=
g> wrote:
> On Mon, Mar 09, 2015 at 04:34:21PM +0000, Alex Benn=C3=A9e wrote:
>> - Boot
>> - Power on secondary CPUs
>> - Power off one secondary CPU
>> - Migrate to file (cpu_powered reflects state of each CPU)
>>
>> - Start fresh QEMU
>> - Restore from file (cpu_powered -> vcpu->paused via ioctl)
>> - Run (we continue with the same power state pre-migrate)
>>
>> - PSCI RESET
>> - Does what it does, power all secondaries down?
>> - Kernel boots, turns them on?
>>
> Hmmm. As long as QEMU always inits all VCPUs in the exact same way
> (including the KVM_ARM_VCPU_POWER_OFF feature bit) I guess it works a=
nd
> that's probably a reasonable requirement for migration.

We init the VCPUs with the POWER_OFF flag set for exactly the
set of CPUs that we want to start powered off. Typically that
means that the first CPU is inited with POWER_OFF clear and the
rest are inited with it set.

Regardless, if we're doing an incoming migration, then the
incoming data will be used to set the VCPU on/off state
appropriately for resuming the VM. (This might include
powering on a VCPU that's been inited in power-off and never
run, or powering down a VCPU that was inited power-on but
never ran. In the 'migration moves a vcpu to powered-on'
case we'll also set the vcpu's PC and other registers so
when it is run it will DTRT.)

If the resumed guest subsequently does a PSCI reset then
QEMU will re-init the VCPUs with the set of feature bits that
the machine model/etc defines for a reset condition for this
board, which will be the same "first CPU powered on, all the
rest powered off" config we started with.

(It's the user's responsibility to ensure that when doing a
migration the QEMUs at both ends are identically configured,
incidentally.)

-- PMM
